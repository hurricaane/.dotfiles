#!/usr/bin/env bash
# Claude Code status line: a vim mode badge (like lualine) in front of another status line.
# Claude Code sends the session as JSON on stdin; it's passed unchanged to the inner command

# The status line shown after the badge: ctxline (https://ctxline.js.org), kept in dotfiles.
# Update it with the command below, NOT `npx ctxline-claude@latest` (it rewrites settings.json):
#   curl -fsSL -o ~/dotfiles/claude/ctxline.js https://raw.githubusercontent.com/MithunWijayasiri/ctxline-claude/main/statusline.js
inner=(node ~/.claude/ctxline.js)

input=$(cat)
mode=$(jq -r '.vim.mode // empty' <<<"$input")

# Catppuccin Mocha colors, like lualine
case $mode in
NORMAL) color="137;180;250" ;;                 # blue
INSERT) color="166;227;161" ;;                 # green
VISUAL | "VISUAL LINE") color="203;166;247" ;; # mauve
esac

# No newline after the badge, so it lands on the first line of the inner status line
if [[ -n $mode ]]; then
	printf '\033[1;38;2;30;30;46;48;2;%sm %s \033[0m ' "$color" "$mode"
	# The inner status line wraps based on the terminal width: leave room for the badge
	[[ -n $COLUMNS ]] && export COLUMNS=$((COLUMNS - ${#mode} - 3))
fi
# ctxline uses plain Unicode symbols that Nerd Fonts lack: the terminal takes them from a
# fallback font, which draws them tiny. Swap them for Nerd Font icons
"${inner[@]}" <<<"$input" | sed \
	-e "s/⎇/"$''"/g" \
	-e "s/↺/"$''"/g" \
	-e "s/⏱/"$'\U000f051b'"/g" \
	-e "s/⬆/"$'\U000f0737'"/g"
