vim.opt_local.formatprg = "stylua --stdin-filepath % -"

vim.lsp.start({
	name = "lua-ls",
	cmd = { "lua-language-server" },
	root_dir = vim.fs.root(
		0,
		{ ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml" }
	),
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			workspace = {
				checkThirdParty = false,
				library = { vim.env.VIMRUNTIME },
			},
		},
	},
})
