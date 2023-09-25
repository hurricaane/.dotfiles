return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
        "ansible-language-server",
        "yaml-language-server",
        "terraform-ls",
        "bash-language-server",
        "helm-ls",
        "pyright",
        "marksman",
        "rust-analyzer",
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        yamlls = {
          settings = {
            yaml = {
              keyOrdering = false,
            },
          },
        },
      },
    },
  },
}
