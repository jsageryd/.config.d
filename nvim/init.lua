-- Set leader to ,
vim.g.mapleader = ','

-- Disable omnicompletion for SQL
vim.g.omni_sql_no_default_maps = 1

-- Avoid vim swap files and backups
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.writebackup = false

-- Indicate the 50th, 72nd, and 80th column
vim.opt.colorcolumn = '50,72,80'

-- Avoid the annoying info window in autocomplete
vim.opt.completeopt:remove('preview')

-- Expand tabs to spaces
vim.opt.expandtab = true

-- Use │ as fillchar to get contiguous vertical split separators
vim.opt.fillchars:append({ vert = '│' })

-- Add 2 to the default format options
vim.opt.formatoptions:append('2')

-- Use block cursor for all modes
vim.opt.guicursor = 'n-v-c-sm:block'

-- Reduce command history
vim.opt.history = 500

-- Make lowercase searches case-insensitive
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Turn off incremental search
vim.opt.incsearch = false

-- Prevent lines from wrapping in the middle of words
vim.opt.linebreak = true

-- Set better listchars and turn on list
vim.opt.listchars = {
  tab = '  ',
  nbsp = '␣',
  extends = '»',
  precedes = '«',
}
vim.opt.list = true

-- Turn off modelines CVE-2007-2438
vim.opt.modelines = 0

-- Enable increment/decrement (^a/^x) of letters and blanks
vim.opt.nrformats = { 'hex', 'alpha', 'blank' }

-- Show line numbers
vim.opt.nu = true

-- Number of spaces inserted or removed with >> or <<
vim.opt.shiftwidth = 2

-- Avoid showing the current mode (lightline already shows it)
vim.opt.showmode = false

-- Set spell checker language
vim.opt.spelllang = 'en_gb'

-- Size of a tab
vim.opt.tabstop = 2

-- Wrap at 80 characters by default
vim.opt.textwidth = 80

-- Time out for key codes (default 50ms in nvim)
vim.opt.ttimeoutlen = 0

-- Update time for diff markers; default is 4000 ms
vim.opt.updatetime = 100

-- Prevent line wrapping
vim.opt.wrap = false

-- Prevent search from wrapping at EOF
vim.opt.wrapscan = false

-- Set colour scheme
vim.opt.background = 'dark'
vim.cmd.colorscheme('hybrid-mod')

-- Set better colours for hlsearch
vim.api.nvim_set_hl(0, 'Search', { ctermfg = 226, ctermbg = 235 })

-- Link WinSeparator to VertSplit (nvim uses WinSeparator instead of VertSplit)
vim.api.nvim_set_hl(0, 'WinSeparator', { link = 'VertSplit' })

-- Highlight Git conflict markers
local conflict_group = vim.api.nvim_create_augroup('HighlightGitConflictMarkers', { clear = true })
vim.api.nvim_create_autocmd('BufEnter', {
  group = conflict_group,
  pattern = '*',
  callback = function()
    vim.fn.matchadd('conflictMarker', '^<<<<<<< .*$')
    vim.fn.matchadd('conflictMarker', '^>>>>>>> .*$')
    vim.fn.matchadd('conflictMarkerMiddle', '^=======$')
  end,
})
vim.api.nvim_set_hl(0, 'conflictMarker', { ctermbg = 29, ctermfg = 255 })
vim.api.nvim_set_hl(0, 'conflictMarkerMiddle', { ctermbg = 178, ctermfg = 255 })

-- Use <CR> for :noh
vim.keymap.set('n', '<CR>', ':noh<CR><CR>', { silent = true })

-- Use <tab> to cycle over windows
vim.keymap.set('n', '<tab>', '<c-w>w')

-- Use <S-tab> to cycle backwards over windows
vim.keymap.set('n', '<S-tab>', '<c-w>W')

-- Toggle folds with space, but only if there is a fold
vim.keymap.set('n', '<Space>', function()
  if vim.fn.foldlevel('.') > 0 then
    return 'za'
  else
    return '<Space>'
  end
end, { expr = true, silent = true })

-- Create new folds with space in visual mode
vim.keymap.set('v', '<Space>', 'zf')

-- Toggle last two buffers with <Leader><Leader>
vim.keymap.set('n', '<Leader><Leader>', '<C-^>')

-- Avoid q: typo that pops up the annoying command history box
vim.keymap.set('n', 'q:', ':q<CR>', { silent = true })

-- Set better text for folded lines
function _G.better_fold_text()
  local text = vim.trim(vim.fn.getline(vim.v.foldstart))

  if text:match('^[%(%[{<]$') then
    local secondline = vim.trim(vim.fn.getline(vim.v.foldstart + 1))
    secondline = secondline:gsub('%s+', ' ')
    text = text .. ' ' .. secondline
  end

  local lastline = vim.trim(vim.fn.getline(vim.v.foldend))

  if lastline:match('^[%)%]}<>]') then
    text = text .. ' ' .. lastline
  end

  local indent_level = vim.fn.indent(vim.v.foldstart)
  local indent

  if indent_level == 0 then
    indent = string.rep('-', indent_level)
  else
    indent = string.rep('-', indent_level - 1) .. ' '
  end

  return indent .. text .. ' (' .. vim.v.foldend - vim.v.foldstart + 1 .. ')'
end

vim.opt.foldtext = 'v:lua.better_fold_text()'

-- Define filetype for mail
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '*.mail',
  callback = function()
    vim.opt_local.filetype = 'mail'
    vim.opt_local.fileencoding = 'utf-8'
    vim.opt_local.fileformat = 'unix'
  end,
})

-- Define filetype for log files
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '*.log',
  callback = function()
    vim.opt_local.filetype = 'log'
  end,
})

-- Remove upon save: trailing whitespace, blank lines at beginning of file,
-- blank lines at end of file. Skip diffs to avoid corrupting patches.
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  command = [[
    if &modifiable && &filetype !=# 'diff' |
      :%s/\s\+$//e | :%s/\n\+\%$//e | :0s/^\n\+//e |
    endif
  ]],
})

-- Date shortcut
vim.cmd('iab <expr> _d strftime("%Y-%m-%d")')

-- Example text
vim.cmd('iab lorem '
  .. 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod '
  .. 'tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim '
  .. 'veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea '
  .. 'commodo consequat. Duis aute irure dolor in reprehenderit in voluptate '
  .. 'velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint '
  .. 'occaecat cupidatat non proident, sunt in culpa qui officia deserunt '
  .. 'mollit anim id est laborum.'
)
