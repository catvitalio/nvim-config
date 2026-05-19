local function config()
  require('snacks').setup({
    lazygit = {
      enabled = true,
      configure = true,
      config = {
        os = {
          edit = 'nvr --remote-send "<Esc><cmd>q<cr><cmd>e {{filename}}<cr>"',
        },
        git = {
          paging = {
            colorArg = 'always',
            pager = 'delta --dark --paging=never',
          },
        },
        gui = {
          showBottomLine = false,
        },
      },
      win = {
        border = 'none',
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
    bigfile = {
      enabled = true,
      size = 1.5 * 1024 * 1024, -- 1.5mb
    },
    words = {
      enabled = true,
      debounce = 1,
    },
  })
end

return {
  'folke/snacks.nvim',
  lazy = false,
  priority = 1000,
  keys = {
    {
      '<A-g>',
      function()
        Snacks.lazygit()
      end,
      desc = '[g]it',
      mode = { 'n', 't' },
    },
  },
  config = config,
}
