local lsp_util = require("lspconfig.util")
local lsp = require("core.lsp")

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
	callback = lsp.attach.on_attach,
})

local servers = {
	pyright = {},
	eslint = {},
	bashls = {},
	volar = { root_dir = lsp_util.root_pattern("vue.config.js", "package.json", ".git") },
	lua_ls = {
		settings = {
			Lua = {
				runtime = { version = "LuaJIT" },
				workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME } },
				completion = { callSnippet = "Replace" },
			},
		},
	},
	vtsls = {
		settings = {
			typescript = { updateImportsOnFileMove = "always" },
			javascript = { updateImportsOnFileMove = "always" },
			vtsls = {
				autoUseWorkspaceTsdk = true,
				experimental = { completion = { enableServerSideFuzzyMatch = true, entriesLimit = 20 } },
				enableMoveToFileCodeAction = true,
			},
		},
	},
}

for name, config in pairs(servers) do
	require("lspconfig")[name].setup(lsp.caps.with_caps(config))
end
