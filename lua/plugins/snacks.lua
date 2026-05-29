local function config()
  require('snacks').setup({
    lazygit = {
      enabled = true,
      configure = true,
      config = {
        os = {
          edit = 'nvim --server "$NVIM" --remote-send "<Esc><cmd>q<cr><cmd>e {{filename}}<cr>"',
        },
        git = {
          paging = {
            colorArg = 'always',
            pager = 'delta --dark --paging=never',
          },
        },
        gui = {
          showBottomLine = false,
          showCommandLog = false,
        },
      },
      win = {
        border = 'none',
        width = 0.96,
        height = 0.96,
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
      size = 1.5 * 1024 * 1024, -- 1.5mb
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
  })
end

return {
  'folke/snacks.nvim',
  lazy = false,
  priority = 1000,
  keys = {
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
  },
  config = config,
}
