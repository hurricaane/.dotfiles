#!/bin/bash
# Toggle the touchpad and the pointing stick (all syna30be devices) together.
# The disabled device names are saved as plain lines in STATE_FILE, and
# input.lua reads them back on every Hyprland reload, so the toggle survives
# config reloads and reboots.
STATE_FILE="$HOME/.local/state/toggle-touchpad/disabled-devices"

set_enabled() {
  while read -r dev; do
    [ -n "$dev" ] && hyprctl eval "hl.device({ name = \"$dev\", enabled = $1 })" >/dev/null
  done
}

if [ -f "$STATE_FILE" ]; then
  set_enabled true <"$STATE_FILE"
  rm "$STATE_FILE"
  notify-send "Touchpad" "Enabled"
else
  mkdir -p "$(dirname "$STATE_FILE")"
  hyprctl devices -j | jq -r '.mice[].name | select(startswith("syna30be"))' >"$STATE_FILE"
  set_enabled false <"$STATE_FILE"
  notify-send "Touchpad" "Disabled"
fi
