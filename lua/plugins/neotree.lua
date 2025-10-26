return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    cmd = 'Neotree',
    keys = {
      { '<A-e>', ':Neotree float reveal<CR>', desc = 'NeoTree', silent = true },
    },
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
          group_empty_dirs = false,
          hide_gitignored = false,
          hide_dotfiles = false,
          hide_by_name = {},
          follow_current_file = { enabled = true },
          never_show = {
            '.git',
            '.DS_Store',
            '.pyc',
            '__pycache__',
          },
        },
        window = {
          popup = {
            title = '',
          },
          position = 'float',
          mappings = {
            -- jump inside directory
            ['}'] = function(state)
              local tree = state.tree
              local node = tree:get_node()
              local siblings = tree:get_nodes(node:get_parent_id())
              local renderer = require('neo-tree.ui.renderer')
              renderer.focus_node(state, siblings[#siblings]:get_id())
            end,
            ['{'] = function(state)
              local tree = state.tree
              local node = tree:get_node()
              local siblings = tree:get_nodes(node:get_parent_id())
              local renderer = require('neo-tree.ui.renderer')
              renderer.focus_node(state, siblings[1]:get_id())
            end,
          },
        },
        default_component_configs = {
          indent = {
            with_markers = true,
            indent_size = 2,
            indent_marker = '│',
            last_indent_marker = '╰',
            highlight = 'NeoTreeIndentMarker',
          },
          git_status = {
            symbols = {
              added = '',
              modified = '',
              deleted = '✖',
              renamed = '󰁕',
              ignored = '',
              untracked = '󰄱',
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
