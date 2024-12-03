vim.loader.enable()

local utils = require("core.utils")

vim.opt.background = "light"

do -- globals
	vim.g.loaded_node_provider = 0
	vim.g.loaded_perl_provider = 0
	vim.g.loaded_python_provider = 0
	vim.g.loaded_python3_provider = 0
	vim.g.loaded_ruby_provider = 0
	vim.g.mapleader = vim.api.nvim_replace_termcodes("<space>", false, false, true)
	vim.g.maplocalleader = vim.api.nvim_replace_termcodes("<bs>", false, false, true)
end

do -- options
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
	vim.opt.timeoutlen = 300
	vim.opt.termguicolors = true
	vim.opt.cursorline = true
	vim.opt.list = true
	vim.opt.listchars = { tab = "»·", trail = "·", nbsp = "␣" }
	vim.opt.grepprg = "rg --vimgrep --smart-case --hidden"
	vim.opt.grepformat = "%f:%l:%c:%m"
	vim.opt.inccommand = "split"
	vim.opt.scrolloff = 10
	vim.opt.completeopt = { "menu", "menuone", "noselect", "popup", "fuzzy" }
	vim.opt.wildmode = { "longest:full", "full" }
	vim.opt.wildoptions:append("fuzzy")
	vim.opt.spelllang = "en_us"
	vim.opt.spell = true
	vim.opt.exrc = true
	vim.opt.mouse = ""
	vim.opt.hidden = true
	vim.opt.bufhidden = "hide"

	vim.opt.foldmethod = "expr"
	vim.opt.foldexpr = "v:lua.vim.lsp.foldexpr()"
	vim.opt.foldtext = "v:lua.vim.lsp.foldtext()"
	vim.opt.foldcolumn = "auto"
end

do -- diagnostics
	vim.keymap.set("n", "<leader>cd", vim.diagnostic.setqflist, { desc = "add diagnostics to qf" })
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
end

do -- misc. keymaps
	vim.keymap.set("t", "<C-o>", "<C-\\><C-n>", { desc = "exit terminal mode" })
	vim.keymap.set("n", "<leader>fg", ":<c-u>silent grep! ", { desc = "grep" })
	vim.keymap.set("n", "J", "mzJ`z", { desc = "join lines without moving cursor" })
	vim.keymap.set("n", "n", "nzzzv", { desc = "find next, center, open folds" })
	vim.keymap.set("n", "N", "Nzzzv", { desc = "find previous, center, open folds" })
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

	vim.keymap.set("n", "<c-l>", function()
		vim.cmd.nohlsearch()
		vim.cmd.diffupdate()
		vim.cmd("normal! <c-l>")
		vim.diagnostic.reset()
		vim.cmd.LspRestart()
	end, { desc = "reset everything" })

	vim.keymap.set("c", "<space>", function()
		local mode = vim.fn.getcmdtype() or ""
		local is_search = mode == "?" or mode == "/"
		return is_search and ".*" or " "
	end, { expr = true })
end

do -- yank
	vim.keymap.set("x", "<leader>yp", [["_dP]], { desc = "paste without replacing register contents" })
	vim.keymap.set({ "n", "x" }, "<leader>y<space>", [["+p]], { desc = "paste from + register" })
	vim.keymap.set({ "n", "x" }, "<leader>yy", [["+y]], { desc = "yank to + register" })
	vim.keymap.set({ "n", "x" }, "<leader>yY", [["+Y]], { desc = "YANK to + register" })
	vim.keymap.set({ "n", "x" }, "<leader>yd", [["_d]], { desc = "delete without replacing register contents " })

	vim.api.nvim_create_autocmd({ "TextYankPost" }, {
		group = vim.api.nvim_create_augroup("UserHighlightYank", { clear = true }),
		desc = "Highlight yanked region",
		callback = function()
			local hl = vim.hl or vim.highlight
			hl.on_yank({ higroup = "Search", timeout = 300 })
		end,
	})
end

do -- quickfix
	vim.cmd.packadd("cfilter")

	local augroup = vim.api.nvim_create_augroup("UserQuickfix", { clear = true })
	vim.api.nvim_create_autocmd("QuickFixCmdPost", {
		group = augroup,
		desc = "Automatically open quickfix window",
		pattern = { "[^l]*" },
		command = "botright cwindow",
	})
	vim.api.nvim_create_autocmd("QuickFixCmdPost", {
		group = augroup,
		desc = "Automatically open loclist window",
		pattern = { "l*" },
		command = "lwindow",
	})

	vim.keymap.set("n", "[c", function()
		local ok, err = pcall(vim.cmd.cprev)
		if not ok and utils.is_err(err, "E553") then
			vim.cmd.clast()
		end
	end, { desc = "previous quickfix entry" })

	vim.keymap.set("n", "]c", function()
		local ok, err = pcall(vim.cmd.cnext)
		if not ok and utils.is_err(err, "E553") then
			vim.cmd.cfirst()
		end
	end, { desc = "next quickfix entry" })
end

do -- vim-cool
	vim.api.nvim_create_autocmd("CursorMoved", {
		group = vim.api.nvim_create_augroup("UserVimCool", { clear = true }),
		callback = function()
			if vim.v.hlsearch == 1 and vim.fn.searchcount().exact_match == 0 then
				vim.schedule(vim.cmd.nohlsearch)
			end
		end,
	})
end

require("amake").setup()

require("config.lazy")

vim.o.completefunc = "v:lua.require'core.snippets'.completefunc"

do --- beancount
	vim.filetype.add({
		extension = { beancount = "beancount", bean = "beancount" },
	})
end
