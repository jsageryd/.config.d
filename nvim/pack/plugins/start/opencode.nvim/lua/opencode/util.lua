local M = {}

---Errors if a system call returned a non-zero exit code or no output.
---
---Ignores exit code 1 if there is no stderr, as many commands
---use this code when there are no results (e.g., `pgrep`, `lsof`, `ps`).
---
---@param obj vim.SystemCompleted
---@param cmd string
function M.check_system_call(obj, cmd)
  cmd = "`" .. cmd .. "`"
  if obj.code ~= 0 and (obj.code ~= 1 or obj.stderr ~= "") then
    error(string.format("`%s` command failed with code %d\n%s", cmd, obj.code, obj.stderr), 0)
  elseif not obj.stdout then
    error(string.format("`%s` command did not return any output", cmd), 0)
  end
end

---@param delay_ms number
---@param callback function
function M.on_user_idle(delay_ms, callback)
  local idle_timer = vim.uv.new_timer()
  if not idle_timer then
    vim.notify("Failed to create idle timer for opencode permissions", vim.log.levels.ERROR, { title = "opencode" })
    return
  end

  local key_listener_id = nil

  local function on_idle()
    idle_timer:stop()
    idle_timer:close()
    vim.on_key(nil, key_listener_id)

    callback()
  end

  local function reset_idle_timer()
    idle_timer:stop()
    idle_timer:start(delay_ms, 0, vim.schedule_wrap(on_idle))
  end

  key_listener_id = vim.on_key(function()
    reset_idle_timer()
  end)

  -- Start the initial timer
  reset_idle_timer()
end

return M
