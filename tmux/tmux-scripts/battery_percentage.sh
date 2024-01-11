#!/bin/bash
if command -v upower &>/dev/null; then
	upower -i "$(upower -e | grep BAT)" | grep --color=never -E "percentage" | awk '{print $2}' | tr -d '%'
elif command -v wsl &>/dev/null; then
	bat_percentage=$(wsl powershell -command "& {Get-WmiObject -Class 'BatteryStatus' -Namespace 'root/cimv2/power' | Select-Object -ExpandProperty 'EstimatedChargeRemaining'}")
	echo "$bat_percentage"
else
	echo "Battery Status Unknown"
	exit 1
fi
