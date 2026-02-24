local function config()
  vim.fn.sign_define(
    'DapBreakpoint',
    { text = '●', texthl = 'DapBreakpoint', linehl = '', numhl = '' }
  )
  vim.fn.sign_define(
    'DapStopped',
    { text = '▶', texthl = 'DapStopped', linehl = 'DapStoppedLine', numhl = '' }
  )

  require('nvim-dap-virtual-text').setup()
  require('dapui').setup({
    layouts = {
      {
        elements = {
          { id = 'repl', size = 0.5 },
          { id = 'scopes', size = 0.5 },
        },
        size = 10,
        position = 'bottom',
      },
    },
  })

  local dap = require('dap')

  dap.adapters.python = {
    type = 'executable',
    command = 'python3',
    args = { '-m', 'debugpy.adapter' },
  }

  dap.configurations.python = {
    {
      type = 'python',
      request = 'launch',
      name = 'Launch file',
      program = '${file}',
      pythonPath = function()
        local venv = os.getenv('VIRTUAL_ENV')
        if venv then
          return venv .. '/bin/python'
        end
        return 'python3'
      end,
    },
  }
end

return {
  'rcarriga/nvim-dap-ui',
  dependencies = {
    'mfussenegger/nvim-dap',
    'nvim-neotest/nvim-nio',
    'theHamsta/nvim-dap-virtual-text',
  },
  lazy = true,
  cmd = {
    'DapToggleBreakpoint',
    'DapContinue',
    'DapTerminate',
    'DapStepOver',
    'DapStepInto',
    'DapStepOut',
  },
  keys = {
    {
      '<A-d>',
      function()
        require('dapui').toggle()
      end,
      desc = 'DAP UI Toggle',
    },
    { '<A-b>', '<Cmd>DapToggleBreakpoint<CR>', desc = 'DAP Toggle Breakpoint' },
    { '<F5>', '<Cmd>DapContinue<CR>', desc = 'DAP Continue' },
    { '<S-F5>', '<Cmd>DapTerminate<CR>', desc = 'DAP Terminate' },
    { '<F10>', '<Cmd>DapStepOver<CR>', desc = 'DAP Step Over' },
    { '<F11>', '<Cmd>DapStepInto<CR>', desc = 'DAP Step Into' },
    { '<S-F11>', '<Cmd>DapStepOut<CR>', desc = 'DAP Step Out' },
  },
  config = config,
}
