---
source: live repo file `ux/TODO-AGENT-UX.md` at gather time
gathered: 2026-07-21
status: gathered source material — NOT an authoritative decision document; live originals may advance
paths:
  - ux/TODO-AGENT-UX.md
source_commit: 3d8e5b9c52b2a581c4ab9021984423073a694693  # verified byte-current 2026-07-21
categories:
  - agent-ux
  - wishlist
  - critical-path
  - edit-tool
why_included: Live agent-UX lane + Joseph priority signal for principled edit (paths→schema→serializer). Open items only posture.
---

> **Why gathered:** Live agent-UX lane + Joseph priority signal for principled edit (paths→schema→serializer). Open items only posture.

# TODO-AGENT-UX — agent-facing tooling

Cheat-sheets, the empirical usability harness, and agentic affordances — homed
in `ux/` beside the human lane (2026-07-16). Predicated on the compliance
fixtures having pinned behavior first.

## Open

- [ ] **Cheat-sheets (rebuild from scratch)** — the old ones were on much older
      models and an older spec; redo from current CORE *after* the compliance
      fixtures have nailed behavior and surfaced ambiguities. Validate via the
      usability harness against the spec (the reference parser can't be the
      yardstick until it is compliant). The January backlog imagined
      per-profile variants worth weighing when rebuilding: simple (no
      dynamics), udon+markdown, template/dynamics, dialects. *(routed from
      `notes/NEXT.md`, 2026-07-16)*
- [ ] **Empirical usability harness (rebuild)** — `test/usability/` results are
      stale (old models/spec); redo with current models, including local ollama.
- [ ] **Agentic tool suite (design → implementation)** —
      `../design/udon-agentic.md` is the design of record (Jan 2026:
      glance/focus/propose/apply/session/trace/infer/validate/search +
      annotate/extract/diff/timeline/template/audit); it absorbed and
      developed most of the Dec-2025 `UDON-AGENT-TOOLS.md` brainstorm.
      Needs a pass against CORE 0.9 (its examples predate the reboot) and
      a fold-in of semantic *merge* — the one Tier-1 idea it doesn't carry
      (`UDON-AGENT-TOOLS.md` §Tier 1) — then an implementation home (rides
      the parser API + `udon-utl`; path syntax is TODO-AUX's lane;
      propose/apply anticipates the still-undrafted patch syntax there).
      *The WHY layer now exists:* `../design/agentic-ux-principles.md`
      (2026-07-16) — re-derive each tool against it before build; where a
      sketch and a principle disagree, the principle governs.
      **Priority signal (Joseph, 2026-07-16):** the piece he most wants is
      the principled agentic **edit** tool — in his words, one that "works
      like [the assistant's] edit tool but guarantees atomicity and
      guarantees that whatever you're changing or patching etc. has the
      right indents and is conformant with that file's spec. It needs the
      path syntax and schema syntax first though." Critical path as named:
      path syntax → schema syntax (both `spec/TODO-AUX.md`), plus the
      serializer/round-trip + spans substrate (`TODO-UTILS.md`,
      `core/TODO-PARSER.md`). A staged shape exists if wanted: an atomic +
      indent-computing + *syntax*-validating v0 needs only paths +
      round-trip; *schema* conformance arrives with schema + pragma.
- [ ] **Grammar-constrained generation** — guaranteed-valid UDON from local
      models via a decoder grammar artifact (GBNF / lark / llguidance-style).
      `../design/GRAMMAR-CONSTRAINED-GENERATION.md` explains the technique
      and hand-sketches a PEG because none existed then; today the artifact
      can be *derived* — `core/generator/*.descent.udon` is a real
      machine-readable grammar, and the pushdown parser tracks exactly the
      state constrained decoding needs. Natural harness tie-in: measure
      invalid-output rates with/without constraints.
- [ ] **Mid-generation feedback (partial-tree affordance)** — "semantic
      streaming": expose the open-element stack, in-progress attribute, and
      prefix/schema validation *while an agent writes* — the agent
      equivalent of syntax highlighting (`UDON-AGENT-TOOLS.md` §Tier 1).
      The substrate landed 2026-07-15 (`TreeStream` / `PushdownParser`);
      what remains is the affordance layer: querying mid-parse state,
      candidate completion, early error surfacing.
- [ ] **Annotation layer for agent metacognition** — structured, strippable
      in-document annotations (`:confidence` / `:source` / `:decision` /
      `:uncertainty`) so agents can leave queryable reasoning-residue
      without touching content (`UDON-AGENT-TOOLS.md` §4; used throughout
      `UDON-AS-ACP-FORMAT.md`). The Dec sketch's `|{@ ...}` form is not
      valid under 0.9 (inline elements take a name; `@` is a reference) —
      needs a syntax/convention ruling: named element (`|{note ...}`),
      reserved trait, or new syntax *(discuss w/ Joseph)*. Same need from the
      Dec-2025 fresh-model review (`_archive/feedback.md`): comment-level
      uncertainty markers (`;?`/`;??`), `???`/TBD values, `.draft`
      prose-is-the-spec marking — fold into the same ruling.
- [ ] **Handoff / compaction / memory affordances** — context-handoff
      generator, context-window compactor, UDON-as-agent-memory
      (`UDON-AGENT-TOOLS.md` §5, §15, wild ideas; `UDON-AS-ACP-FORMAT.md`
      bidirectional flow). Now has live consumers to design against — the
      ASF process maps. Predicated on the tool suite above.
- [ ] **Self-chunking / RAG partitioning experiments** — the README claims
      UDON documents self-segment for retrieval (element boundaries as
      intentional chunk boundaries); nobody has measured it. An experiment
      comparing element-boundary chunking against heuristic chunking (plus
      the "automatic partitioning" idea — tooling that emits the chunks)
      would turn the claim into evidence, or usefully kill it. Natural
      harness tie-in. *(routed from `notes/NEXT.md` "automatic partitioning /
      semantic chunking experiments", 2026-07-16)*
- [ ] **UDON as agent/tool response format** — the `UDON-AS-ACP-FORMAT.md`
      thesis ("the format is the protocol"), alive but recontextualized:
      the Dec-2025 docs imagined a new from-scratch protocol (predating
      MCP's dominance); the live version is UDON as the *payload*
      convention — tool outputs, handoffs, traces — inside existing
      protocols and harnesses. udon-agentic's tools already emit UDON;
      keep this as the north star when their output conventions are
      specified. Background/motivation: `../design/AGENT-CONTEXT-PROTOCOL.md`.
