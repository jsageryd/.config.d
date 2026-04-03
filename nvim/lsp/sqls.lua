-- Parse sqls markdown table hover into structured data
local function parse_table(text)
  text = text:gsub('`', ''):gsub('&nbsp;', ' ')
  local lines = vim.split(text, '\n')
  local header = nil
  local rows = {}
  local col_widths = {}
  for _, line in ipairs(lines) do
    if line:match('^#+ ') then
      header = line:gsub('^#+%s*', ''):gsub('%s+table$', '')
    elseif line:match('^|[%s:%-|]+$') then
      -- skip separator rows
    elseif line:match('^|') then
      local cells = {}
      for cell in line:gmatch('|([^|]*)') do
        cell = vim.trim(cell)
        if cell ~= '' then
          table.insert(cells, cell)
        end
      end
      if #cells > 0 then
        table.insert(rows, cells)
        for i, cell in ipairs(cells) do
          col_widths[i] = math.max(col_widths[i] or 0, #cell)
        end
      end
    end
  end
  if #rows < 2 then return nil end
  return { header = header, rows = rows, col_widths = col_widths }
end

-- Render parsed table into a buffer with highlights, return bufnr, lines
local function render_table_buf(tbl)
  local gap = '  '
  local out = {}

  if tbl.header then
    table.insert(out, tbl.header)
    table.insert(out, '')
  end

  local col_ranges = {}

  local function format_row(cells, line_idx)
    local parts = {}
    local ranges = {}
    local pos = 0
    for i, cell in ipairs(cells) do
      local padded = cell .. string.rep(' ', (tbl.col_widths[i] or 0) - #cell)
      table.insert(parts, padded)
      table.insert(ranges, { pos, pos + #cell, i })
      pos = pos + #padded + #gap
    end
    local line = table.concat(parts, gap)
    col_ranges[line_idx] = ranges
    return line
  end

  local hdr_idx = #out + 1
  table.insert(out, format_row(tbl.rows[1], hdr_idx))

  local sep = {}
  for i = 1, #tbl.rows[1] do
    table.insert(sep, string.rep('-', tbl.col_widths[i] or 0))
  end
  table.insert(out, table.concat(sep, gap))

  for r = 2, #tbl.rows do
    table.insert(out, format_row(tbl.rows[r], #out + 1))
  end

  local type_col = nil
  for i, cell in ipairs(tbl.rows[1]) do
    if cell:lower() == 'type' then
      type_col = i
      break
    end
  end

  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, out)
  vim.bo[bufnr].filetype = 'sqls_hover'

  vim.api.nvim_set_hl(0, 'SqlsHoverTitle', { fg = '#81a2be', bold = true })
  vim.api.nvim_set_hl(0, 'SqlsHoverHeader', { fg = '#c5c8c6', bold = true })
  vim.api.nvim_set_hl(0, 'SqlsHoverSep', { fg = '#373b41' })
  vim.api.nvim_set_hl(0, 'SqlsHoverType', { fg = '#b294bb' })

  local ns = vim.api.nvim_create_namespace('sqls_hover')

  if tbl.header then
    vim.api.nvim_buf_add_highlight(bufnr, ns, 'SqlsHoverTitle', 0, 0, -1)
  end

  local hdr_line = tbl.header and 2 or 0
  vim.api.nvim_buf_add_highlight(bufnr, ns, 'SqlsHoverHeader', hdr_line, 0, -1)
  vim.api.nvim_buf_add_highlight(bufnr, ns, 'SqlsHoverSep', hdr_line + 1, 0, -1)

  if type_col then
    for line_idx, ranges in pairs(col_ranges) do
      if line_idx > hdr_line + 1 then
        for _, range in ipairs(ranges) do
          if range[3] == type_col then
            local buf_line = line_idx - 1
            vim.api.nvim_buf_add_highlight(bufnr, ns, 'SqlsHoverType', buf_line, range[1], range[2])
          end
        end
      end
    end
  end

  return bufnr, out
end

-- Show parsed table in a floating window at cursor
local function show_table_float(tbl)
  local bufnr, out = render_table_buf(tbl)

  local width = 0
  for _, line in ipairs(out) do
    width = math.max(width, vim.fn.strdisplaywidth(line))
  end

  local winnr = vim.api.nvim_open_win(bufnr, false, {
    relative = 'cursor',
    row = 1,
    col = 0,
    width = width + 1,
    height = #out,
    style = 'minimal',
    border = 'rounded',
    focusable = false,
  })
  vim.api.nvim_set_option_value('winhl', 'Normal:NormalFloat,FloatBorder:FloatBorder', { win = winnr })

  vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI', 'BufLeave' }, {
    once = true,
    callback = function()
      if vim.api.nvim_win_is_valid(winnr) then
        vim.api.nvim_win_close(winnr, true)
      end
      if vim.api.nvim_buf_is_valid(bufnr) then
        vim.api.nvim_buf_delete(bufnr, { force = true })
      end
    end,
  })
end

-- Expose for use from completion info popup
_G.sqls_parse_table = parse_table
_G.sqls_render_table_buf = render_table_buf

return {
  cmd = { 'sqls' },
  filetypes = { 'sql' },
  root_markers = { '.git' },
  on_attach = function(client)
    -- Reformat hover markdown tables
    local orig_request = client.request
    client.request = function(self, method, params, handler, bufnr)
      if method == 'textDocument/hover' and handler then
        local orig_handler = handler
        handler = function(err, result, ctx, config)
          if result and result.contents then
            local text = result.contents.value or result.contents
            if type(text) == 'string' and text:match('|') then
              local tbl = parse_table(text)
              if tbl then
                show_table_float(tbl)
                return
              end
            end
          end
          return orig_handler(err, result, ctx, config)
        end
      end
      return orig_request(self, method, params, handler, bufnr)
    end
  end,
  settings = {
    sqls = {
      connections = {
        {
          driver = 'postgresql',
          dataSourceName = 'host=localhost port=5432 user=postgres dbname=postgres sslmode=disable',
        },
      },
    },
  },
}
