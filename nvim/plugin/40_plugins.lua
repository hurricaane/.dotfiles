-- Plugins file
-- This file is for all the other plugins that are not in the mini suite
-- Helper functions ===========================================================
local add = vim.pack.add
local now, now_if_args, later = Config.now, Config.now_if_args, Config.later

-- Snacks =====================================================================
now(function()
	add({ "https://github.com/folke/snacks.nvim" })
	local picker_options = {
		enabled = true,
		hidden = true,
		ignored = false,
		sources = {
			files = {
				hidden = true,
				ignored = false,
			},
		},
		previewers = {
			git = {
				builtin = false,
			},
		},
		matcher = {
			frecency = true,
		},
		win = {
			input = {
				keys = {
					["<Esc>"] = { "close", mode = { "n", "i" } },
					["<C-M-j>"] = { "preview_scroll_down", mode = { "i", "n" } },
					["<C-M-k>"] = { "preview_scroll_up", mode = { "i", "n" } },
					["<C-M-h>"] = { "preview_scroll_left", mode = { "i", "n" } },
					["<C-M-l>"] = { "preview_scroll_right", mode = { "i", "n" } },
					["<M-S-h>"] = { "toggle_hidden", mode = { "i", "n" } },
				},
			},
		},
		layouts = {
			vertical = {
				layout = {
					backdrop = false,
					width = 0.8,
					min_width = 80,
					height = 0.8,
					min_height = 30,
					box = "vertical",
					border = "rounded",
					title = "{title} {live} {flags}",
					title_pos = "center",
					{ win = "input", height = 1, border = "bottom" },
					{ win = "list", border = "none" },
					{ win = "preview", title = "{preview}", height = 0.4, border = "top" },
				},
			},
			ivy = {
				layout = {
					box = "vertical",
					backdrop = false,
					row = -1,
					width = 0,
					height = 0.5,
					border = "top",
					title = " {title} {live} {flags}",
					title_pos = "left",
					{ win = "input", height = 1, border = "bottom" },
					{
						box = "horizontal",
						{ win = "list", border = "none" },
						{ win = "preview", title = "{preview}", width = 0.6, border = "left" },
					},
				},
			},
		},
	}
	require("snacks").setup({
		bigfile = { enabled = true },
		explorer = { enabled = false },
		image = { enabled = true },
		indent = { enabled = true },
		input = { enabled = true },
		notifier = { enabled = true },
		picker = picker_options,
		quickfile = { enabled = true },
		scope = { enabled = true },
		scroll = { enabled = false },
		statuscolumn = { enabled = true },
		words = { enabled = true },
	})
end)

-- Noice ======================================================================
now(function()
	add({
		"https://github.com/MunifTanjim/nui.nvim",
		"https://github.com/folke/noice.nvim",
	})
	require("noice").setup({
		lsp = {
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
			},
		},
		routes = {
			{
				filter = {
					event = "msg_show",
					any = {
						{ find = "%d+L, %d+B" },
						{ find = "; after #%d+" },
						{ find = "; before #%d+" },
					},
				},
				view = "mini",
			},
		},
		presets = {
			bottom_search = false,
			command_palette = true,
			long_message_to_split = true,
		},
	})
end)

