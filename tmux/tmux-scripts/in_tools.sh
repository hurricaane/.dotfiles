#!/bin/bash

# Liste des outils à vérifier
tools=("atuin" "fzf" "nvim" "vim" "lazygit" "less")

# On vérifie si l'un des outils est en cours d'exécution
for tool in "${tools[@]}"; do
  if pgrep -u "$USER" -x "$tool" >/dev/null; then
    exit 0
  fi
done

# Si aucun des outils n'est trouvé, exit 1
exit 1
