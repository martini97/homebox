local amake = {}
local logger = require("vlog"):new({ name = "amake" })

---@type table<integer, vim.SystemObj>
local procs = {}

---@alias amake.ListType "quickfix" | "loclist"

---@class amake.List
---@field type amake.ListType
---@field id number
---@field winnr number
---@field title string
---@field errorfmt string
---@field _posted boolean

---@class amake.MakeOpts
---@field winnr number
---@field bufnr number
---@field bufname string
---@field makeprg string
---@field errorfmt string
---@field list amake.ListType

---@param opts amake.MakeOpts
---@return amake.List
local list_create = function(opts)
	---@type amake.List
	local list = {
		winnr = opts.winnr,
		type = opts.list,
		title = opts.makeprg,
		errorfmt = opts.errorfmt,
		id = 0,
		_posted = false,
	}

	if opts.list == "quickfix" then
		vim.fn.setqflist({}, " ", { title = list.title, lines = {}, efm = list.errorfmt, id = list.id })
		list.id = vim.fn.getqflist({ id = 0 }).id
	elseif opts.list == "loclist" then
		vim.fn.setloclist(opts.winnr, {}, " ", { title = list.title, lines = {}, efm = list.errorfmt, id = list.id })
		list.id = vim.fn.getloclist(opts.winnr, { id = 0 }).id
	else
		logger:error("invalid list, will not create", { opts = opts, list, list })
	end

	logger:debug("created list", { opts = opts, list = list })
	return list
end

---@param list amake.List
---@param entries string[]
local list_publish = vim.schedule_wrap(function(list, entries)
	local action = "a"
	local what = { lines = entries, id = list.id, title = list.title, efm = list.errorfmt }
	if list.type == "quickfix" then
		vim.fn.setqflist({}, action, what)
	elseif list.type == "loclist" then
		vim.fn.setloclist(list.winnr, {}, action, what)
	else
		error("invalid list")
	end

	if #entries > 0 and not list._posted then
		vim.cmd.doautocmd("QuickFixCmdPost", list.type)
		list._posted = true
	end
end)

---@param opts amake.MakeOpts
local function kill_running_proc(opts)
	local proc = procs[opts.bufnr]
	if not proc then
		return
	end
	logger:debug("found old process still running", { opts = opts, proc = proc })
	local ok, err = pcall(function()
		proc:kill(1)
	end)
	logger:debug("killed old process", { opts = opts, ok = ok, err = err })
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

	kill_running_proc(opts)

	local buffered = nil
	local list = list_create(opts)

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
		local entries

		data = buffered ~= nil and buffered .. data or data
		entries = vim.split(data, "\n", { plain = true, trimempty = true })
		buffered = not vim.endswith(entries[#entries], "\n") and entries[#entries] or nil

		if buffered then
			entries = vim.list_slice(entries, 1, #entries - 1)
		end

		list_publish(list, entries)
	end

	---@param out vim.SystemCompleted
	local on_exit = function(out)
		procs[opts.bufnr] = nil
		logger:debug(
			"finished asynchronous make",
			{ opts = opts, exit_code = out.code, stdout = out.stdout, stderr = out.stderr }
		)

		if buffered then
			list_publish(list, vim.split(buffered, "\n", { plain = true, trimempty = true }))
		end
	end

	local command = { vim.o.shell, vim.o.shellcmdflag, vim.fn.expandcmd(opts.makeprg) }
	logger:debug("starting asynchronous makeprg", { opts = opts, command = command })
	procs[opts.bufnr] = vim.system(command, { text = true, stdout = on_data, stderr = on_data }, on_exit)
end

function amake.setup()
	install_user_commands()
end

amake._procs = procs

return amake
