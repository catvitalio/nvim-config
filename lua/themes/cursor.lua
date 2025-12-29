return function()
  local utils = require('themes.utils')
  local opts = { style = 'dark', dashboard = false }
  local colors = {}

  return utils.setup_theme('ydkulks/cursor-dark.nvim', opts, colors)
end