-- Treesitter =================================================================
now_if_args(function()
  -- stylua: ignore
  local ts_update = function() vim.cmd("TSUpdate") end
	Config.on_packchanged("nvim-treesitter", { "update" }, ts_update, "Run :TSUpdate on package update")
	add({
		"https://github.com/nvim-treesitter/nvim-treesitter",
		"https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
	})
	local languages = {
		"bash",
		"c",
		"cmake",
		"cpp",
		"css",
		"desktop",
		"diff",
		"dockerfile",
		"fish",
		"git_config",
		"git_rebase",
		"gitattributes",
		"gitcommit",
		"gitignore",
		"go",
		"gomod",
		"gosum",
		"gotmpl",
		"gowork",
		"hcl",
		"helm",
		"html",
		"hyprlang",
		"javascript",
		"jsdoc",
		"json",
		"json5",
		"just",
		"lua",
		"luadoc",
		"luap",
		"markdown",
		"markdown_inline",
		"ninja",
		"printf",
		"python",
		"query",
		"rasi",
		"regex",
		"ron",
		"rst",
		"rust",
		"sql",
		"terraform",
		"toml",
		"tsx",
		"typescript",
		"vim",
		"vimdoc",
		"vue",
		"xml",
		"yaml",
	}
	local isnt_installed = function(lang)
		return #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false) == 0
	end
	local to_install = vim.tbl_filter(isnt_installed, languages)
  -- stylua: ignore
  if #to_install > 0 then require("nvim-treesitter").install(to_install) end
	-- Create custom filetypes
	vim.filetype.add({
		extension = {
			rasi = "rasi",
			rofi = "rasi",
			wofi = "rasi",
		},
		filename = {
			["vifmrc"] = "vim",
		},
		pattern = {
			[".*/waybar/config"] = "jsonc",
			[".*/mako/config"] = "dosini",
			[".*/kitty/.+%.conf"] = "kitty",
			[".*/hypr/.+%.conf"] = "hyprlang",
			["%.env%.[%w_.-]+"] = "sh",
			[".*/.github/workflows/.*%.yml"] = "yaml.ghaction",
			[".*/.github/workflows/.*%.yaml"] = "yaml.ghaction",
		},
	})
	vim.treesitter.language.register("bash", "kitty")
	local filetypes = {}
	for _, lang in ipairs(languages) do
		for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
			table.insert(filetypes, ft)
		end
	end
  -- stylua: ignore
  local ts_start = function(ev) vim.treesitter.start(ev.buf) end
	Config.new_autocmd("FileType", filetypes, ts_start, "Start tree-sitter")
	-- Treesitter textobjects move
	require("nvim-treesitter-textobjects").setup({
		move = {
			enable = true,
			set_jumps = true,
			goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
			goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
			goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
			goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
		},
	})
end)

-- Autotag ====================================================================
later(function()
	add({ "https://github.com/windwp/nvim-ts-autotag" })
	require("nvim-ts-autotag").setup()
end)

-- Language servers ============================================================
now_if_args(function()
	add({ "https://github.com/neovim/nvim-lspconfig" })
end)

-- Schemastore for JSON and YAML files
now(function()
	add({ "https://github.com/b0o/SchemaStore.nvim" })
end)

-- Lazydev
Config.on_filetype("lua", function()
	add({ "https://github.com/folke/lazydev.nvim" })
	require("lazydev").setup({
		library = {
			{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			{ path = "snacks.nvim", words = { "Snacks" } },
		},
	})
end)

-- Mason Suite
now(function()
	add({
		"https://github.com/mason-org/mason.nvim",
		"https://github.com/mason-org/mason-lspconfig.nvim",
		"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
	})
	require("mason").setup()
	require("mason-lspconfig").setup()
	require("mason-tool-installer").setup({
		ensure_installed = {
			-- LSP Servers
			"ansible-language-server",
			"bash-language-server",
			"clangd",
			"copilot-language-server",
			"docker-compose-language-service",
			"dockerfile-language-server",
			"emmet-language-server",
			"eslint-lsp",
			"fish-lsp",
			"gopls",
			"helm-ls",
			"json-lsp",
			"just-lsp",
			"lua-language-server",
			"marksman",
			"neocmakelsp",
			"pyright",
			"tailwindcss-language-server",
			"taplo",
			"terraform-ls",
			"tflint",
			"tofu-ls",
			"vim-language-server",
			"vtsls",
			"vue-language-server",
			"yaml-language-server",
			-- Linters
			"actionlint",
			"cmakelang",
			"cmakelint",
			"golangci-lint",
			"hadolint",
			"markdownlint-cli2",
			"ruff",
			"shellcheck",
			"sqlfluff",
			"tflint",
			-- Formatters
			"gofumpt",
			"goimports",
			"markdown-toc",
			"prettier",
			"shfmt",
			"stylua",
		},
	})
end)

-- LSP Features ===============================================================
now_if_args(function()
	-- Diagnostics
	vim.diagnostic.config({
		underline = true,
		update_in_insert = false,
		virtual_text = {
			spacing = 4,
			source = "if_many",
			prefix = "●",
		},
		severity_sort = true,
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = Config.icons.diagnostics.Error,
				[vim.diagnostic.severity.WARN] = Config.icons.diagnostics.Warn,
				[vim.diagnostic.severity.HINT] = Config.icons.diagnostics.Hint,
				[vim.diagnostic.severity.INFO] = Config.icons.diagnostics.Info,
			},
		},
	})

	-- Global LSP capabilities (file rename support)
	vim.lsp.config("*", {
		capabilities = {
			workspace = {
				fileOperations = {
					didRename = true,
					willRename = true,
				},
			},
		},
	})

	-- Inlay hints: auto-enable when server supports them
	Snacks.util.lsp.on({ method = "textDocument/inlayHint" }, function(buffer)
		if vim.api.nvim_buf_is_valid(buffer) and vim.bo[buffer].buftype == "" then
			vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
		end
	end)

	-- LSP folding: upgrade from indent to LSP-aware folding when available
	Snacks.util.lsp.on({ method = "textDocument/foldingRange" }, function()
		vim.wo.foldmethod = "expr"
		vim.wo.foldexpr = "v:lua.vim.lsp.foldexpr()"
	end)

	-- ESLint fix all on save
	Snacks.util.lsp.on({ name = "eslint" }, function(buffer)
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = buffer,
			callback = function()
				vim.cmd("EslintFixAll")
			end,
			desc = "ESLint fix all on save",
		})
	end)
