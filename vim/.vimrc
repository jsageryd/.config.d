"Determine OS
let system_uname = system('uname -s')
let osx = system_uname =~? 'darwin'
let linux = system_uname =~? 'linux'
let windows = system_uname =~? 'mingw'

"Set tabstop for this file only
autocmd BufEnter .vimrc set ts=65 sw=65 noet

"Set modelines to 5. (check first 5 lines for mode commands, vi:set ~)
set mls=5

"Enable modelines
set ml

"Use auto-indent
set ai

"Use smart indent
set si

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

"Enable line wrapping
"set wrap

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

"Auto-completion mode
set wildmode=longest,list,full

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

"Avoid colouring of matching parentheses
let loaded_matchparen = 1

"Set number format. Added 'alpha' to enable alphabet increments (^A)
set nf=hex,octal,alpha

"Highlight current line
if !linux
  set cursorline
endif

"Search highlighting
set hlsearch

"Try to prevent syntax colouring from breaking
syntax sync fromstart

"Map ^T to run make
map <C-t> :w | :!make<CR><CR>

"LaTeX remark line
map s :s/^/%<CR>:noh<CR>

"LaTeX unremark line
map S :s/^%/<CR>:noh<CR>

"Set spell checker language
set spelllang=en_gb

"Enable spell checking
"set spell

"Enable menu during auto-complete
set wildmenu

"No join space. Prevents double space after period when joining lines.
set nojs

"Colouring
hi LineNr ctermfg=darkgreen ctermbg=none	"Set colour of line numbering
hi SpellBad cterm=undercurl ctermfg=darkred ctermbg=none	"Set colour of unregognised word
hi SpellCap cterm=undercurl ctermfg=darkyellow ctermbg=none	"Set colour of word that should start with capital
hi SpellLocal cterm=undercurl ctermfg=darkgreen ctermbg=none	"Set colour of word from another region
hi SpellRare cterm=undercurl ctermfg=darkyellow ctermbg=none	"Set colour of rare word

"Set listchars
if windows
  set listchars=tab:\ \ ,nbsp:~,extends:»,precedes:«
else
  set listchars=tab:\ \ ,nbsp:␣,extends:»,precedes:«
endif
set list

"Set colours cheme
if osx
  colorscheme ir_black
endif

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

"Autocomplete
autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#Complete

"Avoid vim swap files and backups
set noswapfile
set nobackup
set nowritebackup

"Automatically remove upon save: trailing whitespace, blank lines at beginning of file, blank lines at end of file
autocmd BufWritePre * :%s/\s\+$//e | :%s/\n\+\%$//e | :0s/\%^\n\+//e

"Fix backspace in Windows
if windows
  set backspace=indent,eol,start
endif
