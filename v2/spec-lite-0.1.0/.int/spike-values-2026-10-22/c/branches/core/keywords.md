# D6: spelling nil, true, false, and `<>`

*Spike c, branch family "core". Depends on D1 (sibling forks `Cv`, `B`) and D2 (`mark`); stated here under each.*

## What is fixed whichever way D1 goes

- **Lowercase only.** `True`, `FALSE`, `Nil` are text. (YAML 1.2's three cases of each (from memory) buy nothing an agent needs and add collisions.)
- **No other words.** `yes`, `no`, `on`, `off`, `y`, `n` are text: the Norway-proofing is that the word set is three words long.
- **`null` is text with a default-on warning "did you mean `nil`?"** (already Joseph's lean, [[rule:nil-spelling]]). Under a mark, `<null>` is an error with the same suggestion: inside a mark there is no text to fall back to.
- **Whole-run.** `true story`, `nil points`, `false start` are texts; the run must be exactly the word.

## Three branches for where the keywords live

### K1. Bare words are the spelling; the mark gives the kind-first form. *(survives; my lean)*

`:tls true`, `:note nil`. Under Cv (the lean) these are texts in the tree that the typed-primitive view reads as true and nil; under B they are true and nil in the tree. Either way a writer writes what JSON, YAML, TOML and Ruby/Elixir writers already write (A2). Where a kind must be known before the value arrives and no slot gives it (a streaming transcoder with no schema), the writer can mark it: `<true>`, `<nil>`, `<>`.

### K2. Only the marked spellings are keywords. *(dies, honestly)*

Under Cv with the view off, `:tls true` is the text `true` and only `<true>` is a boolean. Pure, kind-first everywhere, zero collisions. It dies on A2 and A9: a data file becomes `:tls <true> :debug <false> :note <>`, and an agent will write `:tls true` anyway, getting a lossless but unforeseen miss on every boolean in every schema-less document. The view exists to rescue exactly this case, so K2 is K1 with the view switched off; it isn't a separate design.

### K3. Punctuation for nil. *(dies)*

`~` (YAML, the old S1 draft): one more special character with one role (A8), and `<>` already gives a punctuation nil inside a mark that exists for other reasons. Nothing gained.

## `<>`

Joseph's lean: `<>` is nil, distinct from `""`, `''`, `<"">`, `<''>` and `<false>`. Worked through:

- **It falls out of the interior rule rather than adding one**, if the mark branch keeps "inside `<…>` the standard notation applies": an empty interior is the one interior that names no kind, and nil is the one kind with no content. `<nil>` then means the same, as an ordinary interior. Two spellings of one value, but by composition, not by a second rule; a printer can canonicalize to either (C10, round-trip, keeps the form anyway).
- **It gives the missing-value error its fix.** [[rule:missing-value]] errors on `:a` with nothing after it; under [[rule:anomalies-suggest-a-fix]] that error can say "did you mean `:a <>` (nil) or `:a ""` (empty string)?". That pairing is the strongest case for `<>`: the writer who left a value out is told the two things they might have meant, each one keystroke-cheap.
- **Cold comprehension (A3)**: a reader seeing `:note <>` reads "empty, nothing" — close enough to nil that the one possible confusion (empty string) is the one the spec names. Guessability (A2): an agent won't invent `<>` cold, but will write `nil`, which K1 covers. Moderate confidence on both.
- **Interaction**: `@{}` (empty reference) and `;{}` (empty inline comment, already a text piece) are different forms; `<>` being nil doesn't constrain them.

## Scores

| Factor (weight) | K1 + `<>` | K2 + `<>` | Basis, confidence |
|---|---|---|---|
| A2 guessability (10) | 9 | 4 | Agents write bare `true`/`nil`. High. |
| A3 cold comprehension (10) | 9 | 7 | Moderate. |
| A9 conciseness (6) | 9 | 5 | High. |
| A8 parsimony (8) | 8 | 8 | Neither adds a character; `<` is spent by the mark branch either way. |
| B4 errors that teach (8) | 9 | 8 | `null` and missing-value suggestions. Moderate. |
| C1 structured data (10) | 9 | 6 | High. |
