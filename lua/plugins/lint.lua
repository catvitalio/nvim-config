local function config()
  require('lint').linters_by_ft = {
    python = { 'ruff' },
    rust = { 'clippy' },
    go = { 'golangci-lint' },
    javascript = { 'eslint' },
    json = { 'eslint' },
    toml = { 'taplo' },
    yaml = { 'prettierd', 'prettier', stop_after_first = true },
    nix = { 'nixfmt' },
  }
end

return {
  'mfussenegger/nvim-lint',
  config = config,
}
