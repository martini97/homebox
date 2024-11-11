local group = vim.api.nvim_create_augroup("UserColors", { clear = true })

-- this is required to apply the expected highlights to the cursor
vim.opt.guicursor = "n-v-c:block-Cursor/lCursor,i:block-iCursor"

---@type table<string, vim.api.keyset.highlight>
local override_hls_map = {
	Cursor = { bg = "#add8e6" },
	iCursor = { bg = "#e6adbc" },
}

local function override_hls()
	for hl, val in pairs(override_hls_map) do
		vim.api.nvim_set_hl(0, hl, val)
	end
end

vim.api.nvim_create_autocmd("ColorScheme", { group = group, pattern = "*", callback = override_hls })
vim.cmd.colorscheme("default")
