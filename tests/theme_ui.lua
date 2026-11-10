local function check_ui()
  vim.api.nvim_exec_autocmds('UIEnter', {})
  vim.wait(100)
  local ui = require('themes.ui')
  local function hl(g)
    return vim.api.nvim_get_hl(0, { name = g, link = false })
  end
  local function num(c)
    return tonumber(c:sub(2), 16)
  end
  local function check(label)
    local p = ui.palette()
    for _, g in ipairs({
      'NormalFloat',
      'NormalNC',
      'SnacksPickerPreview',
      'BufferCurrent',
      'BufferInactive',
      'lualine_a_normal',
      'lualine_c_normal',
    }) do
      assert(hl(g).bg == num(p.background), label .. ' background ' .. g)
    end
    for _, g in ipairs({
      'BufferCurrentSign',
      'BufferCurrentSignRight',
      'CmdlineMatch',
      'SnacksPickerMatch',
      'lualine_a_normal',
    }) do
      assert(hl(g).fg == 0x6a8cbc, label .. ' accent ' .. g)
    end
    for _, g in ipairs({ 'BufferInactive', 'lualine_c_normal', 'Whitespace', 'SnacksIndent' }) do
      assert(hl(g).fg == num(p.muted), label .. ' muted ' .. g)
    end
    assert(hl('PmenuSel').bg == hl('SnacksPickerListCursorLine').bg)
    assert(hl('ScrollbarTrack').bg == num(p.background), label .. ' scrollbar track')
    assert(hl('ScrollbarThumb').bg == num(p.muted), label .. ' scrollbar thumb')
    assert(hl('ScrollbarThumb').blend == 30, label .. ' scrollbar thumb transparency')
    assert(hl('Visual').bg == hl('LspReferenceText').bg)
    assert(Snacks.config.lazygit.config.git.paging.pager == require('themes.delta').pager())
    local _, icon = require('nvim-web-devicons').get_icon_color('a.py', 'py', { default = true })
    assert(icon == string.format('#%06x', hl('DiagnosticWarn').fg))
  end
  check('initial')
  vim.o.columns = 180
  vim.o.lines = 50
  vim.cmd('edit lua/plugins/snacks.lua')
  local explorer = Snacks.picker.explorer()
  vim.wait(500, function()
    return explorer.list.win:win_valid() and explorer.preview.win:win_valid()
  end)
  assert(explorer.list.win:win_valid())
  assert(explorer.preview.win:win_valid())
  check('Snacks explorer')
  explorer:close()
  assert(vim.fn.exists(':Neotree') == 0)
  vim.cmd.colorscheme('habamax')
  vim.wait(100)
  check('habamax')
  vim.o.background = 'light'
  vim.cmd.colorscheme('default')
  vim.wait(100)
  check('light')
  vim.api.nvim_set_hl(0, 'Normal', { fg = 0x202020 })
  vim.g.colors_name = 'transparent-test'
  vim.api.nvim_exec_autocmds('ColorScheme', { pattern = 'transparent-test' })
  vim.wait(100)
  check('transparent')
  assert(ui.palette().background == '#ffffff')
  vim.o.background = 'dark'
  vim.cmd.colorscheme('habamax')
  vim.cmd.colorscheme('obscure')
  vim.wait(100)
  check('rapid switch')
  vim.api.nvim_set_hl(0, 'SnacksPickerPreview', { bg = 0xff0000 })
  vim.api.nvim_exec_autocmds('User', { pattern = 'LazyLoad' })
  vim.wait(100)
  check('late plugin update')
  ui.setup({ active_color = '#123456' })
  assert(hl('lualine_a_normal').fg == 0x123456)
  assert(hl('BufferCurrentSign').fg == 0x123456)
  assert(not pcall(ui.setup, { active_color = 'invalid' }))
  assert(ui.palette().active == '#123456')
  ui.setup({ active_color = '#6a8cbc' })
  check('accent setting')
  local p = ui.palette()
  local patch =
    'diff --git a/a.py b/a.py\n--- a/a.py\n+++ b/a.py\n@@ -1 +1 @@\n-value = 1\n+value = 2\n'
  local out = vim.fn.system(require('themes.delta').pager(), patch)
  assert(vim.v.shell_error == 0, out)
  for _, c in ipairs({ p.added, p.removed }) do
    local v = num(c)
    local ansi = string.format(
      '48;2;%d;%d;%d',
      bit.rshift(v, 16),
      bit.band(bit.rshift(v, 8), 255),
      bit.band(v, 255)
    )
    assert(out:find(ansi, 1, true), c)
  end
  print('Theme UI: startup, theme switches, fallbacks, late plugins, accent, icons and delta OK')
end

local ok, err = xpcall(check_ui, debug.traceback)
if not ok then
  vim.api.nvim_err_writeln(err)
  vim.cmd('cquit 1')
end
