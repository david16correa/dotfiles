return {
  -- greeter
  {
    "echasnovski/mini.starter",
    version = false,
    config = function()
      local api = require("mini.starter")
      api.setup({
        header = table.concat({
          [[██╗     ███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗]],
          [[██║     ██╔════╝██╔═══██╗██║   ██║██║████╗ ████║]],
          [[██║     █████╗  ██║   ██║██║   ██║██║██╔████╔██║]],
          [[██║     ██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║]],
          [[███████╗███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║]],
          [[╚══════╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
        }, "\n"),
        items = {
          api.sections.builtin_actions(),
        },
      })
    end,
  },
  -- top buffers in a tabline
  {
    "echasnovski/mini.tabline",
    version = false,
    dependencies = { "echasnovski/mini.icons" }, -- For filetype icons
    config = function()
      require("mini.tabline").setup({
        -- Tab presentation
        tabpage_section = "left", -- Show tabpages on the left (or "none", "right")
        show_icons = true, -- Show filetype icons (requires mini.icons)
        tab_first = true, -- Show current tab first (better for many tabs)

        -- Customize tab names
        name_formatter = function(buf_id, opts)
          local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf_id), ":t") -- Basename only
          if name == "" then
            return "[No Name]"
          end
          return name
        end,

        -- Highlighting
        tab_highlight = "TabLineSel", -- Current tab highlight group
        win_highlight = "TabLine", -- Other tabs highlight group

        -- Behavior
        truncate = true, -- Truncate long names
        truncate_len = 20, -- Max tab name length before truncation
      })
    end,
  },
  -- statusline
  {
    "echasnovski/mini.statusline",
    version = false,
    config = function()
      local statusline = require("mini.statusline")

      statusline.setup({
        content = {
          active = function()
            local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
            local git = statusline.section_git({ trunc_width = 40 })
            local filename = statusline.section_filename({ trunc_width = 140 })
            local location = string.format("%d | %d", unpack(vim.api.nvim_win_get_cursor(0)))
            local time = vim.fn.strftime("%H:%M")

            -- Custom simplified fileinfo
            local fileinfo = function()
              local ft = vim.bo.filetype ~= "" and vim.bo.filetype or "no ft"
              local enc = (vim.bo.fileencoding ~= "" and vim.bo.fileencoding ~= "utf-8")
                  and string.format("[%s]", vim.bo.fileencoding)
                or ""
              return string.format("%s%s", ft, enc)
            end

            return statusline.combine_groups({
              { hl = mode_hl, strings = { mode } },
              { hl = "MiniStatuslineDevinfo", strings = { git } },
              "%<",
              { hl = "MiniStatuslineFilename", strings = { filename } },
              "%=",
              { hl = "MiniStatuslineFileinfo", strings = { fileinfo() } }, -- Use our custom version
              { hl = "MiniStatuslineLocation", strings = { location } },
              { hl = mode_hl, strings = { time } },
            })
          end,
          inactive = nil,
        },
        use_icons = false, -- Disable icons for simpler output
        set_vim_settings = true,
      })
    end,
  },
}
