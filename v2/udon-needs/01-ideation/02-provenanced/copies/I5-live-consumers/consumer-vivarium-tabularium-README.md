---
source: live consumer doc — vivarium tabularium README (schema-by-filename + CLI-demand)
gathered: 2026-07-21
status: gathered — verbatim copy of a short consumer convention document
paths:
  - /Users/josephwecker-v2/src/archema-io/vivarium/tabularium/README.md
source_commit: vivarium@e5b022e
categories: [live-consumer, schema-by-filename, cli-demand, stdin-parse-workaround, libudon-consumer]
why_included: |
  The crispest statement of two live need-classes in one short doc: (1) "Filename =
  `<name>.<root-element-type>.udon`. The root element type is the schema, so the file self-describes
  and tools filter by it (`ls *.ordinum.udon`)" — the schema=root-type=filename-designator pattern;
  (2) the explicit CLI workaround: "Rust consumes these via libudon … validate any edit with
  `cargo run --example stdin_parse < <file>` from the udon core **until a udon-cli lints it**." That
  "until a udon-cli lints it" is naked demand for a lint/fmt CLI, from a consumer currently taping
  over its absence with a cargo example. Also names the safe-subset norm set (`udon-for-structure`,
  `udon-safe-subset`, `udon-filenames`) that PROCESS.udon governs. Copied whole — 20 lines and it is
  itself the demand statement.
---

> **Why gathered.** Live demand for (a) a lint/fmt CLI — the consumer explicitly runs a `cargo`
> example as a stopgap "until a udon-cli lints it" — and (b) the filename-is-schema convention that
> lets tools filter by root type. Both are on the §5 need-class checklist; here they are stated by a
> real consumer in its own words.

---
*(Verbatim copy of `~/src/archema-io/vivarium/tabularium/README.md` at vivarium@e5b022e, 2026-07-21.)*

# tabularium — the library of instituted artifacts

*The Roman **tabularium** was the state archive where the bronze tablets of law were kept. Here it holds vivarium's **structured-but-not-Rust** artifacts — the ones that are more than prose and less than code: law-data with skeletal structure and conformance, authored in **udon** and consumed by Rust through libudon. Established 2026-07-11 with its first tablet, the Terrestris ordinum.*

## What lives here

Artifacts whose content is *data the machine reads*, not narrative and not implementation:

- **ordina** (`*.ordinum.udon`) — codified **phase floors**: per-phase charges, promises, and defeasances for a world-*kind*. The reportatio (prose working text) each was compiled from lives in `doc/` or `.archive/`; the pinned `:reportatio` / `:reportatio-pin` records the exact source. *Present:* [`terrestris.ordinum.udon`](terrestris.ordinum.udon) — the Earth-world-kind (`:manifold cube-sphere-3d-voxel`).
- **regulae** (`*.regula.udon`) — world-level **conformance profiles**: which slots at what minimum rigor, which absences are permitted, the epistemological posture. Each pins an `ordinum@version`. *Coming:* `terrestris.regula.udon` (Regula Terrestris pins the Terrestris ordinum — one track, two faces), spec at [`../doc/plan/regula-conformance-design.md`](../doc/plan/regula-conformance-design.md).
- and, over time, the other structured law-data the design calls for (declarations, slot registries, …) — each a single-root udon document.

The **lexicon** (`../LEXICON.udon`) and the **process norms** (`../doc/PROCESS.udon`) are also udon, but they are project-governance front-doors, so they stay at their load-bearing locations rather than in the archive of world-law.

## Conventions

- **Filename = `<name>.<root-element-type>.udon`.** The root element type is the schema, so the file self-describes and tools filter by it (`ls *.ordinum.udon`). The schema-suffix makes per-type subdirectories redundant — the tabularium is **flat**.
- **Version lives in `:version`, not the filename.** Git versions the file; a version-in-filename is minted only when a *fork* forces two lineages to coexist.
- **One ordinum, many regulae.** An ordinum is a phase floor for a world-*kind* (Terrestris is Earth-lineage; a cellular-automata / 2-D testbed is the anticipated second). Its *schema* is world-kind-agnostic; only its *content* is domain-specific. Multiple regulae may pin the same ordinum at different rigor/target-phase.
- **Rust consumes these via libudon** (`~/src/udon/core`), so the structure is a real interface, not decoration — validate any edit with `cargo run --example stdin_parse < <file>` from the udon core until a udon-cli lints it. Full norms: [`../doc/PROCESS.udon`](../doc/PROCESS.udon) (`udon-for-structure`, `udon-safe-subset`, `udon-filenames`). Vocabulary: [`../LEXICON.udon`](../LEXICON.udon).
