-- Ansible binaries, in order: the project's virtualenv (`$VIRTUAL_ENV`, set by mise's
-- `_.python.venv`), the ansible-core bundled with Mason's `ansible-lint`, then `PATH`
local mason_venv = vim.fn.stdpath("data") .. "/mason/packages/ansible-lint/venv/bin/"

local find_bin = function(name)
	local venv = vim.env.VIRTUAL_ENV
	local candidates = {
		venv and venv .. "/bin/" .. name or nil,
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
