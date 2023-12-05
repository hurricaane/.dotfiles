-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt
local g = vim.g

opt.spelllang = { "en,fr" }

g.python3_host_prog = "/home/yannick/.pyenv/versions/nvim/bin/python"
