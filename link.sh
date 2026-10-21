#!/usr/bin/env bash
# Symlink dotfiles into place from the mappings in ./links.
#
# Usage: link.sh [-n] [-c]
#   -n  dry run: print what would change
#   -c  check: report missing or wrong links, exit 1 if any
#
# The machine profile is read from ./.machine (default: desktop):
#   cli      links/cli.txt
#   desktop  links/cli.txt + links/desktop.txt
#
# Existing real files at a target are moved to <target>.bak.<timestamp>.
# Broken symlinks pointing into the dotfiles repo are removed.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dry=0 check=0
while getopts nc opt; do
  case $opt in
    n) dry=1 ;;
    c) check=1 ;;
    *) exit 2 ;;
  esac
done

profile=$(cat "$DOTFILES/.machine" 2>/dev/null || echo desktop)
case $profile in
  cli) maps=("$DOTFILES/links/cli.txt") ;;
  desktop) maps=("$DOTFILES/links/cli.txt" "$DOTFILES/links/desktop.txt") ;;
  *) echo "unknown profile in .machine: $profile" >&2; exit 2 ;;
esac

problems=0

run() {
  if ((dry)); then echo "  (dry) $*"; else "$@"; fi
}

while read -r src dst _; do
  [[ -z ${src:-} || $src == \#* ]] && continue
  dst="${dst/#\~/$HOME}"
  abs="$DOTFILES/$src"

  if [[ ! -e $abs ]]; then
    echo "missing source: $src"
    problems=1
    continue
  fi

  # Already correct (readlink -f ignores trailing slashes in old links)
  if [[ -L $dst && "$(readlink -f "$dst")" == "$abs" ]]; then
    continue
  fi

  if ((check)); then
    if [[ -L $dst ]]; then
      echo "wrong link: $dst -> $(readlink "$dst")"
    elif [[ -e $dst ]]; then
      echo "real file:  $dst"
    else
      echo "missing:    $dst"
    fi
    problems=1
    continue
  fi

  if [[ -e $dst && ! -L $dst ]]; then
    bak="$dst.bak.$(date +%Y%m%d%H%M%S)"
    echo "backup: $dst -> $bak"
    run mv "$dst" "$bak"
  fi

  echo "link:   $dst -> $abs"
  run mkdir -p "$(dirname "$dst")"
  run ln -sfn "$abs" "$dst"
done < <(cat "${maps[@]}")

# Broken links into the repo (e.g. a config folder that was deleted)
while IFS= read -r stale; do
  if ((check)); then
    echo "broken:     $stale -> $(readlink "$stale")"
    problems=1
  else
    echo "prune:  $stale"
    run rm "$stale"
  fi
done < <(
  find "$HOME" -maxdepth 1 -xtype l -lname "$DOTFILES/*" 2>/dev/null
  find "$HOME/.config" "$HOME/.claude" -maxdepth 3 -xtype l -lname "$DOTFILES/*" 2>/dev/null
)

exit $((check ? problems : 0))
