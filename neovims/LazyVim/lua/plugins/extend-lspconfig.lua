return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    opts.servers.yamlls.settings.yaml = vim.tbl_extend("force", opts.servers.yamlls.settings.yaml, {
      customTags = { "!reference sequence" },
    })
  end,
}
