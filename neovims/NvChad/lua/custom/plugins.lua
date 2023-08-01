-- Add custom/additional plugins here 
local overrides = require("custom.configs.overrides")

---@type NvPluginSpec[]
local plugins = {

  ---------------------------------------------
  -- Override plugin definition options here --
  ---------------------------------------------

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- format & linting
      {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
          require "custom.configs.null-ls"
        end,
      },
    },
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end, -- Override to setup mason-lspconfig
  },

  {
    "williamboman/mason.nvim",
    opts = overrides.mason
  },

  {
    "nvim-treesitter/nvim-treesitter",
    config = function ()
      pcall(dofile, vim.g.base46_cache .. "syntax")
      require "custom.configs.treesitter"
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },

  {
    "folke/which-key.nvim",
    enabled = true,
  },

  -- To make a plugin not be loaded
  -- {
  --   "NvChad/nvim-colorizer.lua",
  --   enabled = false
  -- },

  --------------------------
  -- Add new plugins here --
  --------------------------

  -- Treesitter playground to check syntax highlighting
  {
    "nvim-treesitter/playground",
    lazy = false,
  },

  -- Todo plugin to highlight TODOs (and other things) in the comments
  {
    "folke/todo-comments.nvim",
    lazy = false,
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("todo-comments").setup {}
    end,
  },

  -- Add, change or delete surrounding pairs
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup({
            -- Configuration here, or leave empty to use defaults
        })
    end
  },

  -- Better window management (integrates with tmux)
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },

  -- Markdown previewer
  { 
    "toppair/peek.nvim",
    lazy = false,
    build= "deno task --quiet build:fast",
    config = function()
      vim.api.nvim_create_user_command('PeekOpen', require('peek').open, {})
      vim.api.nvim_create_user_command('PeekClose', require('peek').close, {})
    end,
  },

  -- Neorg
  {
    "nvim-neorg/neorg",
    ft = "norg",
    cmd = "Neorg",
    build = ":Neorg sync-parsers",
    opts = {
      load = {
        ["core.defaults"] = {}, -- Loads default behaviour
        ["core.concealer"] = {
          config = {
            icon_preset = "diamond",
          }
        }, -- Adds pretty icons to your documents
        ["core.dirman"] = { -- Manages Neorg workspaces
          config = {
            workspaces = {
              notes = "~/Documents/Notes/neorg",
              nexsis = "~/Documents/Notes/NexSIS/neorg",
            },
            default_workspace = "notes",
          }
        },
        ["core.export"] = {},
        ["core.export.markdown"] = {
          config = {
            extensions = "all",
          }
        },
      },
    },
    dependencies = { { "nvim-lua/plenary.nvim" } },
  },

  -- Dressing.nvim (For nvim UI stuff)
  {
    "stevearc/dressing.nvim",
    -- lazy = false,
    opts = {},
  },

  -- Icon-picker (for picking nerd font icons, devicons, etc...)
  {
    "ziontee113/icon-picker.nvim",
    lazy = false,
    opts = {
      disable_legacy_commands = true,
    },
    dependencies = { { "stevearc/dressing.nvim" } },
  },

}

return plugins
