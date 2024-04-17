#!/bin/bash

items=("Aliases" "Zshrc")
to_edit=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Zsh Files " --height=~50% --layout=reverse --border --exit-0)
if [[ -z $to_edit ]]; then
	echo "Nothing selected. Aborting."
elif [[ $to_edit == "Aliases" ]]; then
	nvim "$HOME/.zsh_aliases"
elif [[ $to_edit == "Zshrc" ]]; then
	nvim "$HOME/.zshrc"
fi
