---
source: live repo file `TODO-UTILS.md` at gather time
gathered: 2026-07-21
status: gathered source material — NOT an authoritative decision document; live originals may advance
paths:
  - TODO-UTILS.md
source_commit: 3d8e5b9c52b2a581c4ab9021984423073a694693  # verified byte-current 2026-07-21
categories:
  - utils
  - skeleton
  - serializer
  - udon-guard
  - round-trip
why_included: |
  Live utilities lane: skeleton, round-trip, guard, reflow hazards — direct utility/capability seeds for phase (3).
---

> **Why gathered:** Live utilities lane: skeleton, round-trip, guard, reflow hazards — direct utility/capability seeds for phase (3).

# TODO-UTILS — udon-utl

The utilities payload (the "safe set" for vivarium / ASF): accessors, tree
helpers, conversion, formatting, guarantees. *Co-locates with `udon-utl` when
that crate lands; at root for now.* Predicated on a compliant parser.

Items marked *(routed from the archived reboot plan, 2026-07-16)* arrived when
`REBOOT-PLAN.md` / `REVIEW-JULY-2026.md` drained into the lanes (both now in
`_archive/`).

## Open

- [ ] **Accessors** — `attr` (scalar/last) + `attr_all` (list); `traits` view
      always a list; host views.
