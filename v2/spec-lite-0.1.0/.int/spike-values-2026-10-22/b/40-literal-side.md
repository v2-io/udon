# Branch page: the literal side (D4), given the other pages

> **Superseded in part (2026-10-22, later rounds).** This page's landing, that labelled forms are reserved in lite 0.1 and left to full UDON, is withdrawn: Joseph called it the starting premise restated. The designs are now on page 50 (the cold pass: NA, NB, NC, ND, scored) and page 60 (the inventive pass, whose system LW is the recommendation). What still stands here: the synergy with page 30 (δ3 dissolves most collisions of a value-initial `<`) and the strict primitives inside `<…>`.

*Spike b, 2026-10-22. Synthesizes `fork-P-literal-notation.md` (the play) and `fork-R-precedents.md` (§4 EDN, §6 sigils) against pages 10 and 30. Read fork P for the full branch set, the renderings and the deaths.*

## What the other decisions do to this one

1. **Under page 10's β3 (a normative JSON-grammar default reading), forcing a primitive (fork P's J1) is rare.** It shrinks to (a) numeric spellings outside JSON's grammar (`<0xFF>`, `<0o755>`, `<1_000_000>`), (b) the occasional override (`<8080>` in a slot typed text), and (c) `<>` for nil. The string side of overriding needs no mark: quoting already asserts a string.
2. **Under page 30's δ3 (a delimited value must stand alone), most of the prose collisions of value-initial `<` dissolve** [inferred; this synergy is new to me]:

```udon
|li <kbd>Ctrl</kbd> to copy           ; `<kbd>` runs on into `Ctrl`, so not alone: one text
|li <https://x.org> has more          ; followed by more text, so a run: one text
|li [Docs](https://x.org) for more    ; same: one text
|el :token <your-api-token>           ; alone, so a literal: strict interior, error, teaching
|el :mask <0xFF>                      ; alone, so a literal: 255, spelling kept
```
````tree
root
  |li
    :$main ‹<kbd>Ctrl</kbd> to copy›
  |li
    :$main ‹<https://x.org> has more›
  |li
    :$main ‹[Docs](https://x.org) for more›
  |el
    ERROR at 1:12: `<your-api-token>` is not a value lite reads; did you mean `\<your-api-token>` (text)?
  |el
    :mask 0xFF
````

   The case left is an angle form standing alone as a whole value. That is exactly where a writer is most likely to mean a literal, and where a strict interior gives an error rather than a silent misread. So δ3 removes the main argument for moving to `⟨…⟩` (fork P's P5), keeping ASCII `<` with its typing and guessability advantages. [inferred; confidence moderate]

## The landing for lite 0.1 (recommended)

- **`<…>` stays**, read strictly, standing alone:
  - `<>` is nil;
  - a primitive in the **rich set**, with commit at the first character and an error on mismatch (Joseph: "now we *can* commit/error"): `nil`, `true`, `false`, decimal, `0x`, `0o`, `0b` and `_` numbers, a delimited string;
  - **anything else is an error** (B2: refuse what a later UDON may define), including labelled forms (`<date 2026-01-10>`, `<u64:0xff>`). That matches Joseph's `<uint32|0x992BC>` "error- reserved for now".
- **Notations (J2) and composites (J3) are left to full UDON**, with two findings carried forward so that what lite reserves now spends as little as possible (B6):
  - **from EDN (fork R §4): the payload should be core-readable.** A tagged literal built "out of (and only out of) other readable elements" leaves an unaware parser with a complete tree. That is better on B1, B2, A6 and A7 than an opaque interior handed to a dialect. Composites nest naturally (`r[i[3 -7] 0d83.23]`, or `<r <i 3 -7> 0d83.23>`).
  - **from fork P: name before payload, and an attached tag (`date"2026-01-10"`) is the most guessable shape**, at the price of a bound on tag length (B1). `<label …>` commits at its first character with no bound. The choice between them belongs to full UDON. Lite's reservation of `<` + letter covers the `<label …>` route; the attached-tag route needs nothing reserved in lite today, because `date"…"` doesn't stand alone under δ3 and so is already text. [inferred: check if adopted]
- **Joseph's two-digit-year idea (`<27-03-05>`) needs an explicit century** in its notation, or a document's meaning changes with the clock, as REBOL's two-digit years do (fork R §5, checked). That is a B3 failure.
- **Units stay bare**, read by slot notations (page 20 §4; fork P P3).
- **Keeping something as itself** (Lisp quote, `@{<…>}`) is a different job from typing, per fork P §1. It should not share `<…>`. Not pursued here.

## What was left alive for Joseph

- `⟨…⟩` as the assertion bracket. It is clean against prose, but (fork P) it clashes with the transcripts' `‹…›`, and a cold agent will write `<…>` anyway. Its case is much weaker once δ3 is in place.
- If page 10 lands on β4 (no default reading), fork P's ranking flips toward a single first-character-commit bracket, because forcing a primitive becomes common. Then `⟨…⟩` vs `<…>` matters more.
