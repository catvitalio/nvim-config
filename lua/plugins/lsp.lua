local function config()
  -- Configure code action UI
  local border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' }
  vim.lsp.handlers['textDocument/codeAction'] = vim.lsp.with(vim.lsp.handlers['textDocument/codeAction'], {
    border = border,
  })

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
