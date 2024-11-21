return {
	{
		"mfussenegger/nvim-lint",
		event = { "BufEnter", "BufWritePost", "InsertLeave", "TextChanged" },
		config = function()
			require("config.lint")
		end,
	},
}
