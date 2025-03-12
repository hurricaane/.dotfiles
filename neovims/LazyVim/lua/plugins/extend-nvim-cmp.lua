return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lua",
    "petertriho/cmp-git",
    "davidsierradz/cmp-conventionalcommits",
    "Dynge/gitmoji.nvim",
    "hrsh7th/cmp-emoji",
    "chrisgrieser/cmp-nerdfont",
  },
  opts = function(_, opts)
    vim.api.nvim_set_hl(0, "CmpGhostText", {})

    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local luasnip_loaders = require("luasnip.loaders.from_vscode")

    luasnip_loaders.lazy_load({
      paths = {
        vim.fn.stdpath("config") .. "/snippets",
      },
    })

    opts.mapping = vim.tbl_extend("force", opts.mapping, {
      ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
      ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
      ["<C-y>"] = LazyVim.cmp.confirm({ select = true }),
      ["<C-e>"] = function(fallback)
        cmp.abort()
        fallback()
      end,
      ["<C-c>"] = function(fallback)
        cmp.abort()
        fallback()
      end,
      ["<C-l>"] = cmp.mapping(function()
        if luasnip.expand_or_locally_jumpable() then
          luasnip.expand_or_jump()
        end
      end, { "i", "s" }),
      ["<C-h>"] = cmp.mapping(function()
        if luasnip.locally_jumpable(-1) then
          luasnip.jump(-1)
        end
      end, { "i", "s" }),
    })

    table.insert(opts.sources, { name = "emoji" })
    table.insert(opts.sources, { name = "nerdfont" })
    table.insert(opts.sources, { name = "nvim_lua" })
    table.insert(opts.sources, { name = "git" })

    cmp.setup.filetype("oil", {
      sources = cmp.config.sources({
        { name = "buffer" },
      }, {
        { name = "path" },
      }),
    })

    cmp.setup.filetype("gitcommit", {
      sources = cmp.config.sources({
        { name = "git" },
        { name = "conventionalcommits" },
        { name = "gitmoji" },
      }, {
        { name = "buffer" },
      }),
    })

    opts.window = {
      completion = {
        border = "rounded",
        winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
      },
      documentation = {
        border = "rounded",
        winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
      },
    }

    opts.view = {
      entries = {
        follow_cursor = true,
      },
    }

    opts.experimental = vim.tbl_extend("force", opts.experimental, {
      ghost_text = false,
    })
  end,
}
