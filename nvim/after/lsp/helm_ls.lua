-- Kubernetes schemas for Helm templates, matched from their `apiVersion`/`kind`
local sc = require("schema-companion")

return sc.setup_client(
	sc.adapters.helmls.setup({
		sources = {
			sc.sources.matchers.kubernetes.setup({ version = "master" }),
		},
	}),
	{}
)
