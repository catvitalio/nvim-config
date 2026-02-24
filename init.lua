if not vim.g.vscode then
  require('plugins')
  require('settings')
else
  vim.opt.clipboard:append('unnamedplus')
end
