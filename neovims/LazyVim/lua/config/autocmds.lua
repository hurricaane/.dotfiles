-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local function augroup(name)
  return vim.api.nvim_create_augroup("yannick_" .. name, { clear = true })
end

-- Autosource tmux
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*tmux.conf" },
  group = augroup("tmux_source"),
  command = "execute 'silent !tmux source <afile> --silent'",
})

-- Clear Yazi cache
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "yazi.toml" },
  group = augroup("yazi_clear_cache"),
  command = "execute 'silent !yazi --clear-cache'",
})

-- Disable comment creation after <CR> in Insert Mode or O/o in Normal Mode
vim.api.nvim_create_autocmd("BufEnter", {
  group = augroup("comment_creation"),
  desc = "Disable new comment creation after new line",
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- Go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(event)
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
  end,
})
