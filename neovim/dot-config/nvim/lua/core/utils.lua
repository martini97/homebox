local utils = {}

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
	local filetypes = { ... }
	for _, filetype in pairs(filetypes) do
		vim.cmd.runtime({ string.format("ftplugin/%s.lua", filetype), bang = true })
	end
end

return utils
