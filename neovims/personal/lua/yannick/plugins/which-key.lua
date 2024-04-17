return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
  config = function()
    local which_key = require("which-key")
    which_key.setup()

    -- Document existing keychains
    which_key.register({
      ["gs"] = { name = "Surround", _ = "which_key_ignore" },
      ["<leader>b"] = { name = "Buffer", _ = "which_key_ignore" },
      ["<leader>c"] = { name = "Code / LSP", _ = "which_key_ignore" },
      ["<leader>f"] = { name = "Find", _ = "which_key_ignore" },
      ["<leader>g"] = { name = "Git", _ = "which_key_ignore" },
      ["<leader>i"] = { name = "Icon", _ = "which_key_ignore" },
      ["<leader>m"] = { name = "Markdown", _ = "which_key_ignore" },
      ["<leader>s"] = { name = "Split", _ = "which_key_ignore" },
      ["<leader>t"] = { name = "Tabs", _ = "which_key_ignore" },
      ["<leader>u"] = { name = "UI", _ = "which_key_ignore" },
      ["<leader>x"] = { name = "Trouble", _ = "which_key_ignore" },
    })
  end,
}
