---
source: _ref historical trees (udon-2011, udon-c, libudon, udon-ruby) + udon .attic + umbrella _archive
gathered: 2026-07-21
status: characterization — demand-residue map across the historical layers; small demand docs copied separately (see copies/I7-seam-addendum/)
paths:
  - /Users/josephwecker-v2/src/_ref/udon-c/docs/DECIDED.md:1-243
  - /Users/josephwecker-v2/src/_ref/udon-c/src/udon_introspect.c:1-76
  - /Users/josephwecker-v2/src/_ref/udon-c/lib/udon.h (C API ancestor)
  - /Users/josephwecker-v2/src/_ref/udon/.attic/ (syntax2.udon, syntax.udon, sample1.udon, scratch.asciidoc, declang/ predecessor, udon.ebnf) — VERIFIED ON DISK
  - /Users/josephwecker-v2/src/_ref/libudon/PLAN.md:1-90
  - /Users/josephwecker-v2/src/_ref/udon-ruby/ (bindings + converter suite lineage)
source_commit: >
  _ref/udon 1be87d5d4a51332387b81bbb4c34e0bc0e655db7 ·
  _ref/udon-c 700b9dcbcb5901bb5a792e5a30fa3be9719b374a ·
  (libudon / udon-ruby: separate _ref trees, not pinned this pass — gather date locates)
categories: [historical-archaeology, demand-residue, named-products, converter-suite, streaming-ancestry, warnings-as-data, c-api-ancestor, reach-signal, cross-era-evidence]
why_included: >
  Section 7b: utility ambition, NOT syntax law. Mined for named products and
  surviving demand residue across four eras (2011 Ruby original, udon-c, the
  .attic experiments, the pre-umbrella libudon Rust plan). The finding that
  matters: several agent-era "needs" were already demanded 14 years before the
  agent audience existed, under non-agent framing — cross-ERA re-derivation
  (distinct from the corpus's within-author coherence caveat, because the 2011
  author could not have been designing for agents). Syntax-law content is
  deliberately excluded (ruled elsewhere).
---

> **Method note.** The three tiny 2011 demand docs (objectives priority matrix, features wishlist, compare-to frame, build-TODO) are COPIED whole under `copies/I7-seam-addendum/` — go there for the verbatim demand statements. This file characterizes the *larger* historical artifacts for what products they named and what demand survived, where a full copy would be mostly syntax-law noise.

# 7b — Historical archaeology: named products & surviving demand residue

## The `.attic/` verify-first result (grok's honest gap, RESOLVED)

TARGET-FILES §7b flags `_ref/udon/.attic/` as "**Unconfirmed on disk** (grok's honest gap) — verify existence first." **Verified: it exists** (commit 1be87d5). Contents: `syntax.udon`, `syntax2.udon` (11 KB — the biggest experiment), `sample1.udon`, `nodes.udon`, `scratch.asciidoc`, `name.asciidoc`, `udon.ebnf`, `examples_old/`, `finished_examples/`, and a **`declang/` predecessor project** with `c/`, `js/`, `ruby/`, `ruby2/` bindings + `doc/`. CONVERGENCES §"Standing open items" and MERGED §13 can both mark the ".attic/ declang trail" gap as closed.

**What was being reached for (the reach is the signal, per the Brief):**
- `syntax2.udon` is an extended experiment in **fenced/heredoc data with a declared processor**: `<uuu<` (fenced data like a heredoc that declares its processor), chained fences `<uuu<uuu<"`, embedded fences `<{uuu<"www"}>`, and language-mixing (`<javascript<`, `<super-table<uudecode<"`). This reach — raw data carrying its own processor/dialect, indent-sensitive and -insensitive variants — **survives today** as `!:lang:` raw blocks, freeform ```` ``` ```` fences, and the `<…>` typed/dialect question still live in CORE 0.9. A failed 1-of-N syntax gamble whose *demand* (mix languages/raw data into structured docs without escaping hell) was right and got re-answered.
- `scratch.asciidoc` is the **naming search** (SANS/DISMAL/DEAN/SONO/… and the domain/availability notes) — witnesses that "what is this even called" was an open question; UDON as a name post-dates the design intent.
- `declang/` (declarative-language predecessor, multi-binding c/js/ruby) shows the **multi-language-binding ambition was day-one**, not a later port.

## udon-c `DECIDED.md` — 2011-era design residue with surviving demand

Mostly syntax law (excluded). Two items are demand residue that survived 14 years and reappear as agentic-era convergences:

1. **Streaming, called "online mode."** Under `## PARSING`: *"'online' mode? that is, 'issue' children of the root node as they become finalized and flush all on explicit EOF - otherwise returning current continuation state?"* — this is, precisely, the resumable streaming parser the current `StreamingTreeParser` ships (ships completed root-level subtrees as they close; explicit EOF/finish). The streaming demand is 2011-native.
2. **Warnings-with-severity as returned data.** Under `## PARSER`: *"Warnings w/ severity as a separate structure returned that the implementation can decide what to do with"* + *"Ability to suppress specific warning messages."* This is the direct ancestor of today's `Warning` event and the warning-code system — and of CONVERGENCES cluster 15 (errors that teach / structured diagnostics the host decides on). Diagnostics-as-data, not diagnostics-as-prose, was demanded from the start.

   (Also of note, under `## MISCELLANEOUS`: *"Markdown-like languages easily implemented with tags"* — the markdown-layers demand, pre-figured.)

