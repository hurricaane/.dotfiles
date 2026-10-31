-- Default filetypes plus the ones antfu's config also lints (JSON, YAML, TOML, CSS)
return {
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"vue",
		"svelte",
		"astro",
		"htmlangular",
		"json",
		"jsonc",
		"yaml",
		"toml",
		"css",
	},
	settings = {
		workingDirectories = { mode = "auto" },
		-- Hide stylistic rules in the editor, they are still fixed on save
		rulesCustomizations = {
			{ rule = "style/*", severity = "off", fixable = true },
			{ rule = "format/*", severity = "off", fixable = true },
			{ rule = "*-indent", severity = "off", fixable = true },
			{ rule = "*/indent", severity = "off", fixable = true }, -- jsonc/yaml/toml indent, missed by antfu's list
			{ rule = "*-spacing", severity = "off", fixable = true },
			{ rule = "*-spaces", severity = "off", fixable = true },
			{ rule = "*-order", severity = "off", fixable = true },
			{ rule = "*-dangle", severity = "off", fixable = true },
			{ rule = "*-newline", severity = "off", fixable = true },
			{ rule = "*quotes", severity = "off", fixable = true },
			{ rule = "*semi", severity = "off", fixable = true },
		},
	},
}
