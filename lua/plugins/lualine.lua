local function config()
  local colors = {
    blue = '#A99CF5',
    green = '#83D6C5',
    black = '#1A1A1A',
    white = '#E0E2EA',
    red = '#BF616A',
    grey = '#505050',
  }

  local custom = {
    normal = {
      a = { fg = colors.white, bg = colors.black },
      b = { fg = colors.white, bg = colors.black },
      c = { fg = colors.white, bg = colors.black },
    },

    insert = { a = { fg = colors.blue, bg = colors.black } },
    visual = { a = { fg = colors.green, bg = colors.black } },
    replace = { a = { fg = colors.red, bg = colors.black } },

    inactive = {
      a = { fg = colors.black, bg = colors.black },
      b = { fg = colors.black, bg = colors.black },
      c = { fg = colors.black, bg = colors.black },
    },
  }

  filename = {
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

  require('lualine').setup({})
  local lualine = require('lualine')
  lualine.setup({
    options = {
      theme = custom,
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
        '%=', --[[ add your center components here in place of this comment ]]
        filename,
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
          color = { fg = colors.blue },
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
