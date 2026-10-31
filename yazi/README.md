# yazi

Configuration of [yazi](https://yazi-rs.github.io), a terminal file manager. Linked to `~/.config/yazi`.

Open it with `y` in fish: when you quit, the shell `cd`s into the directory yazi was in (`Q` quits without changing directory).

## Requirements

- `yazi` (and `ya`, its package manager)
- `fd` and `ripgrep` (search), `fzf` and `zoxide` (jumps)
- `ouch` (archive preview, compress, extract), `glow` (markdown preview), `eza` (directory preview)
- `7zip` (preview of other archives and disk images), `resvg` (SVG preview)
- `starship`
- `wl-clipboard` (copy files as URIs), `mediainfo` and `exiftool` (optional, file info)
- A Nerd Font

## Installation

```sh
ln -s ~/dotfiles/yazi ~/.config/yazi   # or `just link`
ya pkg install                         # installs the plugins and flavor pinned in package.toml
```

After a yazi update, run `ya pkg upgrade`: plugins follow yazi's API and break when they lag behind.

**relative-motions comes from my fork**, [hurricaane/relative-motions.yazi](https://github.com/hurricaane/relative-motions.yazi). Upstream ([dedukun/relative-motions.yazi](https://github.com/dedukun/relative-motions.yazi)) has had no merge since July 2025 and still calls `ya.mgr_emit`, which yazi 26 removed, so the motion key does nothing (the status bar just shows `1 left`). The fork:

- uses `ya.emit` instead of `ya.mgr_emit`;
- draws the hovered line as one rounded highlight starting before the number (upstream highlights the number as a square block, then starts the rounded highlight at the icon); other numbers have no background;
- bases `Current.redraw` on Yazi 26's preset, so long names are truncated with `…` and drag and drop works.

Never edit `plugins/relative-motions.yazi/` here: `ya pkg` aborts every install/upgrade when a plugin has local changes. Change the fork, push, then `ya pkg upgrade`. If a yazi update breaks it, the fix goes in the fork too.

## Structure

```text
yazi/
├── yazi.toml      # Overrides of the default settings, openers, previewers
├── keymap.toml    # Key bindings added on top of the default keymap
├── theme.toml     # Flavor selection, catppuccin file icons
├── init.lua       # Plugin setup, status bar additions
├── starship.toml  # Single-line starship prompt for the header
├── package.toml   # Plugins and flavor, pinned (managed by `ya pkg`)
├── plugins/       # Installed plugins
└── flavors/       # Installed flavors (catppuccin-mocha)
```

Yazi merges `yazi.toml`, `keymap.toml` and `theme.toml` on top of its built-in defaults, so these files only hold changes. Don't copy the full defaults in: they go stale with every release. Reference: [yazi-default.toml](https://github.com/sxyazi/yazi/blob/main/yazi-config/preset/yazi-default.toml), [keymap-default.toml](https://github.com/sxyazi/yazi/blob/main/yazi-config/preset/keymap-default.toml).

## Settings

`yazi.toml`:

- Column ratio `2:4:3` (wider parent column).
- The "which" popup (shown after the first key of a multi-key binding) is sorted by key.
- **Fetchers**: `git` status for files and directories.
- **Previewers** added on top of the defaults:
  - archives (`zip`, `tar`, `7z`, `rar`, `xz`, `zstd`, `jar`…): their content, with `ouch`;
  - `*.md`: rendered with `glow`;
  - directories: a 3-level `eza` tree.
- **Opener** `extract`: opening an archive extracts it in place with `ouch d -y` (overwrites without asking).

## Plugins

| Plugin                                                                         | Use                                                       |
| ------------------------------------------------------------------------------ | --------------------------------------------------------- |
| [full-border](https://github.com/yazi-rs/plugins/tree/main/full-border.yazi)   | Rounded border around the whole UI                        |
| [git](https://github.com/yazi-rs/plugins/tree/main/git.yazi)                   | Git status of each file in the list                       |
| [bunny](https://github.com/stelcodes/bunny.yazi)                               | Bookmarks ("hops") to jump to                             |
| [relative-motions](https://github.com/hurricaane/relative-motions.yazi)        | Vim-like relative line numbers and counts (`5j`), my fork |
| [starship](https://github.com/Rolv-Apneseth/starship.yazi)                     | Starship prompt in the header                             |
| [smart-enter](https://github.com/yazi-rs/plugins/tree/main/smart-enter.yazi)   | `l` enters a directory or opens a file                    |
| [smart-paste](https://github.com/yazi-rs/plugins/tree/main/smart-paste.yazi)   | `p` pastes into the hovered directory                     |
| [jump-to-char](https://github.com/yazi-rs/plugins/tree/main/jump-to-char.yazi) | `f` jumps to the next file starting with a character      |
| [mount](https://github.com/yazi-rs/plugins/tree/main/mount.yazi)               | Mount / unmount / eject drives                            |
| [chmod](https://github.com/yazi-rs/plugins/tree/main/chmod.yazi)               | Change permissions of the selected files                  |
| [ouch](https://github.com/ndtoan96/ouch.yazi)                                  | Archive preview and compression                           |
| [piper](https://github.com/yazi-rs/plugins/tree/main/piper.yazi)               | Uses a shell command as a previewer (glow, eza)           |
| [toggle-pane](https://github.com/yazi-rs/plugins/tree/main/toggle-pane.yazi)   | Maximize / restore the preview pane                       |
| [mime-ext](https://github.com/yazi-rs/plugins/tree/main/mime-ext.yazi)         | File types from extensions (faster than `file`)           |

The status bar also shows the **symlink target** of the hovered file (left) and its **owner and group** (right).

## Key bindings

Forgot a key? Press `~` (or `F1`) for the full list, then `f` to filter it. Multi-key bindings (`g…`, `c…`, `,…`, `m…`, `t…`) show a popup of their continuations after the first key.

Vim-like defaults (`h/j/k/l`, `gg`/`G`, `y`/`x`/`p`, `d` to trash, `D` to delete, `a` to create, `A` to bulk create, `r` to rename, `s`/`S` to search with fd/rg, `z`/`Z` for fzf/zoxide, `tt` new tab, `tr` rename tab, `gt` trash bin). Overrides and additions:

| Keys      | Action                                                                                        |
| --------- | --------------------------------------------------------------------------------------------- |
| `l`       | Enter the directory or open the file (smart-enter)                                            |
| `p`       | Paste into the hovered directory, or the current one (smart-paste)                            |
| `y`       | Yank, and also copy the files as `file://` URIs to the clipboard, so they paste into GUI apps |
| `f`       | Jump to char                                                                                  |
| `F`       | Filter files (default `f`)                                                                    |
| `1`–`9`   | Relative motion count, then `j`/`k`, `gg`, `h`/`l`, `yy`/`dd`/`xx`, `gt` (e.g. `3j`, `10gg`)  |
| `t1`–`t9` | Switch to tab N (default `1`–`9`; `Alt-N` is taken by tmux)                                   |
| `;`       | Bunny hops menu (`:` still runs a shell command)                                              |
| `'`       | Bunny hops, fuzzy search                                                                      |
| `T`       | Maximize / restore the preview pane                                                           |
| `C`       | Compress the selection (ouch)                                                                 |
| `cm`      | chmod the selection                                                                           |
| `M`       | Mount menu                                                                                    |
| `gr`      | Go to the root of the git repository                                                          |
| `!`       | Open a shell here                                                                             |
| `Esc`     | Cancel an input box directly (no vi normal mode in inputs)                                    |

### Bunny hops

Defined in `init.lua` (`hops` table); `;` opens them.

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

Bunny also offers the open tabs, `<Enter>` to create a temporary hop to the current directory, and `<Space>` for fuzzy search.

## Theme

The [catppuccin-mocha](https://github.com/yazi-rs/flavors/tree/main/catppuccin-mocha.yazi) flavor, for both dark and light terminals. The header uses `starship.toml` from this directory: a single line, since the header only shows the first line of the prompt.
