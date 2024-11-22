local M = {}

local code_lens_state = {}

---@param bufnr? integer
function M.toggle_inlay_hints(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	local is_enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
	local enable = not is_enabled
	vim.lsp.inlay_hint.enable(enable, { bufnr = bufnr })
	vim.notify(string.format("[lsp] setting inlay hints to: %s", enable), vim.log.levels.INFO)
end

---@param bufnr? integer
function M.toggle_code_lens(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	local is_enabled = code_lens_state[bufnr] ~= false
	if is_enabled then
		vim.lsp.codelens.clear(nil, bufnr)
	else
		vim.lsp.codelens.refresh({ bufnr = bufnr })
	end
	code_lens_state[bufnr] = not is_enabled
	vim.notify(string.format("[lsp] setting code lens to: %s", not is_enabled), vim.log.levels.INFO)
end

return M
