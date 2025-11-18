local function config()
  -- python
  vim.lsp.config('zuban', {
    on_attach = function(client, bufnr)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
      client.server_capabilities.renameProvider = false
      client.server_capabilities.codeActionProvider = false
      client.server_capabilities.completionProvider = nil
      client.server_capabilities.hoverProvider = false
      client.server_capabilities.signatureHelpProvider = nil
      client.server_capabilities.definitionProvider = false
      client.server_capabilities.declarationProvider = false
      client.server_capabilities.implementationProvider = false
      client.server_capabilities.referencesProvider = false
      client.server_capabilities.documentSymbolProvider = false
      client.server_capabilities.workspaceSymbolProvider = false
    end,
  })
  vim.lsp.enable('zuban')
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
