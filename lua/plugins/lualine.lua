local function config()
  local lualine = require('lualine')
  lualine.setup({
    options = {
      theme = 'vscode',
    },
  })
end

return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = config,
}
