local configs = require("nvim-treesitter.configs")

configs.setup({
	ensure_installed = {
		"beancount",
		"comment",
		"fish",
		"git_config",
		"git_rebase",
		"gitattributes",
		"gitcommit",
		"gitignore",
		"http",
		"javascript",
		"jsdoc",
		"lua",
		"markdown",
		"markdown_inline",
		"python",
		"query",
		"typescript",
		"vim",
		"vimdoc",
		"vue",
	},
	sync_install = false,
	auto_install = false,
	ignore_install = {},
	modules = {},
	highlight = { enable = true, additional_vim_regex_highlighting = false },
	indent = { enable = true },

	textobjects = {
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				["af"] = { query = "@function.outer", desc = "Outer function" },
				["if"] = { query = "@function.inner", desc = "Inner function" },
				["ac"] = { query = "@class.outer", desc = "Outer class" },
				["ic"] = { query = "@class.inner", desc = "Inner class" },
				["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
			},
			selection_modes = {
				["@parameter.outer"] = "v",
				["@function.outer"] = "V",
				["@class.outer"] = "<c-v>",
			},
			include_surrounding_whitespace = true,
		},
		move = {
			enable = true,
			set_jumps = true,
			goto_next_start = {
				["]m"] = { query = "@function.outer", desc = "next method start" },
				["]]"] = { query = "@class.outer", desc = "next class start" },
				["]s"] = { query = "@local.scope", query_group = "locals", desc = "Next scope" },
			},
			goto_next_end = {
				["]M"] = { query = "@function.outer", desc = "next method end" },
				["]["] = { query = "@class.outer", desc = "next class end" },
				["]S"] = { query = "@local.scope", query_group = "locals" },
			},
			goto_previous_start = {
				["[m"] = { query = "@function.outer", desc = "previous method start" },
				["[["] = { query = "@class.outer", desc = "previous class start" },
				["[s"] = { query = "@local.scope", query_group = "locals", desc = "Previous scope" },
			},
			goto_previous_end = {
				["[M"] = { query = "@function.outer", desc = "previous method end" },
				["[]"] = { query = "@class.outer", desc = "previous class end" },
				["[S"] = { query = "@local.scope", query_group = "locals", desc = "previous scope end" },
			},
		},
	},
})

-- vim.wo.foldmethod = "expr"
-- vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
