# UDON Glossary — 0.10.1-draft

**Status: PROPOSAL DRAFT.** Delta-glossary: new and changed terms only; every 0.10.0 GLOSSARY term not listed here carries unchanged (structure, spaces/positions/recognition, text/flow, values, extents, anomaly terms). Addressing-theory terms (reference, referent, intended-cardinality, resolve, dereference, binding, match, scope, origin, resolution, use, deferral) are **defined in `../references/def/` and only cited here** — def/ has primacy; this glossary never restates them.

## New

- **Material** — an item determined at writing: a thing (element), a fact (assignment), or text. (CORE G5.)
- **Deferred** — an item determined at use, not at writing; the genus of reference and generator (named from def-reference's invariants). (CORE §9.)
- **Generator** — deferred material that produces rather than stands for; parses as an element with the `!` species mark; held by recognition. (def-generator; CORE §9.2.)
- **Hold** — the stance that performs no determination: the item travels as an artifact. One operator per level: `\` (character/line), captures (spans), `@<…>` (a reference as a value). (CORE G6, §4, §9.)
- **Determine** — resolve/dereference a reference, evaluate a generator, construe a capture — always by a consumer, from an origin, as of a moment; never by recognition. (CORE §9.4.)
- **Capture** — a held span for a named vocabulary, in four geometries (value `<…>`, block, fence, in-flow); unifies the 0.10.0 envelope and verbatim families. "Envelope" survives as the value-geometry's name and ladder. (CORE §9.3.)
- **Annotation** — uninterpreted material addressed to the document's maintainers instead of its consumer; interior opaque by definition; the `;` family. (CORE §8.)
- **Head** — the addressing expression a reference carries (`@head`); grammar owned by the addressing theory; this version recognizes the selector subset plus delimited raw heads. (CORE §9.1.)
- **Schedule** — a consumer's assignment of determinations to stages/origins/moments; not a language object. (CORE §9.4.)

## Changed / retired

| 0.10.0 term | 0.10.1-draft |
|---|---|
| dynamics (the `!` family) | **generators** (species), with the baseline template vocabulary as a companion; "directive" survives informally for that vocabulary's generator names |
| directive (model kind, unparsed head) | **Generator** (element shape + species mark; head parsed) |
| interpolation `!{{…}}` | *(retired)* — embedded reference `@{…}` |
| verbatim (family) · envelope (family) | **capture** (one family; envelope = its value geometry) |
| comment | **annotation** (rename; behavior unchanged; opacity principled) |
| "inert" (interim mode / posture) | *(retired as a mode)* — recognition **holds** everything, permanently |
| `NoDialectsLoaded` (anomaly) | a **miss** (consumer-side; meaning from cardinality) |
