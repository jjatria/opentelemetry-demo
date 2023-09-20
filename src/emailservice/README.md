# Email Service

The Email service "sends" an email to the customer with their order details by
rendering it as a log message. It expects a JSON payload like:

```json
{
  "email": "some.address@website.com",
  "order": "<serialized order protobuf>"
}
```

## Local Build

We use `carton` to manage dependencies. To get started, simply `carton install`,
or run `make snapshot`.

## Running locally

You may run this service locally with `morbo email_server`, or `make` to run
inside a container.

## Docker Build

From `src/emailservice`, run `docker build .` or `make build`.
