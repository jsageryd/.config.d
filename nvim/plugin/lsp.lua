-- Suppress sqls "no database connection" and restart the client
local orig_show_message = vim.lsp.handlers['window/showMessage']
vim.lsp.handlers['window/showMessage'] = function(err, result, ctx, config)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  if client and client.name == 'sqls' and result and result.message:match('no database connection') then
    vim.defer_fn(function()
      if vim.bo[vim.api.nvim_get_current_buf()].filetype == 'sql' then
        client:stop(true)
        vim.lsp.enable('sqls')
      end
    end, 500)
    return
  end
  if orig_show_message then
    return orig_show_message(err, result, ctx, config)
  end
end

vim.lsp.enable('gopls')
vim.lsp.enable('sqls')

-- LSP keybindings (only active when LSP is attached)
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local opts = { buffer = args.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'K', function()
      -- If a hover float is already visible, move its content to a split
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_config(win).relative ~= '' then
          local buf = vim.api.nvim_win_get_buf(win)
          local ft = vim.bo[buf].filetype
          if ft == 'markdown' or ft == 'sqls_hover' then
            local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
            -- Collect highlights from the float buffer
            local hls = {}
            if ft == 'sqls_hover' then
              local ns = vim.api.nvim_get_namespaces()['sqls_hover'] or 0
              for i = 0, #lines - 1 do
                for _, hl in ipairs(vim.api.nvim_buf_get_extmarks(buf, ns, {i, 0}, {i, -1}, {details = true})) do
                  table.insert(hls, { line = i, hl_group = hl[4].hl_group, col_start = hl[4].end_col and hl[3] or 0, col_end = hl[4].end_col or -1 })
                end
              end
            end
            vim.api.nvim_win_close(win, true)
            vim.cmd('aboveleft new')
            local split_buf = vim.api.nvim_get_current_buf()
            vim.api.nvim_buf_set_lines(split_buf, 0, -1, false, lines)
            vim.bo[split_buf].buftype = 'nofile'
            vim.bo[split_buf].bufhidden = 'wipe'
            vim.bo[split_buf].swapfile = false
            if ft == 'sqls_hover' then
              local ns = vim.api.nvim_create_namespace('sqls_hover_split')
              for _, hl in ipairs(hls) do
                vim.api.nvim_buf_add_highlight(split_buf, ns, hl.hl_group, hl.line, hl.col_start, hl.col_end)
              end
            else
              vim.bo[split_buf].filetype = 'markdown'
            end
            vim.keymap.set('n', 'q', '<cmd>close<CR>', { buffer = split_buf })
            return
          end
        end
      end
      vim.lsp.buf.hover({ border = 'rounded' })
    end, opts)
    vim.keymap.set('i', '<C-S>', function()
      -- Close existing signature float instead of focusing into it
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_config(win).relative ~= '' then
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.bo[buf].filetype == 'markdown' then
            vim.api.nvim_win_close(win, true)
            return
          end
        end
      end
      vim.lsp.buf.signature_help({ border = 'rounded' })
    end, opts)
  end,
})

vim.diagnostic.config({
  signs = true,
  underline = true,
  severity_sort = true,
})

-- Diagnostic signs and highlights
local signs = { Error = '▎', Warn = '▎', Info = '▎', Hint = '▎' }
for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
end

vim.api.nvim_set_hl(0, 'DiagnosticError', { fg = '#cc6666' })
vim.api.nvim_set_hl(0, 'DiagnosticWarn', { fg = '#f0c674' })
vim.api.nvim_set_hl(0, 'DiagnosticInfo', { fg = '#81a2be' })
vim.api.nvim_set_hl(0, 'DiagnosticHint', { fg = '#8abeb7' })
vim.api.nvim_set_hl(0, 'DiagnosticFloatingError', { fg = '#cc6666', bg = 'NONE' })
vim.api.nvim_set_hl(0, 'DiagnosticFloatingWarn', { fg = '#f0c674', bg = 'NONE' })
vim.api.nvim_set_hl(0, 'DiagnosticFloatingInfo', { fg = '#81a2be', bg = 'NONE' })
vim.api.nvim_set_hl(0, 'DiagnosticFloatingHint', { fg = '#8abeb7', bg = 'NONE' })

-- Style floating windows
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'FloatBorder', { fg = '#707880', bg = 'NONE' })

-- Style completion popup
vim.api.nvim_set_hl(0, 'Pmenu', { fg = '#c5c8c6', bg = '#282a2e' })
vim.api.nvim_set_hl(0, 'PmenuSel', { fg = '#d7ffaf', bg = '#5f875f' })
vim.api.nvim_set_hl(0, 'PmenuSbar', { bg = '#373b41' })
vim.api.nvim_set_hl(0, 'PmenuThumb', { bg = '#707880' })

