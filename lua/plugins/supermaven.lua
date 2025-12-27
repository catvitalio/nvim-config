local function config()
  local utils = require('utils')

  require('supermaven-nvim').setup({
    keymaps = {
      accept_suggestion = '<Tab>',
      clear_suggestion = '<C-]>',
      accept_word = '<C-j>',
    },
    ignore_filetypes = {
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
    color = {
      suggestion_color = utils.getColor('LineNr'),
      cterm = 244,
    },
    log_level = 'off',
    disable_inline_completion = false,
    disable_keymaps = false,
    condition = function()
      return false
    end,
  })
end

return {
  'supermaven-inc/supermaven-nvim',
  config = config,
}
