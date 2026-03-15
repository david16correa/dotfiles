return {
  -- Highlight, edit, and navigate code
  "nvim-treesitter/nvim-treesitter",
  -- dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
  build = ":TSUpdate",
  main = "nvim-treesitter.configs", -- Sets main module to use for opts
  -- event = { "BufReadPost", "BufNewFile" }, -- Load only on opening files
  -- lazy = true,
  opts = {
    ensure_installed = {
      "c",
      "lua",
      "python",
    },
    auto_install = false,
    highlight = {
      enable = true,
      disable = {"latex","cpp","c"},
      additional_vim_regex_highlighting = false,
    },
    indent = { enable = true, disable = { "ruby" } },
  },
}
