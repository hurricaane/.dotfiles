return {
  {
    "chrisgrieser/nvim-spider",
    keys = {
      { "w", "<cmd>lua require('spider').motion('w')<CR>", mode = { "n", "o", "x" } },
      { "e", "<cmd>lua require('spider').motion('e')<CR>", mode = { "n", "o", "x" } },
      { "b", "<cmd>lua require('spider').motion('b')<CR>", mode = { "n", "o", "x" } },
      { "ge", "<cmd>lua require('spider').motion('ge')<CR>", mode = { "n", "o", "x" } },
    },
  },
  -- UTF8 integration
  {
    "vhyrro/luarocks.nvim",
    priority = 1000, -- high priority required, luarocks.nvim should run as the first plugin in your config
    lazy = false,
    opts = {
      rocks = { "dkjson", "luautf8" }, -- specifies a list of rocks to install
    },
  },
}
