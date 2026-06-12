-- Keymaps file
-- stylua: ignore start

-- Helper functions ===========================================================
local map = vim.keymap.set
local map_leader = function(suffix, rhs, opts)
	map("n", "<Leader>" .. suffix, rhs, opts)
end
local xmap_leader = function(suffix, rhs, opts)
	map("x", "<Leader>" .. suffix, rhs, opts)
end

-- General mappings ===========================================================
-- Better j and k + add movement to the jumplist
local better_jk = function(key)
  if vim.v.count > 0 then
    return "m'" .. vim.v.count .. key
  else
    return "g" .. tostring(key)
  end
end
map({ "n", "x" }, "j", better_jk("j"), { desc = "Better 'j' movement + add count to jumplist", silent = true })
map({ "n", "x" }, "k", better_jk("k"), { desc = "Better 'k' movement + add count to jumplist", silent = true })

-- Center screen on <C-u> and <C-d> movements + add movement to jumplist
local better_movement = function(movement)
  vim.api.nvim_feedkeys("m'", "n", false)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(movement, true, false, true), "n", false)
  vim.api.nvim_feedkeys("m'zz", "n", false)
end
map("n", "<C-d>", function() better_movement("<C-d>") end, { desc = "Scroll half a page down", remap = false, silent = true })
map("n", "<C-u>", function() better_movement("<C-u>") end, { desc = "Scroll half a page up",   remap = false, silent = true })

-- Change windows with <Ctrl-hjkl>
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window",  remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- Move with <M-HJKL> in insert mode
map("i", "<M-H>", "<Left>",  { desc = "Left",  remap = true })
map("i", "<M-J>", "<Down>",  { desc = "Down",  remap = true })
map("i", "<M-K>", "<Up>",    { desc = "Up",     remap = true })
map("i", "<M-L>", "<Right>", { desc = "Right", remap = true })

