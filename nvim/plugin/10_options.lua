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
vim.o.spelllang   = "en,fr"        -- Set spell languages
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
vim.o.wrap           = false      -- Don't visually wrap lines (toggle with <Leader>uw)
vim.o.cursorlineopt  = "screenline,number" -- Show cursor line per screen line

-- Special UI symbols. More is set via 'mini.basics' later.
vim.o.fillchars = "eob: ,fold:╌"
vim.o.listchars = "extends:…,nbsp:␣,precedes:…,tab:> "

-- Tabline: " <icon> <name> " per tab (clickable), without the close button
Config.tabline = function()
  local s = ""
  for i, tab in ipairs(vim.api.nvim_list_tabpages()) do
    local win = vim.api.nvim_tabpage_get_win(tab)
    local buf = vim.api.nvim_win_get_buf(win)
    local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")
    local icon = vim.b[buf].ghosttext and "󰊠" or nil
    if name == "" then name, icon = "[No Name]", icon or "" end
    if icon == nil and _G.MiniIcons then icon = MiniIcons.get("file", name) end
    local modified = vim.bo[buf].modified and vim.bo[buf].buftype == "" and " ●" or ""
    local hl = tab == vim.api.nvim_get_current_tabpage() and "%#TabLineSel#" or "%#TabLine#"
    s = s .. hl .. "%" .. i .. "T " .. (icon or "") .. " " .. name .. modified .. " "
  end
  return s .. "%#TabLineFill#%T"
end
vim.o.tabline = "%!v:lua.Config.tabline()"

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

-- Over SSH there is no local clipboard tool: copy through the terminal with OSC 52
if Config.is_ssh then vim.g.clipboard = "osc52" end

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
local hl_yank = function()
  ---@diagnostic disable-next-line: deprecated
  if vim.hl and vim.hl.hl_op then vim.hl.hl_op() else (vim.hl or vim.highlight).on_yank() end
end
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

-- Packages: check for updates on startup (shown in lualine)
local check_pack_updates = function() require("config.pack").check() end
Config.new_autocmd("VimEnter", "*", check_pack_updates, "Check for package updates")

-- Packages: refresh the update count once after a bulk update/delete
local pack_refresh_scheduled = false
local refresh_pack_updates = function()
  if pack_refresh_scheduled then return end
  pack_refresh_scheduled = true
  vim.schedule(function()
    pack_refresh_scheduled = false
    require("config.pack").count()
  end)
end
Config.new_autocmd("PackChanged", "*", refresh_pack_updates, "Refresh package update count")

-- Remote: quit the headless server started by `:RemoteStart` once its last UI leaves
-- (`:qa` fails if there are unsaved changes, so the server stays alive in that case)
if vim.env.NVIM_APPNAME == "nvim-remote" then
  local quit_without_ui = function()
    vim.defer_fn(function() if #vim.api.nvim_list_uis() == 0 then pcall(vim.cmd.qa) end end, 100)
  end
  Config.new_autocmd("UILeave", "*", quit_without_ui, "Quit remote server without UI")
end

-- User commands ==============================================================
-- Packages (see `lua/config/pack.lua`)
local pack_update = function(opts) vim.pack.update(nil, { force = opts.bang }) end
vim.api.nvim_create_user_command("PackUpdate", pack_update, { bang = true, desc = "Update packages (! to skip confirmation)" })

local pack_check = function()
  require("config.pack").check(function(n)
    vim.notify(n == 0 and "Packages are up to date" or n .. " package(s) can be updated")
  end)
end
vim.api.nvim_create_user_command("PackCheck", pack_check, { desc = "Check for package updates" })

local pack_delete = function(opts)
  local pack = require("config.pack")
  if #opts.fargs > 0 then return pack.delete(opts.fargs) end
  vim.ui.select(pack.names(), { prompt = "Delete package" }, function(name)
    if name then pack.delete({ name }) end
  end)
end
local pack_complete = function(arg_lead)
  return vim.tbl_filter(function(n) return vim.startswith(n, arg_lead) end, require("config.pack").names())
end
vim.api.nvim_create_user_command("PackDelete", pack_delete, { nargs = "*", complete = pack_complete, desc = "Delete packages" })

local pack_clean = function()
  local pack = require("config.pack")
  local names = pack.unused()
  if #names == 0 then return vim.notify("No unused packages") end
  pack.delete(names)
end
vim.api.nvim_create_user_command("PackClean", pack_clean, { desc = "Delete packages not in the config anymore" })

-- Remote (see `lua/config/remote.lua`)
local remote_start = function(opts)
  local remote = require("config.remote")
  local host, path = opts.fargs[1], opts.fargs[2]
  if host then return remote.start(host, path, opts.bang) end
  vim.ui.select(remote.hosts(), { prompt = "SSH host" }, function(choice)
    if choice then remote.start(choice, nil, opts.bang) end
  end)
end
local remote_complete = function(arg_lead, line)
  -- Only complete the first argument (host)
  if #vim.split(line, "%s+") > 2 then return {} end
  return vim.tbl_filter(function(h) return vim.startswith(h, arg_lead) end, require("config.remote").hosts())
end
vim.api.nvim_create_user_command("RemoteStart", remote_start, {
  nargs = "*",
  bang = true,
  complete = remote_complete,
  desc = "Open this config on an SSH host: [host] [path] (! to update Neovim nightly there)",
})
-- stylua: ignore end
