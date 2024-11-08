---Lua wrapper around fzf plugin
---Global variables:
---  vim.g.fzf_select_tmux: string -> tmux options, if present fzf will launch in a tmux popup.
---  vim.g.fzf_select_window: dict -> popup window settings, if present fzf will launch in a floating window.
---  vim.g.fzf_select_options: string[] -> extra options for fzf.
---@see https://github.com/junegunn/fzf/blob/master/README-VIM.md

local fzf = {}
local _old_ui_select = nil

---Converts an item in an enumerated item
---@param idx integer
---@param item string
local function enumerate_item(idx, item)
	return string.format("%d. %s", idx, item)
end

---Parses enumerated item into its value and index
---@generic T
---@param item string
---@param items T[]
---@return T?
---@return integer?
local function parse_item(item, items)
	local _, _, idx_str = string.find(item, "^(%d+)%. .*")
	local idx = tonumber(idx_str)
	local value = items[idx]
	return value, idx
end

---Prompts the user to pick from a list of items asynchronously.
---@generic T
---@param items T[]
---@param opts { format_item?: fun(item: T): string; prompt?: string; kind?: string }
---@param on_choice fun(item?: T, idx?: number)
function fzf.select(items, opts, on_choice)
	opts = opts or {}
	opts.format_item = opts.format_item or tostring
	opts.prompt = string.gsub(opts.prompt or "Select one of:", ":%s?$", "> ")
	opts.kind = opts.kind or nil

	return coroutine.wrap(function()
		local co = assert(coroutine.running(), "fzf.select must be called within a coroutine")
		local source = vim.iter(items):map(opts.format_item):enumerate():map(enumerate_item):totable()
		local options = { "--no-multi", "--preview-window", "hidden:right:0", "--prompt", opts.prompt }
		local sink = function(item)
			coroutine.resume(co, on_choice(parse_item(item, items)))
		end

		vim.fn["fzf#run"]({
			source = source,
			sink = sink,
			options = vim.list_extend(options, vim.g.fzf_select_options or {}),
			tmux = vim.g.fzf_select_tmux,
			window = vim.g.fzf_select_window,
		})

		return coroutine.yield()
	end)()
end

---Replaces `vim.ui.select` with `core.fzf.select`
function fzf.register()
	if vim.fn.exists("*fzf#run") ~= 1 then
		vim.notify("[fzf] fzf#run not found, will not register", vim.log.levels.WARN)
		return
	end
	if not _old_ui_select then
		_old_ui_select = vim.ui.select
	end
	vim.ui.select = fzf.select
end

---Restore `vim.ui.select` to it's old value
function fzf.unregister()
	if not _old_ui_select then
		error("not registered")
		return
	end
	vim.ui.select = _old_ui_select
end

return fzf
