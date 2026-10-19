-- Package management helpers on top of `vim.pack`
-- Keeps track of how many packages have a pending update (shown in lualine) and
-- provides the logic behind the `:Pack*` user commands (see `plugin/10_options.lua`)
local M = {}

-- Number of packages with a pending update
M.updates = 0

M.names = function()
	return vim.tbl_map(function(p)
		return p.spec.name
	end, vim.pack.get(nil, { info = false }))
end

-- Run a git command asynchronously in every package directory, then call `on_done`
local git_each = function(args, on_each, on_done)
	local plugins = vim.pack.get(nil, { info = false })
	local pending = #plugins
	if pending == 0 then
		return on_done()
	end
	for _, p in ipairs(plugins) do
		local on_exit = function(out)
			if on_each then
				on_each(p, out)
			end
			pending = pending - 1
			if pending == 0 then
				on_done()
			end
		end
		vim.system(vim.list_extend({ "git" }, args), { cwd = p.path, text = true }, vim.schedule_wrap(on_exit))
	end
end

-- Count pending updates from already fetched data.
-- `vim.pack.get()` blocks while computing pending revisions, so only ask it about
-- packages whose `HEAD` differs from `origin/HEAD`
M.count = function(on_count)
	local candidates = {}
	local add_candidate = function(p, out)
		local revs = vim.split(vim.trim(out.stdout or ""), "\n")
		if out.code ~= 0 or revs[1] ~= revs[2] then
			table.insert(candidates, p.spec.name)
		end
	end
	git_each({ "rev-parse", "HEAD", "origin/HEAD" }, add_candidate, function()
		local n = 0
		for _, p in ipairs(#candidates > 0 and vim.pack.get(candidates) or {}) do
			if p.rev_to and p.rev ~= p.rev_to then
				n = n + 1
			end
		end
		M.updates = n
		vim.cmd.redrawstatus()
		if on_count then
			on_count(n)
		end
	end)
end

-- Same fetch as `vim.pack.update()`, but without blocking, then count updates
M.check = function(on_count)
	local fetch = { "fetch", "--quiet", "--tags", "--force", "--recurse-submodules=yes", "origin" }
	git_each(fetch, nil, function()
		M.count(on_count)
	end)
end

M.delete = function(names)
	if #names == 0 then
		return
	end
	if vim.fn.confirm("Delete " .. table.concat(names, ", ") .. "?", "&Yes\n&No", 2) ~= 1 then
		return
	end
	vim.pack.del(names, { force = true })
end

-- Packages whose source isn't referenced anywhere in the config anymore
M.unused = function()
	local lines = {}
	for _, file in ipairs(vim.fn.globpath(vim.fn.stdpath("config"), "**/*.lua", false, true)) do
		vim.list_extend(lines, vim.fn.readfile(file))
	end
	local config = table.concat(lines, "\n")
	local names = {}
	for _, p in ipairs(vim.pack.get(nil, { info = false })) do
		if not config:find('"' .. p.spec.src .. '"', 1, true) then
			table.insert(names, p.spec.name)
		end
	end
	return names
end

return M
