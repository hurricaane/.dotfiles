#!/bin/bash
if systemctl status upower.service &>/dev/null; then
	percentage=$(upower -i "$(upower -e | grep BAT)" | grep --color=never -E "percentage" | awk '{print $2}' | tr -d '%')
  state=$(upower -i "$(upower -e | grep BAT)" | grep --color=never -E "state" | awk '{print $2}')
elif command -v powershell.exe &>/dev/null; then
	percentage=$(powershell.exe -command "Get-CimInstance -ClassName Win32_Battery | Measure-Object -Property EstimatedChargeRemaining -Average | Select-Object -ExpandProperty Average")
else
	echo "Battery Status Unknown"
	exit 1
fi

if [ "$state" = "charging" ]; then
	echo "󰚥"
elif [ "$percentage" -ge 90 ]; then
	echo "󰁹"
elif [ "$percentage" -ge 80 ]; then
	echo "󰁹"
elif [ "$percentage" -ge 70 ]; then
	echo "󰂁"
elif [ "$percentage" -ge 60 ]; then
	echo "󰁿"
elif [ "$percentage" -ge 50 ]; then
	echo "󰁾"
elif [ "$percentage" -ge 40 ]; then
	echo "󰁽"
elif [ "$percentage" -ge 30 ]; then
	echo "󰁼"
elif [ "$percentage" -ge 20 ]; then
	echo "󰁻"
elif [ "$percentage" -ge 10 ]; then
	echo "󰁺"
else
	echo " " # Case for WSL2
fi
