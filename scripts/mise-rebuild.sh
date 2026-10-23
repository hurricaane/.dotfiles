#!/usr/bin/env bash
set -euo pipefail

# Rebuild what is tied to one exact Python or Node install. Run it after
# `mise upgrade` and before `mise prune`, which removes the old installs.
#   Python: virtualenvs (projects, uv tools, Mason packages, mise pipx:/pypi: tools)
#           whose interpreter is no longer the current one
#   Node:   native modules (mise npm: tools, Mason packages with .node files)
#           when the Node ABI changed, i.e. a new major version
#
# Usage: mise-rebuild.sh [-n]
#   -n  dry run: print what would be rebuilt

dry=0
[[ ${1:-} == -n ]] && dry=1

# Resolve the global versions, and put their binaries first (uv, node, Mason's python3)
cd "$HOME"
PATH="$(mise bin-paths | paste -sd:):$PATH"

data=$HOME/.local/share
mise_python=$data/mise/installs/python
mason=$data/nvim/mason/packages
state=${XDG_STATE_HOME:-$HOME/.local/state}/mise-rebuild

mise_tools=() mason_pkgs=()

run() {
  if ((dry)); then echo "  (dry) $*"; else "$@"; fi
}

# Interpreter dir of a venv, through mise's version links (3.14 -> 3.14.9)
venv_python() {
  realpath -m "$(sed -n 's/^home = //p' "$1/pyvenv.cfg")"
}

# Current interpreter dir for a directory: a project's mise.toml can pin its own
current_python() {
  local where
  where=$(cd "$1" && mise where python 2>/dev/null) || return 1
  echo "$(realpath "$where")/bin"
}

# True when a venv runs on a mise Python that is no longer the current one
stale() {
  local old new
  old=$(venv_python "$1")
  [[ $old == "$mise_python"/* ]] || return 1
  new=$(current_python "$2") || return 1
  [[ $old != "$new" ]]
}

backend() {
  mise tool --backend "$1" 2>/dev/null
}

# ── Python ────────────────────────────────────────────────────────────────────

# Project and standalone venvs: recreated in place with the same packages
while IFS= read -r venv; do
  project=$(dirname "$venv")
  stale "$venv" "$project" || continue
  if [[ ! -x $(venv_python "$venv")/python ]]; then
    echo "skip:   $venv (its Python is already removed, recreate it by hand)"
    continue
  fi
  echo "venv:   $venv"
  ((dry)) && continue
  reqs=$(mktemp)
  uv pip freeze --quiet --python "$venv/bin/python" >"$reqs"
  flags=()
  grep -q '^include-system-site-packages = true' "$venv/pyvenv.cfg" && flags+=(--system-site-packages)
  uv venv --quiet --clear "${flags[@]}" --python "$(current_python "$project")/python" "$venv"
  uv pip install --quiet --python "$venv/bin/python" -r "$reqs"
  rm "$reqs"
done < <(
  find "$HOME" \( -path "$HOME/.cache" -o -path "$data/mise" -o -path "$data/nvim/mason" \
    -o -path "$data/uv/tools" -o -name node_modules -o -name .git \) -prune \
    -o -name pyvenv.cfg -printf '%h\n' 2>/dev/null
)

# uv tools
for venv in "$data"/uv/tools/*/; do
  venv=${venv%/}
  [[ -f $venv/pyvenv.cfg ]] && stale "$venv" "$HOME" || continue
  echo "uv:     $(basename "$venv")"
  run uv tool upgrade --reinstall --python "$(current_python "$HOME")/python" "$(basename "$venv")"
done

# Mason packages installed with pip
for venv in "$mason"/*/venv; do
  [[ -f $venv/pyvenv.cfg ]] && stale "$venv" "$HOME" && mason_pkgs+=("$(basename "$(dirname "$venv")")")
done

# mise pipx: tools
for tool in $(mise ls --global --json | jq -r 'keys[]'); do
  [[ $(backend "$tool") == @(pipx|pypi):* ]] || continue
  while IFS= read -r venv; do
    stale "$venv" "$HOME" && { mise_tools+=("$tool"); break; }
  done < <(find "$(mise where "$tool")" -name pyvenv.cfg -printf '%h\n')
done

# ── Node ──────────────────────────────────────────────────────────────────────

# Native modules only break across ABI versions (one per Node major), so the ABI
# of the last rebuild is kept in $state. The first run rebuilds everything.
abi=$(node -p process.versions.modules)
if [[ $abi != "$(cat "$state/node-abi" 2>/dev/null)" ]]; then
  for tool in $(mise ls --global --json | jq -r 'keys[]'); do
    [[ $(backend "$tool") == npm:* ]] && mise_tools+=("$tool")
  done
  for pkg in "$mason"/*/; do
    [[ -n $(find "$pkg" -name '*.node' -print -quit) ]] && mason_pkgs+=("$(basename "$pkg")")
  done
fi

# ── Reinstall ─────────────────────────────────────────────────────────────────

if ((${#mise_tools[@]})); then
  echo "mise:   ${mise_tools[*]}"
  run mise install --force "${mise_tools[@]}"
fi

if ((${#mason_pkgs[@]})); then
  echo "mason:  ${mason_pkgs[*]}"
  run nvim --headless -c "MasonInstall --force ${mason_pkgs[*]}" -c qa
fi

if ((!dry)); then
  mkdir -p "$state"
  echo "$abi" >"$state/node-abi"
fi

prunable=$(mise prune --dry-run 2>&1 | sed -n 's/^mise \(.*\) is prunable.*/  \1/p')
if [[ -n $prunable ]]; then
  echo "Old versions that \`mise prune\` would remove:"
  echo "$prunable"
fi
