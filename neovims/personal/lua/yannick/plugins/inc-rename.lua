return {
  "smjonas/inc-rename.nvim",
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    require("inc_rename").setup({
      input_buffer_type = "dressing",
    })
  end,
}
