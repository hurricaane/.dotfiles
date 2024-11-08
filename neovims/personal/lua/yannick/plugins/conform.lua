return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        javascript = { "prettierd" },
        typescript = { "prettierd" },
        javascriptreact = { "prettierd" },
        typescriptreact = { "prettierd" },
        css = { "prettierd" },
        html = { "prettierd" },
        json = { "prettierd" },
        -- yaml = { "prettierd" },
        -- markdown = { "prettierd", "markdownlint" },
        lua = { "stylua" },
        python = {
          -- Ruff - see docs : https://docs.astral.sh/ruff/integrations/#vim-neovim
          -- To fix lint errors
          "ruff_fix",
          -- To run the ruff formater
          "ruff_format",
        },
      },
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      },
    })
  end,
}
