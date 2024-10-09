return {
  "akinsho/git-conflict.nvim",
  version = "*",
  opts = function(_, opts)
    opts.default_mappings = {
      ours = "<leader>gCo",
      theirs = "<leader>gCt",
      none = "<leader>gC0",
      both = "<leader>gCb",
      next = "<leader>gCn",
      prev = "<leader>gCp",
    }

    local wk = require("which-key")
    wk.add({
      { "<leader>gC", group = "Conflict" },
    })
  end,
}
