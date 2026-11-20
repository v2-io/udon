---
source: live repo file `design/desc-design-principles.md` at gather time
gathered: 2026-07-21
status: gathered source material — verbatim whole-file copy; NOT authoritative; live originals may advance
paths:
  - design/desc-design-principles.md
source_commit: 3d8e5b9c52b2a581c4ab9021984423073a694693
categories: [descent, grammar-authoring, dialect-author-ux, comprehensibility, tool-design]
why_included: |
  The evaluative criterion for the .desc grammar-authoring format, from Joseph.
  Origin story (a bit-lookup table that could *generate* the RTMP parser it described
  — still running at Amazon/Twitch) and the load-bearing principle: .desc must stay
  table-scannable so the eye audits cursor-advance the way it audits a truth table.
  Names a real tool-decay failure mode — the Ruby lexer's assumptions came to dictate
  syntax more than the design did — and the fix (classify each construct principled
  vs lexer-artifact). Demand signal about grammar-authoring tools generally:
  comprehension-legibility as the non-negotiable.
---

# .desc design principles — origin and the evaluative criterion

*Recorded 2026-07-11 from Joseph, during the libdescent bootstrap work; this
is the measuring stick for all desc-format proposals.*

> Moved here from `notes/` 2026-07-16. Known inbound references from the
> descent repo still point at the old path (`tools/descent/rust/PROGRESS.md`
> ×2, `tools/descent/rust/spikes/udon-reader/NOTES.md`) — fix descent-side.

## Origin

`.desc` began as a **descriptive table** — literally a bit-lookup-table-style
document Joseph built to keep track of state × input-byte → action while
writing an RTMP parser, before realizing the table could *generate* the
parser instead of merely describing it. That generated RTMP parser is still
in use at Amazon/Twitch.tv. descent is the generalization of that move.

## The load-bearing principle

**.desc files read like bit lookup tables** (and render as markdown tables
with the right help). The tabular quality is not aesthetic — it is the
comprehensibility mechanism: rows aligned per state/case make it easy to
reason about **the steady advance of the cursor** through the input. A
state's dispatch is scannable at a glance; the eye audits coverage the way
it audits a truth table.

Any proposed .desc construct — especially "more udonic" ones — is evaluated
against this: does it preserve or strengthen cursor-advance legibility and
the table-scan property? Nesting, prose, and UDON-alignment are welcome
where they serve comprehension; they must not dissolve the table.

## The known failure mode

Over time, **the Ruby implementation's per-line lexing assumptions came to
dictate .desc syntax more than descent's own principles did** — some
current constructs are lexer artifacts, not design. The libdescent rewrite's
desc-format proposals ledger should therefore classify each quirk it hits:
*principled* (serves the table/cursor legibility — keep, spec it) vs
*lexer artifact* (accident of the Ruby scanner — candidate to normalize
under the oracle-guarded rule, or to redesign in the UDON-dialect endpoint).

## Where this points

The fusion endpoint (.desc as a pure UDON dialect + schema) succeeds only
if the UDON rendering of a grammar is *at least as table-legible* as today's
.desc. Rendering-to-tables (Layer 4, `markdown-layers.md` in this directory) is part of
the answer: the stored form and the scanned form need not be identical if
tooling renders grammars back into the lookup-table view Joseph reasons in.
