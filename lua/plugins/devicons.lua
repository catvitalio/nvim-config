local function icon_groups(hex)
  local rgb = {}
  for channel in hex:gmatch('%x%x') do
    rgb[#rgb + 1] = tonumber(channel, 16) / 255
  end
  local r, g, b = rgb[1], rgb[2], rgb[3]
  local high, low = math.max(r, g, b), math.min(r, g, b)
  local delta = high - low
  if high == 0 or delta / high < 0.18 then
    return high > 0.7 and { 'Normal' } or { 'Comment', 'Normal' }
  end
  local hue
  if high == r then
    hue = ((g - b) / delta) % 6
  elseif high == g then
    hue = (b - r) / delta + 2
  else
    hue = (r - g) / delta + 4
  end
  hue = hue * 60
  for _, band in ipairs({
    { 15, { 'DiagnosticError', 'ErrorMsg', 'Normal' } },
    { 35, { 'Number', 'Constant', 'Normal' } },
    { 75, { 'DiagnosticWarn', 'WarningMsg', 'Normal' } },
    { 165, { 'String', 'Normal' } },
    { 200, { 'DiagnosticHint', 'Special', 'Normal' } },
    { 255, { 'Function', 'Directory', 'Normal' } },
    { 285, { 'Keyword', 'Statement', 'Normal' } },
    { 345, { '@variable.parameter', 'Identifier', 'Normal' } },
  }) do
    if hue < band[1] then
      return band[2]
    end
  end
  return { 'DiagnosticError', 'ErrorMsg', 'Normal' }
end

local function config()
  local icons = require('nvim-web-devicons')
  icons.setup()

  local function apply()
    for _, icon in pairs(icons.get_icons()) do
      if icon.name and icon.color then
        local candidates = icon_groups(icon.color)
        local target = 'Normal'
        for _, group in ipairs(candidates) do
          if vim.api.nvim_get_hl(0, { name = group, link = false }).fg then
            target = group
            break
          end
        end
        vim.api.nvim_set_hl(0, 'DevIcon' .. icon.name, { link = target })
      end
    end
  end

  local group = vim.api.nvim_create_augroup('ThemeDevicons', { clear = true })
  vim.api.nvim_create_autocmd('ColorScheme', { group = group, callback = apply })
  vim.api.nvim_create_autocmd('OptionSet', {
    group = group,
    pattern = 'background',
    callback = apply,
  })
  apply()
end

return {
  'nvim-tree/nvim-web-devicons',
  config = config,
}
