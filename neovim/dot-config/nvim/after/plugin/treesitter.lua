local ignore_fts = { "netrw", "fzf" }

local function treesitter_start(ev)
	local ft = ev.match
	local ok, err = pcall(vim.treesitter.start)
	if not ok and not vim.list_contains(ignore_fts, ft) then
		local msg = ("treesitter: failed to start for filetype='%s', err: %s"):format(ft, err)
		vim.notify_once(msg, vim.log.levels.ERROR)
	end
end

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
	callback = treesitter_start,
})
