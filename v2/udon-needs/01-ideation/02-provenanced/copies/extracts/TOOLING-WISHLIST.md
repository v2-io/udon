---
source: live repo file `TOOLING-WISHLIST.md` at gather time
gathered: 2026-07-21
status: gathered source material — NOT an authoritative decision document; live originals may advance
paths:
  - TOOLING-WISHLIST.md
source_commit: 3d8e5b9c52b2a581c4ab9021984423073a694693  # verified byte-current 2026-07-21
categories:
  - tooling
  - agent-debug
  - event-dump
  - round-trip-check
why_included: |
  Joseph felt-needs from 2026-07-19 grammar work: event dump + AST inspect + roundtrip as minimum agent-debug surface. Short, high signal.
---

> **Why gathered:** Joseph felt-needs from 2026-07-19 grammar work: event dump + AST inspect + roundtrip as minimum agent-debug surface. Short, high signal.

# Tooling wishlist — jotted while working (pre-0.9-release tooling pass)

> Scratch pad for "what I wish I already had" as I work in the grammar/spec.
> Joseph, 2026-07-19: basic tooling is the next thing before release. Integrate
> the actionable ones into `TODO-UTILS.md` / `ux/TODO-AGENT-UX.md` at a natural
> break; keep raw impressions here.

## Felt needs (from real friction)

- **`udon events <file>` / stdin → compact event dump.** THE first thing I
  reached for doing the `*{` work. I hand-wrote `udon-core/examples/brace_probe.rs`
  (a compact `Event → "Name \"x\""` printer) because `stdin_parse` dumps `{:?}`
  with spans and is unreadable for eyeballing. Wanted: `--spans` toggle,
  `--fold` (apply the harness's text-fold so output matches fixture rhythm),
  and a mode that prints the *fixture YAML* stanza directly (so a probe becomes
  a paste-ready fixture — closes the loop between "what does it do" and "pin
  it"). `gen_events.rs` half-exists for the YAML side; unify them into one real
  CLI subcommand. **This is agent-facing infra — the consumer of UDON is an
  agent, and an agent debugging UDON needs to see the wire cleanly.**

- **`udon ast <file>` — pretty-print the parsed tree.** For the boundary work I
  keep asking "is `:n |{em x}` a node value or a blob segment?" — the *event*
  stream answers it, but a tree view (`n = <blob: "value ", <em>x</em>, " :a 1">`
  vs `n = <em/>`) would answer it at a glance. Show `all_attributes` vs the
  ergonomic `key/traits/attributes` split (the wire-vs-view round-trip caution
  in CORE is exactly where a consumer gets surprised — a tool that shows both
  side by side would teach it).

- **Round-trip checkers (the reconstruction contract made executable).** The
  text-wire recast's whole promise is "pure in-order concat of text events
  reconstructs the document's text." I want `udon roundtrip --text <file>`
  that parses → concatenates text-bearing events → diffs against the source's
  text bytes, exit non-zero on mismatch. This is the contract as a CLI, and it
  would have *caught the newline-dropping bug the fixtures enabled*. Cheap,
  high-leverage, and a great standing CI gate.

- **AST ⇄ JSON round-trip.** `udon to-json` / `udon from-json` over the tree.
  Two wins: (1) lets non-Rust consumers (and me, quickly) inspect structure with
  `jq`; (2) `from-json | to-udon | parse` round-trips exercise the serializer
  and surface the byte-faithful-span gaps already logged (the empty-node `\`
  span, `core/TODO-CORE-PARSING.md`). JSON is lossy for some UDON distinctions
  (stacked `:x 1 :x 2` vs `:x [1 2]` — the wire-vs-view caution again), so the
  tool must pick `all_attributes` semantics and document the projection.

- **`udon fmt`** (canonical re-emit) — even a minimal one would dogfood the
  serializer/SourceInfo work and give the "computed indentation removes the
  write-side hazard" benefit TODO-AUX's schema note wants for the edit tool.

## Notes toward integration
- The event-dump + AST-inspect + roundtrip trio is the minimum agent-debugging
  surface; it belongs in `TODO-UTILS.md` (`udon-utl`) and doubles as the
  learning/eval substrate in `ux/TODO-AGENT-UX.md`.
- Everything here reads from a *compliant parser*, so it's correctly downstream
  of the `core ^0.9` gate — none of it blocks the tag, all of it wants to exist
  the moment the tag lands.
