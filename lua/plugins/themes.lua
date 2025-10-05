return {
  {
    'Mofiqul/vscode.nvim',
    config = function()
      require('vscode').setup({
        transparent = true,
        italic_comments = false,
        underline_links = true,
        disable_nvimtree_bg = true,
        terminal_colors = true,
      })
    end,
  },
  {
    'vague2k/vague.nvim',
    config = function()
      require('vague').setup({
        -- optional configuration here
      })
    end,
  },
}
