local function config()
  require('scrollbar').setup({
    exclude = {
      buftypes = { 'terminal' },
      filetypes = {
        'dapui_scopes',
        'dapui_breakpoints',
        'dapui_stacks',
        'dapui_watches',
        'dapui_console',
        'dap-repl',
        'blink-cmp-menu',
        'dropbar_menu',
        'dropbar_menu_fzf',
        'DressingInput',
        'cmp_docs',
        'cmp_menu',
        'noice',
        'prompt',
        'snacks_picker_list',
        'snacks_picker_input',
        'snacks_layout_box',
      },
    },
    providers = { gitsigns = true, search = true, marks = false },
  })
end

return {
  'petertriho/nvim-scrollbar',
  branch = 'refactor/v2',
  dependencies = { 'lewis6991/gitsigns.nvim' },
  event = { 'BufReadPost', 'BufNewFile' },
  config = config,
}
