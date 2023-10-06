-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- Better escape
vim.keymap.set("i", "jk", "<ESC>", { noremap = true, silent = true, desc = "<ESC>" })
vim.keymap.set("i", "kj", "<ESC>", { noremap = true, silent = true, desc = "<ESC>" })

-- Overwrite LazyVim default mappings with vim-tmux-navigator mappings
vim.keymap.set("n", "<C-h>", ":<C-U>TmuxNavigateLeft<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-l>", ":<C-U>TmuxNavigateRight<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-j>", ":<C-U>TmuxNavigateDown<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-k>", ":<C-U>TmuxNavigateUp<cr>", { noremap = true, silent = true })

-- Icon Picker keymap
vim.keymap.set("n", "<leader>ip", "<cmd>IconPickerNormal<cr>", { desc = "Open Icon Picker and insert icon" })

-- Remapping Ctrl-d and Ctrl-u for better scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Better Ctrl-d scrolling" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Better Ctrl-u scrolling" })
