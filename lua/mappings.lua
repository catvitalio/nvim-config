-- Leader
vim.g.mapleader = ' '

-- Hotkey options
local opts = {
  noremap = true,
  silent = true,
}

-- NeoTree
vim.keymap.set('n', '<leader>e', ':Neotree float reveal<CR>', opts)
vim.keymap.set('n', '<leader>g', ':Neotree git_status reveal<CR>', opts)

-- Tabs (via buffers)
vim.keymap.set('n', '<leader>[', '<Cmd>BufferPrevious<CR>', opts)
vim.keymap.set('n', '<leader>]', '<Cmd>BufferNext<CR>', opts)
vim.keymap.set('n', '<leader>1', '<Cmd>BufferGoto 1<CR>', opts)
vim.keymap.set('n', '<leader>2', '<Cmd>BufferGoto 2<CR>', opts)
vim.keymap.set('n', '<leader>3', '<Cmd>BufferGoto 3<CR>', opts)
vim.keymap.set('n', '<leader>4', '<Cmd>BufferGoto 4<CR>', opts)
vim.keymap.set('n', '<leader>5', '<Cmd>BufferGoto 5<CR>', opts)
vim.keymap.set('n', '<leader>6', '<Cmd>BufferGoto 6<CR>', opts)
vim.keymap.set('n', '<leader>7', '<Cmd>BufferGoto 7<CR>', opts)
vim.keymap.set('n', '<leader>8', '<Cmd>BufferGoto 8<CR>', opts)
vim.keymap.set('n', '<leader>9', '<Cmd>BufferGoto 9<CR>', opts)
vim.keymap.set('n', '<leader>w', '<Cmd>bd<CR>', opts)
vim.keymap.set('n', '<leader><C-w>', '<Cmd>bd!<CR>', opts)
vim.keymap.set('n', '<leader>t', '<Cmd>BufReopen<CR>', opts)

-- Telescope
local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>ff', builtin.find_files, opts)
vim.keymap.set('n', '<leader>fw', builtin.live_grep, opts)
vim.keymap.set('n', 'gr', builtin.lsp_references, opts)
vim.keymap.set('n', 'gd', builtin.lsp_definitions, opts)
vim.keymap.set('n', '<leader>.', vim.lsp.buf.code_action, opts)

-- Format and save
vim.keymap.set('n', '<leader>s', ':Format<CR>:w<CR>', opts)

-- Debugger
vim.keymap.set('n', '<leader>d', require('dapui').toggle, opts)
