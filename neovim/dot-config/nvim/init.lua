vim.loader.enable()

local utils = require("user.utils")

vim.opt.background = "dark"
vim.cmd.colorscheme({ "unokai" })

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
vim.opt.secure = true
vim.opt.mouse = ""
vim.opt.hidden = true
vim.opt.bufhidden = "hide"
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.jumpoptions = "stack"

vim.opt.winborder = "double"

vim.opt.complete = { ".", "t", "o" }
vim.opt.completeopt = { "noselect", "menuone", "popup", "fuzzy" }
vim.opt.autocomplete = false
vim.opt.pumheight = 10

require("vim._extui").enable({ enable = true, msg = { target = "cmd", timeout = 4000 } })

if vim.fn.has("nvim-0.12") == 1 then
	vim.opt.diffopt = { "internal", "filler", "closeoff", "inline:simple", "linematch:40" }
elseif vim.fn.has("nvim-0.11") == 1 then
	vim.opt.diffopt = { "internal", "filler", "closeoff", "linematch:40" }
end

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

vim.keymap.set("n", "<leader><cr>", function()
	local lines = vim.o.lines or 80
	local height = math.ceil(lines / 3)
	vim.cmd.split({ args = { "+terminal" }, range = { height }, mods = { horizontal = true, split = "botright" } })
end, { desc = "open terminal" })

vim.keymap.set("i", "<c-n>", function()
	if tonumber(vim.fn.pumvisible()) ~= 0 then
		return "<c-n>"
	end
	if next(vim.lsp.get_clients({ bufnr = 0 })) then
		vim.lsp.completion.get()
		return ""
	end
	if not vim.bo.omnifunc or vim.bo.omnifunc == "" then
		return "<c-x><c-n>"
	end
	return "<c-x><c-o>"
end, { desc = "next completion", expr = true })

vim.keymap.set({ "i", "s" }, "<c-j>", function()
	if vim.snippet.active({ direction = -1 }) then
		return "<cmd>lua vim.snippet.jump(-1)<CR>"
	end
	return "<c-j>"
end, { desc = "previous snippet tabstop", expr = true })

vim.keymap.set({ "i", "s" }, "<c-k>", function()
	if vim.snippet.active({ direction = 1 }) then
		return "<cmd>lua vim.snippet.jump(1)<CR>"
	end
	return "<c-k>"
end, { desc = "next snippet tabstop", expr = true })

vim.keymap.set("i", "<tab>", function()
	if not vim.lsp.inline_completion.get() then
		return "<tab>"
	end
end, { expr = true, replace_keycodes = true, desc = "accept suggestion" })

vim.keymap.set("i", "<s-tab>", function()
	vim.lsp.inline_completion.select()
end, { desc = "cycle suggestion" })

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

vim.filetype.add({ extension = { beancount = "beancount", bean = "beancount", cheat = "navi" } })

do -- lsp
	vim.pack.add({
		"https://github.com/mason-org/mason.nvim",
		"https://github.com/neovim/nvim-lspconfig",
	})

	require("mason").setup()
	local m_registry = require("mason-registry")

	local function ensure_installed(name)
		local pkg = m_registry.get_package(name)
		if pkg:is_installed() or pkg:is_installing() then
			return
		end
		pkg:install()
	end

	ensure_installed("typescript-language-server")
	ensure_installed("eslint-lsp")
	ensure_installed("lua-language-server")
	ensure_installed("json-lsp")
	ensure_installed("pyright")
	ensure_installed("prettierd")
	ensure_installed("eslint_d")

	vim.lsp.enable({ "lua_ls", "jsonls", "ts_ls", "eslint", "pyright" })

	local lsp_group = vim.api.nvim_create_augroup("UserLsp", { clear = true })
	vim.api.nvim_create_autocmd("LspAttach", {
		group = lsp_group,
		callback = function(args)
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			if not client then
				vim.notify("invalid client", vim.log.levels.WARN)
				return
			end

			vim.bo[args.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

			-- if client:supports_method("textDocument/formatting", args.buf) then
			-- 	vim.api.nvim_create_autocmd("BufWritePre", {
			-- 		group = lsp_group,
			-- 		buffer = args.buf,
			-- 		callback = function()
			-- 			vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
			-- 		end,
			-- 	})
			-- end

			if client:supports_method("textDocument/completion", args.buf) then
				vim.lsp.completion.enable(true, client.id, args.buf, {
					autotrigger = true,
					convert = function(item)
						return { abbr = item.label:gsub("%b()", "") }
					end,
				})
			end

			if client:supports_method("textDocument/inlineCompletion", args.buf) then
				vim.lsp.inline_completion.enable(true)
			end
		end,
	})
end

do -- fzf
	vim.pack.add({ "https://github.com/ibhagwan/fzf-lua" })

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
			},
		},
	})
	fzf.register_ui_select()

	local keymaps = {
		-- NOTE: testing builtin find with custom findfunc
		-- f = "files",
		-- h = "helptags",
		-- b = "buffers",
		k = "keymaps",
		r = "resume",
		o = "oldfiles",
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
	vim.keymap.set("n", "grl", "<cmd>FzfLua lsp_live_workspace_symbols<cr>", { desc = "[fzf-lua] workspace symbols" })
	vim.keymap.set("n", "grd", "<cmd>FzfLua lsp_document_symbols<cr>", { desc = "[fzf-lua] document symbols" })
end

do -- oil
	vim.pack.add({ "https://github.com/stevearc/oil.nvim" })

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
		columns = { "icon", "permissions", "size", "mtime" },
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
		"https://github.com/tpope/vim-fugitive",
	})

	require("gitlinker").setup()

	vim.keymap.set({ "n", "v" }, "<leader>gy", vim.cmd.GitLink, { desc = "[git] yank link" })

	vim.keymap.set("n", "<leader>gg", function()
		require("neogit").open({ kind = "floating" })
	end, { desc = "[neogit] open" })

	vim.keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", { desc = "[diffview] file history" })
