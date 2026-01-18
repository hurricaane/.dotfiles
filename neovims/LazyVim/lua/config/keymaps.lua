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
vim.keymap.del("n", "L")

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
-- map("n", "<F6>", function()
--   local input = vim.fn.input("Spell language: ")
--   vim.opt.spelllang = input
-- end, { desc = "Set spelllang for current buffer" })

-- Tabs
map("n", "<leader><tab>j", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>k", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
