#!/bin/bash

items="$(bluetoothctl devices | awk '{$1=""; $2=""; print $0}' | sed -e 's/^[ \t]*//' -e 's/\ *$//g')"
device_name="$(printf "${items[@]}" | fzf --prompt=" Bluetooth Picker " --height=~50% --layout=reverse --border --exit-0)"
if [[ -z $device_name ]]; then
	echo "No Bluetooth device selected"
	return 0
else
	device_mac_address="$(bluetoothctl devices | grep "$device_name" | awk '{print $2}')"
	bluetoothctl connect "$device_mac_address"
fi
