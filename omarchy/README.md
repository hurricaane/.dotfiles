# Omarchy

User configuration of [Omarchy](https://omarchy.org), the Arch Linux + Hyprland setup this machine runs (version 4, "Quattro"). Linked to `~/.config/omarchy` (desktop profile).

Omarchy itself lives in `/usr/share/omarchy` and is updated with the system. This folder holds what Omarchy reads from the user: the shell layout, my theme, extensions and hooks. The Hyprland side is in [hypr](../hypr/README.md).

## Requirements

- Omarchy 4

## Structure

```text
omarchy/
├── shell.json            # Omarchy shell: bar layout, idle timers
├── themes/
│   └── catppuccin-glass/ # My theme
├── backgrounds/          # Extra wallpapers, by theme
├── defaults/agent        # Default AI agent for Omarchy (claude)
├── extensions/           # Omarchy menu extensions (unused templates)
├── hooks/                # Scripts run on Omarchy events
├── branding/             # Text shown in About and the screensaver
└── themed/               # Templates for app configs (unused sample)
```

## Shell

`shell.json` configures the Omarchy shell (Quickshell), which replaced Waybar:

- **Bar** at the top, not transparent (the glass effect comes from the Hyprland layer blur).
  - Left: Omarchy menu, workspaces.
  - Center: indicators, clock (`dddd HH:mm`; click for the date and week number), keyboard layout, weather, system updates.
  - Right: tray, AI agents, Bluetooth, network, audio, monitor, power.
- **Idle**: screensaver after 150 s, lock after 300 s.

## Theme

`themes/catppuccin-glass` is [Luquatic/omarchy-catppuccin-glass](https://github.com/Luquatic/omarchy-catppuccin-glass), updated for Omarchy 4: Catppuccin Mocha with a blue accent and translucent "glass" backgrounds. It provides the colors (`colors.toml`) and the files Omarchy applies to each app: Ghostty, kitty, Alacritty, btop, Neovim, Starship, VS Code, Chromium, icons and the shell, plus its wallpapers.

Select it with **Omarchy menu → Style → Theme**. Omarchy then writes the current theme to `~/.local/state/omarchy/current/theme/`, which Ghostty and other apps read.

`backgrounds/tokyo-night/` holds extra wallpapers for the Tokyo Night theme.

## Default agent

`defaults/agent` contains `claude`: the default coding agent that Omarchy launches (`omarchy default agent`, set from the Omarchy menu).

## Hooks

Scripts in `hooks/<event>.d/` run when Omarchy emits the event. Files ending in `.sample` are inactive examples from Omarchy.

| Hook                             | Active | Action                                                               |
| -------------------------------- | ------ | -------------------------------------------------------------------- |
| `post-update.d/setup-agent.hook` | yes    | After an update, invites once to pick a default agent if none is set |
| everything else (`*.sample`)     | no     | Examples: battery low, font set, theme set, post-boot weather…       |

Omarchy runs every file of `hooks/<event>.d/` with bash, except `*.sample` files: to activate a sample, drop the `.sample` suffix.

## Extensions

`extensions/menu.sh` (override functions of `omarchy-menu`) and `extensions/omarchy-menu.jsonc` (add entries to the Quickshell menu) only contain Omarchy's commented templates for now.

## Branding

`branding/about.txt` and `branding/screensaver.txt`: the ASCII art shown in About and in the screensaver.

`*.omarchy-upgrade-to-quattro.*.bak` files are backups made by the Omarchy 4 upgrade; they can be deleted.