end

do -- status
	local status_group = vim.api.nvim_create_augroup("UserStatus", { clear = true })
	vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
		group = status_group,
		pattern = "*",
		callback = function()
			vim.wo.statusline = "%!v:lua.require'user.status'.active()"
		end,
	})

	vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
		group = status_group,
		pattern = "*",
		callback = function()
			vim.wo.statusline = "%!v:lua.require'user.status'.inactive()"
		end,
	})
end

do -- copilot
	vim.pack.add({
		{ src = "https://github.com/nvim-lua/plenary.nvim", version = "master" },
		{ src = "https://github.com/zbirenbaum/copilot.lua" },
		{ src = "https://github.com/CopilotC-Nvim/CopilotChat.nvim" },
	})

	require("copilot").setup({})
	require("CopilotChat").setup({})
end

do -- findfunc
	---@diagnostic disable-next-line: duplicate-set-field
	function _G.user_findfunc(cmdarg)
		local result = vim.system({ "fd", "--full-path", "--hidden", "--follow" }, { text = true }):wait()
		if not result or result.code ~= 0 then
			vim.notify("findfunc: failed to list files" .. result.stdout, vim.log.levels.ERROR)
			return {}
		end
		local files = vim.split(result.stdout, "\n", { trimempty = true })
		if vim.trim(cmdarg or "") == "" then
			return files
		end
		return vim.fn.matchfuzzy(files, cmdarg)
	end

	vim.api.nvim_create_autocmd({ "CmdlineChanged" }, {
		group = vim.api.nvim_create_augroup("UserCmdlineAutocomp", { clear = true }),
		callback = utils.debounce(
			vim.schedule_wrap(utils.with_opts(function()
				if vim.fn.getcmdtype() ~= ":" then
					return
				end
				local ok, cmd = pcall(vim.api.nvim_parse_cmd, vim.fn.getcmdline(), {})
				if not ok then
					vim.notify_once("cmdlinechanged: failed to parse cmdline, err: " .. cmd, vim.log.levels.ERROR)
					return
				end
				local wildtrigger_cmds = { "find", "sfind", "tabfind", "help", "buffer" }
				if not vim.list_contains(wildtrigger_cmds, cmd.cmd) then
					return
				end
				vim.fn.wildtrigger()
			end, { wildmode = { "noselect:lastused", "full" } })),
			500
		),
	})

	vim.opt.findfunc = "v:lua.user_findfunc"

	vim.keymap.set("n", "<leader>ff", ":<c-u>find ", { desc = "find" })
	vim.keymap.set("n", "<leader>fs", ":<c-u>sfind ", { desc = "sfind" })
	vim.keymap.set("n", "<leader>fv", ":<c-u>vertical sfind ", { desc = "vfind" })
	vim.keymap.set("n", "<leader>ft", ":<c-u>tabfind ", { desc = "tabfind" })
	vim.keymap.set("n", "<leader>fh", ":<c-u>help ", { desc = "help" })
	vim.keymap.set("n", "<leader>fb", ":<c-u>buffer ", { desc = "buffer" })
end

do -- treesitter
	vim.pack.add({
		"https://github.com/nvim-treesitter/nvim-treesitter",
		"https://github.com/nvim-treesitter/nvim-treesitter-context",
	})

	---@diagnostic disable-next-line: missing-fields
	require("nvim-treesitter.configs").setup({
		ensure_installed = {
			"bash",
			"c",
			"comment",
			"diff",
			"html",
			"javascript",
			"jsdoc",
			"json",
			"jsonc",
			"lua",
			"luadoc",
			"luap",
			"markdown",
			"markdown_inline",
			"printf",
			"python",
			"query",
			"regex",
			"toml",
			"tsx",
			"typescript",
			"vim",
			"vimdoc",
			"xml",
			"yaml",
		},
		sync_install = false,
		auto_install = true,
		highlight = { enable = true, additional_vim_regex_highlighting = false },
		indent = { enable = true },
	})
end

