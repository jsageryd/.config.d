"Vim is the future
set nocompatible

"Load plugin files per file type
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

"Make lowercase searches case-insensitive, mixed/upper-case case-sensitive
set ignorecase
set smartcase

"Prevent lines breaking in the middle of words
set lbr

"Size of a tab
set tabstop=2

"Size of the space inserted or removed with >> or <<
set shiftwidth=2

"Expand tabs to spaces
set expandtab

"Size of a tab for markdown
autocmd FileType markdown setlocal tabstop=2

"Size of space inserted or removed with >> or << for markdown
autocmd FileType markdown setlocal shiftwidth=2

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

"Set dark background
set background=dark

"Set colour scheme
colorscheme hybrid-mod

"Set command history
set history=500

"Avoid q: typo that pops up the annoying command history box
nnoremap q: :q

"Some example text
iab lorem Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

"Date shortcut
iab <expr> _d strftime("%Y-%m-%d")

"Automatically remove upon save: trailing whitespace, blank lines at beginning
"of file, blank lines at end of file. Avoid for diffs to avoid corrupting them.
autocmd BufWritePre *
  \ if &modifiable && &filetype !=# 'diff' |
  \   :%s/\s\+$//e | :%s/\n\+\%$//e | :0s/^\n\+//e |
  \ endif

"Fix backspace
set backspace=indent,eol,start

"Set text width for Subversion commit messages
autocmd FileType svn setlocal tw=72

"Set text width for Git commit messages
autocmd FileType gitcommit setlocal tw=72

"Turn on spell checker for Git commit messages
autocmd FileType gitcommit setlocal spell

"Turn off text width for ledger files
autocmd FileType ledger setlocal tw=0

"Get rid of 'Thanks for flying Vim'
let &titleold=''

"Toggle folds with space, but only if there is a fold
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>

"Create new folds with space in visual mode
vnoremap <Space> zf

"Auto-fold based on syntax for Go files
autocmd FileType go setlocal foldmethod=syntax

"Don't auto-fold for Go files
autocmd FileType go setlocal foldlevel=99
autocmd FileType go setlocal foldlevelstart=99

"Prevent unfolding on save for Go files
let g:go_fmt_experimental = 1

"Set better text for folded lines
function! FoldText()
  let text = trim(getline(v:foldstart), "\s\t")

  if text =~ '^[(\[{<]$'
    let secondline = trim(getline(v:foldstart + 1), "\s\t")
    let secondline = substitute(secondline, '\s\+', ' ', 'g')
    let text ..= ' ' .. secondline
  endif

  let lastline = trim(getline(v:foldend), "\s\t")

  if lastline =~ '^[)\]}<>]'
    let text ..= ' ... ' .. lastline
  endif

  let indent_level = indent(v:foldstart)

  if indent_level == 0
    let indent = repeat('-', indent_level)
  else
    let indent = repeat('-', indent_level - 1) .. ' '
  endif

  return indent .. text .. ' (' .. (v:foldend - v:foldstart + 1) .. ') '
endfunction

set foldtext=FoldText()

"Indicate the 50th, 72nd, and 80th column
set colorcolumn=50,72,80

"Enable mouse
set ttymouse=xterm2
set mouse=a

"Add new filtype for mail
autocmd BufEnter *.mail setlocal filetype=mail fileencoding=utf-8 fileformat=unix

"Set text width for mail
autocmd FileType mail setlocal tw=72

"Always show status line
set laststatus=2

"Use goimports instead of gofmt
let g:go_fmt_command = "goimports"

"Toggle GoCoverage with <Leader>c
nnoremap <Leader>c :GoCoverageToggle<CR>

"Run GoSameIds with <Leader>s
nnoremap <Leader>s :GoSameIds<CR>

"Enable fzf
set rtp+=/opt/homebrew/opt/fzf

"Use C-p for fzf
nnoremap <C-p> :FZF<CR>

"Use <Leader>b for git blame
nnoremap <Leader>b :Git blame<CR>

"Avoid vim swap files and backups
set noswapfile
set nobackup
set nowritebackup

"Toggle NERD tree with <Leader>n
nnoremap <silent> <Leader>n :NERDTreeToggle<CR>
let NERDTreeShowHidden=1

"Toggle Limelight with <Leader>l
nnoremap <Leader>l :Limelight!!<CR>
xnoremap <Leader>l :Limelight<CR>

"Set Limelight priority to -1 to not override hlsearch
let g:limelight_priority = -1

"Hide .DS_Store from NERDTree tree
let NERDTreeIgnore=['\.DS_Store']

"Hide NERDTree help text etc.
let NERDTreeMinimalUI=1

"Don't collapse directories with single child
let NERDTreeCascadeSingleChildDir=0

