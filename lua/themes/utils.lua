local function override_colors(colors)
  for group, opts in pairs(colors) do
    vim.api.nvim_set_hl(0, group, opts)
  end
end

local function parse_theme_name(repo)
  local theme_name = repo:match('([^/]+)%.nvim$') or repo:match('([^/]+)$') or repo
  return theme_name
end

local function get_color(group, attr)
  attr = attr or 'fg'
  local hl = vim.api.nvim_get_hl(0, { name = group })
  if hl[attr] then
    return string.format('#%06x', hl[attr])
  end
  return nil
end

local function setup_theme(repo, opts, colors)
  local theme_name = parse_theme_name(repo)
  return {
    repo,
    lazy = false,
    priority = 1000,
    config = function()
      if next(opts) ~= nil then
        require(theme_name).setup(opts)
      end

      vim.cmd.colorscheme(theme_name)

      if colors then
        vim.api.nvim_create_autocmd('User', {
          pattern = 'LazyDone',
          callback = function()
            vim.schedule(function()
              override_colors(colors)
            end)
          end,
          once = true,
        })
      end
    end,
  }
end

return {
  get_color = get_color,
  setup_theme = setup_theme,
}
