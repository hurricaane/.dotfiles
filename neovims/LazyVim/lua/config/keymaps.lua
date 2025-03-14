-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set -- For conciseness

-- Deleted keymaps
vim.keymap.del("n", "<C-Up>")
vim.keymap.del("n", "<C-Down>")
vim.keymap.del("n", "<C-Left>")
vim.keymap.del("n", "<C-Right>")
vim.keymap.del("n", "<leader>gd")

-- Better up/down + jumplist
map({ "n", "x" }, "j", function()
  if vim.v.count > 0 then
    return "m'" .. vim.v.count .. "j"
  else
    return "gj"
  end
end, { expr = true, noremap = true })

map({ "n", "x" }, "k", function()
  if vim.v.count > 0 then
    return "m'" .. vim.v.count .. "k"
  else
    return "gk"
  end
end, { expr = true, noremap = true })

-- Better navigation with <C-d> / <C-u> with jumplist
map("n", "<C-d>", function()
  vim.api.nvim_feedkeys("m'", "n", false)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-d>", true, false, true), "n", false)
  vim.api.nvim_feedkeys("m'zz", "n", false)
end, { desc = "Scroll half a page down", noremap = true, silent = true })

map("n", "<C-u>", function()
  vim.api.nvim_feedkeys("m'", "n", false) -- Sauvegarde la position actuelle
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-u>", true, false, true), "n", false) -- Effectue le scroll
  vim.api.nvim_feedkeys("m'zz", "n", false) -- Sauvegarde la position après et recentre
end, { desc = "Scroll half a page up", noremap = true, silent = true })

-- Set spell language for current buffer
map("n", "<F6>", function()
  local input = vim.fn.input("Spell language: ")
  vim.opt.spelllang = input
end, { desc = "Set spelllang for current buffer" })

-- Execute lua
map("n", "<leader>e", function()
  vim.cmd(".lua")
  vim.notify("Current line executed")
end, { desc = "Execute current line (lua)" })

map("n", "<leader>E", function()
  vim.cmd("source %")
  vim.notify("Current file executed")
end, { desc = "Execute current file (lua)" })

-- Navigate between windows / splits
local nvim_tmux_nav = require("nvim-tmux-navigation")
map("n", "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft, { desc = "Go to Left Window", noremap = true })
map("n", "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown, { desc = "Go to Lower Window", noremap = true })
map("n", "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp, { desc = "Go to Upper Window", noremap = true })
map("n", "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight, { desc = "Go to Right Window", noremap = true })
map("n", "<C-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive, { desc = "Go to last active Window", noremap = true })

-- Tabs
map("n", "<leader><tab>j", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>k", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- Normal mode in terminal
map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Escape terminal mode" })

-- Zk keybindings
map(
  "n",
  "<leader>zn",
  "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>",
  { desc = "Create and edit new note", noremap = true, silent = true }
)
map(
  "n",
  "<leader>zo",
  "<Cmd>ZkNotes { sort = { 'modified' } }<CR>",
  { desc = "Open notes", noremap = true, silent = true }
)
map(
  "n",
  "<leader>zt",
  "<Cmd>ZkTags<CR>",
  { desc = "Open notes associated with the tag", noremap = true, silent = true }
)
map(
  "n",
  "<leader>zf",
  "<Cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } }<CR>",
  { desc = "Search note", noremap = true, silent = true }
)
