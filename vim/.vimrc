"Pathogen
execute pathogen#infect()
filetype plugin indent on

"Determine OS
let system_uname = system('uname -s')
let osx = system_uname =~? 'darwin'
let linux = system_uname =~? 'linux'
let windows = has('win32') || system_uname =~? 'mingw'

"Set modelines to 5. (check first 5 lines for mode commands, vi:set ~)
set mls=5

"Enable modelines
set ml

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
set ic

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

"Set colours cheme
colorscheme ir_black

"Set command history
set history=500

"Highlight trailing space
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd BufWinEnter * let w:tws = matchadd('ExtraWhitespace', '\s\+$')
autocmd InsertEnter * call matchdelete(w:tws)
autocmd InsertLeave * let w:tws = matchadd('ExtraWhitespace', '\s\+$')
autocmd BufWinLeave * call matchdelete(w:tws)

"Highlight space before tab
highlight SpaceBeforeTab ctermbg=red guibg=red
autocmd BufWinEnter * let w:sbt = matchadd('SpaceBeforeTab', ' \+\ze\t')
autocmd InsertEnter * call matchdelete(w:sbt)
autocmd InsertLeave * let w:sbt = matchadd('SpaceBeforeTab', ' \+\ze\t')
autocmd BufWinLeave * call matchdelete(w:sbt)

"Highlight leading tabs
highlight TabCharacter ctermbg=black
call matchadd('TabCharacter', '^\t\+')

"Avoid q: typo that pops up the annoying command history box
map q: :q

"Some example text
abbreviate lorem Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis imperdiet cursus posuere. Duis vulputate lacus molestie justo placerat ac sollicitudin leo ornare. Suspendisse non leo a magna vulputate ultricies. Quisque molestie aliquet enim. Etiam vel sagittis justo. Vivamus lacinia blandit justo id tempor. Etiam augue nibh, varius laoreet eleifend ac, varius ac mi. Etiam elit neque, lacinia a ornare eu, facilisis ac arcu. Fusce nec neque diam, et imperdiet magna. Praesent elementum hendrerit mi quis aliquet. Integer eros massa, scelerisque vitae laoreet et, convallis eget mauris. Sed in sapien nec dolor tristique hendrerit eu ut odio. Sed at ligula diam.

"Automatically remove upon save: trailing whitespace, blank lines at beginning of file, blank lines at end of file
autocmd BufWritePre * :%s/\s\+$//e | :%s/\n\+\%$//e | :0s/^\n\+//e

"Fix backspace in Windows
if windows
  set backspace=indent,eol,start
endif

"Set text width for Subversion commit messages
autocmd FileType svn setlocal tw=72

"Set text width for Git commit messages
autocmd FileType gitcommit setlocal tw=72

"Get rid of 'Thanks for flying Vim'
let &titleold=''

"Toggle folds with space
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf

"Indicate the 81th column
set colorcolumn=81
highlight ColorColumn ctermbg=8

"Enable mouse
set ttymouse=xterm2
set mouse=a

"Run gofmt on save for Go files
autocmd FileType go autocmd BufWritePre <buffer> Fmt

"Add new filtype for mail
autocmd BufEnter *.mail setlocal filetype=mail fileencoding=utf-8 fileformat=unix

"Set text width for mail
autocmd FileType mail setlocal tw=72
