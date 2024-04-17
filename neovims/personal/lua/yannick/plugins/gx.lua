return {
  "chrishrb/gx.nvim",
  cmd = { "Browse" },
  dependencies = { "nvim-lua/plenary.nvim" },
  init = function()
    vim.g.netrw_nogx = 1 -- disable netrw gx
  end,
  config = true, -- default settings
  submodules = false, -- not needed, submodules are required only for tests
}
