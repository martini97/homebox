vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = ev.buf, desc = "[lsp] definition" })
		vim.keymap.set("n", "gro", vim.lsp.buf.outgoing_calls, { buffer = ev.buf, desc = "[lsp] outgoing calls" })
	end,
})

local function lsp_info(opts)
	opts = opts or {}
	opts.bang = opts.bang or false
	local filter = opts.bang and {} or { bufnr = vim.api.nvim_get_current_buf() }
	local clients = vim.lsp.get_clients(filter)
	local info = vim.iter(clients)
		:map(function(client)
			return {
				name = vim.tbl_get(client, "config", "name") or "<unknown>",
				attached_buffers = vim.tbl_keys(vim.tbl_get(client or {}, "attached_buffers") or {}),
				root_dir = client.root_dir,
				is_stopped = client.is_stopped(),
				initialized = client.initialized,
				cmd = vim.tbl_get(client, "config", "cmd") or "<unknown>",
			}
		end)
		:totable()
	vim.print(info)
end

vim.api.nvim_create_user_command("LspInfo", lsp_info, { bang = true })
