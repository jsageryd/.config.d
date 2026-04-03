-- Turn on tree-sitter
vim.treesitter.start()

-- Fold based on syntax
vim.opt_local.foldmethod = 'syntax'

-- Don't auto-fold
vim.opt_local.foldlevel = 99
vim.opt_local.foldlevelstart = 99

-- Format using jq: <Leader>f (pretty), <Leader>F (compact)
vim.keymap.set('n', '<Leader>f', ':%!jq .<CR>', { buffer = true })
vim.keymap.set('x', '<Leader>f', ':!jq .<CR>', { buffer = true })
vim.keymap.set('n', '<Leader>F', ':%!jq -c .<CR>', { buffer = true })
vim.keymap.set('x', '<Leader>F', ':!jq -c .<CR>', { buffer = true })
