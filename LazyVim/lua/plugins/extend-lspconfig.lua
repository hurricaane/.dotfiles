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
    },
  },
}
