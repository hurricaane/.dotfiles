#!/bin/bash
if command -v upower &>/dev/null; then
	percentage=$(upower -i "$(upower -e | grep BAT)" | grep --color=never -E "percentage" | awk '{print $2}' | tr -d '%')
elif command -v wsl &>/dev/null; then
	percentage=$(wsl powershell -command "& {Get-WmiObject -Class 'BatteryStatus' -Namespace 'root/cimv2/power' | Select-Object -ExpandProperty 'EstimatedChargeRemaining'}")
else
	echo "Battery Status Unknown"
	exit 1
fi
state=$(upower -i "$(upower -e | grep BAT)" | grep --color=never -E "state" | awk '{print $2}')

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
fi
