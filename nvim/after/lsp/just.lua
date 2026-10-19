-- just-lsp formats with `just --fmt` (needs `just` on PATH), on save through conform's
-- LSP fallback. Indent with 4 spaces, the `just --fmt` style (`after/ftplugin/just.lua`)
return {
	init_options = {
		formatting = {
			indentation = "    ",
		},
	},
}
