# 66 — Does lite type bare values at all, or is every unquoted value a string?

*Raised by the history survey (files 50-69), 2026-09-29, second continuation. Neutral: the question, the alternatives, and where it has come up. Sources are pointers for the second pass, not authority.*

## The question

0.10.01 recognises a frozen bare set from syntax alone: string, integer (with `_`, `0x`/`0o`/`0b`), float, boolean, nil, list; anything else (dates, durations, versions) needs the `<…>` capture. So `:port 8080` is an integer, `:on true` a boolean, `:v 3.10` a float (value 3.1), `:zip 01234` decimal 1234 ("`0755` is decimal 755"). Lite is meant to be small and stable. Should lite keep this typing, shrink it, or say "everything is text; the consumer or a schema casts"?

## The history has both answers

- **Dec 2025 (`_archive/analysis.md`, "Resolved Decisions" §3, written by an agent under Joseph's direction)**: *Decision: Don't parse them. Everything is a string.* Rationale: "YAML's implicit typing is its biggest footgun (Norway → false, 3.10 → 3.1)"; "the consumer knows what type it expects"; "`:count 42` is the string `"42"`. Consumer casts. One possible exception: `null`/`~`." Its closing principle: "Be opinionated and minimal."
- **Joseph, 2025-12-23** (line 5521, same days): *"attribute values are syntax-parsed types… have type based on syntax — NOT value-sniffing."* and (5548) *"attribute values are typed literals / scalars."* So within days the direction was typed-by-syntax rather than all-strings.
- **0.9 / 0.10 (2026)**: typed scalars, then G7 "the bare scalar set is closed forever; growth lives visibly in captures"; bare `2026-07-11` is deliberately a *string*. the repo README example comment: "bare date is a string; temporal is moving to a `<…>` dialect."
- **Dec 2025 agent tests** (`test/usability/results/AGENT_FEEDBACK.md`): "Type inference trade-offs: unquoted numbers, bareword booleans … ambiguity."; "How are numeric types (int vs. float vs. decimal) distinguished?"
- **Joseph 2026-01-09** in the descent value-parsing work noted value parsing "unlike most of the rest of UDON, requires some degree of minor lookahead (especially offsets/duration stuff)" — the cost side.

## Alternatives

### A — 0.10.01's frozen bare set in lite

```udon
|server :port 8080 :tls true :ratio 0.5 :name web :v 3.10
```
```text
port 8080 (int) · tls true (bool) · ratio 0.5 (float) · name "web" · v 3.1 (float)
```
Familiar (JSON/YAML-like), data-friendly, and the loss `3.10` → `3.1` is the classic footgun in miniature; the freeze is what keeps `Norway` a string.

### B — smaller set in lite: strings, plus `true` / `false` / `nil`, plus decimal integers; floats and prefixed bases via capture

```text
port 8080 (int) · tls true · ratio "0.5" (string unless written in a capture or cast by the consumer)
```
Fewer grammar cases (no float, no `0x`, no `_`); costs the most common "0.5" data.

### C — everything unquoted is a string (Dec 2025 analysis decision); keywords and numbers are the consumer's/schema's problem

```text
port "8080" · tls "true" · v "3.10"
```
Nothing to get wrong, no lookahead, round-trips exactly. Loses "the data is typed in the file"; every consumer casts, and a `[1 2 3]` list becomes strings.

## Sub-questions

- If C, what remains of `nil`? Dec 2025 kept "one possible exception: null / ~". See [12](12-missing-values-and-what-counts-as-valid.md) and [72-which-bare-words-are-numbers-booleans-nil](72-which-bare-words-are-numbers-booleans-nil.md) (other survey, unread) for the detailed cases.
- A middle route: lite's *tree* carries the token text plus a syntactic-kind tag (`int`, `word`) and never a converted value. The consumer converts. Does that satisfy least surprise for the JSON-minded user?
- Is a typed bare set a lite feature or a "full UDON" feature that lite refuses to *change the meaning of later* (reserve, do not implement)?

## Interactions

[07](07-untyped-angle-box.md) (what `<…>` does in lite if bare typing shrinks), [12](12-missing-values-and-what-counts-as-valid.md), [13](13-ast-shape.md), [65](65-value-shape-after-stacking.md).
