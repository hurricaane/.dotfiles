return {
  "folke/persistence.nvim",
  event = "BufReadPre",
  dependencies = {
    "tiagovla/scope.nvim",
  },
  opts = {
    options = vim.opt.sessionoptions:get(),
    pre_save = function()
      vim.cmd([[ScopeSaveState]])
    end,
  },
}
