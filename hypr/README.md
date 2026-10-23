# Hyprland

Configuration of [Hyprland](https://hypr.land), the Wayland compositor of [Omarchy](https://omarchy.org). Linked to `~/.config/hypr` (desktop profile).

This is **not a full Hyprland config**: Omarchy 4 ("Quattro") configures Hyprland in **Lua** and ships the defaults (bindings, rules, theme, apps). These files only hold my **overrides**, loaded after Omarchy's defaults, so Omarchy updates keep improving the base without overwriting them.

<!-- toc -->

- [Requirements](#requirements)
- [Structure](#structure)
- [Monitors](#monitors)
- [Input](#input)
- [Key bindings](#key-bindings)
  - [Navigation mode](#navigation-mode)
- [Look and feel](#look-and-feel)
- [Window rules](#window-rules)
- [Autostart](#autostart)
- [Tips](#tips)

<!-- tocstop -->

## Requirements

- Omarchy 4 (the config loads `$OMARCHY_PATH/default/hypr/bootstrap.lua`, `/usr/share/omarchy` by default)
- The `us-fr` keyboard layout from [xkb](../xkb/README.md)
- `solaar` (Logitech receiver), `jq`, `voxtype`, `sealwax`, `signal-desktop`

## Structure

```text
hypr/
├── hyprland.lua             # Entry point: Omarchy bootstrap and defaults, then my files
├── monitors.lua             # Screens
├── input.lua                # Keyboard, touchpad, touchpad toggle state
├── bindings.lua             # Key bindings and the navigation submap
├── looknfeel.lua            # Rounding, blur, layer blur, animations
├── windows.lua              # Window rules (Steam, games)
├── autostart.lua            # Extra programs started at login
├── scripts/
│   └── toggle-touchpad.sh   # Turns the touchpad and pointing stick on/off
├── .luarc.json              # Lua LSP settings (Hyprland API types)
└── old-conf/                # Pre-Quattro hyprlang config (*.conf), not loaded
```

`hyprland.lua` loads, in order: Omarchy's bootstrap and defaults (`default.hypr.omarchy`), then `monitors`, `input`, `bindings`, `looknfeel`, `autostart`, `windows`, and finally Omarchy's dynamic toggles. The `hl` table is Hyprland's Lua API, and `o` holds Omarchy's helpers (`o.bind`, `o.window`, `o.launch_on_start`).

## Monitors

| Output     | Screen                | Mode            | Scale |
| ---------- | --------------------- | --------------- | ----- |
| `eDP-1`    | Laptop                | 1920×1080 @ 60  | 1.3   |
| `HDMI-A-1` | iiyama monitor (home) | 1920×1080 @ 165 | 1     |

Both use `position = "auto"`. `GDK_SCALE` is `1`.

## Input

- **Keyboard layouts**: `us-fr` (US QWERTY with French characters on AltGr, see [xkb](../xkb/README.md)) and `us` `intl`. `Super-Shift-K` switches between them.
- **Caps Lock is a Ctrl key** (`ctrl:nocaps`).
- Key repeat: rate 40, delay 600 ms. Num Lock off at startup.
- **Touchpad**: natural scrolling, two-finger click for right click, scroll factor 0.4, disabled while typing.
- **Scroll speed per app**: 1.5 in Alacritty/kitty/foot, 0.2 in Ghostty.
- **Touchpad toggle**: `Ctrl-;` runs `scripts/toggle-touchpad.sh`, which disables or enables every `syna30be*` device (touchpad and pointing stick) and saves the disabled ones in `~/.local/state/toggle-touchpad/disabled-devices`. `input.lua` reads that file on every reload, so the touchpad stays off across config reloads and reboots.

## Key bindings

Omarchy's defaults stay active; see them all with `omarchy menu keybindings --print`. My changes:

| Keys                  | Action                                    |
| --------------------- | ----------------------------------------- |
| `Super-Shift-G`       | WhatsApp (web app). Swapped with Signal   |
| `Super-Shift-Alt-G`   | Signal                                    |
| `Super-Shift-E`       | Sealwax (email client)                    |
| `Super-Shift-K`       | Next keyboard layout                      |
| `Super-H`             | Voice dictation (`voxtype record toggle`) |
| `Super-.`             | Emoji picker (Omarchy shell)              |
| `Shift-XF86AudioNext` | Previous track (also on the lock screen)  |
| `Ctrl-;`              | Toggle the touchpad                       |
| `Super-N`             | [Navigation mode](#navigation-mode)       |

Unbound Omarchy defaults: `Super-Shift-C`, `Super-Shift-E`, `Super-Shift-Alt-E` (the last two are replaced by Sealwax), and the original `Super-Shift-G` / `Super-Shift-Alt-G` before rebinding them.

### Navigation mode

`Super-N` enters a **submap** to manage windows with vim keys, without holding Super. The active window border turns **peach** while it is on.

| Keys             | Action                                                          |
| ---------------- | --------------------------------------------------------------- |
| `h` `j` `k` `l`  | Move focus left / down / up / right                             |
| `Shift-h/j/k/l`  | Swap the window in that direction                               |
| `Ctrl-h/j/k/l`   | Narrower / taller / shorter / wider (50 px, repeats while held) |
| `Esc` or `Super` | Leave the mode                                                  |

- With `ctrl:nocaps`, resizing is Caps Lock + `h/j/k/l`.
- `Super` leaves on **press**, not release (otherwise releasing the Super of `Super-N` would leave immediately), and the press still goes through, so `Super-<key>` right after works as usual.
- The border color in use is saved when entering and restored when leaving, so a theme change is respected.

## Look and feel

Tuned for the [catppuccin-glass](../omarchy/README.md#theme) theme:

- Rounded corners (8, `rounding_power = 4`), no dimming of inactive windows.
- **Light blur** (size 3, 2 passes, no xray, no noise), so the wallpaper stays visible behind transparent windows.
- **Blur on the Omarchy shell layers**: bar, menu, notifications, clipboard and keyboard panel. `ignore_alpha` keeps fully transparent pixels unblurred.
- **Custom animations**: smooth bezier curves (`water`, `cascade`, `stream`, `flow`, `ripple`…) for windows and fades, and a "pop in" for layers (menus, notifications).

## Window rules

- **Steam**: the main window is tiled, Friends List / Settings / Properties float.
- **Games** (every XWayland window except Steam): forced opaque (fixes see-through games) and fullscreen.

## Autostart

- `solaar --window=hide`: Logitech device manager, in the tray.

## Tips

- **Reload**: `hyprctl reload`, then `hyprctl configerrors` to see errors.
- **Monitor names**: `hyprctl monitors all`. **Layer names** (for blur rules): `hyprctl layers`.
- **Omarchy's defaults** to read before overriding something: `$OMARCHY_PATH/default/hypr/`.
- The Lua LSP in Neovim knows the Hyprland API through `.luarc.json`.
