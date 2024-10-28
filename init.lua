if not vim.g.vscode then
  require('plugins')
  require('core')
else
  vim.opt.clipboard:append('unnamedplus')
end
