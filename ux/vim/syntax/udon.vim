" Vim syntax file for UDON (Universal Document & Object Notation)
" Spec: spec/CORE.md (syntax is safeset; always under-highlight vs mis-highlight)
"
" Architecture:
"   - Default substrate is stock Markdown (syn include → @udonMarkdown),
"     owned by a whole-buffer region (udonMarkdownRoot).
"   - Structure (| : ! ; raw freeform) is *contained* in that root so the
"     root still covers prose lines (a top-level structure region on line 1
"     would steal \%^ and leave prose unhighlighted).
"   - Inline UDON forms (|{…}, ;{…}, !{{…}}, …) remain available in prose.
"
" Safeset notes:
"   - `;` is a comment ONLY line-initial, or whitespace-preceded on a
"     structure line. Semicolons in block prose stay markdown-literal.
"   - `|` opens an element only when followed by letter / [ / . / { / ' and
"     only line-initial or space-preceded on a structure line. Markdown
"     table pipes in prose stay with the markdown syntax.
"   - `!:lang:` raw bodies and ``` freeform bodies are uncolored verbatim
"     (UDON freeform claims ``` over markdown fenced-code).

if exists("b:current_syntax")
  finish
endif

syn sync fromstart

" ---------------------------------------------------------------------------
" Markdown substrate (stock runtime markdown.vim / Tim Pope)
" ---------------------------------------------------------------------------
if !exists('main_syntax')
  let main_syntax = 'udon'
endif
unlet! b:current_syntax
syn include @udonMarkdown syntax/markdown.vim
unlet! b:current_syntax
if exists('main_syntax') && main_syntax ==# 'udon'
  unlet main_syntax
endif

" ---------------------------------------------------------------------------
" Inline UDON forms
" ---------------------------------------------------------------------------

syn region udonBraceInner start=/{/ end=/}/ transparent contained
      \ contains=udonBraceInner

syn region udonEmbedded matchgroup=udonSigil start=/|{/ end=/}/
      \ contained
      \ contains=udonEmbeddedName,udonSamelineAttr,udonEmbedded,
      \udonAttrValueQuoted,udonAttrValueNumber,udonAttrValueConst,udonAttrValueList,
      \udonInlineComment,udonInterpolation,udonInlineRaw,udonInlineDirective,
      \udonBraceInner
