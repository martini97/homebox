if vim.g.disable_netrw == true then
	return
end

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
vim.g.netrw_liststyle = 3
vim.g.netrw_sizestyle = "H"
vim.g.netrw_localcopydircmd = "cp -r"

vim.keymap.set("n", "-", vim.cmd.Explore, { desc = "[netrw] explore" })
