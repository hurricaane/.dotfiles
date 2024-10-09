-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set -- For conciseness

-- Deleted keymaps
vim.keymap.del("n", "<C-Up>")
vim.keymap.del("n", "<C-Down>")
vim.keymap.del("n", "<C-Left>")
vim.keymap.del("n", "<C-Right>")

-- Jumplist
map({ "n", "x" }, "j", function()
  return vim.v.count > 1 and "m'" .. vim.v.count .. "j" or "j"
end, { noremap = true, expr = true })

map({ "n", "x" }, "k", function()
  return vim.v.count > 1 and "m'" .. vim.v.count .. "k" or "k"
end, { noremap = true, expr = true })

-- Better navigation with <C-d> / <C-u>
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll half a page down" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll half a page up" })

-- Set spell language for current buffer
map("n", "<F6>", function()
  local input = vim.fn.input("Spell language: ")
  vim.cmd(string.format("setlocal spelllang=%s", input))
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
