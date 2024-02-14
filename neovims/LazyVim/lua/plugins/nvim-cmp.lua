return {
  {
    "petertriho/cmp-git",
    config = function()
      require("cmp_git").setup()
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "petertriho/cmp-git",
    },
    opts = function(_, opts)
      local cmp = require("cmp")

      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = false })

      -- opts.sources = cmp.config.sources(vim.list_extend(opts.sources, { { name = "git" } }))
      table.insert(opts.sources, { name = "git" })

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-n>"] = cmp.mapping.scroll_docs(4),
      })

      ---@diagnostic disable-next-line: missing-fields
      cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources({
          { name = "git" }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
        }, {
          { name = "buffer" },
        }),
      })
    end,
  },
}
