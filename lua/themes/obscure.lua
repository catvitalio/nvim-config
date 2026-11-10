local M = {}

function M.lualine()
  local theme = vim.deepcopy(require('lualine.themes.obscure'))
  local colors = require('obscure.palettes').get_palette('obscure')
  for _, sections in pairs(theme) do
    for section, style in pairs(sections) do
      if style.fg == colors.black then style.fg = style.bg end
      if section ~= 'a' then style.fg = colors.gray4 end
      style.bg = colors.bg
    end
  end
  theme.normal.a.fg = colors.blue
  return theme
end

function M.plugin()
  return {
    'mikovskii/obscure.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('obscure').setup({
        dim_inactive = false,
        on_highlights = function(hl, colors)
          local diff = {
            added = '#202923',
            removed = '#2b2024',
            added_text = '#2d3d32',
            removed_text = '#422b33',
            changed_text = '#383127',
          }
          hl.DiffAdd = { bg = diff.added }
          hl.DiffDelete = { fg = colors.fg, bg = diff.removed }
          hl.DiffChange = { bg = colors.gray1 }
          hl.DiffText = { bg = diff.changed_text }
          hl.GitSignsAddLn = { bg = diff.added }
          hl.GitSignsChangeLn = { bg = diff.added }
          hl.GitSignsDeleteVirtLn = { fg = colors.fg, bg = diff.removed }
          hl.GitSignsAddInline = { bg = diff.added_text }
          hl.GitSignsChangeInline = { bg = diff.changed_text }
          hl.GitSignsDeleteInline = { fg = colors.fg, bg = diff.removed_text }
          for _, group in ipairs({
            'TabLine', 'TabLineSel', 'TabLineFill',
            'NormalFloat', 'NeoTreeNormal', 'NeoTreeNormalNC',
            'NeoTreeFloatNormal', 'NeoTreeFloatBorder', 'NeoTreeFloatTitle',
            'NeoTreeTitleBar', 'FloatBorder', 'FloatTitle',
          }) do
            hl[group] = vim.tbl_extend('force', hl[group] or {}, { bg = colors.bg })
            hl[group].link = nil
          end
          for _, group in ipairs({ 'Whitespace', 'NonText', 'SnacksIndent', 'SnacksIndentScope' }) do
            hl[group] = { fg = hl.LineNr.fg }
          end
          for _, state in ipairs({ 'Current', 'Visible', 'Inactive', 'Alternate' }) do
            local fg = (state == 'Current' or state == 'Visible') and colors.fg or hl.LineNr.fg
            for _, suffix in ipairs({ '', 'Index', 'Number', 'Sign', 'SignRight', 'Btn', 'Icon', 'Pin', 'PinBtn' }) do
              hl['Buffer' .. state .. suffix] = { fg = fg, bg = colors.bg }
            end
            hl['Buffer' .. state .. 'Mod'] = { fg = colors.yellow, bg = colors.bg }
            hl['Buffer' .. state .. 'ModBtn'] = { fg = colors.yellow, bg = colors.bg }
            hl['Buffer' .. state .. 'Target'] = { fg = colors.red, bg = colors.bg }
          end
          hl.BufferTabpageFill = { bg = colors.bg }
          hl.BufferCurrentSign = { fg = colors.blue, bg = colors.bg }
          hl.BufferCurrentSignRight = { fg = colors.blue, bg = colors.bg }
          hl.BufferTabpages = { fg = colors.fg, bg = colors.bg }
          hl.BufferTabpagesSep = { fg = colors.subtext4, bg = colors.bg }
          hl.SnacksPickerListCursorLine = { bg = colors.gray1 }
          hl.SnacksPickerDir = { fg = colors.subtext3 }
          hl.Visual = { bg = colors.gray2 }
          hl.VisualNOS = { bg = colors.gray2 }
          hl.CmdlineMatch = { fg = colors.blue, bold = true }
        end,
      })
      vim.o.background = 'dark'
      vim.cmd.colorscheme('obscure')
    end,
  }
end

return M
