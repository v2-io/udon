# Fork `angle`: what `<…>` is for, and how a notation is named

*A fork of spike a (Opus 5.5, 2026-10-22), on DP4 and DP5 of `../../notes.md`. Joseph's two notes govern it: CTQ-FACTORS.md is the compass, and precedent is evidence to weigh against it; the estate's documents were written by fiat and are ideation, not evidence of how anyone writes. Where I say what agents would write or read, that's my instinct, labeled. Nothing committed.*

## What I took the question to be

Joseph reopened `<…>` "in all of its forms" and asked for the whole range of brackets and combinations, together with the type system. This fork asked: what jobs has `<…>` been given, which belong on it, and what spelling names a notation?

## What I found

1. **`<…>` has been asked to do seven jobs:** assert, self-end, carry, name, compose, be nil, quote. Quoting (`@{<…>}`) is a different kind of job and should leave the bracket. → [functions-and-the-no-go.md](functions-and-the-no-go.md)
2. **A no-go: one unlabeled bracket can't both reject (`<920px>` an error) and carry (`<2026-10-01>` accepted).** Rejecting needs a closed world, carrying an open one. Read literally, Joseph's 10-20 wording ("number, leading with [+\.\d-]") plus his 10-21 "<920px> error" and "(now we *can* commit/error)" already choose closed for digit-led interiors. The coordinator's restatement ("anything that isn't a primitive passes through raw") contradicts 10-21.
3. **Labels dissolve it.** The unlabeled form is closed (nil, booleans, numbers, delimited strings, else an error); the labeled form `<name: body>` is open (carried for whatever reads `name`).
4. **Lite already does the labeled half at block size:** a fence's head reads like an element's line and its body is carried for its name's handler (checked on the fence cards). `<name[key].trait: body>` is a value fence. One concept («notation» plus a handler per name), two sizes, and keys and traits mean what they mean on elements. The design: [ANG-4c](ang-4c-value-fence.md).
5. **Closed unlabeled turns the usual angle-bracket priors into teaching errors.** HTML tags, `<placeholder>`s, autolinks and `<=` become errors with suggestions, where an open form takes them in silently. *Instinct*, the main basis of the ranking.
6. **The question for Joseph that decides ANG-4c vs ANG-3: is a refinement a change?** If carrying a named body that a later version will read violates reserve-don't-ignore, fences already violate it. So either B2 admits refinement (the body must then be raw, never a string), or notations wait for full UDON and lite 0.1 is ANG-3 (closed, no notations), which can widen to ANG-4c later without breaking anything.
7. **This choice doesn't wait on DP1 (bare classification).** ANG-4c's unlabeled form is necessary if bare is always text, and is assertion (K14) and self-ending if bare is classified.
8. **Dates default to bare text** (`:date 2026-07-21`), read by the slot or schema, with `<date: 2026-07-21>` for an author who wants it said in the document. `<2026-07-21>` is an error that teaches both spellings. *Instinct:* an agent with no exposure writes dates bare.

## Branch map

| Branch | One line | Status |
|---|---|---|
| **ANG-4c** value fence, closed unlabeled | `<8080>` asserted; `<date: 2026-07-21>` carried; `<2026-07-21>` an error | **recommended** (1250) |
| ANG-4o value fence, open unlabeled | same, but `<2026-07-21>` carried as undetermined | live, second (1117) |
| ANG-3 closed, no notations | `<8080>` only; `<u64: 0xff>` reserved | live; the fallback if refinement is a change (1083) |
| ANG-1 raw box (the card today) | everything raw | live only if bare is classified; dominated (987 / 1047) |
| ANG-2 standard set else raw | `<8080>` a number, `<920px>` raw | dominated; contradicts his 10-21 (946) |
| ANG-5 notations as elements, `<…>` retired | `:when |{date 2026-07-21}` | alive only as "retire `<…>`" (946 / 1006) |
| other brackets: `(dt)…`, `⟨…⟩`, `<<…>>` | | dead: break existing text, add characters, or have no job |
| suffix label `<…:dt>` | | dead: decides late, collides with times |
| separators: space, bare `:`, `|` | | dead: `<today>`, `<https://x>`, `|` read as an element |
| notation on the slot `:when:dt …` | | handed to the slots fork; `:` is a label character in the lean |

Totals are weighted hypothesis scores over the discriminating factors (max 1660), in [scores.md](scores.md) with their basis. They double-count by design; read them as an order.

## Files

- [functions-and-the-no-go.md](functions-and-the-no-go.md): the seven jobs, the no-go, the DP1 dependency, the fence identity and the B2 question.
- [ang-4c-value-fence.md](ang-4c-value-fence.md): the recommended rule as a card would state it, the whole composite set with trees, the impact radius, and its costs.
- [other-branches.md](other-branches.md): every other branch, live and dead, with reasons.
- [scores.md](scores.md) and `scores.py`.

## For the debrief (what Joseph would want as examples)

```udon
|server[web] :port <8080> :timeout <dur: 30s> :started <datetime: 2026-07-21T14:20> ; prod
|ev :when <dt[DD-MM-YY]: 05-03-27> :also <dt.iso8601: 2026-07-21> :backup <>
|bad :a <920px>
|bad :b <2026-07-21>
|bad :c <b>bold</b>
|bad :d <dt:2026>
```
Each `|bad` line is an error on its own (an error stops parsing, so in one document only the first would be reported), each suggesting a fix: `920px` bare or `<px: 920>`; `2026-07-21` bare or `<date: 2026-07-21>`; `"<b>bold</b>"`; `<dt: 2026>`.
