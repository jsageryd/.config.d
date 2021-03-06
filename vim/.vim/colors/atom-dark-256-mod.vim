" This scheme was created by CSApproxSnapshot
" on mié, 03 dic 2014

hi clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = expand("<sfile>:t:r")

hi Normal         term=NONE         cterm=NONE      ctermbg=233 ctermfg=231

hi Boolean        term=NONE         cterm=NONE      ctermbg=bg  ctermfg=114
hi Character      term=NONE         cterm=NONE      ctermbg=bg  ctermfg=38
hi ColorColumn    term=reverse      cterm=NONE      ctermbg=234
hi Comment        term=bold         cterm=NONE      ctermbg=bg  ctermfg=244
hi Conceal        term=NONE         cterm=NONE      ctermbg=248 ctermfg=252
hi Conditional    term=NONE         cterm=NONE      ctermbg=bg  ctermfg=42
hi Constant       term=underline    cterm=NONE      ctermbg=bg  ctermfg=114
hi Cursor         term=NONE         cterm=NONE      ctermbg=243 ctermfg=255
hi CursorColumn   term=reverse      cterm=NONE      ctermbg=236
hi CursorLine     term=NONE         cterm=NONE      ctermbg=236
hi CursorLineNr   term=bold         cterm=NONE      ctermbg=bg  ctermfg=146
hi Debug          term=NONE         cterm=NONE      ctermbg=bg  ctermfg=145
hi Define         term=NONE         cterm=NONE      ctermbg=bg  ctermfg=81
hi Delimiter      term=NONE         cterm=NONE      ctermbg=bg  ctermfg=245
hi DiffAdd        term=bold         cterm=NONE      ctermbg=22  ctermfg=154
hi DiffChange     term=bold         cterm=NONE      ctermbg=236 ctermfg=220
hi DiffDelete     term=bold         cterm=NONE      ctermbg=52  ctermfg=196
hi DiffText       term=NONE         cterm=NONE      ctermbg=bg  ctermfg=245
hi Directory      term=bold         cterm=NONE      ctermbg=bg  ctermfg=248
hi Error          term=reverse      cterm=NONE      ctermbg=16  ctermfg=38
hi ErrorMsg       term=NONE         cterm=NONE      ctermbg=233 ctermfg=42
hi Exception      term=NONE         cterm=NONE      ctermbg=bg  ctermfg=186
hi Float          term=NONE         cterm=NONE      ctermbg=bg  ctermfg=114
hi FoldColumn     term=NONE         cterm=NONE      ctermbg=16  ctermfg=59
hi Folded         term=NONE         cterm=NONE      ctermbg=16  ctermfg=59
hi Function       term=NONE         cterm=NONE      ctermbg=bg  ctermfg=186
hi Identifier     term=underline    cterm=NONE      ctermbg=bg  ctermfg=146
hi Ignore         term=NONE         cterm=NONE      ctermbg=233 ctermfg=244
hi IncSearch      term=reverse      cterm=reverse   ctermbg=180 ctermfg=16
hi Keyword        term=NONE         cterm=NONE      ctermbg=bg  ctermfg=42
hi Label          term=NONE         cterm=NONE      ctermbg=bg  ctermfg=42
hi LineNr         term=underline    cterm=NONE      ctermbg=233 ctermfg=59
hi Macro          term=NONE         cterm=NONE      ctermbg=bg  ctermfg=180
hi MatchParen     term=reverse      cterm=NONE      ctermbg=238 ctermfg=145
hi ModeMsg        term=bold         cterm=bold      ctermbg=bg  ctermfg=155
hi MoreMsg        term=bold         cterm=bold      ctermbg=bg  ctermfg=155
hi NERDTreeLink   term=NONE         cterm=NONE      ctermbg=bg  ctermfg=fg
hi NonText        term=bold         cterm=bold      ctermbg=bg  ctermfg=59
hi Number         term=NONE         cterm=NONE      ctermbg=bg  ctermfg=114
hi Operator       term=NONE         cterm=NONE      ctermbg=bg  ctermfg=42
hi Pmenu          term=NONE         cterm=NONE      ctermbg=16  ctermfg=81
hi PmenuSbar      term=NONE         cterm=NONE      ctermbg=232 ctermfg=fg
hi PmenuSel       term=NONE         cterm=NONE      ctermbg=244 ctermfg=fg
hi PmenuThumb     term=NONE         cterm=NONE      ctermbg=16  ctermfg=81
hi PreCondit      term=NONE         cterm=NONE      ctermbg=bg  ctermfg=186
hi PreProc        term=underline    cterm=NONE      ctermbg=bg  ctermfg=186
hi Question       term=NONE         cterm=bold      ctermbg=bg  ctermfg=81
hi Repeat         term=NONE         cterm=NONE      ctermbg=bg  ctermfg=42
hi Search         term=reverse      cterm=NONE      ctermbg=156 ctermfg=16
hi SignColumn     term=NONE         cterm=NONE      ctermbg=233 ctermfg=186
hi Special        term=bold         cterm=NONE      ctermbg=233 ctermfg=81
hi SpecialChar    term=NONE         cterm=NONE      ctermbg=bg  ctermfg=42
hi SpecialComment term=NONE         cterm=NONE      ctermbg=bg  ctermfg=244
hi SpecialKey     term=bold         cterm=NONE      ctermbg=bg  ctermfg=59
hi SpellBad       term=reverse      cterm=undercurl ctermbg=bg  ctermfg=196
hi SpellCap       term=reverse      cterm=undercurl ctermbg=bg  ctermfg=63
hi SpellLocal     term=underline    cterm=undercurl ctermbg=bg  ctermfg=87
hi SpellRare      term=reverse      cterm=undercurl ctermbg=bg  ctermfg=231
hi Statement      term=bold         cterm=NONE      ctermbg=bg  ctermfg=42
hi StatusLine     term=bold,reverse cterm=NONE      ctermbg=231 ctermfg=59
hi StatusLineNC   term=reverse      cterm=reverse   ctermbg=244 ctermfg=232
hi StorageClass   term=NONE         cterm=NONE      ctermbg=bg  ctermfg=146
hi String         term=NONE         cterm=NONE      ctermbg=bg  ctermfg=38
hi Structure      term=NONE         cterm=NONE      ctermbg=bg  ctermfg=81
hi TabLine        term=underline    cterm=NONE      ctermbg=233 ctermfg=244
hi TabLineFill    term=reverse      cterm=reverse   ctermbg=233 ctermfg=233
hi TabLineSel     term=bold         cterm=bold      ctermbg=bg  ctermfg=fg
hi Tag            term=NONE         cterm=NONE      ctermbg=bg  ctermfg=42
hi Title          term=bold         cterm=NONE      ctermbg=bg  ctermfg=146
hi Todo           term=NONE         cterm=NONE      ctermbg=233 ctermfg=231
hi Type           term=underline    cterm=NONE      ctermbg=bg  ctermfg=81
hi Typedef        term=NONE         cterm=NONE      ctermbg=bg  ctermfg=81
hi Underlined     term=underline    cterm=underline ctermbg=bg  ctermfg=244
hi VertSplit      term=reverse      cterm=reverse   ctermbg=236 ctermfg=233
hi Visual         term=reverse      cterm=NONE      ctermbg=59  ctermfg=fg
hi VisualNOS      term=NONE         cterm=NONE      ctermbg=59  ctermfg=fg
hi WarningMsg     term=NONE         cterm=NONE      ctermbg=236 ctermfg=231
hi WildMenu       term=NONE         cterm=NONE      ctermbg=16  ctermfg=81

