return {
  "tiagovla/scope.nvim",
  opts = {},
  config = function(_, opts)
    vim.opt.sessionoptions = { -- required
      "buffers",
      "tabpages",
      "globals",
    }
    require("scope").setup(opts)
  end,
}
