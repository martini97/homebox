return {
	{
		"ibhagwan/fzf-lua",
		dependencies = { { "echasnovski/mini.icons", opts = {} } },
		config = function()
			require("fzf-lua").setup({})
			require("fzf-lua").register_ui_select()
			vim.keymap.set("n", "<leader>ff", ":<c-u>FzfLua files<cr>", { desc = "[fzf-lua] files" })
			vim.keymap.set("n", "<leader>fh", ":<c-u>FzfLua helptags<cr>", { desc = "[fzf-lua] helptags" })
			vim.keymap.set("n", "<leader>fb", ":<c-u>FzfLua buffers<cr>", { desc = "[fzf-lua] buffers" })
		end,
	},
}
