return {
  {
    'saghen/blink.compat',
    version = '*',
    lazy = true,
    opts = { {} },
  },
  {
    'saghen/blink.cmp',
    version = '1.*',
    opts = {
      keymap = { preset = 'enter', ['<C-Space>'] = { 'show', 'hide' } },
      appearance = { nerd_font_variant = 'mono' },
      completion = {
        documentation = { auto_show = false },
        menu = {
          draw = {
            columns = { { 'kind_icon' }, { 'label' }, { 'label_description' } },
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
