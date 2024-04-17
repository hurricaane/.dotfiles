#!/bin/bash
wifi=""

if command -v iwgetid &>/dev/null; then
	wifi=$(iwgetid -r)
elif command -v wsl &>/dev/null; then
	wifi=$(wsl powershell -command "& {Get-NetConnectionProfile | Select-Object -ExpandProperty SSID}")
fi

if [ -n "$wifi" ]; then
  if [[ "$wifi" == "_SNCF_WIFI_INTERCITES" ]]; then
    wifi="SNCF"
  fi
	echo "$wifi"
else
	echo "No Active Wifi"
fi
