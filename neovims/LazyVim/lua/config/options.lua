-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- For concisness
local g = vim.g
local opt = vim.opt

-- Global options
g.python3_host_prog = "/home/yannick/.pyenv/versions/nvim/bin/python"
g.snacks_animate = false
g.lazyvim_picker = "snacks"

-- Appearance
vim.diagnostic.config({
  float = { border = "rounded" }, -- add border to diagnostic popups
})

-- Backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- Tabs & Indentation
opt.autoindent = true
vim.bo.softtabstop = 2

-- views can only be fully collapsed with the global statusline
opt.laststatus = 3
