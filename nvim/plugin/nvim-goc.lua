local goc = require('nvim-goc')
goc.setup({ verticalSplit = true })

-- Coverage highlight groups
vim.api.nvim_set_hl(0, 'goCoverageCovered', { link = 'Question' })
vim.api.nvim_set_hl(0, 'goCoverageUncover', { link = 'WarningMsg' })

-- Coverage and alternate file keymaps
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'go',
  callback = function()
    vim.keymap.set('n', '<Leader>c', goc.Coverage, { buffer = 0 })
    vim.keymap.set('n', '<Leader>cc', goc.ClearCoverage, { buffer = 0 })
    vim.keymap.set('n', '<Leader>a', goc.Alternate, { buffer = 0 })
    vim.keymap.set('n', '<Leader>A', goc.AlternateSplit, { buffer = 0 })
  end,
})