"Don't recursively open directories with single child
let NERDTreeCascadeOpenSingleChildDir=0

"Use <tab> to cycle over windows
nnoremap <tab> <c-w>w
nnoremap <S-tab> <c-w>W

"<C-I> ( == <tab>) now cycles windows; use <Leader>i to get original <C-I>
nnoremap <Leader>i <C-I>

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

"Avoid the annoying info window in autocomplete
set completeopt-=preview

"Set better colours for hlsearch
hi Search cterm=none ctermfg=226 ctermbg=235

"Use <CR> to :noh and :GoSameIdsClear
nnoremap <silent> <CR> :noh<bar>:call ExecIfExists('GoSameIdsClear')<CR><CR>

"Map gr to :GoRename
nnoremap <silent> gr :GoRename<CR>

"Use <Leader>{<Down>,<Up>} to go to next and previous unstaged change
nmap <Leader><Down> <Plug>(GitGutterNextHunk)
nmap <Leader><Up> <Plug>(GitGutterPrevHunk)

"Wrap at 80 chars by default
set textwidth=80

"Add 2 to the default format options
set formatoptions+=2

"Make mouse mode work past the 223rd column
set ttymouse=sgr

"Use ga in visual mode to trigger vim-easy-align
xmap ga <Plug>(EasyAlign)

"Use │ as fillchar to get contiguous vertical split separators
set fillchars+=vert:│

"Avoid showing the current mode (e.g. "-- INSERT --") in the lower status bar
set noshowmode

"Time out after 0 ms for key codes (the default value is -1 which makes it
"assume the value of timeoutlen, default 1000 ms) to make it faster to switch
"from insert mode to normal mode.
set ttimeoutlen=0

"Map <Leader>f to format JSON using jq
autocmd FileType json nnoremap <Leader>f :%!jq .<CR>

"Show file path relative to repo root in status bar instead of just the filename
let g:lightline = { 'component_function': { 'filename': 'LightlineFilename' } }
function! LightlineFilename()
  let root = fnamemodify(get(b:, 'git_dir'), ':h')
  let path = expand('%:p')
  if path[:len(root)-1] ==# root
    return path[len(root)+1:]
  endif
  return expand('%')
endfunction

"Disable omnicompletion for SQL
let g:omni_sql_no_default_maps = 1

"Update time for the git-gutter diff markers; default is 4000 ms.
set updatetime=500

"Define filetype for log files
autocmd BufEnter *.log setlocal filetype=log

"Avoid line wrapping for log files
autocmd FileType log setlocal tw=0

"Map C-n to cycle to next Copilot suggestion
inoremap <C-n> <Plug>(copilot-next)

"Make vim-visual-multi case sensitive
let g:VM_case_setting = 'sensitive'

"Make Copilot suggestions faster
let g:copilot_idle_delay = 0

"Enable Copilot by default
let g:copilot_enabled = v:true

"Enable Copilot for specific filetypes only
let g:copilot_filetypes = {
  \   '*': v:false,
  \   'gitcommit': v:true,
  \   'go': v:true,
  \   'gohtmltmpl': v:true,
  \   'log': v:true,
  \   'markdown': v:true,
  \   'yaml': v:true,
  \ }

"Toggle Copilot on/off with <Leader>p
nnoremap <silent> <Leader>p :call ToggleCopilot()<CR>

function! ToggleCopilot()
  if copilot#Enabled()
    Copilot disable
  else
    Copilot enable
  endif
  Copilot status
endfunction

"Map C-p for ad-hoc Copilot suggestion
inoremap <C-p> <Plug>(copilot-suggest)

"Disable Copilot for large files
autocmd BufReadPre *
  \ let f=getfsize(expand("<afile>"))
  \ | if f == -2 || f > 100000
  \ |   let b:copilot_enabled = v:false
  \ | endif

"ExecIfExists runs cmd only if cmd exists
function! ExecIfExists(cmd)
  if exists(':' . a:cmd)
    execute a:cmd
  endif
endfunction

"Highlight Git conflict markers
function! HighlightGitConflictMarkers()
  syn match conflictMarker /^<<<<<<< .*$/ containedin=ALL
  syn match conflictMarker /^>>>>>>> .*$/ containedin=ALL
  syn match conflictMarkerMiddle /^=======$/ containedin=ALL
  hi conflictMarker ctermbg=29 ctermfg=255
  hi conflictMarkerMiddle ctermbg=178 ctermfg=255
endfunction

augroup HighlightGitConflictMarkers
  autocmd!
  autocmd BufEnter * call HighlightGitConflictMarkers()
augroup END

"Override nrformats for C-a, C-x
set nrformats=hex,alpha,blank
