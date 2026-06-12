-- All mini plugins configuration here
-- Helper functions ===========================================================
local now, now_if_args, later = Config.now, Config.now_if_args, Config.later

-- Mini Icons
now(function()
	local ext3_blocklist = { scm = true, txt = true, yml = true }
	local ext4_blocklist = { json = true, yaml = true }
	require("mini.icons").setup({
		extension = {
			yaml = { glyph = " ", hl = "MiniIconsRed" },
			["yaml.ansible"] = { glyph = "󱂚 ", hl = "MiniIconsRed" },
		},
		file = {
			["%.env%.[%w_.-]+"] = { glyph = "", hl = "MiniIconsYellow" },
			[".keep"] = { glyph = "󰊢 ", hl = "MiniIconsGrey" },
			["devcontainer.json"] = { glyph = " ", hl = "MiniIconsAzure" },
			[".eslintrc.js"] = { glyph = "󰱺 ", hl = "MiniIconsYellow" },
			[".node-version"] = { glyph = " ", hl = "MiniIconsGreen" },
			[".prettierrc"] = { glyph = " ", hl = "MiniIconsPurple" },
			[".yarnrc.yml"] = { glyph = " ", hl = "MiniIconsBlue" },
			["eslint.config.js"] = { glyph = "󰱺 ", hl = "MiniIconsYellow" },
			["package.json"] = { glyph = " ", hl = "MiniIconsGreen" },
			["tsconfig.json"] = { glyph = " ", hl = "MiniIconsAzure" },
			["tsconfig.build.json"] = { glyph = " ", hl = "MiniIconsAzure" },
			["yarn.lock"] = { glyph = " ", hl = "MiniIconsBlue" },
		},
		use_file_extension = function(ext, _)
			return not (ext3_blocklist[ext:sub(-3)] or ext4_blocklist[ext:sub(-4)])
		end,
	})
	later(MiniIcons.mock_nvim_web_devicons)
	later(MiniIcons.tweak_lsp_kind)
end)

-- Mini Files
now_if_args(function()
	local mf = require("mini.files")
	mf.setup({
		mappings = {
			go_in = "",
			go_in_plus = "l",
			go_out = "",
			go_out_plus = "h",
		},
		options = {
			permanent_delete = false,
		},
		windows = {
			preview = true,
			width_focus = 60,
			width_preview = 80,
		},
	})
	local add_marks = function()
		MiniFiles.set_bookmark("c", vim.fn.stdpath("config"), { desc = "Config" })
		local vimpack_plugins = vim.fn.stdpath("data") .. "/site/pack/core/opt"
		MiniFiles.set_bookmark("p", vimpack_plugins, { desc = "Plugins" })
		MiniFiles.set_bookmark("w", vim.fn.getcwd, { desc = "Working directory" })
	end
	Config.new_autocmd("User", "MiniFilesExplorerOpen", add_marks, "Add bookmarks")
	local line_numbers = function(args)
		local win = vim.wo[args.data.win_id]
		win.number = true
		win.relativenumber = true
	end
	Config.new_autocmd("User", "MiniFilesWindowUpdate", line_numbers, "Add relative line numbers")
	local show_dotfiles = true
  -- stylua: ignore
  local filter_show = function(fs_entry) return true end
	local filter_hide = function(fs_entry)
		return not vim.startswith(fs_entry.name, ".")
	end
	local toggle_dotfiles = function()
		show_dotfiles = not show_dotfiles
		local new_filter = show_dotfiles and filter_show or filter_hide
		mf.refresh({ content = { filter = new_filter } })
	end
	local map_split = function(buf_id, lhs, direction)
		local rhs = function()
			local new_target_window
			local cur_target_window = mf.get_explorer_state().target_window
			if cur_target_window ~= nil then
				vim.api.nvim_win_call(cur_target_window, function()
					vim.cmd("belowright " .. direction .. " split")
					new_target_window = vim.api.nvim_get_current_win()
				end)
				mf.set_target_window(new_target_window)
				mf.go_in({ close_on_file = true })
			end
		end
		local desc = "Open in " .. direction .. " split and close"
		vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
	end
	local callback = function(args)
		local buf_id = args.data.buf_id
		vim.keymap.set("n", "g.", toggle_dotfiles, { buffer = buf_id, desc = "Toggle hidden files" })
		map_split(buf_id, "<M-_>", "horizontal")
		map_split(buf_id, "<M-|>", "vertical")
	end
	Config.new_autocmd("User", "MiniFilesBufferCreate", callback, "Add toggle dotfiles mappings and split mappings")
end)

-- Mini Extras
-- stylua: ignore
later(function() require("mini.extra").setup() end)

-- Mini A/I
later(function()
	local ai = require("mini.ai")
	ai.setup({
		custom_textobjects = {
			o = ai.gen_spec.treesitter({
				a = { "@block.outer", "@conditional.outer", "@loop.outer" },
				i = { "@block.inner", "@conditional.inner", "@loop.inner" },
			}),
			B = MiniExtra.gen_ai_spec.buffer(),
			f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
			c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
			t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
			d = { "%f[%d]%d+" },
			e = {
				{ "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
				"^().*()$",
			},
		},
		search_method = "cover",
	})
end)

-- Mini Comment
-- stylua: ignore
later(function() require("mini.comment").setup() end)

-- Mini Operators
later(function()
	require("mini.operators").setup({
		sort = {
			prefix = "go",
		},
	})
	vim.keymap.set("n", "(", "gxiagxila", { remap = true, desc = "Swap arg left" })
	vim.keymap.set("n", ")", "gxiagxina", { remap = true, desc = "Swap arg right" })
end)

-- Mini Pairs
later(function()
	require("mini.pairs").setup({
		modes = { insert = true, command = true, terminal = false },
		skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
		skip_ts = { "string" },
		skip_unbalanced = true,
		markdown = true,
	})
end)

-- Mini Splitjoin
later(function()
	require("mini.splitjoin").setup({
		mappings = {
			toggle = "gJ",
		},
	})
end)

-- Mini surround
later(function()
	require("mini.surround").setup({
		mappings = {
			add = "gsa",
			delete = "gsd",
			find = "gsf",
			find_left = "gsF",
			highlight = "gsh",
			replace = "gsr",
			update_n_lines = "gsn",
		},
	})
end)
