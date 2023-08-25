#!/bin/bash
vpn_icon='   '
vpn_name=''
vpn_prompt=''

nmcli -f NAME,TYPE con show --active | grep -i "vpn" 1>/dev/null

if [ $? -eq 0 ]; then
	vpn_name=$(nmcli -f NAME,TYPE con show --active | grep --color=never -i "vpn" | awk '{print $1}')
	vpn_prompt="${vpn_icon}${vpn_name}"
else
	vpn_prompt="No Active VPN"
fi

echo "$vpn_prompt"