-- Move lines of code
map("n", "<A-;>", "<cmd>execute 'move .+' . v:count1<cr>==",                   { desc = "Move Down" })
map("n", "<A-,>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==",             { desc = "Move Up" })
map("i", "<A-;>", "<esc><cmd>m .+1<cr>==gi",                                   { desc = "Move Down" })
map("i", "<A-,>", "<esc><cmd>m .-2<cr>==gi",                                   { desc = "Move Up" })
map("v", "<A-;>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv",       { desc = "Move Down" })
map("v", "<A-,>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

-- LSP
map("n", "K", function() vim.lsp.buf.hover() end, { desc = "Hover (LSP)" })
map("n", "gK", function() vim.lsp.buf.signature_help() end, { desc = "Signature Help (LSP)" })
map("i", "<C-k>", function() vim.lsp.buf.signature_help() end, { desc = "Signature Help (LSP)" })

-- Jump between LSP references (Snacks.words)
map("n", "]]", function() Snacks.words.jump(vim.v.count1) end, { desc = "Next reference" })
map("n", "[[", function() Snacks.words.jump(-vim.v.count1) end, { desc = "Prev reference" })

-- Flash
map({ "n", "x", "o" }, "s", function() require("flash").jump() end, { desc = "Flash" })
map({ "n", "x", "o" }, "S", function() require("flash").treesitter() end, { desc = "Flash Treesitter" })

-- Todo Comments
map("n", "]t", function() require("todo-comments").jump_next() end, { desc = "Next Todo" })
map("n", "[t", function() require("todo-comments").jump_prev() end, { desc = "Prev Todo" })

-- Leader mappings ============================================================
-- Create a global table with information about Leader groups
Config.leader_groups = {
  { "<Leader>b",  group = "Buffers",      icon = " " },
  { "<Leader>e",  group = "Explore/Edit", icon = " " },
  { "<Leader>f",  group = "Find",         icon = " " },
  { "<Leader>g",  group = "Git",          icon = " " },
  { "<Leader>gh", group = "Hunks",        icon = " " },
  { "<Leader>l",  group = "Language",     icon = " " },
  { "<Leader>s",  group = "Session",      icon = " " },
}

-- Buffers
map_leader("ba", "<Cmd>b#<CR>",                                                             { desc = "Go to alternate buffer" })
map_leader("bb", function() Snacks.picker.buffers({ current = false, layout = "ivy" }) end, { desc = "Show buffer list" })
map_leader("bd", function() Snacks.bufdelete() end,                                         { desc = "Delete buffer" })
map_leader("bD", "<Cmd>bd<CR>",                                                             { desc = "Delete buffer and window" })
map_leader("bo", function() Snacks.bufdelete.other() end,                                   { desc = "Delete other buffers" })

-- Explore / Edit
local edit_plugin_file = function(filename)
  return string.format("<Cmd>edit %s/plugin/%s<CR>", vim.fn.stdpath("config"), filename)
end
local explore_at_file = function() MiniFiles.open(vim.api.nvim_buf_get_name(0)) end
local explore_quickfix = function()
  vim.cmd(vim.fn.getqflist({ winid = true }).winid ~= 0 and "cclose" or "copen")
end
local explore_locations = function()
  vim.cmd(vim.fn.getloclist(0, { winid = true }).winid ~= 0 and "lclose" or "lopen")
end
map_leader("ed", function() MiniFiles.open() end,              { desc = "Open current working directory" })
map_leader("ef", explore_at_file,                              { desc = "Open directory of the current file" })
map_leader("ei", "<Cmd>edit $MYVIMRC<CR>",                     { desc = "Edit init.lua config" })
map_leader("ek", edit_plugin_file("20_keymaps.lua"),           { desc = "Edit keymaps config" })
map_leader("em", edit_plugin_file("30_mini.lua"),              { desc = "Edit mini config" })
map_leader("en", function() Snacks.picker.notifications() end, { desc = "Open notifications list" })
map_leader("eo", edit_plugin_file("10_options.lua"),           { desc = "Edit options config" })
map_leader("ep", edit_plugin_file("40_plugins.lua"),           { desc = "Edit plugins config" })
map_leader("eq", explore_quickfix,                             { desc = "Open quickfix list" })
map_leader("eQ", explore_locations,                            { desc = "Open location list" })

-- Fuzzy Find - Picker
map_leader("f:", function() Snacks.picker.command_history() end,    { desc = "Command history" })
map_leader("f/", function() Snacks.picker.search_history() end,     { desc = "Search history" })
map_leader("fb", function() Snacks.picker.lines() end,              { desc = "Buffer lines" })
map_leader("fB", function() Snacks.picker.grep_buffers() end,       { desc = "Grep open buffers" })
map_leader("fd", function() Snacks.picker.diagnostics() end,        { desc = "Diagnostics" })
map_leader("fD", function() Snacks.picker.diagnostics_buffer() end, { desc = "Buffer diagnostics" })
map_leader("ff", function() Snacks.picker.files() end,              { desc = "Files" })
map_leader("fg", function() Snacks.picker.grep() end,               { desc = "Grep" })
map_leader("fh", function() Snacks.picker.help() end,               { desc = "Help"} )
map_leader("fH", function() Snacks.picker.highlights() end,         { desc = "Highlights" })
map_leader("fi", function() Snacks.picker.icons() end,              { desc = "Icons" })
map_leader("fp", function() Snacks.picker() end,                    { desc = "Pickers" })
map_leader("fr", function() Snacks.picker.resume() end,             { desc = "Resume search" })
map_leader("ft", "<Cmd>TodoSnacks<CR>",                             { desc = "Todos" })
map_leader("fu", function() Snacks.picker.undo() end,               { desc = "Undo history" })
map_leader("fw", function() Snacks.picker.grep_word() end,          { desc = "Word under cursor" })

-- Git
map_leader("gd", "<Cmd>CodeDiff<CR>",                                                        { desc = "Diff (CodeDiff)" })
map_leader("gf", function() Snacks.picker.git_log_file() end,                                { desc = "Git file history (buffer)" })
map_leader("gl", function() Snacks.picker.git_log({ cwd = vim.fs.root(0, ".git") }) end,     { desc = "Git log" })

-- Language
local inc_rename = function()
  return "<Cmd>IncRename " .. vim.fn.expand("<cword>")
end
map_leader("la", function() vim.lsp.buf.code_actions() end,                                                    { desc = "Code actions" })
map_leader("ld", function() vim.diagnostic.open_float() end,                                                   { desc = "Diagnostics (line)" })
map_leader("lD", function() Snacks.picker.diagnostics() end,                                                   { desc = "Diagnostics (project)" })
map_leader("lf", function() require("conform").format() end,                                                   { desc = "Format" })
map_leader("lF", function() require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 }) end, { desc = "Format injected langs" })
map_leader("li", function() Snacks.picker.lsp_config() end,                                                    { desc = "LSP Info" })
map_leader("lI", function() Snacks.picker.lsp_implementations() end,                                           { desc = "Implementation" })
map_leader("lr", inc_rename,                                                                                   { desc = "Rename symbol", expr = true })
map_leader("lR", function() Snacks.rename.rename_file() end,                                                   { desc = "Rename file" })
map_leader("ls", function() Snacks.picker.lsp_definitions() end,                                               { desc = "Source definition" })
map_leader("lS", function() Snacks.picker.lsp_references() end,                                                { desc = "References", nowait = true })
map_leader("lt", function() Snacks.picker.lsp_type_definitions() end,                                          { desc = "Type definition" })
xmap_leader("lf", function() require("conform").format() end,                                                  { desc = "Format selection" })

-- Session (Persistence)
map_leader("ss", function() require("persistence").load() end,                { desc = "Restore session" })
map_leader("sS", function() require("persistence").select() end,              { desc = "Select session" })
map_leader("sl", function() require("persistence").load({ last = true }) end, { desc = "Restore last session" })
map_leader("sd", function() require("persistence").stop() end,                { desc = "Stop persistence" })
-- stylua: ignore end
