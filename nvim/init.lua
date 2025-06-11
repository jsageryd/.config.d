-- nvim-tree: Turn off netrw to avoid race
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Show line numbers
vim.o.nu = true

-- Show file name in window header
vim.o.title = true

-- Set leader to ,
vim.g.mapleader = ','

-- Turn off modelines
vim.o.modelines = 0

-- Use block cursor for all modes
vim.o.guicursor = 'n-v-c-sm:block'

-- Prevent line wrapping
vim.o.wrap = false

-- Make lowercase searches case-insensitive
vim.o.ignorecase = true
vim.o.smartcase = true

-- Prevent lines from wrapping in the middle of words
vim.o.linebreak = true

-- Size of a tab
vim.o.tabstop = 2

-- Number of spaces inserted or removed with >> or <<
vim.o.shiftwidth = 2

-- Expand tabs to spaces
vim.o.expandtab = true

-- Set number formats for ^a and ^x
vim.o.nf = 'alpha,bin,hex'

-- Set spell checker language
vim.o.spelllang = 'en_gb'

-- Avoid q: typo that opens the command history box
-- TODO: try without
-- vim.api.nvim_set_keymap('n', 'q:', ':q', { noremap = true })

-- Automatically remove upon save: trailing whitespace, blank lines at beginning
-- of file, blank lines at end of file. Skip for diffs to avoid corrupt patches.
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  command = [[
    if &modifiable && &filetype !=# 'diff' |
      :%s/\s\+$//e | :%s/\n\+\%$//e | :0s/^\n\+//e |
    endif
  ]],
})

-- Indicate the 50th, 72nd, and 80th column
vim.o.colorcolumn = '50,72,80'

-- Use <tab> to cycle over windows
vim.api.nvim_set_keymap('n', '<tab>', '<c-w>w', { noremap = true })
vim.api.nvim_set_keymap('n', '<S-tab>', '<c-w>W', { noremap = true })

-- Prevent search from wrapping at EOF
vim.o.wrapscan = false

-- Set text width to 80 for markdown
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  command = 'setlocal tw=80',
})

-- Avoid showing the current mode (e.g. "-- INSERT --") in the lower status bar
-- vim.o.showmode = false

-- Define filetype for log files
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '*.log',
  command = 'setlocal filetype=log',
})

-- Avoid line wrapping for log files
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'log',
  command = 'setlocal tw=0',
})

-- nvim-tree config
require("nvim-tree").setup({
  renderer = {
    icons = {
      glyphs = {
        default = "",
        symlink = "@",
        bookmark = "+",
        modified = "●",
        hidden = ".",
        folder = {
          arrow_closed = "▶",
          arrow_open = "▼",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "@",
          symlink_open = "@",
        },
        git = {
          unstaged = "c",
          staged = "+",
          unmerged = "!",
          renamed = ">",
          untracked = "?",
          deleted = "-",
          ignored = ".",
        },
      }
    },
  },
  on_attach = function(bufnr)
    local api = require("nvim-tree.api")

    -- Set default mappings
    api.config.mappings.default_on_attach(bufnr)

    -- Use 's' for vertical split
    vim.keymap.set('n', 's', api.node.open.vertical, { buffer = bufnr, noremap = true, silent = true, nowait = true })

    -- Use <tab> to cycle over windows
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<tab>', '<c-w>w', { noremap = true })
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<S-tab>', '<c-w>W', { noremap = true })
  end,
})

-- Toggle nvim-tree with <Leader>n
vim.api.nvim_set_keymap('n', '<Leader>n', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- Use <CR> for :noh
vim.api.nvim_set_keymap('n', '<CR>', ':noh<CR><CR>', { noremap = true, silent = true })

-- Turn off incremental search
vim.o.incsearch = false
