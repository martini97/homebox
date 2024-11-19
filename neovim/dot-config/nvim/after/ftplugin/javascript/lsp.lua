local function vtsls_setup()
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
end

local function eslint_setup()
	local root_dir = vim.fs.root(0, {
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

	if not root_dir or root_dir == "" then
		return
	end

	local function open_doc(_, result)
		local url = vim.tbl_get(result or {}, "url")
		if url and url ~= "" then
			vim.ui.open(url)
		end
		return {}
	end

	vim.lsp.start({
		name = "vscode-eslint-language-server",
		cmd = { "vscode-eslint-language-server", "--stdio" },
		root_dir = root_dir,
		handlers = { ["eslint/openDoc"] = open_doc },
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
			workspaceFolder = { uri = vim.uri_from_fname(root_dir), name = vim.fs.basename(root_dir) },
			codeAction = {
				disableRuleComment = { enable = true, location = "separateLine" },
				showDocumentation = { enable = true },
			},
		},
	})
end

vtsls_setup()
eslint_setup()
