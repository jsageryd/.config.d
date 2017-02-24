"Vim is the future
set nocompatible

"Pathogen
execute pathogen#infect()
filetype plugin indent on

"Set leader to ,
let mapleader = ","

"Determine OS
let system_uname = system('uname -s')
let osx = system_uname =~? 'darwin'
let linux = system_uname =~? 'linux'
let windows = has('win32') || system_uname =~? 'mingw'

"Avoid modelines CVE-2007-2438
set modelines=0

"Use auto-indent
set ai

"Show line numbers
set nu

"Briefly show matching bracket
set showmatch

"Show file name in window header
set title

"Enable ruler (bottom right corner)
set ruler

"Enable syntax colouring
sy on

"Prevent line wrapping
set nowrap

"Ignore case when searching
"set ic

"Prevent lines breaking in the middle of words
set lbr

"Size of a tab
set tabstop=2

"Size of the space inserted or removed with >> or <<
set shiftwidth=2

"Expand tabs to spaces
set expandtab

"Default file encodings
" - Allow BOM to be recognised in an UTF-8 file
" - Use plain UTF-8 if there is no BOM
" - Allow non-latin1 to be recognised before latin1
" - Try latin1 if the file is not any of the above
set fileencodings=ucs-bom,utf-8,default,latin1

"Store files as UTF-8 (vim does not seem to read LANG on Windows)
if windows
  set encoding=utf-8
endif

"Set number format. Added 'alpha' to enable alphabet increments (^A)
set nf=hex,octal,alpha

"Highlight current line
"set cursorline

"Search highlighting
set hlsearch

"Try to prevent syntax colouring from breaking
syntax sync fromstart

"Set spell checker language
set spelllang=en_gb

"Enable spell checking
"set spell

"No join space. Prevents double space after period when joining lines.
set nojs

"Set listchars
if windows
  set listchars=tab:\ \ ,nbsp:~,extends:»,precedes:«
else
  set listchars=tab:\ \ ,nbsp:␣,extends:»,precedes:«
endif
set list

"Use dark background
set background=dark

"Set colour scheme
colorscheme hybrid

"Set command history
set history=500

"Highlight leading tabs
highlight TabCharacter ctermfg=233 ctermbg=0
call matchadd('TabCharacter', '^\t\+')

"Avoid q: typo that pops up the annoying command history box
map q: :q

"Some example text
abbreviate lorem Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis imperdiet cursus posuere. Duis vulputate lacus molestie justo placerat ac sollicitudin leo ornare. Suspendisse non leo a magna vulputate ultricies. Quisque molestie aliquet enim. Etiam vel sagittis justo. Vivamus lacinia blandit justo id tempor. Etiam augue nibh, varius laoreet eleifend ac, varius ac mi. Etiam elit neque, lacinia a ornare eu, facilisis ac arcu. Fusce nec neque diam, et imperdiet magna. Praesent elementum hendrerit mi quis aliquet. Integer eros massa, scelerisque vitae laoreet et, convallis eget mauris. Sed in sapien nec dolor tristique hendrerit eu ut odio. Sed at ligula diam.

"Automatically remove upon save: trailing whitespace, blank lines at beginning of file, blank lines at end of file
autocmd BufWritePre * :%s/\s\+$//e | :%s/\n\+\%$//e | :0s/^\n\+//e

"Fix backspace
set backspace=indent,eol,start

"Set text width for Subversion commit messages
autocmd FileType svn setlocal tw=72

"Set text width for Git commit messages
autocmd FileType gitcommit setlocal tw=72

"Get rid of 'Thanks for flying Vim'
let &titleold=''

"Toggle folds with space
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf

"Indicate the 50th, 72nd, and 80th column
set colorcolumn=50,72,80
highlight ColorColumn ctermbg=233

"Enable mouse
set ttymouse=xterm2
set mouse=a

"Add new filtype for mail
autocmd BufEnter *.mail setlocal filetype=mail fileencoding=utf-8 fileformat=unix

"Set text width for mail
autocmd FileType mail setlocal tw=72

"Always show status line
set laststatus=2

"No matter the colorscheme, use black background
hi Normal ctermbg=0

"Use goimports instead of gofmt
let g:go_fmt_command = "goimports"

"Toggle GoCoverage with <Leader>c
nnoremap <Leader>c :GoCoverageToggle<CR>

"Enable fzf
set rtp+=/usr/local/opt/fzf

"Use C-p for fzf
nnoremap <C-p> :FZF<CR>

"Use <Leader>b for git blame
nnoremap <Leader>b :Gblame<CR>

"Avoid vim swap files and backups
set noswapfile
set nobackup
set nowritebackup

"Toggle NERD tree with <Leader>n
nnoremap <silent> <Leader>n :NERDTreeToggle<CR>
let NERDTreeShowHidden=1

"Use <tab> to cycle over windows
noremap <tab> <c-w>w
noremap <S-tab> <c-w>W

"Toggle last two buffers with <Leader><Leader>
nnoremap <Leader><Leader> <C-^>

"Reload unmodified buffer without asking, if underlying file changes
"(this does not poll automatically, run :checktime to check all buffers)
set autoread

"Prevent search from wrapping at EOF
set nowrapscan

"Set text width to 80 for markdown
autocmd FileType markdown setlocal tw=80

"Disable vim-go's templates
let g:go_template_autocreate = 0

"Set Airline theme
let g:airline_theme = "base16color"

"Avoid the annoying info window in autocomplete
set completeopt-=preview

"Set better colours for hlsearch
hi Search cterm=none ctermfg=226 ctermbg=235

"Use <CR> to :noh
nnoremap <silent> <CR> :noh<CR><CR>

"Map gr to :GoRename
nnoremap <silent> gr :GoRename<CR>
