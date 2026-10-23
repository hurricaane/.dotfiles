# Ghostty

Configuration of [Ghostty](https://ghostty.org), my terminal emulator. Linked to `~/.config/ghostty` (desktop profile).

## Requirements

- Ghostty, on Omarchy (the colors come from the current Omarchy theme)
- `ttf-cascadia-mono-nerd` (CaskaydiaCove Nerd Font), in `packages/desktop.txt`
- fish

## Files

| File         | Content                                       |
| ------------ | --------------------------------------------- |
| `config`     | Main config                                   |
| `blur.css`   | GTK CSS that asks Hyprland to blur the window |
| `config.bak` | Old version, not used                         |

## Configuration

### Theme and look

- **Colors** are not set here: `config-file = ?"~/.local/state/omarchy/current/theme/ghostty.conf"` loads the current Omarchy theme's colors, so changing the theme in Omarchy recolors the terminal. The `?` makes the file optional.
- **Font**: CaskaydiaCove Nerd Font, size 10, cells 30 % taller (`adjust-cell-height`).
- **Glass**: `background-opacity = 0.98`, and `blur.css` requests the background blur from the compositor. Since GTK 4.24, Hyprland only blurs where the app asks for it (`ext-background-effect`), so without this file the window isn't blurred.
- `faint-opacity = 0.8`: dimmed text is unreadable at the default 50 % on the glass theme.
- No window decorations, 14 px padding, bar cursor, mouse hidden while typing, no resize overlay.

### Shell

- Runs `fish --login --interactive`. New windows keep the working directory.
- `term = xterm-256color`, so remote hosts and older tools don't need Ghostty's terminfo.
- Shell integration: `ssh-env`, `sudo`; the cursor shape and window title are left to fish.

### Key bindings

| Keys                           | Action                                                               |
| ------------------------------ | -------------------------------------------------------------------- |
| `Ctrl-]`                       | Reload the config                                                    |
| `F11`                          | Fullscreen                                                           |
| `Shift-Insert` / `Ctrl-Insert` | Paste / copy                                                         |
| `Shift-Enter`                  | Sends `Esc` + `Enter` (newline in Claude Code and other TUIs)        |
| `Alt-Shift-Enter`              | Sends the CSI-u sequence, so tmux can tell it apart from `Alt-Enter` |
| `Super-Ctrl-Shift-Alt-arrows`  | Resize Ghostty splits                                                |

### Other

- `confirm-close-surface = false`: closing a window never asks.
- `mouse-scroll-multiplier = 0.95`.
- `async-backend = epoll`: fixes slowness under Hyprland ([ghostty#3224](https://github.com/ghostty-org/ghostty/discussions/3224)).
- Touchpad scroll speed in Ghostty is lowered on the Hyprland side (`hypr/input.lua`).
