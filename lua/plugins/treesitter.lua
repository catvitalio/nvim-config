local languages = {
  'python',
  'lua',
  'rust',
  'c',
  'go',
  'gomod',
  'yaml',
  'dockerfile',
  'toml',
  'typescript',
  'javascript',
  'tsx',
  'nix',
}

local function config()
  require('nvim-treesitter').install(languages)

  vim.api.nvim_create_autocmd('FileType', {
    pattern = languages,
    callback = function(args)
      pcall(vim.treesitter.start, args.buf)
    end,
  })
end

return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    lazy = false,
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
