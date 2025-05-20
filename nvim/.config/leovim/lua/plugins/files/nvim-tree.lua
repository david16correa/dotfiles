return {
  "nvim-tree/nvim-tree.lua",
  version = "*", -- Use the latest version
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- Optional, for file icons
  config = function()
    -- Disable netrw (native file explorer) to avoid conflicts
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    require("nvim-tree").setup({
      -- Basic options
      view = {
        width = 35, -- Width of the tree (columns)
        side = "left", -- Position: "left" or "right"
      },
      -- File/folder icons
      renderer = {
        icons = {
          glyphs = {
            folder = {
              arrow_closed = "▶", -- Closed folder arrow
              arrow_open = "▼", -- Open folder arrow
            },
          },
        },
      },
      -- File ignoring
      filters = {
        dotfiles = false, -- Show hidden files (true to hide)
      },
      -- Key mappings
      actions = {
        open_file = {
          quit_on_open = true, -- Close tree when opening a file
        },
      },
    })

    -- Key mapping to toggle nvim-tree
    vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { silent = true })
  end,
}
