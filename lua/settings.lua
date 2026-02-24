vim.o.termguicolors = true
vim.o.mousemoveevent = true
vim.opt.termsync = false
vim.opt.scrolloff = 8
vim.opt.updatetime = 300
vim.opt.wrap = false
vim.opt.virtualedit = 'block'
vim.opt.undofile = true

-- Separators
vim.opt.fillchars = {
  eob = ' ',
  vert = '│',
  horiz = '─',
  diff = '╱',
}

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Turn off standard status line
vim.opt.showmode = false

-- Hide cmd line
vim.opt.cmdheight = 0

-- Mouse
vim.opt.mouse = 'a'
vim.opt.mousefocus = true

-- Line Numbers
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.cursorline = true
vim.opt.cursorlineopt = 'number'

-- Status column (only when number is enabled in the target window)
_G.statuscol = function()
  local win = vim.g.statusline_winid or 0
  local buf = vim.api.nvim_win_get_buf(win)
  if vim.bo[buf].buftype ~= '' then
    return ''
  end
  if not vim.wo[win].number then
    return ''
  end
  return '%s%C%=%{v:relnum ? v:lnum : virtcol(".")} '
end
vim.opt.statuscolumn = '%!v:lua.statuscol()'

-- Splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Clipboard
vim.opt.clipboard = 'unnamedplus'
vim.g.clipboard = {
  name = 'OSC 52',
  copy = {
    ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
    ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
  },
  paste = {
    ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
    ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
  },
}

-- Shorter messages
vim.opt.shortmess:append('cI')

-- Indent Settings
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.smartindent = true

-- Invisible symbols
vim.opt.list = true
vim.opt.listchars = {
  space = ' ',
  tab = '→ ',
  trail = ' ',
}

-- Sensitive files
vim.filetype.add({
  pattern = {
    -- Keys and certificates
    ['.*/.ssh/.*'] = 'sensitive',
    ['.*/id_rsa.*'] = 'sensitive',
    ['.*/id_ed25519.*'] = 'sensitive',
    ['.*/id_ecdsa.*'] = 'sensitive',
    ['.*/id_dsa.*'] = 'sensitive',
    ['.*%.pem'] = 'sensitive',
    ['.*%.key'] = 'sensitive',
    ['.*%.p12'] = 'sensitive',
    ['.*%.pfx'] = 'sensitive',
    ['.*%.asc'] = 'sensitive',
    ['.*%.gpg'] = 'sensitive',
    ['.*%.pgp'] = 'sensitive',
    ['.*%.keystore'] = 'sensitive',
    ['.*%.jks'] = 'sensitive',
    ['.*%.kdbx'] = 'sensitive',
    -- Configs with secrets
    ['.*%.env.*'] = 'sensitive',
    ['.*%.secret'] = 'sensitive',
    ['.*%.secrets'] = 'sensitive',
    ['.*%.tfvars'] = 'sensitive',
    ['.*/.aws/.*'] = 'sensitive',
    ['.*/.gnupg/.*'] = 'sensitive',
    ['.*/.kube/config'] = 'sensitive',
    ['.*/.docker/config%.json'] = 'sensitive',
    ['.*/.netrc'] = 'sensitive',
    ['.*/.npmrc'] = 'sensitive',
  },
})

-- Diagnostics
vim.fn.sign_define('DiagnosticSignError', { text = '', texthl = 'DiagnosticSignError' })
vim.fn.sign_define('DiagnosticSignWarn', { text = '', texthl = 'DiagnosticSignWarn' })
vim.fn.sign_define('DiagnosticSignHint', { text = '', texthl = 'DiagnosticSignHint' })
vim.fn.sign_define('DiagnosticSignInfo', { text = '', texthl = 'DiagnosticSignInfo' })
vim.diagnostic.config({
  float = {
    source = 'always',
    border = 'rounded',
  },
  signs = false,
  virtual_text = false,
  severity_sort = true,
  current_line_virt = true,
})

-- Hover diagnostics
vim.api.nvim_create_autocmd({ 'CursorHold' }, {
  pattern = '*',
  callback = function()
    vim.diagnostic.open_float({
      scope = 'cursor',
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
