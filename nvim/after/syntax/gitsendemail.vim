" The upstream diff region ends on /^-- %/, a typo for the mail signature
" separator /^-- $/, so the region never closes: the signature and the git
" version trailing it are highlighted as diff content. Redefine it.
" `keepend` stops diff.vim's own `^-` match from extending past the
" signature, and `matchgroup` keeps the separator out of that match.
silent! syn clear gitsendemailDiff
syn region gitsendemailDiff
      \ start=/\%(^diff --\%(git\|cc\|combined\) \)\@=/
      \ matchgroup=gitsendemailSignature
      \ end=/^-- $/
      \ keepend fold contains=@gitsendemailDiff

" The diffstat between the `---` separator and the first diff header is
" left unhighlighted upstream.
syn match gitsendemailStatSep /^---$/
syn match gitsendemailStatFile /^ \S.\{-}\ze|/ contained containedin=gitsendemailStat
" The counts run `++--`, so the additions are anchored on the deletions
" rather than on the end of the line.
syn match gitsendemailStatAdd /+\+\ze-*$/ contained containedin=gitsendemailStat
syn match gitsendemailStatDel /-\+$/ contained containedin=gitsendemailStat
syn match gitsendemailStat /^ \S.\{-}|\s\+\d\+\s*[+-]*$/
syn match gitsendemailStatMode /^ \%(create\|delete\|rename\|copy\) .*$/
syn match gitsendemailStatSummary /^ \d\+ files\= changed.*$/

hi def link gitsendemailSignature Comment
hi def link gitsendemailStatSep diffFile
hi def link gitsendemailStatFile diffFile
hi def link gitsendemailStatAdd Added
hi def link gitsendemailStatDel Removed
hi def link gitsendemailStatMode PreProc
hi def link gitsendemailStatSummary Comment
