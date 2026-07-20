# The `\` escape — one character, four positions

## Head position: force the line to prose
```udon
\|element
\:not-an-attr
\```not a fence
\\path\to
```

## Sameline head position
```udon
|element |another :val [234 19] \ how wonderful ; it is
```

## In prose: escapes exactly the inline openers, else literal
```udon
|p see \|{em x} and C:\Users\me and wrap \
```

## The `\`-anchored indented prose block
```udon
|the-element |another
   \     Here all of this is output indented,
         even this more-indented line -- no marker needed --
      here too, smaller indent (still past the base);
  this dedents past the base: warning, base resets.
```
