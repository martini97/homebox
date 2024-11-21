local configs = require("nvim-treesitter.configs")

configs.setup({
	ensure_installed = {
		"lua",
		"vim",
		"vimdoc",
		"query",
		"markdown",
		"markdown_inline",
		"typescript",
		"javascript",
		"jsdoc",
		"vue",
		"http",
		"python",
		"comment",
		"gitcommit",
	},
	sync_install = false,
	auto_install = false,
	ignore_install = {},
	modules = {},
	highlight = { enable = true, additional_vim_regex_highlighting = false },
	indent = { enable = true },
})

vim.api.nvim_create_autocmd("BufEnter", {
	group = vim.api.nvim_create_augroup("UserTSCompletefunc", { clear = true }),
	callback = function(ev)
		local has_parser = require("nvim-treesitter.parsers").has_parser()
		if not has_parser then
			return
		end
		vim.bo[ev.buf].completefunc = "v:lua.vim.treesitter.query.omnifunc"
	end,
})

vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
