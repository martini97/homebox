local M = {}

---@param config? lspconfig.Config
---@return lspconfig.Config
function M.with_caps(config)
	config = config or {}
	local capabilities =
		vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities(), config.capabilities or {})
	return vim.tbl_deep_extend("force", { capabilities = capabilities }, config)
end

return M
