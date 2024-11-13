local formatter = {}
local Logger = require("vlog")

local logger = Logger:new({ plugin = "core.formatter", level = Logger.get_level_from_env("VIM_LOGLEVEL") })

---@class core.formatter.Opts
---@field bufnr? number
---@field start_lnum? number
---@field end_lnum? number
---@field timeout? number
---@field formatprg? string

---Check if a vim.system call timed out.
---@param syscomp vim.SystemCompleted
---@return boolean
local function system_timedout(syscomp)
	local timeout_code = 124
	return syscomp.code == timeout_code
end

---@param opts core.formatter.Opts
---@return number
function formatter.formatprg(opts)
	opts = opts or {}
	opts.bufnr = opts.bufnr or 0
	opts.start_lnum = opts.start_lnum or 0
	opts.end_lnum = opts.end_lnum or vim.api.nvim_buf_line_count(opts.bufnr)
	opts.timeout = opts.timeout or 500
	opts.formatprg = opts.formatprg or vim.bo[opts.bufnr].formatprg

	if opts.start_lnum < 0 or opts.end_lnum < 0 then
		logger:warn("invalid range for formatprg", opts)
		return 0
	end

	if not opts.formatprg or opts.formatprg == "" then
		logger:warn("formatprg is not set", opts)
		return 0
	end

	local stdin = vim.api.nvim_buf_get_lines(opts.bufnr, opts.start_lnum, opts.end_lnum, true)
	local result = vim.system(
		{ vim.o.shell, vim.o.shellcmdflag, vim.fn.expandcmd(opts.formatprg) },
		{ stdin = stdin, text = true, timeout = 500 }
	):wait()

	if system_timedout(result) then
		logger:warn("formatter timed out", opts)
		return 0
	end

	if result.code ~= 0 then
		local stderr = vim.split(result.stderr or "", "\n", { trimempty = true })
		logger:error("formatter failed", { opts = opts, stderr = stderr })
		return 0
	end

	local lines = vim.split(result.stdout or "", "\n", { trimempty = true })
	vim.api.nvim_buf_set_lines(opts.bufnr, opts.start_lnum, opts.end_lnum, true, lines)

	local view = vim.w.saved_view
	if view then
		vim.fn.winrestview(view)
		vim.w.saved_view = nil
	end
	return 0
end

---Execute formatter.formatprg as formatexpr
function formatter.formatexpr()
	if vim.list_contains({ "i", "R", "ic", "ix" }, vim.fn.mode()) then
		return 1
	end
	formatter.formatprg({ start_lnum = vim.v.lnum - 1, end_lnum = vim.v.lnum + vim.v.count - 1 })
end

---Register formatter.formatexpr as the formatexpr for the bufnr
---@param bufnr? integer
function formatter.register(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	vim.bo[bufnr].formatexpr = [[v:lua.require("core.formatter").formatexpr()]]
	logger:debug("registered buffer", { bufnr = bufnr, formatexpr = vim.bo[bufnr].formatexpr })
end

return formatter
