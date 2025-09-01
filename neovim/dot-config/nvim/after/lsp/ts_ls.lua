return {
	init_options = { hostInfo = "neovim" },
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
	},
	root_dir = function(bufnr, on_dir)
		local root_markers = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" }
		root_markers = vim.fn.has("nvim-0.11.3") == 1 and { root_markers } or root_markers
		local project_root = vim.fs.root(bufnr, root_markers)
		if not project_root then
			return
		end

		on_dir(project_root)
	end,
	handlers = {
		-- handle rename request for certain code actions like extracting functions / types
		["_typescript.rename"] = function(_, result, ctx)
			local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
			vim.lsp.util.show_document({
				uri = result.textDocument.uri,
				range = { start = result.position, ["end"] = result.position },
			}, client.offset_encoding)
			vim.lsp.buf.rename()
			return vim.NIL
		end,
	},
	commands = {
		["editor.action.showReferences"] = function(command, ctx)
			local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
			local file_uri, position, references = unpack(command.arguments)

			local quickfix_items = vim.lsp.util.locations_to_items(references, client.offset_encoding)
			vim.fn.setqflist({}, " ", {
				title = command.title,
				items = quickfix_items,
				context = { command = command, bufnr = ctx.bufnr },
			})

			vim.lsp.util.show_document(
				{ uri = file_uri, range = { start = position, ["end"] = position } },
				client.offset_encoding
			)

			vim.cmd("botright copen")
		end,
	},
	---@param client vim.lsp.Client
	---@param bufnr number
	on_attach = function(client, bufnr)
		vim.api.nvim_buf_create_user_command(bufnr, "LspTypescriptSourceAction", function()
			local source_actions = vim.tbl_filter(function(action)
				return vim.startswith(action, "source.")
			end, client.server_capabilities.codeActionProvider.codeActionKinds)

			---@diagnostic disable-next-line: missing-fields
			vim.lsp.buf.code_action({ context = { only = source_actions } })
		end, {})

		vim.keymap.set("n", "gri", function()
			local win = vim.api.nvim_get_current_win()
			local params = vim.lsp.util.make_position_params(win, client.offset_encoding)

			client:exec_cmd({
				title = "go_to_source_definition",
				command = "_typescript.goToSourceDefinition",
				arguments = { params.textDocument.uri, params.position },
			}, { bufnr = bufnr }, function(err, result)
				if err ~= nil then
					vim.log.error(err)
				end
				if #result < 1 then
					vim.notify("source not found", vim.log.levels.WARN)
				elseif #result == 1 then
					vim.lsp.util.show_document(result[1], client.offset_encoding)
				else
					local items = vim.lsp.util.locations_to_items(result, client.offset_encoding)
					vim.schedule(function()
						vim.fn.setqflist(items)
					end)
				end
			end)
		end, { desc = "[lsp] goto source definition", buffer = bufnr })
	end,
}
