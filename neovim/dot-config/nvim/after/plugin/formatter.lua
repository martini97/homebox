if vim.g.loaded_formatter == 1 then
	return
end

vim.g.loaded_formatter = 1

local TIMEOUT_CODE = 124
local plugin_name = "formatter"

---@class formatter.Opts
---@field bufnr? number
---@field start_lnum? number
---@field end_lnum? number
---@field timeout? number
---@field formatprg? string

local function logger(level)
	return function(msg, ctx)
		msg = string.format("[%s] %s, ctx=%s", plugin_name, msg, vim.inspect(ctx))
		vim.notify(msg, level)
	end
end

local log_debug = logger(vim.log.levels.DEBUG)
local log_info = logger(vim.log.levels.INFO)
local log_warn = logger(vim.log.levels.WARN)
local log_error = logger(vim.log.levels.ERROR)

---@param opts formatter.Opts
---@return number
function _G.formatprg(opts)
	opts = opts or {}
	opts.bufnr = opts.bufnr or 0
	opts.start_lnum = opts.start_lnum or 0
	opts.end_lnum = opts.end_lnum or vim.api.nvim_buf_line_count(opts.bufnr)
	opts.timeout = opts.timeout or 500
	opts.formatprg = opts.formatprg or vim.bo[opts.bufnr].formatprg

	if opts.start_lnum < 0 or opts.end_lnum < 0 then
		log_warn("invalid range for formatprg", opts)
		return 0
	end

	if not opts.formatprg or opts.formatprg == "" then
		log_warn("formatprg is not set", opts)
		return 0
	end

	local stdin = vim.api.nvim_buf_get_lines(opts.bufnr, opts.start_lnum, opts.end_lnum, true)
	local result = vim.system(
		{ vim.o.shell, vim.o.shellcmdflag, vim.fn.expandcmd(opts.formatprg) },
		{ stdin = stdin, text = true, timeout = 500 }
	):wait()

	if result.code == TIMEOUT_CODE then
		log_warn("formatter timed out", opts)
		return 0
	end

	if result.code ~= 0 then
		local stderr = vim.split(result.stderr or "", "\n", { trimempty = true })
		log_error("formatter failed", { opts = opts, stderr = stderr })
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

function _G.format_expr()
	if vim.list_contains({ "i", "R", "ic", "ix" }, vim.fn.mode()) then
		return 1
	end
	_G.formatprg({ start_lnum = vim.v.lnum - 1, end_lnum = vim.v.lnum + vim.v.count - 1 })
end

vim.opt.formatexpr = "v:lua.format_expr()"
