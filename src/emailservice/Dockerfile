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

COPY cpanfile cpanfile.snapshot .

RUN cpm install --global

# # Uncomment following lines to install from submodules
# # Install dev version of API
# COPY ./api/ /tmp/api/
# RUN cpanm --verbose /tmp/api
#
# # Install dev version of SDK
# COPY ./sdk/ /tmp/sdk/
# RUN cpanm --verbose /tmp/sdk
#
# Install dev version of OTLP exporter
# COPY ./otlp/ /tmp/otlp/
# RUN cpanm --verbose /tmp/otlp
#
# RUN rm -rf /tmp/api /tmp/sdk /tmp/otlp

FROM builder as release

WORKDIR /email_server

COPY email_server .
COPY templates templates

EXPOSE ${EMAIL_SERVICE_PORT}

ENTRYPOINT ["morbo", "email_server"]
