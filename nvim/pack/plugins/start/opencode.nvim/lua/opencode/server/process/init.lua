local M = {}

---An `opencode` process.
---Retrieval is platform-dependent.
---@class opencode.server.process.Process
---@field pid number
---@field port number

---@return opencode.server.process.Process[]
function M.get()
  if vim.fn.has("win32") == 1 then
    return require("opencode.server.process.windows").get()
  else
    return require("opencode.server.process.unix").get()
  end
end

return M
