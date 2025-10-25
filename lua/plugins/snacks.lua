return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  opts = {
    lazygit = {
      enabled = true,
      configure = true,
      config = {
        os = {
          edit = 'nvr -l --remote {{filename}}',
        },
      },
    },
  },
}
