-- Remote development over SSH, like remote-nvim.nvim:
-- copy this config to the host, run a headless Neovim nightly there and attach a
-- local UI to it through an SSH tunnel (see `:RemoteStart` in `plugin/10_options.lua`)
-- On the host, everything is kept apart from its own Neovim setup:
-- - config in `~/.config/nvim-remote` (`NVIM_APPNAME`), plugins in `~/.local/share/nvim-remote`
-- - Neovim nightly in `~/.local/share/nvim-remote-nightly`
local M = {}

M.appname = "nvim-remote"

local notify = function(msg, level)
	vim.notify(msg, level, { title = "Remote" })
end

-- Scripts run with `sh -c '...'` on the host, so they must not contain single quotes.
-- Copy the config archive from stdin and install Neovim nightly if missing (or `update`)
local setup_script = [[
set -e
[ "$(uname -s)" = Linux ] || { echo "Only Linux hosts are supported" >&2; exit 1; }
cfg=${XDG_CONFIG_HOME:-$HOME/.config}/{appname}
bin=$HOME/.local/share/{appname}-nightly
rm -rf "$cfg" && mkdir -p "$cfg" && tar -xzf - -C "$cfg"
if [ {update} -eq 1 ] || [ ! -x "$bin/bin/nvim" ]; then
	case $(uname -m) in
		x86_64) arch=x86_64 ;;
		aarch64 | arm64) arch=arm64 ;;
		*) echo "Unsupported architecture: $(uname -m)" >&2; exit 1 ;;
	esac
	command -v curl >/dev/null || { echo "curl is required on the host" >&2; exit 1; }
	tmp=$(mktemp -d)
	curl -fsSL "https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-$arch.tar.gz" | tar -xz -C "$tmp"
	rm -rf "$bin" && mkdir -p "$(dirname "$bin")" && mv "$tmp/nvim-linux-$arch" "$bin" && rm -rf "$tmp"
fi
]]

-- Start the headless server, print READY once its socket exists, and stop it when
-- the SSH connection closes
local server_script = [[
cd "{path}" || exit 1
NVIM_APPNAME={appname} "$HOME/.local/share/{appname}-nightly/bin/nvim" --headless --listen "{sock}" &
pid=$!
trap "kill $pid 2>/dev/null" EXIT HUP INT TERM
while [ ! -S "{sock}" ]; do kill -0 $pid 2>/dev/null || exit 1; sleep 0.2; done
echo READY
wait $pid
]]

local render = function(script, vars)
	return "sh -c '" .. script:gsub("{(%w+)}", vars) .. "'"
end

-- Hosts from `~/.ssh/config` and `~/.ssh/known_hosts` (hashed and non-default port entries are skipped)
M.hosts = function()
	local hosts, seen = {}, {}
	local add = function(host)
		if host ~= "" and not seen[host] and not host:find("[*?|%[]") then
			seen[host] = true
			table.insert(hosts, host)
		end
	end
	local read = function(file)
		local ok, lines = pcall(vim.fn.readfile, vim.fn.expand(file))
		return ok and lines or {}
	end
	for _, line in ipairs(read("~/.ssh/config")) do
		for host in (line:match("^%s*[Hh]ost%s+(.+)") or ""):gmatch("%S+") do
			add(host)
		end
	end
	for _, line in ipairs(read("~/.ssh/known_hosts")) do
		for host in (line:match("^([^@#]%S*)") or ""):gmatch("[^,]+") do
			add(host)
		end
	end
	return hosts
end

local free_port = function()
	local tcp = assert(vim.uv.new_tcp())
	tcp:bind("127.0.0.1", 0)
	local port = tcp:getsockname().port
	tcp:close()
	return port
end

-- `BatchMode` makes SSH fail instead of prompting (password, unknown host key), as
-- there is no terminal to answer. Hosts need key authentication
local ssh = function(...)
	return vim.list_extend({ "ssh", "-o", "BatchMode=yes" }, { ... })
end

-- Open the local UI in a new tmux window, or in a new terminal outside of tmux
local open_ui = function(host, port)
	local client = { vim.v.progpath, "--remote-ui", "--server", "127.0.0.1:" .. port }
	local cmd = vim.env.TMUX and { "tmux", "new-window", "-n", host } or { "xdg-terminal-exec" }
	vim.system(vim.list_extend(cmd, client), { detach = true })
	notify("Connected to " .. host)
end

local start_server = function(host, path)
	local port = free_port()
	local sock = ("/tmp/%s-%d-%d.sock"):format(M.appname, port, os.time())
	local server = render(server_script, { appname = M.appname, path = path, sock = sock })
	local forward = ("127.0.0.1:%d:%s"):format(port, sock)
	local cmd = ssh("-tt", "-o", "ExitOnForwardFailure=yes", "-L", forward, host, server)
	local output, ready = {}, false
	local on_stdout = function(_, data)
		table.insert(output, data)
		if not ready and data and data:find("READY") then
			ready = true
			vim.schedule(function()
				open_ui(host, port)
			end)
		end
	end
	local on_exit = function(out)
		if ready then
			return notify("Session on " .. host .. " closed")
		end
		local msg = table.concat(output) .. (out.stderr or "")
		notify("Failed to start Neovim on " .. host .. ":\n" .. msg, vim.log.levels.ERROR)
	end
	-- Detached so the session outlives the Neovim instance which started it
	vim.system(cmd, { stdout = on_stdout, detach = true }, vim.schedule_wrap(on_exit))
end

-- Start a remote session on `host` in `path` (default: home). `update` re-downloads Neovim nightly
M.start = function(host, path, update)
	path = (path or "~"):gsub("^~", "$HOME")
	if path:find("['\"]") then
		return notify("Quotes are not supported in the path", vim.log.levels.ERROR)
	end
	notify(("Setting up %s%s"):format(host, update and " (updating Neovim nightly)" or ""))
	local config = vim.fn.stdpath("config")
	local archive = vim.system({ "tar", "-czf", "-", "--exclude=.git", "-C", config, "." }):wait()
	if archive.code ~= 0 then
		return notify("Failed to archive the config:\n" .. archive.stderr, vim.log.levels.ERROR)
	end
	local setup = render(setup_script, { appname = M.appname, update = update and 1 or 0 })
	local on_setup = function(out)
		if out.code ~= 0 then
			return notify("Failed to set up " .. host .. ":\n" .. (out.stderr or ""), vim.log.levels.ERROR)
		end
		start_server(host, path)
	end
	vim.system(ssh(host, setup), { stdin = archive.stdout, text = true }, vim.schedule_wrap(on_setup))
end

return M
