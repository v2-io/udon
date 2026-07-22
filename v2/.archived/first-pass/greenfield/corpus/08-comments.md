# Comments

## Root line comment with continuation (everything deeper is comment text)

```udon
; This would be a comment
  this is still part of the comment
  |even :this "structure"
\; But this line is output as text.
```

```events
CommentStart
  Text " This would be a comment"
  Text "this is still part of the comment"      ; continuation, verbatim, inert
  Text "|even :this \"structure\""
CommentEnd
Text "; But this line is output as text.\n"     ; head-\ consumed
```

*(Comment content never carries terminators — stripping the frame preserves line boundaries. What happens to a continuation line's *indentation* — stripped to the comment's column, or kept verbatim? — is not decidable from CORE's text. Shown stripped here, by analogy with prose content-base; flagged in the greenfield copy as needing one sentence.)*

## Comments participate in the hierarchy

```udon
|parent
  |child
   ; inside child
  ; sibling of child
; closes everything
|sibling
```

```events
ElementStart parent
  ElementStart child
    CommentStart
      Text " inside child"
    CommentEnd
  ElementEnd                     ; the col-2 comment pops child
  CommentStart
    Text " sibling of child"
  CommentEnd
ElementEnd                       ; the col-0 comment pops parent
CommentStart
  Text " closes everything"
CommentEnd
ElementStart sibling
ElementEnd
```

## Sameline comment: the whitespace frame

```udon
|li Item one ; TODO expand
|li Item one ;still prose
|li ratio 1;2 done
|li trailing wins ;
```

```events
ElementStart li
  Text "Item one"
  CommentStart
    Text " TODO expand"
  CommentEnd
  Text "\n"                      ; text-bearing line, annotation owned its end
ElementEnd
ElementStart li
  Text "Item one ;still prose\n" ; no space after ; → literal
ElementEnd
ElementStart li
  Text "ratio 1;2 done\n"        ; no space before → literal
ElementEnd
ElementStart li
  Text "trailing wins"
  CommentStart
  CommentEnd                     ; EOL is a valid after-boundary → empty comment
  Text "\n"
ElementEnd
```

*(Frame spaces: the space before ` ; ` is consumed as frame — geometry. So "Item one" not "Item one ". Derived: CORE never says which side keeps the space; the strip-comments-preserves-text goal argues the frame is geometry. Flagged in the greenfield copy.)*

## Comment at the prose base column vs deeper

```udon
|element
  Some prose content
  ; comment at the base — a comment
   ; deeper than base — literal prose
```

```events
ElementStart element
  Text "Some prose content\n"
  CommentStart
    Text " comment at the base — a comment"
  CommentEnd
  Text " ; deeper than base — literal prose\n"   ; 1 preserved space (col 3 - base 2)
ElementEnd
```
