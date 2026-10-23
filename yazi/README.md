# yazi

Configuration of [yazi](https://yazi-rs.github.io), a terminal file manager. Linked to `~/.config/yazi`.

Open it with `y` in fish: when you quit, the shell `cd`s into the directory yazi was in (`Q` quits without changing directory).

## Requirements

- `yazi` (and `ya`, its package manager)
- `fd` and `ripgrep` (search), `fzf` and `zoxide` (jumps)
- `ouch` (archive preview, compress, extract), `glow` (markdown preview), `eza` (directory preview)
- `wl-clipboard` (copy files as URIs), `mediainfo` and `exiftool` (optional, file info)
- A Nerd Font

## Installation

```sh
ln -s ~/dotfiles/yazi ~/.config/yazi   # or `just link`
ya pkg install                         # installs the plugins and flavor pinned in package.toml
```

## Structure

```text
yazi/
├── yazi.toml      # General settings, openers, previewers
├── keymap.toml    # Key bindings (full default keymap + prepend_keymap overrides)
├── theme.toml     # Flavor selection
├── init.lua       # Plugin setup, status bar additions
├── package.toml   # Plugins and flavor, pinned (managed by `ya pkg`)
├── plugins/       # Installed plugins
└── flavors/       # Installed flavors (catppuccin-mocha)
```

## Settings

`yazi.toml`:

- Column ratio `2:4:3`, directories first, alphabetical sort, hidden files off (`.` toggles them), `scrolloff = 5`.
- **Previewers** added on top of the defaults:
  - archives (`zip`, `tar`, `7z`, `rar`, `xz`, `zstd`, `jar`…): their content, with `ouch`;
  - `*.md`: rendered with `glow`;
  - directories: a 3-level `eza` tree.
- **Opener** `extract`: extracts archives in place with `ouch d -y`.

## Plugins

| Plugin             | Use                                                  |
| ------------------ | ---------------------------------------------------- |
| [full-border]      | Rounded border around the whole UI                   |
| [git]              | Git status of each file in the list                  |
| [bunny]            | Bookmarks ("hops") to jump to                        |
| [relative-motions] | Vim-like relative line numbers and counts (`5j`)     |
| [starship]         | Starship prompt in the header                        |
| [smart-enter]      | `l` enters a directory or opens a file               |
| [smart-paste]      | `p` pastes into the hovered directory                |
| [jump-to-char]     | `f` jumps to the next file starting with a character |
| [mount]            | Mount / unmount / eject drives                       |
| [chmod]            | Change permissions of the selected files             |
| [ouch]             | Archive preview and compression                      |
| [piper]            | Uses a shell command as a previewer (glow, eza)      |

[full-border]: https://github.com/yazi-rs/plugins/tree/main/full-border.yazi
[git]: https://github.com/yazi-rs/plugins/tree/main/git.yazi
[bunny]: https://github.com/stelcodes/bunny.yazi
[relative-motions]: https://github.com/dedukun/relative-motions.yazi
[starship]: https://github.com/Rolv-Apneseth/starship.yazi
[smart-enter]: https://github.com/yazi-rs/plugins/tree/main/smart-enter.yazi
[smart-paste]: https://github.com/yazi-rs/plugins/tree/main/smart-paste.yazi
[jump-to-char]: https://github.com/yazi-rs/plugins/tree/main/jump-to-char.yazi
[mount]: https://github.com/yazi-rs/plugins/tree/main/mount.yazi
[chmod]: https://github.com/yazi-rs/plugins/tree/main/chmod.yazi
[ouch]: https://github.com/ndtoan96/ouch.yazi
[piper]: https://github.com/yazi-rs/plugins/tree/main/piper.yazi

The status bar also shows the **symlink target** of the hovered file (left) and its **owner and group** (right).

## Key bindings

Vim-like defaults (`h/j/k/l`, `gg`/`G`, `y`/`x`/`p`, `d` to trash, `D` to delete, `a` to create, `r` to rename, `s`/`S` to search with fd/rg, `z`/`Z` for fzf/zoxide, `~` for help). Overrides and additions:

| Keys           | Action                                                                                        |
| -------------- | --------------------------------------------------------------------------------------------- |
| `l`            | Enter the directory or open the file (smart-enter)                                            |
| `p`            | Paste into the hovered directory, or the current one (smart-paste)                            |
| `y`            | Yank, and also copy the files as `file://` URIs to the clipboard, so they paste into GUI apps |
| `f`            | Jump to char                                                                                  |
| `1`–`9`        | Relative motion count (then `j`/`k`…)                                                         |
| `;`            | Bunny hops menu                                                                               |
| `'`            | Bunny hops, fuzzy search                                                                      |
| `C`            | Compress the selection (ouch)                                                                 |
| `cm`           | chmod the selection                                                                           |
| `M`            | Mount menu                                                                                    |
| `gr`           | Go to the root of the git repository                                                          |
| `gh` `gc` `gd` | Go to `~`, `~/.config`, `~/Downloads`                                                         |
| `!`            | Open a shell here                                                                             |
| `Esc`          | Cancel an input box directly (no vi normal mode in inputs)                                    |

### Bunny hops

| Keys | Path             |
| ---- | ---------------- |
| `/`  | `/`              |
| `t`  | `/tmp`           |
| `c`  | `~/.config`      |
| `hh` | `~`              |
| `hk` | `~/Desktop`      |
| `hd` | `~/Downloads`    |
| `hD` | `~/Documents`    |
| `hp` | `~/Pictures`     |
| `ls` | `~/.local/share` |
| `lb` | `~/.local/bin`   |
| `lt` | `~/.local/state` |

Bunny also offers the open tabs and an "ephemeral" hop back to the previous directory.

## Theme

The [catppuccin-mocha](https://github.com/yazi-rs/flavors/tree/main/catppuccin-mocha.yazi) flavor, for both dark and light terminals.
