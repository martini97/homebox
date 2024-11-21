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

vim.api.nvim_create_user_command("Bdelete", function()
	require("mini.bufremove").delete(vim.api.nvim_get_current_buf())
end, {})

vim.api.nvim_create_user_command("Bwipeout", function()
	require("mini.bufremove").wipeout(vim.api.nvim_get_current_buf())
end, {})
