return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    opts.highlight = vim.tbl_extend("force", opts.highlight, {
      additional_vim_regex_highlighting = { "markdown" },
    })
  end,
}
