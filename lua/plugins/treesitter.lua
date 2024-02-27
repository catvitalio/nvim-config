local function config()
  require('nvim-treesitter.configs').setup({
    ensure_installed = {
      'python',
      'lua',
      'rust',
      'c',
      'yaml',
      'dockerfile',
      'toml',
      'typescript',
      'javascript',
      'tsx',
    },
    sync_install = false,
    auto_install = true,
    highlight = {
      enable = true,
    },
  })
end

return {
  {
    'nvim-treesitter/nvim-treesitter',
    config = config,
  },
}
