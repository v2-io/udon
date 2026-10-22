# DP9: units

*Slots fork, spike a, 2026-10-22. Labels as in `dp6-slot-types.md`.*

## Joseph's puzzle, dissolved into its parts

He said units "seem to be a bit of both slot-type & literal-hint & coercion." K6 shows why. Write a timeout of 5 minutes and a length of 5 meters naturally:

```udon
|job :timeout 5m
|rope :length 5m
```

- The **literal** says a magnitude and a symbol: 5, `m`. It doesn't say whether `m` is minutes or meters.
- The **slot** says the dimension: a timeout is a duration and a length is a length. Without the literal's symbol it doesn't say the unit: `:timeout 5` is seconds or milliseconds, or a convention.
- **Coercion** is the reader turning (5, `m`, duration) into its canonical unit (300 s).

Neither half decides alone, and together they always do. So a unit symbol on a literal is a **partial claim, completed by the slot's dimension**. That's why it felt like "both": the literal carries half the meaning and the slot the other half. *(My analysis; I'd call it high confidence: any pair of units that share a symbol across dimensions reproduces it: `m`, minutes or meters; `M`, mega or molar; `s`, seconds or Siemens.)*

**What lite owes units is therefore only the spelling,** intact and addressable by its slot. Under the bare-is-text lean that's already true: `5m`, `920px`, `1.5em`, `50%` and `30s` are «texts», never errors (Joseph: "920px being an error violates least surprisal").

## Branches

### U0: units are text, and the reader does everything (alive)

Lite does nothing. A reader with a dialect parses `5m` according to the slot. Without a dialect, it's text, which is honest: the document didn't say which `m`.

### U1: lite classifies a "quantity" shape (alive, not recommended)

The parser attaches a classification `quantity(5, m)` when a run spells a number followed by a unit symbol, as the old 2011 notes imagined ("number with unit"). Pushed to the edges, the rule needs all of these:

- **where the symbol ends:** `km/h`, `m/s²`, `°C`, `µs`, `kg·m`;
- **a space or not:** SI writes `5 m`, and `:count 7 apples` would then classify as `quantity(7, apples)`;
- **exponents:** `2em` (CSS) vs `2e5m`;
- **other bases:** `0xffpx`;
- **`%`.**

Each is a fixture and a sentence in the spine (A6, A7). What it buys, one split shared by every reader (B3), can be had without making it lite's tree content (U2). And it can't reach the meaning anyway, since the dimension is the slot's.

### U2: text in lite, plus a named standard notation for quantities (alive; my lean)

Lite: U0. Beside lite, not in its spine: a **standard notation** `quantity` (and its relatives `duration`, `iso-date`, …) that dialects name for their slots. Each has one written grammar and a unit vocabulary (UCUM, memory, is the obvious precedent for unit codes), so readers that adopt it agree. This is the same "notation" Joseph's N layer names, standardized once and used by reference from a slot: `timeout: duration in notation quantity(units: s m h d)`.

```udon
; a dialect, written in lite (illustrative only; not proposing a schema language)
|slot[timeout] :type duration :notation quantity :units [ms s m h]
|slot[length]  :type length   :notation quantity :units [mm cm m km]
```
With it, `|job :timeout 5m` reads as 300 s, `|rope :length 5m` as 5 m, and `|job :timeout 5 m` (with a space) by the same grammar if the notation allows it.

### U3: the unit in the slot's name (alive as advice, not a rule)

`:timeout-ms 30000`, `:width-px 920`: the literal stays a pure number (the default view reads it as one), and the name carries the unit. Common JSON practice, and it needs no rule. Domain-forward only in part, since the unit becomes part of the name (A5). It belongs in a writing companion ([[expl:writing-lite]]) as one of the ways to say a unit when no dialect exists.

### U4: the unit as a literal annotation (`<min:5>`, `<5 min>`) (handed over)

This is the angle-bracket fork's question: a literal claim in a typed bracket. One thing from here for it: a bracketed unit still doesn't escape the slot, since `<5m>` is no less ambiguous than `5m`.

## Scores (my hypothesis)

| Factor (weight) | U0 | U1 | U2 | U3 | basis / confidence |
|---|---|---|---|---|---|
| A2 generative (10) | 8 | 7 | 8 | 8 | writers write `920px` and it just works; U1's edges can surprise (M) |
| A5 domain-forward (9) | 9 | 9 | 9 | 6 | U3 puts the unit in the name (M) |
| A6 spec clarity (9) | 10 | 6 | 9 | 10 | U1 adds a classification with many edges to the spine (H) |
| A7 syntactic simplicity (8) | 10 | 6 | 10 | 10 | (H) |
| B3 stability across readers (10) | 7 | 9 | 9 | 8 | U0 leaves each reader to split (M) |
| B6 headroom (7) | 10 | 6 | 10 | 10 | U1 spends the quantity shape in lite's tree (M) |
| C1 structured data (10) | 7 | 7 | 7 | 9 | U3 keeps JSON numbers numbers (M) |
| C4 types, notations, units (8) | 4 | 7 | 8 | 5 | U2 gives units a standard home (M) |
| D1 agent tooling (8) | 5 | 7 | 8 | 5 | a shared grammar is a library (L) |
| **weighted mean** | 7.8 | 7.2 | **8.6** | 7.9 | |

Impact radius: U0 and U2 change no card; U2 adds a companion outside the spine. U1 adds a classification card and fixtures, and touches the transcript.
