#!/bin/bash
if systemctl status upower.service &>/dev/null; then
	upower -i "$(upower -e | grep BAT)" | grep --color=never -E "percentage" | awk '{print $2}' | tr -d '%'
elif command -v powershell.exe &>/dev/null; then
	bat_percentage=$(powershell.exe -command "Get-CimInstance -ClassName Win32_Battery | Measure-Object -Property EstimatedChargeRemaining -Average | Select-Object -ExpandProperty Average")
	echo "$bat_percentage"
else
	echo "Battery Status Unknown"
	exit 1
fi
