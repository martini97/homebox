local ls = require("luasnip")
local ls_extras = require("luasnip.extras")

local p = ls_extras.partial
local s = ls.snippet
local c = ls.choice_node

return {
	s({
		trig = [[\vtoday|date]],
		trigEngine = "vim",
	}, { c(1, {
		p(os.date, "%d/%m/%Y"),
		p(os.date, "%Y-%m-%d"),
	}) }),
}
