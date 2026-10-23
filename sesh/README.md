# sesh

Configuration of [sesh](https://github.com/joshmedeski/sesh), a tmux session manager. It lists the open tmux sessions, the zoxide directories and the sessions defined here, and connects to one (creating the tmux session when needed). Linked to `~/.config/sesh`.

## Requirements

- `sesh`, `tmux`, `zoxide`
- `eza` (directory preview), `nvim` (startup command)
- [Television](../television/README.md): the picker UI

## How I use it

sesh doesn't have its own picker here: **Television** shows it, with the `sesh` channel (`television/cable/sesh.toml`).

| Where                                | How                                           |
| ------------------------------------ | --------------------------------------------- |
| Terminal opened with no tmux session | fish opens `tv sesh` automatically            |
| In fish                              | `s` (abbreviation for `sesh-sessions`)        |
| In tmux                              | `prefix t` (popup), `prefix l` (last session) |

In the picker, `Ctrl-s` cycles between sources (all, tmux sessions, configs, zoxide, directories under `~`), `Enter` connects and `Ctrl-d` kills the selected tmux session. See [television](../television/README.md#sesh).

## Configuration

`sesh.toml`:

- `blacklist = ["scratch"]`: the `scratch` session is never listed.
- `cache = false`: the list is always fresh.
- **Default session** (any directory without its own entry):
  - preview: `eza` long listing with icons and git status;
  - startup command: Neovim with the Snacks file picker open.

### Predefined sessions

| Session                  | Path                 | Startup command  |
| ------------------------ | -------------------- | ---------------- |
| `home`                   | `~`                  | none             |
| `downloads`              | `~/Downloads`        | `y` (yazi)       |
| `tmux configuration`     | `~/dotfiles/tmux`    | default (Neovim) |
| `sesh configuration`     | `~/dotfiles/sesh`    | `nvim sesh.toml` |
| `ghostty configuration`  | `~/dotfiles/ghostty` | `nvim config`    |
| `hyprland configuration` | `~/dotfiles/hypr`    | default (Neovim) |
| `nvim configuration`     | `~/dotfiles/nvim`    | default (Neovim) |
| `yazi configuration`     | `~/dotfiles/yazi`    | default (Neovim) |
| `fish configuration`     | `~/dotfiles/fish`    | default (Neovim) |
| `waybar configuration`   | `~/dotfiles/waybar`  | default (Neovim) |

To add one, append a `[[session]]` block with a `name` and a `path`, and optionally a `startup_command` (or `disable_startup_command = true`).
