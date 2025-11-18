local function config()
  require('colorizer').setup({
    user_default_options = {
      names = false,
    },
  })
end

return {
  'catgoose/nvim-colorizer.lua',
  config = config,
  event = 'BufReadPre',
  opts = {},
}
