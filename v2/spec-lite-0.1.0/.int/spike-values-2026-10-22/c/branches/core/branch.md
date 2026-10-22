# Branch family "core": the standard set, number spelling, units, keywords (D4, D5, D6)

*Spike c, written by a fork of the spike-c agent, 2026-10-22. Sub-pages: `kinds-and-test.md` (D4: which kinds, by what test), `spelling.md` (D4: the number notation), `units.md` (D5), `keywords.md` (D6), `renderings.md` (composite E1, E4–E8). Scores are this fork's hypotheses against CTQ-FACTORS, with basis and confidence on each page; nothing was measured.*

## What this family found

1. **A test for the core that follows from the frame.** A kind is core when its meaning is **parameter-free** (the spelling alone says what it is: no slot, locale, zone, calendar, unit dictionary or format), **host-portable**, **collision-light**, and **earns its grammar**. The first test is the frame's geometry turned onto kinds: a kind that needs a parameter must get it from the slot or a named notation, so it can't be core by construction. Through the four tests: **nil, true, false, integer, float, delimited string, list** are core; dates are the first named notation, not core; durations, local times, rationals, complex, quantities and money are not kinds in lite at all.
2. **The Norway problem lives in conversion, not in lite's tree.** Lite's tree keeps kind *and* spelling ("classify, never convert"), so no classification in the tree loses anything; the loss happens when a schema-less consumer converts. That splits silent misses into **lossy** (text read as a number: `01234` → 1234) and **lossless** (a number left as text), and the strict spelling is chosen so that classification never makes a lossy miss where text was likely meant: no leading zeros, `_` only between digits, no `.5` or `5.`, no bare `nan`/`inf`.
3. **Units are not a lexical kind.** `5m` (minutes or metres) can't be disambiguated literal-side without a dictionary, and the slot disambiguates it for free; a bare number-plus-letters classifier captures `1st`, `4K`, `1080p`, `401k`, `3am`. So `920px` is text, meaning comes from the slot, and a unit-owning named notation inside a mark (`<css: 920px>`, `<si: 5 m>`) is the later path. Lite 0.1.0 needs no unit syntax and reserves nothing new for it.
4. **`<>` composes rather than adds.** If the mark's interior is "the standard notation", an empty interior is nil and `<nil>` means the same with no extra rule; and it gives the missing-value error its fix: "did you mean `:a <>` (nil) or `:a ""`?".

## Branch map

| Branch | Decision | Status | Why |
|---|---|---|---|
| core-J | JSON's set + TOML-style integer spellings, strict; dates not core | **survives (recommended)** | passes all four tests; `kinds-and-test.md` |
| core-M | the old line's maximal set (temporal, rationals, complex, durations, relative) | dies | every extra member fails test 1 or 2; the old line's surprises sit entirely inside them |
| core-0 | only nil/true/false; numbers by slot or mark | dies as a core; survives as "view off" | C1 data needs a mark on every number; it is the same design as core-J with the view off |
| core-J+D | core-J plus ISO dates bare | dies for 0.1.0 | test 2 is shaky, and C4 is met one mark away by a named notation |
| floats-in-view (i) | the view reads floats; writers quote versions | **survives, my lean** (moderate) | matches JSON/YAML/TOML habit |
| floats-in-view (ii) | the view reads ints, bools, nil only | alive, Joseph's call | no version trap; a mark on every schema-less float |
| U1 | units are text; the slot gives meaning | **survives (recommended)** | `units.md` |
| U2 | bare quantity literal `920px` | dies | ordinals, resolutions, model names; `5m` still ambiguous |
| U3 | quantity inside a mark, with a named notation owning the dictionary | later, forward-compatible | refused today by the interior rule |
| U4 | unit in the attribute name | a writing convention | no syntax needed |
| K1 | bare `nil`/`true`/`false` + marked `<nil>`/`<true>`/`<>` | **survives** | `keywords.md` |
| K2 | marked keywords only | dies | it is K1 with the view off; `:tls <true>` everywhere |
| K3 | `~` for nil | dies | a special character for what `<>` already gives |

## Summary scores (selected factors; hypotheses)

| Factor (weight) | core-J + strict + U1 + K1 | core-M (old line) | Confidence |
|---|---|---|---|
| A2 guessability (10) | 8 | 5 | moderate |
| A3 cold comprehension (10) | 9 | 5 | moderate |
| A5 domain-forward (9) | 8 | 6 | moderate |
| A6 spec clarity (9) | 8 | 4 | moderate |
| A7 syntactic simplicity (8) | 8 | 4 | high |
| B3 stability (10) | 9 | 5 | high |
| B5 parse speed (9) | 9 | 9 | high |
| B6 headroom (7) | 9 | 6 | moderate (core-M spends `+`, `/`, `-`, `:` after digits) |
| C1 structured data (10) | 9 | 9 | high |
| C4 types, notations, units (8) | 5 in 0.1.0 (slots only) | 6 | moderate; the honest cost of this branch |

## What it would change in the store (not edited; proposals)

- The `rule:bare-typing` gap card: the standard numeric notation of `spelling.md`, plus the whole-run rule, plus `nil`/`true`/`false` lowercase only. It is used by the view, the mark interior, and strict getters alike.
- [[rule:nil-spelling]]: unchanged in substance; add `<null>` as an error suggesting `<>`/`<nil>` if marks get interiors.
- [[rule:missing-value]]: its message suggests `<>` and `""`.
- [[obj:represent-structured-data]] Statement 2 ("each value's kind decided by how it is written") holds for core kinds; non-core kinds are decided by the slot. Its "how strong is 'the same data'" question gets a partial answer: lossless in the tree; the conversion default is the open part.
- A host mapping guide (C1 note, D2): integer range per host, binary64 vs decimal hosts for floats, `-0`.
- [[expl:writing-lite]]: quote versions and leading-zero codes; put fixed units in the attribute name.

## Open for Joseph

- Floats in the view, (i) or (ii).
- Whether `<nan>`, `<inf>`, `<-inf>` exist (with the mark branch).
- `-0xFF`: text (my low-confidence taste) or a number.
- Whether dates are the first named notation in 0.1.1, and its spelling (mark branch).

## On the deep-forking experiment

This fork did not fork further: the harness gives forks a rule against spawning agents ("Do NOT spawn subagents with the Agent tool … you ARE the fork"), so depth was one level in this run. The sub-branches above were worked in files instead.
