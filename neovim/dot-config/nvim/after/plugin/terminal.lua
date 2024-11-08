---@type integer
vim.t.terminal_window = vim.t.terminal_window or -1
---@type integer
vim.t.terminal_buffer = vim.t.terminal_buffer or -1
---@type integer
vim.t.terminal_height = vim.t.terminal_height or 12
---@type "aboveleft" | "belowright" | "topleft" | "botright"
vim.t.terminal_split = vim.t.terminal_split or "botright"

---@return integer
local function __terminal_window_setup()
	local win = vim.t.terminal_window or -1
	local height = vim.t.terminal_height or 12
	local split = vim.t.terminal_split or "botright"

	if vim.api.nvim_win_is_valid(win) and vim.fn.win_gotoid(win) == 1 then
		return win
	end

	vim.cmd.split({ range = { height }, mods = { split = split } })
	return vim.api.nvim_get_current_win()
end

---@return integer
local function __terminal_buffer_setup()
	local win = vim.t.terminal_window or -1
	local buf = vim.t.terminal_buffer or -1

	local winsetbuf = function()
		local ok, _ = pcall(vim.api.nvim_win_set_buf, win, buf)
		return ok
	end

	if vim.api.nvim_buf_is_loaded(buf) and winsetbuf() then
		return buf
	end

	vim.cmd.terminal()
	return vim.api.nvim_get_current_buf()
end

local function terminal_toggle()
	if vim.bo.filetype == "terminal" then
		vim.cmd.hide()
		return
	end
	vim.t.terminal_height = vim.t.terminal_height or 12
	vim.t.terminal_split = vim.t.terminal_split or "botright"
	vim.t.terminal_window = __terminal_window_setup()
	vim.t.terminal_buffer = __terminal_buffer_setup()
	vim.wo[vim.t.terminal_window].winfixheight = true
	vim.api.nvim_win_set_height(vim.t.terminal_window, vim.t.terminal_height)
end

local function terminal_floating()
	require("lazy.util").float_term(nil, {
		border = "solid",
		title = "Terminal",
		title_pos = "center",
		style = "minimal",
		persistent = true,
	})
end

vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("UserTermOpen", { clear = true }),
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
		vim.opt_local.scrolloff = 0
		vim.opt_local.filetype = "terminal"
	end,
})

vim.keymap.set("n", "<localleader><bs>", terminal_toggle, { desc = "[terminal] toggle terminal" })
vim.keymap.set("n", "<localleader><cr>", terminal_floating, { desc = "[terminal] floating terminal" })
