return {
  "chrisgrieser/nvim-scissors",
  dependencies = "nvim-telescope/telescope.nvim",
  keys = {
    {
      "<leader>cxa",
      function()
        require("scissors").addNewSnippet()
      end,
      mode = { "n", "x" },
      desc = "Add new snippet",
    },
    {
      "<leader>cxe",
      function()
        require("scissors").editSnippet()
      end,
      desc = "Edit snippet",
    },
  },
  opts = {
    snippetDir = vim.fn.stdpath("config") .. "/snippets",
    jsonFormatter = "jq",
  },
}
