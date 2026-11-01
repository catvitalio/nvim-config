local M = {}

M.palette = {
  background = '#1e1e1e',
  selection = '#282828',
  muted = '#414141',
  secondary = '#767676',
  white = '#ffffff',
  active_indent = '#9399b2',
}

function M.lualine()
  if vim.g.colors_name ~= 'catppuccin-mocha' then
    return 'auto'
  end
  local theme = vim.deepcopy(require('lualine.themes.catppuccin-mocha'))
  for _, sections in pairs(theme) do
    for section, style in pairs(sections) do
      style.fg = section == 'a' and style.bg or M.palette.muted
      style.bg = M.palette.background
    end
  end
  return theme
end

function M.plugin()
  local palette = M.palette
  local background, grey = palette.background, palette.muted

  return {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000,
    opts = {
      flavour = 'mocha',
      transparent_background = false,
      lsp_styles = {
        underlines = {
          errors = { 'undercurl' },
          warnings = { 'undercurl' },
          hints = { 'undercurl' },
          information = { 'undercurl' },
          ok = { 'undercurl' },
        },
      },
      color_overrides = {
        mocha = {
          base = background,
          mantle = background,
          crust = background,
        },
      },
      custom_highlights = function(colors)
        local highlights = {
          SignColumn = { bg = background },
          LineNr = { fg = grey, bg = background },
          LineNrAbove = { fg = grey, bg = background },
          LineNrBelow = { fg = grey, bg = background },
          CursorLineNr = { fg = colors.text, bg = background },
          NormalFloat = { bg = background },
          FloatBorder = { fg = grey, bg = background },
          WinSeparator = { fg = grey, bg = background },
          NeoTreeFloatBorder = { fg = grey, bg = background },
          NeoTreeCursorLine = { bg = palette.selection },
          BlinkCmpMenuSelection = { bg = palette.selection, bold = true },
          BlinkCmpMenuBorder = { fg = grey, bg = background },
          BlinkCmpDocBorder = { fg = grey, bg = background },
          BlinkCmpSignatureHelpBorder = { fg = grey, bg = background },
          SnacksPickerBorder = { fg = grey, bg = background },
          SnacksPickerBoxBorder = { fg = grey, bg = background },
          SnacksPickerListCursorLine = { bg = palette.selection },
          SnacksPickerDir = { fg = palette.secondary },
          SnacksPickerTotals = { fg = palette.secondary },
          SnacksIndent = { fg = grey },
          SnacksIndentScope = { fg = palette.active_indent },
          Whitespace = { fg = grey },
          NonText = { fg = grey },
          GitSignsCurrentLineBlame = { fg = grey },
          CmdlineMatch = { fg = colors.blue },
          CodexIdle = { fg = colors.overlay0, bg = background },
          CodexWorking = { fg = palette.white, bg = background },
        }
        for _, state in ipairs({ 'Current', 'Visible', 'Inactive', 'Alternate' }) do
          for _, suffix in ipairs({ '', 'Index', 'Mod', 'Sign', 'Target', 'Icon', 'SignRight' }) do
            local fg = (state == 'Current' or state == 'Visible') and colors.text or grey
            if suffix == 'Mod' then fg = colors.yellow end
            if suffix == 'Target' then fg = colors.red end
            highlights['Buffer' .. state .. suffix] = { fg = fg, bg = background }
          end
        end
        highlights.BufferTabpageFill = { bg = background }
        return highlights
      end,
    },
    config = function(_, opts)
      require('catppuccin').setup(opts)
      vim.cmd.colorscheme('catppuccin-mocha')
    end,
  }
end

return M
