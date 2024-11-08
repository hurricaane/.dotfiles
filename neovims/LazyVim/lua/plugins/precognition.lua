return {
  "tris203/precognition.nvim",
  keys = {
    { "<leader>P", "<cmd>Precognition toggle<CR>", desc = "Toggle Precognition" },
  },
  opts = {
    startVisible = false,
    disabled_fts = {
      "lazy",
      "dashboard",
    },
  },
}
