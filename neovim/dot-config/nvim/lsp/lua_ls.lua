return {
	cmd = { 'lua-language-server' },
	root_markers = {
		'.luarc.json',
		'.luarc.jsonc',
		'.luacheckrc',
		'.stylua.toml',
		'stylua.toml',
		'selene.toml',
		'selene.yml',
		'.git',
	},
	filetypes = { 'lua' },
	single_file_support = true,
	settings = {
		Lua = {
			runtime = { version = 'LuaJIT', },
			diagnostics = { globals = { 'vim', 'require' }, },
			workspace = { library = vim.api.nvim_get_runtime_file("", true), },
		},
	},
}
