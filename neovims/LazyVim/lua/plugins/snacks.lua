return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    image = {
      -- your image configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    picker = {
      matcher = {
        frecency = true,
      },
    },
    win = {
      input = {
        ["<Esc>"] = { "close", mode = { "n", "i" } },
        ["J"] = { "preview_scroll_down", mode = { "i", "n" } },
        ["K"] = { "preview_scroll_up", mode = { "i", "n" } },
        ["H"] = { "preview_scroll_left", mode = { "i", "n" } },
        ["L"] = { "preview_scroll_right", mode = { "i", "n" } },
      },
    },
  },
}