-- Add border and padding to completion info popup
local function show_completion_info()
  if vim.fn.pumvisible() == 0 then return end
  local info = vim.fn.complete_info({ 'items', 'selected' })

  -- Close any existing info popup
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_config(win).relative ~= '' then
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.bo[buf].buftype == 'nofile' and vim.b[buf].completion_info then
        vim.api.nvim_win_close(win, true)
        vim.api.nvim_buf_delete(buf, { force = true })
      end
    end
  end

  if info.selected < 0 then return end
  local item = info.items[info.selected + 1]
  if not item or not item.info or item.info == '' then return end

  local text = vim.trim(item.info)
  local lines = vim.split(text, '\n')
  if #lines == 0 then return end

  local pum = vim.fn.pum_getpos()
  if not pum or vim.tbl_isempty(pum) then return end

  local editor_width = vim.o.columns
  local editor_height = vim.o.lines
  local border_extra = 2
  local pum_right = pum.col + pum.width + (pum.scrollbar and 1 or 0)
  local space_right = editor_width - pum_right - border_extra
  local space_left = pum.col - border_extra

  local max_width, col
  if space_right >= space_left then
    max_width = math.max(space_right, 1)
    col = pum_right
  else
    max_width = math.max(space_left, 1)
    col = nil
  end

  -- Use sqls table renderer if the content looks like a markdown table
  local bufnr, rendered_lines
  if _G.sqls_parse_table and text:match('|') then
    local tbl = _G.sqls_parse_table(text)
    if tbl then
      bufnr, rendered_lines = _G.sqls_render_table_buf(tbl)
      vim.b[bufnr].completion_info = true
    end
  end

  if not bufnr then
    bufnr = vim.api.nvim_create_buf(false, true)
    vim.b[bufnr].completion_info = true
    rendered_lines = vim.lsp.util.stylize_markdown(bufnr, lines, { max_width = max_width })
  end

  local width = 0
  for _, line in ipairs(rendered_lines) do
    width = math.max(width, vim.fn.strdisplaywidth(line))
  end
  width = math.min(math.max(width, 1), max_width)

  if not col then
    col = pum.col - width - border_extra
  end

  -- Calculate height accounting for wrapped lines
  local height = 0
  for _, line in ipairs(rendered_lines) do
    height = height + math.max(1, math.ceil(vim.fn.strdisplaywidth(line) / width))
  end
  height = math.min(height, editor_height - pum.row - border_extra)
  height = math.max(height, 1)

  local winnr = vim.api.nvim_open_win(bufnr, false, {
    relative = 'editor',
    row = pum.row,
    col = col,
    width = width,
    height = height,
    style = 'minimal',
    border = 'rounded',
    focusable = false,
  })
  vim.api.nvim_set_option_value('winhl', 'Normal:NormalFloat,FloatBorder:FloatBorder', { win = winnr })
  vim.api.nvim_set_option_value('wrap', true, { win = winnr })
end

vim.api.nvim_create_autocmd('CompleteChanged', {
  callback = function() vim.schedule(show_completion_info) end,
})

-- Close completion info popup when leaving completion
vim.api.nvim_create_autocmd({ 'CompleteDone', 'InsertLeave' }, {
  callback = function()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_config(win).relative ~= '' then
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].buftype == 'nofile' and vim.b[buf].completion_info then
          vim.api.nvim_win_close(win, true)
          vim.api.nvim_buf_delete(buf, { force = true })
        end
      end
    end
  end,
})

-- Show diagnostics on hover with severity colours
vim.api.nvim_create_autocmd('CursorHold', {
  callback = function()
    local diags = vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })
    if #diags == 0 then return end

    local severity_hl = {
      [vim.diagnostic.severity.ERROR] = 'DiagnosticFloatingError',
      [vim.diagnostic.severity.WARN]  = 'DiagnosticFloatingWarn',
      [vim.diagnostic.severity.INFO]  = 'DiagnosticFloatingInfo',
      [vim.diagnostic.severity.HINT]  = 'DiagnosticFloatingHint',
    }

    local lines = {}
    local highlights = {}
    for _, diag in ipairs(diags) do
      local src = diag.source or ''
      if src ~= '' then src = ' (' .. src .. ')' end
      local hl = severity_hl[diag.severity] or 'DiagnosticFloatingInfo'
      local full = ' ● ' .. diag.message .. src
      for j, part in ipairs(vim.split(full, '\n')) do
        if j > 1 then part = '   ' .. part end
        table.insert(lines, part)
        table.insert(highlights, hl)
      end
    end

    local bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
    for i, hl in ipairs(highlights) do
      vim.api.nvim_buf_add_highlight(bufnr, -1, hl, i - 1, 0, -1)
    end

    local width = 0
    for _, line in ipairs(lines) do
      width = math.max(width, vim.fn.strdisplaywidth(line))
    end

    local winnr = vim.api.nvim_open_win(bufnr, false, {
      relative = 'cursor',
      row = 1,
      col = 0,
      width = width + 1,
      height = #lines,
      style = 'minimal',
      border = 'rounded',
      focusable = false,
    })
    vim.api.nvim_set_option_value('winhl', 'Normal:NormalFloat,FloatBorder:FloatBorder', { win = winnr })

    -- Close float on cursor move
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
  end,
})
