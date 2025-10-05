local function config()
  require('telescope').setup({
    extensions = {
      ['ui-select'] = require('telescope.themes').get_dropdown({}),
    },
    defaults = {
      border = true,
      layout_config = {
        prompt_position = 'bottom',
      },
      sorting_strategy = 'ascending',
    },
  })
  require('telescope').load_extension('ui-select')
end

return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-ui-select.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    config = config,
  },
}
