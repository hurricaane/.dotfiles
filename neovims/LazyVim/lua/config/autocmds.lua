-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
local api = vim.api

local resetGroup = api.nvim_create_augroup("ResetCursor", { clear = true })
api.nvim_create_autocmd({"VimLeave, VimSuspend"}, {
  pattern = {"*"},
  group = resetGroup,
  callback = function()
    vim.opt_local.guicursor = "a:ver25-blinkoff0"
  end
})
