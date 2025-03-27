local M = {}
local comp = require("core.lsp.completion")
local helpers = require("core.lsp.helpers")
local methods = vim.lsp.protocol.Methods

---@param ev { buf: integer, data: { client_id: integer } }
function M.on_attach(ev)
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

	---@param fn fun(bufnr: integer)
	local buf_call = function(fn)
		return function()
			return fn(ev.buf)
		end
	end

	vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

	map("gd", vim.lsp.buf.definition, "[lsp] definition")
	map("gro", vim.lsp.buf.outgoing_calls, "[lsp] outgoing calls")

	local client = vim.lsp.get_client_by_id(ev.data.client_id)
	if not client then
		return
	end

	if client:supports_method(methods.textDocument_inlayHint, ev.buf) then
		map("<leader>th", buf_call(helpers.toggle_inlay_hints), "[lsp] toggle inlay hints")
	end

	if client:supports_method(methods.textDocument_codeLens, ev.buf) then
		map("<leader>tl", buf_call(helpers.toggle_inlay_hints), "[lsp] toggle code lens")
	end

	if client:supports_method(methods.textDocument_completion, ev.buf) then
		comp.enable_completion(client, ev.buf)

		if client:supports_method(methods.completionItem_resolve, ev.buf) then
			comp.enable_completion_docs(client, ev.buf)
		end
	end
end

return M
