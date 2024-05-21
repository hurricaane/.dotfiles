vim.opt.encoding = "utf8"
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.fileformat = "unix"

local function augroup(name)
  return vim.api.nvim_create_augroup("yannick_python_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd("VimEnter", {
  desc = "Auto select virtualenv Nvim open",
  group = augroup("venv"),
  pattern = "*",
  callback = function()
    local venv = vim.fn.findfile("pyproject.toml", vim.fn.getcwd() .. ";")
    if venv ~= "" then
      require("venv-selector").retrieve_from_cache()
    end
  end,
  once = true,
})
