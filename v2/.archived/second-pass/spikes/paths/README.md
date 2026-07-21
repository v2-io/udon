# Spike: paths

**Status:** open exploration (2026-07-21)  
**Class:** not a pin — WAIT-DEMAND terrain for multi-line / addressing / refs  
**Out of bounds for this residue:** DECISIONS, PROCESS, live CORE prose, grammar/parser work

---

## The itch (question-shaped)

What does it mean for agents (and humans) to **address** structure inside a
UDON document — and how much of that language should be the *same* as the
document surface itself?

Related forks that keep showing up as one cluster, not separate problems:

1. **In-document references** today are a selector tuple
   `(name, key, traits)`. When (if ever) do they grow into multi-segment
   paths — and how do you avoid path-debt from incremental tuple growth?
2. **Tool addressing** (skeleton, `at`/`all`, patch, schema selectors,
   cross-file trace) seems to want a richer language than one segment.
3. **Identity purity:** document `[1]` is the integer key 1. Older path
   sketches used `[0]` for positional. Those cannot both be true under
   “paths look like the UDON they navigate.”
4. **Embeddability:** a path string must eventually live *inside*
   documents (attrs, patches, schema) without poisoning the scan —
   terminators, `|` mid-token, quoted vs bare vs dialect envelope.
5. **Multi-line (OPEN ML):** the emergent-span finding says line-bound
   policy and path/edit/stream design pull on each other. This spike does
   **not** pin multi-line; it only watches where addressing would *force*
   a demand.

This is not a mini-spec. Wrong sketches are welcome.

---

## What “done enough” looks like for a pass

Enough durable residue that a stranger-agent can:

- See what was already tried (stale design doc, adjudication packet, day-in-the-life scenarios)
- Try new examples without re-deriving the collision map
- Optionally harvest a **proposal** into OPEN later — never smuggle a pin here

Optional next passes (anyone): push embeddability edge cases; relational vs
tree; multiple keys (`|phase[9][scribal]`); prose addressing; wire
reference encoding under path pressure.

---

## Layout

```text
README.md          this file — the question
NOTES.md           explorations, dead ends, surprises, open questions
sketches.udon      toy documents + provisional path strings (not law)
```

## Inputs worth re-opening (primary, not summaries)

| Source | Why |
|--------|-----|
| [`design/udon-paths.md`](../../../design/udon-paths.md) | Stale input material — surviving principles + known collisions |
| [`spec/msc/adjudication-2026-07-paths-and-silences.md`](../../../spec/msc/adjudication-2026-07-paths-and-silences.md) Part A | Fresh design questions P0–P9; field evidence Part A½ |
| [`spec/CORE.md`](../../../spec/CORE.md) References | Live selector-tuple + interim wire; “notably absent by design” |
| Greenfield **2a Q5**, **3b O7** | Keep tuple until paths arrive *whole* |
| [`v2-spec/OPEN.md`](../../OPEN.md) **S3, S14, ML, W3** | Multiple keys; ref model; multi-line wait; wire ref encoding |
| [`test/scenarios/`](../../../test/scenarios/) | Day-in-the-life paths (provisional spelling; demand > spelling) |

Session vault (optional retrieval): multi-line / demand-side discussion in
`spikes/session-vault/raw/grok/019f7d71-greenfield-3b.md`, agentic path
pressure in older exports.

---

## Explicit non-goals

- Ratifying path grammar or `at`/`all` API
- Growing the reference tuple “just a little”
- Pinning multi-line policy
- Implementing a path parser
- Editing DECISIONS / PROCESS / live CORE
