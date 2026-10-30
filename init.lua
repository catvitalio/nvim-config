vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

if not vim.g.vscode then
  require('plugins')
  require('settings')
else
  vim.opt.clipboard:append('unnamedplus')
end
