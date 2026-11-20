# The `\` escape — one character, four positions

## Head position: force the line to prose

```udon
\|element
\:not-an-attr
\```not a fence
\\path\to
```

```events
Text "|element\n"
Text ":not-an-attr\n"
Text "```not a fence\n"
Text "\\path\\to\n"        ; first \ consumed, second is already prose
```

## Sameline head position

```udon
|element |another :val [234 19] \ how wonderful ; it is
```

```events
ElementStart element
  ElementStart another
    AttrStart val
      ArrayStart
        Scalar Int "234"
        Scalar Int "19"
      ArrayEnd
    AttrEnd
    Text " how wonderful ; it is\n"   ; \ consumes only itself; ; is literal here
  ElementEnd
ElementEnd
```

## In prose: escapes exactly the inline openers, else literal

```udon
|p see \|{em x} and C:\Users\me and wrap \
```

```events
ElementStart p
  Text "see |{em x} and C:\\Users\\me and wrap \\\n"
ElementEnd
```

*(One Text shown; fragmentation is unguaranteed either way. The escapes before `|{` are consumed; mid-word and trailing `\` pass through.)*

## The `\`-anchored indented prose block

```udon
|the-element |another
   \     Here all of this is output indented,
         even this more-indented line -- no marker needed --
      here too, smaller indent (still past the base);
  this dedents past the base: warning, base resets.
```

```events
ElementStart the-element
  ElementStart another
    Text "     Here all of this is output indented,\n"   ; base = the \ column (3)
    Text "      even this more-indented line -- no marker needed --\n"
    Text "   here too, smaller indent (still past the base);\n"
    Warning InconsistentIndentation
    Text "this dedents past the base: warning, base resets.\n"
  ElementEnd
ElementEnd
```

*(The consumed `\` takes no column: base=3, so line 2's col-9 keeps 6 spaces, line 3's col-6 keeps 3, and the col-2 line rebases. Exact interior spacing per CORE's example shape; the arithmetic here is the derived reading of "the text after it backs up one column into the `\`'s position".)*
