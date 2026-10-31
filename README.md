# Dotfiles

My personal configuration for an **Arch Linux + [Omarchy](https://omarchy.org) (Hyprland)** desktop, built around a terminal workflow: Ghostty → fish → tmux → Neovim, with Claude Code running next to the editor.

Everything lives in `~/dotfiles` and is **symlinked** into place by a small script. Package lists and links are split in two **profiles**, so the same repo also sets up a headless or server machine with only the terminal tools.

<!-- toc -->

- [Requirements](#requirements)
  - [Operating system](#operating-system)
  - [Tools needed before installing](#tools-needed-before-installing)
  - [Tools installed outside the package lists](#tools-installed-outside-the-package-lists)
- [Installation](#installation)
  - [After the first install](#after-the-first-install)
- [Everyday commands](#everyday-commands)
- [How it works](#how-it-works)
  - [Profiles](#profiles)
  - [Links](#links)
  - [Packages](#packages)
- [Configurations](#configurations)
  - [Terminal](#terminal)
  - [Editor](#editor)
  - [Git](#git)
  - [AI](#ai)
  - [Desktop](#desktop)
- [Repository layout](#repository-layout)
- [Theme](#theme)

<!-- tocstop -->

## Requirements

### Operating system

| Profile   | OS                                                                                   |
| --------- | ------------------------------------------------------------------------------------ |
| `desktop` | Arch Linux with **Omarchy 4** ("Quattro": Hyprland configured in Lua, Omarchy shell) |
| `cli`     | Any Arch-based distribution (packages are installed with `yay`)                      |

The desktop configs (`hypr`, `omarchy`, `ghostty`, `xkb`) only make sense on Omarchy: the Hyprland config loads Omarchy's defaults first and only holds overrides, and Ghostty reads its colors from the current Omarchy theme.

The terminal configs don't depend on Omarchy, but a few lines assume Wayland (`wl-copy` for the tmux and yazi clipboard).

### Tools needed before installing

- `git`, to clone the repo
- [`yay`](https://github.com/Jguer/yay): every package is installed through it (AUR included). Omarchy ships it.
- [`just`](https://github.com/casey/just): runs the setup recipes (`sudo pacman -S just`). It is also in `packages/cli.txt`, so it stays installed afterwards.

On a machine **without Omarchy**, also install the tools that Omarchy normally provides, which the configs rely on:

```sh
yay -S --needed bat eza fd fzf jq lazygit ripgrep starship tmux wl-clipboard zoxide
```

### Tools installed outside the package lists

These aren't installed by `just install`, because they come from their own installers or from mise:

| Tool                                             | Used by                                               | Install                                             |
| ------------------------------------------------ | ----------------------------------------------------- | --------------------------------------------------- |
| [atuin](https://atuin.sh)                        | fish history (`Ctrl-r`, `/`), Claude Code hooks       | [Installation](#installation)                       |
| [rtk](https://github.com/rtk-ai/rtk)             | Claude Code hook that condenses command output        | [Installation](#installation)                       |
| [workmux](https://github.com/raine/workmux)      | tmux (`prefix w`), fish abbr `wm`                     | [Installation](#installation)                       |
| [fisher](https://github.com/jorgebucaran/fisher) | fish plugins                                          | [After the first install](#after-the-first-install) |
| [Claude Code](https://code.claude.com)           | Neovim (claudecode.nvim), workmux, `ai-commit-msg.sh` | [After the first install](#after-the-first-install) |
| Neovim nightly                                   | Neovim (0.12 minimum, 0.13-dev recommended)           | [After the first install](#after-the-first-install) |

## Installation

```sh
git clone git@github.com:hurricaane/.dotfiles.git ~/dotfiles
cd ~/dotfiles

sudo pacman -S --needed just

# Tools with their own installers, before linking: the atuin installer edits
# the fish config and ~/.claude, which would otherwise be the files in the repo
curl --proto '=https' -sSf https://setup.atuin.sh | sh
curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh
curl -fsSL https://raw.githubusercontent.com/raine/workmux/main/scripts/install.sh | bash

# Pick the profile of this machine: desktop (default) or cli
just profile desktop

# Install the packages of the profile, then create the symlinks
just setup
```

`just link -n` shows what would be linked without touching anything. When a target already exists as a real file or folder, it is moved to `<target>.bak.<timestamp>` before the link is created, so nothing is lost.

### After the first install

1. **fish as the login shell**: `chsh -s /usr/bin/fish`. Then, in fish, install fisher and the plugins listed in `fish/fish_plugins`:

   ```fish
   curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
   fisher update
   ```

2. **Claude Code and the other mise tools**: `mise install` (see [mise](mise/README.md)).
3. **tmux plugins**: `prefix I` (`Ctrl-a I`) inside tmux, or `tpack install` (tpack comes from the CLI list).
4. **bat themes**: `bat cache --build`, so `BAT_THEME="Catppuccin Mocha"` is found.
5. **yazi plugins**: `ya pkg install` installs the plugins pinned in `yazi/package.toml`.
6. **Neovim**: `bob use nightly`, then start `nvim`. Plugins, tree-sitter parsers and LSP servers install on first launch (see [nvim](nvim/README.md#installation)).
7. **Git identity and signing**: create `git/config.local` (gitignored) for anything machine-specific, such as the commit signing key (see [git](git/README.md#machine-specific-settings)).
8. **Desktop only**: log out and back in, so Hyprland picks up the new config and keyboard layout.

## Everyday commands

The fish abbreviation `dots` runs `just -f ~/dotfiles/justfile` from anywhere: `dots check`, `dots pkg-add cli ripgrep`…

| Command                       | What it does                                                             |
| ----------------------------- | ------------------------------------------------------------------------ |
| `just`                        | List the recipes and show the current profile                            |
| `just profile <cli\|desktop>` | Set this machine's profile (saved in the gitignored `.machine` file)     |
| `just setup`                  | `install` then `link`                                                    |
| `just install`                | Install every package of the profile's lists (`yay -S --needed`)         |
| `just link [-n]`              | Create the symlinks (`-n`: dry run)                                      |
| `just check`                  | Report missing or wrong links, then package drift                        |
| `just pkg-add <list> <pkgs…>` | Install packages and add them to `packages/<list>.txt`                   |
| `just pkg-rm <pkgs…>`         | Uninstall packages and remove them from every list                       |
| `just pkg-diff`               | Packages installed but in no list, and packages listed but not installed |
| `just mise-rebuild [-n]`      | Rebuild what uses an old Python/Node, before `mise prune`                |

## How it works

### Profiles

The profile is stored in `.machine` (gitignored, default `desktop`):

| Profile   | Links                                 | Packages                                    |
| --------- | ------------------------------------- | ------------------------------------------- |
| `cli`     | `links/cli.txt`                       | `packages/cli.txt`                          |
| `desktop` | `links/cli.txt` + `links/desktop.txt` | `packages/cli.txt` + `packages/desktop.txt` |

### Links

`link.sh` reads `links/*.txt`, one mapping per line:

```text
<source in dotfiles>   <target>
fish                   ~/.config/fish
tmux/tmux.conf         ~/.config/tmux/tmux.conf
```

- `~` expands to `$HOME`, and lines starting with `#` are ignored. Commented entries at the end of `links/cli.txt` are configs kept in the repo but not linked (tool not installed, or replaced).
- A whole folder is linked when the app's config dir only holds my files. A **single file** is linked when the app writes its own files next to it (tmux plugins, Claude Code's state in `~/.claude`).
- Links that are already correct are skipped, so running it again is safe.
- Broken symlinks pointing into the repo (a config folder that was deleted or renamed) are removed.
- `link.sh -c` (`just check`) only reports problems and exits with `1` if there are any.

### Packages

- `packages/cli.txt`: terminal tools, installed on every machine.
- `packages/desktop.txt`: desktop apps, fonts and hardware tools, only with the `desktop` profile.
- `packages/ignore.txt`: installed on purpose but not part of the setup (kernel, microcode, Omarchy itself). `just pkg-diff` ignores them.

`just pkg-diff` also skips every package from Omarchy's own lists (`/usr/share/omarchy/install/omarchy-*.packages`), so the lists only hold what I add on top of Omarchy.

## Configurations

Each folder has its own README with the details of the configuration.

### Terminal

| Tool                                                       | Config                             | Description                                                          |
| ---------------------------------------------------------- | ---------------------------------- | -------------------------------------------------------------------- |
| [Ghostty](https://ghostty.org)                             | [ghostty](ghostty/README.md)       | Terminal emulator: Omarchy theme colors, glass blur, CSI-u key fixes |
| [fish](https://fishshell.com)                              | [fish](fish/README.md)             | Shell: vi mode, abbreviations, tool integrations, tmux auto-attach   |
| [Starship](https://starship.rs)                            | [starship](starship/README.md)     | Two-sided prompt with git status and language versions               |
| [tmux](https://github.com/tmux/tmux)                       | [tmux](tmux/README.md)             | Multiplexer: `Ctrl-a` prefix, popups for sesh/lazygit/workmux        |
| [sesh](https://github.com/joshmedeski/sesh)                | [sesh](sesh/README.md)             | tmux session manager, with predefined sessions for each config       |
| [Television](https://github.com/alexpasmantier/television) | [television](television/README.md) | Fuzzy finder: channels for sesh, files, git, docker…                 |
| [yazi](https://yazi-rs.github.io)                          | [yazi](yazi/README.md)             | File manager: plugins for git, archives, bookmarks, relative motions |
| [bat](https://github.com/sharkdp/bat)                      | [bat](bat/README.md)               | `cat` with syntax highlighting, Catppuccin themes                    |
| [RTK](https://github.com/rtk-ai/rtk)                       | [rtk](rtk/README.md)               | Condenses command output for AI agents                               |
| [mise](https://mise.jdx.dev)                               | [mise](mise/README.md)             | Global tool versions: Node, gh and the AI agent CLIs                 |

### Editor

| Tool                        | Config                 | Description                                                             |
| --------------------------- | ---------------------- | ----------------------------------------------------------------------- |
| [Neovim](https://neovim.io) | [nvim](nvim/README.md) | `vim.pack` + mini.nvim config, LSP, Claude Code integration, remote SSH |

### Git

| Tool                                                | Config                       | Description                                                          |
| --------------------------------------------------- | ---------------------------- | -------------------------------------------------------------------- |
| [Git](https://git-scm.com)                          | [git](git/README.md)         | Global config, delta pager, global hooks with a gitleaks secret scan |
| [lazygit](https://github.com/jesseduffield/lazygit) | [lazygit](lazygit/README.md) | Git TUI with delta diffs and an AI commit message command            |

### AI

| Tool                                        | Config                       | Description                                                          |
| ------------------------------------------- | ---------------------------- | -------------------------------------------------------------------- |
| [Claude Code](https://code.claude.com)      | [claude](claude/README.md)   | Settings, hooks (RTK, atuin), vim-mode status line, theme, skills    |
| [workmux](https://github.com/raine/workmux) | [workmux](workmux/README.md) | One git worktree + tmux window per task, each with Neovim and Claude |

### Desktop

Linked with the `desktop` profile only.

| Tool                           | Config                       | Description                                                                  |
| ------------------------------ | ---------------------------- | ---------------------------------------------------------------------------- |
| [Hyprland](https://hypr.land)  | [hypr](hypr/README.md)       | Overrides on top of Omarchy: monitors, input, bindings, nav mode, animations |
| [Omarchy](https://omarchy.org) | [omarchy](omarchy/README.md) | Omarchy shell (bar, idle), the catppuccin-glass theme, hooks                 |
| [XKB](https://xkbcommon.org)   | [xkb](xkb/README.md)         | `us-fr` layout: US QWERTY with French characters on AltGr                    |

## Repository layout

```text
dotfiles/
├── justfile              # Setup recipes (profile, install, link, check, pkg-*)
├── link.sh               # Symlink script, reads links/*.txt
├── links/                # Symlink mappings per profile
├── packages/             # Package lists per profile (+ ignore list)
├── scripts/
│   └── ai-commit-msg.sh  # Commit message for the staged changes, written by Claude Haiku
├── .markdownlint.yaml    # Linked to ~/.markdownlint.yaml (used by markdownlint-cli2 in Neovim)
└── <tool>/               # One folder per tool, see Configurations
```

`scripts/ai-commit-msg.sh` is used by the fish abbreviation `gcai` and by the `Ctrl-k` custom command in lazygit (see [lazygit](lazygit/README.md#ai-commit-message)).

Folders that are not listed above are legacy configs that are no longer used: `LazyVim` (the previous Neovim config), `mcphub` (MCP servers for mcphub.nvim, which only the LazyVim config loaded), `waybar` (replaced by the Omarchy shell), `wezterm`, `xremap`, `zk`, `zshrc`, `gh-dash`, `opencode` and `task`.

## Theme

Everything uses **[Catppuccin Mocha](https://catppuccin.com/palette/)** with transparent backgrounds, so the Hyprland blur shows through: the Omarchy `catppuccin-glass` theme, Ghostty, fish, tmux, Starship, Neovim, bat, yazi, workmux and Claude Code. lazygit is the exception, with Tokyo Night Moon colors.
