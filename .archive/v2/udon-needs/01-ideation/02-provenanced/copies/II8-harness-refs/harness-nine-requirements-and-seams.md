---
source: archema-io/harness/ai-cli-tools-fork-recommendation.md — Joseph's harness-requirements derivation read against the shipping OSS coding CLIs
gathered: 2026-07-21
status: gathered — excerpted verbatim spans (nine requirements; per-seam matrix; interiority-loop + doom_loop design note); the ranking/red-team narrative is summarized, not copied
paths:
  - /Users/josephwecker-v2/src/archema-io/harness/ai-cli-tools-fork-recommendation.md   # 31KB; excerpted Part 1, the per-seam table, the interiority/doom_loop design note
source_commit: "archema-io: 1b98ad4; file dated 2026-07-19"
categories: [harness-requirements, tier-1-ideology, context-assembly, memory-provenance, agent-loop, interiority, loop-guarding, harness-handover]
why_included: >
  The clearest single statement in this section of what an agent harness must
  provide — and what off-the-shelf harnesses get WRONG — derived by reading the
  shipping OSS trees (opencode/codex/aider/grok-build) against Joseph's PROPRIUM
  design. Primary consumer here is the harness programme (this IS the target
  document's subject), but several requirements are also UDON-facing: honest
  context assembly / no "gaslighting," provenance-separated append-only stores,
  and a tool layer with "safety + teaching semantics" all name properties a
  notation and its tooling must support. The doom_loop / interiority-guard design
  note is the strongest cross-tool convergence in the harness tier: xAI's
  grok-build shipped, in its sampling protocol, the exact loop-guard shape
  PROPRIUM derived independently — genuine triangulation (different vendor,
  different substrate, same answer).
---

> Excerpt of `ai-cli-tools-fork-recommendation.md` (2026-07-19), a document that
> reads four shipping coding-CLI source trees against Joseph's harness design.
> The fork-target ranking (opencode #1) is summarized; the *requirements* and the
> *convergence findings* — the parts that witness demand rather than a
> one-time build decision — are copied verbatim.

---

## The nine harness requirements (verbatim, Part 1)

*"The load-bearing ideas impose **nine harness requirements**, ordered by how
PROPRIUM-specific they are and how weak off-the-shelf harnesses are on each":*

- **A. Sovereign, interceptable context assembly (CONSPECTUS)** — *the single most load-bearing requirement.* The harness must not own "what enters context this turn" as an opaque step; the agent's consciousness decides what to attend to, the runtime faithfully assembles it. Context assembly must be a **replaceable seam** with preserved invariants (identity / current-thought / causal-coherence / epistemic-honesty). *This is where mainstream harnesses are structurally weakest.*
- **B. Honest INTERPRES / no "context gaslighting" (inviolable)** — the provider layer must **never fabricate what the model said or misrepresent causality**. Forbids summarizing history into synthesized (often first-person) text passed back as the conversation. Compaction is **rip-and-replace**; the raw record (git-backed) is preserved separately.
- **C. Non-user-gated loop + external scheduler + observation channels** — the entity has interiority; the loop runs on internal pulses + background reports, not only user messages. Needs a long-lived process, an event/observation bus, an external scheduler.
- **D. Provenance-separated, pluggable memory stores** — **observations vs actions** as a *structural* causal boundary (never a shared key-space; both append-only). Memory subsystem should be **swappable**.
- **E. Multi-provider incl. local + capability catalog + identity-sharing sub-agents** — **Substrate Independence is a stated principle**: must not *require* a closed frontier model. Sub-agents run on a substrate hierarchy (frontier for conscious thought, local ~70B for consolidation/monitoring), sharing the parent's identity.
- **F. Sovereign system prompt (AXIOMATA) as first-class + per-turn config** — agent-authored "minimum viable self"; config stored per-turn.
- **G. Robust provider layer** — retries/backoff, cache breakpoints, accurate token accounting, incomplete-state detection + blocking recovery.
- **H. Tool layer with safety + teaching semantics** — single-match `str-replace` showing all match line-numbers, backup-before-edit, query-for-files RAG.
- **I. Hooks for out-of-band learning** — every tool use logs intent→outcome for later consolidation; memory-query as an MCP-shaped external tool.

**Requirement H is the direct UDON/edit-tooling hook** — "single-match str-replace
showing all match line-numbers, backup-before-edit" is the same exact-match +
uniqueness contract the three edit formats converge on (see
`edit-format-schemas.md`), stated here as a *harness requirement* with an added
demand: **teaching semantics** (show all matches, not just fail). "Safety +
teaching semantics" is the phrase to carry to synthesis.

---

## Per-seam comparison (verbatim table)

*How the shipping OSS bases score against each PROPRIUM seam — a compact map of
where real harnesses help vs. fight the requirements above:*

| PROPRIUM seam | opencode-v2 | codex | grok-build |
|---|---|---|---|
| CONSPECTUS (context assembly) | **Help** (Context Epoch, provider-neutral) | Partial — real seam, Responses-typed | borrow |
| CHRONICA/ACTUS (memory provenance) | **Help** (EventV2 log + projectors) | Partial — rollout append-only but Responses-typed, no provenance | borrow (reattach durable-log) |
| INTERPRES / honest compaction | **Help** (keeps transcript, swaps active rep) | Fight (compaction = ResponseItem variants) | — |
| CADENTIA / interiority loop | Help (forming — inbox + wake/run) | **Welded** (request→response) | **Borrow (strongest)** — leader/daemon owns entity+loop |
| auxilia (identity-sharing sub-agents) | Help (clean seams) | Help+ machinery (but for *independent* agents) | borrow (subagent + ToolKind) |
| memories / MEMORATA | Neutral (clean slate) | **Fight** (uploads to OpenAI backend) | — |
| Inviolable invariants | runtime (Effect/TS) | **Help (best — compile-time Rust)** | Help (Rust) |
| License / private-fork | **Help — MIT, proven-forkable** | Apache-2.0 but §1.4-counter | **Blocked** (read-only mirror) |

*The verdict (summarized): opencode is the recommended private-fork base — but
the move settled at "track opencode-v2 + prototype the mappings + probably graft
CONSPECTUS/INTERPRES as plugins," not "fork v1 now," because opencode's in-flight
v2 is independently converging on the PROPRIUM shape (a first-class "Context
Epoch" = durable CONSPECTUS; transcript-preserving compaction = honest INTERPRES;
a durable `session_input` inbox = PERCEIVE/CADENTIA admission).*

---

## The interiority loop + loop-guarding — the strongest cross-tool convergence (verbatim spans)

*Design note, 2026-07-19. The finding that xAI's grok-build shipped, inside its
sampling protocol, the exact loop-guard shape PROPRIUM derived independently.*

The organizing inversion:

> "Standard coding-CLI loops *are* the request→response cycle. ... PROPRIUM's
> CADENTIA + the **'interiority except explicit emission'** stance flips this:
> the loop is **primary and continuous** ... and **message-emission is one
> discrete, deliberate action**, not the loop's clock. ... **Emission-as-explicit-action
> is where INTERPRES honesty becomes *structural*.** If the runtime never
> auto-sends the model's text — if 'emit' is a tool the entity calls — then
> everything the user sees is something the entity *chose to say*. Silence
> becomes a valid state. Honesty stops being an enforced rule and becomes an
> architectural property."

grok-build's `doom_loop` guard, read from source (`crates/.../xai-grok-sampler/src/doom_loop.rs`):

> "the **backend emits doom-loop signals over the SSE stream**, and the client
> **collects them per-attempt with a recovery-budget policy and a mid-stream
> abort** — i.e., repetition/stuck-loop mitigation is a first-class part of the
> sampling protocol. ... the server emits a *cumulative*
> `tail_repetition:{threshold}@{channel}` / `low_logprob@{channel}` trigger set
> on the SSE stream; a **per-attempt** collector dedups them; and the
> **confidence policy is the sharp part** — it acts *only* on `tail_repetition`
> **on the `thinking` channel** below a threshold, everything else warn-only,
> with the explicit rule that **'loops in visible output are the user's to
> judge.'** On a confident thinking-loop it **aborts mid-stream and resamples
> near-immediately** (a fresh sample, *not* exponential backoff — 'waiting buys
> nothing; a fresh sample is the remedy'), up to a small budget (2); when the
> budget is spent it **disarms and lets the final attempt complete as-is** —
> never infinite, never fatal."

Why it's a convergence, not just prior art:

> "the **channel-scoped intervention maps 1:1 onto PROPRIUM's own boundary**:
> auto-guard the *interior* (thinking ≈ deliberation), but **never silently
> resample or discard the entity's visible OUTPUT — because ACTUS is
> sovereign**. That is the *same* interiority/ACTUS line as
> emission-as-explicit-action above — **grok reached it independently, which is
> strong corroboration; adopt it verbatim.**"

**For the harness handover:** this is the one place in the section where a
Tier-2 shipped practice (grok-build's protocol-level loop guard) and a Tier-1
ideology (PROPRIUM's sovereign-output / interiority boundary) triangulate onto
the same design — the detector/confidence-policy/recovery split, channel-scoped
so the guard touches deliberation but never the entity's chosen output. Flag as
a genuine cross-tier convergence per the Brief's convergence-discipline bar.

*(Honest provenance flags carried from the source: the `memories`-uploads-to-OpenAI
finding is primary-source confirmed; grok's reattach-durable-log and "richer
multi-agent machinery" claims are structural inferences from file listings + e2e
test names, bodies not fully read; the doom_loop abort-site wiring is
reconstructed from the collector + retry docstrings, not the stream module.)*
