"Show line numbers
set nu

"Show file name in window header
set title

"Set leader to ,
let mapleader = ","

"Avoid modelines CVE-2007-2438
set modelines=0

"Use block cursor for all modes
set guicursor=n-v-c-sm:block

"Prevent line wrapping
set nowrap

"Make lowercase searches case-insensitive, mixed/upper-case case-sensitive
set ignorecase
set smartcase

"Prevent lines from wrapping in the middle of words
set lbr

"Size of a tab
set tabstop=2

"Size of the space inserted or removed with >> or <<
set shiftwidth=2

"Expand tabs to spaces
set expandtab

"Set number formats for ^a and ^x
set nf=alpha,bin,hex

"Set spell checker language
set spelllang=en_gb

"Avoid q: typo that opens the command history box
nnoremap q: :q

"Automatically remove upon save: trailing whitespace, blank lines at beginning
"of file, blank lines at end of file. Avoid for diffs to avoid corrupting them.
autocmd BufWritePre *
  \ if &modifiable && &filetype !=# 'diff' |
  \   :%s/\s\+$//e | :%s/\n\+\%$//e | :0s/^\n\+//e |
  \ endif

"Indicate the 50th, 72nd, and 80th column
set colorcolumn=50,72,80

"Use <tab> to cycle over windows
nnoremap <tab> <c-w>w
nnoremap <S-tab> <c-w>W

"Prevent search from wrapping at EOF
set nowrapscan

"Set text width to 80 for markdown
autocmd FileType markdown setlocal tw=80

"Avoid showing the current mode (e.g. "-- INSERT --") in the lower status bar
set noshowmode

"Define filetype for log files
autocmd BufEnter *.log setlocal filetype=log

"Avoid line wrapping for log files
autocmd FileType log setlocal tw=0
