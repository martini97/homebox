require("gitlinker").setup()

vim.env.GIT_EDITOR = "nvr -cc split --remote-wait"

vim.api.nvim_create_autocmd({ "FileType" }, {
	group = vim.api.nvim_create_augroup("UserFtGit", { clear = true }),
	pattern = { "gitcommit", "gitrebase", "gitconfig" },
	callback = function()
		vim.opt_local.bufhidden = "delete"
	end,
})

vim.keymap.set("n", "<leader>gg", function()
	require("neogit").open({ kind = "floating" })
end, { desc = "[neogit] open" })

vim.keymap.set("n", "<leader>gl", function()
	local cwd = vim.uv.cwd()
	local dirname = vim.fs.basename(cwd)
	require("lazy.util").float_term({ "lazygit", "log" }, {
		cwd = cwd,
		border = "solid",
		title = string.format("Git Log [%s]", dirname),
		title_pos = "center",
		style = "minimal",
	})
end, { desc = "[git] lazygit log" })

vim.keymap.set({ "n", "v" }, "<leader>gy", vim.cmd.GitLink, { desc = "[git] yank link" })
