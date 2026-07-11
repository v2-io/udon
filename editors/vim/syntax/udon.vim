" Vim syntax file for UDON (Universal Document & Object Notation)
" Spec: spec/FULL-SPEC.md v0.7-draft (December 2025)
"
" Safeset highlighting: only constructs whose parse is unambiguous from local
" context get color. Under-highlight rather than mis-highlight.
"   - `;` is a comment ONLY line-initial, or whitespace-preceded on a
"     structure line. Semicolons in block prose stay plain (they are literal).
"   - `|` opens an element only when followed by letter / [ / . / { / ' and
"     only line-initial or space-preceded on a structure line. Markdown table
"     pipes in prose stay plain.
"   - `!:lang:` raw bodies and ``` freeform bodies are uncolored verbatim.

if exists("b:current_syntax")
  finish
endif

" Indentation-scoped regions need full-file sync.
syn sync fromstart

" ---------------------------------------------------------------------------
" Raw and freeform bodies (defined first; later rules must not fire inside)
" ---------------------------------------------------------------------------

" !:lang: raw directive -- body is every following line indented past it.
syn region udonRawBlock matchgroup=udonRawLabel
      \ start=/^\z(\s*\)!:[[:alpha:]][[:alnum:]_-]*:\s*$/
      \ skip=/^\s*$/
      \ end=/^\%(\z1\s\)\@!/
      \ keepend contains=NONE

" ``` freeform block -- verbatim, indentation-insensitive. May open mid-line.
syn region udonFreeform matchgroup=udonFence
      \ start=/```/ end=/```/
      \ contains=NONE

" ---------------------------------------------------------------------------
" Comments and escapes
" ---------------------------------------------------------------------------

" Line-initial `;` is a block comment.
syn match udonComment /^\s*;.*$/ contains=udonTodo
syn keyword udonTodo TODO FIXME XXX NOTE contained

" Block-level escape: ' or \ followed by a marker char, at line start only.
syn match udonEscape /^\s*['\\][|;:!']/

" ---------------------------------------------------------------------------
" Inline forms (usable in prose and on structure lines)
" ---------------------------------------------------------------------------

" Transparent balanced-brace helper so inner { } don't close inline forms.
syn region udonBraceInner start=/{/ end=/}/ transparent contained
      \ contains=udonBraceInner

" |{element ...} embedded element
syn region udonEmbedded matchgroup=udonSigil start=/|{/ end=/}/
      \ contains=udonEmbeddedName,udonSamelineAttr,udonEmbedded,
      \udonAttrValueQuoted,udonAttrValueNumber,udonAttrValueConst,udonAttrValueList,
      \udonInlineComment,udonInterpolation,udonInlineRaw,udonInlineDirective,
      \udonBraceInner
