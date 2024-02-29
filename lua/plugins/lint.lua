local function config()
  require('lint').linters_by_ft = {
    lua = { 'luacheck', 'cspell' },
    json = { 'cspell' },
    yaml = { 'yamllint', 'cspell' },
    dockerfile = { 'cspell' },
    python = { 'ruff', 'cspell' },
  }

  vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
    callback = function()
      require('lint').try_lint()
    end,
  })
end

return {
  'mfussenegger/nvim-lint',
  config = config,
}
