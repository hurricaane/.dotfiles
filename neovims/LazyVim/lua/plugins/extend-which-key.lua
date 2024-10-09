return {
  "folke/which-key.nvim",
  keys = {
    {
      "<leader>z",
      function()
        require("which-key").show({ keys = "z", loop = true })
      end,
      desc = "Z mode (Hydra)",
    },
    {
      "<leader>v<Space>",
      function()
        require("which-key").show({ keys = "<leader>v", loop = true })
      end,
      desc = "Toggle Hydra mode",
    },
  },
  opts = {
    preset = "modern",
  },
}
