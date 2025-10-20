local function config()
  local telescope = require('telescope')
  local actions = require('telescope.actions')

  telescope.setup({
    extensions = {
      ['ui-select'] = {
        {
          previewer = false,
          theme = 'dropdown',
          layout_strategy = 'center',
          layout_config = {
            width = 0.5,
            height = 0.4,
            prompt_position = 'top',
          },
          border = true,
          borderchars = {
            prompt = { '─', '│', ' ', '│', '╭', '╮', '│', '│' },
            results = { '─', '│', '─', '│', '├', '┤', '╯', '╰' },
          },
          sorting_strategy = 'ascending',
        },
      },
    },
    defaults = {
      border = true,
      borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
      layout_config = {
        prompt_position = 'bottom',
      },
      sorting_strategy = 'ascending',
    },
  })
end

return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    config = config,
  },
  {
    'nvim-telescope/telescope-ui-select.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config = function()
      require('telescope').load_extension('ui-select')
    end,
  },
}
