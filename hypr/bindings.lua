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
o.bind("CTRL + SEMICOLON", "Toggle touchpad", "~/dotfiles/hypr/scripts/toggle-touchpad.sh")
-- Voice activation (works with Logitech Keyboard)
o.bind("SUPER + H", nil, "voxtype record toggle")
-- Emojis (works with Logitech keyboard)
o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")
-- Switch keyboard layout
o.bind("SUPER + SHIFT + K", "Switch keyboard layout", "hyprctl switchxkblayout all next")

-- Navigation mode: SUPER+N enters, hjkl focus, SHIFT+hjkl swap, CTRL+hjkl resize,
-- Escape/Super exits.
-- The active border turns peach while the mode is on.
o.bind("SUPER + N", "Navigation mode (hjkl)", hl.dsp.submap("nav"))

hl.define_submap("nav", function()
	o.bind("H", "Focus left", hl.dsp.focus({ direction = "l" }))
	o.bind("J", "Focus down", hl.dsp.focus({ direction = "d" }))
	o.bind("K", "Focus up", hl.dsp.focus({ direction = "u" }))
	o.bind("L", "Focus right", hl.dsp.focus({ direction = "r" }))
	o.bind("SHIFT + H", "Swap left", hl.dsp.window.swap({ direction = "l" }))
	o.bind("SHIFT + J", "Swap down", hl.dsp.window.swap({ direction = "d" }))
	o.bind("SHIFT + K", "Swap up", hl.dsp.window.swap({ direction = "u" }))
	o.bind("SHIFT + L", "Swap right", hl.dsp.window.swap({ direction = "r" }))
	o.bind("ESCAPE", "Exit navigation mode", hl.dsp.submap("reset"))
	-- Resize with CapsLock (ctrl:nocaps) held; repeats while the key is held down.
	o.bind("CTRL + H", "Narrower", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })
	o.bind("CTRL + J", "Taller", hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true })
	o.bind("CTRL + K", "Shorter", hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })
	o.bind("CTRL + L", "Wider", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true })
	-- SUPER exits on press, not release: the release of the SUPER held for SUPER+N would exit instantly.
	-- Non-consuming so a follow-up SUPER+key still reaches the normal bindings.
	o.bind("Super_L", "Exit navigation mode", hl.dsp.submap("reset"), { ignore_mods = true, non_consuming = true })
end)

-- Save the theme's border on entry so theme changes are respected on exit.
local nav_saved_border
hl.on("keybinds.submap", function(name)
	if name == "nav" then
		nav_saved_border = nav_saved_border or hl.get_config("general.col.active_border")
		hl.config({ general = { col = { active_border = "rgba(fab387ff)" } } })
	elseif nav_saved_border then
		hl.config({ general = { col = { active_border = nav_saved_border } } })
		nav_saved_border = nil
	end
end)
