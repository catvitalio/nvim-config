local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local lazy = require('lazy')

lazy.setup({
  require('plugins.neotree'),
  require('plugins.cmdline'),
  require('plugins.barbar'),
  require('plugins.bufstack'),
  require('plugins.lualine'),
  require('plugins.themes'),
  require('plugins.telescope'),
  require('plugins.treesitter'),
  require('plugins.treesitter-context'),
  require('plugins.colorizer'),
  require('plugins.gitsigns'),
  require('plugins.blink'),
  require('plugins.lsp'),
  require('plugins.format'),
  require('plugins.lint'),
  require('plugins.comment'),
  require('plugins.debug'),
  require('plugins.conflict'),
  require('plugins.scrollbar'),
  require('plugins.supermaven'),
})
