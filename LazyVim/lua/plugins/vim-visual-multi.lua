return {
  "mg979/vim-visual-multi",
  branch = "master",
  config = function()
    vim.keymap.set("n", "<leader>vm", "<Plug>(VM-Add-Cursor-At-Pos)", { desc = "Add cursor at position" })
    vim.keymap.set("n", "<leader>vn", "<Plug>(VM-Find-Under)", { desc = "Select next occurence of the word" })
    vim.keymap.set("n", "<leader>vj", "<Plug>(VM-Add-Cursor-Down)", { desc = "Add cursor down" })
    vim.keymap.set("n", "<leader>vk", "<Plug>(VM-Add-Cursor-Up)", { desc = "Add cursor up" })
    vim.keymap.set("n", "<leader>va", "<Plug>(VM-Select-All)", { desc = "Select all occurences of the word" })

    local wk = require("which-key")
    wk.add({
      { "<leader>v", group = "Multicursor", icon = "" },
    })
  end,
}
