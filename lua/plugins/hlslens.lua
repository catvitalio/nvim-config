return {
  'kevinhwang91/nvim-hlslens',
  keys = { '/', '?', 'n', 'N', '*', '#', 'g*', 'g#' },
  config = function()
    require('hlslens').setup({
      calm_down = true,
      nearest_only = false,
      nearest_float_when = 'never',
    })
  end,
}
