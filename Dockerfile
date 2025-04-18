FROM golang:alpine AS builder
WORKDIR /app

ARG DERP_VERSION=latest
RUN apk add --no-cache curl grep git && \
    echo "Using DERP version: $DERP_VERSION" && \
    go install tailscale.com/cmd/derper@${DERP_VERSION} && \
    go install tailscale.com/cmd/tailscale@${DERP_VERSION} && \
    go install tailscale.com/cmd/tailscaled@${DERP_VERSION}

FROM ubuntu
ARG DEBIAN_FRONTEND=noninteractive

LABEL maintainer="xubiaolin@markxu.vip"
LABEL description="Tailscale DERP Server"
LABEL version="1.0"

WORKDIR /app

COPY --from=builder /go/bin/derper /usr/local/bin/
COPY --from=builder /go/bin/tailscale /usr/local/bin/
COPY --from=builder /go/bin/tailscaled /usr/local/bin/

ENV DERP_DOMAIN=your-hostname.com \
    DERP_CERT_MODE=letsencrypt \
    DERP_CERT_DIR=/app/certs \
    DERP_ADDR=:443 \
    DERP_STUN=true \
    DERP_STUN_PORT=3478 \
    DERP_HTTP_PORT=80 \
    DERP_VERIFY_CLIENTS=false \
    DERP_VERIFY_CLIENT_URL=""

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    apt-utils \
    iptables \
    iproute2 \
    curl \
    supervisor \
    ca-certificates && \
    curl -fsSL https://tailscale.com/install.sh | sh && \
    mkdir -p /app/certs /var/log/derper && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY supervisor/derper.conf /etc/supervisor/conf.d/derper.conf
COPY supervisor/tailscaled.conf /etc/supervisor/conf.d/tailscaled.conf

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:${DERP_HTTP_PORT}/ || exit 1

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf", "-n"]