end)

-- Formatting =================================================================
later(function()
	add({ "https://github.com/stevearc/conform.nvim" })
	require("conform").setup({
		default_format_opts = {
			lsp_format = "fallback",
			timeout_ms = 2000,
			async = false,
			quiet = false,
		},
		format_on_save = function(bufnr)
			local ignore_filetypes = {}
			if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
				return
			end
			return { timeout_ms = 3000, lsp_format = "fallback" }
		end,
    -- stylua: ignore
		formatters_by_ft = {
			fish               = { "fish_indent" },
      go                 = { "goimports", "gofumpt" },
      hcl                = { "tofu_fmt" },
			lua                = { "stylua" },
      markdown           = { "prettier", "markdownlint-cli2", "markdown-toc" },
      ["markdown.mdx"]   = { "prettier", "markdownlint-cli2", "markdown-toc" },
			sh                 = { "shfmt" },
      terraform          = { "tofu_fmt" },
      ["terraform-vars"] = { "tofu_fmt" },
      tf                 = { "tofu_fmt" },
		},
		formatters = {
			["markdown-toc"] = {
				condition = function(_, ctx)
					for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
						if line:find("<!%-%- toc %-%->") then
							return true
						end
					end
					return false
				end,
			},
			["markdownlint-cli2"] = {
				condition = function(_, ctx)
					local diag = vim.tbl_filter(function(d)
						return d.source == "markdownlint"
					end, vim.diagnostic.get(ctx.buf))
					return #diag > 0
				end,
			},
		},
	})
end)

-- Linting ====================================================================
later(function()
	add({ "https://github.com/mfussenegger/nvim-lint" })
	local lint = require("lint")

	lint.linters["markdownlint-cli2"].args = { "--config", "~/.markdownlint.yaml", "--" }

  -- stylua: ignore
	lint.linters_by_ft = {
		cmake              = { "cmakelint" },
		dockerfile         = { "hadolint" },
		fish               = { "fish" },
		go                 = { "golangcilint" },
		markdown           = { "markdownlint-cli2" },
		sql                = { "sqlfluff" },
		terraform          = { "tflint" },
		["terraform-vars"] = { "tflint" },
		tf                 = { "tflint" },
		["yaml.ghaction"]  = { "actionlint" },
	}

	local timer = assert(vim.uv.new_timer())
	local function debounced_lint()
		timer:stop()
    -- stylua: ignore
    timer:start(100, 0, vim.schedule_wrap(function() lint.try_lint() end))
	end

	Config.new_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, nil, debounced_lint, "Trigger linting")
end)

-- Completion =================================================================
now(function()
	add({
		{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
		"https://github.com/rafamadriz/friendly-snippets",
	})
	require("blink.cmp").setup({
		keymap = {
			preset = "default",
			["<C-p>"] = {},
			["<C-n>"] = {},
			["<C-k>"] = { "select_prev", "fallback" },
			["<C-j>"] = { "select_next", "fallback" },
			["<C-h>"] = { "snippet_backward", "fallback" },
			["<C-l>"] = { "snippet_forward", "fallback" },
			["<C-e>"] = { "cancel", "hide", "fallback" },
			["<C-c>"] = { "cancel", "hide", "fallback" },
		},

		appearance = {
			nerd_font_variant = "mono",
			kind_icons = Config.icons.kinds,
		},

		completion = {
			accept = {
				auto_brackets = { enabled = true },
			},
			menu = {
				border = "rounded",
				scrollbar = false,
				draw = {
					treesitter = { "lsp" },
					columns = { { "label", "label_description", gap = 2 }, { "kind_icon", gap = 1, "kind" } },
					components = {
						kind_icon = {
							text = function(ctx)
								local icon = ctx.kind_icon
								if ctx.source_name == "Path" then
									local mini_icon = require("mini.icons").get("lsp", ctx.kind)
									if mini_icon then
										icon = mini_icon
									end
								end
								return icon .. ctx.icon_gap
							end,
							highlight = function(ctx)
								local _, hl = require("mini.icons").get("lsp", ctx.kind)
								return hl
							end,
						},
						kind = {
							highlight = function(ctx)
								local _, hl = require("mini.icons").get("lsp", ctx.kind)
								return hl
							end,
						},
					},
				},
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 200,
				window = { border = "rounded" },
			},
		},

		signature = {
			enabled = true,
			window = { border = "rounded" },
		},

		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
			per_filetype = {
				lua = { inherit_defaults = true, "lazydev" },
			},
			providers = {
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					score_offset = 100,
				},
			},
		},

		cmdline = {
			enabled = true,
			keymap = { preset = "cmdline" },
			completion = {
				list = { selection = { preselect = false } },
				menu = {
					auto_show = function(ctx)
						return vim.fn.getcmdtype() == ":"
					end,
				},
				ghost_text = { enabled = true },
			},
		},

		fuzzy = {
			implementation = "prefer_rust_with_warning",
		},
	})
