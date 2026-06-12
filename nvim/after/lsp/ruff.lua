return {
	cmd_env = { RUFF_TRACE = "messages" },
	init_options = {
		settings = {
			logLevel = "error",
		},
	},
	on_attach = function()
		Snacks.util.lsp.on({ name = "ruff" }, function(_, client)
			client.server_capabilities.hoverProvider = false
		end)
	end,
}
