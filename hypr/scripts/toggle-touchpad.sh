#!/bin/bash
STATE_FILE="/tmp/touchpad-disabled"

if [ -f "$STATE_FILE" ]; then
  hyprctl keyword device[syna30be:00-06cb:ce09-1]:enabled true
  hyprctl keyword device[syna30be:00-06cb:ce09-2]:enabled true
  rm "$STATE_FILE"
  notify-send "Touchpad" "Enabled"
else
  hyprctl keyword device[syna30be:00-06cb:ce09-1]:enabled false
  hyprctl keyword device[syna30be:00-06cb:ce09-2]:enabled false
  touch "$STATE_FILE"
  notify-send "Touchpad" "Disabled"
fi
