-- Autoformatter setup
-- lua: stylua
-- clang: clang-format (via clangd)
-- markdown: marksman
--
return {
  "stevearc/conform.nvim",
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>ff",
      function()
        require("conform").format({ async = true, lsp_format = "fallback" })
      end,
      mode = "",
      desc = "[F]ormat buffer",
    },
  },
  opts = {
    notify_on_error = false,
    -- Disable format on save globally
    format_on_save = false,
    formatters_by_ft = {
      lua = { "stylua" }, -- Use stylua without args
      c = { "clang-format" },
      cpp = { "clang-format" },
      markdown = { "prettier" },
    },
  },
}
