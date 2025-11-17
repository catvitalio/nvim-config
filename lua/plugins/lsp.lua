local function config()
  -- python
  vim.lsp.enable('pyrefly')
  -- lua
  vim.lsp.config('lua_ls', {})
  -- spell
  vim.lsp.enable('codebook')
  -- nix
  vim.lsp.enable('nixd')
end

return {
  'neovim/nvim-lspconfig',
  config = config,
}
