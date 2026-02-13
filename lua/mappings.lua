-- Leader
vim.g.mapleader = ' '

-- Hotkey options
local opts = {
  noremap = true,
  silent = true,
}

-- LazyGit (via Snacks)
vim.keymap.set('n', '<A-g>', function()
  Snacks.lazygit()
end, { desc = '[g]it' })

-- Tabs (via buffers)
vim.keymap.set('n', '<A-[>', '<Cmd>BufferPrevious<CR>', opts)
vim.keymap.set('n', '<A-]>', '<Cmd>BufferNext<CR>', opts)
vim.keymap.set('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', opts)
vim.keymap.set('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', opts)
vim.keymap.set('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', opts)
vim.keymap.set('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', opts)
vim.keymap.set('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', opts)
vim.keymap.set('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', opts)
vim.keymap.set('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', opts)
vim.keymap.set('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', opts)
vim.keymap.set('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', opts)
vim.keymap.set('n', '<A-0>', '<Cmd>BufferGoto 10<CR>', opts)
vim.keymap.set('n', '<A-w>', '<Cmd>bd<CR>', opts)
vim.keymap.set('n', '<A-S-w>', '<Cmd>bd!<CR>', opts)
vim.keymap.set('n', '<A-S-t>', '<Cmd>BufReopen<CR>', opts)

-- LSP
vim.keymap.set('n', 'ca', vim.lsp.buf.code_action, opts)

-- Format and save
vim.keymap.set('n', '<A-s>', ':Format<CR>:w<CR>', opts)

-- Debugger
vim.keymap.set('n', '<A-d>', require('dapui').toggle, opts)
vim.keymap.set('n', '<A-b>', '<Cmd>DapToggleBreakpoint<CR>', opts)
