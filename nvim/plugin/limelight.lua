-- Set Limelight priority to -1 to not override hlsearch
vim.g.limelight_priority = -1

-- Toggle Limelight with <Leader>l in normal mode
vim.keymap.set('n', '<Leader>l', ':Limelight!!<CR>')

-- Toggle Limelight with <Leader>l for visual selection
vim.keymap.set('x', '<Leader>l', ':Limelight<CR>')
