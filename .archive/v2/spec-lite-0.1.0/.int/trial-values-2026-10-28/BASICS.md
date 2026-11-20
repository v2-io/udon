# UDON Lite in one page

*The exposure every trial agent starts from. It covers structure only; how values get kinds (numbers, dates, units) is deliberately left out, because that is what the trial is about.*

UDON Lite is a notation where structure and prose mix. Indentation decides nesting. It is read and written mostly by agents, usually without syntax highlighting.

```udon
; a comment line
|book[war-and-peace].classic :title War and Peace :lang ru
  :translator Louise and Aylmer Maude
  A long novel about five families.
  It starts in 1805.

  |chapter Book One
    |p Well, Prince, so Genoa and Lucca are now just family estates.
    |p See |{a :href /notes \ the notes} for more.  ; a framed comment
```

- `|name` opens an element. `[…]` right after the name is its key; `.word` a trait (a class-like tag).
- `:name value` is an attribute. Attributes can sit on the element's line or on the lines below it.
- An unquoted value runs to the end of the line, or until a space followed by another `:name`, `|name` or ` ; `. So `:title War and Peace :lang ru` gives `title` the value `War and Peace`.
- A framed backslash ` \ ` ends a value early: `|a :href /notes \ the notes` gives `href` the value `/notes`, and `the notes` is left over.
- Text left over on an element's own line is the element's `$main` (`|chapter Book One`: `$main` is `Book One`).
- Lines indented under an element that don't start with a marker are prose: its text children.
- `|{…}` is an element inside text. `;` at the start of a line is a comment; ` ; ` with spaces on both sides ends a line with a comment.
- `"…"` and `'…'` are quoted values (Ruby-like escapes in `"…"`). `[a b c]` is a list.
- Three or more backticks open a fenced block of verbatim text, as in Markdown.
