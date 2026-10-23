# XKB

A custom keyboard layout, `us-fr`: **US QWERTY with French characters on AltGr** (right Alt). Linked to `~/.config/xkb` (desktop profile), where libxkbcommon (and so Hyprland) finds user layouts.

The point: keep the US layout for code (`'` and `"` are **not** dead keys, unlike `us` `intl`), and still type French without switching layouts.

## Usage

Hyprland loads it as the first layout in [hypr/input.lua](../hypr/input.lua):

```lua
kb_layout = "us-fr,us",
kb_variant = ",intl",
```

`Super-Shift-K` switches to `us` `intl`, the bar shows the current layout.

## Layout

`symbols/us-fr` includes `us(basic)` and uses the right Alt as AltGr (`level3(ralt_switch)`).

| Key | Normal / Shift | AltGr                                                    | AltGr + Shift                            |
| --- | -------------- | -------------------------------------------------------- | ---------------------------------------- |
| `e` | `e` `E`        | `é`                                                      | `É`                                      |
| `w` | `w` `W`        | `è`                                                      | `È`                                      |
| `a` | `a` `A`        | `à`                                                      | `À`                                      |
| `u` | `u` `U`        | `ù`                                                      | `Ù`                                      |
| `c` | `c` `C`        | `ç`                                                      | `Ç`                                      |
| `o` | `o` `O`        | `œ`                                                      | `Œ`                                      |
| `[` | `[` `{`        | `«`                                                      |                                          |
| `]` | `]` `}`        | `»`                                                      |                                          |
| `'` | `'` `"`        | `’`                                                      | dead `¨`, then `e` `i` `u` → `ë` `ï` `ü` |
| `2` | `2` `@`        | `²`                                                      |                                          |
| `3` | `3` `#`        | `³`                                                      |                                          |
| `5` | `5` `%`        | `€`                                                      |                                          |
| `6` | `6` `^`        | dead `^`, then `a` `e` `i` `o` `u` → `â` `ê` `î` `ô` `û` |                                          |
| `.` | `.` `>`        | `…`                                                      |                                          |

Every other key has nothing on AltGr.

## Testing a change

After editing `symbols/us-fr`, reload Hyprland (`hyprctl reload`) and check the layout is still found: `hyprctl configerrors` and `hyprctl devices` (active keymap of the keyboard).
