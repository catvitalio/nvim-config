local M = {}

M.palette = require('themes.graphite.palette')

function M.setup()
  vim.o.termguicolors = true
  vim.o.background = 'dark'
  vim.cmd('highlight clear')
  vim.g.colors_name = 'graphite'
  for _, section in ipairs({ 'editor', 'syntax', 'languages', 'integrations' }) do
    for group, style in pairs(require('themes.graphite.' .. section)) do
      vim.api.nvim_set_hl(0, group, style)
    end
  end
end

function M.lualine()
  if vim.g.colors_name ~= 'graphite' then
    return 'auto'
  end
  local p = M.palette
  local theme = {}
  for mode, accent in pairs({
    normal = p.blue,
    insert = p.green,
    terminal = p.green,
    command = p.peach,
    visual = p.mauve,
    replace = p.red,
    inactive = p.background,
  }) do
    theme[mode] = {
      a = { fg = accent, bg = p.background, gui = 'bold' },
      b = { fg = p.muted, bg = p.background },
      c = { fg = p.muted, bg = p.background },
    }
  end
  theme.inactive.a.gui = nil
  theme.inactive.b.gui = 'bold'
  return theme
end

return M
