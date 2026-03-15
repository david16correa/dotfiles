return {
  {
    "echasnovski/mini.pick",
    version = false,
    config = function()
      local MiniPick = require("mini.pick")
      local devicons = require("nvim-web-devicons")

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

      local function all_files()
        MiniPick.start({
          source = {
            items = function()
              -- Use 'fd' or 'find' command to get all files (including ignored)
              local command = "fd --hidden --no-ignore --type f --follow --exclude .git || find . -type f"
              local handle = io.popen(command)
              local files = {}
              if handle then
                for file in handle:lines() do
                  table.insert(files, file)
                end
                handle:close()
              end
              return files
            end,
            -- This will show icons if nvim-web-devicons is installed
            name = "All files (including ignored)",
            cwd = vim.fn.getcwd(),
          },
        })
      end

      -- Keymap to trigger the picker
      vim.keymap.set("n", "<leader>fa", all_files, { desc = "Find all files (including ignored)" })

      vim.keymap.set("n", "<leader>sw", function()
        require("mini.pick").builtin.grep_live(nil, {
          source = {
            name = "Live Grep (cwd)",
            cwd = vim.fn.getcwd(),
          },
        })
      end, { desc = "Live grep in current working directory" })
    end,

    -- does not work properly
    vim.keymap.set("n", "<leader>ww", function()
      -- Prompt user for a filetype or pattern
      local ext = vim.fn.input("Filetype or glob (e.g. lua, *.c): ")

      -- If the input doesn't start with "*", assume it's just an extension
      if not ext:match("^%*") then
        ext = "*." .. ext
      end

      MiniPick.builtin.grep_live(nil, {
        source = {
          name = "Live Grep: " .. ext,
          cwd = vim.fn.getcwd(),
          args = { "-g", ext },
        },
      })
    end, { desc = "Live grep by prompted filetype" }),
  },
}
