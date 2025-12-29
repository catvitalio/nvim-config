local function config()
  -- python
  local utils = require('utils')

  vim.lsp.config('pyrefly', {
    settings = {
      python = {
        pyrefly = {
          displayTypeErrors = 'force-on',
          logLevel = 'warning',
          extraPaths = utils.get_json_env('PYREFLY_EXTRA_PATHS', { '.' }),
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
