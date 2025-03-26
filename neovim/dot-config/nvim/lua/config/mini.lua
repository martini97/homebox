require("mini.trailspace").setup()

require("mini.bufremove").setup()

require("mini.ai").setup({
	custom_textobjects = {
		d = function()
			return {
				from = { line = 1, col = 1 },
				to = { line = vim.fn.line("$"), col = math.max(vim.fn.getline("$"):len(), 1) },
			}
		end,
	},
})

require("mini.surround").setup({
	mappings = {
		add = "sa",
		delete = "sd",
		find = "sf",
		find_left = "sF",
		highlight = "sh",
		replace = "sr",
		update_n_lines = "sn",
		suffix_last = "l",
		suffix_next = "n",
	},
})

require("mini.indentscope").setup({
	draw = { animation = require("mini.indentscope").gen_animation.none() },
	options = { indent_at_cursor = false, try_as_border = true },
})

require("mini.misc").setup({})
-- this is causing issues with tmux+kitty
-- require("mini.misc").setup_termbg_sync()
require("mini.misc").setup_restore_cursor()

vim.api.nvim_create_user_command("Bdelete", function()
	require("mini.bufremove").delete(vim.api.nvim_get_current_buf())
end, {})

vim.api.nvim_create_user_command("Bwipeout", function()
	require("mini.bufremove").wipeout(vim.api.nvim_get_current_buf())
end, {})

vim.keymap.set("n", "<leader>wo", function()
	require("mini.misc").zoom(0, { title = { { " <ZOOM> ", "Error" } }, title_pos = "center", border = "double" })
end, { desc = "[window] zoom" })
vim.keymap.set("n", "<leader>wh", "<c-w>h", { desc = "[window] left" })
vim.keymap.set("n", "<leader>wj", "<c-w>j", { desc = "[window] down" })
vim.keymap.set("n", "<leader>wk", "<c-w>k", { desc = "[window] up" })
vim.keymap.set("n", "<leader>wl", "<c-w>l", { desc = "[window] right" })
vim.keymap.set("n", "<leader>wx", "<c-w>c", { desc = "[window] close" })
vim.keymap.set("n", "<leader>wv", "<c-w>v", { desc = "[window] vertical split" })
vim.keymap.set("n", "<leader>ws", "<c-w>s", { desc = "[window] horizontal split" })
