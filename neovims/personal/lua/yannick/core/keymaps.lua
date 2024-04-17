-- Keymaps configuration file
-- Here lies the keymaps for all the plugins (easier to manage)

local map = vim.keymap.set -- For conciseness

-- General keymaps
-- Remap <C-j> in insert mode to act like <Enter>
map("i", "<C-j>", "<Enter>")
-- Remap <ESC>
map("i", "jk", "<ESC>")
map("i", "kj", "<ESC>")
-- Better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
-- Add relative movements to jumplist
map("n", "k", [[(v:count > 1 ? "m'" . v:count : '') . 'k']], { noremap = true, silent = true, expr = true })
map("n", "j", [[(v:count > 1 ? "m'" . v:count : '') . 'j']], { noremap = true, silent = true, expr = true })
-- Move Lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move Up" })
-- Better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Remove highlight after search
map("n", "<ESC>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlighting" })

-- Center line on screen when navigating with <C-d> or <C-u>
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll half a page down" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll half a page up" })

-- Window management
map("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
map("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
map("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
map("n", "<leader>sm", "<cmd>MaximizerToggle<CR>", { desc = "Toggle maximize window" }) -- Maximize split window - Vim Maximizer plugin
map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

-- Buffers
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- Tab management
map("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
map("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
map("n", "<leader>tj", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
map("n", "<leader>tk", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
map("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n (taken from LazyVim)
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- Spell options
map("n", "<F5>", function()
  local spell = vim.api.nvim_exec2("set spell?", { output = true })
  spell.output = string.gsub(spell.output, "%s+", "")
  vim.cmd("set spell!")
  if spell.output == "spell" then
    vim.notify("Spell deactivated")
  else
    vim.notify("Spell activated")
  end
end, { desc = "Toggle spell" })
map("n", "<F6>", function()
  local input = vim.fn.input("Spell language: ")
  vim.cmd(string.format("setlocal spelllang=%s", input))
end, { desc = "Set spelllang for current buffer" })

-- Plugins
-- Open Lazy
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Open Lazy" })
-- Open URLs - gx.nvim plugin
map({ "n", "x" }, "gx", "<cmd>Browse<CR>", { desc = "Open link in browser" })
-- Mini Files
map("n", "<leader>o", "<cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>", { desc = "Open Mini Files" })
-- Icon picker
map("n", "<leader>ip", "<cmd>IconPickerNormal", { desc = "Pick and Insert icon" })
-- Telescope mappings - see ../plugins/telescope.lua
-- Mini Surround - see ../plugins/mini-surround.lua
-- Todo Comments
map("n", "]t", function()
  require("todo-comments").jump_next()
end, { desc = "Next todo comment" })
map("n", "[t", function()
  require("todo-comments").jump_prev()
end, { desc = "Previous todo comment" })
-- LSP - see ../plugins/lspconfig.lua
-- Conform (Formatting)
map({ "n", "v" }, "<leader>cf", function()
  require("conform").format({
    lsp_fallback = true,
    async = false,
    timeout_ms = 1000,
  })
end, { desc = "Format file or range (in visual mode)" })
-- Nvim-lint (Linting)
map("n", "<leader>cl", function()
  require("lint").try_lint()
end, { desc = "Trigger linting for current file" })
-- Zen Mode
map("n", "<leader>z", "<cmd>ZenMode<CR>", { desc = "Toggle Zen Mode" })
-- Notify
map("n", "<leader>un", function()
  require("notify").dismiss({ silent = true, pending = true })
end, { desc = "Dismiss All Notifications" })
-- Bufferline
map("n", "<leader>tr", function()
  local input = vim.fn.input("New tab name: ")
  vim.cmd(string.format("BufferLineTabRename %s", input))
end, { desc = "Rename Tab" })
-- Markdown Previewer
map("n", "<leader>mp", "<cmd>MarkdownPreview<CR>", { desc = "Preview Markdown file" })
-- Hardtime Toggle
map("n", "<leader>H", "<cmd>Hardtime toggle<CR>", { desc = "Toggle Hardtime" })
-- Screenkey
map("n", "<leader>S", "<cmd>Screenkey<CR>", { desc = "Toggle Screenkey (Key casting)" })
