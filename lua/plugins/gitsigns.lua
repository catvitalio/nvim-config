return {
  'lewis6991/gitsigns.nvim',
  commit = '5be654f2232c10ddcad19c1607a67b6b4b78fc29',
  event = { 'BufReadPre', 'BufNewFile' },
  keys = {
    { '<A-i>', '<cmd>Gitsigns preview_hunk_inline<cr>', desc = 'Git preview hunk inline' },
  },
  config = function()
    require('gitsigns').setup({
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol',
        delay = 1,
        ignore_whitespace = false,
        virt_text_priority = 100,
      },
    })
  end,
}
