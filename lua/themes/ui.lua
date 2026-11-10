local M = {}
local options = { active_color = '#6a8cbc' }
local pending = false

local function color(groups, attr, fallback)
  for _, group in ipairs(groups) do
    local value = vim.api.nvim_get_hl(0, { name = group, link = false })[attr]
    if value then
      return string.format('#%06x', value)
    end
  end
  return fallback
end

local function blend(background, foreground, amount)
  local result = '#'
  for offset = 2, 6, 2 do
    local bg = tonumber(background:sub(offset, offset + 1), 16)
    local fg = tonumber(foreground:sub(offset, offset + 1), 16)
    result = result .. string.format('%02x', math.floor(bg + (fg - bg) * amount + 0.5))
  end
  return result
end

function M.palette()
  local dark = vim.o.background == 'dark'
  local bg = color({ 'Normal' }, 'bg', dark and '#161617' or '#ffffff')
  local fg = color({ 'Normal' }, 'fg', dark and '#c9c7cd' or '#202020')
  local green = color({ 'String', 'DiagnosticOk' }, 'fg', fg)
  local red = color({ 'DiagnosticError', 'ErrorMsg' }, 'fg', fg)
  return {
    background = bg,
    text = fg,
    muted = color({ 'LineNr', 'Comment' }, 'fg', blend(bg, fg, 0.2)),
    secondary = blend(bg, fg, 0.65),
    active = options.active_color,
    selection = blend(bg, fg, 0.03),
    visual = blend(bg, fg, 0.11),
    green = green,
    red = red,
    yellow = color({ 'DiagnosticWarn', 'WarningMsg' }, 'fg', fg),
    purple = color({ 'Keyword', 'Statement' }, 'fg', fg),
    added = blend(bg, green, 0.12),
    removed = blend(bg, red, 0.14),
    added_text = blend(bg, green, 0.25),
    removed_text = blend(bg, red, 0.28),
  }
end

function M.lualine()
  local p = M.palette()
  local theme = {}
  for mode, accent in pairs({
    normal = p.active,
    insert = p.green,
    command = p.yellow,
    visual = p.purple,
    replace = p.red,
    terminal = p.active,
    inactive = p.muted,
  }) do
    theme[mode] = {
      a = { fg = accent, bg = p.background },
      b = { fg = p.muted, bg = p.background },
      c = { fg = p.muted, bg = p.background },
    }
  end
  return theme
end

