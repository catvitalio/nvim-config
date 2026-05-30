return {
  {
    'saghen/blink.compat',
    version = '*',
    lazy = true,
  },
  {
    'saghen/blink.cmp',
    event = 'InsertEnter',
    version = '1.*',
    opts = {
      keymap = { preset = 'enter', ['<C-Space>'] = { 'show', 'hide' } },
      appearance = { nerd_font_variant = 'mono' },
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 0,
          window = { border = 'rounded' },
        },
        menu = {
          border = 'rounded',
          draw = {
            treesitter = { 'lsp' },
            columns = {
              { 'label', gap = 1 },
              { 'kind_icon' },
              { 'kind' },
            },
          },
        },
      },
      cmdline = { enabled = false },

      sources = {
        default = { 'lsp', 'path', 'buffer' },
      },

      fuzzy = { implementation = 'prefer_rust_with_warning' },
    },
    opts_extend = { 'sources.default' },
  },
}
