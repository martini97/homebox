vim.loader.enable()

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
vim.opt.timeoutlen = 300
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.list = true
vim.opt.listchars = { tab = "»·", trail = "·", nbsp = "␣" }
vim.opt.grepprg = "rg --vimgrep --smart-case --hidden"
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.inccommand = "split"
vim.opt.scrolloff = 10
vim.opt.wildmode = { "longest:full", "full" }
vim.opt.wildoptions:append("fuzzy")
vim.opt.spelllang = "en_us"
vim.opt.spell = true
vim.opt.exrc = true
vim.opt.mouse = ""
vim.opt.hidden = true
vim.opt.bufhidden = "hide"
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.lsp.foldexpr()"
vim.opt.foldtext = ""
vim.opt.foldcolumn = "auto"

vim.opt.winborder = "double"

vim.opt.complete = { ".", "t", "o" }
vim.opt.completeopt = { "menuone", "noselect", "popup", "fuzzy" }
vim.opt.autocomplete = false
vim.opt.pumheight = 10

vim.diagnostic.config({ virtual_text = { current_line = true } })

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

vim.keymap.set("c", "<space>", function()
	local mode = vim.fn.getcmdtype() or ""
	local is_search = mode == "?" or mode == "/"
	return is_search and ".*" or " "
end, { expr = true })

vim.keymap.set("n", "<leader>wt", "<cmd>tab split<cr>", { desc = "[window] split to tab" })

local yank_group = vim.api.nvim_create_augroup("UserHighlightYank", { clear = true })
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
	group = yank_group,
	desc = "Highlight yanked region",
	callback = function()
		local hl = vim.hl or vim.highlight
		hl.on_yank({ higroup = "Search", timeout = 300 })
	end,
})

local quickfix_group = vim.api.nvim_create_augroup("UserQuickfix", { clear = true })
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
	group = quickfix_group,
	desc = "Automatically open quickfix window",
	pattern = { "[^l]*" },
	command = "botright cwindow",
})
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
	group = quickfix_group,
	desc = "Automatically open loclist window",
	pattern = { "l*" },
	command = "lwindow",
})

local cool_group = vim.api.nvim_create_augroup("UserVimCool", { clear = true })
vim.api.nvim_create_autocmd("CursorMoved", {
	group = cool_group,
	callback = function()
		if vim.v.hlsearch == 1 and vim.fn.searchcount().exact_match == 0 then
			vim.schedule(vim.cmd.nohlsearch)
		end
	end,
})

vim.filetype.add({ extension = { beancount = "beancount", bean = "beancount" } })

do -- lsp
	vim.pack.add({
		"https://github.com/mason-org/mason.nvim",
		"https://github.com/neovim/nvim-lspconfig"
	})

	require("mason").setup()
	local m_registry = require 'mason-registry'

	local function ensure_installed(name)
		local pkg = m_registry.get_package(name)
		if pkg:is_installed() or pkg:is_installing() then
			return
		end
		pkg:install()
	end

	ensure_installed('typescript-language-server')
	ensure_installed('eslint-lsp')
	ensure_installed('lua-language-server')
	ensure_installed('json-lsp')

	vim.lsp.enable({ 'lua_ls', 'jsonls', 'ts_ls', 'eslint' })

	local lsp_group = vim.api.nvim_create_augroup("UserLsp", { clear = true })
	vim.api.nvim_create_autocmd("LspAttach", {
		group = lsp_group,
		callback = function(args)
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			if not client then
				vim.notify('invalid client', vim.log.levels.WARN)
				return
			end

			vim.bo[args.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

			if client:supports_method('textDocument/formatting', args.buf) then
				vim.api.nvim_create_autocmd('BufWritePre', {
					group = lsp_group,
					buffer = args.buf,
					callback = function()
						vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
					end
				})
			end

			if client:supports_method('textDocument/completion', args.buf) then
				vim.lsp.completion.enable(true, client.id, args.buf, {
					autotrigger = true,
					convert = function(item)
						return { abbr = item.label:gsub("%b()", "") }
					end,
				})
			end
		end
	})
end

do -- fzf
	vim.pack.add({
		"https://github.com/echasnovski/mini.icons",
		"https://github.com/ibhagwan/fzf-lua",
	})

	local fzf = require("fzf-lua")

	fzf.setup({
		actions = {
			files = {
				["ctrl-v"] = fzf.actions.file_vsplit,
				["ctrl-t"] = fzf.actions.file_tabedit,
				["alt-q"] = fzf.actions.file_sel_to_qf,
				["alt-Q"] = fzf.actions.file_sel_to_ll,
				["alt-i"] = fzf.actions.toggle_ignore,
				["alt-h"] = fzf.actions.toggle_hidden,
				["alt-f"] = fzf.actions.toggle_follow,
				["enter"] = fzf.actions.file_edit_or_qf,
			}
		}
	})
	fzf.register_ui_select()
	require("mini.icons").setup({})

	local keymaps = {
		f = "files",
		h = "helptags",
		b = "buffers",
		k = "keymaps",
		r = "resume",
		o = "lsp_document_symbols",
		O = "lsp_workspace_symbols",
		["<space>"] = "builtin",
		["."] = "oldfiles",
	}

	for key, action in pairs(keymaps) do
		local lhs = string.format("<leader>f%s", key)
		local rhs = string.format(":<c-u>FzfLua %s<cr>", action)
		local desc = string.format("[fzf-lua] %s", action)
		vim.keymap.set("n", lhs, rhs, { desc = desc })
	end

	vim.keymap.set("n", "<leader>/", ":<c-u>FzfLua blines<cr>", { desc = "[fzf-lua] blines" })
end

do -- oil
	vim.pack.add({
		"https://github.com/echasnovski/mini.icons",
		"https://github.com/stevearc/oil.nvim",
	})

	require("mini.icons").setup({})

	local oil = require("oil")

	local function cycle_columns()
		local columns = require("oil.config").columns

		if #columns == 1 and columns[1] == "icon" then
			oil.set_columns({ "icon", "permissions", "size", "mtime" })
		else
			oil.set_columns({ "icon" })
		end
	end

	oil.setup({
		default_file_explorer = true,
		columns = { "icon" },
		buf_options = { buflisted = false, bufhidden = "hide" },
		keymaps = {
			gq = "actions.close",
			["gd"] = cycle_columns,
		},
	})

	vim.keymap.set("n", "-", require("oil").open, { desc = "[oil] open" })
end

do -- git
	vim.pack.add({
		{ src = "https://github.com/nvim-lua/plenary.nvim", version = "master" },
		"https://github.com/sindrets/diffview.nvim",
		"https://github.com/ibhagwan/fzf-lua",
		"https://github.com/linrongbin16/gitlinker.nvim",
		"https://github.com/NeogitOrg/neogit",
		"https://github.com/tpope/vim-fugitive"
	})

	require("gitlinker").setup()

	vim.keymap.set({ "n", "v" }, "<leader>gy", vim.cmd.GitLink, { desc = "[git] yank link" })

	vim.keymap.set("n", "<leader>gg", function()
		require("neogit").open({ kind = "floating" })
	end, { desc = "[neogit] open" })
end

do -- status
	local status_group = vim.api.nvim_create_augroup("UserStatus", { clear = true })
	vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
		group = status_group,
		pattern = "*",
		callback = function()
			vim.wo.statusline = "%!v:lua.require'user.status'.active()"
		end
	})

	vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
		group = status_group,
		pattern = "*",
		callback = function()
			vim.wo.statusline = "%!v:lua.require'user.status'.inactive()"
		end
	})
end
