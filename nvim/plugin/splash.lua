-- splash.lua - time-of-day progress bar screen
-- Vibed into existence with Claude, April 2026

local ns = vim.api.nvim_create_namespace('splash')

local BLOCK = '■'
local PERIOD_HOURS = 3
local BLOCKS_PER_PERIOD = 6
local BLOCKS_PER_HOUR = BLOCKS_PER_PERIOD / PERIOD_HOURS

local periods = {
  { name = 'dawn',        start = 5,  base = '#68384f', peak = '#ff7fb2' },
  { name = 'morning',     start = 8,  base = '#7d5b2b', peak = '#ffc257' },
  { name = 'midday',      start = 11, base = '#385a73', peak = '#5fbfea' },
  { name = 'afternoon',   start = 14, base = '#445635', peak = '#aeda6f' },
  { name = 'evening',     start = 17, base = '#35534c', peak = '#72e0c6' },
  { name = 'lateevening', start = 20, base = '#33425f', peak = '#76a6ff' },
  { name = 'night',       start = 23, base = '#404040', peak = '#7d7d7d' },
}
local DAY_PERIODS = #periods - 1

local BLANK = { { '', 'NonText' } }

local function period_index(hour)
  for i = #periods, 1, -1 do
    if hour >= periods[i].start then return i end
  end
  return #periods
end

-- `:colorscheme` runs `hi clear`, which wipes these; re-applied on ColorScheme.
local function set_highlights(cur)
  vim.api.nvim_set_hl(0, 'SplashTitle', { fg = '#909090', default = true })
  vim.api.nvim_set_hl(0, 'SplashInfo', { fg = '#707880', default = true })
  vim.api.nvim_set_hl(0, 'SplashBarInactive', { fg = '#2f2f2f', default = true })
  vim.api.nvim_set_hl(0, 'SplashBarActive', { fg = cur.base, default = true })
  vim.api.nvim_set_hl(0, 'SplashBarMarker', { fg = cur.peak, bold = true, default = true })
end

local function build_bar(cur_index, marker)
  local chunks = {}
  for i = 1, DAY_PERIODS do
    for j = 1, BLOCKS_PER_PERIOD do
      local hl = 'SplashBarInactive'
      if i == cur_index then
        hl = (j == marker) and 'SplashBarMarker' or 'SplashBarActive'
      end
      chunks[#chunks + 1] = { BLOCK, hl }
    end
  end
  return chunks
end

local function center(chunks, width)
  local w = 0
  for _, c in ipairs(chunks) do w = w + vim.fn.strdisplaywidth(c[1]) end
  local pad = math.max(0, math.floor((width - w) / 2))
  if pad == 0 then return chunks end
  return vim.list_extend({ { string.rep(' ', pad), 'NonText' } }, chunks)
end

local function should_show()
  if vim.fn.argc() > 0 then return false end
  if vim.bo.buftype ~= '' then return false end
  if vim.bo.modified then return false end
  if vim.fn.bufname('%') ~= '' then return false end
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  if #lines > 1 or (lines[1] and lines[1] ~= '') then return false end
  return true
end

local function is_empty(buf)
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  return #lines == 1 and (lines[1] == nil or lines[1] == '')
end

local function show_splash()
  if not should_show() then return end

  local buf = vim.api.nvim_get_current_buf()

  local now = os.time()
  local hour = tonumber(os.date('%H', now)) + tonumber(os.date('%M', now)) / 60
  local cur_index = period_index(math.floor(hour))
  local cur = periods[cur_index]
  local marker = math.floor((hour - cur.start) * BLOCKS_PER_HOUR) + 1

  local v = vim.version()
  local rows = {
    build_bar(cur_index, marker),
    BLANK,
    { { os.date('%A %-d %B %Y %H:%M', now), 'SplashTitle' } },
    BLANK,
    BLANK,
    { { string.format('nvim v%d.%d.%d', v.major, v.minor, v.patch), 'SplashInfo' } },
  }

  set_highlights(cur)

  local group = vim.api.nvim_create_augroup('Splash', { clear = true })
  local extmark_id

  local function dismiss()
    if extmark_id and vim.api.nvim_buf_is_valid(buf) then
      pcall(vim.api.nvim_buf_del_extmark, buf, ns, extmark_id)
    end
    extmark_id = nil
    pcall(vim.api.nvim_del_augroup_by_id, group)
  end

  local function render()
    local win = vim.api.nvim_buf_is_valid(buf) and vim.fn.win_findbuf(buf)[1]
    if not win or not is_empty(buf) then return dismiss() end

    local width = vim.api.nvim_win_get_width(win)
    -- Neovim does not draw virt_lines above the first line, so the buffer's
    -- own empty line is always the top row: one row of padding comes free.
    local top = math.max(0, math.floor((vim.api.nvim_win_get_height(win) - #rows) / 2) - 1)

    local virt_lines = {}
    for _ = 1, top do virt_lines[#virt_lines + 1] = BLANK end
    for _, row in ipairs(rows) do
      virt_lines[#virt_lines + 1] = row == BLANK and BLANK or center(row, width)
    end

    if extmark_id then pcall(vim.api.nvim_buf_del_extmark, buf, ns, extmark_id) end
    extmark_id = vim.api.nvim_buf_set_extmark(buf, ns, 0, 0, { virt_lines = virt_lines })
  end

  render()
  if not extmark_id then return dismiss() end

  vim.api.nvim_create_autocmd('WinResized', { group = group, callback = render })
  vim.api.nvim_create_autocmd('ColorScheme', {
    group = group,
    callback = function() set_highlights(cur) end,
  })

  vim.api.nvim_create_autocmd({
    'TextChanged', 'TextChangedI', 'InsertEnter', 'BufModifiedSet',
    'BufReadPre', 'BufWinLeave', 'BufHidden', 'BufWipeout',
  }, { group = group, buffer = buf, callback = dismiss })

  vim.api.nvim_create_autocmd('BufWinEnter', {
    group = group,
    callback = function(ev) if ev.buf ~= buf then dismiss() end end,
  })
end

vim.api.nvim_create_autocmd('VimEnter', {
  once = true,
  callback = function()
    vim.schedule(show_splash)
  end,
})
