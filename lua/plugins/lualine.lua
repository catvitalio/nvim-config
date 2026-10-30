local _codex = { started_at = 0, working = false }

local function init_codex_monitor()
  local path = vim.fn.expand('~/.codex/nvim-status')

  local function write_status(state)
    local f = io.open(path, 'w')
    if f then f:write(state); f:close() end
  end

  vim.api.nvim_create_autocmd('TermOpen', {
    callback = function(ev)
      -- Matches the codex terminal command from plugins/snacks.lua.
      if not vim.api.nvim_buf_get_name(ev.buf):find('codex resume --last', 1, true) then return end
      vim.keymap.set('t', '<Esc>', function()
        write_status('idle')
        local job_id = vim.b[ev.buf].terminal_job_id
        if job_id then vim.api.nvim_chan_send(job_id, '\27') end
      end, { buffer = ev.buf })
      -- A codex that dies mid-run never reports idle, and the indicator would
      -- spin until the next run rewrites the file.
      vim.api.nvim_create_autocmd('TermClose', {
        buffer = ev.buf,
        callback = function()
          write_status('idle')
        end,
      })
    end,
  })
  local timer = vim.uv.new_timer()
  timer:start(0, 60, vim.schedule_wrap(function()
    local f = io.open(path, 'r')
    local prev = _codex.working
    _codex.working = f and vim.startswith(vim.trim(f:read('*a')), 'working') or false
    if f then f:close() end
    if _codex.working then
      if not prev then _codex.started_at = vim.uv.hrtime() end
      require('lualine').refresh({ scope = 'all', place = { 'statusline' } })
    elseif prev then
      require('lualine').refresh({ scope = 'all', place = { 'statusline' } })
    end
  end))
end

local codex_component = {
  function()
    return '•'
  end,
  color = function()
    if not _codex.working then return 'CodexIdle' end
    local hl = vim.api.nvim_get_hl(0, { name = 'CodexWorking', link = false })
    if not hl.fg or not hl.bg then return 'CodexWorking' end
    local elapsed = (vim.uv.hrtime() - _codex.started_at) / 1e9
    local distance = math.abs(10 - math.floor((elapsed % 2) / 2 * 21))
    local intensity = distance <= 5 and 0.5 * (1 + math.cos(math.pi * distance / 5)) or 0
    local fade = intensity * 0.9
    local function channel(shift)
      local fg = bit.band(bit.rshift(hl.fg, shift), 255)
      local bg = bit.band(bit.rshift(hl.bg, shift), 255)
      return math.floor(fg * (1 - fade) + bg * fade + 0.5)
    end
    return {
      fg = string.format('#%02x%02x%02x', channel(16), channel(8), channel(0)),
      bg = string.format('#%06x', hl.bg),
      gui = 'bold',
    }
  end,
  padding = 0,
}

local function config()
  local lualine = require('lualine')
  init_codex_monitor()

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
      lualine_z = { codex_component },
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
