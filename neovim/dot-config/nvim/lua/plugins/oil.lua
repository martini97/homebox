return {
	{
		"stevearc/oil.nvim",
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {},
		dependencies = { { "echasnovski/mini.icons", opts = {} } },
		keys = {
			{ "-", "<cmd>Oil<cr>", mode = "n", desc = "[oil] open oil buffer" },
		},
	},
}
