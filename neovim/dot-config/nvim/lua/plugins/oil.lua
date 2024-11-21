return {
	{
		"stevearc/oil.nvim",
		dependencies = { { "echasnovski/mini.icons", opts = {} } },
		config = function()
			require("config.oil")
		end,
	},
}
