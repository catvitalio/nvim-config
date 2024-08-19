local function config()
  require('eagle').setup({
    border = 'rounded',
  })
end

return {
  'soulis-1256/eagle.nvim',
  config = config,
}
