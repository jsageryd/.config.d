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

local function show_splash()
  -- Only show for a fresh start with no file arguments
  if vim.fn.argc() > 0 then return end
  if vim.fn.expand('%') ~= '' then return end
  local check = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  if #check > 1 or check[1] ~= '' then return end

  local buf = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()

  -- Convert current empty buffer to scratch
  vim.bo[buf].bufhidden = 'wipe'
  vim.bo[buf].buftype = 'nofile'
  vim.bo[buf].swapfile = false
  vim.bo[buf].filetype = 'splash'

  -- Save window options to restore later
  local saved_opts = {
    number = vim.wo[win].number,
    relativenumber = vim.wo[win].relativenumber,
    signcolumn = vim.wo[win].signcolumn,
    colorcolumn = vim.wo[win].colorcolumn,
    cursorline = vim.wo[win].cursorline,
    list = vim.wo[win].list,
  }
  local saved_fillchars = vim.o.fillchars

  -- Clean window chrome
  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].signcolumn = 'no'
  vim.wo[win].colorcolumn = ''
  vim.wo[win].cursorline = false
  vim.wo[win].list = false
  vim.opt_local.fillchars:append({ eob = ' ' })

  -- Snapshot values that stay constant across resizes
  local hour = tonumber(os.date('%H'))
  local cur = get_period(hour)
  local date_text = os.date('%A %-d %B %Y %H:%M')
  local v = vim.version()
  local ver_text = string.format('nvim v%d.%d.%d', v.major, v.minor, v.patch)
  local now_h = hour + tonumber(os.date('%M')) / 60

  -- Set up highlight groups
  vim.api.nvim_set_hl(0, 'SplashTitle', { fg = '#909090' })
  vim.api.nvim_set_hl(0, 'SplashInfo', { fg = '#707880' })
  vim.api.nvim_set_hl(0, 'SplashBarInactive', { fg = '#252525' })
  for i = 1, #periods - 1 do
    vim.api.nvim_set_hl(0, 'SplashBar_' .. periods[i].name, { fg = periods[i].base })
  end
  vim.api.nvim_set_hl(0, 'SplashBarMarker', { fg = cur.peak, bold = true })

  -- Build bar: 30 fixed blocks (6 per period = 1 block per 30 min)
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

  -- Render content centered in the current window dimensions
  local bar_str = string.rep('■', 30)
  local ch_len = #'■'

  local function render()
    if not vim.api.nvim_buf_is_valid(buf) then return end
    if not vim.api.nvim_win_is_valid(win) then return end

    local width = vim.api.nvim_win_get_width(win)
    local height = vim.api.nvim_win_get_height(win)

    local function center(text)
      local pad = math.max(0, math.floor((width - vim.fn.strdisplaywidth(text)) / 2))
      return string.rep(' ', pad) .. text, pad
    end

    local bar_padded, bar_pad = center(bar_str)
    local lines = { bar_padded, '', center(date_text), '', '', (center(ver_text)) }
    local top = math.max(0, math.floor((height - #lines) / 2))

    local final = {}
    for _ = 1, top do table.insert(final, '') end
    for _, l in ipairs(lines) do table.insert(final, l) end
    for _ = #final + 1, height do table.insert(final, '') end

    vim.bo[buf].modifiable = true
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, final)
    vim.bo[buf].modifiable = false

    -- Apply highlights
    vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
    local byte_off = bar_pad
    for i = 1, #bar_groups do
      vim.api.nvim_buf_add_highlight(buf, ns, bar_groups[i], top, byte_off, byte_off + ch_len)
      byte_off = byte_off + ch_len
    end
    vim.api.nvim_buf_add_highlight(buf, ns, 'SplashTitle', top + 2, 0, -1)
    vim.api.nvim_buf_add_highlight(buf, ns, 'SplashInfo', top + 5, 0, -1)
  end

  render()

  -- Re-render on resize
  local splash_group = vim.api.nvim_create_augroup('SplashResize', { clear = true })
  vim.api.nvim_create_autocmd({ 'VimResized', 'WinResized' }, {
    group = splash_group,
    callback = function()
      if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_win_is_valid(win) then
        render()
      end
    end,
  })

  -- Close splash window when a file is opened anywhere (e.g. split from nvim-tree)
  vim.api.nvim_create_autocmd('BufWinEnter', {
    group = splash_group,
    callback = function(ev)
      if ev.buf ~= buf and vim.bo[ev.buf].buftype == '' and vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
    end,
  })

  -- Dismiss splash and feed key through to a new empty buffer
  for key in ('iIaAoOsScCR:/?'):gmatch('.') do
    vim.keymap.set('n', key, function()
      vim.cmd('enew')
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), 'n', false)
    end, { buffer = buf, nowait = true, silent = true })
  end

  -- Restore window options when splash buffer leaves the window
  local restore_group = vim.api.nvim_create_augroup('SplashRestore', { clear = true })
  local function cleanup()
    pcall(vim.api.nvim_del_augroup_by_id, splash_group)
    pcall(vim.api.nvim_del_augroup_by_id, restore_group)
    if vim.api.nvim_win_is_valid(win) then
      for k, val in pairs(saved_opts) do
        vim.wo[win][k] = val
      end
      vim.wo[win].fillchars = saved_fillchars
    end
  end
  vim.api.nvim_create_autocmd({ 'BufWinLeave', 'BufWipeout' }, {
    group = restore_group,
    buffer = buf,
    once = true,
    callback = cleanup,
  })
end

vim.api.nvim_create_autocmd('VimEnter', {
  once = true,
  callback = function()
    vim.schedule(show_splash)
  end,
})
