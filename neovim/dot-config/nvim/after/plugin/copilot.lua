local copilot = require("copilot")
local chat = require("CopilotChat")

copilot.setup({ suggestion = { enabled = true }, panel = { enabled = true } })
chat.setup({})

vim.keymap.set("n", "<leader>aq", function()
	vim.ui.input({ prompt = ">>> Quick Chat: " }, function(query)
		if not query or query == "" then
			return
		end
		require("CopilotChat").ask(query, { selection = require("CopilotChat.select").buffer })
	end)
end, { desc = "[copilot] quick chat" })

vim.keymap.set("n", "<leader>ap", function()
	chat.select_prompt()
end, { desc = "[copilot] prompt actions" })

vim.keymap.set("n", "<leader>aa", "<cmd>CopilotChatToggle<cr>", { desc = "[copilot] toggle chat" })
