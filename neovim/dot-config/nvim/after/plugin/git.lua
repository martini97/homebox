vim.env.GIT_EDITOR = "nvr -cc split --remote-wait"

vim.api.nvim_create_autocmd({ "FileType" }, {
	group = vim.api.nvim_create_augroup("UserFtGit", { clear = true }),
	pattern = { "gitcommit", "gitrebase", "gitconfig" },
	callback = function()
		vim.opt_local.bufhidden = "delete"
	end,
})

local function lazygit_log()
	local cwd = vim.uv.cwd()
	local dirname = vim.fs.basename(cwd)
	require("lazy.util").float_term({ "lazygit", "log" }, {
		cwd = cwd,
		border = "solid",
		title = string.format("Git Log [%s]", dirname),
		title_pos = "center",
		style = "minimal",
	})
end

vim.keymap.set("n", "<leader>gl", lazygit_log, { desc = "[git] lazygit log" })
