local function set_suggestion_hl()
  vim.api.nvim_set_hl(0, 'SupermavenSuggestion', { link = 'LineNr' })
  require('supermaven-nvim.completion_preview').suggestion_group = 'SupermavenSuggestion'
end

local function config()
  require('supermaven-nvim').setup({
    keymaps = {
      accept_suggestion = '<Tab>',
      clear_suggestion = '<C-]>',
      accept_word = '<C-j>',
    },
    ignore_filetypes = {
      'sensitive',
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
    log_level = 'off',
    disable_inline_completion = false,
    disable_keymaps = false,
  })

  set_suggestion_hl()
  vim.api.nvim_create_user_command('SupermavenToggle', function()
    require('supermaven-nvim.api').toggle()
    vim.schedule(set_suggestion_hl)
  end, { force = true })
end

return {
  'supermaven-inc/supermaven-nvim',
  config = config,
}
