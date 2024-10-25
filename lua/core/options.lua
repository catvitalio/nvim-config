vim.cmd.colorscheme('vscode_modern')
vim.opt.showmode = false
vim.opt.updatetime = 100
vim.opt.scrolloff = 8
vim.opt.wrap = false
vim.opt.virtualedit = 'block'
vim.opt.undofile = true
vim.o.mousemoveevent = true

-- Mouse
vim.opt.mouse = 'a'
vim.opt.mousefocus = true

-- Line Numbers
vim.opt.number = true
vim.opt.relativenumber = false

-- Splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Clipboard
vim.opt.clipboard = 'unnamedplus'

-- Shorter messages
vim.opt.shortmess:append('c')

-- Indent Settings
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.smartindent = true
