-- Configuration for nvim-0.12
-- Took inspiration from MiniMax (https://github.com/nvim-mini/MiniMax) and LazyVim (https://github.com/LazyVim/LazyVim)
-- This file is the initial file loaded on startup
-- Used here to configure global settings and helpers

-- Define config table to be able to pass data between scripts
-- It's a global variable which can be used both as `_G.Config` and `Config`
_G.Config = {}

-- Add `mini` plugin to here and configure it in `./plugin/30_mini.lua`
vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })

-- Loading helpers used to organize config into fail-safe parts. Example usage:
-- - `now` - execute immediately. Use for what must be executed during startup.
--   Like colorscheme, statusline, tabline, dashboard, etc.
-- - `later` - execute a bit later. Use for things not needed during startup.
-- - `now_if_args` - use only if needed during startup when Neovim is started
--   like `nvim -- path/to/file`, but otherwise delaying is fine.
-- - Others are better used only if the above is not enough for good performance.
--   Use only if you are comfortable with adding complexity to your config:
--   - `on_event` - execute once on a first matched event. Like "delay until
--     first Insert mode enter": `on_event('InsertEnter', function() ... end)`.
--   - `on_filetype` - execute once on a first matched filetype. Like "delay
--     until first Lua file": `on_filetype('lua', function() ... end)`.
-- See also:
-- - `:h MiniMisc.safely()`

-- stylua: ignore start
local misc = require("mini.misc")
Config.now = function(f) misc.safely("now", f) end
Config.later = function(f) misc.safely("later", f) end
Config.now_if_args = vim.fn.argc(-1) > 0 and Config.now or Config.later
Config.on_event = function(ev, f) misc.safely("event:" .. ev, f) end
Config.on_filetype = function(ft, f) misc.safely("filetype:" .. ft, f) end
Config.on_command = function(command, callback)
  vim.api.nvim_create_user_command(command, function()
    vim.api.nvim_del_user_command(command)
    callback()
    vim.cmd(command)
  end, { desc = "Single use passthrough of the user command with callback before main command" })
end

-- Define custom autocommand group and helper to create an autocommand
local gr = vim.api.nvim_create_augroup("custom-config", {})
Config.new_autocmd = function(event, pattern, callback, desc)
  local opts = { group = gr, pattern = pattern or "*", callback = callback, desc = desc }
  vim.api.nvim_create_autocmd(event, opts)
end

-- Define custom `vim.pack.add()` hook helper
Config.on_packchanged = function(plugin_name, kinds, callback, desc)
  local f = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if not (name == plugin_name and vim.tbl_contains(kinds, kind)) then return end
    -- Make sure plugin is loaded before using callback()
    if not ev.data.active then vim.cmd.packadd(plugin_name) end
    callback(ev.data)
  end
  Config.new_autocmd("PackChanged", "*", f, desc)
end

-- Colorscheme ================================================================
Config.now(function()
  vim.pack.add({
    { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
  })
  require("catppuccin").setup({
    flavour = "mocha",
    transparent_background = true,
    float = {
      transparent = true,
      solid = false,
    },
    integrations = {
      blink_cmp = true,
      gitsigns = {
        enabled = true,
        transparent = true,
      },
      snacks = {
        enabled = true,
      },
      which_key = true,
      markview = true,
      mason = true,
    },
  })
  vim.cmd("colorscheme catppuccin-nvim")
end)

-- Custom icons ================================================================
Config.icons = {
  misc = {
    dots = "󰇘",
  },
  ft = {
    octo = " ",
    gh = " ",
    ["markdown.gh"] = " ",
  },
  dap = {
    Stopped             = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
    Breakpoint          = " ",
    BreakpointCondition = " ",
    BreakpointRejected  = { " ", "DiagnosticError" },
    LogPoint            = ".>",
  },
  diagnostics = {
    Error = " ",
    Warn  = " ",
    Hint  = " ",
    Info  = " ",
  },
  git = {
    added    = " ",
    modified = " ",
    removed  = " ",
  },
  kinds = {
    Array         = " ",
    Boolean       = "󰨙 ",
    Class         = " ",
    Codeium       = "󰘦 ",
    Color         = " ",
    Control       = " ",
    Collapsed     = " ",
    Constant      = "󰏿 ",
    Constructor   = " ",
    Copilot       = " ",
    Enum          = " ",
    EnumMember    = " ",
    Event         = " ",
    Field         = " ",
    File          = " ",
    Folder        = " ",
    Function      = "󰊕 ",
    Interface     = " ",
    Key           = " ",
    Keyword       = " ",
    Method        = "󰊕 ",
    Module        = " ",
    Namespace     = "󰦮 ",
    Null          = " ",
    Number        = "󰎠 ",
    Object        = " ",
    Operator      = " ",
    Package       = " ",
    Property      = " ",
    Reference     = " ",
    Snippet       = "󱄽 ",
    String        = " ",
    Struct        = "󰆼 ",
    Supermaven    = " ",
    TabNine       = "󰏚 ",
    Text          = " ",
    TypeParameter = " ",
    Unit          = " ",
    Value         = " ",
    Variable      = "󰀫 ",
  },
}
-- stylua: ignore end
