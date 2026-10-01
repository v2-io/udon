---
kind: principle
awaiting-second: true
awaiting-decision: true
needs-work: false
per: []
depends: []
---

# Prefer the simpler grammar, short of surprising the agents who use it

*Among alternatives that all meet lite's objectives, prefer the one that makes the grammar or rules simpler, unless it would surprise the agents who read and write lite, weighed by how often the case occurs.*

## Statement

When several alternatives for a rule each meet every objective, prefer the one that makes the grammar or the rules simpler, unless it would surprise its users. Surprise is judged:

1. for agents reading and writing lite in plain text, without syntax highlighting, first; for people second;
2. in proportion to how often the case occurs, so that a surprise in a rare case does not outweigh a simplification that serves a common one.

## Grounds

- **The principle.** "I will be very persuaded by things that simplify the grammar or rules without violating the principle of least surprise" (Joseph, 2026-09-29, `.int/STEWARD-VERBATIM.md`).
- **Whose surprise.** "udon is primarily for agents by agents and they are the principle user" (2026-07-21); "think in terms of the consumer and user of UDON (which is targeting *you* as a consumer …) and therefore the principle of least surprise" (2026-07-19); "It is optimized for agents and AI. The fact that it happens to be very comprehensible for humans as well is a fortunate unintended consequence" (2025-12-24) (`~/.claude/history.jsonl` 17060, 16904, 5571).
- **Without highlighting.** "it needs to be clearly and quickly scannable *without* syntax highlighting-- because right now agents don't have syntax highlighting for the normal read workflow" (2025-12-24, 5572).
- **Weighed by frequency.** "Almost all my decisions try to reduce to not violating the principle of least surprise the most (so sometimes taking into account estimated or hypothesized frequencies of edge-case occurance etc.-- like 'emoticons in the $main attribute text and forgetting to escape' -- pretty unlikely … so unlikely compared to how often we'll want multiple attributes on the same line or subsequent lines)" (2026-08-09, 18890); and "another instance of limiting an important use-case because of an unimportant failure mode" (18886).

## How it is used

A principle decides nothing by itself. A decision that leans on it says which alternative it favored, what makes that alternative simpler, whose surprise it considered, and how common the surprising case is. Joseph's own way of checking surprise: ask fresh agents what they would expect something to parse to, "not that it's binding or conclusive, but it is definitely useful thinking!" (18890).

## Epistemic status

A principle is never met or unmet; it orders alternatives that the objectives leave open. It fails when it is ignored, applied inconsistently, or keeps favoring choices that later need reversing.

## Discussion

- **Precedent is not a tie-breaker.** "I reserve the right to change my mind about anything and everything in the past" (2026-09-29). A past spec's choice is evidence of what someone once thought.
- **Agents first doesn't mean people last.** The README's claim is "for humans and AI alike", and the 2011 objectives ranked beauty and human readability highest (`_older/udon/doc/objectives.asciidoc`). The order here only says whose surprise wins when the two conflict.

## Working notes

- **Awaiting Joseph:** adopting this as a lite principle, with the audience and frequency weighting drawn from his words above. The earlier example version left "whose surprise counts?" open; this answers it from his statements, which is the udon team's reading.
- A measure for it (time for a fresh agent to read a lite document correctly, or how often agents write lite wrongly) would be a fitness, not yet an admitted kind; see [[sop/conv:purpose-layer]]. The Dec-2025 usability harness (`test/usability/`) is a ready instrument.
