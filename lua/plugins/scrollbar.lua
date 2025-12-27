local function config()
  require('scrollbar').setup({
    excluded_filetypes = {
      'dapui_scopes',
      'dapui_breakpoints',
      'dapui_stacks',
      'dapui_watches',
      'dapui_console',
      'dap-repl',
      'TelescopePrompt',
      'blink-cmp-menu',
      'dropbar_menu',
      'dropbar_menu_fzf',
      'DressingInput',
      'cmp_docs',
      'cmp_menu',
      'noice',
      'prompt',
      'neo-tree',
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
