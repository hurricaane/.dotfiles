-- Custom mapping go here !
local M = {}

-- Disable default mappings
M.disabled = {
  -- Insert mode
  i = {
    ["jk"] = "",
  },

  -- Normal mode
  n = {
    ["<Esc>"] = "",
    ["<C-n>"] = "",
    ["<C-h>"] = "",
    ["<C-j>"] = "",
    ["<C-k>"] = "",
    ["<C-l>"] = "",
    ["<leader>e"] = "",
    ["<leader>w"] = "",
    ["<leader>wa"] = "",
    ["<leader>wl"] = "",
    ["<leader>wr"] = "",
    ["<leader>wK"] = "",
    ["<leader>wk"] = "",
    ["<leader>q"] = "",
    ["<leader>h"] = "",
    ["<leader>v"] = "",
    ["<leader>/"] = "",
    ['<leader>ip'] = "",
  },

  -- Visual mode
  v = {
    ["<leader>/"] = "",
  },
}

-- General mappings override

M.general = {
  -- insert mode
  i = {
    -- Better exit
    ["jk"] = { "<ESC>", "Exit insert mode", opts = { noremap = true, silent = true, nowait = true } },
    ["kj"] = { "<ESC>", "Exit insert mode", opts = { noremap = true, silent = true, nowait = true } },
  },

  -- Normal mode 
  n = {
    -- Saving
    ["<leader>w"] = { "<cmd> w <CR>", "Save file" },
    ["<leader>Q"] = { "<cmd> q! <CR>", "Quit file without saving" },
    ["<leader>q"] = { "<cmd> wq <CR>", "Save file and quit" },

    -- Remove highlighting
    ["<leader>h"] = { "<cmd> noh <CR>", "Clear highlights" },

    -- Dashboard
    ["<leader>a"] = { "<cmd> Nvdash <CR>", "Open Nvdash" },

    -- Start and stop LSP Server
    ["<leader>ss"] = { "<cmd> LspStart <CR>", "Start LSP server"},
    ["<leader>st"] = { "<cmd> LspStop <CR>", "Stop LSP server"},

    -- Copy into clipboard buffer
    ["<leader>y"] = { '"+y', 'Copy to clipboard' },

    -- Icon picker
    ['<leader>ip'] = { "<cmd> IconPickerYank <CR>", "Open Icon Picker (Yank) in Normal Mode" }
  },
}

M.comment = {
  plugin = true,

  -- Toggle commenting
  -- In normal mode
  n = {
    ["gcc"] = {
      function()
        require("Comment.api").toggle.linewise.current()
      end,
      "toggle comment",
    },
  },

  -- In visual mode
  v = {
    ["gcc"] = {
      "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
      "toggle comment",
    },
  },
}

M.nvimtree = {
  plugin = true,

  -- Toggle Nvim-tree
  n = {
    ["<leader>e"] = { "<cmd> NvimTreeToggle <CR>", "Toggle nvimtree" },
  },
}

M.whichkey = {
  plugin = true,

  -- List all which-key keymaps
  n = {
    ["<leader>W"] = {
      function()
        vim.cmd "WhichKey"
      end,
      "which-key all keymaps",
    },
  },
}

return M
