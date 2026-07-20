# Prose, content-base, blank lines, terminators

## The basic shape: sameline prose + indented continuation
```udon
|section **The great indent**
  This content is indented.
  Until the dedent.
|next
```

## Inconsistent indentation: warn and rebase
```udon
|the-parent |on-line-child
      first-line-of-prose...
   but what about this???
       four extra spaces
```

## Blank lines between prose
```udon
|article
  para one

  para two
```

## Prose interleaves freely with structure (head position every line)
```udon
|a
  here is prose
  |b a child element
  and more prose
```

## Deeper-than-base is inside the prose — markers inert
```udon
|el
  \  start some prose
    \some more prose
    ; not a comment — inside the prose
```

## Inline forms split prose Text; inline comments contribute nothing
```udon
|p This has ;{TODO: fix} some text |{em mid} and continues.
```

## Multiline inline element: per-line Text, continuation indent skipped
```udon
|p This has |{a :href /docs
   a link that spans
   multiple lines} and continues.
```