syn match udonEmbeddedName /\%(|{\)\@2<=[[:alpha:]][[:alnum:]_-]*/ contained

syn region udonInlineComment matchgroup=udonComment start=/;{/ end=/}/
      \ contained
      \ contains=udonCommentBraceInner
syn region udonCommentBraceInner start=/{/ end=/}/ contained transparent
      \ contains=udonCommentBraceInner

syn region udonInterpolation matchgroup=udonSigil start=/!{{/ end=/}}/
      \ contained
      \ contains=udonFilterPipe,udonQuotedString
syn match udonFilterPipe /|\s*[[:alpha:]][[:alnum:]_-]*/ contained
      \ contains=udonFilterName
syn match udonFilterName /[[:alpha:]][[:alnum:]_-]*/ contained

syn region udonInlineRaw matchgroup=udonRawLabel start=/!{:[[:alpha:]][[:alnum:]_-]*:/ end=/}/
      \ contained
      \ contains=udonBraceInner

syn region udonInlineDirective matchgroup=udonSigil start=/!{\%({\)\@!/ end=/}/
      \ contained
      \ contains=udonInlineDirectiveName,udonEmbedded,udonInlineComment,
      \udonInterpolation,udonBraceInner
syn match udonInlineDirectiveName /\%(!{\)\@2<=[[:alpha:]][[:alnum:]_-]*/ contained

syn match udonQuotedString /"\%([^"\\]\|\\.\)*"/ contained

" ---------------------------------------------------------------------------
" Structure-line pieces (contained in structure line regions)
" ---------------------------------------------------------------------------

syn match udonSamelineComment /\s\@1<=;\%({\)\@!.*$/ contained contains=udonTodo

syn match udonElementChain /\%(^\s*\|\s\)\@<=|\%([[:alpha:]]\|[\[.']\)\@=[^ \t]*/
      \ contained contains=udonElemPipe,udonElemName,udonElemId,udonElemClass,
      \udonElemSuffix,udonSamelineAttr
syn match udonElemPipe /|/ contained
syn match udonElemName /\%(|\)\@1<=\%([[:alpha:]][[:alnum:]_-]*\|'[^']*'\)/ contained
syn region udonElemId matchgroup=udonSigil start=/\[/ end=/\]/ contained oneline
      \ contains=NONE
syn match udonElemClass /\.[[:alnum:]_-]\+/ contained contains=udonElemDot
syn match udonElemDot /\./ contained
syn match udonElemSuffix /[?*+!]/ contained

syn match udonSamelineAttr /\%(^\|\s\)\@<=:\%('[^']*'\|"[^"]*"\|[[:alpha:]_$][[:alnum:]_.$-]*\)/
      \ contained contains=udonAttrColon
syn match udonAttrColon /:/ contained
syn match udonAttrValueQuoted /\%(:[[:alnum:]_.$'"-]\+\s\+\)\@<=\%("\%([^"\\]\|\\.\)*"\|'\%([^'\\]\|\\.\)*'\)\ze\%(\s*$\|\s\+[:;|]\|[}\]]\)/ contained
syn match udonAttrValueNumber /\%(:[[:alnum:]_.$'"-]\+\s\+\)\@<=-\?\%(0[xX]\x[0-9a-fA-F_]*\|0[oO][0-7][0-7_]*\|0[bB][01][01_]*\|\d[0-9_]*\%(\.\d[0-9_]*\)\?\%([eE][+-]\?\d\+\)\?\%(\/\d[0-9_]*r\)\?\)\ze\%(\s*$\|\s\+[:;|]\|[}\]]\)/ contained
syn match udonAttrValueConst /\%(:[[:alnum:]_.$'"-]\+\s\+\)\@<=\%(true\|false\|null\|nil\)\ze\%(\s*$\|\s\+[:;|]\|[}\]]\)/ contained
syn region udonAttrValueList matchgroup=udonSigil
      \ start=/\%(:[[:alnum:]_.$'"-]\+\s\+\)\@<=\[/ end=/\]/ contained oneline
      \ contains=udonListString,udonListNumber,udonListConst
syn match udonListString /"\%([^"\\]\|\\.\)*"\|'\%([^'\\]\|\\.\)*'/ contained
syn match udonListNumber /\%(^\|[\[ ]\)\@1<=-\?\d[0-9_]*\%(\.\d[0-9_]*\)\?\%([eE][+-]\?\d\+\)\?\ze[ \]]/ contained
syn match udonListConst /\%(^\|[\[ ]\)\@1<=\%(true\|false\|null\|nil\)\ze[ \]]/ contained

syn match udonDirectiveName /^\s*\zs![[:alpha:]][[:alnum:]_-]*/ contained

" ---------------------------------------------------------------------------
" Structure / exclusive regions (contained in the markdown root)
" ---------------------------------------------------------------------------

syn region udonElementLine start=/^\s*\ze|[[:alpha:]\[.{']/ end=/$/ keepend contained
      \ contains=udonElementChain,udonEmbedded,udonSamelineAttr,
      \udonAttrValueQuoted,udonAttrValueNumber,udonAttrValueConst,udonAttrValueList,
      \udonSamelineComment,udonInlineComment,udonInterpolation,udonInlineRaw,
      \udonInlineDirective

syn region udonAttrLine start=/^\s*\ze:[[:alpha:]_'"$]/ end=/$/ keepend contained
      \ contains=udonSamelineAttr,udonSamelineComment,udonInlineComment,
      \udonAttrValueQuoted,udonAttrValueNumber,udonAttrValueConst,udonAttrValueList,
      \udonEmbedded,udonInterpolation

syn region udonDirectiveLine start=/^\s*\ze![[:alpha:]]/ end=/$/ keepend contained
      \ contains=udonDirectiveName,udonElementChain,udonEmbedded,udonSamelineAttr,
      \udonAttrValueQuoted,udonAttrValueNumber,udonAttrValueConst,udonAttrValueList,
      \udonSamelineComment,udonInlineComment,udonInterpolation,udonInlineRaw,
      \udonInlineDirective

syn match udonComment /^\s*;.*$/ contained contains=udonTodo
syn keyword udonTodo TODO FIXME XXX NOTE contained

syn match udonEscape /^\s*\\[|;:!\\]/ contained

syn region udonRawBlock matchgroup=udonRawLabel
      \ start=/^\z(\s*\)!:[[:alpha:]][[:alnum:]_-]*:\s*$/
      \ skip=/^\s*$/
      \ end=/^\%(\z1\s\)\@!/
      \ keepend contained contains=NONE

" Freeform ``` — listed in the root contains= after @udonMarkdown so it can
" claim fences over markdown fenced-code (same start; later group wins when
" both are contained candidates — definition order + contains list order).
syn region udonFreeform matchgroup=udonFence
      \ start=/```/ end=/```/
      \ keepend contained contains=NONE

" ---------------------------------------------------------------------------
" Whole-buffer root: markdown default + structure punches
" ---------------------------------------------------------------------------
" Defined last so it is the top-level owner of \%^. Everything else is
" contained here — never a competing top-level region at the same start.

syn region udonMarkdownRoot start=/\%^/ end=/\%$/ keepend
      \ contains=@udonMarkdown,
      \udonEmbedded,udonInlineComment,udonInterpolation,udonInlineRaw,udonInlineDirective,
      \udonElementLine,udonAttrLine,udonDirectiveLine,
      \udonComment,udonEscape,udonRawBlock,udonFreeform

" ---------------------------------------------------------------------------
" Highlight links
" ---------------------------------------------------------------------------

hi def link udonComment           Comment
hi def link udonInlineComment     Comment
hi def link udonSamelineComment   Comment
hi def link udonTodo              Todo
hi def link udonEscape            SpecialChar

hi def link udonSigil             Delimiter
hi def link udonElemPipe          Delimiter
hi def link udonElemDot           Delimiter
hi def link udonAttrColon         Delimiter
hi def link udonFence             Delimiter

hi def link udonElemName          Statement
hi def link udonEmbeddedName      Statement
hi def link udonElemId            Identifier
hi def link udonElemClass         Type
hi def link udonElemSuffix        Special

hi def link udonSamelineAttr      PreProc
hi def link udonAttrValueQuoted   String
hi def link udonListString        String
hi def link udonAttrValueNumber   Number
hi def link udonListNumber        Number
hi def link udonAttrValueConst    Boolean
hi def link udonListConst         Boolean
hi def link udonQuotedString      String

hi def link udonDirectiveName     Keyword
hi def link udonInlineDirectiveName Keyword
hi def link udonRawLabel          Special
hi def link udonInterpolation     Special
hi def link udonFilterName        Function

let b:current_syntax = "udon"
