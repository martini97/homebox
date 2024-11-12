vim.loader.enable()

local utils = require("core.utils")

vim.opt.background = "light"

vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.mapleader = vim.api.nvim_replace_termcodes("<space>", false, false, true)
vim.g.maplocalleader = vim.api.nvim_replace_termcodes("<bs>", false, false, true)

vim.opt.showmode = false
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.signcolumn = "yes"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.showtabline = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.shiftwidth = 2
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.updatetime = 50
vim.opt.timeoutlen = 500
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.list = true
vim.opt.listchars = { tab = "»·", trail = "·", nbsp = "␣" }
vim.opt.grepprg = "rg --vimgrep --smart-case --hidden"
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.inccommand = "split"
vim.opt.scrolloff = 10
vim.opt.completeopt = { "menu", "menuone", "noselect", "popup" }
vim.opt.wildmode = { "longest:full", "full" }
vim.opt.wildoptions:append("fuzzy")
vim.opt.spelllang = "en_us"
vim.opt.spell = true
vim.opt.exrc = true

-- TODO(2024-11-11): improve this (perf. issues)
vim.opt.path:append("**")
vim.opt.wildignore:append("**/node_modules/**")

vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "open diagnostic floating window" })
vim.keymap.set(
	"n",
	"[d",
	utils.bind(vim.diagnostic.jump, { count = -1, wrap = true, float = true }),
	{ desc = "previous diagnostic" }
)
vim.keymap.set(
	"n",
	"]d",
	utils.bind(vim.diagnostic.jump, { count = 1, wrap = true, float = true }),
	{ desc = "next diagnostic" }
)
vim.keymap.set("n", "<leader>cd", vim.diagnostic.setqflist, { desc = "add diagnostics to qf" })
vim.keymap.set("t", "<C-o>", "<C-\\><C-n>", { desc = "exit terminal mode" })
vim.keymap.set("n", "<leader>fg", ":<c-u>silent grep! ", { desc = "grep" })
vim.keymap.set("n", "<leader>ff", ":<c-u>silent find! ", { desc = "find" })
vim.keymap.set("n", "<leader>fs", ":<c-u>silent sfind! ", { desc = "split find" })
vim.keymap.set("n", "<leader>fv", ":<c-u>silent vertical sfind! ", { desc = "vertical split find" })
vim.keymap.set("n", "<leader>ft", ":<c-u>silent tabfind! ", { desc = "tab find" })
vim.keymap.set("n", "<leader>fh", ":<c-u>help ", { desc = "help" })
vim.keymap.set("n", "J", "mzJ`z", { desc = "join lines without moving cursor" })
vim.keymap.set("n", "n", "nzzzv", { desc = "find next, center, open folds" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "find previous, center, open folds" })
vim.keymap.set("x", "<leader>yp", [["_dP]], { desc = "paste without replacing register contents" })
vim.keymap.set({ "n", "x" }, "<leader>y<space>", [["+p]], { desc = "paste from + register" })
vim.keymap.set({ "n", "x" }, "<leader>yy", [["+y]], { desc = "yank to + register" })
vim.keymap.set({ "n", "x" }, "<leader>yY", [["+Y]], { desc = "YANK to + register" })
vim.keymap.set({ "n", "x" }, "<leader>yd", [["_d]], { desc = "delete without replacing register contents " })
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("c", "<c-r><c-d>", function()
	local buf = vim.api.nvim_get_current_buf()
	local fname = vim.api.nvim_buf_get_name(buf)
	return vim.fs.dirname(fname) .. "/"
end, { expr = true, desc = "insert current file dir" })

vim.keymap.set("n", "<leader>ee", ":<c-u>edit ")
vim.keymap.set("n", "<leader>ev", ":<c-u>vsplit ")
vim.keymap.set("n", "<leader>ex", ":<c-u>split ")
vim.keymap.set("n", "<leader>et", ":<c-u>tabedit ")
vim.keymap.set("n", "<leader>er", ":<c-u>read ")

vim.keymap.set({ "i", "c" }, "<c-h>", "<bs>", { desc = "[emacs] backspace" })
vim.keymap.set({ "i", "c" }, "<c-d>", "<del>", { desc = "[emacs] delete" })
vim.keymap.set("c", "<c-a>", "<home>", { desc = "[emacs] home" })
vim.keymap.set("c", "<c-e>", "<end>", { desc = "[emacs] end" })
vim.keymap.set("c", "<c-p>", "<up>", { desc = "[emacs] up" })
vim.keymap.set("c", "<c-n>", "<down>", { desc = "[emacs] down" })
vim.keymap.set("c", "<c-b>", "<left>", { desc = "[emacs] left" })
vim.keymap.set("c", "<c-f>", "<right>", { desc = "[emacs] right" })
vim.keymap.set("c", "<c-k>", "<C-f>D<C-c><C-c>:<Up>", { desc = "[emacs] kill to the end of line" })
vim.keymap.set("c", "<m-b>", "<c-left>", { desc = "[emacs] wordwise left" })
vim.keymap.set("c", "<m-f>", "<c-right>", { desc = "[emacs] wordwise right" })

vim.keymap.set("x", "id", function()
	vim.w.saved_view = vim.fn.winsaveview()
	vim.cmd.normal({ "G$Vgg0", bang = true })
end, { desc = "inner document" })

vim.keymap.set("o", "id", function()
	vim.w.saved_view = vim.fn.winsaveview()
	vim.cmd.normal({ "GVgg", bang = true })
end, { desc = "inner document" })

vim.keymap.set("n", "<c-l>", function()
	vim.cmd.nohlsearch()
	vim.cmd.diffupdate()
	vim.cmd("normal! <c-l>")
	vim.diagnostic.reset()
	vim.cmd.LspRestart()
end, { desc = "reset everything" })

vim.cmd.packadd("cfilter")

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
	group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank({ higroup = "Visual", timeout = 300 })
	end,
})

local qfg = vim.api.nvim_create_augroup("quickfix_config", { clear = true })
vim.api.nvim_create_autocmd("QuickFixCmdPost", { group = qfg, pattern = { "[^l]*" }, command = "cwindow" })
vim.api.nvim_create_autocmd("QuickFixCmdPost", { group = qfg, pattern = { "l*" }, command = "lwindow" })

-- vim-cool
vim.api.nvim_create_autocmd("CursorMoved", {
	group = vim.api.nvim_create_augroup("vim_cool", { clear = true }),
	callback = function()
		if vim.v.hlsearch == 1 and vim.fn.searchcount().exact_match == 0 then
			vim.schedule(vim.cmd.nohlsearch)
		end
	end,
})

vim.keymap.set("c", "<space>", function()
	local mode = vim.fn.getcmdtype()
	local line = vim.fn.getcmdline()
	local cmd = vim.api.nvim_parse_cmd(line, {})
	local is_search = mode == "?" or mode == "/"
	local is_find = cmd.cmd == "find" or cmd.cmd == "sfind"

	if is_search then
		return ".*"
	elseif is_find then
		return "*"
	else
		return " "
	end
end, { expr = true })
