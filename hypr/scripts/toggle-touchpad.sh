#!/bin/bash
STATE_FILE="/tmp/touchpad-disabled"

set_enabled() {
  hyprctl devices -j | jq -r '.mice[].name | select(startswith("syna30be"))' |
    while read -r dev; do
      hyprctl eval "hl.device({ name = \"$dev\", enabled = $1 })"
    done
}

if [ -f "$STATE_FILE" ]; then
  set_enabled true
  rm "$STATE_FILE"
  notify-send "Touchpad" "Enabled"
else
  set_enabled false
  touch "$STATE_FILE"
  notify-send "Touchpad" "Disabled"
fi
