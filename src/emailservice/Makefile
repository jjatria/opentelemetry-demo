# Copyright The OpenTelemetry Authors
# SPDX-License-Identifier: Apache-2.0

start: build
	docker run --rm --publish 3000:3000 otel_demo_email_server

build: snapshot
	docker build --tag otel_demo_email_server .

snapshot: base
	rm -rf local/lib/perl5/OpenTelemetry* cpanfile.snapshot
	docker run --rm                                    \
		--env PERL_CPANM_HOME=/email_server/.cpanm \
		--user "$$( id -u ):$$( id -g )"           \
		--volume "${PWD}:/email_server:rw"         \
		--workdir /email_server                    \
		otel_demo_email_server_base carton install

base:
	docker build --target base --tag otel_demo_email_server_base .

clean:
	rm -rf .cpanm local
