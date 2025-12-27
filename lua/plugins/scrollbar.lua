local function config()
  require('scrollbar').setup({
    excluded_filetypes = {
      'dapui_scopes',
      'dapui_breakpoints',
      'dapui_stacks',
      'dapui_watches',
      'dapui_console',
      'dap-repl',
    },
  })
  require('scrollbar.handlers.gitsigns').setup()
  require('scrollbar.handlers.search').setup()
end

return {
  'petertriho/nvim-scrollbar',
  event = { 'BufReadPost', 'BufNewFile' },
  config = config,
}
