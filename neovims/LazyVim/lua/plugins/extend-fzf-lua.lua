return {
  "ibhagwan/fzf-lua",
  keys = {
    { "<leader>,", false },
    {
      "<S-h>",
      "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<CR>",
      desc = "Switch buffers",
    },
    { "<leader>fb", "<cmd>FzfLua builtin<CR>", desc = "Builtin" },
  },
}
