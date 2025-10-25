-- Leader
vim.g.mapleader = ' '

-- Hotkey options
local opts = {
  noremap = true,
  silent = true,
}

-- NeoTree
vim.keymap.set('n', '<A-e>', ':Neotree float reveal<CR>', opts)

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

-- Telescope
local builtin = require('telescope.builtin')

vim.keymap.set('n', 'ff', builtin.find_files, opts)
vim.keymap.set('n', 'fw', builtin.live_grep, opts)
vim.keymap.set('n', 'gr', builtin.lsp_references, opts)
vim.keymap.set('n', 'gd', builtin.lsp_definitions, opts)
vim.keymap.set('n', 'ca', vim.lsp.buf.code_action, opts)

-- Format and save
vim.keymap.set('n', '<A-s>', ':Format<CR>:w<CR>', opts)

-- Debugger
vim.keymap.set('n', '<A-d>', require('dapui').toggle, opts)

-- Supermaven toggle
vim.keymap.set('n', '<leader>sm', function()
  local api = require('supermaven-nvim.api')
  if api.is_running() then
    api.stop()
    print('Supermaven stopped')
  else
    api.start()
    print('Supermaven started')
  end
end, opts)
