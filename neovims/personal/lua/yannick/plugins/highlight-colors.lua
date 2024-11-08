return {
  "brenoprata10/nvim-highlight-colors",
  keys = {
    { "<leader>uc", "<cmd>HighlightColors On<CR>", desc = "Turn On Highlight Colors" },
    { "<leader>uC", "<cmd>HighlightColors Off<CR>", desc = "Turn Off Highlight Colors" },
  },
  opts = {
    render = "virtual",
  },
}
