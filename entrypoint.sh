#!/bin/bash

(
    while [ -z $(cat /proc/net/dev | awk '{i++;if(i>2)print $1}' | sed 's/[:]*$//g' | grep 'tun0') ];
    do
        sleep 3
    done
    /usr/sbin/sockd -D
) &

if [ ! -z $AUTH_USER ] && [ ! -z $AUTH_PASS ]; then
    openvpn --up /etc/openvpn/update-resolv-conf --script-security 2 --config /ovpn.conf --auth-user-pass <(echo -e $AUTH_USER"\n"$AUTH_PASS)
else
    openvpn --up /etc/openvpn/update-resolv-conf --script-security 2 --config /ovpn.conf
fi
