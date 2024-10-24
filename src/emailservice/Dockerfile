# Copyright The OpenTelemetry Authors
# SPDX-License-Identifier: Apache-2.0

FROM perl:5.38 as base

# For OTLP exporter
RUN apt-get update \
 && apt-get install --no-install-recommends --yes \
    g++ cmake libprotobuf-dev libprotoc-dev \
 && rm -rf /var/lib/apt/lists/*

RUN cpm install --global Carton

FROM base AS builder

WORKDIR /tmp

COPY ./src/emailservice/cpanfile ./src/emailservice/cpanfile.snapshot .

RUN cpm install --global

# # Uncomment following lines to install from submodules
# # Install dev version of API
# COPY ./src/emailservice/api/ /tmp/api/
# RUN cpanm --verbose /tmp/api
#
# # Install dev version of SDK
# COPY ./src/emailservice/sdk/ /tmp/sdk/
# RUN cpanm --verbose /tmp/sdk
#
# # Install dev version of OTLP exporter
# COPY ./src/emailservice/otlp/ /tmp/otlp/
# RUN cpanm --verbose /tmp/otlp

RUN rm -rf /tmp/api /tmp/sdk /tmp/otlp

FROM builder as release

WORKDIR /email_server

COPY ./src/emailservice/email_server .
COPY ./src/emailservice/templates templates

EXPOSE ${EMAIL_SERVICE_PORT}

ENTRYPOINT ["morbo", "email_server"]
