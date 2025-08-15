--[[
	Marks / Bookmarks / Harpoon Replacement
	Based on:
	https://github.com/olimorris/dotfiles/blob/main/.config/nvim/lua/util/marks.lua
--]]

---@param mark string
---@return string
local function mark2char(mark)
	if mark:match("[1-9]") then
		return string.char(mark + 64)
	end
	return mark
end

vim.keymap.set("n", "m", function()
	local mark = vim.fn.getcharstr()
	local char = mark2char(mark)
	vim.cmd.mark({ char })
	if mark:match("[1-9]") then
		vim.notify("Added mark " .. mark, vim.log.levels.INFO, { title = "Marks" })
	else
		vim.fn.feedkeys("m" .. mark, "n")
	end
end, { desc = "Add mark" })

vim.keymap.set("n", "'", function()
	local mark = vim.fn.getcharstr()
	local char = mark2char(mark)

	local mark_pos ---@type number
	if char:match("[A-Z]") then
		mark_pos = vim.api.nvim_get_mark(char, {})[1]
	else
		mark_pos = vim.api.nvim_buf_get_mark(0, char)[1]
	end
	if mark_pos == 0 then
		return vim.notify("No mark at " .. mark, vim.log.levels.WARN, { title = "Marks" })
	end
	vim.fn.feedkeys("'" .. char, "n")
end, { desc = "Go to mark" })

vim.keymap.set("n", "<leader>mm", function()
	require("fzf-lua").marks({ marks = "[A-I]" })
end, { desc = "List marks" })

vim.keymap.set("n", "<leader>md", function()
	local mark = vim.fn.getcharstr()
	local char = mark2char(mark)
	if char:match("[A-Z]") then
		vim.api.nvim_del_mark(char)
	else
		vim.api.nvim_buf_del_mark(0, char)
	end
	vim.notify("Deleted mark " .. char, vim.log.levels.INFO, { title = "Marks" })
end, { desc = "Delete mark" })

vim.keymap.set("n", "<leader>mD", function()
	vim.cmd.delmarks({ "A-I" })
	vim.notify("Deleted all marks", vim.log.levels.INFO, { title = "Marks" })
end, { desc = "Delete all marks" })
