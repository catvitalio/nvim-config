return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
      's1n7ax/nvim-window-picker',
    },
    config = function()
      require('neo-tree').setup({
        close_if_last_window = true,
        popup_border_style = 'rounded',
        filesystem = {
          hijack_netrw_behavior = 'open_default',
          group_empty_dirs = true,
        },
        window = {
          position = 'float',
        },
      })
    end,
  },
}
