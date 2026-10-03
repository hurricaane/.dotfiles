-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")

-- Unbindings
hl.unbind("SUPER + SHIFT + C")
hl.unbind("SUPER + SHIFT + E")
hl.unbind("SUPER + SHIFT + ALT + E")
-- invert WhatsApp and Signal bindings
hl.unbind("SUPER + SHIFT + G")
hl.unbind("SUPER + SHIFT + ALT + G")

-- Bindings
-- Whatsapp and Signal
o.bind("SUPER + SHIFT + G", "WhatsApp", [[omarchy-launch-or-focus-webapp WhatsApp "https://web.whatsapp.com/"]])
o.bind("SUPER + SHIFT + ALT + G", "Signal", [[omarchy-launch-or-focus ^signal$ "uwsm-app -- signal-desktop"]])
-- Media - previous track
hl.bind(
	"SHIFT + XF86AudioNext",
	hl.dsp.exec_cmd("playerctl previous"),
	{ locked = true, description = "Previous track" }
)
-- Toggle touchpad
o.bind("SUPER + SHIFT + T", "Toggle touchpad", "~/dotfiles/hypr/scripts/toggle-touchpad.sh")
-- Voice activation (works with Logitech Keyboard)
o.bind("SUPER + H", nil, "voxtype record toggle")
-- Emojis (works with Logitech keyboard)
o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")
