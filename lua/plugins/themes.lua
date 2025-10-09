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
    'ydkulks/cursor-dark.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      -- vim.cmd.colorscheme("cursor-dark-midnight")
      require('cursor-dark').setup({
        -- For theme
        style = 'dark',
        -- For a transparent background
        transparent = true,
        -- If you have dashboard-nvim plugin installed
        dashboard = true,
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
