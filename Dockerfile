FROM golang:latest AS builder
WORKDIR /app

ARG DERP_VERSION=latest
RUN go install tailscale.com/cmd/derper@${DERP_VERSION}
RUN go install tailscale.com/cmd/tailscale@${DERP_VERSION}
RUN go install tailscale.com/cmd/tailscaled@${DERP_VERSION}

FROM ubuntu
ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /app
COPY --from=builder /go/bin/derper .
COPY --from=builder /go/bin/tailscale .
COPY --from=builder /go/bin/tailscaled .

COPY supervisor/derper.conf /etc/supervisor/conf.d/derper.conf
COPY supervisor/tailscaled.conf /etc/supervisor/conf.d/tailscaled.conf

ENV DERP_CERT_MODE=manual
ENV DERP_CERT_DIR=/app/certs

RUN apt-get update && \
    apt-get install -y --no-install-recommends apt-utils iptables iproute2 curl supervisor&& \
    apt-get install -y ca-certificates && \
    curl -fsSL https://tailscale.com/install.sh | sh &&\
    mkdir /app/certs

RUN echo '#!/bin/sh\n\
    rm -f /var/run/supervisor.sock\n\
    exec supervisord -c /etc/supervisor/supervisord.conf' > /app/start.sh && \
    chmod +x /app/start.sh

CMD ["sh", "/app/start.sh"]