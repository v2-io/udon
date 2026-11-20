# D4: which kinds are core, and by what test

*Spike c, branch family "core". Labels: **checked** (verified here), **from memory** (precedent recalled, not re-read today), **guess**, **taste**.*

## The test

The hypothesis in the ideation file was one test: *a kind is core when every plausible host has an obvious, near-lossless equivalent.* Working the kinds through it showed it is necessary but not enough, and it misplaces the Norway problem. Four tests together sort the candidates cleanly:

1. **Parameter-free meaning.** The spelling alone says what the value is: no slot, locale, zone, calendar, unit dictionary or format string is needed. *This is the frame's geometry turned onto kinds:* a kind whose meaning needs a parameter has to get that parameter from somewhere, and the only places are the slot or a named notation. So a parameter-needing kind can't be core by construction; it belongs to whatever names the parameter.
2. **Host-portable.** Every plausible host has an obvious near-lossless equivalent, with the edges in a host mapping guide (Joseph: "for most elementary constructs there is a type equivalence").
3. **Collision-light.** Its spelling class seldom occurs as text a writer meant as text, in the places values go. Where it does, the miss must be *recoverable*.
4. **Earns its grammar.** Without it, common data (C1) needs plumbing on every value; with it, the grammar (A7), the special characters (A8) and the parser (B5) grow by a stated amount.

### What test 3 found: the trap lives in conversion, not in the tree

The old line classified and never converted: the tree held a kind plus the source spelling (`Integer "0755"`, not 755; `.int/old-numeric-typing.md` §1 "What 'parsed to' means", **checked** there by running the parsers). Every branch spike c is looking at keeps that: lite's tree holds spelling and form ([[rule:tree-transcript]]'s `::kind.form`). Under that contract **no kind assignment in the tree loses anything**: `:version 1.10` read as a float still carries the spelling `1.10`. The loss happens one step later, when a consumer that wasn't told what the slot is converts it to a host number (1.1) or writes it to JSON as `1.1`.

So YAML's Norway problem has two halves, and lite already has only one of them: YAML resolves tags and libraries convert at load, so the spelling is gone (from memory: YAML 1.2 core schema resolution; PyYAML-style loaders). Lite's question is narrower: **what does a schema-less consumer do by default?** That is the typed-primitive view's default ([[def:reading-option]], open), and it is where test 3 bites. Two kinds of miss follow, and they are not equal:

- **Lossy miss**: text read as a number and converted (`01234` → 1234, `1.10` → 1.1, a 23-digit ID → a rounded double). Not recoverable after conversion.
- **Lossless miss**: a number left as text (`"0.5"` handed to a JSON writer as a string). Recoverable by any consumer that knows the slot.

CTQ footnote a2 already weighs silent misses over caught ones; this adds that among silent misses, lossy ones weigh more. That decides several spelling questions below (leading zeros, specials) without appeal to any precedent.

## The candidates through the four tests

