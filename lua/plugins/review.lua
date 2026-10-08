return {
  'meowshed/meow.review.nvim',
  dependencies = { 'MunifTanjim/nui.nvim' },
  cmd = { 'MeowReview' },
  lazy = false,
  keys = {
    { '<A-r>',   '<Plug>(MeowReviewAdd)',     mode = { 'n', 'x' }, desc = 'Add review annotation' },
    { '<M-S-r>', '<Plug>(MeowReviewResolve)', mode = 'n', desc = 'Resolve review annotation' },
    { '<M-S-d>', '<Plug>(MeowReviewDelete)',  mode = 'n', desc = 'Delete review annotation' },
    { ']r',      '<Plug>(MeowReviewNext)',               desc = 'Next annotation' },
    { '[r',      '<Plug>(MeowReviewPrev)',               desc = 'Prev annotation' },
  },
  config = function()
    require('meow.review').setup({
      context_lines = 3,
      auto_gitignore = false,
      annotation_types = {
        ISSUE      = { icon = '!', hl = 'DiagnosticError', label = 'ISSUE' },
        SUGGESTION = { icon = '?', hl = 'DiagnosticWarn',  label = 'SUGGESTION' },
        NOTE       = { icon = '·', hl = 'DiagnosticInfo',  label = 'NOTE' },
      },
    })

    -- Normal-mode shortcuts inside the annotation modal (floating markdown popup)
    vim.api.nvim_create_autocmd('BufWinEnter', {
      callback = function(ev)
        local win = vim.api.nvim_get_current_win()
        if vim.api.nvim_win_get_config(win).relative == '' then return end
        if vim.bo[ev.buf].filetype ~= 'markdown' then return end
        if not vim.bo[ev.buf].modifiable then return end
        local opts = { buffer = ev.buf, nowait = true }
        vim.keymap.set('i', '<A-s>', '<C-s>', vim.tbl_extend('force', opts, { remap = true }))
        vim.keymap.set('i', '<A-t>', '<C-t>', vim.tbl_extend('force', opts, { remap = true }))
        vim.keymap.set('i', '<A-c>', '<C-c>', vim.tbl_extend('force', opts, { remap = true }))
        -- Russian layout equivalents (ы=s, е=t, с=c)
        vim.keymap.set('i', '<A-ы>', '<C-s>', vim.tbl_extend('force', opts, { remap = true }))
        vim.keymap.set('i', '<A-е>', '<C-t>', vim.tbl_extend('force', opts, { remap = true }))
        vim.keymap.set('i', '<A-с>', '<C-c>', vim.tbl_extend('force', opts, { remap = true }))
      end,
    })
  end,
}
