return {
  "Wansmer/treesj",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  keys = {
    {
      "<leader>j",
      function()
        require("treesj").toggle()
      end,
      desc = "Split/Join node under cursor",
    },
  },
  config = function()
    require("treesj").setup({
      use_default_keymaps = false,
    })
  end,
}