syn match udonEmbeddedName /\%(|{\)\@2<=[[:alpha:]][[:alnum:]_-]*/ contained

" ;{...} inline comment (brace-counted)
syn region udonInlineComment matchgroup=udonComment start=/;{/ end=/}/
      \ contains=udonCommentBraceInner
syn region udonCommentBraceInner start=/{/ end=/}/ contained transparent
      \ contains=udonCommentBraceInner

" !{{expr | filter}} interpolation
syn region udonInterpolation matchgroup=udonSigil start=/!{{/ end=/}}/
      \ contains=udonFilterPipe,udonQuotedString
syn match udonFilterPipe /|\s*[[:alpha:]][[:alnum:]_-]*/ contained
      \ contains=udonFilterName
syn match udonFilterName /[[:alpha:]][[:alnum:]_-]*/ contained

" !{:kind: raw payload} inline raw (payload uncolored)
syn region udonInlineRaw matchgroup=udonRawLabel start=/!{:[[:alpha:]][[:alnum:]_-]*:/ end=/}/
      \ contains=udonBraceInner

" !{directive body} inline directive (body may nest inline forms)
syn region udonInlineDirective matchgroup=udonSigil start=/!{\%({\)\@!/ end=/}/
      \ contains=udonInlineDirectiveName,udonEmbedded,udonInlineComment,
      \udonInterpolation,udonBraceInner
syn match udonInlineDirectiveName /\%(!{\)\@2<=[[:alpha:]][[:alnum:]_-]*/ contained

" ---------------------------------------------------------------------------
" Structure-line pieces (contained; only fire inside the line regions below)
" ---------------------------------------------------------------------------

" Whitespace-preceded `;` comment (sameline context only).
syn match udonSamelineComment /\s\@1<=;\%({\)\@!.*$/ contained contains=udonTodo

" Element identity chain: |name?[id].class1.class2?
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

" Sameline attribute `:key value` -- value colored only when it is a single
" typed token (quoted / number / bool / nil / list); bare values stay plain.
syn match udonSamelineAttr /\%(^\|\s\)\@<=:\%('[^']*'\|"[^"]*"\|[[:alpha:]_$][[:alnum:]_.$-]*\)/
      \ contained contains=udonAttrColon
syn match udonAttrColon /:/ contained
" Values: must sit directly after `:key ` and be a complete token (followed
" by end-of-line, another attr, a comment, `}` or `]`). This keeps `42` in
" the bare block value `:note has 42 things` uncolored (it is string data).
syn match udonAttrValueQuoted /\%(:[[:alnum:]_.$'"-]\+\s\+\)\@<=\%("\%([^"\\]\|\\.\)*"\|'\%([^'\\]\|\\.\)*'\)\ze\%(\s*$\|\s\+[:;|]\|[}\]]\)/ contained
syn match udonAttrValueNumber /\%(:[[:alnum:]_.$'"-]\+\s\+\)\@<=-\?\%(0[xX]\x[0-9a-fA-F_]*\|0[oO][0-7][0-7_]*\|0[bB][01][01_]*\|\d[0-9_]*\%(\.\d[0-9_]*\)\?\%([eE][+-]\?\d\+\)\?\%(\/\d[0-9_]*r\)\?\)\ze\%(\s*$\|\s\+[:;|]\|[}\]]\)/ contained
syn match udonAttrValueConst /\%(:[[:alnum:]_.$'"-]\+\s\+\)\@<=\%(true\|false\|null\|nil\)\ze\%(\s*$\|\s\+[:;|]\|[}\]]\)/ contained
syn region udonAttrValueList matchgroup=udonSigil
      \ start=/\%(:[[:alnum:]_.$'"-]\+\s\+\)\@<=\[/ end=/\]/ contained oneline
      \ contains=udonListString,udonListNumber,udonListConst
syn match udonListString /"\%([^"\\]\|\\.\)*"\|'\%([^'\\]\|\\.\)*'/ contained
syn match udonListNumber /\%(^\|[\[ ]\)\@1<=-\?\d[0-9_]*\%(\.\d[0-9_]*\)\?\%([eE][+-]\?\d\+\)\?\ze[ \]]/ contained
syn match udonListConst /\%(^\|[\[ ]\)\@1<=\%(true\|false\|null\|nil\)\ze[ \]]/ contained

" Block directive name (!if, !for, !include, ...)
syn match udonDirectiveName /^\s*\zs![[:alpha:]][[:alnum:]_-]*/ contained

" ---------------------------------------------------------------------------
" Structure-line regions (line-scoped contexts)
" ---------------------------------------------------------------------------

" Element line: first non-space char is | followed by letter / [ / . / { / '
syn region udonElementLine start=/^\s*\ze|[[:alpha:]\[.{']/ end=/$/ keepend
      \ contains=udonElementChain,udonEmbedded,udonSamelineAttr,
      \udonAttrValueQuoted,udonAttrValueNumber,udonAttrValueConst,udonAttrValueList,
      \udonSamelineComment,udonInlineComment,udonInterpolation,udonInlineRaw,
      \udonInlineDirective,udonFreeform

" Block attribute line: first non-space char is : followed by a key char
syn region udonAttrLine start=/^\s*\ze:[[:alpha:]_'"$]/ end=/$/ keepend
      \ contains=udonSamelineAttr,udonSamelineComment,udonInlineComment,
      \udonAttrValueQuoted,udonAttrValueNumber,udonAttrValueConst,udonAttrValueList,
      \udonEmbedded,udonInterpolation,udonFreeform

" Directive line: !name args (raw `!:lang:` is claimed by udonRawBlock above)
syn region udonDirectiveLine start=/^\s*\ze![[:alpha:]]/ end=/$/ keepend
      \ contains=udonDirectiveName,udonElementChain,udonEmbedded,udonSamelineAttr,
      \udonAttrValueQuoted,udonAttrValueNumber,udonAttrValueConst,udonAttrValueList,
      \udonSamelineComment,udonInlineComment,udonInterpolation,udonInlineRaw,
      \udonInlineDirective,udonFreeform

" Anything else is prose: no line region; only the global inline forms above
" (udonEmbedded, udonInlineComment, udonInterpolation, udonInlineRaw,
" udonInlineDirective) apply. Mid-line ; | : stay plain -- by design.

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

syn match udonQuotedString /"\%([^"\\]\|\\.\)*"/ contained

let b:current_syntax = "udon"
