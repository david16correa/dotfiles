local luasnip = require("luasnip")
local s = luasnip.snippet
local t = luasnip.text_node
local i = luasnip.insert_node
local extras = require("luasnip.extras")
local rep = extras.rep
local fmt = require("luasnip.extras.fmt").fmt

return {
	-- ============================================
	-- simple text abbreviations
	-- ============================================
	s(";a", { t("\\alpha") }),
	s(";b", { t("\\beta") }),
	s(";g", { t("\\gamma") }),
	s(";d", { t("\\delta") }),
	s(";D", { t("\\Delta") }),
	s(";p", { t("\\psi") }),
	s(";P", { t("\\Psi") }),
	s(";s", { t("\\sigma") }),
	s(";l", { t("\\lambda") }),
	s(";m", { t("\\mu") }),
	s(";n", { t("\\nu") }),
	s(";e", { t("\\epsilon") }),
	s(";th", { t("\\theta") }),
	s(";pi", { t("\\pi") }),
	s(";inf", { t("\\infty") }),
	-- placeholder text for cites
	s("needcite", { t("\\textbf{[CITE]}") }),

	-- ============================================
	-- more involved wrappers, and inserts
	-- ============================================

	-- inline math mode
	s("mm", fmt(
			"$<>$",
			{ i(0) },
			{ delimiters = "<>" }
		)
	),
	-- math text
	s("tm", fmt(
			"\\mathrm{<>}",
			{ i(1) },
			{ delimiters = "<>" }
		)
	),
	-- fraction
	s("ff", fmt(
			"\\frac{<>}{<>}",
			{ i(1), i(2) },
			{ delimiters = "<>" }
		)
	),
	-- sqrt
	s("sqrt", fmt(
			"\\sqrt{<>}",
			{ i(1) },
			{ delimiters = "<>" }
		)
	),
	-- upperscript
	s("uu", fmt(
			"^{<>}",
			{ i(1) },
			{ delimiters = "<>" }
		)
	),
	-- subscript
	s("ss", fmt(
			"_{<>}",
			{ i(1) },
			{ delimiters = "<>" }
		)
	),
	-- integral
	s("int", fmt(
			"\\int_{<>}^{<>} <> \\textrm{d}<>",
			{ i(1), i(2), i(0), i(3) },
			{ delimiters = "<>" }
		)
	),
	-- sum
	s("sum", fmt(
			"\\sum_{<>}^{<>} <>",
			{ i(1), i(2), i(0) },
			{ delimiters = "<>" }
		)
	),
	-- generic environment
	s("env", fmt(
		[[
			\begin{<>}
				<>
			\end{<>}
		]],
		{ i(1), i(0), rep(1) },
		{ delimiters = "<>" }
		)
	),
	-- placeholder text for figures
	s("needfig", {
		t({ "\\vspace{1em} INCLUDE FIGURE OF" }),
		i(0),
		t({ "\\vspace{1em}" }),
	}),
}
