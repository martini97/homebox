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
	vim.opt.splitright = true
	vim.opt.splitbelow = true

	vim.opt.foldmethod = "expr"
	vim.opt.foldexpr = "v:lua.vim.lsp.foldexpr()"
	vim.opt.foldtext = ""
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

	vim.keymap.set("n", "<leader>wt", "<cmd>tab split<cr>", { desc = "[window] split to tab" })
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

vim.o.completefunc = "v:lua.require'core.snippets'.completefunc"

do --- beancount
	vim.filetype.add({
		extension = { beancount = "beancount", bean = "beancount" },
	})
end

do --- lsp
	local lsp = require("core.lsp")

	vim.lsp.config("*", lsp.caps.with_caps())
	vim.lsp.enable({ "luals", "volar", "bashls", "pyright" })

	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
		callback = lsp.attach.on_attach,
	})

	vim.api.nvim_create_autocmd({ "LspDetach" }, {
		group = vim.api.nvim_create_augroup("UserLspDetach", {}),
		callback = function(args)
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			local remaining = vim.tbl_filter(function(buf)
				return buf ~= args.buf
			end, vim.tbl_get(client or {}, "attached_buffers") or {})

			if not client or #remaining > 0 then
				return
			end

			vim.notify("[lsp] stopping lsp client: " .. client.name, vim.log.levels.INFO)
			client:stop()
		end,
		desc = "Stop lsp client when no buffer is attached",
	})
end

