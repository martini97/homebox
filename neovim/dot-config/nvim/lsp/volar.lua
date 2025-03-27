---@param names string|string[]
---@param opts vim.fs.find.Opts
---@return string?
local function fs_find(names, opts)
	return vim.tbl_get(vim.fs.find(names, opts), 1)
end

local root_dir = fs_find({ "vue.config.js", "package.json", ".git" }, { upward = true })
local tsdk = fs_find("node_modules/typescript/lib", { path = root_dir, upward = true })

if not tsdk then
	tsdk = vim.fs.joinpath(vim.uv.os_homedir(), ".local", "lib", "node_modules", "typescript", "lib")
end

---@type vim.lsp.Config
return {
	cmd = { "vue-language-server", "--stdio" },
	filetypes = { "vue" },
	root_dir = root_dir,
	init_options = { typescript = { tsdk = tsdk } },
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME } },
			completion = { callSnippet = "Replace" },
		},
	},
}
