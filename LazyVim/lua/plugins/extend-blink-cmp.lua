return {
  "saghen/blink.cmp",
  dependencies = {
    "onsails/lspkind.nvim",
  },
  opts = {
    keymap = {
      preset = "default",
      ["<C-p>"] = {},
      ["<C-n>"] = {},
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-h>"] = { "snippet_backward", "fallback" },
      ["<C-l>"] = { LazyVim.cmp.map({ "snippet_forward", "ai_accept" }), "fallback" },
      ["<C-e>"] = { "cancel", "hide", "fallback" },
      ["<C-c>"] = { "cancel", "hide", "fallback" },
    },
    completion = {
      menu = {
        border = "rounded",
        scrollbar = false,
        draw = {
          components = {
            kind_icon = {
              text = function(ctx)
                local icon = ctx.kind_icon
                if vim.tbl_contains({ "Path" }, ctx.source_name) then
                  local mini_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                  if mini_icon then
                    icon = mini_icon
                  end
                else
                  icon = require("lspkind").symbol_map[ctx.kind] or icon
                end
                return icon .. ctx.icon_gap
              end,
              -- (optional) use highlights from mini.icons
              highlight = function(ctx)
                local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                return hl
              end,
            },
            kind = {
              -- (optional) use highlights from mini.icons
              highlight = function(ctx)
                local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                return hl
              end,
            },
          },
          columns = { { "label", "label_description", gap = 2 }, { "kind_icon", gap = 1, "kind" } },
        },
      },
      documentation = {
        window = {
          border = "rounded",
        },
      },
    },
    signature = {
      window = {
        border = "rounded",
      },
    },
    sources = {
      compat = {},
      default = { "lsp", "path", "snippets", "buffer" },
    },
  },
}
