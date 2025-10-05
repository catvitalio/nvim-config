local function config()
  require('cmdline').setup({
    cmdtype = ':', -- you can also add / and ? by using ":/?"
    -- as a string

    window = {
      matchFuzzy = true,
      offset = 1, -- depending on 'cmdheight' you might need to offset
      debounceMs = 10, -- the lower the number the more responsive however
      -- more resource intensive
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
