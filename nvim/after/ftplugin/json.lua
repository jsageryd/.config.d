-- Fold based on syntax
vim.opt_local.foldmethod = 'syntax'

-- Don't auto-fold
vim.opt_local.foldlevel = 99
vim.opt_local.foldlevelstart = 99

-- Map <Leader>f to format using jq
vim.keymap.set('n', '<Leader>f', ':%!jq .<CR>', { buffer = true })
