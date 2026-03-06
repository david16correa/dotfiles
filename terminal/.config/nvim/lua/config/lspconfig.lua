require("lspconfig").julials.setup({
  on_new_config = function(new_config, _)
    local julia = vim.fn.expand("~/.julia/environments/nvim-lspconfig/bin/julia")
    if require("lspconfig").util.path.is_file(julia) then
      vim.notify("Hello!")
      new_config.cmd[1] = julia
    end
  end,
})
