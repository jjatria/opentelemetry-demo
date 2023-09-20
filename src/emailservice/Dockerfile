# Copyright The OpenTelemetry Authors
# SPDX-License-Identifier: Apache-2.0
FROM perl:5.38 as base

RUN cpm install --global Carton

FROM base AS builder

WORKDIR /tmp

COPY cpanfile cpanfile.snapshot .

# Install OpenTelemetry from repo for now, from CPAN later
RUN cpanm --installdeps --notest --quiet https://github.com/jjatria/perl-opentelemetry.git \
 && cpanm --verbose https://github.com/jjatria/perl-opentelemetry.git \
 && cpm install --global

FROM builder as release

WORKDIR /email_server

COPY email_server .
COPY templates templates

EXPOSE ${EMAIL_SERVICE_PORT}

ENTRYPOINT ["morbo", "email_server"]