hi diffAdded   ctermfg=190
hi diffRemoved ctermfg=197

hi iCursor               term=NONE cterm=NONE ctermbg=243 ctermfg=255
hi pythonSpaceError      term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi pythonSync            term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimAuSyntax           term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimAugroup            term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimAugroupError       term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimAugroupSyncA       term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimAutoCmdSfxList     term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimAutoCmdSpace       term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimAutoEventList      term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimClusterName        term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimCmdSep             term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimCollClass          term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimCollection         term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimCommentTitleLeader term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimEcho               term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimEscapeBrace        term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimExecute            term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimExtCmd             term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimFiletype           term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimFilter             term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimFuncBlank          term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimFuncBody           term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimFunction           term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimGlobal             term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimGroupList          term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimHiBang             term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimHiCtermColor       term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimHiFontname         term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimHiGuiFontname      term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimHiKeyList          term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimHiLink             term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimHiTermcap          term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimIf                 term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimIsCommand          term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimMapLhs             term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimMapRhs             term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimMapRhsExtend       term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimMenuBang           term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimMenuMap            term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimMenuPriority       term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimMenuRhs            term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimNormCmds           term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimOperParen          term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimPatRegion          term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimPythonRegion       term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimRegion             term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimSet                term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimSetEqual           term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimSubstPat           term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimSubstRange         term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimSubstRep           term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimSubstRep4          term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimSynKeyRegion       term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimSynLine            term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimSynMatchRegion     term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimSynMtchCchar       term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimSynMtchGroup       term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimSynPatMod          term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimSynRegion          term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimSyncLinebreak      term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimSyncLinecont       term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimSyncLines          term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimSyncMatch          term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimSyncRegion         term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi vimUserCmd            term=NONE cterm=NONE ctermbg=bg  ctermfg=fg

