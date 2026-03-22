#!/usr/bin/env bash
# vi: ft=sh

WINDOW_COUNT=$(tmux list-windows | wc -l)
if [ "$WINDOW_COUNT" -gt 1 ]; then
  tmux display-message "work-setup: session already has $WINDOW_COUNT windows, aborting."
  exit 0
fi

CLAUDE_CMD="claude"
PROJECT_KEY=$(pwd | sed 's|/|-|g')
tmux rename-window "code"
tmux new-window -n "claude"
tmux new-window -n "server"
tmux select-window -t 1

if [ -d "$HOME/.claude/projects/$PROJECT_KEY" ]; then
  CLAUDE_CMD="claude --continue"
fi

tmux send-keys -t :2 "$CLAUDE_CMD" Enter
tmux send-keys -t :3 "pnpm dev" Enter
