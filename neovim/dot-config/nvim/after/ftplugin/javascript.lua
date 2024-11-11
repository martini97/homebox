vim.opt_local.isfname:append({ "@-@" })
vim.opt_local.suffixesadd:prepend({ ".js", ".mjs", ".cjs", ".jsx", ".ts", ".tsx", ".d.ts", ".vue", "/package.json" })

vim.lsp.start({
	name = "vtsls",
	cmd = { "vtsls", "--stdio" },
	root_dir = vim.fs.root(0, { "tsconfig.json", "jsconfig.json", "package.json", ".git" }),
	capabilities = vim.lsp.protocol.make_client_capabilities(),
	settings = {
		typescript = { updateImportsOnFileMove = "always" },
		javascript = { updateImportsOnFileMove = "always" },
		vtsls = {
			autoUseWorkspaceTsdk = true,
			experimental = { completion = { enableServerSideFuzzyMatch = true, entriesLimit = 20 } },
			enableMoveToFileCodeAction = true,
		},
	},
})

local eslint_rootdir = vim.fs.root(0, {
	".eslintrc",
	".eslintrc.js",
	".eslintrc.cjs",
	".eslintrc.yaml",
	".eslintrc.yml",
	".eslintrc.json",
	"eslint.config.js",
	"eslint.config.mjs",
	"eslint.config.cjs",
	"eslint.config.ts",
	"eslint.config.mts",
	"eslint.config.cts",
})

vim.lsp.start({
	name = "vscode-eslint-language-server",
	cmd = { "vscode-eslint-language-server", "--stdio" },
	root_dir = eslint_rootdir,
	handlers = {
		["eslint/openDoc"] = function(_, result)
			local url = vim.tbl_get(result or {}, "url")
			if not url or url == "" then
				return
			end
			vim.ui.open(url)
			return {}
		end,
	},
	settings = {
		validate = "on",
		packageManager = nil,
		useESLintClass = false,
		experimental = { useFlatConfig = false },
		codeActionOnSave = { enable = false, mode = "all" },
		format = true,
		quiet = false,
		onIgnoredFiles = "off",
		rulesCustomizations = {},
		run = "onType",
		problems = { shortenToSingleLine = false },
		nodePath = "",
		workingDirectory = { mode = "location" },
		workspaceFolder = {
			uri = vim.uri_from_fname(eslint_rootdir),
			name = vim.fs.basename(eslint_rootdir),
		},
		codeAction = {
			disableRuleComment = { enable = true, location = "separateLine" },
			showDocumentation = { enable = true },
		},
	},
})
