-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
local api = vim.api

-- local resetGroup = api.nvim_create_augroup("ResetCursor", { clear = true })
-- api.nvim_create_autocmd({ "VimLeave" }, {
--   pattern = { "*" },
--   group = resetGroup,
--   callback = function()
--     vim.opt_local.guicursor = "a:ver25-blinkoff0"
--   end,
-- })

local function detach_yamlls()
  local clients = vim.lsp.get_active_clients()
  for client_id, client in pairs(clients) do
    if client.name == "yamlls" then
      vim.lsp.buf_detach_client(0, client_id)
    end
  end
end

local gotmplGroup = api.nvim_create_augroup("GotmplGroup", { clear = true })
api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  group = gotmplGroup,
  pattern = {
    "*/templates/*.yaml",
    "*/templates/*.yml",
    "*/templates/*.tpl",
    "*.gotmpl",
    "helmfile*.yaml",
    "helmfile*.yml",
  },
  callback = function()
    vim.opt_local.filetype = "helm"
    vim.defer_fn(detach_yamlls, 500)
  end,
})
