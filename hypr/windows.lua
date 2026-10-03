-- --- Steam Fixes ---

-- 1. Force Main Steam Window to TILE
hl.window_rule({ match = { class = "^(steam)$", title = "^(Steam)$" }, tile = true })

-- 2. Ensure popups float (Friends, Settings, etc.)
hl.window_rule({
	match = { class = "^(steam)$", title = "^(Friends List|Settings|Properties)$" },
	float = true,
})

-- --- Game Fixes (Excluding Steam) ---

-- 1. Force Opacity (Fixes transparent/ghostly games)
hl.window_rule({ match = { xwayland = true }, opacity = "1.0 override 1.0 override" })

-- 2. Force Fullscreen for Games
hl.window_rule({ match = { xwayland = true }, fullscreen = true })
-- Steam itself is excluded (later rules take precedence)
hl.window_rule({ match = { class = "^(steam)$" }, fullscreen = false })
