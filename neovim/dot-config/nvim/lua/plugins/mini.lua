return {
	{
		"echasnovski/mini.nvim",
		version = false,
		config = function()
			require("mini.trailspace").setup()
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
		end,
	},
}
