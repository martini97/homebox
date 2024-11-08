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
			branch = "canary",
			dependencies = {
				{ "nvim-lua/plenary.nvim" },
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
			"neovim/nvim-lspconfig",
			config = function()
				require("config.lsp")
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
			},
			build = ":TSUpdate",
			config = function()
				require("config.treesitter")
			end,
		},
		--- }}}
	},
})
