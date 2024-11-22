local M = {}

---@param bufnr integer
function M.toggle_inlay_hints(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	local is_enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
	local enable = not is_enabled
	vim.lsp.inlay_hint.enable(enable, { bufnr = bufnr })
	vim.notify(string.format("[lsp] setting inlay hints to: %s", enable), vim.log.levels.INFO)
end

return M
