return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    local keys = require("lazyvim.plugins.lsp.keymaps").get()
    keys[#keys + 1] = { "<c-k>", false, mode = { "i" } }
    opts.servers.yamlls.settings.yaml = vim.tbl_extend("force", opts.servers.yamlls.settings.yaml, {
      customTags = { "!reference sequence", "!reference mapping", "!reference scalar" },
    })
    opts.servers.tailwindcss = {
      -- exclude a filetype from the default_config
      filetypes_exclude = { "markdown" },
      -- add additional filetypes to the default_config
      filetypes_include = { "vue" },
      -- to fully override the default_config, change the below
      -- filetypes = {}
    }
    opts.setup = vim.tbl_extend("force", opts.setup, {
      tailwindcss = function(_, tailwind_opts)
        local tw = LazyVim.lsp.get_raw_config("tailwindcss")
        tailwind_opts.filetypes = tailwind_opts.filetypes or {}

        -- Add default filetypes
        vim.list_extend(tailwind_opts.filetypes, tw.default_config.filetypes)

        -- Remove excluded filetypes
        --- @param ft string
        tailwind_opts.filetypes = vim.tbl_filter(function(ft)
          return not vim.tbl_contains(tailwind_opts.filetypes_exclude or {}, ft)
        end, tailwind_opts.filetypes)

        -- Additional settings for Phoenix projects
        tailwind_opts.settings = {
          editor = {
            strings = "on",
          },
          tailwindCSS = {
            includeLanguages = {
              elixir = "html-eex",
              eelixir = "html-eex",
              heex = "html-eex",
            },
            classAttributes = { "class", "className", "class:list", "classList", "ngClass", "ui" },
            experimental = {
              classRegex = { "ui:\\s*{([^)]*)\\s*}", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
            },
          },
        }

        -- Add additional filetypes
        vim.list_extend(tailwind_opts.filetypes, tailwind_opts.filetypes_include or {})
      end,
    })
  end,
}
