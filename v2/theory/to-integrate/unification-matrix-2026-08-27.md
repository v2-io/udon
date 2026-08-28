# The unification matrix — 0.10.0 reconciled to material/deferred (2026-08-27)

**Register: pre-validation proposal**, the "later work" [[lexical-forms-redux]] deliberately did not do: every 0.10.0-alpha.1 construct mapped into the frame (material / deferred, species, stance, position), with a disposition each. Dispositions: **survives** (already principled; the frame only explains it) · **collapses** (merges into another row; spec text deletable) · **moves** (leaves the core spec; owned by the addressing theory or a consumer layer) · **dissolves** (the question stops existing). Nothing here is ruled; each row is checkable against the suite read whole this session.

## The matrix

| 0.10 construct | Frame cell | Disposition | Why |
|---|---|---|---|
| `\|el`, nesting rule, sameline (G1/G2) | material·thing | **survives** | already principled; untouched |
| `:label value`, stacking, four-state | material·fact | **survives** | untouched |
| identity/traits/suffixes/`$main` sugar | material·fact (designated) | **survives** | sugar-to-designated-assignments untouched |
| text-space, flow, the text law | material·text + the composition rule | **survives** | "prose is content in textual clothing" *is* §7's flow, stated as the one rule |
| comments `;` (all positions) | annotation | **survives** | the accidental exemplar; interior-opacity now principled (spelling of structure, not structure) |
| escape `\` (both frames) | **hold, at the character/line level** | **survives, reframed** | attached `\X` = hold one item; framed ` \ ` = hold the rest of the line. One story instead of a two-operation table |
| `@sel` reference | deferred·reference, **held by default** | **survives, reframed** | "references inert at core" (R7) is a stance-schedule fact: the core always holds; consumers determine. The rule stops being a special posture and becomes the default stance |
| `!{{expr}}` interpolation | deferred·reference, determined at evaluation | **collapses → reference** | same primitive, different as-of moment; retires the only construct with its own brace rule (first `}}`) |
| `!include` (dialect) | deferred·reference under transclude policy | **collapses → reference** | the resolution menu already owns the word |
| `!name` directives (block/inline) | deferred·generator, currently held | **collapses → element grammar + species mark** | K3's "inert this version" = held. Arguments as values (references included) retire head-swallow, the unparsed head, and the `!else` adjacency hack; sameline bodies become ordinary sameline grammar |
| `!:kind:` / fence / `!{:kind:}` verbatim | held span + kind | **collapses → hold + vocabulary tag** | "never look inside" is hold at the span level; kind is who the span is held *for*. Fence stays the byte-exact variant |
| `<…>` envelope, labelled | deferred — reference into a named vocabulary's scope | **survives, reframed** (construed question open) | the ladder names a scope path (dialect:type); "no dialect loaded" = a miss, kept lexically — which is what §11.6 already does |
| `<…>` unlabelled dispatch | resolution under declared **preference** (match over the declared-dialect scope) | **moves → resolution policy** | "offered in declared order, first claim wins" is a preference policy; "all decline → Error" is zero-against-{1,1}. The bespoke dispatch rules become one instance of def-resolution's machinery |
| duplicate `(name,key)` policy §12.3 | **collide** policing (def-binding) | **moves → addressing theory** | the menu (`error \| first-wins \| …`) is collision-surfacing policy; def-binding already states uniqueness as a policed norm, not an invariant |
| `$partial-key` fail-safe | a reference marked non-determinable | **survives** | already the right shape: keep the artifact, exclude it from determination |
| selector frozen-at-three, `@{…}` grammar, paths | reference internals | **moves → addressing theory** | CARVEOUTS §PATHS already says a path syntax replaces the tuple wholesale; the frame just names the owner |
| ML (multi-line per-construct table) §13.2 | capture grammars own their spans | **dissolves** | CARVEOUTS §ML predicted its own dissolution; under one deferred family each capture's grammar owns its line-span by construction |
| mixins §12.4 | reference + merge policy | **moves → consumer over resolution** | trait-matched inheritance is a match-connection plus a merge policy — no core mechanism |
| PRAGMA (dialect/schema binding) | scope **edges** declared by the document | **moves → addressing theory** | "which vocabularies is this document connected to" is an edge-declaration question (def-scope), not new machinery |
| `NoDialectsLoaded`, resolve-time errors | miss meanings (count-against-cardinality) | **moves → §4 of redux** | severity stays consumer policy; the anomaly inventory keeps only recognition-layer rows (unclosed, tabs, indentation…) |
| bare scalar set, syntactic typing §11 | material typing, frozen | **survives** | untouched — the frame needs the frozen bare set as much as 0.10 does |
| keep-everything, severity=loss §14 | recognition-layer law | **survives** | and gains the resolution-side twin for free (no miss drops material) |
| bounded lookahead, extent taxonomy §13.1 | recognition-layer law | **survives** | untouched |

## What measurably shrinks

- **§9 Dynamics nearly empties**: five recognition forms → element grammar + a species mark; head-swallow, unparsed heads, adjacency chains, and interpolation-as-category all go. The Liquid expression grammar leaves the core entirely (expressions are references + filters — addressing-theory grammar).
- **§13.2 ML and its caution box go** (dissolved, as its own carve-out hoped).
- **§12 references thins to the surface family** — selector semantics, matching, uniqueness, resolution menus all live in the addressing theory, cited not restated.
- **§11.6 dispatch rules become one paragraph** citing resolution policy.
- **§4 escape becomes one operation** (hold) with two extents instead of two operations plus a fallback.
- **CARVEOUTS shrinks by dissolution, not closure**: ML dissolved; PATHS/PRAGMA/DIALECT-DEF/ANNOT stop being "deliberately unspecified language questions" and become "owned by the addressing theory / consumer layers" — deferral with an owner instead of a fence with a reason.

What does **not** shrink: geometry, text law, stacking, four-state, anomalies-at-recognition, the frozen bare set — the material half was already right.

## The clean deferrals (each with its owner)

| Deferred question | Owner | What the core keeps meanwhile |
|---|---|---|
| path grammar (outer-path → inner-selection, filters) | addressing theory | one deferred-family surface slot |
| origin-posture spelling (relative vs universal-origin) | addressing theory (writer-intent, carried by the reference) | a slot in the reference's written form |
| evaluation policy + failure vocabulary for generators | def-generator working notes | held-by-default (today's inertness) |
| vocabulary binding (PRAGMA) + dialect definition | addressing theory (scope edges) + dialect work | declared-order preference as interim |
| construed species (typed literals: third species or reference-into-vocabulary?) | def/ working notes | envelope behavior as-is |
| hold composition (saturates? per-level?) | redux §3 open questions | current per-level devices |

## Where this leaves the program

The loop closed in the right direction: 0.10.0 was begun to give references a base language, and the reference theory returned the genus (*deferred*, from def-reference's own invariants) that unifies the base language. The sequence this suggests — proposed, not planned:

1. **Steward pass over this matrix** — each row is a checkable claim; the collapses (interpolation, directives, verbatim) are where a wrong row would cost most.
2. **The addressing theory continues as the critical path** (paths, origin, the newly-converted ref/ primaries) — every "moves" row lands there, and no spec restructure is safe before those rows have a receiving surface.
3. **Only then a suite restructure** (0.11?): CORE's material half nearly verbatim; a new short "Deferred material" part replacing §9/§12/§11.6's bespoke machinery with the family + stance + citations into the addressing theory. The suite gets *shorter* while gaining the store/pipeline story it currently lacks entirely.

*Provenance: 2026-08-27 session — the whole-suite read, [[lexical-forms-redux]] (the frame), `../../references/def/` (all six + def-generator drafted the same day). Every row derives from primary text read this session; none has been verified by a second reader.*
