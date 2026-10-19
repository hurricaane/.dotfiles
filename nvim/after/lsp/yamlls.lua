-- schema-companion picks the schema of each buffer: Kubernetes manifests and CRDs from
-- their `apiVersion`/`kind`, everything else from yamlls (SchemaStore catalog below).
-- Pick another one with `<Leader>ly`
local sc = require("schema-companion")

return sc.setup_client(
	sc.adapters.yamlls.setup({
		sources = {
			sc.sources.matchers.kubernetes.setup({ version = "master" }),
			sc.sources.lsp.setup(),
			sc.sources.schemas.setup({
				{
					name = "Kubernetes (all resources, master)",
					uri = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/master-standalone-strict/all.json",
				},
			}),
			sc.sources.none.setup(),
		},
	}),
	---@diagnostic disable-next-line: missing-fields
	{
		-- Default filetypes + GitHub workflows (`yaml.ghaction`, see `plugin/40_plugins.lua`)
		filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab", "yaml.helm-values", "yaml.ghaction" },
		capabilities = {
			textDocument = {
				foldingRange = {
					dynamicRegistration = false,
					lineFoldingOnly = true,
				},
			},
		},
		before_init = function(_, new_config)
      -- stylua: ignore
      ---@diagnostic disable-next-line: inject-field
			new_config.settings.yaml.schemas = vim.tbl_deep_extend(
        "force",
        new_config.settings.yaml.schemas or {},
        require("schemastore").yaml.schemas()
      )
		end,
		settings = {
			redhat = { telemetry = { enabled = false } },
			yaml = {
				keyOrdering = false,
				format = {
					enable = true,
				},
				validate = true,
				schemaStore = {
					enable = false,
					url = "",
				},
				customTags = {
					"!reference sequence",
					"!reference mapping",
					"!reference scalar",
				},
			},
		},
	}
)
