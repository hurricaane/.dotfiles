return {
  "echasnovski/mini.files",
  keys = {
    {
      "<leader>e",
      function()
        require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
      end,
      desc = "Open mini.files (directory of current file)",
    },
    {
      "<leader>E",
      function()
        require("mini.files").open(vim.uv.cwd(), true)
      end,
      desc = "Open mini.files (cwd)",
    },
    { "<leader>fm", false },
    { "<leader>fM", false },
  },
  opts = {
    mappings = {
      close = "q",
      go_in = "",
      go_in_plus = "L",
      go_out = "",
      go_out_plus = "H",
      mark_goto = "'",
      mark_set = "m",
      reset = "<BS>",
      reveal_cwd = "@",
      show_help = "g?",
      synchronize = "=",
      trim_left = "<",
      trim_right = ">",
    },
    options = {
      use_as_default_explorer = true,
    },
    windows = {
      width_focus = 60,
      width_preview = 60,
    },
  },
}
