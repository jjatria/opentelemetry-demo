package Mojolicious::Plugin::OpenTelemetry;

our $VERSION = '0.001';

use Mojo::Base 'Mojolicious::Plugin', -signatures;
use Feature::Compat::Try;
use OpenTelemetry -all;
use OpenTelemetry::Constants -span;
use Syntax::Keyword::Dynamically;

sub register ( $, $app, $config ) {
    $config->{tracer}{name} //= otel_config('SERVICE_NAME') // $app->moniker;

    $app->hook( around_dispatch => sub ( $next, $ ) {
        try {
            $next->();
        }
        catch ($error) {
            my ($message) = split /\n/, "$error", 2;
            $message =~ s/ at \S+ line \d+\.$//a;

            otel_span_from_context
                ->record_exception($error)
                ->set_attribute( 'http.status_code' => 500 )
                ->set_status( SPAN_STATUS_ERROR, $message )
                ->end;

            die $error;
        }
    });

    $app->hook( around_action  => sub ( $next, $c, $, $ ) {
        my $tracer = otel_tracer_provider->tracer( %{ $config->{tracer} } );

        my $req    = $c->tx->req;
        my $url    = $req->url;
        my $route  = $url->path->to_string;
        my $method = $req->method;

        my $context = otel_propagator->extract(
            $req->headers->to_hash,
            undef,
            sub ( $carrier, $key ) { $carrier->{ ucfirst $key } },
        );

        dynamically otel_current_context = $context;

        $tracer->in_span(
            $method . ' ' . $route => (
                kind       => SPAN_KIND_SERVER,
                attributes => {
                    'component'   => 'http',
                    'http.method' => $method,
                    'http.route'  => $route,
                    'http.url'    => "$url",
                },
            ),
            sub ( $span, $context ) {
                $next->();

                $span
                    ->set_status( SPAN_STATUS_OK )
                    ->set_attribute( 'http.status_code' => $c->tx->res->code );
            },
        );
    });
}

1;
