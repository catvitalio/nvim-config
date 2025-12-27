local function config()
  local utils = require('utils')
  local lualine = require('lualine')

  local colors = {
    bg = utils.getColor('Normal', 'bg'),
    fg = utils.getColor('Normal'),
    insert = utils.getColor('Constant'),
    visual = utils.getColor('Keyword'),
    replace = utils.getColor('Error'),
  }

  local theme = {
    normal = {
      a = { fg = colors.fg, bg = colors.bg },
      b = { fg = colors.fg, bg = colors.bg },
      c = { fg = colors.fg, bg = colors.bg },
    },

    insert = { a = { fg = colors.insert, bg = colors.bg } },
    visual = { a = { fg = colors.visual, bg = colors.bg } },
    replace = { a = { fg = colors.replace, bg = colors.bg } },

    inactive = {
      a = { fg = colors.fg, bg = colors.bg },
      b = { fg = colors.fg, bg = colors.bg },
      c = { fg = colors.fg, bg = colors.bg },
    },
  }

  local fileName = {
    'filename',
    path = 1,
    separator = { left = '', right = '' },
    left_padding = 2,
    symbols = {
      modified = '',
      readonly = '',
      unnamed = 'untitled',
      newfile = 'untitled',
    },
  }

  lualine.setup({
    options = {
      theme = theme,
      component_separators = '',
      disabled_filetypes = {
        statusline = {
          'dapui_scopes',
          'dapui_breakpoints',
          'dapui_stacks',
          'dapui_watches',
          'dapui_console',
          'dap-repl',
        },
        winbar = {},
      },
    },
    sections = {
      lualine_a = {
        {
          'mode',
          fmt = function(str)
            return str:sub(1, 1)
          end,
        },
      },
      lualine_b = {},
      lualine_c = {
        '%=',
        fileName,
        'branch',
        'diff',
      },
      lualine_x = {
        {
          function()
            local api = require('supermaven-nvim.api')
            if api.is_running() then
              return '󰚩'
            else
              return ''
            end
          end,
          color = { fg = colors.insert },
        },
      },
      lualine_y = { 'location' },
      lualine_z = {},
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },
    tabline = {},
    extensions = {},
  })
end

return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = config,
}
