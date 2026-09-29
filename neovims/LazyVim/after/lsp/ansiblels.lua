local function pyenv_bin(bin_name)
  local found = vim.fs.find(".python-version", { path = vim.fn.getcwd(), upward = true })[1]
  if not found then
    return bin_name
  end

  local lines = vim.fn.readfile(found)
  local version = lines[1] and vim.trim(lines[1]) or nil
  if not version or version == "" then
    return bin_name
  end

  local venv_bin = vim.fn.expand("~/.pyenv/versions/" .. version .. "/bin/" .. bin_name)
  if vim.fn.executable(venv_bin) == 1 then
    return venv_bin
  end

  return bin_name
end

return {
  settings = {
    ansible = {
      ansible = { path = pyenv_bin("ansible") },
      python = { interpreterPath = pyenv_bin("python") },
      validation = { lint = { path = pyenv_bin("ansible-lint") } },
    },
  },
}
