local M = {}

local kind = "Snippet"

---@class core.Snippet
---@field trigger string
---@field description string[]

---@param snip core.Snippet
---@return string[]
local function get_snippet_keys(snip)
	if not vim.startswith(snip.trigger, vim.pesc("\\v")) then
		return { snip.trigger }
	end
	return vim.split(snip.trigger:sub(3), "|", { trimempty = true, plain = true })
end

---@param bufnr? integer
---@return table<string, core.Snippet>
function M.list_snippets(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()

	local available = require("luasnip").available() or {}
	local ft = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
	return vim.iter(vim.list_extend(available.all or {}, available[ft] or {})):fold({}, function(acc, snip)
		for _, key in pairs(get_snippet_keys(snip)) do
			acc[key] = snip
		end
		return acc
	end)
end

---@param findstart integer
---@param base string
function M.completefunc(findstart, base)
	local snippets = M.list_snippets()
	local triggers = vim.tbl_keys(snippets)

	if findstart == 1 then
		local col = vim.fn.col(".") - 1
		local line = string.sub(vim.fn.getline(".") or "", 1, col)
		return vim.fn.match(line, "\\k*$")
	end

	if #triggers < 1 then
		return {}
	end

	local parts = vim.split(base, "%s+", { plain = false, trimempty = false })
	local word = parts[#parts] or ""
	return vim.iter(triggers)
		:filter(function(trig)
			return vim.startswith(trig, word)
		end)
		:map(function(trig)
			local snip = snippets[trig]
			return {
				word = trig,
				menu = "[luasnip]",
				kind = kind,
				user_data = snip,
				info = table.concat(snip.description, "\n"),
			}
		end)
		:totable()
end

vim.api.nvim_create_autocmd("CompleteDone", {
	group = vim.api.nvim_create_augroup("UserSnippetCompleteDone", { clear = true }),
	callback = function()
		local item = vim.v.completed_item
		local event = vim.v.event or {}

		if event.reason ~= "accept" or item.kind ~= kind or not vim.tbl_get(item, "user_data", "trigger") then
			return
		end
		require("luasnip").expand()
	end,
})

return M