function M.apply()
  local p = M.palette()
  local function set(group, style)
    vim.api.nvim_set_hl(0, group, style)
  end
  for _, group in ipairs({
    'NormalNC',
    'NormalFloat',
    'TabLine',
    'TabLineSel',
    'TabLineFill',
    'StatusLine',
    'StatusLineNC',
    'FloatTitle',
    'Pmenu',
    'BlinkCmpMenu',
    'BlinkCmpDoc',
    'BlinkCmpSignatureHelp',
    'SnacksPicker',
    'SnacksPickerInput',
    'SnacksPickerList',
    'SnacksPickerPreview',
    'SnacksNormal',
    'SnacksNormalNC',
  }) do
    set(group, { fg = p.text, bg = p.background })
  end
  for _, group in ipairs({
    'FloatBorder',
    'FloatFooter',
    'WinSeparator',
    'PmenuBorder',
    'BlinkCmpMenuBorder',
    'BlinkCmpDocBorder',
    'BlinkCmpSignatureHelpBorder',
    'SnacksPickerBorder',
    'SnacksPickerBoxBorder',
    'SnacksPickerInputBorder',
    'SnacksPickerListBorder',
    'SnacksPickerPreviewBorder',
  }) do
    set(group, { fg = p.muted, bg = p.background })
  end
  for _, group in ipairs({
    'Whitespace',
    'NonText',
    'SnacksIndent',
    'SnacksIndentScope',
    'GitSignsCurrentLineBlame',
  }) do
    set(group, { fg = p.muted })
  end
  for _, group in ipairs({ 'SnacksPickerMatch', 'CmdlineMatch' }) do
    set(group, { fg = p.active, bold = true })
  end
  set('SnacksPickerDir', { fg = p.secondary })
  set('SnacksPickerTotals', { fg = p.secondary })
  for _, group in ipairs({
    'SnacksPickerListCursorLine',
    'SnacksPickerSelected',
    'PmenuSel',
    'PmenuKindSel',
    'PmenuExtraSel',
    'BlinkCmpMenuSelection',
  }) do
    set(group, { bg = p.selection })
  end
  for _, group in ipairs({
    'Visual',
    'VisualNOS',
    'LspReferenceText',
    'LspReferenceRead',
    'LspReferenceWrite',
  }) do
    set(group, { bg = p.visual })
  end
  for _, state in ipairs({ 'Current', 'Visible', 'Inactive', 'Alternate' }) do
    local fg = (state == 'Current' or state == 'Visible') and p.text or p.muted
    for _, suffix in ipairs({
      '',
      'Index',
      'Number',
      'Sign',
      'SignRight',
      'Btn',
      'Icon',
      'Pin',
      'PinBtn',
    }) do
      set('Buffer' .. state .. suffix, { fg = fg, bg = p.background })
    end
    for _, suffix in ipairs({ 'Mod', 'ModBtn' }) do
      set('Buffer' .. state .. suffix, { fg = p.yellow, bg = p.background })
    end
    set('Buffer' .. state .. 'Target', { fg = p.red, bg = p.background })
  end
  for _, group in ipairs({ 'BufferCurrentSign', 'BufferCurrentSignRight' }) do
    set(group, { fg = p.active, bg = p.background })
  end
  set('BufferTabpageFill', { bg = p.background })
  set('BufferTabpages', { fg = p.text, bg = p.background })
  set('BufferTabpagesSep', { fg = p.muted, bg = p.background })
  for _, group in ipairs({ 'DiffAdd', 'GitSignsAddLn', 'GitSignsChangeLn' }) do
    set(group, { bg = p.added })
  end
  for _, group in ipairs({ 'DiffDelete', 'GitSignsDeleteVirtLn' }) do
    set(group, { fg = p.text, bg = p.removed })
  end
  set('DiffChange', { bg = p.selection })
  for _, group in ipairs({ 'DiffText', 'GitSignsAddInline', 'GitSignsChangeInline' }) do
    set(group, { bg = p.added_text })
  end
  set('GitSignsDeleteInline', { fg = p.text, bg = p.removed_text })

  local lazygit = _G.Snacks and Snacks.config.lazygit
  if lazygit and lazygit.config and lazygit.config.git and lazygit.config.git.paging then
    lazygit.config.git.paging.pager = require('themes.delta').pager()
  end
end

local function schedule_apply()
  if pending then
    return
  end
  pending = true
  vim.schedule(function()
    pending = false
    M.apply()
  end)
end

function M.setup(opts)
  local updated = vim.tbl_extend('force', options, opts or {})
  assert(
    type(updated.active_color) == 'string' and updated.active_color:match('^#%x%x%x%x%x%x$'),
    'active_color must be #RRGGBB'
  )
  options = updated
  local group = vim.api.nvim_create_augroup('ThemeUI', { clear = true })
  vim.api.nvim_create_autocmd('ColorScheme', {
    group = group,
    callback = function()
      M.apply()
      schedule_apply()
    end,
  })
  vim.api.nvim_create_autocmd('User', {
    group = group,
    pattern = { 'LazyDone', 'LazyLoad' },
    callback = schedule_apply,
  })
  M.apply()
  if package.loaded.lualine then
    require('lualine').setup()
  end
end

function M.plugin(theme, opts)
  local spec = vim.tbl_extend('force', {}, theme)
  local init = spec.init
  spec.init = function(plugin)
    M.setup(opts)
    if init then
      init(plugin)
    end
  end
  return spec
end

return M
