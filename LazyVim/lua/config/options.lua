-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Backspace
vim.opt.backspace = "indent,eol,start"

-- views can only be fully collapsed with the global statusline
vim.opt.laststatus = 3

-- add localoptions to sessionoptions default value in LazyVim so that it can save language options of a buffer
vim.opt.sessionoptions =
  { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds", "localoptions" }

-- set default language to english
vim.opt.spelllang = { "en", "fr_fr" }

-- eslint
vim.g.lazyvim_eslint_auto_format = true

-- rounded borders
vim.opt.winborder = "rounded"
