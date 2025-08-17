-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.slime_target = "tmux"
vim.g.slime_default_config = {
  socket_name = "default",
  target_pane = ":.2",
}
vim.g.slime_dont_ask_default = true

vim.cmd("let g:latex_to_unicode_tab = 'off'")
vim.cmd("let g:latex_to_unicode_auto = 1")

vim.g.snacks_animate = false
vim.opt.conceallevel = 0 -- keep \alpha as \alpha instead of α
vim.g.autoformat = false

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "tex" },
  callback = function()
    -- spell check is enabled
    vim.opt_local.spell = true
    vim.opt.spelllang = { "myEn", "miEs" }
    -- lines are wrapped
    vim.opt_local.wrap = true
    -- no autocomplete; it becomes too slow for large documents, like my thesis project
    vim.b.completion = false
  end,
})