do --- lazy
	local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

	if not (vim.uv or vim.loop).fs_stat(lazypath) then
		local lazyrepo = "https://github.com/folke/lazy.nvim.git"
		local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
		if vim.v.shell_error ~= 0 then
			vim.api.nvim_echo({
				{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
				{ out, "WarningMsg" },
				{ "\nPress any key to exit..." },
			}, true, {})
			vim.fn.getchar()
			os.exit(1)
		end
	end

	vim.opt.rtp:prepend(lazypath)

	require("lazy").setup({
		install = { colorscheme = { "default" } },
		checker = { enabled = true },
		dev = { path = "~/git/martini97", fallback = true },
		rocks = { hererocks = true },
		spec = {
			--- fzf {{{
			{
				"ibhagwan/fzf-lua",
				event = "VimEnter",
				dependencies = { { "echasnovski/mini.icons", opts = {} } },
				config = function()
					require("config.fzf")
				end,
			},
			--- }}}
			--- colors {{{
			{ "martini97/system-theme.nvim", dev = true, opts = {} },
			--- }}}
			--- conform {{{
			{
				"stevearc/conform.nvim",
				event = { "BufWritePre" },
				cmd = { "ConformInfo" },
				config = function()
					require("config.conform")
				end,
			},
			--- }}}
			--- copilot {{{
			{
				"CopilotC-Nvim/CopilotChat.nvim",
				dependencies = {
					{ "nvim-lua/plenary.nvim", branch = "master" },
					{ "zbirenbaum/copilot.lua", cmd = "Copilot", event = "InsertEnter", opts = {} },
				},
				build = "make tiktoken",
				opts = {},
				cmd = {
					"CopilotChat",
					"CopilotChatFix",
					"CopilotChatDocs",
					"CopilotChatLoad",
					"CopilotChatOpen",
					"CopilotChatSave",
					"CopilotChatStop",
					"CopilotChatClose",
					"CopilotChatReset",
					"CopilotChatTests",
					"CopilotChatAgents",
					"CopilotChatCommit",
					"CopilotChatModels",
					"CopilotChatReview",
					"CopilotChatToggle",
					"CopilotChatExplain",
					"CopilotChatOptimize",
					"CopilotChatDebugInfo",
					"CopilotChatCommitStaged",
					"CopilotChatFixDiagnostic",
				},
				keys = {
					{
						"<leader>aq",
						function()
							vim.ui.input({ prompt = ">>> Quick Chat: " }, function(query)
								if not query or query == "" then
									return
								end
								require("CopilotChat").ask(query, { selection = require("CopilotChat.select").buffer })
							end)
						end,
						mode = "n",
						desc = "[copilot] quick chat",
					},
					{
						"<leader>ap",
						function()
							local actions = require("CopilotChat.actions")
							require("CopilotChat.integrations.fzflua").pick(actions.prompt_actions())
						end,
						mode = "n",
						desc = "[copilot] prompt actions",
					},
					{
						"<leader>aa",
						"<cmd>CopilotChatToggle<cr>",
						mode = "n",
						desc = "[copilot] prompt actions",
					},
				},
			},
			--- }}}
			--- git {{{
			{
				"martini97/git-worktree.nvim",
				dev = true,
				keys = {
					{
						"<leader>gw",
						function()
							require("git-worktree").prompt()
						end,
						mode = "n",
						desc = "[git-worktree] prompt for action",
					},
				},
				config = function()
					vim.g.git_worktree_loglevel = vim.log.levels.INFO
				end,
			},
			{ "tpope/vim-fugitive" },
			{ "tpope/vim-rhubarb" },
			{
				"NeogitOrg/neogit",
				dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim", "ibhagwan/fzf-lua" },
				config = true,
				cmd = { "Neogit" },
				keys = {
					{
						"<leader>gg",
						function()
							require("neogit").open({ kind = "floating" })
						end,
						mode = "n",
						desc = "[neogit] open",
					},
				},
			},
			{
				"linrongbin16/gitlinker.nvim",
				cmd = "GitLink",
				opts = {},
				keys = {
					{ "<leader>gy", vim.cmd.GitLink, mode = { "n", "v" }, desc = "[gitlink] yank" },
				},
			},
			--- }}}
			--- lint {{{
			{
				"mfussenegger/nvim-lint",
				event = { "BufEnter", "BufWritePost", "InsertLeave", "TextChanged" },
				config = function()
					require("config.lint")
				end,
			},
			--- }}}
			--- lsp {{{
			{
				"folke/lazydev.nvim",
				dependencies = { { "Bilal2453/luvit-meta", lazy = true } },
				ft = "lua",
				opts = { library = { { path = "luvit-meta/library", words = { "vim%.uv" } } } },
			},
			{
				"pmizio/typescript-tools.nvim",
				dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
				ft = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
				opts = {},
				config = function()
					require("typescript-tools").setup({
						on_attach = function(client, _bufnr)
							client.server_capabilities.documentFormattingProvider = false
							client.server_capabilities.documentRangeFormattingProvider = false
						end,
						filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
						settings = {
							tsserver_plugins = { "@vue/typescript-plugin" },
							expose_as_code_action = "all",
							jsx_close_tag = {
								enable = true,
								filetypes = { "javascriptreact", "typescriptreact" },
							},
						},
					})
				end,
			},
			--- }}}
			--- mini {{{
			{
				"echasnovski/mini.nvim",
				version = false,
				config = function()
					require("config.mini")
				end,
			},
			--- }}}
			--- oil {{{
			{
				"stevearc/oil.nvim",
				dependencies = { { "echasnovski/mini.icons", opts = {} } },
				config = function()
					require("config.oil")
				end,
			},
			--- }}}
			--- snippets {{{
			{
				"L3MON4D3/LuaSnip",
				version = "v2.*",
				build = "make install_jsregexp",
				config = function()
					require("config.luasnip")
				end,
			},
			--- }}}
			--- treesitter {{{
			{
				"nvim-treesitter/nvim-treesitter",
				dependencies = {
					{ "nvim-treesitter/nvim-treesitter-textobjects" },
					{ "nvim-treesitter/nvim-treesitter-context" },
				},
				build = ":TSUpdate",
				config = function()
					require("config.treesitter")
				end,
			},
			--- }}}
			--- beancount {{{
			{
				"nathangrigg/vim-beancount",
				ft = "beancount",
			},
			--- }}}
			--- beancount {{{
			{
				"rest-nvim/rest.nvim",
				ft = "http",
			},
			--- }}}
			--- blink.nvim {{{
			{
				"saghen/blink.cmp",
				version = "*",
				dependencies = { "L3MON4D3/LuaSnip", version = "v2.*" },
				opts = {
					snippets = { preset = "luasnip" },
					signature = { enabled = true },
					keymap = { preset = "default" },
					appearance = {
						use_nvim_cmp_as_default = true,
						nerd_font_variant = "mono",
					},
					sources = { default = { "lsp", "path", "snippets", "buffer" } },
					fuzzy = { implementation = "prefer_rust_with_warning" },
					completion = {
						documentation = { auto_show = true, auto_show_delay_ms = 500 },
						menu = {
							draw = {
								columns = { { "label", "label_description", gap = 1 }, { "kind" } },
								components = {
									kind = {
										ellipsis = false,
										text = function(ctx)
											return ctx.kind
										end,
										highlight = function(ctx)
											local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
											return hl
										end,
									},
								},
							},
						},
					},
				},
				opts_extend = { "sources.default" },
			},
			--- }}}
			--- undotree {{{
			{
				"mbbill/undotree",
				config = function()
					local undo_dir = vim.fs.joinpath(vim.fn.stdpath("state"), "undo")
					if not vim.uv.fs_stat(undo_dir) then
						vim.fn.mkdir(undo_dir, "p", "0700")
					end

					vim.opt.undodir = undo_dir
					vim.opt.undofile = true

					vim.keymap.set("n", "<leader>tu", vim.cmd.UndotreeToggle)
				end,
			},
			--- }}}
			--- harpoon {{{
			{
				"ThePrimeagen/harpoon",
				branch = "harpoon2",
				dependencies = { "nvim-lua/plenary.nvim" },
				config = function()
					local harpoon = require("harpoon")
					harpoon:setup()

					vim.keymap.set("n", "<leader>ha", function()
						harpoon:list():add()
					end, { desc = "[harpoon] add" })
					vim.keymap.set("n", "<c-h>a", function()
						harpoon:list():add()
					end, { desc = "[harpoon] add" })

					vim.keymap.set("n", "<leader>hm", function()
						harpoon.ui:toggle_quick_menu(harpoon:list())
					end, { desc = "[harpoon] toggle quick menu" })
					vim.keymap.set("n", "<c-h>m", function()
						harpoon.ui:toggle_quick_menu(harpoon:list())
					end, { desc = "[harpoon] toggle quick menu" })

					vim.keymap.set("n", "<leader>hp", function()
						harpoon:list():prev()
					end, { desc = "[harpoon] previous" })
					vim.keymap.set("n", "<c-h>p", function()
						harpoon:list():prev()
					end, { desc = "[harpoon] previous" })

					vim.keymap.set("n", "<leader>hn", function()
						harpoon:list():next()
					end, { desc = "[harpoon] next" })
					vim.keymap.set("n", "<c-h>n", function()
						harpoon:list():next()
					end, { desc = "[harpoon] next" })

					for i = 1, 10 do
						vim.keymap.set("n", "<leader>h" .. tostring(i % 10), function()
							harpoon:list():select(i)
						end, { desc = "[harpoon] select " .. tostring(i) .. " nth" })
						vim.keymap.set("n", "<c-h>" .. tostring(i % 10), function()
							harpoon:list():select(i)
						end, { desc = "[harpoon] select " .. tostring(i) .. " nth" })
					end

					for i, k in ipairs({ "h", "j", "k", "l", ";" }) do
						vim.keymap.set("n", "<leader>h" .. k, function()
							harpoon:list():select(i)
						end, { desc = "[harpoon] select " .. tostring(i) .. " nth" })
						vim.keymap.set("n", "<c-h>" .. k, function()
							harpoon:list():select(i)
						end, { desc = "[harpoon] select " .. tostring(i) .. " nth" })
					end
				end,
			},
			--- }}}
		},
	})
end
