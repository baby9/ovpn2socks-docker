# OpenVPN client + SOCKS proxy
# Usage:
# Create configuration (.ovpn), mount it in a volume
# docker run --volume=something.ovpn:/ovpn.conf:ro --device=/dev/net/tun --cap-add=NET_ADMIN
# Connect to (container):1080
# Note that the config must have embedded certs

FROM alpine:3.17

RUN true && \
    apk add --no-cache openvpn bash openresolv openrc curl && \
    wget https://github.com/go-gost/gost/releases/download/v3.0.0-rc10/gost_3.0.0-rc10_linux_amd64.tar.gz -O /root/gost.tar.gz && \
    tar zxvf /root/gost.tar.gz -C /root/ && \
    mv /root/gost / && \
    rm -rf /root/* /var/cache/apk/*

COPY update-resolv-conf /etc/openvpn/
COPY entrypoint.sh /
RUN chmod +x /etc/openvpn/update-resolv-conf /gost /entrypoint.sh

HEALTHCHECK --interval=90s --timeout=15s --retries=2 --start-period=120s \
	CMD curl -fsL 'http://edge.microsoft.com/captiveportal/generate_204' --interface tun0

EXPOSE 1080

ENTRYPOINT [ "/entrypoint.sh" ]
