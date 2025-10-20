return {
  'nvim-treesitter/nvim-treesitter-context',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  opts = {
    enable = true,
    max_lines = 3, -- How many lines the context can take up
    min_window_height = 20, -- Minimum editor window height to enable context
    line_numbers = true,
    multiline_threshold = 1, -- Maximum number of lines to collapse for a single context line
    trim_scope = 'outer', -- Which context lines to discard if max_lines is exceeded
    mode = 'cursor', -- 'cursor' or 'topline' - Line used to calculate context
    separator = nil, -- Separator between context and content (nil for no separator)
    zindex = 20, -- The Z-index of the context window
  },
  config = function(_, opts)
    require('treesitter-context').setup(opts)
  end,
}
