# TODO-AGENT-UX — agent-facing tooling

Cheat-sheets, the empirical usability harness, and agentic affordances. *(Home
tbd.)* Predicated on the compliance fixtures having pinned behavior first.

## Open

- [ ] **Cheat-sheets (rebuild from scratch)** — the old ones were on much older
      models and an older spec; redo from current CORE *after* the compliance
      fixtures have nailed behavior and surfaced ambiguities. Validate via the
      usability harness against the spec (the reference parser can't be the
      yardstick until it is compliant).
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
      reserved trait, or new syntax *(discuss w/ Joseph)*.
- [ ] **Handoff / compaction / memory affordances** — context-handoff
      generator, context-window compactor, UDON-as-agent-memory
      (`UDON-AGENT-TOOLS.md` §5, §15, wild ideas; `UDON-AS-ACP-FORMAT.md`
      bidirectional flow). Now has live consumers to design against — the
      ASF process maps. Predicated on the tool suite above.
- [ ] **UDON as agent/tool response format** — the `UDON-AS-ACP-FORMAT.md`
      thesis ("the format is the protocol"), alive but recontextualized:
      the Dec-2025 docs imagined a new from-scratch protocol (predating
      MCP's dominance); the live version is UDON as the *payload*
      convention — tool outputs, handoffs, traces — inside existing
      protocols and harnesses. udon-agentic's tools already emit UDON;
      keep this as the north star when their output conventions are
      specified. Background/motivation: `../design/AGENT-CONTEXT-PROTOCOL.md`.
