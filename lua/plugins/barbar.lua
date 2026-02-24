local function config()
  require('barbar').setup({
    icons = {
      buffer_index = true,
    },
    animation = false,
    no_name_title = 'untitled',
    auto_hide = true,
  })
end

return {
  {
    'romgrk/barbar.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    lazy = false,
    keys = {
      { '<A-[>', '<Cmd>BufferPrevious<CR>', desc = 'Buffer Previous' },
      { '<A-]>', '<Cmd>BufferNext<CR>', desc = 'Buffer Next' },
      { '<A-1>', '<Cmd>BufferGoto 1<CR>', desc = 'Buffer Goto 1' },
      { '<A-2>', '<Cmd>BufferGoto 2<CR>', desc = 'Buffer Goto 2' },
      { '<A-3>', '<Cmd>BufferGoto 3<CR>', desc = 'Buffer Goto 3' },
      { '<A-4>', '<Cmd>BufferGoto 4<CR>', desc = 'Buffer Goto 4' },
      { '<A-5>', '<Cmd>BufferGoto 5<CR>', desc = 'Buffer Goto 5' },
      { '<A-6>', '<Cmd>BufferGoto 6<CR>', desc = 'Buffer Goto 6' },
      { '<A-7>', '<Cmd>BufferGoto 7<CR>', desc = 'Buffer Goto 7' },
      { '<A-8>', '<Cmd>BufferGoto 8<CR>', desc = 'Buffer Goto 8' },
      { '<A-9>', '<Cmd>BufferGoto 9<CR>', desc = 'Buffer Goto 9' },
      { '<A-0>', '<Cmd>BufferGoto 10<CR>', desc = 'Buffer Goto 10' },
      { '<A-w>', '<Cmd>bd<CR>', desc = 'Buffer Delete' },
      { '<A-S-w>', '<Cmd>bd!<CR>', desc = 'Buffer Delete Force' },
      { '<A-S-t>', '<Cmd>BufReopen<CR>', desc = 'Buffer Reopen' },
    },
    config = config,
    version = '^1.0.0',
  },
}
