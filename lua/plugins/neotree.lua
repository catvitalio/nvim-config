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
        enable_diagnostics = false,
        close_if_last_window = true,
        popup_border_style = 'rounded',
        filesystem = {
          hijack_netrw_behavior = 'open_default',
          group_empty_dirs = true,
        },
        window = {
          position = 'float',
        },
        default_component_configs = {
          git_status = {
            symbols = {
              -- Change type
              added = '',
              modified = '',
              deleted = '✖',
              renamed = '󰁕',
              untracked = '',
              ignored = '',
              unstaged = '󰄱',
              staged = '',
              conflict = '',
            },
          },
        },
      })
    end,
  },
}
