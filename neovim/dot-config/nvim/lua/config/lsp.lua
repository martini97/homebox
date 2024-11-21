local lsp_util = require("lspconfig.util")

---@param ev { buf: integer, data: { client_id: integer } }
local function lsp_on_attach(ev)
	---@param lhs string
	---@param rhs string|function
	---@param opts? string|vim.keymap.set.Opts
	---@param mode? string|string[]
	local map = function(lhs, rhs, opts, mode)
		opts = type(opts) == "string" and { desc = opts } or opts or {}
		opts = vim.tbl_deep_extend("error", opts --[[@as vim.keymap.set.Opts]], { buffer = ev.buf })
		mode = mode or "n"
		vim.keymap.set(mode, lhs, rhs, opts)
	end

	vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

	map("gd", vim.lsp.buf.definition, "[lsp] definition")
	map("gro", vim.lsp.buf.outgoing_calls, "[lsp] outgoing calls")

	local client = vim.lsp.get_client_by_id(ev.data.client_id)
	if not client then
		return
	end

	if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, ev.buf) then
		map("<leader>th", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }))
		end, "[lsp] toggle inlay hints")
	end

	if client:supports_method(vim.lsp.protocol.Methods.textDocument_completion, ev.buf) then
		vim.lsp.completion.enable(true, ev.data.client_id, ev.buf, { autotrigger = false })
	end
end

---@param config? lspconfig.Config
---@return lspconfig.Config
local function lsp_with_caps(config)
	config = config or {}
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})
	return config
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
	callback = lsp_on_attach,
})

local servers = {
	lua_ls = {
		settings = {
			Lua = {
				runtime = { version = "LuaJIT" },
				workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME } },
				completion = { callSnippet = "Replace" },
			},
		},
	},
	pyright = {},
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
	eslint = {},
	volar = { root_dir = lsp_util.root_pattern("vue.config.js", "package.json", ".git") },
}

for name, config in pairs(servers) do
	require("lspconfig")[name].setup(lsp_with_caps(config))
end
