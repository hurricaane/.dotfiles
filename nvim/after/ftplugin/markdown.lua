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
		-- Wiki link (Obsidian)
		W = { input = { "%[%[().-()%]%]" }, output = { left = "[[", right = "]]" } },
	},
}
-- Wrap long lines visually (paragraphs are written on a single line)
vim.opt_local.wrap = true

-- Markdown Plus keymaps (its default keymaps are disabled)
-- stylua: ignore start
local map = function(mode, lhs, plug, desc)
	vim.keymap.set(mode, lhs, "<Plug>(MarkdownPlus" .. plug .. ")", { buffer = true, desc = desc })
end
-- Lists
map("i",          "<CR>",       "ListEnter",                "Continue list")
map("i",          "<A-CR>",     "ListShiftEnter",           "Continue list item content")
map("i",          "<Tab>",      "ListIndent",               "Indent list item")
map("i",          "<S-Tab>",    "ListOutdent",              "Outdent list item")
map("i",          "<BS>",       "ListBackspace",            "Remove empty list item")
map("n",          "o",          "NewListItemBelow",         "New list item below")
map("n",          "O",          "NewListItemAbove",         "New list item above")
map({ "n", "x" }, "<Leader>ml", "ToggleListPick",           "Change list type")
map("n",          "<Leader>mr", "RenumberLists",            "Renumber lists")
map({ "n", "x" }, "<Leader>mx", "ToggleCheckbox",           "Toggle checkbox")
-- Formatting
map({ "n", "x" }, "<Leader>mb", "Bold",                     "Toggle bold")
map({ "n", "x" }, "<Leader>mc", "Code",                     "Toggle inline code")
map({ "n", "x" }, "<Leader>mi", "Italic",                   "Toggle italic")
map({ "n", "x" }, "<Leader>ms", "Strikethrough",            "Toggle strikethrough")
-- Quotes and callouts
map({ "n", "x" }, "<Leader>ma", "InsertCallout",            "Insert/wrap callout")
map("n",          "<Leader>mA", "ToggleCalloutType",        "Cycle callout type")
map({ "n", "x" }, "<Leader>mq", "ToggleQuote",              "Toggle blockquote")
map("n",          "<Leader>mQ", "ConvertToCallout",         "Convert blockquote to callout")
-- Tables
map("n",          "<Leader>ta", "TableToggleCellAlignment", "Toggle cell alignment")
map("n",          "<Leader>tc", "TableInsertColumnRight",   "Insert column right")
map("n",          "<Leader>tC", "TableInsertColumnLeft",    "Insert column left")
map("n",          "<Leader>td", "TableDeleteRow",           "Delete row")
map("n",          "<Leader>tD", "TableDeleteColumn",        "Delete column")
map("n",          "<Leader>te", "TableEditCell",            "Edit cell in popup")
map("n",          "<Leader>tf", "TableFormat",              "Format table")
map("n",          "<Leader>tF", "TableNormalize",           "Normalize malformed table")
map("n",          "<Leader>th", "TableMoveColumnLeft",      "Move column left")
map("n",          "<Leader>tj", "TableMoveRowDown",         "Move row down")
map("n",          "<Leader>tk", "TableMoveRowUp",           "Move row up")
map("n",          "<Leader>tl", "TableMoveColumnRight",     "Move column right")
map("n",          "<Leader>tn", "TableCreate",              "New table")
map("n",          "<Leader>tr", "TableInsertRowBelow",      "Insert row below")
map("n",          "<Leader>tR", "TableInsertRowAbove",      "Insert row above")
map("n",          "<Leader>ts", "TableSortAscending",       "Sort by column (ascending)")
map("n",          "<Leader>tS", "TableSortDescending",      "Sort by column (descending)")
map("n",          "<Leader>tx", "TableClearCell",           "Clear cell")
map("n",          "<Leader>ty", "TableDuplicateRow",        "Duplicate row")
map("n",          "<Leader>tY", "TableDuplicateColumn",     "Duplicate column")
-- stylua: ignore end
