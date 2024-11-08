return {
  "sindrets/diffview.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("diffview").setup()

    local function map(mode, l, r, desc)
      vim.keymap.set(mode, l, r, { desc = desc })
    end

    map("n", "<leader>gd", "<cmd>DiffviewOpen<CR>", "View Diff")
    map("n", "<leader>gD", "<cmd>DiffviewClose<CR>", "Close Diff")
  end,
}
