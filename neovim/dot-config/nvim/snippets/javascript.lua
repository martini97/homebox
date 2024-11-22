local ls = require("luasnip")
local extras = require("luasnip.extras")
local fmt = require("luasnip.extras.fmt").fmt
local postfix = require("luasnip.extras.postfix").postfix

local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local l = extras.lambda
local rep = extras.rep

return {
	s({ trig = "imp", name = "import" }, {
		c(1, {
			sn(nil, { t("import "), i(2, "what"), t(" from '"), i(1), t("';") }),
			sn(nil, { t("import * as "), i(2, "what"), t(" from '"), i(1), t("';") }),
			sn(nil, { i(1), t("import { "), i(2, "what"), t(" } from '"), i(1), t("';") }),
		}),
	}),
	s(
		{ trig = "pd", name = "print print" },
		fmt([[console.debug(">>> {filename}:{line_number}:{var_repeated}:::", {var});]], {
			filename = extras.partial(vim.fn.expand, "%:.:r"),
			line_number = l(l.TM_LINE_NUMBER),
			var = i(1),
			var_repeated = rep(1),
		})
	),
	postfix(".pd", {
		f(function(_, parent)
			local fname = vim.fn.expand("%:.:r")
			local lnum = parent.env.TM_LINE_NUMBER
			return string.format(
				[[console.debug(">>> %s:%s:%s:::", %s)]],
				fname,
				lnum,
				parent.env.POSTFIX_MATCH,
				parent.env.POSTFIX_MATCH
			)
		end),
	}),
	s(
		{ trig = "sleep", name = "sleep" },
		fmt([[await new Promise((r) => setTimeout(r, {ms}));]], {
			ms = i(1, "ms"),
		})
	),
	s({ trig = "inj", name = "injectable", description = "Injectable" }, {
		i(3, [[import { Injectable } from "@nestjs/common";]]),
		t({
			"",
			"",
			[[@Injectable()]],
			[[export class ]],
		}),
		i(1, "ClsName"),
		t({ " {", "\tconstructor(", "\t\t" }),
		i(2, "provider"),
		t({ "", "\t) {}", "}" }),
	}),
}
