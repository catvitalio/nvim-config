local function config()
  require('lint').linters_by_ft = {
    python = { 'ruff', 'cspell' },
  }
end

return {
  'mfussenegger/nvim-lint',
  config = config,
}