end)

-- Lualine ====================================================================
now(function()
	add({ "https://github.com/nvim-lualine/lualine.nvim" })

	local lualine_require = require("lualine_require")
	lualine_require.require = require

	require("lualine").setup({
		options = {
			theme = "auto",
			globalstatus = true,
			disabled_filetypes = { statusline = { "dashboard", "snacks_dashboard" } },
			component_separators = "",
			section_separators = { left = "", right = "" },
		},

		sections = {
			lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
			lualine_b = { "branch" },

			lualine_c = {
				"%=",
				{
					"diagnostics",
					symbols = {
						error = Config.icons.diagnostics.Error,
						warn = Config.icons.diagnostics.Warn,
						info = Config.icons.diagnostics.Info,
						hint = Config.icons.diagnostics.Hint,
					},
				},
				{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
				{
					"filename",
					path = 1,
					color = function()
						if vim.bo.modified then
							return { fg = Snacks.util.color("MatchParen"), gui = "bold" }
						end
						return { gui = "bold" }
					end,
					symbols = {
						modified = "●",
						readonly = "󰣮 ",
						unnamed = "[No Name]",
					},
				},
			},

			lualine_x = {
				-- stylua: ignore start
				{
					function() return require("noice").api.status.command.get() end,
					cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
					color = function() return { fg = Snacks.util.color("Statement") } end,
				},
				{
					function() return require("noice").api.status.mode.get() end,
					cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
					color = function() return { fg = Snacks.util.color("Constant") } end,
				},
				-- stylua: ignore end
				{
					"diff",
					symbols = {
						added = Config.icons.git.added,
						modified = Config.icons.git.modified,
						removed = Config.icons.git.removed,
					},
					source = function()
						local gitsigns = vim.b.gitsigns_status_dict
						if gitsigns then
							return {
								added = gitsigns.added,
								modified = gitsigns.changed,
								removed = gitsigns.removed,
							}
						end
					end,
				},
			},

			lualine_y = {
				{ "progress", separator = " ", padding = { left = 1, right = 0 } },
				{ "location", padding = { left = 0, right = 1 } },
			},

			lualine_z = {
				{
					function()
						return " " .. os.date("%R")
					end,
					separator = { right = "" },
					left_padding = 2,
				},
			},
		},

		extensions = { "mason", "quickfix" },
	})
end)

-- Gitsigns ===================================================================
later(function()
	add({ "https://github.com/lewis6991/gitsigns.nvim" })
	require("gitsigns").setup({
		signs = {
			add = { text = "▎" },
			change = { text = "▎" },
			delete = { text = "" },
			topdelete = { text = "" },
			changedelete = { text = "▎" },
			untracked = { text = "▎" },
		},
		signs_staged = {
			add = { text = "▎" },
			change = { text = "▎" },
			delete = { text = "" },
			topdelete = { text = "" },
			changedelete = { text = "▎" },
		},
		on_attach = function(buffer)
			local gs = package.loaded.gitsigns

			local function map(mode, l, r, desc)
				vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc, silent = true })
			end

			local function map_leader(suffix, rhs, desc)
				vim.keymap.set("n", "<Leader>" .. suffix, rhs, { buffer = buffer, desc = desc, silent = true })
			end

			local function xmap_leader(suffix, rhs, desc)
				vim.keymap.set({ "n", "x" }, "<Leader>" .. suffix, rhs, { buffer = buffer, desc = desc, silent = true })
			end

			-- stylua: ignore start
			map("n", "]h", function()
				if vim.wo.diff then vim.cmd.normal({ "]c", bang = true })
				else gs.nav_hunk("next") end
			end, "Next Hunk")
			map("n", "[h", function()
				if vim.wo.diff then vim.cmd.normal({ "[c", bang = true })
				else gs.nav_hunk("prev") end
			end, "Prev Hunk")
			map("n", "]H", function() gs.nav_hunk("last") end,  "Last Hunk")
			map("n", "[H", function() gs.nav_hunk("first") end, "First Hunk")

			xmap_leader("ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
			xmap_leader("ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")

			map_leader("ghS", gs.stage_buffer,    "Stage Buffer")
			map_leader("ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
			map_leader("ghR", gs.reset_buffer,    "Reset Buffer")

			map_leader("ghp", gs.preview_hunk_inline,                        "Preview Hunk Inline")
			map_leader("ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
			map_leader("ghB", function() gs.blame() end,                     "Blame Buffer")

			map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select Hunk")
			-- stylua: ignore end
		end,
	})
end)

-- Which-key ==================================================================
later(function()
	add({ "https://github.com/folke/which-key.nvim" })
	require("which-key").setup({
		preset = "helix",
		spec = vim.list_extend(vim.deepcopy(Config.leader_groups), {
			{ "[", group = "Prev" },
			{ "]", group = "Next" },
			{ "g", group = "Goto" },
			{ "gs", group = "Surround" },
			{ "go", group = "Sort" },
			{ "gx", desc = "Exchange" },
			{ "z", group = "Fold" },
		}),
	})
end)

-- Inc Rename =================================================================
later(function()
	add({ "https://github.com/smjonas/inc-rename.nvim" })
	require("inc_rename").setup()
end)

-- Todo Comments ==============================================================
later(function()
	add({ "https://github.com/folke/todo-comments.nvim" })
	require("todo-comments").setup()
end)

-- Flash ======================================================================
later(function()
	add({ "https://github.com/folke/flash.nvim" })
	require("flash").setup({
		highlight = {
			backdrop = false,
			groups = {
				backdrop = "",
			},
		},
	})
end)

-- Codediff ===================================================================
later(function()
	add({ "https://github.com/esmuellert/codediff.nvim" })
	require("codediff").setup()
end)

-- Persistence ================================================================
later(function()
	add({ "https://github.com/folke/persistence.nvim" })
	require("persistence").setup()
end)

-- Better Escape ==============================================================
later(function()
	add({ "https://github.com/max397574/better-escape.nvim" })
	require("better_escape").setup({
		timeout = vim.o.timeoutlen,
		default_mappings = true,
		mappings = {
			i = { j = { k = "<Esc>" } },
			c = { j = { k = "<C-c>" } },
			t = { j = { k = "<C-\\><C-n>" } },
			v = { j = { k = "<Esc>" } },
			s = { j = { k = "<Esc>" } },
		},
	})
end)

-- Color Picker ===============================================================
later(function()
	add({ "https://github.com/eero-lehtinen/oklch-color-picker.nvim" })
	require("oklch-color-picker").setup()
end)

-- Rainbow Delimiters =========================================================
later(function()
	add({ "https://github.com/HiPhish/rainbow-delimiters.nvim" })
end)

-- Screenkey ==================================================================
later(function()
	add({ "https://github.com/NStefan002/screenkey.nvim" })
	require("screenkey").setup({
		win_opts = {
			border = "rounded",
		},
	})
end)

-- Markview ===================================================================
later(function()
	add({ "https://github.com/OXY2DEV/markview.nvim" })
	require("markview").setup({
		preview = {
			icon_provider = "mini",
		},
		markdown_inline = {
			tags = {
				default = {
					hl = "MarkviewCodeInfo",
					padding_left = "",
					padding_left_hl = "MarkviewCodeFg",
					padding_right = "",
					padding_right_hl = "MarkviewCodeFg",
				},
				enable = true,
			},
		},
		markdown = {
			list_items = {
				shift_width = function(buffer, item)
					local parent_indent = math.max(1, item.indent - vim.bo[buffer].shiftwidth)
					return item.indent * (1 / (parent_indent * 2))
				end,
				marker_minus = {
					add_padding = function(_, item)
						return item.indent > 1
					end,
				},
			},
		},
	})
end)

-- Helpview ===================================================================
now(function()
	add({ "https://github.com/OXY2DEV/helpview.nvim" })
	require("helpview").setup({
		preview = {
			icon_provider = "mini",
		},
	})
end)
