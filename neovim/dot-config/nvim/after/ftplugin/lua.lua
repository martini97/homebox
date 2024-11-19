vim.opt_local.formatprg = "stylua --stdin-filepath % -"

require("core.formatter").register()

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

vim.snippet.add("fn", "function ${1:name}($2)\n\t${3:-- content}\nend", { buffer = 0 })
vim.snippet.add("lfn", "local function ${1:name}($2)\n\t${3:-- content}\nend", { buffer = 0 })
