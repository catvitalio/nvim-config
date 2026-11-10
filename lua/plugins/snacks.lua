local function config()
  require('snacks').setup({
    lazygit = {
      enabled = true,
      configure = true,
      theme = {
        activeBorderColor = { fg = 'SnacksPickerMatch', bold = true },
        searchingActiveBorderColor = { fg = 'SnacksPickerMatch', bold = true },
        selectedLineBgColor = { bg = 'SnacksPickerListCursorLine' },
      },
      config = {
        os = {
          edit = 'nvim --server "$NVIM" --remote-send "<Esc><cmd>q<cr><cmd>e {{filename}}<cr>"',
        },
        git = {
          paging = {
            colorArg = 'always',
            pager = require('themes.delta').pager(),
          },
        },
        gui = {
          showBottomLine = false,
          showCommandLog = false,
        },
      },
      win = {
        border = 'none',
        width = 0.9999,
        height = 0.9999,
        style = {
          backdrop = false,
        },
      },
    },
    indent = {
      enabled = true,
      animate = {
        enabled = false,
      },
    },
    bigfile = {
      enabled = true,
      size = 10 * 1024 * 1024,
      line_length = 10000,
    },
    words = {
      enabled = true,
      debounce = 1,
    },
    picker = {
      enabled = true,
      layouts = {
        default = {
          layout = { backdrop = false },
        },
      },
    },
    terminal = {
      enabled = true,
      auto_insert = true,
      win = {
        keys = {
          term_normal = false,
          terminal_normal = {
            '<A-Esc>',
            function()
              vim.cmd.stopinsert()
            end,
            mode = 't',
            desc = 'Terminal normal mode',
          },
        },
      },
    },
  })
end

local function hide_others(skip_buf)
  for _, t in ipairs(Snacks.terminal.list()) do
    if t.buf ~= skip_buf and t:valid() then
      t:hide()
    end
  end
end

local float_win = {
  style = 'float',
  border = 'rounded',
  backdrop = false,
}

-- Snacks identifies a terminal by its command string: get() and toggle() must
-- receive the exact same string or a second terminal gets created.
local codex_cmd = 'sh -c "codex resume --last 2>/dev/null || codex"'

local function term_keys()
  local keys = {}
  for i = 1, 10 do
    local n = i % 10
    table.insert(keys, {
      '<M-S-' .. n .. '>',
      function()
        local existing = Snacks.terminal.get(nil, { count = i, create = false })
        hide_others(existing and existing.buf)
        Snacks.terminal.toggle(nil, {
          count = i,
          win = vim.tbl_extend(
            'force',
            float_win,
            { title = ' Terminal ' .. i .. ' ', title_pos = 'center' }
          ),
        })
      end,
      desc = 'Terminal ' .. i,
      mode = { 'n', 't' },
    })
  end
  return keys
end

return {
  'folke/snacks.nvim',
  lazy = false,
  priority = 1000,
  keys = vim.list_extend(term_keys(), {
    {
      '<A- >',
      function()
        local existing = Snacks.terminal.get(codex_cmd, { cwd = vim.fn.getcwd(), create = false })
        hide_others(existing and existing.buf)
        Snacks.terminal.toggle(codex_cmd, {
          cwd = vim.fn.getcwd(),
          win = vim.tbl_extend('force', float_win, { title = ' Codex ', title_pos = 'center' }),
        })
      end,
      desc = 'Codex',
      mode = { 'n', 't' },
    },
    {
      '<A-p>',
      function()
        Snacks.picker.smart()
      end,
      desc = 'Find files (smart)',
    },
    {
      '<A-f>',
      function()
        Snacks.picker.grep()
      end,
      desc = 'Live grep',
    },
    {
      'gr',
      function()
        Snacks.picker.lsp_references()
      end,
      desc = 'LSP references',
    },
    {
      'gd',
      function()
        Snacks.picker.lsp_definitions()
      end,
      desc = 'LSP definitions',
    },
    {
      '<A-g>',
      function()
        Snacks.lazygit()
      end,
      desc = '[g]it',
      mode = { 'n', 't' },
    },
    {
      '<A-G>',
      function()
        local line = vim.fn.line('.')
        local file = vim.fn.expand('%:p')
        local out = vim.fn.system(
          ('git blame -L %d,%d --porcelain -- %s'):format(line, line, vim.fn.shellescape(file))
        )
        local hash = out:match('^(%x+)')
        if not hash or hash:match('^0+$') then
          vim.notify('Line not committed yet', vim.log.levels.WARN)
          return
        end
        Snacks.lazygit({ args = { '--filter', file } })
        vim.schedule(function()
          vim.api.nvim_chan_send(vim.b.terminal_job_id, '/' .. hash .. '\r')
        end)
      end,
      desc = '[B]lame commit in lazygit',
    },
  }),
  config = config,
}
