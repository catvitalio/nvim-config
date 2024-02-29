local function config()
  require('mason').setup()
  require('mason-tool-installer').setup({
    ensure_installed = {
      -- python tools
      'pyright',
      'jedi-language-server',
      'ruff',
      -- lua tools
      'lua-language-server',
      'luacheck',
      'stylua',
      -- spell
      'cspell',
    },
  })
end

return {
  {
    'williamboman/mason.nvim',
    dependencies = { 'WhoIsSethDaniel/mason-tool-installer.nvim' },
    config = config,
  },
}
