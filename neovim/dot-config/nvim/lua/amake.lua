local amake = {}

local logger = require("vlog"):new({ name = "amake" })

---@alias amake.List "quickfix" | "loclist"

---@class amake.MakeOpts
---@field winnr number
---@field bufnr number
---@field bufname string
---@field makeprg string
---@field errorfmt string
---@field list amake.List

---Publishes entries to target list
---@param opts amake.MakeOpts
---@param entries string[]
local function publish(opts, entries)
	if opts.list == "quickfix" then
		vim.fn.setqflist({}, " ", { title = opts.makeprg, lines = entries, efm = opts.errorfmt })
	elseif opts.list == "loclist" then
		vim.fn.setloclist(opts.winnr, {}, " ", { title = opts.makeprg, lines = entries, efm = opts.errorfmt })
	else
		logger:error("invalid list, will not publish", opts)
		return
	end

	vim.cmd.doautocmd("QuickFixCmdPost", opts.list)
end

---Setup logger level based on g:amake_loglevel
local function setup_logger()
	local loglevel = vim.g.amake_loglevel or vim.log.levels.WARN
	logger:set_level(loglevel)
end

---Install user commands
local function install_user_commands()
	vim.api.nvim_create_user_command("Amake", function()
		amake.make()
	end, { desc = "[amake] run make asynchronously", nargs = "*" })

	vim.api.nvim_create_user_command("Almake", function()
		amake.make({ list = "loclist" })
	end, { desc = "[amake] run lmake asynchronously", nargs = "*" })

	vim.api.nvim_create_user_command("AmakeLogs", function(opts)
		vim.cmd.new({ logger.outfile, mods = opts.smods })
	end, { desc = "[amake] open log file", nargs = "*" })
end

---@param opts? amake.MakeOpts
function amake.make(opts)
	opts = opts or {}
	opts.bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
	opts.bufname = opts.bufname or vim.api.nvim_buf_get_name(opts.bufnr)
	opts.makeprg = vim.fn.expandcmd(opts.makeprg or vim.api.nvim_get_option_value("makeprg", { buf = opts.bufnr }))
	opts.errorfmt = opts.errorfmt or vim.api.nvim_get_option_value("errorformat", { buf = opts.bufnr })
	opts.list = opts.list or "quickfix"

	setup_logger()

	if not opts.makeprg or opts.makeprg == "" then
		logger:warn("makeprg not set, skipping", opts)
		return
	end

	local entries = {}
	local buffered = nil

	---@param err string?
	---@param data string?
	local on_data = function(err, data)
		if err and err ~= "" then
			logger:error("received error on data event", { err = err, data = data, opts = opts })
		end
		if not data or data == "" then
			return
		end
		---@type string[]
		local lines

		data = buffered ~= nil and buffered .. data or data
		lines = vim.split(data, "\n", { plain = true, trimempty = true })
		buffered = not vim.endswith(lines[#lines], "\n") and lines[#lines] or nil

		if buffered then
			lines = vim.list_slice(lines, 1, #lines - 1)
		end

		vim.list_extend(entries, lines)
	end

	---@param out vim.SystemCompleted
	local on_exit = function(out)
		logger:debug(
			"finished asynchronous make",
			{ opts = opts, exit_code = out.code, stdout = out.stdout, stderr = out.stderr }
		)

		if buffered then
			table.insert(entries, buffered)
		end

		vim.schedule_wrap(publish)(opts, entries)
	end

	local command = { vim.o.shell, vim.o.shellcmdflag, vim.fn.expandcmd(opts.makeprg) }
	logger:debug("starting asynchronous makeprg", { opts = opts, command = command })
	vim.system(command, { text = true, stdout = on_data, stderr = on_data }, on_exit)
end

function amake.setup()
	install_user_commands()
end

return amake
