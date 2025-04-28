local function get_gemini_api_key()
	local api_key = vim.env.GEMINI_API_KEY
	if not api_key or api_key == "" then
		vim.notify("Gemini API key not found", vim.log.levels.WARN)
		return nil
	end
	return api_key
end

require("codecompanion").setup({
	display = { chat = { show_settings = true } },
	adapters = {
		gemini = function()
			local api_key = get_gemini_api_key()
			return require("codecompanion.adapters").extend("gemini", { env = { api_key = api_key } })
		end,
	},
	strategies = {
		chat = {
			adapter = "gemini",
			slash_commands = {
				git_files = {
					description = "List git files",
					---@param chat CodeCompanion.Chat
					callback = function(chat)
						local result = vim.system({ "git", "ls-files" }, { text = true }):wait()
						if result.code ~= 0 then
							vim.notify("Failed to list git files", vim.log.levels.ERROR)
						end
						chat:add_reference({ role = "user", content = result.stdout }, "git", "<git_files>")
					end,
					opts = { contains_code = false },
				},
				git_status = {
					description = "List git status",
					---@param chat CodeCompanion.Chat
					callback = function(chat)
						local result = vim.system({ "git", "status", "--porcelain" }, { text = true }):wait()
						if result.code ~= 0 then
							vim.notify("Failed to list git status", vim.log.levels.ERROR)
						end
						chat:add_reference({ role = "user", content = result.stdout }, "git", "<git_status>")
					end,
					opts = { contains_code = false },
				},
				git_diff_staged = {
					description = "List git staged changes",
					---@param chat CodeCompanion.Chat
					callback = function(chat)
						local result = vim.system({ "git", "diff", "--staged" }, { text = true }):wait()
						if result.code ~= 0 then
							vim.notify("Failed to list git staged changes", vim.log.levels.ERROR)
						end
						chat:add_reference({ role = "user", content = result.stdout }, "git", "<git_diff_staged>")
					end,
					opts = { contains_code = false },
				},
			},
		},
		inline = { adapter = "gemini" },
	},
})
