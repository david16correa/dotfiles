return {
  {
    "echasnovski/mini.pick",
    version = false,
    config = function()
      local MiniPick = require("mini.pick")

      vim.ui.select = MiniPick.ui_select
      MiniPick.setup({
        mappings = {
          caret_left = "<Left>",
          caret_right = "<Right>",

          choose = "<CR>",
          choose_in_split = "<C-s>",
          choose_in_tabpage = "<C-t>",
          choose_in_vsplit = "<C-v>",
          choose_marked = "<M-CR>",

          delete_char = "<BS>",
          delete_char_right = "<Del>",
          delete_left = "<C-u>",
          delete_word = "<C-w>",

          mark = "<C-x>",
          mark_all = "<C-a>",

          move_down = "<C-j>",
          move_start = "<C-g>",
          move_up = "<C-k>",

          paste = "<C-r>",

          refine = "<C-Space>",
          refine_marked = "<M-Space>",

          scroll_down = "<C-f>",
          scroll_left = "<C-h>",
          scroll_right = "<C-l>",
          scroll_up = "<C-b>",

          stop = "<Esc>",

          toggle_info = "<S-Tab>",
          toggle_preview = "<Tab>",
        },
        options = {
          -- Whether to show content from bottom to top
          content_from_bottom = true,

          -- Whether to cache matches (more speed and memory on repeated prompts)
          use_cache = false,
        },

        window = {
          config = function()
            local height = math.floor(0.618 * vim.o.lines)
            local width = math.floor(0.618 * vim.o.columns)
            return {
              anchor = "NW",
              height = height,
              width = width,
              row = math.floor(0.5 * (vim.o.lines - height)),
              col = math.floor(0.5 * (vim.o.columns - width)),
            }
          end,

          prompt_caret = "▏",
          prompt_prefix = " ",
        },
      })

      -- Keymaps for files
      vim.keymap.set("n", "<leader>sf", ":Pick files<CR>", { desc = "[S]earch [F]iles", noremap = true, silent = true }) -- focus file explorer

      vim.keymap.set("n", "<leader>sa", function()
        local handle = io.popen("fd --type f -H -I") -- List all files, including hidden and ignored ones
        if handle then
          local result = handle:read("*a")
          handle:close()
          local items = vim.split(result, "\n", { trimempty = true })
          MiniPick.start({ source = { items = items } })
        end
      end, { desc = "[S]earch [A]ll files (including ignored)", noremap = true, silent = true })

    end,
  },
}
