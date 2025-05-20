-- load modules
require("core.options") -- ./core/options.lua
require("core.keymaps") -- ./core/keypams.lua
require("core.autocmds") -- ./core/autocmds.lua

-- install lazy plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    error("Error cloning lazy.nvim:\n" .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

local plugins = {

  require("plugins.ui.basic-ui"),
  require("plugins.ui.mini-ui"),

  require("plugins.files.nvim-tree"),
  require("plugins.files.picker"),

  require("plugins.coding.lsp"),
  require("plugins.coding.autocompletion"),
  require("plugins.coding.autoformatting"),
  require("plugins.coding.mini-nvim"),
  require("plugins.coding.treesitter"),

  require("plugins.markdown"),
  require("plugins.misc"),
}

require("lazy").setup(plugins)
