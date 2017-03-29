" local syntax file - set colors on a per-machine basis:
" vim: tw=0 ts=4 sw=4
" Vim color file
" Maintainer:  dburman 

set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "phylite"

"hi Normal       gui=none guifg=#eeeeee guibg=#000000

hi Comment      gui=none guifg=#505050
hi Comment      gui=none ctermfg=grey
hi Constant     gui=bold guifg=#87b3c3
hi Constant     cterm=bold ctermfg=lightblue
hi Error        gui=none guifg=#ffffff guibg=#ff0000
hi Error        cterm=none ctermfg=white ctermbg=red
hi Identifier   gui=none guifg=#747474
hi Identifier   cterm=none ctermfg=gray
hi Number       gui=none guifg=#ffffff
hi Statement    gui=none guifg=#ffff00
hi Statement    cterm=none ctermfg=yellow
hi StatusLine   gui=none guifg=#d4d4d4 guibg=#474747
hi StatusLineNC gui=none guifg=#000000 guibg=#474747
hi String       gui=none guifg=#bd6bbc
hi String       cterm=none ctermfg=magenta
hi Type         gui=none guifg=#00ff00
hi Type         cterm=none ctermfg=green

hi Normal       guifg=white     guibg=black
hi Normal       ctermfg=white   ctermbg=black
hi NonText      guifg=#747474   ctermfg=lightMagenta
hi identifier   guifg=gray ctermfg=gray
hi preproc      guifg=red ctermfg=red
hi special      guifg=#4c6096   ctermfg=lightmagenta
hi Underlined   guifg=cyan      ctermfg=cyan
hi Underlined   gui=underline   cterm=underline

hi ErrorMsg     guifg=orange    guibg=darkBlue
hi ErrorMsg     ctermfg=lightRed ctermbg=darkBlue
hi WarningMsg   guifg=cyan      guibg=darkBlue  gui=bold
hi WarningMsg   ctermfg=cyan
hi ModeMsg      guifg=yellow    gui=NONE
hi ModeMsg      ctermfg=yellow
hi MoreMsg      guifg=yellow    gui=NONE
hi MoreMsg      ctermfg=yellow
hi Error        guifg=red       guibg=darkBlue  gui=underline
hi Error        ctermfg=red ctermbg=darkBlue cterm=underline

hi Todo         guifg=black     guibg=yellow
hi Todo         ctermfg=black   ctermbg=darkYellow
hi Cursor       guifg=black     guibg=white
hi Cursor       ctermfg=black   ctermbg=white
hi Search       guifg=black     guibg=yellow
hi Search       ctermfg=black   ctermbg=darkYellow
hi IncSearch    guifg=black     guibg=yellow
hi IncSearch    ctermfg=black   ctermbg=darkYellow
hi LineNr       guifg=pink      ctermfg=lightMagenta
hi title        guifg=white gui=bold    cterm=bold

hi StatusLineNC ctermfg=blue  ctermbg=black
hi StatusLine   ctermfg=cyan   ctermbg=black

hi label        guifg=cyan  ctermfg=cyan
hi operator     guifg=orange    gui=bold    ctermfg=darkYellow
hi clear Visual
hi Visual       term=reverse
hi Visual       ctermfg=black   ctermbg=darkCyan
hi Visual       guifg=black     guibg=darkCyan

hi DiffChange   guibg=darkGreen     guifg=black
hi DiffChange   ctermbg=darkGreen   ctermfg=black
hi DiffText     guibg=olivedrab     guifg=black
hi DiffText     ctermbg=lightGreen  ctermfg=black
hi DiffAdd      guibg=slateblue     guifg=black
hi DiffAdd      ctermbg=blue        ctermfg=black
hi DiffDelete   guibg=coral         guifg=black
hi DiffDelete   ctermbg=cyan        ctermfg=black

hi Folded       guibg=gray40        guifg=black
hi Folded       ctermbg=yellow      ctermfg=black
hi FoldColumn   guibg=gray30        guifg=black
hi FoldColumn   ctermbg=gray        ctermfg=black
hi cIf0         guifg=gray          ctermfg=gray



"set guifont=Lucida\ Console:h9

