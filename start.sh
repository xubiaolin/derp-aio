#!/bin/bash

echo "command=/app/derper --hostname=${DERP_DOMAIN} --certmode=${DERP_CERT_MODE} --certdir=${DERP_CERT_DIR}  --a=${DERP_ADDR}  --stun=${DERP_STUN} --stun-port=${DERP_STUN_PORT} --http-port=${DERP_HTTP_PORT} --verify-clients=${DERP_VERIFY_CLIENTS} --verify-client-url=${DERP_VERIFY_CLIENT_URL}"

cat /etc/supervisor/conf.d/derper.conf

supervisord -c /etc/supervisor/supervisord.conf -n