return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    preset = 'classic',
    delay = 250,
    win = {
      border = 'rounded',
      wo = { winblend = 0 },
    },
    spec = {
      { '<leader>r', group = 'Review' },
    },
  },
  keys = {
    {
      '<leader>?',
      function()
        require('which-key').show({ keys = '<leader>' })
      end,
      desc = 'Show leader keymaps',
    },
  },
}
