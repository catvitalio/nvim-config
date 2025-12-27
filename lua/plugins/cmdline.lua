local function config()
  require('cmdline').setup({
    cmdtype = ':/?',
    window = {
      matchFuzzy = true,
      offset = 1,
      debounceMs = 10,
    },

    hl = {
      default = 'Pmenu',
      selection = 'PmenuSel',
      directory = 'Directory',
      substr = 'LineNr',
    },

    column = {
      maxNumber = 6,
      minWidth = 20,
    },

    binds = {
      next = '<Tab>',
      back = '<S-Tab>',
    },
  })
end

return {
  'vzze/cmdline.nvim',
  config = config,
}
