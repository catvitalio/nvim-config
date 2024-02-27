local function config()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

  local lspconfig = require('lspconfig')
  lspconfig.jedi_language_server.setup({ capabilities = capabilities })
  lspconfig.pyright.setup({ capabilities = capabilities })
end

return {
  {
    'neovim/nvim-lspconfig',
    config = config,
  },
}
