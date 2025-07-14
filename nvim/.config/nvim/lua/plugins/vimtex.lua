return {
    -- basic setup for latex
    "lervag/vimtex",
    ft = "tex",
    lazy = false, -- we don't want to lazy load VimTeX
    -- tag = "v2.15", -- uncomment to pin to a specific release
    init = function()
      -- VimTeX configuration goes here, e.g.
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_compiler_method = "latexmk"

      vim.keymap.set("n", "<leader>ll", ":VimtexCompile<CR>", { desc = "vimtex-compile" })
      vim.keymap.set("n", "<leader>lc", ":VimtexCompile<CR>", { desc = "vimtex-clean-aux" })
    end,
  }
