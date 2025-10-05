vim.cmd.colorscheme('vscode')
vim.o.termguicolors = true
vim.opt.showmode = false
vim.opt.updatetime = 100
vim.opt.scrolloff = 8
vim.opt.wrap = false
vim.opt.virtualedit = 'block'
vim.opt.undofile = true
vim.o.mousemoveevent = true
vim.opt.fillchars = { eob = ' ' }
vim.opt.termsync = false

-- Fix color around borders
vim.api.nvim_set_hl(0, 'NormalFloat', { link = 'Normal' })
vim.api.nvim_set_hl(0, 'FloatBorder', { link = 'Normal' })

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

-- Diagnostic
vim.fn.sign_define('DiagnosticSignError', { text = '', texthl = 'DiagnosticSignError' })
vim.fn.sign_define('DiagnosticSignWarn', { text = '', texthl = 'DiagnosticSignWarn' })
vim.fn.sign_define('DiagnosticSignHint', { text = '', texthl = 'DiagnosticSignHint' })
vim.fn.sign_define('DiagnosticSignInfo', { text = '', texthl = 'DiagnosticSignInfo' })

vim.diagnostic.config({
  float = { source = 'always' },
  signs = false,
  virtual_text = false,
  severity_sort = true,
  current_line_virt = true,
})

-- Invisible symbols
vim.opt.list = true
vim.opt.listchars = {
  space = '·',
  tab = '→ ',
  trail = '·',
}

-- Hover diagnostics
vim.api.nvim_create_autocmd({ 'CursorHold' }, {
  pattern = '*',
  callback = function()
    for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
      if vim.api.nvim_win_get_config(winid).zindex then
        return
      end
    end
    vim.diagnostic.open_float({
      scope = 'cursor',
      border = 'rounded',
      focusable = false,
      close_events = {
        'CursorMoved',
        'CursorMovedI',
        'BufHidden',
        'InsertCharPre',
        'WinLeave',
      },
    })
  end,
})

-- NeoTree
vim.api.nvim_set_hl(0, 'NeoTreeIndentMarker', { fg = '#5a5a5a' })
