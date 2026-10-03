return {
  "zk-org/zk-nvim",
  keys = {
    {
      "<leader>zn",
      function()
        require("zk.commands").get("ZkNew")({ title = vim.fn.input("Title : ") })
      end,
      desc = "Create and edit new note",
    },
    {
      "<leader>zo",
      function()
        require("zk.commands").get("ZkNotes")({ sort = { "modified" } })
      end,
      desc = "Open notes",
    },
    {
      "<leader>zt",
      function()
        require("zk.commands").get("ZkTags")
      end,
      desc = "Open notes associated with a tag",
    },
    {
      "<leader>zf",
      function()
        require("zk.commands").get("ZkNotes")({ sort = { "modified" }, match = { vim.fn.input("Search : ") } })
      end,
      desc = "Search note",
    },
  },
  config = function()
    require("zk").setup({
      -- Can be "telescope", "fzf", "fzf_lua", "minipick", "snacks_picker",
      -- or select" (`vim.ui.select`).
      picker = "snacks_picker",

      picker_options = {
        snacks_picker = {
          layout = {
            preset = "ivy",
          },
        },
      },

      lsp = {
        -- `config` is passed to `vim.lsp.start(config)`
        config = {
          name = "zk",
          cmd = { "zk", "lsp" },
          filetypes = { "markdown" },
          -- on_attach = ...
          -- etc, see `:h vim.lsp.start()`
        },

        -- automatically attach buffers in a zk notebook that match the given filetypes
        auto_attach = {
          enabled = true,
        },
      },
    })
  end,
}
