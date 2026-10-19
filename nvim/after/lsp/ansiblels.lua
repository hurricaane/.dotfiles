-- Ansible binaries, in order: the project's pyenv version (`.python-version`), the
-- ansible-core bundled with Mason's `ansible-lint`, then whatever is on `PATH`
local mason_venv = vim.fn.stdpath("data") .. "/mason/packages/ansible-lint/venv/bin/"

local find_bin = function(name)
	local found = vim.fs.find(".python-version", { path = vim.fn.getcwd(), upward = true })[1]
	local version = found and vim.trim(vim.fn.readfile(found)[1] or "") or ""
	local candidates = {
		version ~= "" and vim.fn.expand("~/.pyenv/versions/" .. version .. "/bin/" .. name) or nil,
		mason_venv .. name,
	}
	for _, bin in ipairs(candidates) do
		if vim.fn.executable(bin) == 1 then
			return bin
		end
	end
	return name
end

return {
	settings = {
		ansible = {
			ansible = { path = find_bin("ansible") },
			python = { interpreterPath = find_bin("python") },
			validation = { lint = { enabled = true, path = find_bin("ansible-lint") } },
		},
	},
}
