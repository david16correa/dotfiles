return {
  -- add gruvbox
  {
    "loctvl842/monokai-pro.nvim",
    opts = { filter = "octagon" }, -- classic | octagon | pro | machine | ristretto | spectrum
  },

  -- Configure LazyVim to load monokai
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "monokai-pro",
    },
  },
}
