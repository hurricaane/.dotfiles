#!/usr/bin/env bash
# vi: ft=sh

WINDOW_COUNT=$(tmux list-windows | wc -l)
if [ "$WINDOW_COUNT" -le 1 ]; then
  tmux display-message "close-other-windows: only one window in session, nothing to close."
  exit 0
fi

CURRENT=$(tmux display-message -p '#{window_id}')

tmux list-windows -F '#{window_id}' | grep -v "^$CURRENT$" | while read -r win; do
  tmux kill-window -t "$win"
done

exit 0
