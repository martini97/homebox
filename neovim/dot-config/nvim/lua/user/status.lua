local M = {}

vim.api.nvim_set_hl(0, "UserStatusAccent", { fg = "NvimDarkGrey3", bg = "#9D00FF", bold = true })
vim.api.nvim_set_hl(0, "UserStatusInsertAccent", { fg = "NvimDarkGrey3", bg = "#FFCB61", bold = true })
vim.api.nvim_set_hl(0, "UserStatusVisualAccent", { fg = "NvimDarkGrey3", bg = "#8ABB6C", bold = true })
vim.api.nvim_set_hl(0, "UserStatusReplaceAccent", { fg = "NvimDarkGrey3", bg = "#E6521F", bold = true })
vim.api.nvim_set_hl(0, "UserStatusCmdLineAccent", { fg = "NvimDarkGrey3", bg = "#FFD8D8", bold = true })
vim.api.nvim_set_hl(0, "UserStatusTermAccent", { fg = "NvimDarkGrey3", bg = "#77BEF0", bold = true })
vim.api.nvim_set_hl(0, "UserStatusError", { fg = "NvimDarkRed", bg = "#DDDDDD", bold = true })
vim.api.nvim_set_hl(0, "UserStatusWarn", { fg = "NvimDarkYellow", bg = "#DDDDDD", bold = true })
vim.api.nvim_set_hl(0, "UserStatusHint", { fg = "NvimDarkBlue", bg = "#DDDDDD", bold = true })
vim.api.nvim_set_hl(0, "UserStatusInfo", { fg = "NvimDarkCyan", bg = "#DDDDDD", bold = true })

local modes = {
	["n"] = "NORMAL",
	["nt"] = "NORMAL",
	["no"] = "NORMAL",
	["v"] = "VISUAL",
	["V"] = "VISUAL LINE",
	[""] = "VISUAL BLOCK",
	["s"] = "SELECT",
	["S"] = "SELECT LINE",
	[""] = "SELECT BLOCK",
	["i"] = "INSERT",
	["ic"] = "INSERT",
	["R"] = "REPLACE",
	["Rv"] = "VISUAL REPLACE",
	["c"] = "COMMAND",
	["cv"] = "VIM EX",
	["ce"] = "EX",
	["r"] = "PROMPT",
	["rm"] = "MOAR",
	["r?"] = "CONFIRM",
	["!"] = "SHELL",
	["t"] = "TERMINAL",
}

local function with_highlight(text, hl)
	return ("%%#%s#"):format(hl) .. text .. "%#Normal#"
end

local function mode()
	local current_mode = vim.api.nvim_get_mode().mode
	return string.format(" %s ", modes[current_mode]):upper()
end

local function update_mode_colors()
	local current_mode = vim.api.nvim_get_mode().mode
	local mode_color = "%#UserStatusAccent#"
	if current_mode == "n" then
		mode_color = "%#UserStatusAccent#"
	elseif current_mode == "i" or current_mode == "ic" then
		mode_color = "%#UserStatusInsertAccent#"
	elseif current_mode == "v" or current_mode == "V" or current_mode == "" then
		mode_color = "%#UserStatusVisualAccent#"
	elseif current_mode == "R" then
		mode_color = "%#UserStatusReplaceAccent#"
	elseif current_mode == "c" then
		mode_color = "%#UserStatusCmdLineAccent#"
	elseif current_mode == "t" then
		mode_color = "%#UserStatusTermAccent#"
	end
	return mode_color
end

local function filepath()
	local fpath = vim.fn.fnamemodify(vim.fn.expand "%", ":~:.:h")
	if fpath == "" or fpath == "." then
		return " "
	end

	return string.format(" %%<%s/", fpath)
end

local function filename()
	local fname = vim.fn.expand "%:t"
	if fname == "" then
		return ""
	end
	return fname .. " "
end

local function filetype()
	return string.format(" %s ", vim.bo.filetype):upper()
end

local function lsp()
	local count = {}
	local levels = {
		errors = vim.diagnostic.severity.ERROR,
		warnings = vim.diagnostic.severity.WARN,
		info = vim.diagnostic.severity.INFO,
		hints = vim.diagnostic.severity.HINT,
	}

	for k, level in pairs(levels) do
		count[k] = vim.tbl_count(vim.diagnostic.get(0, { severity = level }))
	end

	local parts = {}


	if count["errors"] ~= 0 then
		table.insert(parts, with_highlight("E" .. count["errors"], "UserStatusError"))
	end
	if count["warnings"] ~= 0 then
		table.insert(parts, with_highlight("W" .. count["warnings"], "UserStatusWarn"))
	end
	if count["hints"] ~= 0 then
		table.insert(parts, with_highlight("H" .. count["hints"], "UserStatusHint"))
	end
	if count["info"] ~= 0 then
		table.insert(parts, with_highlight("I" .. count["info"], "UserStatusInfo"))
	end

	return table.concat(parts, " ") .. "%#Normal#"
end

local function lineinfo()
	if vim.bo.filetype == "alpha" then
		return ""
	end
	return " %P %l:%c "
end

M.active = function()
	return table.concat({
		"%#Statusline#",
		update_mode_colors(),
		mode(),
		"%#Normal# ",
		filepath(),
		filename(),
		"%#Normal#",
		lsp(),
		"%=%#StatusLineExtra#",
		filetype(),
		lineinfo(),
	})
end

M.inactive = function()
	return " %F"
end

return M
