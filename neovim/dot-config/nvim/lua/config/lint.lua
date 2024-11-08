local lint = require("lint")

lint.linters_by_ft = {
	lua = { "selene" },
	sh = { "shellcheck" },
	bash = { "shellcheck" },
	fish = { "fish" },
	javascript = { "eslint_d" },
	typescript = { "eslint_d" },
	javascriptreact = { "eslint_d" },
	typescriptreact = { "eslint_d" },
	["typescript.tsx"] = { "eslint_d" },
	["javascript.jsx"] = { "eslint_d" },
	vue = { "eslint_d" },
}

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave", "TextChanged" }, {
	desc = "Automatically lint buffers",
	group = vim.api.nvim_create_augroup("UserLint", { clear = true }),
	callback = function()
		lint.try_lint()
	end,
})
