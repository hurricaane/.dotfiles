#!/bin/bash
icon_battery='  '
icon_charging='  '
percentage=''
battery_life=''

systemctl status upower.service 1>/dev/null

if [ $? -eq 0 ]; then
	percentage=$(upower -i $(upower -e | grep BAT) | grep --color=never -E "percentage" | awk '{print $2}')
	state=$(upower -i $(upower -e | grep BAT) | grep --color=never -E "state" | awk '{print $2}')

	if [ "$state" = "charging" ]; then
		battery_life="${icon_charging} ${percentage}"
	else
		battery_life="${icon_battery} ${percentage}"
	fi
else
	percentage=$(cat /sys/class/power_supply/BAT1/capacity)
	battery_life="${icon_battery} ${percentage}%"
fi

echo "$battery_life"
