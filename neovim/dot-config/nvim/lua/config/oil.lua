local oil = require("oil")

local function cycle_columns()
	local columns = require("oil.config").columns

	if #columns == 1 and columns[1] == "icon" then
		oil.set_columns({ "icon", "permissions", "size", "mtime" })
	else
		oil.set_columns({ "icon" })
	end
end

oil.setup({
	default_file_explorer = true,
	columns = { "icon" },
	buf_options = { buflisted = false, bufhidden = "hide" },
	keymaps = {
		gq = "actions.close",
		["gd"] = cycle_columns,
	},
})

vim.keymap.set("n", "-", require("oil").open, { desc = "[oil] open" })
