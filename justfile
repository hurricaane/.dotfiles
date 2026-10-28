set shell := ["bash", "-euo", "pipefail", "-c"]

# Machine profile, stored in the gitignored .machine file: cli or desktop
machine := `cat .machine 2>/dev/null || echo desktop`
lists := if machine == "cli" { "packages/cli.txt" } else { "packages/cli.txt packages/desktop.txt" }
omarchy_packages := "/usr/share/omarchy/install/omarchy-*.packages"

[private]
default:
    @just --list
    @echo "Profile: {{ machine }}"

# Split packages into repo (incl. [omarchy]) and AUR, and install each with the matching omarchy helper
[private]
pkg-install +pkgs:
    #!/usr/bin/env bash
    set -euo pipefail
    wanted=$(printf '%s\n' {{ pkgs }} | sort -u)
    repo=$(pacman -Slq | sort -u)
    mapfile -t official < <(comm -12 <(echo "$wanted") <(echo "$repo"))
    mapfile -t aur < <(comm -23 <(echo "$wanted") <(echo "$repo"))
    if (( ${#official[@]} )); then omarchy pkg add "${official[@]}"; fi
    if (( ${#aur[@]} )); then
      echo "From AUR: ${aur[*]}"
      omarchy pkg aur add "${aur[@]}"
    fi

# Set this machine's profile: cli (terminal tools only) or desktop (everything)
profile name:
    @[[ "{{ name }}" =~ ^(cli|desktop)$ ]] || { echo "profile must be cli or desktop" >&2; exit 1; }
    echo "{{ name }}" > .machine

# Symlink configs into place (`just link -n` for a dry run)
link *args:
    ./link.sh {{ args }}

# Install packages, then link configs
setup: install link

# Report missing links and package drift
check:
    -./link.sh -c
    @just pkg-diff

# Rebuild venvs, uv tools, Mason packages and npm tools on the current Python and Node, before `mise prune` (`just mise-rebuild -n` for a dry run)
mise-rebuild *args:
    ./scripts/mise-rebuild.sh {{ args }}

# Install the packages for this machine's profile
install:
    just pkg-install $(grep -ho '^[^#[:space:]]\+' {{ lists }})

# Install packages and add them to a list, e.g. `just pkg-add cli ripgrep`
pkg-add list +pkgs:
    @[[ -f "packages/{{ list }}.txt" ]] || { echo "no such list: packages/{{ list }}.txt" >&2; exit 1; }
    just pkg-install {{ pkgs }}
    for p in {{ pkgs }}; do grep -qx "$p" packages/{{ list }}.txt || echo "$p" >> packages/{{ list }}.txt; done

# Uninstall packages and remove them from every list
pkg-rm +pkgs:
    omarchy pkg drop {{ pkgs }}
    for p in {{ pkgs }}; do sed -i "/^$p\$/d" packages/*.txt; done

# Compare the package lists with what is installed (skips Omarchy's packages and packages/ignore.txt)
pkg-diff:
    #!/usr/bin/env bash
    set -euo pipefail
    names() { grep -ho '^[^#[:space:]]\+' "$@" 2>/dev/null | sort -u; }
    wanted=$(names {{ lists }})
    known=$(names packages/*.txt {{ omarchy_packages }})
    echo "Installed but in no list (add with pkg-add, or remove with pkg-rm):"
    comm -23 <(pacman -Qqe | sort -u) <(echo "$known") | sed 's/^/  /'
    echo "Wanted by the {{ machine }} profile but not installed (run install):"
    comm -13 <(pacman -Qq | sort -u) <(echo "$wanted") | sed 's/^/  /'
