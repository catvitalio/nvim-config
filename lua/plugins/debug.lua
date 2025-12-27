local function config()
  local utils = require('utils')

  vim.fn.sign_define(
    'DapBreakpoint',
    { text = '●', texthl = 'DapBreakpoint', linehl = '', numhl = '' }
  )
  vim.fn.sign_define(
    'DapStopped',
    { text = '▶', texthl = 'DapStopped', linehl = 'DapStoppedLine', numhl = '' }
  )
  vim.api.nvim_set_hl(0, 'DapBreakpoint', { fg = utils.getColor('Error') })
  vim.api.nvim_set_hl(0, 'DapStopped', { fg = utils.getColor('Keyword') })

  require('dapui').setup({
    layouts = {
      {
        elements = {
          { id = 'repl', size = 0.5 },
          { id = 'console', size = 0.5 },
        },
        size = 10,
        position = 'bottom',
      },
    },
  })
end

return {
  'rcarriga/nvim-dap-ui',
  dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
  config = config,
}
