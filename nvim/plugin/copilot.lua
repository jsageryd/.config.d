-- Make Copilot suggestions faster
vim.g.copilot_idle_delay = 0

-- Enable Copilot by default
vim.g.copilot_enabled = true

-- Enable Copilot for specific filetypes only
vim.g.copilot_filetypes = {
  ['*'] = false,
  css = true,
  gitcommit = true,
  go = true,
  gohtmltmpl = true,
  gomod = true,
  html = true,
  log = true,
  lua = true,
  markdown = true,
  sh = true,
  sql = true,
  yaml = true,
}

-- Map C-n to cycle to next Copilot suggestion
vim.keymap.set('i', '<C-n>', '<Plug>(copilot-next)')

-- Map C-p for ad-hoc Copilot suggestion
vim.keymap.set('i', '<C-p>', '<Plug>(copilot-suggest)')

-- Toggle Copilot on/off with <Leader>p
vim.keymap.set('n', '<Leader>p', function()
  if vim.fn['copilot#Enabled']() == 1 then
    vim.cmd('Copilot disable')
  else
    vim.cmd('Copilot enable')
  end
  vim.cmd('Copilot status')
end, { silent = true })

-- Disable Copilot for large files
vim.api.nvim_create_autocmd('BufReadPre', {
  pattern = '*',
  callback = function()
    local f = vim.fn.getfsize(vim.fn.expand('<afile>'))
    if f == -2 or f > 100000 then
      vim.b.copilot_enabled = false
    end
  end,
})