- [ ] **Reference expansion / mixin-style merge helpers** — core `@` is an
      inert pointer by ratification (never insertion), which makes
      dereference/expansion a *host* utility: resolve a reference's selector
      tuple against a tree, and (maybe) the old merge-attributes-from-target
      idiom. Whether the merge half is wanted at all, or belongs to the
      schema layer, is open. *(routed from `notes/NEXT.md` "mixin expansion /
      reference expansion", 2026-07-16; discuss w/ Joseph)*
- [ ] **Value coercion API** — `as_i64()`, `as_f64()`, `as_bool()`, … Values
      hold validated raw text by design (good); the ergonomic layer is
      missing. *(routed from the archived reboot plan, 2026-07-16)*
- [ ] **Serializer / round-trip** — emit UDON from the tree; success =
      `parse ∘ serialize` identity over the example corpus
      (`design/examples/`). Attempt the hardest part first
      (whitespace / attribute-order preservation): a no-go that enumerates
      exactly what a SourceInfo layer must capture is as valuable as success —
      it *is* the SourceInfo requirements document (`design/udon-ast.md`
      sketches SourceInfo as a parallel metadata layer). Prerequisite for
      every agentic edit tool (propose/apply). *(routed from the archived
      reboot plan, 2026-07-16)*
- [ ] **Skeleton view** — a document map where every line is a valid,
      copy-pasteable path (with `[*]` for multiples, attr lists, prose
      indicators, counts — `design/udon-ast.md`). Quietly the single best
      agent-orientation affordance in the whole design; build it in the
      first utilities pass, not the last. *(routed from the archived reboot
      plan, 2026-07-16)* Joseph, 2026-07-16: a given-a-document
      show-all-viable-paths tool "could be super useful — it's also
      essentially a document summary" — same tool: skeleton = the paths
      enumeration = the summary, one artifact serving all three readings
      (and the natural first consumer of the path syntax).
- [ ] **udon guard — a file-watcher enforcing tool-mediated edits**
      (Joseph, 2026-07-16, sketch): "an udon file-watcher that specifically
      undoes any agent-or-human edits to any udon files, where using the
      correct tool instead receives a token from this guard that says what
      edit it is going to attempt / operation or set of operations, that it
      will use to know if the edit is legitimately through the correct
      tool. (or something like that). (keep the blanket readability...)"
      This is the answer to `design/udon-guarantees.md`'s gatekeeper
      problem ("a rogue vim edit bypasses everything") — enforcement
      inverted from hope-writes-flow-through-the-tool to
      out-of-band-writes-revert-by-default; the token handshake is
      declared-vs-honored made mechanical (the tool declares the operation;
      the guard verifies the resulting diff matches the declaration —
      `design/agentic-ux-principles.md` P7). Design notes to work through
      (mine, unratified): reverted edits are **quarantined, never
      destroyed** (keep-everything applies to humans too — revert + save
      the rejected edit + notify, so a vim edit becomes a reviewable
      proposal rather than a loss); files stay plain readable text (the
      guard is beside the files, never wrapping them); enrollment likely
      per-directory/profile (the Careful/Critical dial) rather than
      blanket; VCS interplay needs care (checkout/merge/rebase legitimately
      rewrite files — recognize or suspend); token shape could be as thin
      as an intent record (op descriptor + expected-result content hash)
      the guard matches against observed changes. Predicated on the edit
      tool existing. **Refinement (Joseph, 2026-07-16): quarantine lowers
      the required cadence — the guard "could be a commit check instead"
      of a live watcher — and the posture is udon-filetype-specific, a
      spectrum:** RDBMS-like hardening/concurrency/immediate rejection at
      one end; gentleman's-agreement care with schema checkpointing at
      deploy in the middle; no-schema-yet-but-aspiring at the other (see
      the schema-by-exemplar and aspirational-designator items in
      `spec/TODO-AUX.md`). Enforcement cadence (live watcher → commit
      check → deploy checkpoint → convention) selects per file/profile.
      *(discuss w/ Joseph when picked up)*
- [ ] **Paths implementation** — `at`/`all` MVP first, exercised against the
      live ASF process map (earliest real-consumer signal; surfaces path
      syntax issues like `||` and `[*]` before the full implementation
      commits to them). Path *syntax* questions live in `spec/TODO-AUX.md`.
      *(routed from the archived reboot plan, 2026-07-16)*
- [ ] **Linter + hinter** — spec warnings surfaced well; style hints
      (alignment fragility, over-quoting); and the **reflow-damage
      heuristics** no generic editor feature can catch: attr-after-prose,
      comment/directive lines interrupting a paragraph mid-flow, sudden
      dedent of a paragraph tail. The hazard being guarded: UDON prose is
      valid at any indent — a reflowed line doesn't fail, it silently
      belongs to someone else, and a wrapped sigil-initial word silently
      becomes structure. *(routed from the archived reboot plan, 2026-07-16)*
- [ ] **Conversion** — `udon2md` / `md2udon` over the real parsed tree
      (Layer 3; degradation policy per `spec/MARKDOWN.md`); then JSON / YAML,
      bidirectional, spec-faithful, on the real tree (the old udon-ruby
      `bin/` scripts were regex sketches — reference only).
- [ ] **`udon fmt` — TABLED** (Joseph, 2026-07-16: "needs a much bigger ux
      prioritization discussion"). Context for whenever it reopens: UDON
      mandates no canonical form, so shipping a formatter creates a de-facto
      one; the candidate jobs beyond style were agent round-trip stability,
      paste/ingest renormalization, and closing the column-alignment
      fragility corner; the hazard is prose reflow (structure-safe-only was
      the recommendation on the table when it was set aside). Joseph's
      tabling rationale, worth meeting before re-arguing: effort spent here
      "would end up being friction for adoption when the same effort could
      be spent on an actually principled tool" — the agentic edit tool
      (span-splicing makes canonical form unnecessary for edits). Don't
      pick this up without that discussion.
- [ ] **`udon-cli`** — one installed binary `udon` (crate `udon-cli`,
      `[[bin]] name = "udon"` — crates.io `udon` itself is squatted):
      `parse` / `events` / `skeleton` first, then `lint`, then
      `fmt` / `convert`. *(routed from the archived reboot plan, 2026-07-16)*
- [ ] **Guarantees / validation** — `design/udon-guarantees.md` explores the
      space (guarantee ladder, consistency profiles); extract tasks here.
