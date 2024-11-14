vim.opt_local.formatprg = "black --stdin-filename % -"

require("core.formatter").register()
local logger = require("vlog"):new({ name = "ftplugin.python", level = vim.log.levels.TRACE })

vim.lsp.start({
	name = "pyright",
	cmd = { "pyright-langserver", "--stdio" },
	root_dir = logger:var_debug(
		vim.fs.root(0, {
			"pyproject.toml",
			"setup.py",
			"setup.cfg",
			"requirements.txt",
			"Pipfile",
			"pyrightconfig.json",
			".git",
		}),
		"pyright:root_dir",
		{ bufnr = vim.api.nvim_get_current_buf(), bufname = vim.api.nvim_buf_get_name(0) }
	),
	settings = {
		python = {
			analysis = { autoSearchPaths = true, useLibraryCodeForTypes = true, diagnosticMode = "openFilesOnly" },
		},
	},
})
