-- Enable fzf
vim.opt.rtp:append('/opt/homebrew/opt/fzf')

-- Use C-p for fzf
vim.keymap.set('n', '<C-p>', ':FZF<CR>')
