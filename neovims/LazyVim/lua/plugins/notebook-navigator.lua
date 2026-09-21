return {
  "GCBallesteros/NotebookNavigator.nvim",
  dependencies = { "benlubas/molten-nvim", "nvim-mini/mini.comment" },
  opts = {
    cell_markers = { python = "# %%" },
    activate_hydra_keys = nil,
  },
  keys = {
    {
      "]h",
      function()
        require("notebook-navigator").move_cell("d")
      end,
      desc = "Next cell",
    },
    {
      "[h",
      function()
        require("notebook-navigator").move_cell("u")
      end,
      desc = "Prev cell",
    },
    {
      "<leader>mX",
      function()
        require("notebook-navigator").run_cell()
      end,
      desc = "Run cell",
    },
    {
      "<leader>mA",
      function()
        require("notebook-navigator").run_all_cells()
      end,
      desc = "Run all cells",
    },
  },
}
