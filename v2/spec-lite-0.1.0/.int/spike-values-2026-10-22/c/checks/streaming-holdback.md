# Streaming check: where does holdback actually come from?

*Spike c, 2026-10-22. Two checks, each labeled. The first is a measurement of the existing reference parser; the second is a model of wire disciplines, which shows a mechanism and measures nothing about lite.*

## Why this check

Option B (the whole run decides: `8080` an integer, `920px` a text) was dropped on 2026-10-21 for streaming. Joseph gave the example `4938422…2412124p`: "if the streaming parser is forced to buffer essentially unlimited amount of the incoming stream before being able to output any partial text or partial node etc., the architecture has to change quite a bit, and there is room for DoS type attacks and buffer overflows etc. Udon was able to do parsing streaming without that if it knows in the first few characters what the type is." The session agent agreed, and the same objection decided C's open bit: a bare run that spells a primitive is not typed in the tree. CTQ B1 now reads "No construct holds an unbounded stretch before its kind is known." His method says a dropped claim should be fully attempted first, so this check asks what the holdback is made of.

## 1. Measured: what the 0.9 reference parser holds (checked)

`holdback-probe.rs` (in this directory; built in a scratch crate against `core/udon-core` at the working tree of commit `73f6a1b`) feeds each document to `PushdownParser` in 4 KiB chunks. Each document has a 1,000,000-byte value. The probe counts content bytes emitted before the value's terminator arrives:

| Value (1 MB) | Bytes emitted before the terminator | Event at the end |
|---|---|---|
| bare text `aaaa… b` | 0 | `Text` 1,000,003 bytes |
| digits then `p` (Joseph's example) | 0 | `BareValue` 1,000,001 |
| digits then end of line | 0 | `Integer` 1,000,000 |
| a prose line under an element | 0 | `Text` 1,000,001 |
| a quoted string | 0 | `StringValue` 1,000,000 |

Why (read in `parser_pd.rs`): the parser "owns an accumulation buffer so capture (`mark..pos`) never spans a seam; consumed bytes before the active mark are drained after every run" (lines 640–643, `drain_consumed` 730–747). Every capture, of every kind, is held from its mark to its terminator. The older line-buffered `StreamingParser` (`parser.rs` 7810–7870) goes further: it emits only complete lines and errors past a 4 KiB buffer. The 0.9 grammar also already decides one event's kind at its close: HOLD/RELEASE emits `$key` vs `$partial-key` late (`parser_pd.rs` 666–669; README "late-decided-prologue emission").

**What this shows:** in the existing implementation, holdback is per token and the same for every kind. A bare `8080` typed by B would be held exactly as long as bare text is held today. Joseph's memory of how the old parser streamed matches `old-numeric-typing.md` §4: the parser decided a value's *kind* at the token's end and emitted tag plus slice then, so it already held the whole token. **What it doesn't show:** that holding is acceptable. B1 may be a design ideal ahead of the implementation, and it is a good one. So the real question is what the ideal requires.

## 2. Modeled: four wire disciplines for one bare run (a model)

`wire_model.py` (output in `wire_model.out.txt`) streams a run through a finite-state classifier for a strict number grammar plus `true`/`false`/`nil`. It reports the most bytes each stage must hold before it can emit them:

| Run | B, kind-first parser | B, kind-at-close parser | kind-first JSON transcoder after B-close | C (bare is text) |
|---|---|---|---|---|
| `4938…2p` (1 MB) | 1,000,000 | one chunk | 1,000,000 | one chunk |
| `4938…2` (1 MB integer) | 1,000,000 | one chunk | 1,000,000 | one chunk |
| `1984 is a novel` | 5 | — | 5 | — |
| `7 apples` | 2 | — | 2 | — |
| with a spelled 64-character cap on primitives | 64 | one chunk | 64 | one chunk |

What the model shows:

- **Classification itself needs no buffer.** Deciding "is this run still a possible number?" takes a few states plus a count of trailing spaces. A parser can stream B's content out in chunks and say the kind at the close (a `ValueEnd{kind}` event). Its holdback is then the same as C's.
- **The holdback moves to whoever needs the kind before the content.** A streaming transcoder writing JSON has to choose `"` or no `"` before it writes the first digit. Downstream of a kind-at-close parser it has to hold exactly the prefix that could still be a number: B-kind-first's holdback again, one stage later.
- **The same transcoder pays the same cost under "C with the view on"**, because the view is B's classifier applied at the consumer. The only discipline that never holds is "bare is text for every default consumer", or a kind that arrives before the value (slot or mark).
- **A spelled cap bounds it.** "A bare run longer than N characters is never a primitive" bounds every stage at N. The cost is a cliff: a 65-digit integer is text, though no common host can hold it losslessly anyway (C1's mapping-guide edge). TOML is the precedent for a range limit on number literals (lossless i64 or an error), not for a length limit.

## What follows (the agent's reading; the factors are CTQ's)

1. **B1 as worded ("before its kind is known") is about semantic kind.** The structural decisions a streaming parser needs (does a value end here? does a block start here?) are the same under B and C, because the run's extent doesn't depend on what it spells. What differs is only *when the classification label is available*. The 2026-10-21 objection is sound **for a kind-first wire**, and it doesn't apply to the parser if the wire may carry the kind at the close.
2. **Unbounded content is not the attack surface; unbounded *undecided* content is.** A 1 MB text is fine to stream. A 1 MB "maybe-number" is fine for a kind-at-close wire, and costs a kind-first consumer 1 MB. A cap of N (or a slot or a start mark) removes it.
3. **So the design space is a choice of *who knows the kind first*, not of lookahead:** the slot (before), the start mark (at the start), or the spelling (at the end). See `../00-frame.md`.

*Re-run: `python3 -I wire_model.py`; the probe needs a scratch crate whose `Cargo.toml` has `udon-core = { path = ".../core/udon-core" }` and `[workspace]`, with `holdback-probe.rs` as `src/main.rs`; `cargo run --release`.*
