local map = vim.keymap.set -- For conciseness

map(
  "n",
  "<CR>",
  "<Cmd>lua vim.lsp.buf.definition()<CR>",
  { desc = "Open link under cursor", silent = true, noremap = true }
)
map("n", "<leader>zb", "<Cmd>ZkBacklinks<CR>", { desc = "Notes referencing this note", silent = true, noremap = true })
map(
  "n",
  "<leader>zl",
  "<Cmd>ZkLinks<CR>",
  { desc = "Notes being referenced by this note", silent = true, noremap = true }
)
