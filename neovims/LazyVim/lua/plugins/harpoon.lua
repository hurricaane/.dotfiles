return {
  "ThePrimeagen/harpoon",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local keymap = vim.keymap
    local mark = require("harpoon.mark")
    local ui = require("harpoon.ui")

    require("telescope").load_extension("harpoon")

    keymap.set("n", "<leader>ha", mark.add_file, { desc = "Mark file with harpoon" })
    keymap.set("n", "<leader>he", ui.toggle_quick_menu, { desc = "Toogle harpoon quick ui" })

    keymap.set("n", "<leader>hh", "<cmd>Telescope harpoon marks<cr>", { desc = "Search through marks with Telescope" })

    keymap.set("n", "<leader>hk", function()
      ui.nav_next()
    end, { desc = "Go to previous harpoon mark" })
    keymap.set("n", "<leader>hj", function()
      ui.nav_next()
    end, { desc = "Go to next harpoon mark" })
  end,
}