| Kind | 1 parameter-free | 2 host-portable | 3 collision-light | 4 earns its grammar | Verdict |
|---|---|---|---|---|---|
| nil | yes | yes (null/None/nil/nullptr-ish; JSON `null`) | `nil` as an intended word: rare | yes; JSON data needs it | **core** |
| true / false | yes | yes | as words: rare in value position; whole-run match only | yes | **core** |
| integer, decimal | yes | yes within i64 / 2^53; beyond, the mapping guide (bigint, string, or error) | **only if strict**: leading zeros (`01234`, `007`) are IDs and codes far more often than numbers | yes: the commonest datum after text | **core, strict spelling** |
| integer, `0x` `0o` `0b` | yes | yes | `0x…` as intended text: rare (hashes start with digits, not `0x`, mostly) | marginal: absent from JSON; present in TOML, YAML 1.2 core (from memory); needed for E9-style masks and addresses | **core, prefixed; taste-level call** |
| float, decimal point / exponent | yes (the decimal spelling is exact; binary64 is the host's rounding) | yes, binary64 everywhere; decimal hosts (Ruby BigDecimal, Python Decimal) by mapping guide | version numbers (`1.10`, `3.10`) are the classic collision; the tree keeps the spelling, so the loss is only at schema-less conversion | yes: JSON data is full of them | **core** (see "floats in the view" below) |
| NaN, ±infinity | yes | yes (IEEE) | `Nan` and `nan` are words and names; `inf` an abbreviation | rare in data | **not bare; inside a mark only** (`<nan>`, `<inf>`, `<-inf>`), if the mark branch has an interior grammar |
| string (delimited) | yes | yes | n/a: delimited | yes | **core** (it is a start mark, not a classification) |
| list | yes | yes | n/a: delimited | yes | **core** |
| rational `1/3r`, complex `3+4i` | yes | **no** (no JS equivalent) | `3+4i` rare; `1/3` as a fraction in text common, which is why `r` was mandatory | rare in data | **not core**; a named notation if anyone asks |
| calendar date `2026-01-10` | almost: assumes proleptic Gregorian, near-universal | partly: host date types disagree on what a date-without-zone is; JS's standard `Temporal.PlainDate` is recent (from memory; shipping state not checked) | strict ISO date: collision-light | yes for data, but C4 (8) can be met by a named notation one mark away | **not core in 0.1.0; first named notation** |
| instant `2026-01-10T14:30Z` | yes with `Z` or offset | mostly | light | as above | **as above** |
| local date-time, time, durations, relative times | **no**: a local time needs a zone to be an instant; `P1M` needs a calendar to be a length; `30s` vs `30S` vs `5m` needs a unit dictionary | no | the old line's own record: `30seconds` → Duration + "econds", `1d12h` split, `0s` a string while `00s` a Duration (§5 there) | — | **not core**; the old surprises were exactly test-1 failures dressed as lexing |
| quantity with unit `920px` | **no**: `px` means nothing without a dictionary, and `5m` is minutes or metres | no | `1st`, `2nd`, `3D`, `4K`, `5G`, `9mm`, `401k`, `1080p`, `64bit`, `3am`, `2fa` all spell number-plus-letters | — | **not a kind at all in lite**: see `units.md` |
| money `$9.99` | no (currency, locale) | no | — | — | not core (the old line's absorption of `$` was a defect, fixed in 0.9) |
| version `1.10.2` | yes | as a string | — | — | text; no kind (the old line already left `0.7.0` a string) |

### What the old standard set says, weighed against the factors

*Reweighed after Joseph's note that the corpus and history are ideation, not evidence: the verdicts in the table rest on the four tests and the CTQ factors, applied with my own sense of what each spelling means. What follows is illustration.* Every member the old line kept beyond JSON's set (temporal, rationals, complex, durations, relative times) fails test 1 or test 2, and the old line's own surprise list (`.int/old-numeric-typing.md` §5, items 1, 3, 4, 7, 8) sits entirely inside those members. That is consistent with the four tests being the right cut, and with the CTQ judgments (A3 cold comprehension, B3 stability, A7 syntactic simplicity) that would score the maximal set down anyway. The old line's one durable lesson, *classify, never convert*, survives on its own merits: it is what makes test 3 lossless in the tree, and it is also what made the old value machine fast (2.3x, the only isolated measurement there), which B5 weighs at 9.

## The core, stated

**nil, true, false, integer, float, delimited string, list.** Integers and floats are classified by a strict spelling (`spelling.md`); the tree keeps kind, subkind (integer/float, base) and the source spelling; the host converts, guided by a host mapping guide (C1, D2). Nothing else is a kind in lite 0.1.0. Dates are the first candidate for a named notation, held for the mark branch to spell.

This is the JSON set plus TOML's integer spellings, minus TOML's bare `nan`/`inf` (the reason is test 3, not TOML). It is close to what 0.9 and 0.10 called the frozen bare set; that agreement is noted, not used as a ground.

## Floats in the view: one sub-branch worth Joseph's eye

If the typed-primitive view is on by default for schema-less consumers, it decides `:version 1.10` → 1.1 at conversion. Two ways out, neither free:

- **(i) classify floats; writers quote versions** (`:version "1.10"`). The same rule JSON, YAML and TOML writers already follow, so A2 (generative guessability) is high for agents trained on them; the miss is lossy but well known. *My lean (taste, moderate confidence).*
- **(ii) the view classifies integers, true, false and nil only; floats need a mark or a slot** (`:ratio <0.5>`). No version trap at all; costs a mark on every schema-less float, and an agent writing `:ratio 0.5` gets a lossless miss (a string) it won't foresee.

Under a slot (a schema or a strict getter `float(:ratio)`), both are identical: the question only exists for the schema-less default.
