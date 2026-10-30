local M = {}
local ffi = require('ffi')
local uv = vim.uv
local LOCK_EX, LOCK_NB, LOCK_UN = 2, 4, 8

ffi.cdef('int flock(int fd, int operation);')

local pending = {}

local function with_lock(directory, action, ...)
  if pending[directory] then
    return false, 'Another fude write is pending in this editor'
  end
  pending[directory] = true
  local made, mkdir_err = pcall(vim.fn.mkdir, directory, 'p')
  if not made then
    pending[directory] = nil
    return false, mkdir_err
  end
  local fd, err = uv.fs_open(directory .. '/.mcp.lock', 'a', 384)
  if not fd then
    pending[directory] = nil
    return false, err
  end

  -- Python's fcntl.flock uses this same lock, including the version-check/append transaction.
  local ok, acquired = pcall(vim.wait, 3000, function()
    return ffi.C.flock(fd, LOCK_EX + LOCK_NB) == 0
  end, 10)
  if not ok or not acquired then
    uv.fs_close(fd)
    pending[directory] = nil
    return false, 'Review store is busy; retry the action'
  end

  local result = { pcall(action, ...) }
  ffi.C.flock(fd, LOCK_UN)
  uv.fs_close(fd)
  pending[directory] = nil
  if not result[1] then
    return false, result[2]
  end
  return unpack(result, 2)
end

function M.setup()
  local store = require('fude.local.store')
  if store._mcp_lock_enabled then
    return
  end
  if vim.fn.has('win32') == 1 then
    error('The fude MCP lock integration requires macOS or Linux')
  end
  store._mcp_lock_enabled = true

  local append = store.append_event
  store.append_event = function(path, event)
    return with_lock(vim.fs.dirname(vim.fs.dirname(path)), append, path, event)
  end

  local read = store.read_events
  store.read_events = function(path)
    local events, err = with_lock(vim.fs.dirname(vim.fs.dirname(path)), read, path)
    if events == false then
      error(err)
    end
    return events
  end

  for _, name in ipairs({ 'write_current', 'clear_current' }) do
    local original = store[name]
    store[name] = function(root, ...)
      return with_lock(vim.fs.dirname(store.current_file(root)), original, root, ...)
    end
  end
end

return M
