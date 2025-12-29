local function config()
  local telescope = require('telescope')

  telescope.setup({
    extensions = {
      ['ui-select'] = {
        require('telescope.themes').get_dropdown({
          previewer = false,
          borderchars = {
            prompt = { '─', '│', ' ', '│', '╭', '╮', '│', '│' },
            results = { '─', '│', '─', '│', '├', '┤', '╯', '╰' },
          },
          layout_config = {
            width = 0.5,
            height = 0.4,
            prompt_position = 'top',
          },
          sorting_strategy = 'ascending',
        }),
      },
    },
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

  telescope.load_extension('ui-select')
end

return {
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    lazy = true,
    keys = {
      { 'ff', '<cmd>Telescope find_files<cr>', desc = 'Find files' },
      { 'fw', '<cmd>Telescope live_grep<cr>', desc = 'Live grep' },
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
    'nvim-telescope/telescope-ui-select.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-telescope/telescope.nvim' },
  },
}
