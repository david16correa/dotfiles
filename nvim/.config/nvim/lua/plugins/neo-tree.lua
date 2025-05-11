-- aniadi esto para mostrar mis playgrounds, que son documentos ignorados por git
return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      filtered_items = {
        visible = false,
        hide_dotfiles = true,
        hide_gitignored = false,
      },
    },
  },
}
