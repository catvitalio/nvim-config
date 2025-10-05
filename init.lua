if not vim.g.vscode then
  require('plugins')
  require('mappings')
  require('settings')
else
  vim.opt.clipboard:append('unnamedplus')
end
