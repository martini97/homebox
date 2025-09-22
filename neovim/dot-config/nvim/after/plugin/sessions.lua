if vim.g.loaded_sessions then
	return
end

vim.g.loaded_sessions = 1

_G.sessions = _G.sessions or {}

local group = vim.api.nvim_create_augroup("UserSession", { clear = true })
local sessions_dir = vim.g.sessions_dir or vim.fs.joinpath(vim.fn.stdpath("data"), "sessions")

if not vim.uv.fs_stat(sessions_dir) then
	vim.uv.fs_mkdir(sessions_dir, tonumber("755", 8))
end

---@param bufnr integer
---@return boolean
local function skip_save(bufnr)
	local bufname = vim.api.nvim_buf_get_name(bufnr)
	if vim.fs.basename(bufname or "") == "COMMIT_EDITMSG" then
		return true
	end
	return false
end

function _G.sessions.get_current_session_file()
	local root = assert(vim.uv.cwd())
	local root_id = vim.fn.fnamemodify(root, ":t") .. "_" .. vim.fn.sha256(root):sub(1, 8) .. ".vim"
	return vim.fs.joinpath(sessions_dir, root_id)
end

function _G.sessions.save_session()
	local bufnr = vim.api.nvim_get_current_buf()
	if skip_save(bufnr) then
		return
	end

	local session = _G.sessions.get_current_session_file()
	vim.cmd.mksession({ args = { session }, bang = true })
	vim.notify("save session: " .. session, vim.log.levels.INFO)
end

function _G.sessions.load_session()
	local bufnr = vim.api.nvim_get_current_buf()
	local bufname = vim.api.nvim_buf_get_name(bufnr)
	if bufname and bufname ~= "" then
		return
	end
	if vim.fn.argc() > 0 then
		return
	end

	local session = _G.sessions.get_current_session_file()
	if not vim.uv.fs_stat(session) then
		return
	end

	vim.schedule(function()
		vim.cmd.source({ args = { session } })
		vim.notify("load session: " .. session, vim.log.levels.INFO)
	end)
end

vim.api.nvim_create_autocmd("VimLeavePre", { group = group, callback = _G.sessions.save_session })
vim.api.nvim_create_autocmd("VimEnter", { group = group, callback = _G.sessions.load_session })
