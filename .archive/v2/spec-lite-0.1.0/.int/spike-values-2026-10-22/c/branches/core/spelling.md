# D4, continued: how strict the number spelling is

*Spike c, branch family "core". A proposal to argue with, not a card. Precedents are from memory (TOML 1.0, JSON RFC 8259, YAML 1.2 core schema) and are weighed, not leaned on.*

## The governing idea

One **standard numeric notation**, used identically wherever a number is classified: by the typed-primitive view over a bare run, inside `<…>` (if the mark branch gives `<…>` primitives), in keys and list items if they classify, and by a strict getter `int(:port)`. One notation means one thing to learn (A6, A7) and one tree per document in every parser (B3).

Strictness is chosen by the lossy/lossless-miss distinction (`kinds-and-test.md`): a spelling is admitted as a number only where reading it as a number can't silently destroy what a writer meant as text.

## The notation (proposal)

```text
number   = int | float
int      = sign? ( "0" | [1-9] digits? )            ; decimal: no leading zero
         | ( "0x" hexdigit+ | "0o" [0-7]+ | "0b" [01]+ )   with "_" allowed between digits
                                                     ; prefixed: no sign, lowercase prefix
float    = sign? ( "0" | [1-9] digits? ) "." digits exponent?
         | sign? ( "0" | [1-9] digits? ) exponent
exponent = ( "e" | "E" ) sign? digit+                 ; digits in the exponent: no "_"
digits   = digit ( "_"? digit )*                      ; "_" only singly, between two digits
sign     = "+" | "-"
```

What each choice buys, and its cost:

| Spelling | Classified? | Why |
|---|---|---|
| `01234`, `007`, `0755` | **no** (text) | Lossy if read as a number (zip codes, IDs, Bond). Inside a mark, an error that suggests `<"01234">` or `<1234>` (B4). The old line made `0755` decimal 755; that is exactly a lossy silent miss. |
| `1_000_000` | yes | Readability; no collision. Single `_` between digits only: `1__0`, `1_`, `_1` are text (the old line accepted all three, a validation gap). |
| `+42` | yes | Symmetry with `-`; JSON lacks it, TOML has it (from memory). Low stakes. |
| `-0` | yes, int 0 | Spelling kept; hosts with a signed zero get it from a float spelling `-0.0`. |
| `5.`, `.5` | **no** (text) | `.5` collides with prose and traits-after-spaces ([[rule:traits-may-follow-spaces]] makes a leading `.` structural on a sameline already); `5.` ends sentences. Both are cheap to write `0.5`/`5.0`. |
| `1e10` | yes, float | Exponent alone makes a float, as in JSON. |
| `1.10` | yes, float, spelling kept | The version trap is a conversion question: see `kinds-and-test.md`, "Floats in the view". |
| `0xFF`, `0xff` | yes | Hex digits either case; prefix lowercase only (`0XFF` text: one spelling of the mark). |
| `-0xFF` | **no** (text) | Prefixed literals are bit patterns more often than signed quantities; one fewer combination. Taste, low confidence. |
| `0d42` | **no** (text) | Decimal is the default; a second spelling of it adds nothing (A8). The 0.9 `0d83.23` "exact decimal" question becomes: exactness is the host's business (mapping guide), not a spelling. |
| `nan`, `inf`, `NaN`, `Infinity` | no (text) | Test 3: names and abbreviations. A mark may give them (`<nan>`), if the mark branch has an interior grammar. |
| `3+4i`, `1/3r` | no (text) | Not core (test 2). |
| `12345678901234567890123` | yes, int | Tree keeps the spelling; the host mapping guide says what a host does past its range (bigint, string, or a strict-getter error). Never a different tree. |

## Case and the whole-run rule

Classification is **whole-run**: the run (or the mark's interior) must be exactly one number with nothing else, after trimming (Joseph, 2026-10-21: bare values trimmed both sides). `30s`, `7 apples`, `1/3rd` are texts in their entirety; nothing splits a value in two (the old line's suffix-return defect can't arise, because there is no prefix match).

## Cost of strictness, honestly

- A writer used to YAML 1.1 or to the old line who writes `0755` meaning octal gets text, silently; it is a lossless miss (the spelling is kept and a slot-typed consumer can still parse it as octal), and a default-off warning "`0755` is text; did you mean `0o755`?" makes it caught for those who turn it on.
- The grammar is about a dozen productions. B5: classification of a whole run is a single forward pass with constant state (the old line's 2.3x lesson); the strict rules add rejection states, no lookahead.

## Scores (the strict notation against the old line's lax one)

| Factor (weight) | strict | old-line lax | Basis, confidence |
|---|---|---|---|
| A2 guessability (10) | 8 | 6 | Strict matches JSON/TOML/Python literal habits that agents carry; lax admits spellings nobody guesses (`1__0`, `0d83.23`). Moderate. |
| A3 cold comprehension (10) | 9 | 6 | `0755` meaning 755 surprises; `01234` → text doesn't. Moderate. |
| A6 spec clarity (9) | 8 | 5 | One table, one notation everywhere. Moderate. |
| A7 simplicity (8) | 7 | 5 | Strict has more rejection rules but no special cases by context (the old line's zero-led gaps). Moderate. |
| B3 stability (10) | 9 | 5 | Whole-run, no prefix match, no splitting. High. |
| B4 errors that teach (8) | 8 | 4 | Rejections inside a mark can say what was meant. Moderate. |
| B5 speed (9) | 9 | 9 | Both single-pass. High. |
| C1 structured data (10) | 9 | 8 | Everything JSON can spell, plus hex. High. |
