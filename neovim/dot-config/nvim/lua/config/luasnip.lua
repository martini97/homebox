local snip_dir = vim.fs.joinpath(vim.fn.stdpath("config") --[[@as string]], "snippets")
local ls = require("luasnip")

ls.setup()
require("luasnip.loaders.from_lua").load({ paths = { snip_dir } })

--- NOTE: this fixes the snippet expansion from the omnifunc
vim.snippet.expand = ls.lsp_expand

local function feedkeys(keys)
	vim.api.nvim_feedkeys(vim.keycode(keys), "n", true)
end

vim.keymap.set({ "i", "s" }, "<c-l>", function()
	if ls.expand_or_locally_jumpable() then
		ls.expand_or_jump()
		return
	end
	feedkeys("<c-l>")
end, { desc = "[luasnip] expand or jump forward" })

vim.keymap.set({ "i", "s" }, "<c-h>", function()
	if ls.locally_jumpable(-1) then
		ls.jump(-1)
		return
	end
	feedkeys("<c-h>")
end, { desc = "[luasnip] expand or jump backwards" })

vim.keymap.set({ "i", "s" }, "<c-k>", function()
	if ls.choice_active() then
		ls.change_choice(-1)
		return
	end
	feedkeys("<c-k>")
end, { desc = "[luasnip] change choice backwards" })

vim.keymap.set({ "i", "s" }, "<c-j>", function()
	if ls.choice_active() then
		ls.change_choice(1)
		return
	end
	feedkeys("<c-j>")
end, { desc = "[luasnip] change choice forward" })

vim.keymap.set("s", "<bs>", "<c-o>s", { desc = "[luasnip] delete selection" })
