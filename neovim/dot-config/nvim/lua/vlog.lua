---@alias vlog.Level 0 | 1 | 2 | 3 | 4 | 5

---@class vlog.LevelConfig
---@field hl? string
---@field label string

---@class vlog.Config
---@field plugin string
---@field use_console boolean
---@field use_file boolean
---@field highlights boolean
---@field level vlog.Level
---@field float_precision number
---@field levels table<vlog.Level, vlog.LevelConfig>

---@class vlog.Logger
---@field config vlog.Config
---@field outfile string

---@type vlog.Config
local default_config = {
	plugin = "vlog",
	use_console = true,
	highlights = true,
	use_file = true,
	level = vim.log.levels.OFF,
	float_precision = 0.01,
	levels = {
		[vim.log.levels.TRACE] = { hl = "Comment", label = "TRACE" },
		[vim.log.levels.DEBUG] = { hl = "Comment", label = "DEBUG" },
		[vim.log.levels.INFO] = { hl = "None", label = "INFO" },
		[vim.log.levels.WARN] = { hl = "WarningMsg", label = "WARN" },
		[vim.log.levels.ERROR] = { hl = "ErrorMsg", label = "ERROR" },
		[vim.log.levels.OFF] = { hl = "None", label = "OFF" },
	},
}

---@class vlog.Logger
local Logger = {}
Logger.__index = Logger

---@param config? vlog.Config
---@return vlog.Logger
function Logger.new(config)
	local self = {}
	setmetatable(self, Logger)

	self.config = vim.tbl_deep_extend("force", default_config, config or {})
	self.outfile = vim.fs.joinpath(vim.fn.stdpath("data") --[[@as string]], self.config.plugin .. ".log")

	return self
end

---Get log level from env var
---@param envvar string?
---@return vlog.Level
function Logger.get_level_from_env(envvar)
	envvar = envvar or "LOGLEVEL"
	local val = string.upper(vim.env[envvar] or "INFO")
	local lvl = vim.log.levels[val]
	return lvl or vim.log.levels.INFO
end

---Round x according to float precision
---@private
---@param x number
---@return number
function Logger:_round(x)
	local precision = self.config.float_precision or 1
	if precision == 1 then
		return x
	end
	x = x / precision
	return (x > 0 and math.floor(x + 0.5) or math.ceil(x - 0.5)) * precision
end

---@private
function Logger:_make_string(...)
	local args = { ... }
	return vim.iter(args)
		:map(function(x)
			if type(x) == "number" then
				x = tostring(self:_round(x))
			elseif type(x) == "table" then
				x = vim.inspect(x)
			else
				x = tostring(x)
			end
			return x
		end)
		:join(" ")
end

---@private
---@param level vlog.Level
---@param message string
function Logger:_output_to_console(level, message)
	if not self.config.use_console then
		return
	end

	if level < self.config.level then
		return
	end

	local level_cfg = self.config.levels[level]
	local log_str = string.format("[%-6s%s]: %s", level_cfg.label, os.date("%H:%M:%S"), message)
	local chunks = vim.iter(vim.split(log_str, "\n"))
		:map(function(line)
			local text = string.format("[%s] %s\n", self.config.plugin, line)
			return { text, level_cfg.hl }
		end)
		:totable()
	vim.api.nvim_echo(chunks, true, {})
end

---@private
---@param level vlog.Level
---@param message string
function Logger:_output_to_file(level, message)
	if not self.config.use_file then
		return
	end

	local level_cfg = self.config.levels[level]
	local fp = io.open(self.outfile, "a")
	local log_str = string.format("[%-6s%s]: %s\n", level_cfg.label, os.date(), message)
	if not fp then
		return
	end
	fp:write(log_str)
	fp:close()
end

---@param level vlog.Level
---@param ... unknown
function Logger:log_at_level(level, ...)
	local message = self:_make_string(...)

	self:_output_to_console(level, message)
	self:_output_to_file(level, message)
end

---@param ... unknown
function Logger:trace(...)
	self:log_at_level(vim.log.levels.TRACE, ...)
end

---@param ... unknown
function Logger:debug(...)
	self:log_at_level(vim.log.levels.DEBUG, ...)
end

---@param ... unknown
function Logger:info(...)
	self:log_at_level(vim.log.levels.INFO, ...)
end

---@param ... unknown
function Logger:warn(...)
	self:log_at_level(vim.log.levels.WARN, ...)
end

---@param ... unknown
function Logger:error(...)
	self:log_at_level(vim.log.levels.ERROR, ...)
end

return Logger
