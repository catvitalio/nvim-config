local function config()
  -- python
  vim.lsp.enable('ty')
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
  event = { 'BufReadPre', 'BufNewFile', 'VimEnter' },
  keys = {
    {
      '<A-.>',
      function()
        vim.lsp.buf.code_action()
      end,
      desc = 'LSP Code Action',
    },
  },
  config = config,
}
