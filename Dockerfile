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

COPY start.sh .

ENV DERP_CERT_MODE=manual
ENV DERP_CERT_DIR=/app/certs
ENV DERP_DOMAIN=derp.example.com
ENV DERP_ADDR=:18443
ENV DERP_STUN=19302
ENV DERP_STUN_PORT=443
ENV DERP_HTTP_PORT=80
ENV DERP_VERIFY_CLIENTS=false
ENV DERP_VERIFY_CLIENT_URL=""

RUN apt-get update && \
    apt-get install -y --no-install-recommends apt-utils iptables iproute2 curl supervisor&& \
    apt-get install -y ca-certificates && \
    curl -fsSL https://tailscale.com/install.sh | sh &&\
    mkdir -p /app/certs

COPY supervisor/derper.conf /etc/supervisor/conf.d/derper.conf
COPY supervisor/tailscaled.conf /etc/supervisor/conf.d/tailscaled.conf

# CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf", "-n"]
CMD ["/app/start.sh"]