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
          edit = 'nvr --remote-send "<Esc><cmd>q<cr><cmd>e {{filename}}<cr>"',
        },
        gui = {
          theme = {
            activeBorderColor = { '#AA9BF5', 'bold' },
            inactiveBorderColor = { '#505050' },
          },
        },
      },
      win = {
        border = 'rounded',
        style = {
          backdrop = false,
        },
      },
    },
    indent = {
      enabled = true,
      animate = {
        enabled = false,
      },
    },
  },
  config = function(_, opts)
    require('snacks').setup(opts)
    vim.api.nvim_set_hl(0, 'SnacksLazygitBorder', { fg = vim.g.border_color, bg = 'NONE' })
  end,
}
