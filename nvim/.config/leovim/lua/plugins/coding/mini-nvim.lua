return {
  -- used for extra pickers that work well with lsp and git
  {
    "echasnovski/mini.extra",
    version = false,
    config = function()
      local api = require("mini.extra")
      api.setup()
    end,
  },
  -- open and close parenthesis
  {
    "echasnovski/mini.pairs",
    version = false,
    config = function()
      local minipairs = require("mini.pairs")
      minipairs.setup({})
    end,
  },
  -- surround actions
  {
    "echasnovski/mini.surround",
    version = false,
    config = function()
      require("mini.surround").setup({
        custom_surroundings = {
          -- Override default brackets to remove spaces
          ["("] = { output = { left = "(", right = ")" } },
          ["["] = { output = { left = "[", right = "]" } },
          ["{"] = { output = { left = "{", right = "}" } },
          ["<"] = { output = { left = "<", right = ">" } },
          -- Override quotes
          ['"'] = { output = { left = '"', right = '"' } },
          ["'"] = { output = { left = "'", right = "'" } },
          ["`"] = { output = { left = "`", right = "`" } },
        },
      })
    end,
  },
  -- substitutes to which key
  {
    "echasnovski/mini.clue",
    version = false,
    config = function()
      local miniclue = require("mini.clue")
      miniclue.setup({
        delay = 250,
        triggers = {
          -- Leader triggers
          { mode = "n", keys = "<leader>" },
          { mode = "x", keys = "<leader>" },

          -- Built-in completion
          { mode = "i", keys = "<C-x>" },

          -- `g` key
          { mode = "n", keys = "g" },
          { mode = "x", keys = "g" },

          -- Marks
          { mode = "n", keys = "'" },
          { mode = "n", keys = "`" },
          { mode = "x", keys = "'" },
          { mode = "x", keys = "`" },

          -- Registers
          { mode = "n", keys = '"' },
          { mode = "x", keys = '"' },
          { mode = "i", keys = "<C-r>" },
          { mode = "c", keys = "<C-r>" },

          -- Window commands
          { mode = "n", keys = "<C-w>" },

          -- `z` key
          { mode = "n", keys = "z" },
          { mode = "x", keys = "z" },
        },

        clues = {
          -- Enhance this by adding descriptions for <Leader> mapping groups
          miniclue.gen_clues.builtin_completion(),
          miniclue.gen_clues.g(),
          miniclue.gen_clues.marks(),
          miniclue.gen_clues.registers(),
          miniclue.gen_clues.windows(),
          miniclue.gen_clues.z(),
        },
      })
    end,
  },
}
