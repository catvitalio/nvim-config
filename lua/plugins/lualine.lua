local function config()
  local lualine = require('lualine')

  local filename = {
    'filename',
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
      lualine_x = {
        {
          function()
            local api = require('supermaven-nvim.api')
            if api.is_running() then
              return '󰚩'
            else
              return ''
            end
          end,
        },
      },
      lualine_y = { 'location' },
      lualine_z = {},
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
  lazy = false,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = config,
}
