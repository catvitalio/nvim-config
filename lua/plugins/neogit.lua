return {
  'NeogitOrg/neogit',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'sindrets/diffview.nvim',
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    require('neogit').setup({
      kind = 'floating', -- открывается в плавающем окне
      integrations = {
        telescope = true,
        diffview = true,
      },
    })
  end,
}
