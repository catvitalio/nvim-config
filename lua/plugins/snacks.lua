local function config()
  local utils = require('themes.utils')

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
          theme = {
            activeBorderColor = { utils.get_color('LazygitActiveBorder'), 'bold' },
            inactiveBorderColor = { utils.get_color('LazygitInactiveBorder') },
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
  })
end

return {
  'folke/snacks.nvim',
  event = 'VeryLazy',
  config = config,
}
