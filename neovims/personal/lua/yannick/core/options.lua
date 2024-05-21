-- Options file
-- For conciseness
local g = vim.g
local opt = vim.opt

-- Global options
g.have_nerd_font = true
g.netrw_liststyle = 3
g.markdown_recommended_style = 0 -- Fix markdown indentation settings
g.python3_host_prog = "/home/yannick/.pyenv/versions/nvim/bin/python"

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Tabs & Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
vim.bo.softtabstop = 2

-- Line Wrapping
opt.wrap = false

-- Search Settings
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true

-- Cursor Line
opt.cursorline = true

-- Appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
opt.showmode = false
opt.conceallevel = 2
vim.diagnostic.config({
  float = { border = "rounded" }, -- add border to diagnostic popups
})

-- Backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- Clipboard
opt.clipboard:append("unnamedplus")

-- Split Windows
opt.splitright = true
opt.splitbelow = true

-- Swap file
opt.swapfile = false

-- Scroll off
opt.scrolloff = 4 -- Lines of context
opt.sidescrolloff = 8 -- Column of context

-- Mouse support
opt.mouse = "a"

-- Undo file
opt.undofile = true
