return function()
  local utils = require('themes.utils')

  local black = '#1f1f1f'
  local white = '#d4d4d4'
  local grey = '#5a5a5a'
  local dark_grey = '#222222'
  local blue = '#569cd6'
  local red = '#f44747'
  local orange = '#ce9178'
  local green = '#6a9955'
  local purple = '#c678dd'
  local yellow = '#dcdcaa'
  local none = 'NONE'

  local colors = {
    -- Float windows
    FloatBorder = { fg = grey, bg = black },
    NormalFloat = { fg = white, bg = black },
    Pmenu = { fg = white, bg = black },

    -- Barbar
    BufferCurrent = { fg = white, bg = black },
    BufferCurrentIndex = { fg = blue, bg = black },
    BufferCurrentMod = { fg = yellow, bg = black },
    BufferCurrentSign = { fg = blue, bg = black },
    BufferCurrentTarget = { fg = red, bg = black },
    BufferVisible = { fg = white, bg = black },
    BufferVisibleIndex = { fg = white, bg = black },
    BufferVisibleMod = { fg = orange, bg = black },
    BufferVisibleSign = { fg = white, bg = black },
    BufferVisibleTarget = { fg = red, bg = black },
    BufferInactive = { fg = grey, bg = black },
    BufferInactiveIndex = { fg = grey, bg = black },
    BufferInactiveMod = { fg = grey, bg = black },
    BufferInactiveSign = { fg = grey, bg = black },
    BufferInactiveTarget = { fg = red, bg = black },
    BufferTabpages = { fg = white, bg = black },
    BufferTabpageFill = { fg = white, bg = black },

    -- Neo-tree
    NeoTreeFloatBorder = { fg = grey, bg = black },
    NeoTreeFloatNormal = { bg = black },

    -- Lualine
    lualine_a_normal = { fg = blue, bg = black },
    lualine_a_insert = { fg = orange, bg = black },
    lualine_a_visual = { fg = green, bg = black },
    lualine_a_replace = { fg = red, bg = black },
    lualine_b_normal = { fg = grey, bg = black },
    lualine_b_insert = { fg = grey, bg = black },
    lualine_b_visual = { fg = grey, bg = black },
    lualine_b_replace = { fg = grey, bg = black },
    lualine_c_normal = { fg = grey, bg = black },
    lualine_c_insert = { fg = grey, bg = black },
    lualine_c_visual = { fg = grey, bg = black },
    lualine_c_replace = { fg = grey, bg = black },
    lualine_a_inactive = { fg = grey, bg = black },
    lualine_b_inactive = { fg = grey, bg = black },
    lualine_c_inactive = { fg = grey, bg = black },
    lualine_a_terminal = { fg = grey, bg = black },
    lualine_b_terminal = { fg = grey, bg = black },
    lualine_c_terminal = { fg = grey, bg = black },
    lualine_a_command = { fg = black, bg = black },
    lualine_b_command = { fg = black, bg = black },
    lualine_c_command = { fg = black, bg = black },

    -- Treesitter
    TreesitterContext = { fg = white, bg = black },

    -- Telescope
    TelescopeBorder = { fg = grey, bg = none },
    TelescopePromptBorder = { fg = grey, bg = none },
    TelescopeResultsBorder = { fg = grey, bg = none },
    TelescopePreviewBorder = { fg = grey, bg = none },

    -- Lazygit
    LazygitActiveBorder = { fg = blue, bold = true },
    LazygitInactiveBorder = { fg = grey },

    -- Dap
    DapBreakpoint = { fg = red, bg = black },
    DapStopped = { fg = purple, bg = black },
    DapStoppedLine = { bg = dark_grey },
    NvimDapVirtualText = { fg = grey, italic = true },
  }

  return utils.setup_theme('Mofiqul/vscode.nvim', {}, colors)
end
