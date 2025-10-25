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
          edit = 'sh -c "nvr --remote-send q && nvr -l --remote \\$1" -- {{filename}}',
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
