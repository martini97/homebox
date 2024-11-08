---Based on this:
---https://github.com/konradmalik/neovim-flake/blob/6dba374af89a294c976d72615cca6cfca583a9f2/config/native/lua/pde/lsp/completion.lua

local M = {}

local kinds = {
	"Text",
	"Method",
	"Function",
	"Constructor",
	"Field",
	"Variable",
	"Class",
	"Interface",
	"Module",
	"Property",
	"Unit",
	"Value",
	"Enum",
	"Keyword",
	"Snippet",
	"Color",
	"File",
	"Reference",
	"Folder",
	"EnumMember",
	"Constant",
	"Struct",
	"Event",
	"Operator",
	"TypeParameter",
}

local docs_timer = assert(vim.uv.new_timer(), "cannot create timer")
local docs_debounce_ms = 500
local augroup = vim.api.nvim_create_augroup("UserCoreLsp", { clear = true })

---@param client vim.lsp.Client
---@param docs string
---@return string
local function format_docs(client, docs)
	return docs .. "\n\n_source: **" .. client.name .. "**_"
end

---@param client vim.lsp.Client
---@param complete_info { selected: integer }
---@return fun(err: lsp.ResponseError, result: any)
local function completion_item_resolve_handler(client, complete_info)
	return function(err, result)
		if err ~= nil then
			vim.notify(
				"Error from client " .. client.id .. " when getting documentation\n" .. vim.inspect(err),
				vim.log.levels.ERROR
			)
			return
		end

		local docs = vim.tbl_get(result, "documentation", "value")
		if not docs then
			return
		end

		local wininfo = vim.api.nvim__complete_set(complete_info.selected, { info = format_docs(client, docs) })
		if vim.tbl_isempty(wininfo) or not vim.api.nvim_win_is_valid(wininfo.winid) then
			return
		end

		vim.api.nvim_win_set_config(wininfo.winid, { border = "rounded" })
		vim.wo[wininfo.winid].conceallevel = 2
		vim.wo[wininfo.winid].concealcursor = "n"

		if not vim.api.nvim_buf_is_valid(wininfo.bufnr) then
			return
		end

		vim.bo[wininfo.bufnr].syntax = "markdown"
		vim.treesitter.start(wininfo.bufnr, "markdown")
	end
end

---@param client vim.lsp.Client
---@param completion_item any
---@param complete_info { selected: integer }
---@param bufnr integer
---@return fun()
local function completion_item_resolve_request(client, completion_item, complete_info, bufnr)
	return vim.schedule_wrap(function()
		client:request(
			vim.lsp.protocol.Methods.completionItem_resolve,
			completion_item,
			completion_item_resolve_handler(client, complete_info),
			bufnr
		)
	end)
end

---Format the lsp item into a completion item
---@param item lsp.CompletionItem
local function completion_convert(item)
	local kind = kinds[item.kind] or "Unknown"
	return { word = item.label, menu = "[lsp]", kind = kind }
end

---Enable builtin lsp completion
---@param client vim.lsp.Client
---@param bufnr integer
function M.enable_completion(client, bufnr)
	vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = false, convert = completion_convert })
end

---Enable documentation on builtin completion
---@param client vim.lsp.Client
---@param bufnr integer
function M.enable_completion_docs(client, bufnr)
	if not docs_timer then
		vim.notify("cannot create timer", vim.log.levels.ERROR)
		return {}
	end

	vim.api.nvim_create_autocmd("CompleteChanged", {
		group = augroup,
		buffer = bufnr,
		callback = function()
			docs_timer:stop()
			local client_id = vim.tbl_get(vim.v.completed_item, "user_data", "nvim", "lsp", "client_id")
			local completion_item = vim.tbl_get(vim.v.completed_item, "user_data", "nvim", "lsp", "completion_item")
			if client.id ~= client_id or not completion_item then
				return
			end

			local complete_info = vim.fn.complete_info({ "selected" })
			if not complete_info or vim.tbl_isempty(complete_info) then
				return
			end

			docs_timer:start(
				docs_debounce_ms,
				0,
				completion_item_resolve_request(client, completion_item, complete_info, bufnr)
			)
		end,
	})
end

return M
