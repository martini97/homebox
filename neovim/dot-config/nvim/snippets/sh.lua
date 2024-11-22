local ls = require("luasnip")

local s = ls.snippet
local t = ls.text_node

return {
	s("shebang", t({ "#!/usr/bin/env bash", "" })),
	s("set", t({ "set -o errexit", "set -o nounset", "set -o pipefail", "" })),
	s("awkuniq", t({ [[awk '!a[$0]++']] })),
}
