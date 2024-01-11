#!/bin/bash
wifi=""

if command -v iwgetid &>/dev/null; then
	wifi=$(iwgetid -r)
elif command -v wsl &>/dev/null; then
	wifi=$(wsl powershell -command "& {Get-NetConnectionProfile | Select-Object -ExpandProperty SSID}")
fi

if [ -n "$wifi" ]; then
	echo "$wifi"
else
	echo "No Active Wifi"
fi
