---@param bufnr integer
---@param ... string
---@return string
local function first(bufnr, ...)
	local conform = require("conform")
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

return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		init = function()
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		end,
		---@module "conform"
		---@type conform.setupOpts
		opts = {
			log_level = vim.log.levels.TRACE,
			notify_on_error = true,
			format_on_save = { lsp_fallback = true, timeout_ms = 750 },
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
		},
	},
}
