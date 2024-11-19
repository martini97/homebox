---Refer to <https://microsoft.github.io/language-server-protocol/specification/#snippet_syntax>
---for the specification of valid body.
---@param trigger string trigger string for snippet
---@param body string snippet text that will be expanded
---@param opts? vim.keymap.set.Opts
function vim.snippet.add(trigger, body, opts)
	vim.keymap.set("ia", trigger, function()
		-- If abbrev is expanded with keys like "(", ")", "<cr>", "<space>",
		-- don't expand the snippet. Only accept "<c-]>" as trigger key.
		local c = vim.fn.nr2char(vim.fn.getchar(0))
		if c ~= "" then
			vim.api.nvim_feedkeys(trigger .. c, "i", true)
			return
		end
		vim.snippet.expand(body)
	end, opts)
end

vim.keymap.set({ "i", "s" }, "<c-l>", function()
	if vim.snippet.active({ direction = 1 }) then
		return "<cmd>lua vim.snippet.jump(1)<cr>"
	else
		return "<c-l>"
	end
end, { expr = true })

vim.keymap.set({ "i", "s" }, "<c-h>", function()
	if vim.snippet.active({ direction = -1 }) then
		return "<cmd>lua vim.snippet.jump(-1)<cr>"
	else
		return "<c-h>"
	end
end, { expr = true })
