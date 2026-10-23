# tmux

Configuration of [tmux](https://github.com/tmux/tmux), which holds every terminal session: fish starts inside it automatically (see [fish](../fish/README.md#tmux-auto-start)), and sessions are managed with [sesh](../sesh/README.md).

Only `tmux.conf` is linked, to `~/.config/tmux/tmux.conf`. It sources the theme straight from the repo (`~/dotfiles/tmux/tmux-catppuccin-theme.conf`).

<!-- toc -->

- [Requirements](#requirements)
- [Installation](#installation)
- [Files](#files)
- [Settings](#settings)
- [Key bindings](#key-bindings)
  - [Without prefix](#without-prefix)
  - [With prefix](#with-prefix)
  - [Copy mode](#copy-mode)
- [Popups](#popups)
- [Plugins](#plugins)
- [Theme](#theme)

<!-- tocstop -->

## Requirements

- tmux **3.2** or later (`%hidden` variables). Written for tmux 3.8.
- `fish` (default shell), `wl-copy` (copy mode), and for the popups: `sesh`, `tv`, `lazygit`, `workmux`
- [tpack](https://github.com/tmuxpack/tpack) for the plugins (`tpack-bin` in `packages/cli.txt`)
- A Nerd Font for the icons

## Installation

```sh
mkdir -p ~/.config/tmux
ln -s ~/dotfiles/tmux/tmux.conf ~/.config/tmux/tmux.conf   # or `just link`
yay -S tpack-bin                                           # or `just install`
```

Then start tmux and press `prefix I` to install the plugins.

## Files

| File                                 | Used | Content                                              |
| ------------------------------------ | ---- | ---------------------------------------------------- |
| `tmux.conf`                          | yes  | Main config                                          |
| `tmux-catppuccin-theme.conf`         | yes  | Status bar, window tabs, borders, messages (sourced) |
| `tmux-tokyonight-theme.conf`         | no   | Old theme                                            |
| `tmux-windows.conf`, `tmux-old.conf` | no   | Old configs                                          |

## Settings

- **Prefix**: `Ctrl-a` (instead of `Ctrl-b`). `Ctrl-a Ctrl-a` sends a literal `Ctrl-a`.
- **Shell**: `/usr/bin/fish`.
- **Colors**: true color (`RGB`), undercurl and colored underlines (for Neovim diagnostics).
- **Windows and panes** start at 1, windows are renumbered when one closes.
- **Status bar** at the top, and **pane borders show a title line**, used to display copy mode (see [Copy mode](#copy-mode)).
- `detach-on-destroy off`: killing a session switches to another one instead of detaching.
- `escape-time 0`, `focus-events on`, `mouse on`, 10 000 lines of history.
- `allow-passthrough all` (images in Neovim/yazi) and OSC 52 clipboard (`set-clipboard on`, `clipboard` terminal feature), so yanks in a remote Neovim reach the local clipboard.
- `main-pane-width 85`: room for a line number gutter and 80 columns in the `main-vertical` layout.

## Key bindings

### Without prefix

| Keys              | Action                              |
| ----------------- | ----------------------------------- |
| `Alt-h/j/k/l`     | Move to the pane left/down/up/right |
| `Alt-1` … `Alt-9` | Go to window 1–9                    |
| `Alt-y`           | Enter copy mode                     |

### With prefix

| Keys       | Action                                        |
| ---------- | --------------------------------------------- |
| `\` / `h`  | Split side by side, in the current path       |
| `-` / `v`  | Split top/bottom, in the current path         |
| `\|` / `_` | Full-width / full-height split                |
| `n`        | New window in the current path                |
| `m`        | Zoom the pane                                 |
| `x`        | Kill the pane (no confirmation)               |
| `W` / `Q`  | Kill the session / the server                 |
| `l`        | Last session (`sesh last`)                    |
| `t`        | sesh picker (popup)                           |
| `g`        | lazygit in the current path (popup)           |
| `w`        | workmux dashboard (popup)                     |
| `f` / `F`  | Floating pane / its menu (tmux-floax)         |
| `o` / `i`  | Copy mode at the previous / next shell prompt |
| `r`        | Reload the config                             |
| `I` / `U`  | Install / update plugins (tpack)              |
| `M-u`      | Remove plugins no longer in the config        |
| `T`        | tpack TUI: install, update, browse plugins    |

### Copy mode

Vi keys (`mode-keys vi`):

| Keys      | Action                                             |
| --------- | -------------------------------------------------- |
| `v`       | Start the selection                                |
| `y`       | Copy to the Wayland clipboard (`wl-copy`) and exit |
| `/` / `?` | Incremental search down / up                       |
| `O` / `I` | Previous / next shell prompt (repeatable)          |

- Entering copy mode shows the position in the pane's top border: `-- COPY --` on the left, and on the right the search result count and the line position (`[offset/history size]`).
- Releasing a mouse drag keeps copy mode open, so you can adjust the selection.

## Popups

Bound on the prefix, all with rounded borders and a colored title:

- `prefix t`: **sesh** through Television (`tv sesh`), 80 %.
- `prefix g`: **lazygit** in the current pane's directory, 95 %.
- `prefix w`: **workmux dashboard**, 95 %.

## Plugins

Managed with [tpack](https://github.com/tmuxpack/tpack), a drop-in replacement for tpm (same `@plugin` syntax and keys). `tpack install`, `tpack update all` and `tpack clean` do the same from a shell:

- [tmux-sensible](https://github.com/tmux-plugins/tmux-sensible): common defaults
- [tmux-floax](https://github.com/omerxx/tmux-floax): a floating pane that keeps its content, toggled with `prefix f` (90 % of the screen)

## Theme

`tmux-catppuccin-theme.conf` builds a minimal Catppuccin Mocha status bar on a **transparent background**:

- left: the session name, green, or maroon while the prefix is active;
- center: the windows, the current one in blue and underlined (with a zoom icon when zoomed);
- right: the time.

Popups also keep a transparent background (tmux 3.8 gives them a grey one by default).
