docker rm -f derp-aio

docker run -d \
--name derp-aio \
-v /dev/net/tun:/dev/net/tun \
-v $(pwd)/tailscale_data:/var/lib/tailscale \
-v $(pwd)/log/derper/:/var/log/derper/ \
-v $(pwd)/log/tailscaled/:/var/log/tailscaled/ \
--cap-add=NET_ADMIN \
--cap-add=NET_RAW \
--cap-add=SYS_MODULE \
--sysctl net.ipv4.ip_forward=1 \
--sysctl net.ipv6.conf.all.forwarding=1 \
-e DERP_DOMAIN=derp.example.com \
-e DERP_ADDR=:18443 \
-e DERP_STUN_PORT=19443 \
--restart unless-stopped \
derp-aio 