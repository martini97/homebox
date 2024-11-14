local utils = require("core.utils")
local logger = require("vlog"):new({ name = "ftplugin.vue", level = vim.log.levels.TRACE })

utils.ft_runtime("javascript")

local function volar_ls_setup()
	vim.lsp.start({
		name = "volar",
		cmd = { "vue-language-server", "--stdio" },
		root_dir = logger:var_debug(
			vim.fs.root(0, { "vue.config.js", "package.json", ".git" }),
			"volar:rootdir",
			{ bufnr = vim.api.nvim_get_current_buf(), bufname = vim.api.nvim_buf_get_name(0) }
		),
	})
end

volar_ls_setup()
