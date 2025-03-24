docker run -d \
--name derp-aio \
-v /dev/net/tun:/dev/net/tun \
-v $(pwd)/tailscale_data:/var/lib/tailscale \
--cap-add=NET_ADMIN \
--cap-add=NET_RAW \
--cap-add=SYS_MODULE \
--sysctl net.ipv4.ip_forward=1 \
--sysctl net.ipv6.conf.all.forwarding=1 \
--restart unless-stopped \
derp-aio 