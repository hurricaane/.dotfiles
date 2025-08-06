return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    opts.highlight = vim.tbl_extend("force", opts.highlight, {
      additional_vim_regex_highlighting = { "markdown" },
    })
    opts.indent = vim.tbl_extend("force", opts.indent, {
      enable = true,
      disable = {
        "markdown",
      },
    })
  end,
}
