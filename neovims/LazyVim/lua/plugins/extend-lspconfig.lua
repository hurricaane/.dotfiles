return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      ["*"] = {
        keys = {
          { "<C-k>", false, mode = { "i " } },
        },
      },
      yamlls = {
        settings = {
          yaml = {
            customTags = {
              "!reference sequence",
              "!reference mapping",
              "!reference scalar",
            },
          },
        },
      },
      taplo = {
        settings = {
          taplo = {
            schema = {
              associations = {
                [".*sesh\\.toml$"] = "https://github.com/joshmedeski/sesh/raw/main/sesh.schema.json",
              },
            },
          },
        },
      },
    },
  },
}
