local function config()
  require('bufferline').setup({
    options = {
      buffer_close_icon = '',
      mode = 'buffers',
      offsets = {
        {
          filetype = 'neo-tree',
          text = 'File Explorer',
          separator = true,
          padding = 1,
        },
      },
      diagnostics = 'nvim_lsp',
      indicator = {
        -- icon = '  ', -- this should be omitted if indicator style is not 'icon'
        style = 'icon',
      },
      -- separator_style = "slope"
    },
  })
end

return {
  {
    'akinsho/bufferline.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = config,
  },
}
