---Returns the stdout as an array of strings
---@param syscomp vim.SystemCompleted
---@return string[]
local function get_stdout_lines(syscomp)
	--- TODO(2024-11-11): @martini97: check for error before returning lines
	return vim.split(syscomp.stdout, "\n", { plain = true, trimempty = true })
end

---Check if cmd is available as executable
---@param cmd string
---@return boolean
local function has_cmd(cmd)
	return vim.fn.executable(cmd) == 1
end

---Transform str into a glob
---@param str string
---@return string
local function globify(str)
	str = str or ""
	if str == "" then
		return str
	end
	if not vim.startswith(str, "**/") then
		str = "**/" .. str
	end
	if not vim.endswith(str, "*") then
		str = str .. "*"
	end
	return str
end

---Convert a glob into an fzf pattern
---@param glob string
---@return string
local function glob_to_fzf(glob)
	-- fzf does not accept '*' so we need to convert them into ' '
	local res, _ = string.gsub(glob, vim.pesc("*"), " ")
	return res
end

---@param query string
---@return string[]
local function list_files(query)
	if has_cmd("fd") then
		local cmd = { "fd", "--full-path", "--hidden", "--color", "never", "--glob", globify(query) }
		local result = vim.system(cmd, { text = true }):wait()
		return get_stdout_lines(result)
	end
	error("findfunc: could not list files")
end

---@param query string
---@param files string[]
---@return string[]
local function filter_files(query, files)
	if query and vim.uv.fs_statfs(query) then
		return { query }
	end
	if has_cmd("fzf") then
		local cmd = { "fzf", "--filter", glob_to_fzf(query) }
		local result = vim.system(cmd, { stdin = files, text = true }):wait()
		return get_stdout_lines(result)
	end
	return vim.iter(files)
		:filter(function(file)
			return string.match(file, query)
		end)
		:totable()
end

---Custom findfunc
---@param query string
---@return string[]
function _G.user_findfunc(query)
	local files_ok, files_or_err = pcall(list_files, query)
	if not files_ok then
		vim.notify(string.format("findfunc: failed to find files, error: %s", files_or_err), vim.log.levels.ERROR)
		return {}
	end
	local filtered_ok, filtered_or_err = pcall(filter_files, query, files_or_err)
	if not filtered_ok then
		vim.notify(string.format("findfunc: failed to filter files, error: %s", filtered_or_err), vim.log.levels.ERROR)
		return {}
	end
	return filtered_or_err
end

vim.opt.findfunc = "v:lua.user_findfunc"
