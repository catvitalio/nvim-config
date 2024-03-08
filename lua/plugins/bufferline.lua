local function config()
  require('bufferline').setup({
    options = {
      show_buffer_close_icons = false,
      mode = 'buffers',
      themable = true,
      offsets = {
        {
          filetype = 'neo-tree',
          text = 'File Explorer',
          separator = true,
          padding = 1,
        },
      },
      diagnostics = false,
      indicator = { style = 'icon' },
      separator_style = 'thin',
      color_icons = true,
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
