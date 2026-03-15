local luasnip = require("luasnip")
local s = luasnip.snippet
local t = luasnip.text_node
local i = luasnip.insert_node
local extras = require("luasnip.extras")
local rep = extras.rep
local fmt = require("luasnip.extras.fmt").fmt


return {
	s("include", fmt(
			"#include <{}>",
			{ i(0) },
			{ delimiters = "{}" }
		)
	),
	s("main", fmt(
			[[
				int main() {
					<>
					return 0;
				}
			]],
			{ i(0) },
			{ delimiters = "<>" }
		)
	),

	s("readfile", fmt(
			[[
				FILE *hand;
				hand = fopen("<>","r");
				char line[<>];
				while (fgets(line, <>,hand) != NULL) {
					printf("%s",line);
					<>
				}
			]],
			{ i(1),i(2),rep(2),i(0) },
			{ delimiters = "<>" }
		)
	),
}
