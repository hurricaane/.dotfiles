return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    preset = "modern",
    spec = {
      { "gs", group = "Surround" },
      { "<leader>b", group = "Buffer" },
      { "<leader>c", group = "Code / LSP" },
      { "<leader>f", group = "Find" },
      { "<leader>g", group = "Git" },
      { "<leader>gc", group = "Git conflict" },
      { "<leader>i", group = "Icon", icon = " " },
      { "<leader>m", group = "Markdown" },
      { "<leader>s", group = "Split", icon = " " },
      { "<leader>t", group = "Tabs" },
      { "<leader>u", group = "UI" },
      { "<leader>x", group = "Trouble" },
      { "<leader>v", group = "Virtual Env" },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
