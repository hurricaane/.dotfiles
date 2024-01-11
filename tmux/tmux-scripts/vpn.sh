#!/bin/bash
vpn=""
if command -v nmcli &>/dev/null; then
	vpn=$(nmcli -f NAME,TYPE con show --active | grep --color=never -i "vpn" | awk '{print $1}')
fi

if [ -n "$vpn" ]; then
	echo "$vpn"
else
	echo "No Active VPN"
fi
