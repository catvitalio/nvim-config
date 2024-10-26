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
  require('plugins.themes'),
  require('plugins.barbar'),
  require('plugins.telescope'),
  require('plugins.mason'),
  require('plugins.cmp'),
  require('plugins.lsp'),
  require('plugins.lint'),
  require('plugins.conform'),
  require('plugins.neotree'),
  require('plugins.treesitter'),
  require('plugins.gitsigns'),
  require('plugins.lazygit'),
  require('plugins.lualine'),
  require('plugins.supermaven'),
})
