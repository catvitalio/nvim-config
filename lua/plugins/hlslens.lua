return {
  'kevinhwang91/nvim-hlslens',
  config = function()
    require('hlslens').setup({
      calm_down = true,
      nearest_only = false,
      nearest_float_when = 'never',
    })

    -- Улучшенные маппинги для поиска
    local kopts = { noremap = true, silent = true }

    vim.keymap.set('n', 'n', [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], kopts)
    vim.keymap.set('n', 'N', [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]], kopts)
    vim.keymap.set('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
    vim.keymap.set('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
    vim.keymap.set('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
    vim.keymap.set('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)

    -- ESC для очистки подсветки поиска
    vim.keymap.set('n', '<Esc>', '<Cmd>noh<CR>', kopts)
  end,
}
