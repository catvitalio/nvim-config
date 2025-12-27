local function config()
  local utils = require('utils')

  require('supermaven-nvim').setup({
    keymaps = {
      accept_suggestion = '<Tab>',
      clear_suggestion = '<C-]>',
      accept_word = '<C-j>',
    },
    ignore_filetypes = {},
    color = {
      suggestion_color = utils.getColor('LineNr'),
      cterm = 244,
    },
    log_level = 'off',
    disable_inline_completion = false,
    disable_keymaps = false,
    condition = function()
      return false
    end,
  })
end

return {
  'supermaven-inc/supermaven-nvim',
  config = config,
}
