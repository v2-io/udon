" Vim filetype plugin for UDON
" Indentation is structural in UDON (like Python) and the spec forbids tabs.

if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

setlocal expandtab
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal tabstop=2

" Maintain the current indent on newline (UDON priority: never lose the column).
setlocal autoindent
setlocal nosmartindent
setlocal indentexpr=

" Folding follows indentation -- matches UDON's hierarchy rule.
setlocal foldmethod=indent
setlocal foldlevel=99

" Line comments start with `;` (only line-initial / whitespace-preceded in
" structure context; commentstring is used for whole-line comment toggles,
" which is the safe case).
setlocal comments=:;
setlocal commentstring=;\ %s

" IMPORTANT: `gq` / auto-wrap can silently change UDON structure (a wrapped
" word starting with | : ; ! at line start becomes structure). Prefer
" soft-wrap; do not auto-wrap prose.
setlocal formatoptions-=t
setlocal formatoptions-=a
setlocal wrap
setlocal linebreak
setlocal breakindent

let b:undo_ftplugin = "setlocal expandtab< shiftwidth< softtabstop< tabstop<"
      \ . " autoindent< smartindent< indentexpr< foldmethod< foldlevel<"
      \ . " comments< commentstring< formatoptions< wrap< linebreak< breakindent<"
