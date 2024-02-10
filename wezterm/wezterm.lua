local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux

wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

-- Wezterm Configuration
return {
	-- Color scheme (Multiple ones I like hehe)
	-- color_scheme = 'Chalk',
	-- color_scheme = 'Firewatch',
	-- color_scheme = "Helios (base16)",
	-- color_scheme = "Highway",
	-- color_scheme = "palenight (Gogh)",
	color_scheme = "Catppuccin Mocha",
	-- Font
	font = wezterm.font({
		family = "Space Mono Nerd Font",
		harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
	}),
	font_size = 11.0,
	-- Disable tab bar
	enable_tab_bar = false,
	-- Remove window padding
	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
	-- Borderless window
	window_decorations = "RESIZE",
	-- enable scrollbar
	enable_scroll_bar = false,
	-- Dead Keys
	use_dead_keys = false,
	-- Cursor Style
	default_cursor_style = "SteadyBar",
	-- Enable cursor dynamic color change
	force_reverse_video_cursor = true,
	-- Disable prompt when closing windows
	window_close_confirmation = "NeverPrompt",
	-- Key Bindings for Wezterm
	disable_default_key_bindings = true,
	keys = {
		-- Copy & Paste
		{ action = act.CopyTo("Clipboard"), mods = "CTRL|SHIFT", key = "C" },
		{ action = act.PasteFrom("Clipboard"), mods = "CTRL|SHIFT", key = "V" },
		-- Zoom in, zoom out & reset
		{ action = act.DecreaseFontSize, mods = "CTRL", key = "-" },
		{ action = act.IncreaseFontSize, mods = "CTRL", key = "=" },
		{ action = act.ResetFontSize, mods = "CTRL", key = "0" },
		-- Fullscreen
		{ action = act.ToggleFullScreen, key = "F11" },
		-- Close window
		{ action = act.CloseCurrentTab({ confirm = true }), mods = "CTRL|SHIFT", key = "W" },
	},
}
