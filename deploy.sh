docker run -d \
  --name derp-moyu \
  -e "DERP_DOMAIN=derp-moyu.nb2.markxu.vip" \
  -e "DERP_CERT_MODE=manual" \
  -e "DERP_CERT_DIR=/app/certs" \
  -e "DERP_ADDR=:18443" \
  -e "DERP_STUN_PORT=13478" \
  -e "DERP_VERIFY_CLIENTS=true" \
  -p 11880:11880 \
  -p 18443:18443 \
  -p 3478:3478/udp \
  -v /etc/letsencrypt/live/derp-moyu.nb2.markxu.vip/:/app/certs/ \
  --restart unless-stopped \
  xubiaolin/derp-docker:latest