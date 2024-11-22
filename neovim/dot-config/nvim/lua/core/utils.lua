local utils = {}

---@alias core.utils.get_cwd.Scope
---| '"global"' # global cwd
---| '"tab"' # tab cwd (see :h tcd)
---| '"buffer"' # get buffer directory

---@generic T : any
---@param fn fun(...: any[]): T Function to bind
---@param ... any[] Arguments to bind
---@return fun(...: any[]): T
function utils.bind(fn, ...)
	local args = { ... }
	return function(...)
		vim.list_extend(args, { ... })
		return fn(unpack(args))
	end
end

---Check if err matches expected vim error code
---@param err unknown The error object
---@param code string The expected error code
---@return boolean
function utils.is_err(err, code)
	local pattern = string.format("^Vim:%s:.*", code)
	return type(err) == "string" and string.match(err, pattern) ~= nil
end

---Source ftplugins for the given filetypes
---@param ... string
function utils.ft_runtime(...)
	vim.iter({ ... })
		:map(function(ft)
			return { string.format("ftplugin/%s.lua", ft), string.format("ftplugin/%s/*.lua", ft) }
		end)
		:flatten()
		:map(function(pattern)
			vim.cmd.runtime({ pattern, bang = true })
		end)
		:totable()
end

---Returns true if path is a directory.
---@param path string
---@return boolean
function utils.is_dir(path)
	local stat, err_name, err_msg = vim.uv.fs_stat(path)
	assert(
		(err_name or "") == "" and (err_msg or "") == "",
		string.format("failed to stat path: '%s', err_name: '%s', err_msg: '%s'", path, err_name, err_msg)
	)
	assert(stat, string.format("failed to stat path: '%s', returned nil", path))

	return stat.type == "directory"
end

---Get cwd based on the scope.
---@param opts? { scope?: core.utils.get_cwd.Scope }
---@return string
function utils.get_cwd(opts)
	opts = opts or {}
	opts.scope = opts.scope or "global"

	if opts.scope == "global" then
		return vim.fn.getcwd(-1, -1)
	elseif opts.scope == "tab" then
		return vim.fn.getcwd(0, 0)
	end

	local bufname = vim.api.nvim_buf_get_name(0)
	if utils.is_dir(bufname) then
		return bufname
	end
	return vim.fs.dirname(bufname)
end

return utils
