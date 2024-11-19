return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		opts = {},
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "canary",
		dependencies = { { "zbirenbaum/copilot.lua" }, { "nvim-lua/plenary.nvim" } },
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
}
