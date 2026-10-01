# Purpose candidates for later: full UDON, or a later lite

*A holding pile, not records. Things lite 0.1.0 doesn't aim at, but that someone will want to argue from later. Nothing here is decided, and nothing in `obj.future/` resolves as a record: when one is taken up, it becomes an objective, principle or decision in its own store, and its entry here is removed. One file for now; split it when an entry grows. Started 2026-09-30 by the udon-team agent; lead sources are from `.int/principles-survey-2026-10-01.md`, where the fuller passages are, and only the first two below were re-checked against their source here.*

## Likely a later lite (0.1.1 or so)

- **A quick subset of core types inside `<…>`.** Joseph, 2026-10-01: "I decided option 2 for now, but specifically decided we would stay open to doing a quick subset of core types potentially, depending on need (I kind of suspect that will be a 0.1.1 feature or something)." With it, reattaching the temporal parser that already exists ([[decision:explicit-typed-value-in]]).
- **Tiny host-language parsers.** Joseph's 2026-08-30 request (`v2/INBOX-REQUESTS.md`) for "tiny, dependency free 'simplified udon' parsers written in the host languages". Whether this is set aside or deferred is an open question in [[decision:no-bespoke-parser]].
- **A file marker saying "this is lite"** (pre-design 84 Q3), which would let a full parser read a marked file by lite's rules and narrow what lite must reserve. Joseph, 2026-01-14: "Just like document schemas end up really needing a HARD schema-version in order to be useful, I wonder if we need one or two elements or directives for udon documents that say 'This is an archema resource flavored udon.'" (survey #20)
- **Errors that teach.** "World-class error messages and warnings to guide UDON document creation" (Joseph, 2025-12-24, survey #19); and `arch/firmatum/principles`' refusal atoms: a refusal names its class, and offers the next step. Partly lite's now, since a reserved spelling is an error ([[decision:reserved-is-an-error]]).
- **A structured table construct** ([[decision:tables-deferred]], pre-design 08).

## Full UDON

- **Schema-guarded structural mutation** as the customer that paths, schema, spans and round-trip serve (survey #21; Joseph 2026-07-16: "a principled agentic tool that works like your edit tool but guarantees atomicity and guarantees that whatever you're changing or patching etc. has the right indents and is conformant with that file's spec").
- **Paths and addressing** (survey #22); `v2/references/` is the adopted vocabulary.
- **Dialects and typed envelopes, temporal first** (survey #23), including a dialect's "degradation contract" for when it isn't loaded.
- **Templates and directives through references** (survey #24).
- **Schema as a living system** (survey #25; DISCUSSION-THOUGHTS O1, O4–O7, O10).
- **Tooling for agents**: a skeleton view, an edit tool, a file-watcher guard, an editor feedback loop (survey #26).
- **Proven agent onboarding, measured** (survey #27; O8, O9).
- **Epistemic register and annotation as structure** (survey #28; O11, O12).
- **Self-chunking for retrieval**, which the README claims and nothing has measured (survey #29).
- **Streaming with bounded lookahead** as a language law (survey #16). Lite is specified as a tree ([[decision:ast-centric]]), but its documents must parse identically under full UDON's streaming parser, so this may come back as a lite constraint (pre-design 91).

## Non-goals worth stating somewhere (survey §3)

- Not Turing-complete, and not for algorithms.
- Not for pure source code, narrow fixed-schema data packets, or binary.
- No adoption or uptake work.
- No performance work beyond what exists (with a conflict: 2011's objectives ranked performance "Very High").
