local M = {}

local function setup_compl_caps(capabilities)
	local ok, cmp_or_err = pcall(require, "blink.cmp")
	if not ok then
		return capabilities
	end
	return cmp_or_err.get_lsp_capabilities(capabilities)
end

---@param config? lspconfig.Config
---@return lspconfig.Config
function M.with_caps(config)
	config = config or {}
	local capabilities =
		vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities(), config.capabilities or {})
	config = vim.tbl_deep_extend("force", { capabilities = capabilities }, config)
	config.capabilities = setup_compl_caps(config.capabilities)
	return config
end

return M
