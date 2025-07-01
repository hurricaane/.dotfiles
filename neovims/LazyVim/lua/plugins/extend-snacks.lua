return {
  "folke/snacks.nvim",
  keys = {
    { "<leader>e", false },
    { "<leader>E", false },
    {
      "<leader>gl",
      function()
        Snacks.picker.git_log({
          finder = "git_log",
          format = "git_log",
          preview = "git_show",
          confirm = "git_checkout",
          sort = { fields = { "score:desc", "idx" } },
          layout = "vertical",
        })
      end,
      desc = "Git Log",
    },
    {
      "<S-h>",
      function()
        Snacks.picker.buffers({
          on_show = function()
            vim.cmd.stopinsert()
          end,
          finder = "buffers",
          format = "buffer",
          hidden = false,
          unloaded = true,
          current = false,
          sort_lastused = true,
          win = {
            input = {
              keys = {
                ["d"] = "bufdelete",
              },
            },
            list = { keys = { ["d"] = "bufdelete" } },
          },
          layout = "ivy",
        })
      end,
      desc = "Switch buffer",
    },
    {
      "<leader>sc",
      function()
        Snacks.picker.cliphist()
      end,
      desc = "Clipboard History",
    },
  },
  opts = {
    scroll = {
      enabled = false,
    },
    explorer = {
      enabled = false,
    },
    input = {
      enabled = true,
    },
    image = {
      enabled = true,
    },
    picker = {
      previewers = {
        git = {
          builtin = false,
        },
      },
      matcher = {
        frecency = true,
      },
      win = {
        input = {
          keys = {
            ["<Esc>"] = { "close", mode = { "n", "i" } },
            ["<C-M-j>"] = { "preview_scroll_down", mode = { "i", "n" } },
            ["<C-M-k>"] = { "preview_scroll_up", mode = { "i", "n" } },
            ["<C-M-h>"] = { "preview_scroll_left", mode = { "i", "n" } },
            ["<C-M-l>"] = { "preview_scroll_right", mode = { "i", "n" } },
          },
        },
      },
      layouts = {
        vertical = {
          layout = {
            backdrop = false,
            width = 0.8,
            min_width = 80,
            height = 0.8,
            min_height = 30,
            box = "vertical",
            border = "rounded",
            title = "{title} {live} {flags}",
            title_pos = "center",
            { win = "input", height = 1, border = "bottom" },
            { win = "list", border = "none" },
            { win = "preview", title = "{preview}", height = 0.4, border = "top" },
          },
        },
        ivy = {
          layout = {
            box = "vertical",
            backdrop = false,
            row = -1,
            width = 0,
            height = 0.5,
            border = "top",
            title = " {title} {live} {flags}",
            title_pos = "left",
            { win = "input", height = 1, border = "bottom" },
            {
              box = "horizontal",
              { win = "list", border = "none" },
              { win = "preview", title = "{preview}", width = 0.6, border = "left" },
            },
          },
        },
      },
    },
  },
}
