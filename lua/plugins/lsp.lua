local function config()
  -- python
  vim.lsp.config('pyrefly', {
    settings = {
      python = {
        pyrefly = {
          displayTypeErrors = 'force-on',
          logLevel = 'warning',
        },
      },
    },
  })
  vim.lsp.enable('pyrefly')
  -- lua
  vim.lsp.enable('lua_ls')
  -- go
  vim.lsp.enable('gopls')
  -- rust
  vim.lsp.enable('rust_analyzer')
  -- ts / js
  vim.lsp.enable('tsserver')
  -- json
  vim.lsp.enable('jsonls')
  -- spell
  vim.lsp.enable('codebook')
  -- nix
  vim.lsp.enable('nixd')
end

return {
  'neovim/nvim-lspconfig',
  config = config,
}
