local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local lazy = require('lazy')

lazy.setup({
  require('themes.vscode')(),
  require('plugins.neotree'),
  require('plugins.cmdline'),
  require('plugins.barbar'),
  require('plugins.bufstack'),
  require('plugins.lualine'),
  require('plugins.telescope'),
  require('plugins.treesitter'),
  require('plugins.colorizer'),
  require('plugins.gitsigns'),
  require('plugins.snacks'),
  require('plugins.blink'),
  require('plugins.lsp'),
  require('plugins.format'),
  require('plugins.lint'),
  require('plugins.comment'),
  require('plugins.debug'),
  require('plugins.conflict'),
  require('plugins.scrollbar'),
  require('plugins.supermaven'),
  require('plugins.hlslens'),
}, {
  performance = {
    cache = {
      enabled = true,
    },
    rtp = {
      disabled_plugins = {
        'gzip',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
})
