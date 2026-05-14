return {
  'keaising/im-select.nvim',
  event = 'VeryLazy',
  config = function()
    local function executable(command)
      return vim.fn.executable(command) == 1
    end

    local function is_wsl()
      if vim.fn.has('wsl') == 1 then
        return true
      end

      local proc_version = vim.fn.filereadable('/proc/version') == 1
          and vim.fn.readfile('/proc/version', '', 1)[1]
        or ''

      return proc_version:lower():find('microsoft', 1, true) ~= nil
    end

    local function resolve_backend()
      if vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 or is_wsl() then
        if executable('im-select.exe') then
          return {
            default_im_select = '1033',
            default_command = 'im-select.exe',
          }
        end
      end

      if vim.fn.has('mac') == 1 or vim.fn.has('macunix') == 1 then
        if executable('macism') then
          return {
            default_im_select = 'com.apple.keylayout.ABC',
            default_command = 'macism',
          }
        end
      end

      if executable('fcitx5-remote') then
        return {
          default_im_select = 'keyboard-us',
          default_command = 'fcitx5-remote',
        }
      end

      if executable('fcitx-remote') then
        return {
          default_im_select = '1',
          default_command = 'fcitx-remote',
        }
      end

      if executable('ibus') then
        return {
          default_im_select = 'xkb:us::eng',
          default_command = 'ibus',
        }
      end
    end

    local backend = resolve_backend()
    if not backend then
      return
    end

    require('im_select').setup(vim.tbl_extend('force', backend, {
      set_default_events = { 'InsertLeave', 'CmdlineLeave' },
      set_previous_events = { 'InsertEnter' },
      keep_quiet_on_no_binary = true,
      async_switch_im = true,
    }))
  end,
}
