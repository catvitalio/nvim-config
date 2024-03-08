local function config()
  local colors = {
    blue = '#5e9cd4',
    cyan = '#11a8cd',
    black = '#1E1E1E',
    white = '#e5e5e5',
    red = '#ca917a',
    violet = '#bc3fbc',
    green = '#0dbc79',
    grey = '#252526',
    light_grey = '#3b3b3c',
  }

  local th = {
    normal = {
      a = { fg = colors.black, bg = colors.blue },
      b = { fg = colors.white, bg = colors.light_grey },
      c = { fg = colors.white, bg = colors.grey },
    },

    insert = { a = { fg = colors.black, bg = colors.red } },
    visual = { a = { fg = colors.black, bg = colors.green } },
    replace = { a = { fg = colors.black, bg = colors.red } },

    inactive = {
      a = { fg = colors.white, bg = colors.black },
      b = { fg = colors.white, bg = colors.black },
      c = { fg = colors.black, bg = colors.black },
    },
  }

  require('lualine').setup({
    options = {
      theme = th,
      component_separators = '|',
      section_separators = { left = '', right = '' },
    },
    sections = {
      lualine_a = { { 'mode', separator = { left = '' }, right_padding = 0 } },
      lualine_b = {
        'filename',
        'branch',
        -- require('lsp-progress').progress,
      },
      lualine_c = {},
      lualine_x = {},
      lualine_y = {
        'filetype',
        'progress',
      },
      lualine_z = {
        { 'location', separator = { right = '' }, left_padding = 0 },
      },
    },
    inactive_sections = {
      lualine_a = { 'filename' },
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = { 'location' },
    },
    tabline = {},
    extensions = {},
  })

  vim.cmd([[
augroup lualine_augroup
    autocmd!
    autocmd User LspProgressStatusUpdated lua require("lualine").refresh()
augroup END
]])
end

return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'linrongbin16/lsp-progress.nvim',
  },
  config = config,
}
