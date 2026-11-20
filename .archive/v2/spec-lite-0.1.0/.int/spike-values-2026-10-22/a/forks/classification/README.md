# Classification fork (spike a): how a bare value gets its kind

*A fork of spike a's coordinator, 2026-10-22. Scope: DP1 (where the classification of a bare run lives), DP2 (what it may be classified as), DP3 (identifiers that spell numbers), DP8 (nil). Measured against [`CTQ-FACTORS.md`](../../../../../CTQ-FACTORS.md) only; precedent (JSON, YAML, the old line) appears as evidence weighed against those factors, never as a reason. No estate document is used as evidence of how anyone writes.*

## What I took the question to be

Today's lean, "C with the view", was chosen because B (typing a bare run by its whole spelling) seemed to break bounded streaming. The question underneath was whether that's true, and if not, what actually decides where a bare value's kind comes from.

## What I found

1. **Streaming doesn't decide it.** A run's extent never depends on what it spells, so a parser can stream the characters and attach the classification when the run closes. That is the same function, computed at the same moment, as the typed-primitive view. Checked by `f1_check.py`: a battery, 400,000 fuzzed runs where the streaming classifier agrees with a whole-text regex, and a million-character run emitted from its first character with nothing held. The remaining cost is to the event vocabulary (0.9's wire announces kinds first, which is why descent needed HOLD/RELEASE), and lite specifies the tree, not the wire. → [f1-streaming.md](f1-streaming.md)
2. **The view's open default *is* the decision.** Off, it is C0; on and exactly specified, it is Cc. Left open, two consumers disagree about `:enabled true` (B3, C7). → [dp1](dp1-where-the-class-lives.md)
3. **Cc and B carry the same information but differ in identity and in growth.** Under Cc a value is its spelling (`[3]` ≠ `[03]` ≠ `[3.0]`; `|h1 1984` is a heading's text); under B it is a number, and numeric equality across spellings has to be defined. Cc can add classes in a later version without changing any accepted tree; B can't. C0 → Cc is one monotone path; B is off it. → [dp1](dp1-where-the-class-lives.md)
4. **Under Cc the standard set should be small, and four tests pick out JSON's literal set** (nil, true, false, JSON numbers). Leaving a spelling out costs little (a slot reads it); putting one in wrongly costs a silent misreading. Units, bases, underscores, rationals and temporal values belong to slots or notations. A side effect: every classified number is a valid JSON number token, so lite → JSON copies it byte for byte. → [dp2](dp2-the-standard-set.md)
5. **No rule about spelling can tell a number from an identifier; only the slot can.** JSON's grammar keeps `01234` text, and identity by spelling keeps everything in the tree; `1.10`, `1234567` and `1e10` remain a data-reading hazard, which a slot type or the writer's quotes resolve. → [dp3](dp3-identifiers.md)
6. **nil:** under Cc, bare `nil` stays as [[rule:nil-spelling]] has it; no decided card's Statement changes. `<>` is a separate, compatible spelling. → [dp8](dp8-nil.md)

## Branch map

| Branch | State | Weighted (my hypothesis) | Why |
|---|---|---|---|
| **Cc**: text plus a normative class, identity by spelling, S-JSON | **alive, leading** | 8.20 | best on A2, A3, A5, C1, C5; changes no decided card's Statement |
| B: the class is the kind, S-JSON | alive, second | 7.48 | same data; heading-as-number (A3), numeric equality to define (B3), can't grow classes without changing trees (B6, B2 strained) |
| Cv: the view with its default open (as carded) | **dissolves** into C0 or Cc once its default is fixed | 6.55 | not a stable design; open, it costs B3 and C7 |
| C0: bare is text, nil and numbers only in `<…>` | alive, weak | 6.40 | identifier-safe and simplest, but a silent miss on every JSON-style value (A2, C1); changes two decided cards |
| B-old: kind-first with the old line's whole set | **dead** | 5.62 | edges grow with the set and each is a B3 liability; under Cc nothing is gained by having the parser classify what a slot reads |
| S-quantity (units as a parser class) | **dead as a parser class** | — | the class degrades to "a number followed by letters" (`10am`, `3rd`, `0xff` as 0 + `xff`, checked); meaning is the slot's |
| S-JSON−e (no exponents) | alive, judgment call | — | keeps `1e10` ids text; costs JSON round-trips of scientific values; I lean to keep exponents |
| S-JSON+ (underscores, `0x`) | alive, weak | — | fails "a schema-less consumer needs it"; more edges |
| N2 (nil only as `<nil>`/`<>`) | weak | — | changes two decided cards; JSON nulls need marks |

Scores weight the overlapping factors as CTQ-FACTORS.md says they should; the margins are larger in the sum than in substance. Confidence: high on findings 1, 2 and 4's direction; medium on Cc over B (it rests on identity-by-spelling and growth, which Joseph may weigh differently).

## Files

- [f1-streaming.md](f1-streaming.md): the streaming check, what it models and doesn't, the costs that remain
- [dp1-where-the-class-lives.md](dp1-where-the-class-lives.md): the four branches, the score table, Cc stated as a card would state it
- [dp2-the-standard-set.md](dp2-the-standard-set.md): membership tests, candidate sets, the edges S-JSON must pin
- [dp3-identifiers.md](dp3-identifiers.md): guards, K2 under each design
- [dp8-nil.md](dp8-nil.md)
- [composite.md](composite.md): the composite set and the three composite lines under Cc + S-JSON, with the differences under the others
- [impact.md](impact.md): cards each branch touches, by firmness
- `f1_check.py` (run: `python3 -I f1_check.py`), `scores.py`

## Seams with the sibling forks

- `<…>` under Cc is no longer needed for nil, booleans or numbers; what it's for (asserting a value, carrying notations such as dates, `<>`) is the `<…>` fork's.
- Units, aliases (`:port ssh`) and `5m` as minutes or meters all land on slot types under Cc; the slots fork owns them.
- Bare dates are texts with no class here; whether they should be written in `<…>` is the `<…>` fork's.
