return {
  "ravitemer/mcphub.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  build = "npm install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
  config = function()
    require("mcphub").setup()
    require("which-key").add({
      { "<leader>m", "<cmd>MCPHub<CR>", desc = "Open MCP Hub" },
    })
  end,
}
