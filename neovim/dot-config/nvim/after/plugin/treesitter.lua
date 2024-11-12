local ignore_fts = { "netrw", "fzf" }

local logger = require("vlog").new({ plugin = "plugin.treesitter", level = vim.log.levels.OFF })

local function treesitter_start(ev)
	local ft = ev.match
	local ok, err = pcall(vim.treesitter.start)
	if not ok and not vim.list_contains(ignore_fts, ft) then
		logger:error("treesitter failed to start", { filetype = ft, error = err })
	end
end

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
	callback = treesitter_start,
})
