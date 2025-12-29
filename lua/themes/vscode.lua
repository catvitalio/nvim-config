return function()
  local utils = require('themes.utils')
  local colors = {
    -- Float windows
    FloatBorder = { fg = '#5a5a5a', bg = '#1f1f1f' },
    NormalFloat = { fg = '#d4d4d4', bg = '#1f1f1f' },
    Pmenu = { fg = '#d4d4d4', bg = '#1f1f1f' },

    -- Barbar
    BufferCurrent = { fg = '#d4d4d4', bg = '#1f1f1f' },
    BufferCurrentIndex = { fg = '#569cd6', bg = '#1f1f1f' },
    BufferCurrentMod = { fg = '#dcdcaa', bg = '#1f1f1f' },
    BufferCurrentSign = { fg = '#569cd6', bg = '#1f1f1f' },
    BufferCurrentTarget = { fg = '#f44747', bg = '#1f1f1f' },
    BufferVisible = { fg = '#d4d4d4', bg = '#1f1f1f' },
    BufferVisibleIndex = { fg = '#d4d4d4', bg = '#1f1f1f' },
    BufferVisibleMod = { fg = '#ce9178', bg = '#1f1f1f' },
    BufferVisibleSign = { fg = '#d4d4d4', bg = '#1f1f1f' },
    BufferVisibleTarget = { fg = '#f44747', bg = '#1f1f1f' },
    BufferInactive = { fg = '#5a5a5a', bg = '#1f1f1f' },
    BufferInactiveIndex = { fg = '#5a5a5a', bg = '#1f1f1f' },
    BufferInactiveMod = { fg = '#5a5a5a', bg = '#1f1f1f' },
    BufferInactiveSign = { fg = '#5a5a5a', bg = '#1f1f1f' },
    BufferInactiveTarget = { fg = '#f44747', bg = '#1f1f1f' },
    BufferTabpages = { fg = '#d4d4d4', bg = '#1f1f1f' },
    BufferTabpageFill = { fg = '#d4d4d4', bg = '#1f1f1f' },

    -- Neo-tree
    NeoTreeFloatBorder = { fg = '#5a5a5a', bg = '#1f1f1f' },
    NeoTreeFloatNormal = { bg = '#1f1f1f' },

    -- Lualine
    lualine_a_normal = { fg = '#569cd6', bg = '#1f1f1f' },
    lualine_a_insert = { fg = '#ce9178', bg = '#1f1f1f' },
    lualine_a_visual = { fg = '#c586c0', bg = '#1f1f1f' },
    lualine_a_replace = { fg = '#f44747', bg = '#1f1f1f' },
    lualine_b_normal = { fg = '#5a5a5a', bg = '#1f1f1f' },
    lualine_b_insert = { fg = '#5a5a5a', bg = '#1f1f1f' },
    lualine_b_visual = { fg = '#5a5a5a', bg = '#1f1f1f' },
    lualine_b_replace = { fg = '#5a5a5a', bg = '#1f1f1f' },
    lualine_c_normal = { fg = '#5a5a5a', bg = '#1f1f1f' },
    lualine_c_insert = { fg = '#5a5a5a', bg = '#1f1f1f' },
    lualine_c_visual = { fg = '#5a5a5a', bg = '#1f1f1f' },
    lualine_c_replace = { fg = '#5a5a5a', bg = '#1f1f1f' },
    lualine_x_normal = { fg = '#c586c0', bg = '#1f1f1f' },
    lualine_x_insert = { fg = '#c586c0', bg = '#1f1f1f' },
    lualine_x_visual = { fg = '#c586c0', bg = '#1f1f1f' },
    lualine_x_replace = { fg = '#c586c0', bg = '#1f1f1f' },
    lualine_y_normal = { fg = '#5a5a5a', bg = '#1f1f1f' },
    lualine_y_insert = { fg = '#5a5a5a', bg = '#1f1f1f' },
    lualine_y_visual = { fg = '#5a5a5a', bg = '#1f1f1f' },
    lualine_y_replace = { fg = '#5a5a5a', bg = '#1f1f1f' },
    lualine_a_inactive = { fg = '#5a5a5a', bg = '#1f1f1f' },
    lualine_b_inactive = { fg = '#5a5a5a', bg = '#1f1f1f' },
    lualine_c_inactive = { fg = '#5a5a5a', bg = '#1f1f1f' },
    lualine_x_inactive = { fg = '#5a5a5a', bg = '#1f1f1f' },
    lualine_y_inactive = { fg = '#5a5a5a', bg = '#1f1f1f' },

    -- Treesitter
    TreesitterContext = { fg = '#d4d4d4', bg = '#1f1f1f' },

    -- Telescope
    TelescopeBorder = { fg = '#5a5a5a', bg = 'NONE' },
    TelescopePromptBorder = { fg = '#5a5a5a', bg = 'NONE' },
    TelescopeResultsBorder = { fg = '#5a5a5a', bg = 'NONE' },
    TelescopePreviewBorder = { fg = '#5a5a5a', bg = 'NONE' },

    -- Lazygit
    LazygitActiveBorder = { fg = '#569cd6', bold = true },
    LazygitInactiveBorder = { fg = '#5a5a5a' },

    -- Dap
    DapBreakpoint = { fg = '#f44747', bg = '#1f1f1f' },
    DapStopped = { fg = '#C586C0', bg = '#1f1f1f' },
  }

  return utils.setup_theme('Mofiqul/vscode.nvim', {}, colors)
end
