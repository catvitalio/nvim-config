local M = {}

function M.pager()
  local function color(group, attr, fallback)
    local value = vim.api.nvim_get_hl(0, { name = group, link = false })[attr]
    return value and string.format('#%06x', value) or fallback
  end
  local bg = color('Normal', 'bg', vim.o.background == 'dark' and '#000000' or '#ffffff')
  local fg = color('Normal', 'fg', vim.o.background == 'dark' and '#ffffff' or '#000000')
  local flavour = (vim.g.colors_name or ''):match('^catppuccin%-(%a+)$')
  local names = { mocha = 'Mocha', frappe = 'Frappe', macchiato = 'Macchiato', latte = 'Latte' }
  local syntax = vim.g.colors_name == 'graphite' and 'Catppuccin Mocha'
    or names[flavour] and ('Catppuccin ' .. names[flavour]) or 'none'
  local text = syntax ~= 'none' and 'syntax' or fg
  local function style(group, fallback)
    return text .. ' ' .. color(group, 'bg', fallback or bg)
  end
  local options = {
    { '--syntax-theme', syntax },
    { '--minus-style', style('GitSignsDeleteVirtLn', color('DiffDelete', 'bg', bg)) },
    { '--plus-style', style('GitSignsAddLn', color('DiffAdd', 'bg', bg)) },
    { '--minus-emph-style', style('GitSignsDeleteInline', color('DiffText', 'bg', bg)) },
    { '--plus-emph-style', style('GitSignsAddInline', color('DiffText', 'bg', bg)) },
    { '--zero-style', text .. ' ' .. bg },
  }
  local args = { 'delta', '--' .. vim.o.background, '--paging=never', '--true-color=always' }
  for _, option in ipairs(options) do
    args[#args + 1] = option[1]
    args[#args + 1] = vim.fn.shellescape(option[2])
  end
  return table.concat(args, ' ')
end

return M
