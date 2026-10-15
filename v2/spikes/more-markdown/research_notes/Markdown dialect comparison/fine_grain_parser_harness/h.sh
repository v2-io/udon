#!/bin/bash
# usage: h.sh file [engines...]
f="$1"; shift
engines="${*:-cm gfm gfmpd gh ghc gl pd dj djjs myst mdoc mdx}"
D=$(dirname "$0")
GLFLAGS="--unsafe -e alerts,autolink,cjk-friendly-emphasis,description-lists,footnotes,math-code,math-dollars,multiline-block-quotes,strikethrough,table,tasklist,wikilinks-title-before-pipe --relaxed-tasklist-character --relaxed-autolinks --tasklist-classes --full-info-string -c none"
for e in $engines; do
  case $e in
    cm) r=$(node $D/run.mjs cmjs "$f");;
    gfm) r=$(comrak -c none --gfm --unsafe "$f" 2>&1);;
    gfmpd) r=$(pandoc -f gfm -t html "$f" 2>&1);;
    gh) r=$(jq -n --rawfile t "$f" '{text:$t,mode:"markdown"}' | gh api /markdown --input - 2>&1 | sed -E 's/ class="(heading-element|anchor)"//g; s/<a id="user-content[^>]*>.*<\/a>//g');;
    ghc) r=$(jq -n --rawfile t "$f" '{text:$t,mode:"gfm",context:"github/docs"}' | gh api /markdown --input - 2>&1);;
    gl) r=$(comrak $GLFLAGS "$f" 2>&1);;
    pd) r=$(pandoc -f markdown -t html "$f" 2>&1);;
    dj) r=$(pandoc -f djot -t html "$f" 2>&1);;
    djjs) r=$(node $D/run.mjs djotjs "$f");;
    myst) r=$(node $D/run.mjs myst "$f");;
    mdoc) r=$(node $D/run.mjs markdoc "$f");;
    mdx) r=$(node $D/run.mjs mdx "$f");;
    mdxgfm) r=$(node $D/run.mjs mdxgfm "$f");;
  esac
  printf '%-6s| %s\n' "$e" "$(echo "$r" | tr '\n' ' ' | sed -E 's/ +/ /g' | cut -c1-600)"
done
