vim.lsp.enable('gopls')

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
          if vim.bo[buf].filetype == 'markdown' then
            local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
            vim.api.nvim_win_close(win, true)
            vim.cmd('aboveleft new')
            local split_buf = vim.api.nvim_get_current_buf()
            vim.api.nvim_buf_set_lines(split_buf, 0, -1, false, lines)
            vim.bo[split_buf].buftype = 'nofile'
            vim.bo[split_buf].bufhidden = 'wipe'
            vim.bo[split_buf].swapfile = false
            vim.bo[split_buf].filetype = 'markdown'
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
vim.api.nvim_create_autocmd('CompleteChanged', {
  callback = function()
    vim.schedule(function()
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

      local lines = vim.split(vim.trim(item.info), '\n')
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

      local bufnr = vim.api.nvim_create_buf(false, true)
      vim.b[bufnr].completion_info = true

      lines = vim.lsp.util.stylize_markdown(bufnr, lines, { max_width = max_width })

      local width = 0
      for _, line in ipairs(lines) do
        width = math.max(width, vim.fn.strdisplaywidth(line))
      end
      width = math.min(math.max(width, 1), max_width)

      if not col then
        col = pum.col - width - border_extra
      end

      -- Calculate height accounting for wrapped lines
      local height = 0
      for _, line in ipairs(lines) do
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
    end)
  end,
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
