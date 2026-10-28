local _claude = { frames = { '·', '✻', '✽', '✶', '✳', '✢', '✳', '✶', '✽', '✻' }, idx = 1, working = false }

local function init_claude_monitor()
  local path = vim.fn.expand('~/.claude/nvim-status')

  vim.api.nvim_create_autocmd('TermOpen', {
    callback = function(ev)
      if not vim.api.nvim_buf_get_name(ev.buf):find('claude', 1, true) then return end
      vim.keymap.set('t', '<Esc>', function()
        local f = io.open(path, 'w')
        if f then f:write('idle'); f:close() end
        local job_id = vim.b[ev.buf].terminal_job_id
        if job_id then vim.api.nvim_chan_send(job_id, '\27') end
      end, { buffer = ev.buf })
    end,
  })
  local timer = vim.uv.new_timer()
  timer:start(0, 120, vim.schedule_wrap(function()
    local f = io.open(path, 'r')
    local prev = _claude.working
    _claude.working = f and vim.startswith(vim.trim(f:read('*a')), 'working') or false
    if f then f:close() end
    if _claude.working then
      _claude.idx = (_claude.idx % #_claude.frames) + 1
      require('lualine').refresh({ scope = 'all', place = { 'statusline' } })
    elseif prev then
      require('lualine').refresh({ scope = 'all', place = { 'statusline' } })
    end
  end))
end

local claude_component = {
  function()
    return _claude.working and _claude.frames[_claude.idx] or '✻'
  end,
  color = function()
    return _claude.working and 'ClaudeWorking' or 'ClaudeIdle'
  end,
  padding = 0,
}

local function config()
  local lualine = require('lualine')
  init_claude_monitor()

  local filename = {
    'filename',
    cond = function()
      local ft = vim.bo.filetype
      return vim.bo.buftype ~= 'terminal'
        and ft ~= 'neo-tree'
        and not ft:match('^snacks_picker')
    end,
    path = 1,
    separator = { left = '', right = '' },
    symbols = {
      modified = '',
      readonly = '',
      unnamed = 'untitled',
      newfile = 'untitled',
    },
    fmt = function(str)
      local devicons = require('nvim-web-devicons')
      local parts = vim.split(str, '/', { plain = true })
      local formatted_parts = {}

      for i, part in ipairs(parts) do
        if i == #parts then
          local icon, _ =
            devicons.get_icon(part, vim.fn.fnamemodify(part, ':e'), { default = true })
          table.insert(formatted_parts, (icon or '') .. ' ' .. part)
        elseif part == '' then
          table.insert(formatted_parts, '/')
        else
          table.insert(formatted_parts, '󰉋 ' .. part)
        end
      end

      return table.concat(formatted_parts, ' > ')
    end,
  }

  lualine.setup({
    options = {
      globalstatus = true,
      component_separators = '',
      section_separators = '',
      disabled_filetypes = {
        statusline = {
          'dapui_scopes',
          'dapui_breakpoints',
          'dapui_stacks',
          'dapui_watches',
          'dapui_console',
          'dap-repl',
        },
        winbar = {},
      },
    },
    sections = {
      lualine_a = {
        {
          'mode',
          fmt = function(str)
            return str:sub(1, 1)
          end,
        },
      },
      lualine_b = {},
      lualine_c = {
        '%=',
        filename,
      },
      lualine_x = {},
      lualine_y = {},
      lualine_z = { claude_component },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },
    tabline = {},
    extensions = {},
  })
end

return {
  'nvim-lualine/lualine.nvim',
  event = 'UIEnter',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = config,
}
