local function config()
  local utils = require('utils')

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
            activeBorderColor = { utils.getColor('Constant'), 'bold' },
            inactiveBorderColor = { utils.getColor('FloatBorder') },
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
  lazy = false,
  config = config,
}
