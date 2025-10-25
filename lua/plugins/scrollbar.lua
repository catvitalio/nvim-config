return {
  'petertriho/nvim-scrollbar',
  event = { 'BufReadPost', 'BufNewFile' },
  config = function()
    require('scrollbar').setup({})
    require('scrollbar.handlers.gitsigns').setup()
    require('scrollbar.handlers.search').setup()
  end,
}
