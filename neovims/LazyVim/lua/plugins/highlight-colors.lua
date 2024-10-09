return {
  "brenoprata10/nvim-highlight-colors",
  keys = {
    { "<leader>hc", "<cmd>HighlightColors On<CR>", desc = "Turn On Highlight Colors" },
    { "<leader>hC", "<cmd>HighlightColors Off<CR>", desc = "Turn Off Highlight Colors" },
  },
  opts = {
    render = "virtual",
  },
}
