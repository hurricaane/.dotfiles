return {
  "nvim-telescope/telescope.nvim",
  keys = {
    { "<leader>,", false },
    {
      "<S-h>",
      "<cmd>Telescope buffers sort_mru=true sort_lastused=true initial_mode=normal theme=ivy<CR>",
      desc = "Switch buffers",
    },
    { "<leader>fb", "<cmd>Telescope builtin<cr>", desc = "Builtin" },
  },
  opts = function(_, opts)
    local actions = require("telescope.actions")

    opts.defaults.mappings.i = vim.tbl_extend("force", opts.defaults.mappings.i, {
      ["<C-j>"] = actions.move_selection_next,
      ["<C-k>"] = actions.move_selection_previous,
    })

    opts.defaults.mappings.n = vim.tbl_extend("force", opts.defaults.mappings.n, {
      ["d"] = actions.delete_buffer,
    })
  end,
}
