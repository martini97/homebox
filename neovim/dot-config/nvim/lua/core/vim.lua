local M = {}

---Check if err matches expected vim error code
---@param err unknown The error object
---@param code string The expected error code
---@return boolean
function M.is_err(err, code)
	local pattern = string.format("^Vim:%s:.*", code)
	return type(err) == "string" and string.match(err, pattern) ~= nil
end

return M