hi LightLineLeft_command_0               term=bold cterm=bold ctermbg=148 ctermfg=22
hi LightLineLeft_command_0_1             term=NONE cterm=NONE ctermbg=240 ctermfg=148
hi LightLineLeft_command_0_raw           term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineLeft_command_0_tabsel        term=bold cterm=bold ctermbg=233 ctermfg=148
hi LightLineLeft_command_1               term=NONE cterm=NONE ctermbg=240 ctermfg=231
hi LightLineLeft_command_1_2             term=NONE cterm=NONE ctermbg=236 ctermfg=240
hi LightLineLeft_command_1_raw           term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineLeft_command_1_tabsel        term=NONE cterm=NONE ctermbg=233 ctermfg=240
hi LightLineLeft_command_2_raw           term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineLeft_command_2_tabsel        term=NONE cterm=NONE ctermbg=233 ctermfg=236
hi LightLineLeft_command_raw             term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineLeft_command_raw_0           term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineLeft_command_raw_1           term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineLeft_command_raw_2           term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineLeft_command_raw_raw         term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineLeft_command_raw_tabsel      term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineLeft_command_tabsel          term=NONE cterm=NONE ctermbg=233 ctermfg=250
hi LightLineLeft_command_tabsel_0        term=bold cterm=bold ctermbg=148 ctermfg=233
hi LightLineLeft_command_tabsel_1        term=NONE cterm=NONE ctermbg=240 ctermfg=233
hi LightLineLeft_command_tabsel_2        term=NONE cterm=NONE ctermbg=236 ctermfg=233
hi LightLineLeft_command_tabsel_raw      term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineLeft_command_tabsel_tabsel   term=NONE cterm=NONE ctermbg=233 ctermfg=233
hi LightLineLeft_inactive_0              term=NONE cterm=NONE ctermbg=233 ctermfg=240
hi LightLineLeft_inactive_0_1            term=NONE cterm=NONE ctermbg=236 ctermfg=233
hi LightLineLeft_inactive_0_tabsel       term=NONE cterm=NONE ctermbg=233 ctermfg=233
hi LightLineLeft_inactive_1_tabsel       term=NONE cterm=NONE ctermbg=233 ctermfg=236
hi LightLineLeft_inactive_tabsel         term=NONE cterm=NONE ctermbg=233 ctermfg=250
hi LightLineLeft_inactive_tabsel_0       term=NONE cterm=NONE ctermbg=233 ctermfg=233
hi LightLineLeft_inactive_tabsel_1       term=NONE cterm=NONE ctermbg=236 ctermfg=233
hi LightLineLeft_inactive_tabsel_tabsel  term=NONE cterm=NONE ctermbg=233 ctermfg=233
hi LightLineLeft_insert_0                term=bold cterm=bold ctermbg=231 ctermfg=23
hi LightLineLeft_insert_0_1              term=NONE cterm=NONE ctermbg=31  ctermfg=231
hi LightLineLeft_insert_0_raw            term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineLeft_insert_0_tabsel         term=bold cterm=bold ctermbg=233 ctermfg=231
hi LightLineLeft_insert_1                term=NONE cterm=NONE ctermbg=31  ctermfg=231
hi LightLineLeft_insert_1_2              term=NONE cterm=NONE ctermbg=24  ctermfg=31
hi LightLineLeft_insert_1_raw            term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineLeft_insert_1_tabsel         term=NONE cterm=NONE ctermbg=233 ctermfg=31
hi LightLineLeft_insert_2_raw            term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineLeft_insert_2_tabsel         term=NONE cterm=NONE ctermbg=233 ctermfg=24
hi LightLineLeft_insert_raw              term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineLeft_insert_raw_0            term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineLeft_insert_raw_1            term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineLeft_insert_raw_2            term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineLeft_insert_raw_raw          term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineLeft_insert_raw_tabsel       term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineLeft_insert_tabsel           term=NONE cterm=NONE ctermbg=233 ctermfg=250
hi LightLineLeft_insert_tabsel_0         term=bold cterm=bold ctermbg=231 ctermfg=233
hi LightLineLeft_insert_tabsel_1         term=NONE cterm=NONE ctermbg=31  ctermfg=233
hi LightLineLeft_insert_tabsel_2         term=NONE cterm=NONE ctermbg=24  ctermfg=233
hi LightLineLeft_insert_tabsel_raw       term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineLeft_insert_tabsel_tabsel    term=NONE cterm=NONE ctermbg=233 ctermfg=233
hi LightLineLeft_normal_0                term=bold cterm=bold ctermbg=148 ctermfg=22
hi LightLineLeft_normal_0_1              term=NONE cterm=NONE ctermbg=240 ctermfg=148
hi LightLineLeft_normal_0_raw            term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineLeft_normal_0_tabsel         term=bold cterm=bold ctermbg=233 ctermfg=148
hi LightLineLeft_normal_1                term=NONE cterm=NONE ctermbg=240 ctermfg=231
hi LightLineLeft_normal_1_2              term=NONE cterm=NONE ctermbg=236 ctermfg=240
hi LightLineLeft_normal_1_raw            term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineLeft_normal_1_tabsel         term=NONE cterm=NONE ctermbg=233 ctermfg=240
hi LightLineLeft_normal_2_raw            term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineLeft_normal_2_tabsel         term=NONE cterm=NONE ctermbg=233 ctermfg=236
hi LightLineLeft_normal_raw              term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineLeft_normal_raw_0            term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineLeft_normal_raw_1            term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineLeft_normal_raw_2            term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineLeft_normal_raw_raw          term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineLeft_normal_raw_tabsel       term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineLeft_normal_tabsel           term=NONE cterm=NONE ctermbg=233 ctermfg=250
hi LightLineLeft_normal_tabsel_0         term=bold cterm=bold ctermbg=148 ctermfg=233
hi LightLineLeft_normal_tabsel_1         term=NONE cterm=NONE ctermbg=240 ctermfg=233
hi LightLineLeft_normal_tabsel_2         term=NONE cterm=NONE ctermbg=236 ctermfg=233
hi LightLineLeft_normal_tabsel_raw       term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineLeft_normal_tabsel_tabsel    term=NONE cterm=NONE ctermbg=233 ctermfg=233
hi LightLineMiddle_command               term=NONE cterm=NONE ctermbg=236 ctermfg=245
hi LightLineMiddle_inactive              term=NONE cterm=NONE ctermbg=236 ctermfg=245
hi LightLineMiddle_normal                term=NONE cterm=NONE ctermbg=236 ctermfg=245
hi LightLineRight_command_0              term=NONE cterm=NONE ctermbg=252 ctermfg=59
hi LightLineRight_command_0_1            term=NONE cterm=NONE ctermbg=240 ctermfg=252
hi LightLineRight_command_0_raw          term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineRight_command_0_tabsel       term=NONE cterm=NONE ctermbg=233 ctermfg=252
hi LightLineRight_command_1              term=NONE cterm=NONE ctermbg=240 ctermfg=250
hi LightLineRight_command_1_2            term=NONE cterm=NONE ctermbg=236 ctermfg=240
hi LightLineRight_command_1_raw          term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineRight_command_1_tabsel       term=NONE cterm=NONE ctermbg=233 ctermfg=240
hi LightLineRight_command_2              term=NONE cterm=NONE ctermbg=236 ctermfg=247
hi LightLineRight_command_2_3            term=NONE cterm=NONE ctermbg=236 ctermfg=236
hi LightLineRight_command_2_raw          term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineRight_command_2_tabsel       term=NONE cterm=NONE ctermbg=233 ctermfg=236
hi LightLineRight_command_3_raw          term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineRight_command_3_tabsel       term=NONE cterm=NONE ctermbg=233 ctermfg=236
hi LightLineRight_command_raw            term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineRight_command_raw_0          term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineRight_command_raw_1          term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineRight_command_raw_2          term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineRight_command_raw_3          term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineRight_command_raw_raw        term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineRight_command_raw_tabsel     term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineRight_command_tabsel         term=NONE cterm=NONE ctermbg=233 ctermfg=250
hi LightLineRight_command_tabsel_0       term=NONE cterm=NONE ctermbg=252 ctermfg=233
hi LightLineRight_command_tabsel_1       term=NONE cterm=NONE ctermbg=240 ctermfg=233
hi LightLineRight_command_tabsel_2       term=NONE cterm=NONE ctermbg=236 ctermfg=233
hi LightLineRight_command_tabsel_3       term=NONE cterm=NONE ctermbg=236 ctermfg=233
hi LightLineRight_command_tabsel_raw     term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineRight_command_tabsel_tabsel  term=NONE cterm=NONE ctermbg=233 ctermfg=233
hi LightLineRight_inactive_0             term=NONE cterm=NONE ctermbg=59  ctermfg=233
hi LightLineRight_inactive_0_1           term=NONE cterm=NONE ctermbg=233 ctermfg=59
hi LightLineRight_inactive_0_tabsel      term=NONE cterm=NONE ctermbg=233 ctermfg=59
hi LightLineRight_inactive_1             term=NONE cterm=NONE ctermbg=233 ctermfg=240
hi LightLineRight_inactive_1_2           term=NONE cterm=NONE ctermbg=236 ctermfg=233
hi LightLineRight_inactive_1_tabsel      term=NONE cterm=NONE ctermbg=233 ctermfg=233
hi LightLineRight_inactive_2_tabsel      term=NONE cterm=NONE ctermbg=233 ctermfg=236
hi LightLineRight_inactive_tabsel        term=NONE cterm=NONE ctermbg=233 ctermfg=250
hi LightLineRight_inactive_tabsel_0      term=NONE cterm=NONE ctermbg=59  ctermfg=233
hi LightLineRight_inactive_tabsel_1      term=NONE cterm=NONE ctermbg=233 ctermfg=233
hi LightLineRight_inactive_tabsel_2      term=NONE cterm=NONE ctermbg=236 ctermfg=233
hi LightLineRight_inactive_tabsel_tabsel term=NONE cterm=NONE ctermbg=233 ctermfg=233
hi LightLineRight_insert_0               term=NONE cterm=NONE ctermbg=42 ctermfg=23
hi LightLineRight_insert_0_raw           term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineRight_insert_0_tabsel        term=NONE cterm=NONE ctermbg=233 ctermfg=42
hi LightLineRight_insert_1               term=NONE cterm=NONE ctermbg=31  ctermfg=42
hi LightLineRight_insert_1_2             term=NONE cterm=NONE ctermbg=24  ctermfg=31
hi LightLineRight_insert_1_raw           term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineRight_insert_1_tabsel        term=NONE cterm=NONE ctermbg=233 ctermfg=31
hi LightLineRight_insert_2               term=NONE cterm=NONE ctermbg=24  ctermfg=42
hi LightLineRight_insert_2_3             term=NONE cterm=NONE ctermbg=24  ctermfg=24
hi LightLineRight_insert_2_raw           term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineRight_insert_2_tabsel        term=NONE cterm=NONE ctermbg=233 ctermfg=24
hi LightLineRight_insert_3_raw           term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineRight_insert_3_tabsel        term=NONE cterm=NONE ctermbg=233 ctermfg=24
hi LightLineRight_insert_raw             term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineRight_insert_raw_0           term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineRight_insert_raw_1           term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineRight_insert_raw_2           term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineRight_insert_raw_3           term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineRight_insert_raw_raw         term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineRight_insert_raw_tabsel      term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineRight_insert_tabsel          term=NONE cterm=NONE ctermbg=233 ctermfg=250
hi LightLineRight_insert_tabsel_0        term=NONE cterm=NONE ctermbg=42 ctermfg=233
hi LightLineRight_insert_tabsel_1        term=NONE cterm=NONE ctermbg=31  ctermfg=233
hi LightLineRight_insert_tabsel_2        term=NONE cterm=NONE ctermbg=24  ctermfg=233
hi LightLineRight_insert_tabsel_3        term=NONE cterm=NONE ctermbg=24  ctermfg=233
hi LightLineRight_insert_tabsel_raw      term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineRight_insert_tabsel_tabsel   term=NONE cterm=NONE ctermbg=233 ctermfg=233
hi LightLineRight_normal_0               term=NONE cterm=NONE ctermbg=252 ctermfg=59
hi LightLineRight_normal_0_1             term=NONE cterm=NONE ctermbg=240 ctermfg=252
hi LightLineRight_normal_0_raw           term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineRight_normal_0_tabsel        term=NONE cterm=NONE ctermbg=233 ctermfg=252
hi LightLineRight_normal_1               term=NONE cterm=NONE ctermbg=240 ctermfg=250
hi LightLineRight_normal_1_2             term=NONE cterm=NONE ctermbg=236 ctermfg=240
hi LightLineRight_normal_1_raw           term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineRight_normal_1_tabsel        term=NONE cterm=NONE ctermbg=233 ctermfg=240
hi LightLineRight_normal_2               term=NONE cterm=NONE ctermbg=236 ctermfg=247
hi LightLineRight_normal_2_3             term=NONE cterm=NONE ctermbg=236 ctermfg=236
hi LightLineRight_normal_2_raw           term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineRight_normal_2_tabsel        term=NONE cterm=NONE ctermbg=233 ctermfg=236
hi LightLineRight_normal_3_raw           term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineRight_normal_3_tabsel        term=NONE cterm=NONE ctermbg=233 ctermfg=236
hi LightLineRight_normal_raw             term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineRight_normal_raw_0           term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineRight_normal_raw_1           term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineRight_normal_raw_2           term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineRight_normal_raw_3           term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineRight_normal_raw_raw         term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineRight_normal_raw_tabsel      term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineRight_normal_tabsel          term=NONE cterm=NONE ctermbg=233 ctermfg=250
hi LightLineRight_normal_tabsel_0        term=NONE cterm=NONE ctermbg=252 ctermfg=233
hi LightLineRight_normal_tabsel_1        term=NONE cterm=NONE ctermbg=240 ctermfg=233
hi LightLineRight_normal_tabsel_2        term=NONE cterm=NONE ctermbg=236 ctermfg=233
hi LightLineRight_normal_tabsel_3        term=NONE cterm=NONE ctermbg=236 ctermfg=233
hi LightLineRight_normal_tabsel_raw      term=NONE cterm=NONE ctermbg=bg  ctermfg=fg
hi LightLineRight_normal_tabsel_tabsel   term=NONE cterm=NONE ctermbg=233 ctermfg=233
