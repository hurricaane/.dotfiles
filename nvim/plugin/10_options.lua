-- Options files
-- stylua: ignore start

-- Disabled Builtin plugins ===================================================
local disabled_builtins = {
  "gzip",
  "matchit",
  "matchparen",
  "netrwPlugin",
  "tarPlugin",
  "tohtml",
  "zipPlugin",
}
for _, plugin in ipairs(disabled_builtins) do
  vim.g["loaded_" .. plugin] = 1
end

-- General ====================================================================
vim.g.mapleader                  = " "
-- vim.g.localleader                = "\\"
vim.g.markdown_recommended_style = 0 -- Fix markdown indentation settings

vim.o.mouse       = "a"            -- Enable mouse
vim.o.mousescroll = "ver:25,hor:6" -- Customize mouse scroll
vim.o.spelllang   = "en,fr_fr"     -- Set spell languages
vim.o.switchbuf   = "usetab"       -- Use already opened buffers when switching
vim.o.timeoutlen  = 300            -- Lower than default (1000) to quickly trigger which-key
vim.o.undofile    = true           -- Enable persistent undo
vim.o.updatetime  = 200            -- Save swap file and trigger CursorHold
-- Set session options for saving options when restoring sessions
vim.o.sessionoptions = "buffers,curdir,tabpages,winsize,help,globals,skiprtp,folds,localoptions"
vim.o.shada = "'100,<50,s10,:1000,/100,@100,h" -- Limit ShaDa file (for startup)

-- Enable all filetype plugins and syntax (if not enabled, for better startup)
vim.cmd('filetype plugin indent on')
if vim.fn.exists('syntax_on') ~= 1 then vim.cmd('syntax enable') end

-- UI =========================================================================
vim.o.breakindent    = true       -- Indent wrapped lines to match line start
vim.o.breakindentopt = "list:-1"  -- Add padding for lists (if 'wrap' is set)
vim.o.cmdheight      = 0          -- Remove cmdline height
vim.o.cursorline     = true       -- Enable current line highlighting
vim.o.laststatus     = 3          -- Have 1 statusline for all windows
vim.o.linebreak      = true       -- Wrap lines at 'breakat' (if 'wrap' is set)
vim.o.list           = true       -- Show helpful text indicators
vim.o.number         = true       -- Show line numbers
vim.o.pumborder      = "rounded"  -- Use border in popup menu
vim.o.pumheight      = 10         -- Make popup menu smaller
vim.o.pummaxwidth    = 100        -- Make popup menu not too wide
vim.o.relativenumber = true       -- Add relative line numbers
vim.o.ruler          = false      -- Don't show cursor coordinates
vim.o.scrolloff      = 4          -- Lines of context
vim.o.showmode       = false      -- Don't show mode in command line
vim.o.signcolumn     = "yes"      -- Always show signcolumn (less flicker)
vim.o.splitbelow     = true       -- Horizontal splits will be below
vim.o.splitkeep      = "screen"   -- Reduce scroll during window split
vim.o.splitright     = true       -- Vertical splits will be to the right
vim.o.winborder      = "rounded"  -- Use border in floating windows
vim.o.wrap           = false      -- Don't visually wrap lines (toggle with \w)
vim.o.cursorlineopt  = "screenline,number" -- Show cursor line per screen line

-- Special UI symbols. More is set via 'mini.basics' later.
vim.o.fillchars = "eob: ,fold:╌"
vim.o.listchars = "extends:…,nbsp:␣,precedes:…,tab:> "

-- Folds (see `:h fold-commands`, `:h zM`, `:h zR`, `:h zA`, `:h zj`)
vim.o.foldlevel   = 10       -- Fold nothing by default; set to 0 or 1 to fold
vim.o.foldmethod  = "indent" -- Fold based on indent level
vim.o.foldnestmax = 10       -- Limit number of fold levels
vim.o.foldtext    = ""       -- Show text under fold with its highlighting

