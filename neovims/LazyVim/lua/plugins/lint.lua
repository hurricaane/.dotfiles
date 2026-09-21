return {
  "mfussenegger/nvim-lint",
  linters_by_ft = {
    ansible = { "ansible-lint" },
  },
  opts = {
    linters = {
      ["markdownlint-cli2"] = {
        args = { "--config", "~/.markdownlint.yaml", "--" },
      },
    },
  },
}
