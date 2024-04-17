#!/bin/bash

items=("Neovim" "Wezterm" "Tmux")
to_edit=$(printf "%s\n" "${items[@]}" | fzf --prompt="  Configuration to edit " --height=~50% --layout=reverse --border --exit-0)
if [[ -z $to_edit ]]; then
	echo "Nothing selected. Aborting."
elif [[ $to_edit == "Neovim" ]]; then
	nvim "$HOME/dotfiles/neovims/LazyVim/lua/plugins/"
elif [[ $to_edit == "Wezterm" ]]; then
	nvim "$HOME/dotfiles/wezterm/wezterm.lua"
elif [[ $to_edit == "Tmux" ]]; then
	nvim "$HOME/dotfiles/tmux/tmux.conf"
fi