do -- conform
	vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

	local conform = require("conform")

	---@param bufnr integer
	---@param ... string
	---@return string
	local function first(bufnr, ...)
		for i = 1, select("#", ...) do
			local formatter = select(i, ...)
			if conform.get_formatter_info(formatter, bufnr).available then
				return formatter
			end
		end
		return select(1, ...)
	end

	local function ecma_formatters(bufnr)
		return { first(bufnr, "prettierd", "prettier"), first(bufnr, "eslint_d", "eslint") }
	end

	conform.setup({
		log_level = vim.log.levels.TRACE,
		notify_on_error = true,
		notify_no_formatters = true,
		format_on_save = { lsp_format = "fallback", timeout_ms = 750 },
		formatters_by_ft = {
			lua = { "stylua" },
			sh = { "shfmt", "shellcheck" },
			fish = { "fish_indent" },
			bash = { "shfmt", "shellcheck" },
			python = { "isort", "black" },
			go = { "goimports", "golines", "gofmt" },
			sql = { "sleek" },

			javascript = ecma_formatters,
			typescript = ecma_formatters,
			javascriptreact = ecma_formatters,
			typescriptreact = ecma_formatters,
			["typescript.tsx"] = ecma_formatters,
			["javascript.jsx"] = ecma_formatters,
			vue = ecma_formatters,
		},
	})

	vim.opt.formatexpr = "v:lua.require'conform'.formatexpr()"
end

do -- testing
	vim.pack.add({ "https://github.com/vim-test/vim-test" })

	local function with_env_ci(cmd)
		return "CI=true " .. cmd
	end

	vim.g["test#strategy"] = "neovim_sticky"
	vim.g["test#preserve_screen"] = 1
	vim.g["test#neovim#start_normal"] = 1
	vim.g["test#preserve_screen"] = 0
	vim.g["test#neovim_sticky#kill_previous"] = 1
	vim.g["test#neovim_sticky#reopen_window"] = 1
	vim.g["test#neovim_sticky#use_existing"] = 1
	vim.g["test#neovim#term_position"] = "hor botright 30"

	vim.g["test#custom_transformations"] = { with_env_ci = with_env_ci }
	vim.g["test#transformation"] = "with_env_ci"

	vim.g["test#javascript#runner"] = "jest"
	vim.g["test#javascript#jest#executable"] = "npm run test --"
	vim.g["test#javascript#jest#options"] = "--no-coverage"

	vim.keymap.set("n", "<leader>tt", vim.cmd.TestNearest, { desc = "[test] run nearest" })
	vim.keymap.set("n", "<leader>tf", vim.cmd.TestFile, { desc = "[test] run file" })
	vim.keymap.set("n", "<leader>tl", vim.cmd.TestLast, { desc = "[test] run last" })
end

do -- folding
	vim.opt.foldmethod = "expr"
	vim.opt.foldexpr = "v:lua.vim.lsp.foldexpr()"
	vim.opt.foldtext = ""
	vim.opt.foldcolumn = "auto"
	vim.opt.foldcolumn = "0"
	vim.opt.foldlevel = 99
	vim.opt.foldlevelstart = 1
	vim.opt.foldnestmax = 6
end

do -- codecompanion
	vim.pack.add({
		{ src = "https://github.com/nvim-lua/plenary.nvim", version = "master" },
		"https://github.com/nvim-treesitter/nvim-treesitter",
		"https://github.com/olimorris/codecompanion.nvim",
	})

	---@diagnostic disable-next-line: undefined-field
	require("codecompanion").setup()
end

vim.keymap.set("n", "<leader>fy", function()
	local function get_path(type)
		if type == "relative" then
			return vim.fn.expand("%:~:.")
		elseif type == "absolute" then
			return vim.fn.expand("%:p")
		end
		error("unknown type")
	end

	vim.ui.select({ "relative", "absolute" }, {
		prompt = "Pick path",
		format_item = function(item)
			return item .. " = " .. get_path(item)
		end,
	}, function(item)
		if not item or item == "" then
			return
		end
		local fpath = get_path(item)
		vim.fn.setreg("+", fpath)
	end)
end, { desc = "find" })

do -- shada
	local root = assert(vim.uv.cwd())
	local data_dir = vim.fn.stdpath("data")
	local root_id = vim.fn.fnamemodify(root, ":t") .. "_" .. vim.fn.sha256(root):sub(1, 8) .. ".shada"
	vim.opt.shadafile = vim.fs.joinpath(data_dir, "shada", root_id)
end

do -- abbreviations
	vim.cmd.iabbrev({ args = { "<expr>", "dt@", [[strftime('%Y-%m-%d')]] } })
	vim.cmd.iabbrev({ args = { "<expr>", "uuid@", [[ systemlist('uuidgen')[0] ]] } })
	vim.cmd.iabbrev({
		args = { "todo@", [[<c-r>=printf(&commentstring, 'TODO')<cr>(<c-r>=strftime('%Y-%m-%d')<cr>):]] },
	})
end

do -- dadbod
	vim.pack.add({
		"https://github.com/tpope/vim-dadbod",
		"https://github.com/kristijanhusak/vim-dadbod-ui",
		"https://github.com/kristijanhusak/vim-dadbod-completion",
	})

	vim.g.dbs = {
		{ name = "nova-dev", url = "postgres://novadb:novadbareyoukiddingme@127.0.0.1:5432/nova" },
	}
end
