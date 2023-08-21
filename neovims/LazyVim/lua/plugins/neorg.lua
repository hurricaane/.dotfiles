-- Neorg plugin
return {
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
        },
      }, -- Adds pretty icons to your documents
      ["core.dirman"] = { -- Manages Neorg workspaces
        config = {
          workspaces = {
            notes = "~/Documents/Notes/neorg",
            nexsis = "~/Documents/Notes/NexSIS/neorg",
          },
          default_workspace = "notes",
        },
      },
      ["core.export"] = {},
      ["core.export.markdown"] = {
        config = {
          extensions = "all",
        },
      },
    },
  },
  dependencies = { { "nvim-lua/plenary.nvim" } },
}
