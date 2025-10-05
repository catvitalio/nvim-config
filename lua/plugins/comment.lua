local function config()
  require('Comment').setup()
end

return {
  'numToStr/Comment.nvim',
  opts = {},
  config = config,
}