## udon-c C API — the node/attr/error shape is a stable ancestor

`udon_introspect.c` + `lib/udon.h` show the **C API ancestor** of today's Rust tree: `UdonNode` (name, classes, children), `UdonList` (typed cons-cells: `UDON_STRING_TYPE` / `UDON_NODE_TYPE`), `UdonString` (start+length slices — i.e. spans, not copies), and `UdonError` (message + `data_line` + `data_column`). `udon_introspect.c` is a **pretty-printer / round-trip tool** (`|name.classes`, attributes/id marked TODO). The demand residue: the node+attributes+children tree shape, slice-based strings, and located errors have been the stable consumer contract across C (2011-ish) → Rust (2026). Convergence across the project's OWN eras — the same product keeps being rebuilt because it keeps being needed.

## libudon `PLAN.md` — the pre-umbrella Rust plan & "streaming is foundational"

`PLAN.md` (pre-umbrella, descent-based Rust, 2026-07-08) states the load-bearing demand explicitly: *"The streaming event model is the foundation, not a feature. The parser emits events as it parses—no accumulation. The tree builder … will be just another event consumer."* Its "What Works" checklist is the **earlier public API shape** and a capability inventory (typed values incl. rational/complex, PHF keyword dispatch, context-aware terminators, `|eof` handling, raw blocks, interpolation-with-filters, freeform fences, prose content-base tracking with inconsistent-indent warnings). `README.md`/`CLAUDE.md` carry process discipline for agents working *on* UDON. Value here is provenance of the current architecture's demand rationale, not fresh demand.

## udon-ruby — converter-suite lineage

`_ref/udon-ruby/` holds bindings + a converter suite — the living end of the 2011 TODO's converter ambition (`udon2xml/xml2udon`, `udon2json/json2udon`; `_ref/udon/bin/xml2udon` is the surviving 182-line interchange tool). The "2011→2026 conversion-matrix lineage" (TARGET-FILES §7b): interchange with the incumbent formats (XML/JSON/YAML) was a day-one demand and remains a wishlist item (TOOLING-WISHLIST `to-json`, UTILS conversion). Characterized as a lineage pointer, not copied — the converter code itself is plumbing; the *ambition's persistence* is the signal.

## Umbrella `_archive/` — demand residue, not syntax law

The §7b umbrella-archive row (REVIEW-JULY-2026, REBOOT-PLAN, the `.bak` ledgers, analysis/feedback, HARNESS-AUDIT, EOF proposals, spikes, parser-strategy, the Ruby validator) is explicitly to be mined "for *named products and demand residue*, not syntax law." Not re-characterized here at depth — much of it is already drained into the per-area TODO lanes (per the repo README's 2026-07-16 migration) and the estate-review defect table is history. Flagged as a lower-yield archaeological layer whose live demand has mostly already been promoted into the lanes; a deep pass is warranted only if a phase-2 synthesizer needs the revival narrative's *why*.

## Agreements / divergences vs the 02 synthesis layer

Consulted `syntheses/CONVERGENCES.md` AFTER forming the above.

- **Agreement:** the archaeology corroborates clusters 15 (structured diagnostics) and the streaming/persistence family — but from an era the convergence table doesn't cover.
- **Divergence worth surfacing (the headline finding):** CONVERGENCES frames the whole harvest as 2025–26 agentic-era, and its load-bearing caveat is that within-author agreement is *coherence, not corroboration* (one author, aligned projects). The 2011 archaeology is a **different kind of evidence**: the author of `objectives.asciidoc` and udon-c's "online mode" / "warnings w/ severity" was designing for *human authors and generic software*, with no agent audience conceivable. That agent-era needs (streaming observation, typed diagnostics-as-data, lossless machine API, language-mixing, structured self-description) were independently demanded 14 years earlier under a non-agent frame is **cross-ERA re-derivation** — it strengthens those convergences in a way within-author coherence cannot, because the eras don't share a design intent. Recommend phase-2 treat the 2011 tier as a distinct "substrate-independent demand" datapoint, not merely "more Joseph."
- **Open question for Joseph / merge:** is the 2011→2026 persistence of a demand (e.g. converter suite, streaming) best counted as *one* long-standing need or as independent re-arrivals? It changes how it weights against the Tier-2 lineage-copying caveat. Deferring — this smells like a steward call.
