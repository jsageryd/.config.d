-- Inherit HTML settings (indent, commentstring, etc.)
vim.cmd('runtime! ftplugin/html.vim')

-- Turn on tree-sitter
vim.treesitter.start()