-- Editing ====================================================================
vim.o.autoindent    = true          -- Use auto indent
vim.o.clipboard     = "unnamedplus" -- Sync with system clipboard
vim.o.expandtab     = true          -- Convert tabs to spaces
vim.o.formatoptions = "rqnl1j"      -- Improve comment editing
vim.o.ignorecase    = true          -- Ignore case during search
vim.o.incsearch     = true          -- Show search matches while typing
vim.o.infercase     = true          -- Infer case in built-in completion
vim.o.shiftwidth    = 2             -- Use this number of spaces for indentation
vim.o.smartcase     = true          -- Respect case if search pattern has upper case
vim.o.smartindent   = true          -- Make indenting smart
vim.o.spelloptions  = "camel"       -- Treat camelCase word parts as separate words
vim.o.tabstop       = 2             -- Show tab as this number of spaces
vim.o.virtualedit   = "block"       -- Allow going past end of line in blockwise mode
vim.o.iskeyword = "@,48-57,_,192-255,-" -- Treat dash as `word` textobject part

-- Pattern for a start of numbered list (used in `gw`). This reads as
-- "Start of list item is: at least one special character (digit, -, +, *)
-- possibly followed by punctuation (. or `)`) followed by at least one space".
vim.o.formatlistpat = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]

-- Built-in completion
vim.o.complete        = ".,w,b,kspell"                  -- Use less sources
vim.o.completeopt     = "menuone,noselect,fuzzy,nosort" -- Use custom behavior
vim.o.completetimeout = 100                             -- Limit sources delay
vim.o.wildmode        = "longest:full,full"             -- Command-line completion mode

-- Autocommands ===============================================================
-- Don't auto-wrap comments and don't insert comment leader after hitting 'o'.
-- Do on `FileType` to always override these changes from filetype plugins.
local f = function() vim.cmd('setlocal formatoptions-=c formatoptions-=o') end
Config.new_autocmd('FileType', nil, f, "Proper 'formatoptions'")

-- Go to last location when opening a buffer
local last_location = function(event)
  local exclude = { "gitcommit" }
  local buf = event.buf
  if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].last_loc then
    return
  end
  vim.b[buf].last_loc = true
  local mark = vim.api.nvim_buf_get_mark(buf, '"')
  local lcount = vim.api.nvim_buf_line_count(buf)
  if mark[1] > 0 and mark[1] <= lcount then
    pcall(vim.api.nvim_win_set_cursor, 0, mark)
  end
end
Config.new_autocmd("BufReadPost", "*", last_location, "Restore cursor location on last edit")

-- Check if we need to reload the file when it changed
local check_reload_file = function()
  if vim.o.buftype ~= "nofile" then
    vim.cmd("checktime")
  end
end
Config.new_autocmd({ "FocusGained", "TermClose", "TermLeave" }, "*", check_reload_file, "Reload file if focus changed")

-- Highlight text on yank
local hl_yank = function() (vim.hl or vim.highlight).on_yank() end
Config.new_autocmd("TextYankPost", "*", hl_yank, "Highlight text on yank")

-- Auto create dir when saving a file, in case some intermediate directory does not exist
local auto_create_dir = function(event)
  if event.match:match("^%w%w+:[\\/][\\/]") then
    return
  end
  local file = vim.uv.fs_realpath(event.match) or event.match
  vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
end
Config.new_autocmd("BufWritePre", "*", auto_create_dir, "Auto create directory when saving files if necessary")

-- FileType specific configuration
local filetypes = {
  "PlenaryTestPopup",
  "checkhealth",
  "dap-float",
  "dbout",
  "gitsigns-blame",
  "help",
  "lspinfo",
  "neotest-output",
  "neotest-output-panel",
  "neotest-summary",
  "notify",
  "qf",
  "startuptime",
  "tsplayground",
}
local close_filetypes = function(event)
  vim.bo[event.buf].buflisted = false
  vim.schedule(function()
    vim.keymap.set("n", "q", function()
      vim.cmd("close")
      pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
    end, {
        buffer = event.buf,
        silent = true,
        desc = "Quit buffer",
      })
  end)
end
local ft_configs = {
  {
    ft = { "json", "jsonc", "json5" },
    cb = function() vim.opt_local.conceallevel = 0 end,
    desc = "Fix conceal for JSON"
  },
  {
    ft = { "gitcommit", "markdown", "plaintex", "text", "typst" },
    cb = function() vim.opt_local.spell = true end,
    desc = "Enable spellcheck"
  },
  {
    ft = filetypes,
    cb = close_filetypes,
    desc = "Close with q"
  },
}
for _, cfg in ipairs(ft_configs) do
  Config.new_autocmd("FileType", cfg.ft, cfg.cb, cfg.desc)
end
-- stylua: ignore end
