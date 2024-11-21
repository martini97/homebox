return {
	{
		"ibhagwan/fzf-lua",
		dependencies = { { "echasnovski/mini.icons", opts = {} } },
		config = function()
			require("config.fzf")
		end,
	},
}
