local function config()
  local telescope = require('telescope')

  telescope.setup({
    defaults = {
      border = true,
      borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
      layout_config = {
        prompt_position = 'bottom',
      },
      sorting_strategy = 'ascending',
      vimgrep_arguments = {
        'rg',
        '--color=never',
        '--no-heading',
        '--with-filename',
        '--line-number',
        '--column',
        '--smart-case',
        '--fixed-strings',
      },
    },
  })

  telescope.load_extension('frecency')
end

return {
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    lazy = true,
    keys = {
      { '<A-p>', '<cmd>Telescope frecency workspace=CWD<cr>', desc = 'Find files (frecency)' },
      { '<A-f>', '<cmd>Telescope live_grep<cr>', desc = 'Live grep' },
      { 'gr', '<cmd>Telescope lsp_references<cr>', desc = 'LSP references' },
      { 'gd', '<cmd>Telescope lsp_definitions<cr>', desc = 'LSP definitions' },
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    config = config,
  },
  {
    'nvim-telescope/telescope-frecency.nvim',
    lazy = true,
    dependencies = { 'nvim-telescope/telescope.nvim' },
  },
}
