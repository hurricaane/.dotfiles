-- File to add filetype extensions
vim.filetype.add({
  -- Detect based on extension
  extension = {
    envrc = "sh",
  },
  -- Detect based on entire filenames
  filename = {
    [".envrc"] = "sh",
  },
})
