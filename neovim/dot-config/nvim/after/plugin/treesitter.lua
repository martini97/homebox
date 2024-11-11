local function treesitter_start(ev)
	local ft = ev.match
	local ok, err = pcall(vim.treesitter.start)
	if not ok then
		local msg = ("treesitter: failed to start for filetype='%s', err: %s"):format(ft, err)
		vim.notify(msg, vim.log.levels.ERROR)
	end
end

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
	callback = treesitter_start,
})
