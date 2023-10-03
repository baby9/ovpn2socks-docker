# OpenVPN client + SOCKS proxy
# Usage:
# Create configuration (.ovpn), mount it in a volume
# docker run --volume=something.ovpn:/ovpn.conf:ro --device=/dev/net/tun --cap-add=NET_ADMIN
# Connect to (container):1080
# Note that the config must have embedded certs

FROM alpine:3.17

COPY sockd.sh /usr/local/bin/

RUN true && \
    apk add --update --no-cache dante-server openvpn bash openresolv openrc curl && \
    rm -rf /var/cache/apk/* && \
    chmod a+x /usr/local/bin/sockd.sh

COPY sockd.conf /etc/
COPY update-resolv-conf.sh /etc/openvpn/
RUN chmod +x /etc/openvpn/update-resolv-conf.sh

HEALTHCHECK --interval=90s --timeout=15s --retries=2 --start-period=120s \
	CMD curl 'https://www.cloudflare.com/cdn-cgi/trace' --interface tun0 || exit 1

EXPOSE 1080

ENTRYPOINT [ \
    "openvpn", \
    "--up", "/usr/local/bin/sockd.sh", \
    "--script-security", "2", \
    "--config", "/ovpn.conf"]
