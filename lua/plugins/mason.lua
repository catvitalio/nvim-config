return {
  'williamboman/mason.nvim',
  config = function()
    require('mason').setup({})
    require('mason-tool-installer').setup({
      ensure_installed = {
        'stylua',
        'prettier',
        'zuban',
        'basedpyright',
        'ruff',
        'codebook',
        'pyrefly',
      },
      auto_update = true,
      run_on_start = true,
    })
  end,
  dependencies = {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    'williamboman/mason-lspconfig.nvim',
    'williamboman/mason-null-ls.nvim',
    'jay-babu/mason-nvim-dap.nvim',
  },
}
