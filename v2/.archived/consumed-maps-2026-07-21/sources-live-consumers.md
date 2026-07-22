---
source: gathering pass (Grok), live UDON consumers outside this repo
gathered: 2026-07-21
status: mining-spot listing + partial extracts — not synthesis
scope: |
  Real documents that use UDON today (or load it). Not deep schema-framework
  design (see sources-schema-versioning.md). Registry mirror: extracts/CONSUMERS.md.
---

# Sources — live consumers (usage → needs)

Purpose: ground demand in **actual documents and loaders**, not only design
essays. Highest signal from 2026-07-21 capped scan under `~/src/`.

## Extracted heads (partial)

| Gathered | Original | Consumer need residue |
|----------|----------|------------------------|
| `extracts/consumer-vivarium-PROCESS-head.udon` | `~/src/archema-io/vivarium/doc/PROCESS.udon` | Safe-subset authoring contract; hybrid structure+prose; wait for CLI |
| `extracts/consumer-vivarium-DECISIONS-head.udon` | `~/src/archema-io/vivarium/DECISIONS.decision-log.udon` | Append-only concurrent log; identity + dense headers |
| `extracts/CONSUMERS.md` | repo `CONSUMERS.md` | Full registry + unused-feature surface |

## Mining spots (not yet extracted)

| Path | Why |
|------|-----|
| `~/src/archema-io/asf/msc/meta-process-review-2026-07-07/PROCESS-MAP-v0.udon` | Process-map genre precedent (MECE, health/drain tags) |
| `~/src/archema-io/vivarium/LEXICON.udon` | Dictionary: slug identity, status, relations, `!:md:` tables |
| `~/src/archema-io/vivarium/tabularium/terrestris.ordinum.udon` | Machine-read law-data; versioned phases for Rust |
| `~/src/archema-io/vivarium/tabularium/README.md` | Schema-by-filename (`*.ordinum.udon`); `stdin_parse` until CLI |
| `~/src/archema-io/vivarium/crates/vivarium-world/src/ordinum.rs` | Hand parser awaiting libudon — runtime consumer demand |
| `~/src/archema-io/vivarium/doc/plan/regula-conformance-design.md` | Upcoming `.regula.udon` profiles / conformance rigor |
| `~/src/archema-io/vivarium/FORMAT.md` | Cross-doc path schemes into LEXICON/DECISIONS |
| `~/src/autopax/taxonomy.udon` | Nested taxonomy; multi-value attrs (comma hazards) |
| `~/src/archema-io/TODO.md` | Program demand for Rust linters / decision logs once tools land |

## Need classes distilled (from corpus, not decisions)

- Safe subset + lint/fmt CLI (PROCESS authoring rules)
- Schema = root type = filename designator pattern
- Identity `[key]` density for greppable first lines
- Date attrs today unvalidated strings → temporal dialect migration surface
- Append-friendly docs (no forced single root wrapper)
- Real library parse for runtime (not forever hand parsers)
- Raw dialects (`!:md:`, `!:sh:`) inside structured docs
- Features consumers **don’t** use yet (`@`, `|{…}`, freeform fences, `<…>`, flags) — product vs overbuild signal

## Not found this pass

- No `*.udon` under `~/src/operata` (name appears in design examples only)
- `ops/` no hits in capped search
