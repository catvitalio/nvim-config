local function config()
  local colors = {
    yellow = '#D7BA7D',
    blue = '#569CD6',
    green = '#6A9956',
    black = '#1E1E1E',
    white = '#D4D4D4',
    red = '#CD3131',
    grey = '#2D2D2D',
  }

  local bubbles_theme = {
    normal = {
      a = { fg = colors.black, bg = colors.yellow },
      b = { fg = colors.white, bg = colors.grey },
      c = { fg = colors.white, bg = colors.grey },
    },

    insert = { a = { fg = colors.black, bg = colors.blue } },
    visual = { a = { fg = colors.black, bg = colors.green } },
    replace = { a = { fg = colors.black, bg = colors.red } },

    inactive = {
      a = { fg = colors.black, bg = colors.white },
      b = { fg = colors.black, bg = colors.white },
      c = { fg = colors.white },
    },
  }

  require('lualine').setup({})
  local lualine = require('lualine')
  lualine.setup({
    options = {
      theme = bubbles_theme,
      component_separators = '',
      section_separators = { left = '', right = '' },
    },
    sections = {
      lualine_a = {
        {
          'filename',
          path = 1,
          separator = { left = '', right = '' },
          left_padding = 2,
        },
      },
      lualine_b = { 'branch', 'diff' },
      lualine_c = {
        '%=', --[[ add your center components here in place of this comment ]]
      },
      lualine_x = {},
      lualine_y = { 'o:encoding', { 'fileformat', icons_enabled = false } },
      lualine_z = {
        { 'location', separator = { right = '', left = '' }, left_padding = 2 },
      },
    },
    inactive_sections = {
      lualine_a = { { 'filename', path = 1 } },
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {
        { 'location', separator = { right = '', left = '' }, left_padding = 2 },
      },
    },
    tabline = {},
    extensions = {},
  })
end

return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = config,
}
