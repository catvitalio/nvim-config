return {
  {
    'romgrk/barbar.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    init = function()
      vim.g.barbar_auto_setup = false
      require('barbar').setup({
        icons = {
          buffer_index = true,
        },
        animation = false,
        no_name_title = 'untitled',
      })
    end,
    opts = {},
    version = '^1.0.0',
  },
}
