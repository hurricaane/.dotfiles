-- Markdown filetype configuration
-- Fold with tree-sitter
vim.cmd("setlocal foldmethod=expr foldexpr=v:lua.vim.treesitter.foldexpr()")
-- Add markdown specific surrounding in `mini.surround`
vim.b.minisurround_config = {
	custom_surroundings = {
		L = {
			input = { "%[().-()%]%(.-%)" },
			output = function()
				local link = require("mini.surround").user_input("Link: ")
				return { left = "[", right = "](" .. link .. ")" }
			end,
		},
	},
}
-- Wrap long lines visually (paragraphs are written on a single line)
vim.opt_local.wrap = true
