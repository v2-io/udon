# Prose, content-base, blank lines, terminators

## The basic shape: sameline prose + indented continuation

```udon
|section **The great indent**
  This content is indented.
  Until the dedent.
|next
```

```events
ElementStart section
  Text "**The great indent**\n"
  Text "This content is indented.\n"    ; 2-space content-base stripped (geometry)
  Text "Until the dedent.\n"
ElementEnd
ElementStart next
ElementEnd
```

*(Markdown inside prose is opaque — no events for `**…**`.)*

## Inconsistent indentation: warn and rebase

```udon
|the-parent |on-line-child
      first-line-of-prose...
   but what about this???
       four extra spaces
```

```events
ElementStart the-parent
  ElementStart on-line-child
    Text "first-line-of-prose...\n"     ; base = 6
    Warning InconsistentIndentation
    Text "but what about this???\n"     ; base rebases to 3
    Text "    four extra spaces\n"      ; 7 - 3 = 4 preserved spaces
  ElementEnd
ElementEnd
```

## Blank lines between prose

```udon
|article
  para one

  para two
```

```events
ElementStart article
  Text "para one\n"
  BlankLine
  Text "para two\n"
ElementEnd
```

*(Interior BlankLine — text material, `"\n"`. A trailing BlankLine before a
dedent would also be emitted; interior-vs-ornamental is the AST's whole-stream
disposition, not the event parser's.)*

## Prose interleaves freely with structure (head position every line)

```udon
|a
  here is prose
  |b a child element
  and more prose
```

```events
ElementStart a
  Text "here is prose\n"
  ElementStart b
    Text "a child element\n"
  ElementEnd                     ; "and more prose" at col 2 dedents b… 
  Text "and more prose\n"
ElementEnd
```

*(Careful case: `|b`'s base column is 2; the prose line at col 2 satisfies
`2 <= 2` → pops `b`, then is prose of `a`. But `b`'s sameline prose set no
content-base, so nothing holds the line inside `b` — consistent with "same
column = sibling", and prose-vs-element makes no difference to the stack rule.)*

## Deeper-than-base is inside the prose — markers inert

```udon
|el
  \  start some prose
    \some more prose
    ; not a comment — inside the prose
```

```events
ElementStart el
  Text "  start some prose\n"    ; head-\ consumed; sets base at the \ column
  Text "  \\some more prose\n"   ; past-base \ is literal (2 preserved spaces)
  Text "  ; not a comment — inside the prose\n"
ElementEnd
```

## Inline forms split prose Text; inline comments contribute nothing

```udon
|p This has ;{TODO: fix} some text |{em mid} and continues.
```

```events
ElementStart p
  Text "This has "
  CommentStart inline
    Text "TODO: fix"
  CommentEnd
  Text " some text "
  ElementStart em inline
    Text "mid"
  ElementEnd
  Text " and continues.\n"
ElementEnd
```

*(Strip the comment frames and concatenate: "This has  some text mid and
continues.\n" — the double space is real; both framing spaces around `;{…}` are
prose. CORE's example strips to a single space, which quietly deletes a real
space — flagged in the greenfield copy.)*

## Multiline inline element: per-line Text, continuation indent skipped

```udon
|p This has |{a :href /docs
   a link that spans
   multiple lines} and continues.
```

```events
ElementStart p
  Text "This has "
  ElementStart a inline
    AttrStart href
      Scalar Str "/docs"
    AttrEnd
    Text "\n"                    ; the opener line's terminator is inside the form
    Text "a link that spans\n"
    Text "multiple lines"
  ElementEnd
  Text " and continues.\n"
ElementEnd
```

*(Derived placement: the newline after `/docs` is content of the still-open
inline form — its line ends inside the braces. Flagged as an interpretation in
the greenfield copy; CORE says only "per-line Text events, each carrying its
line terminator".)*
