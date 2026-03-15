return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    require("nvim-tree").setup({
      view = {
        width = 35,
        side = "left",
      },
      renderer = {
        icons = {
          glyphs = {
            folder = {
              arrow_closed = "▶",
              arrow_open = "▼",
            },
          },
        },
        -- Highlight Git icons
        highlight_git = true,
        -- Show Git icons next to file names
        indent_markers = {
          enable = true,
        },
      },
      filters = {
        dotfiles = false,
      },
      -- Git integration
      git = {
        enable = true,       -- Enable Git integration
        ignore = false,      -- Show ignored files (default: false)
        timeout = 500,       -- Timeout for Git commands (ms)
        show_on_dirs = true, -- Show Git status on directories
        show_on_open_dirs = true,
      },
      actions = {
        open_file = {
          quit_on_open = true,
        },
      },
    })

    vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { silent = true })
  end,
}
