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
  'vim',
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
}
