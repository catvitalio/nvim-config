return function(key, default)
  local env = os.getenv(key)

  if env then
    local ok, parsed = pcall(vim.json.decode, env)
    if ok and type(parsed) == 'table' then
      return parsed
    end
  end

  return default
end
