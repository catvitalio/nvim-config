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
      annotation_types = {
        ISSUE      = { icon = '!', hl = 'DiagnosticError', label = 'ISSUE' },
        SUGGESTION = { icon = '?', hl = 'DiagnosticWarn',  label = 'SUGGESTION' },
        NOTE       = { icon = '·', hl = 'DiagnosticInfo',  label = 'NOTE' },
      },
    })
  end,
}
