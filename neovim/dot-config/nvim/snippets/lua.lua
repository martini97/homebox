local ls = require("luasnip")
local extras = require("luasnip.extras")
local fmt = require("luasnip.extras.fmt").fmt
local postfix = require("luasnip.extras.postfix").postfix

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local dl = extras.dynamic_lambda

return {
	s(
		"req",
		fmt([[local {} = require("{}")]], {
			dl(2, l._1:match("%.([%w_]+)$"), { 1 }),
			i(1),
		})
	),
	s(
		{ trig = "pd", name = "print debug" },
		fmt([[vim.print([=[>>> {filename}:{line_number}:{var_repeated}:::]=], vim.inspect({var}))]], {
			filename = p(vim.fn.expand, "%:.:r"),
			line_number = l(l.TM_LINE_NUMBER),
			var = i(1),
			var_repeated = rep(1),
		})
	),
	postfix(".pp", {
		f(function(_, parent)
			local fname = vim.fn.expand("%:.:r")
			local lnum = parent.env.TM_LINE_NUMBER
			return string.format(
				[[vim.print([=[>>> %s:%s:%s:::]=], vim.inspect(%s))]],
				fname,
				lnum,
				parent.env.POSTFIX_MATCH,
				parent.env.POSTFIX_MATCH
			)
		end),
	}),
	s(
		"fn",
		{ t("function "), i(1, "name"), t("("), i(2, "args"), t({ ")", "" }), i(3, "-- content"), t({ "", "end" }) }
	),
}
