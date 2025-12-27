local function getColor(group, attr)
  attr = attr or 'fg'
  local hl = vim.api.nvim_get_hl(0, { name = group })
  if hl[attr] then
    return string.format('#%06x', hl[attr])
  end
  return nil
end

return {
  getColor = getColor,
}
