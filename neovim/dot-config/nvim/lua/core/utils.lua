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

return utils
