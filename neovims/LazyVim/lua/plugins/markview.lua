return {
  "OXY2DEV/markview.nvim",
  lazy = false, -- Recommended
  -- ft = "markdown" -- If you decide to lazy-load anyway

  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "echasnovski/mini.nvim",
  },
  opts = {
    preview = {
      filetypes = { "markdown", "norg", "rmd", "org", "vimwiki", "Avante" },
      ignore_buftypes = {},
    },
  },
  config = function(_, opts)
    require("markview").setup(opts)
    --- Setup markview code editor
    require("markview.extras.editor").setup({
      --- The minimum & maximum window width
      --- If the value is smaller than 1 then
      --- it is used as a % value.
      ---@type [ number, number ]
      width = { 10, 0.75 },

      --- The minimum & maximum window height
      ---@type [ number, number ]
      height = { 3, 0.75 },

      --- Delay(in ms) for window resizing
      --- when typing.
      ---@type integer
      debounce = 50,

      --- Callback function to run on
      --- the floating window.
      ---@type fun(buf:integer, win:integer): nil
      callback = function(buf, win) end,
    })
    local wk = require("which-key")
    local map = vim.keymap.set

    -- Create markview keymaps
    wk.add({
      { "<leader>m", group = "MarkView" },
    })
    map("n", "<leader>ms", "<cmd>Markview splitToggle<CR>", { desc = "Toggle split view" })
    map("n", "<leader>mo", "<cmd>MarkOpen<CR>", { desc = "Open link under cursor" })
    map("n", "<leader>mc", "<cmd>CodeCreate<CR>", { desc = "Create code block" })
    map("n", "<leader>me", "<cmd>CodeEdit<CR>", { desc = "Edit code block" })
  end,
}
