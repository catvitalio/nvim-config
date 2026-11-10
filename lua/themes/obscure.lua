local M = {}

function M.plugin()
  return {
    'mikovskii/obscure.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('obscure').setup({ dim_inactive = false })
      vim.o.background = 'dark'
      vim.cmd.colorscheme('obscure')
    end,
  }
end

return M
