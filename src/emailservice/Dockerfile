# Copyright The OpenTelemetry Authors
# SPDX-License-Identifier: Apache-2.0

FROM perl:5.38 as base

# For OTLP exporter
RUN apt-get update \
 && apt-get install --no-install-recommends --yes g++ cmake libprotobuf-dev libprotoc-dev \
 && rm -rf /var/lib/apt/lists/*

RUN cpm install --global Carton

FROM base AS builder

WORKDIR /tmp

COPY cpanfile cpanfile.snapshot .

RUN cpm install --global

# Install OpenTelemetry from repo for now, from CPAN later
RUN cpanm --installdeps --notest --quiet https://github.com/jjatria/perl-opentelemetry.git

COPY ./api/ /tmp/api/

RUN cpanm --verbose /tmp/api \
 && cpanm --installdeps --notest --quiet https://github.com/jjatria/perl-opentelemetry-sdk.git

COPY ./sdk/ /tmp/sdk/

RUN cpanm --verbose /tmp/sdk \
 && cpanm --installdeps --notest --quiet https://github.com/jjatria/perl-opentelemetry-exporter-otlp.git

COPY ./otlp/ /tmp/otlp/

RUN cpanm --verbose /tmp/otlp

RUN rm -rf /tmp/api /tmp/sdk /tmp/otlp

FROM builder as release

WORKDIR /email_server

COPY email_server .
COPY templates templates

EXPOSE ${EMAIL_SERVICE_PORT}

ENTRYPOINT ["morbo", "email_server"]
