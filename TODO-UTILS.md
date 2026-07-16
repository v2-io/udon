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
      plan, 2026-07-16)*
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
- [ ] **`udon fmt`** — optional; UDON mandates no canonical form, so only if
      we choose to offer one. If we do, it has two more jobs beyond style:
      paste/ingest renormalization, and closing the column-alignment
      fragility corner (padding slack after renames). *(discuss w/ Joseph)*
- [ ] **`udon-cli`** — one installed binary `udon` (crate `udon-cli`,
      `[[bin]] name = "udon"` — crates.io `udon` itself is squatted):
      `parse` / `events` / `skeleton` first, then `lint`, then
      `fmt` / `convert`. *(routed from the archived reboot plan, 2026-07-16)*
- [ ] **Guarantees / validation** — `design/udon-guarantees.md` explores the
      space (guarantee ladder, consistency profiles); extract tasks here.
