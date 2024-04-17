-- Main configuration file of my neovim
-- Author : Yannick Dossou

-- NOTE: Leader keys must be set before loading plugins
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load options, keymaps, autocommands etc...
require("yannick.core")
-- Load lazy
require("yannick.lazy")
