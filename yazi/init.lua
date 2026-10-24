-- Full border plugin
require("full-border"):setup({
	set = "rounded",
})

-- MIME types from file extensions instead of file(1), much faster in large directories.
-- Unknown extensions still fall back to file(1).
require("mime-ext"):setup()
require("mime-ext.local"):setup({
	fallback_file1 = true,
})

-- Git plugin
require("git"):setup({
	order = 1500,
})

-- Bunny hop plugin
require("bunny"):setup({
	hops = {
		{ key = "/", path = "/" },
		{ key = "t", path = "/tmp" },
		{ key = "c", path = "~/.config", desc = "Config files" },
		{ key = { "h", "h" }, path = "~", desc = "Home" },
		{ key = { "h", "k" }, path = "~/Desktop", desc = "Desktop" },
		{ key = { "h", "d" }, path = "~/Downloads/", desc = "Downloads" },
		{ key = { "h", "D" }, path = "~/Documents/", desc = "Documents" },
		{ key = { "h", "p" }, path = "~/Pictures/", desc = "Pictures" },
		{ key = { "l", "s" }, path = "~/.local/share", desc = "Local share" },
		{ key = { "l", "b" }, path = "~/.local/bin", desc = "Local bin" },
		{ key = { "l", "t" }, path = "~/.local/state", desc = "Local state" },
		-- key and path attributes are required, desc is optional
	},
	desc_strategy = "path", -- If desc isn't present, use "path" or "filename", default is "path"
	ephemeral = true, -- Enable ephemeral hops, default is true
	tabs = true, -- Enable tab hops, default is true
	notify = false, -- Notify after hopping, default is false
	fuzzy_cmd = "fzf", -- Fuzzy searching command, default is "fzf"
})

-- Relative motion plugin
require("relative-motions"):setup({
	show_numbers = "relative",
	show_motions = true,
	only_motions = false,
	enter_mode = "first",
})

-- Starship plugin
-- Uses a single-line starship config: the header only shows the first line
require("starship"):setup({
	config_file = "~/.config/yazi/starship.toml",
})

-- Smart enter plugin
require("smart-enter"):setup({
	open_multi = true,
})

-- Show symlink in status bar
---@diagnostic disable-next-line: undefined-global
Status:children_add(function(self)
	local h = self._current.hovered
	if h and h.link_to then
		return " -> " .. tostring(h.link_to)
	else
		return ""
	end
end, 3300, Status.LEFT)

-- Show user and group in status bar
Status:children_add(function()
	local h = cx.active.current.hovered
	if not h or ya.target_family() ~= "unix" then
		return ""
	end

	return ui.Line({
		ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"),
		":",
		ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"),
		" ",
	})
end, 500, Status.RIGHT)
