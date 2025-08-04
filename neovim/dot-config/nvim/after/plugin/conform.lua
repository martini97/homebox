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
