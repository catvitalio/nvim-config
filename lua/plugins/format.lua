local function config()
  require('conform').setup({
    formatters_by_ft = {
      lua = { 'stylua' },
      python = { 'ruff_format' },
      rust = { 'rustfmt', lsp_format = 'fallback' },
      javascript = { 'prettierd', 'prettier', stop_after_first = true },
      nix = { 'nixfmt' },
    },
  })

  vim.api.nvim_create_user_command('Format', function(args)
    local range = nil
    if args.count ~= -1 then
      local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
      range = {
        start = { args.line1, 0 },
        ['end'] = { args.line2, end_line:len() },
      }
    end
    require('conform').format({ async = false, lsp_format = 'fallback', range = range })
  end, { range = true })
end

return {
  'stevearc/conform.nvim',
  config = config,
}
