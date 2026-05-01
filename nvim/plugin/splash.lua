-- splash.lua - time-of-day progress bar screen
-- Vibed into existence with Claude, April 2026

local ns = vim.api.nvim_create_namespace('splash')

-- Time-of-day periods: name, start hour, and color palette
-- Each daytime period is 3 hours; night spans 20:00-05:00
local periods = {
  { name = 'dawn',      start = 5,  base = '#4a2838', peak = '#b05878' },
  { name = 'morning',   start = 8,  base = '#4a4238', peak = '#b09050' },
  { name = 'midday',    start = 11, base = '#2e3a4a', peak = '#5080a0' },
  { name = 'afternoon', start = 14, base = '#323a28', peak = '#709048' },
  { name = 'evening',   start = 17, base = '#2a3048', peak = '#5878c0' },
  { name = 'night',     start = 20, base = '#333333', peak = '#707070' },
}

local function get_period(hour)
  for i = #periods, 1, -1 do
    if hour >= periods[i].start then return periods[i] end
  end
  return periods[#periods] -- night (wraps past midnight)
end

local function should_show()
  if vim.fn.argc() > 0 then return false end
  if vim.fn.bufname('%') ~= '' then return false end
  if vim.bo.modified then return false end
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  if #lines > 1 or (lines[1] and lines[1] ~= '') then return false end
  if vim.bo.buftype ~= '' then return false end
  return true
end

local function show_splash()
  if not should_show() then return end

  local buf = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()

  local hour = tonumber(os.date('%H'))
  local cur = get_period(hour)
  local date_text = os.date('%A %-d %B %Y %H:%M')
  local v = vim.version()
  local ver_text = string.format('nvim v%d.%d.%d', v.major, v.minor, v.patch)
  local now_h = hour + tonumber(os.date('%M')) / 60

  vim.api.nvim_set_hl(0, 'SplashTitle', { fg = '#909090', default = true })
  vim.api.nvim_set_hl(0, 'SplashInfo', { fg = '#707880', default = true })
  vim.api.nvim_set_hl(0, 'SplashBarInactive', { fg = '#252525', default = true })
  for i = 1, #periods - 1 do
    vim.api.nvim_set_hl(0, 'SplashBar_' .. periods[i].name,
      { fg = periods[i].base, default = true })
  end
  vim.api.nvim_set_hl(0, 'SplashBarMarker', { fg = cur.peak, bold = true, default = true })

  -- 30 blocks: 6 per daytime period (1 block per 30 min); night has no marker
  local marker_block = math.floor((now_h - cur.start) * 2) + 1
  local bar_groups = {}
  for i = 1, 5 do
    local pd = periods[i]
    local is_active = cur.name ~= 'night' and pd.name == cur.name
    for j = 1, 6 do
      if is_active and j == marker_block then
        table.insert(bar_groups, 'SplashBarMarker')
      elseif is_active then
        table.insert(bar_groups, 'SplashBar_' .. pd.name)
      else
        table.insert(bar_groups, 'SplashBarInactive')
      end
    end
  end

  local block = '■'
  local function build_bar_chunks()
    local chunks = {}
    for _, hl in ipairs(bar_groups) do
      table.insert(chunks, { block, hl })
    end
    return chunks
  end

  local extmark_id

  local function clear()
    if extmark_id and vim.api.nvim_buf_is_valid(buf) then
      pcall(vim.api.nvim_buf_del_extmark, buf, ns, extmark_id)
    end
    extmark_id = nil
  end

  local function render()
    if not vim.api.nvim_buf_is_valid(buf) then return end
    if not vim.api.nvim_win_is_valid(win) then return end
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    if #lines > 1 or (lines[1] and lines[1] ~= '') then
      clear()
      return
    end

    local width = vim.api.nvim_win_get_width(win)
    local height = vim.api.nvim_win_get_height(win)

    local function pad_chunks(chunks, display_width)
      local pad = math.max(0, math.floor((width - display_width) / 2))
      if pad == 0 then return chunks end
      local out = { { string.rep(' ', pad), 'SplashTitle' } }
      for _, c in ipairs(chunks) do table.insert(out, c) end
      return out
    end

    local function center_text(text, hl)
      local w = vim.fn.strdisplaywidth(text)
      local pad = math.max(0, math.floor((width - w) / 2))
      return { { string.rep(' ', pad) .. text, hl } }
    end

    local virt_lines = {}
    local content_lines = 6
    local top = math.max(0, math.floor((height - content_lines) / 2))
    for _ = 1, top do table.insert(virt_lines, { { '', 'NonText' } }) end
    table.insert(virt_lines, pad_chunks(build_bar_chunks(), 30))
    table.insert(virt_lines, { { '', 'NonText' } })
    table.insert(virt_lines, center_text(date_text, 'SplashTitle'))
    table.insert(virt_lines, { { '', 'NonText' } })
    table.insert(virt_lines, { { '', 'NonText' } })
    table.insert(virt_lines, center_text(ver_text, 'SplashInfo'))

    clear()
    extmark_id = vim.api.nvim_buf_set_extmark(buf, ns, 0, 0, {
      virt_lines = virt_lines,
    })
  end

  render()
  if not extmark_id then return end

  local group = vim.api.nvim_create_augroup('Splash', { clear = true })

  vim.api.nvim_create_autocmd({ 'VimResized', 'WinResized' }, {
    group = group,
    callback = render,
  })

  vim.api.nvim_create_autocmd({
    'TextChanged', 'TextChangedI', 'InsertEnter',
    'BufModifiedSet', 'BufReadPre',
  }, {
    group = group,
    buffer = buf,
    callback = clear,
  })

  vim.api.nvim_create_autocmd({ 'BufWinLeave', 'BufHidden', 'BufWipeout' }, {
    group = group,
    buffer = buf,
    callback = function()
      clear()
      pcall(vim.api.nvim_del_augroup_by_id, group)
    end,
  })

  vim.api.nvim_create_autocmd('BufWinEnter', {
    group = group,
    callback = function(ev)
      if ev.buf ~= buf then
        clear()
        pcall(vim.api.nvim_del_augroup_by_id, group)
      end
    end,
  })
end

vim.api.nvim_create_autocmd('VimEnter', {
  once = true,
  nested = true,
  callback = function()
    vim.schedule(show_splash)
  end,
})
