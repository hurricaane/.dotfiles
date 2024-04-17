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
    map("n", "<leader>gc", "<cmd>DiffviewClose<CR>", "Close Diff")
    map("n", "<leader>gD", function()
      local input = vim.fn.input("Diff Option: ")
      vim.cmd(string.format("DiffviewOpen %s", input))
    end, "View Diff (User Input)")
  end,
}
