local function config(_, opts)
  require('avante').setup(opts)
end

return {
  'yetone/avante.nvim',
  build = vim.fn.has('win32') ~= 0
      and 'powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false'
    or 'make',
  event = 'VeryLazy',
  version = false,
  cmd = {
    'AvanteAsk',
    'AvanteBuild',
    'AvanteChat',
    'AvanteChatNew',
    'AvanteClear',
    'AvanteEdit',
    'AvanteFocus',
    'AvanteHistory',
    'AvanteModels',
    'AvanteRefresh',
    'AvanteStop',
    'AvanteSwitchProvider',
    'AvanteToggle',
  },
  keys = {
    {
      '<A-a>',
      '<cmd>AvanteToggle<cr>',
      desc = '[a]vante toggle',
    },
    {
      '<A-o>',
      '<cmd>AvanteAsk<cr>',
      mode = { 'n', 'v' },
      desc = 'Avante ask',
    },
    {
      '<A-i>',
      '<cmd>AvanteEdit<cr>',
      mode = { 'v' },
      desc = 'Avante [i]nline edit',
    },
    {
      '<A-h>',
      '<cmd>AvanteHistory<cr>',
      desc = 'Avante [h]istory',
    },
  },
  opts = {
    provider = 'codex',
    mode = 'agentic',
    acp_providers = {
      codex = {
        command = 'codex-acp',
        args = {},
        env = {
          NODE_NO_WARNINGS = '1',
        },
      },
    },
    behaviour = {
      auto_focus_sidebar = true,
      auto_suggestions = false,
      auto_set_keymaps = false,
      auto_set_highlight_group = true,
      auto_apply_diff_after_generation = false,
      minimize_diff = true,
      auto_add_current_file = true,
      auto_approve_tool_permissions = false,
    },
    input = {
      provider = 'snacks',
      provider_opts = {
        title = 'Avante',
      },
    },
    mappings = {
      ask = '<A-o>',
      new_ask = '<A-n>',
      zen_mode = '<A-z>',
      edit = '<A-i>',
      refresh = '<A-r>',
      focus = '<A-j>',
      stop = '<A-S>',
      select_history = '<A-h>',
      toggle = {
        default = '<A-a>',
        debug = '<A-x>',
        suggestion = '<A-u>',
      },
      sidebar = {
        close = { 'q', '<Esc>' },
        close_from_input = {
          normal = '<Esc>',
        },
      },
    },
    windows = {
      position = 'right',
      width = 35,
      sidebar_header = {
        enabled = true,
        rounded = true,
        align = 'center',
        include_model = true,
      },
      input = {
        height = 8,
      },
      ask = {
        floating = true,
        border = 'rounded',
        start_insert = true,
      },
    },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    'nvim-tree/nvim-web-devicons',
    'folke/snacks.nvim',
  },
  config = config,
}
