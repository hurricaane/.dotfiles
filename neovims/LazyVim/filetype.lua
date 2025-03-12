-- File to add filetype extensions
vim.filetype.add({
  -- Detect based on extension
  extension = {
    envrc = "sh",
    jinja = "jinja",
    jinja2 = "jinja",
    j2 = "jinja",
  },
  -- Detect based on entire filenames
  filename = {
    [".envrc"] = "sh",
    ["yml.j2"] = "jinja",
    ["yaml.j2"] = "jinja",
  },
  -- Detect based on regex pattern
  pattern = {
    ["Dockerfile*"] = "dockerfile",
    ["*Dockerfile"] = "dockerfile",
    [".*/hypr/.*%.conf"] = "hyprlang",
  },
})
