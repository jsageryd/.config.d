vim.lsp.enable('gopls')

-- LSP keybindings (only active when LSP is attached)
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local opts = { buffer = args.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'K', function()
      vim.lsp.buf.hover({ border = 'rounded' })
    end, opts)
    vim.keymap.set('i', '<C-S>', function()
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
