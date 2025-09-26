return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    local keys = require("lazyvim.plugins.lsp.keymaps").get()
    keys[#keys + 1] = { "<c-k>", false, mode = { "i" } }

    -- customize yaml server
    LazyVim.extend(opts.servers.yamlls, "settings.yaml.customTags", {
      "!reference sequence",
      "!reference mapping",
      "!reference scalar",
    })
  end,
}
