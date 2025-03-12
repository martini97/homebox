local lsp_util = require("lspconfig.util")
local lsp = require("core.lsp")
local typescript_sdk = vim.fs.joinpath(vim.uv.os_homedir(), ".local", "lib", "node_modules", "typescript", "lib")

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
	callback = lsp.attach.on_attach,
})

local servers = {
	pyright = {},
	eslint = {},
	bashls = {},
	volar = {
		root_dir = lsp_util.root_pattern("vue.config.js", "package.json", ".git"),
		init_options = {
			typescript = { tsdk = typescript_sdk },
		},
		on_new_config = function(new_config, new_root_dir)
			local lib_path = vim.fs.find("node_modules/typescript/lib", { path = new_root_dir, upward = true })[1]
			if lib_path then
				new_config.init_options.typescript.tsdk = lib_path
			end
		end,
	},
	lua_ls = {
		settings = {
			Lua = {
				runtime = { version = "LuaJIT" },
				workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME } },
				completion = { callSnippet = "Replace" },
			},
		},
	},
}

for name, config in pairs(servers) do
	require("lspconfig")[name].setup(lsp.caps.with_caps(config))
end
