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
-- Automatically wrap text at column 80
vim.api.nvim_set_option_value("textwidth", 80, {})
