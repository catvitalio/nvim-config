local function config()
  require('barbar').setup({
    icons = {
      buffer_index = true,
    },
    animation = false,
    no_name_title = 'untitled',
    auto_hide = true,
  })
end

return {
  {
    'romgrk/barbar.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    config = config,
    version = '^1.0.0',
  },
}
