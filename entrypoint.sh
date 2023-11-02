#!/bin/bash

if [ ! -z $AUTH_USER ] && [ ! -z $AUTH_PASS ]; then
    openvpn --up /etc/openvpn/update-resolv-conf --script-security 2 --config /ovpn.conf --auth-user-pass <(echo -e $AUTH_USER"\n"$AUTH_PASS) &
else
    openvpn --up /etc/openvpn/update-resolv-conf --script-security 2 --config /ovpn.conf &
fi

sleep 10
/usr/sbin/sockd
