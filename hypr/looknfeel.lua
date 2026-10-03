-- Change the default Omarchy look'n'feel.

-- https://wiki.hypr.land/Configuring/Basics/Variables/#general
-- hl.config({
--   general = {
--     -- No gaps between windows or borders.
--     gaps_in = 0,
--     gaps_out = 0,
--     border_size = 0,
--
--     -- Change to niri-like side-scrolling layout.
--     layout = "scrolling",
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#decoration
-- hl.config({
--   decoration = {
--     -- Use round window corners.
--     rounding = 8,
--
--     -- Dim unfocused windows (0.0 = no dim, 1.0 = fully dimmed).
--     dim_inactive = true,
--     dim_strength = 0.15,
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#animations
-- hl.config({
--   animations = {
--     -- Disable all animations.
--     enabled = false,
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#layout
-- hl.config({
--   layout = {
--     -- Avoid overly wide single-window layouts on wide screens.
--     single_window_aspect_ratio = { 1, 1 },
--   },
-- })

-- https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/
-- hl.config({
--   scrolling = {
--     -- See only one column per screen instead of two.
--     column_width = 0.97,
--   },
-- })

hl.config({
	decoration = {
		-- Use round window corners.
		rounding = 8,
		rounding_power = 4.0, -- from the old theme; uncomment if hyprctl configerrors accepts it
		dim_inactive = false,

		-- Lighter blur so the wallpaper stays visible (old theme: size 7, passes 3, brightness 0.85)
		blur = {
			enabled = true,
			size = 3,
			passes = 2,
			xray = false,
			noise = 0,
			contrast = 1,
			brightness = 1.0,
		},
	},

	animations = {
		enabled = true,
	},
})

-- Glass blur on shell surfaces (names from `hyprctl layers`)
-- ignore_alpha: pixels at or below this opacity are not blurred
hl.layer_rule({ match = { namespace = "omarchy-bar" }, blur = true, ignore_alpha = 0.1 })
hl.layer_rule({ match = { namespace = "omarchy-keyboard-panel" }, blur = true, ignore_alpha = 0.2 })
hl.layer_rule({ match = { namespace = "omarchy-menu" }, blur = true, ignore_alpha = 0.3 })
hl.layer_rule({ match = { namespace = "omarchy-notifications" }, blur = true, ignore_alpha = 0.2 })

-- Animation curves (catppuccin-glass)
hl.curve("water", { type = "bezier", points = { { 0.22, 0.9 }, { 0.36, 1.0 } } })
hl.curve("flow", { type = "bezier", points = { { 0.25, 0.1 }, { 0.25, 1.0 } } })
hl.curve("ripple", { type = "bezier", points = { { 0.33, 0.0 }, { 0.2, 1.0 } } })
hl.curve("stream", { type = "bezier", points = { { 0.4, 0.0 }, { 0.4, 1.0 } } })
hl.curve("cascade", { type = "bezier", points = { { 0.19, 1.0 }, { 0.22, 1.0 } } })
hl.curve("md3_standard", { type = "bezier", points = { { 0.2, 0.0 }, { 0.0, 1.0 } } })
hl.curve("md3_accel", { type = "bezier", points = { { 0.3, 0.0 }, { 0.8, 0.15 } } })
hl.curve("overshot", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

-- Animations
hl.animation({ leaf = "windows", enabled = true, speed = 3.0, bezier = "water" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 2.8, bezier = "cascade" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 2.4, bezier = "stream" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 1.6, bezier = "flow" })
hl.animation({ leaf = "fade", enabled = true, speed = 2.4, bezier = "water" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 2.0, bezier = "cascade" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.8, bezier = "ripple" })
hl.animation({ leaf = "fadeDim", enabled = true, speed = 2.0, bezier = "water" })
hl.animation({ leaf = "fadeSwitch", enabled = true, speed = 1.4, bezier = "flow" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 1.5, bezier = "overshot", style = "popin 80%" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.3, bezier = "md3_accel", style = "popin 90%" })
hl.animation({ leaf = "layers", enabled = true, speed = 1.5, bezier = "md3_standard" })
