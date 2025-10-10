local function config()
  -- python
  vim.lsp.enable('basedpyright')
  vim.lsp.config('basedpyright', {
    settings = {
      basedpyright = {
        analysis = {
          typeCheckingMode = 'standard',
          autoSearchPaths = true,
          autoImportCompletions = true,
          useLibraryCodeForTypes = true,
          diagnosticSeverityOverrides = {
            reportPrivateLocalImportUsage = 'none',
          },
        },
      },
    },
  })
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
