return {
  "nvim-telescope/telescope.nvim",
  event = "VimEnter",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    { "nvim-telescope/telescope-ui-select.nvim" },
    { "debugloop/telescope-undo.nvim" },
    -- Useful for getting pretty icons, but requires a Nerd Font.
    { "nvim-tree/nvim-web-devicons" },
    "folke/todo-comments.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local themes = require("telescope.themes")

    telescope.setup({
      defaults = {
        path_display = { "smart" },
        prompt_prefix = " ",
        selection_caret = " ",
        mappings = {
          n = {
            ["<C-z>"] = actions.delete_buffer,
          },
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next, -- move to next result
            ["<C-z>"] = actions.delete_buffer,
            ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
      },
      pickers = {
        find_files = {
          hidden = true,
        },
      },
      extensions = {
        ["ui-select"] = {
          themes.get_dropdown(),
        },
        undo = {
          side_by_side = true,
          layout_strategy = "vertical",
          layout_config = {
            preview_height = 0.8,
          },
        },
      },
    })

    -- Load Telescope extensions if they are installed
    telescope.load_extension("fzf")
    telescope.load_extension("ui-select")
    telescope.load_extension("undo")
    telescope.load_extension("scope")

    local builtin = require("telescope.builtin")
    local map = vim.keymap.set
    -- Editor
    map("n", "<leader>ff", builtin.find_files, { desc = "Files" })
    map("n", "<leader>fw", builtin.grep_string, { desc = "Current word" })
    map("n", "<leader>fg", builtin.live_grep, { desc = "Grep" })
    map("n", "<leader>fd", builtin.diagnostics, { desc = "Diagnostics" })
    map("n", "<leader>f.", builtin.oldfiles, { desc = "Recent Files" })
    -- map("n", "<leader>fb", builtin.buffers, { desc = "Buffers (in current tab)" })
    map("n", "<leader>fb", "<cmd> Telescope scope buffers<CR>", { desc = "Find Buffers" })
    map("n", "<leader>gf", builtin.git_files, { desc = "Find git files" })
    map("n", "<leader>fq", builtin.quickfix, { desc = "Quickfix" })
    -- map("n", "<leader><leader>", "<cmd> Telescope scope buffers<CR>", { desc = "Find Buffers" })
    -- map("n", "<leader><leader>", function()
    --   require("telescope").extensions.smart_open.smart_open({ match_algorithm = "fzf" })
    -- end, { desc = "Smart Open" })
    map("n", "<leader>/", function()
      builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        winblend = 10,
        previewer = false,
      }))
    end, { desc = "Fuzzily search in current buffer" })
    map("n", "<leader>ft", "<cmd>TodoTelescope<CR>", { desc = "Find Todo Comments" })

    -- Utilities
    map("n", "<leader>fr", builtin.resume, { desc = "Resume Search" })
    map("n", "<leader>fc", function()
      builtin.find_files({ cwd = vim.fn.stdpath("config") })
    end, { desc = "Neovim Config" })
    map("n", "<leader>fu", "<cmd>Telescope undo<CR>", { desc = "Undo" })
    map("n", "<leader>fn", "<cmd>Telescope notify<CR>", { desc = "Notifications" })

    -- Vim functions
    map("n", "<leader>fh", builtin.help_tags, { desc = "Help" })
    map("n", "<leader>fk", builtin.keymaps, { desc = "Keymaps" })
    map("n", "<leader>f:", builtin.command_history, { desc = "Command History" })
    map("n", "<leader>fM", builtin.man_pages, { desc = "Man Pages" })

    -- Telescope
    map("n", "<leader>fs", builtin.builtin, { desc = "Telescope builtins" })
  end,
}
