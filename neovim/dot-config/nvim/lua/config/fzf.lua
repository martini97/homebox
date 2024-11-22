require("fzf-lua").setup({})
require("fzf-lua").register_ui_select()

local utils = require("core.utils")

local keymaps = {
	h = "helptags",
	b = "buffers",
	k = "keymaps",
	r = "resume",
	o = "lsp_document_symbols",
	O = "lsp_workspace_symbols",
	["<space>"] = "builtin",
	["."] = "oldfiles",
}

for key, action in pairs(keymaps) do
	local lhs = string.format("<leader>f%s", key)
	local rhs = string.format(":<c-u>FzfLua %s<cr>", action)
	local desc = string.format("[fzf-lua] %s", action)
	vim.keymap.set("n", lhs, rhs, { desc = desc })
end

vim.keymap.set(
	"n",
	"<leader>fn",
	string.format(":<c-u>FzfLua files cwd=%s<cr>", vim.fn.stdpath("config")),
	{ desc = "[fzf-lua] neovim config" }
)

vim.keymap.set("n", "<leader>ff", function()
	local count = vim.v.count or 0
	local scope = count == 0 and "tab" or count == 1 and "global" or "buffer"
	local cwd = utils.get_cwd({ scope = scope })
	require("fzf-lua").files({ cwd = cwd, cmd = "fd --hidden" })
end, { desc = "[fzf-lua] find files (global cwd)" })

vim.keymap.set("n", "<leader>/", ":<c-u>FzfLua blines<cr>", { desc = "[fzf-lua] blines" })
