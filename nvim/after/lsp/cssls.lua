-- Ignore Tailwind directives (`@apply`, `@theme`, `@tailwind`, ...)
return {
	settings = {
		css = { lint = { unknownAtRules = "ignore" } },
		scss = { lint = { unknownAtRules = "ignore" } },
		less = { lint = { unknownAtRules = "ignore" } },
	},
}
