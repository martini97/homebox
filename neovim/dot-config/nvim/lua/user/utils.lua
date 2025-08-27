local M = {}

---Debounce func on trailing edge.
---@generic F: function
---@param func F
---@param delay_ms number
---@return F
function M.debounce(func, delay_ms)
	---@type uv.uv_timer_t?
	local timer = nil
	---@type boolean?
	local running = nil
	return function(...)
		if not running then
			timer = assert(vim.uv.new_timer())
		end
		local argv = { ... }
		assert(timer):start(delay_ms, 0, function()
			assert(timer):stop()
			running = nil
			func(unpack(argv, 1, table.maxn(argv)))
		end)
	end
end

---Override vim.opts for function
---@generic F: function
---@param func F
---@param opts table<string, any>
---@return F
function M.with_opts(func, opts)
	return function(...)
		local prev = {}
		for key, value in pairs(opts) do
			prev[key] = vim.opt[key]
			vim.opt[key] = value
		end
		local result = func(...)
		for key, value in pairs(prev) do
			vim.opt[key] = value
		end
		return result
	end
end

return M
