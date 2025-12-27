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
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      enable = true,
      max_lines = 3,
      min_window_height = 20,
      line_numbers = true,
      multiline_threshold = 1,
      trim_scope = 'outer',
      mode = 'cursor',
      separator = nil,
      zindex = 20,
    },
    config = function(_, opts)
      require('treesitter-context').setup(opts)
    end,
  },
}
