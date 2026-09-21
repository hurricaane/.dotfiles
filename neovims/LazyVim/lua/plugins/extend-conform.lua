return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    opts.formatters = opts.formatters or {}
    opts.formatters.just = {
      command = "just",
      args = { "--fmt", "-f", "$FILENAME" },
      stdin = false,
    }
    opts.formatters_by_ft = opts.formatters_by_ft or {}
    opts.formatters_by_ft.just = { "just" }
  end,
}
