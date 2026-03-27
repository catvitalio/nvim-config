local function config()
  require('lint').linters_by_ft = {
    python = { 'ruff' },
    rust = { 'clippy' },
    go = { 'golangcilint' },
    javascript = { 'eslint' },
    json = { 'eslint' },
  }

  vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost' }, {
    callback = function()
      require('lint').try_lint()
    end,
  })
end

return {
  'mfussenegger/nvim-lint',
  config = config,
}
