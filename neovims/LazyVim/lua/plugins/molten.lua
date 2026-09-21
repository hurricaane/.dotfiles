return {
  "benlubas/molten-nvim",
  version = "*",
  build = ":UpdateRemotePlugins",
  init = function()
    vim.g.molten_image_provider = "snacks"
    vim.g.molten_output_win_max_height = 20
  end,
  -- keys = {
  --   { "<leader>mi", "<cmd>MoltenInit<cr>", desc = "Init kernel" },
  --   { "<leader>ml", "<cmd>MoltenEvaluateLine<cr>", desc = "Evaluate line" },
  --   { "<leader>mc", "<cmd>MoltenReevaluateCell<cr>", desc = "Re-evaluate cell" },
  --   { "<leader>md", "<cmd>MoltenDelete<cr>", desc = "Delete cell" },
  --   { "<leader>mo", "<cmd>MoltenShowOutput<cr>", desc = "Show output" },
  --   { "<leader>mr", "<cmd>MoltenRestart!<cr>", desc = "Restart kernel" },
  --   { "<leader>ms", "<cmd>MoltenInterrupt<cr>", desc = "Interrupt kernel" },
  --   {
  --     "<leader>mv",
  --     "<cmd>MoltenEvaluateVisual<cr>",
  --     mode = "v",
  --     desc = "Evaluate visual selection",
  --   },
  -- },
}
