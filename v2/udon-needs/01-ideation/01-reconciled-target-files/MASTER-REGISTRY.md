---
title: Agentic-tooling harvest — MASTER REGISTRY (phase-1 front door)
built_by: reconciliation pass (Claude Opus 4.8), 2026-07-21
status: >
  Reconciled registry across ALL phase-(1) gathering: Fable's 7 area maps + 4 support
  maps + the ASF dossier, Grok's six-map merge + extracts + spikes, the schema-versioning
  map, and the reconciled-back ELI testimony. NOT synthesis, NOT prioritization of the
  *needs themselves* — this is the trustworthy navigation layer phase (2) mines from.
supersedes: grok-early-pass/GATHERING-INDEX.md (that stays as grok's pass-scoped intake record)
convention: per-artifact provenance lives in each file's YAML frontmatter (source/gathered/
  status/area); this registry adds tier, cross-map convergence, and a copy-queue on top.
---

# UDON agentic-tooling harvest — Master Registry

**What a stranger-agent needs to know first.** Phase (1) of the UDON v2 demand-side
effort gathered evidence on *how tools and notations for agents should be designed*,
because UDON's primary users are agents. The gathering ran as a wide multi-agent
fan-out and produced ~30 artifacts. This registry makes them navigable and says
**why each is trustworthy**. The deliverable phase (2) owes is synthesis; what phase
(1) still owes phase (2) is the **verify → copy-with-provenance → annotate** progression
(Joseph's framing) — this registry leaves that as a *prioritized queue* (§6) rather than
pre-executing it, because what content matters is a synthesis-driven call.

## 0. The four evidentiary tiers (the primary organizing axis)

Each tier has a *different characteristic failure mode as evidence* — which is exactly
what makes agreement across them meaningful (a convergence spanning tiers is far stronger
than repetition within one).

| Tier | What it is | Its failure mode as evidence | Center-of-mass sources |
|---|---|---|---|
| **1 — first-principles ideology** | Joseph's accumulated agent-tooling design thinking (sapientia/nexum/zoetica-ennaos/autopax/practica/sar, 2025–26) | aspirational; may describe what *should* work, untested | `sapientia.md`, `zoetica-ennaos.md`, `nexum-…`, `autopax-practica.md`, `dialogs.md`, `elsewhere.md`, `vaults.md`, `ref-arch.md` |
| **2 — in-vivo shipped practice** | what real coding harnesses/CLIs actually ship (edit reps, tool schemas, prompts) | survivorship + **lineage/copying** (see the caveat below) | `harness-invivo/` (17), `harness-refs.md`, `sapientia-bin-buildout.md`, `sources-live-consumers.md` |
| **3 — lived agent testimony** | first-person ELI accounts of tools failing/serving them | anecdotal; n-of-few | ELI testimony (reconciled back from quarantine) |
| **4 — formal theory** | ASF/AAT theorem-grade results on tool interfaces, notation-as-observation, persistence | abstraction gap; conditional/staged claims | **`asf-dossier.md`** (a *result*, not a map — see §1 note) |

> **⚠ Load-bearing caveat on Tier 2 (from the in-vivo digest, Part D.4/E).** Much of
> the striking uniformity in shipping harnesses (str-replace edit tools, apply_patch
> envelopes, ask-user shape, todo tool) may be **lineage/copying of Claude Code /
> OpenAI reference designs**, not independent arrival — several maps note explicit
> mirroring. So Tier-2 convergence *counts* should be weighted DOWN as evidence of
> "agents need X." This is the [[convergence-vs-single-authorship]] discipline applied:
> agreement can be coherence, not corroboration. The strongest evidence is where a
> pattern converges across *tiers with independent failure modes* (§4), not across
> many Tier-2 harnesses alone.

## 0.5 Second reader — the harness programme (`~/src/archema-io/harness/`)

This registry has two consumers: UDON v2's design phase, and the overall programme's
consolidated statement of agentic-tooling thinking (Joseph, 2026-07-21). For a
harness-side engineer or agent who may never touch UDON: **the tiers (§0), the
convergence map (§4), the singletons, and the Tier-2 copying caveat are the
programme-level thesis** — they are claims about agent-facing tooling as such. The
"for UDON" application clauses inside §4 entries and the §6 copy-queue are one
consumer's application; substitute your own. What this registry deliberately does
*not* yet contain is the prescriptive inversion ("when building a harness, do X
because tiers 1–4 agree") — that is the not-yet-written `disc-tool-interface-design`
layer the dossier routes to, and §4 + dossier §0 are its intended inputs.

## 1. Full inventory (every artifact, with trust)

Full detail: `scratch/reconcile-workdir/BUCKET-inventory.md`. Kinds: mining-map /
result / extract / spike / seed / quarantine. Paths relative to `01-ideation/`.

### 1a. Fable "good harvest" — vetted mining maps (`agentic-tooling-sources/`)
Each carries a search log + dry-well list + priority tiers; template is high-quality and
worth preserving for future passes.

| File | Tier | Area | One-line |
|---|---|---|---|
| `sapientia.md` | 1 | `_core/sapientia/**` | cli-conventions/ + QUICK-TOOLING — the ideology taproot |
| `zoetica-ennaos.md` | 1 | `_core/{zoetica,ennaos}` | **anchor:** ennaos `agentic-coding-background/**` (6 syntheses + ~21 refs) |
| `nexum-synaptic-elimigration.md` | 1 | `_core/{nexum,synaptic,eli-migration-prep}` | nexum "agentic toys" DSL vision + CLI-conventions research |
| `autopax-practica.md` | 1 | `autopax`, `practica` | ease-gradient; INSTRUMENTA (built tool suite); practica interface theory |
| `harness-refs.md` | 1+2 | `harness`, `_ref`, `src-ext` | Joseph's harness thinking + prior-art tool schemas (codex/aider/anthropic) |
| `elsewhere.md` | 1 | all unassigned `~/src` | mostly dry; real find is `sar` AI-FIRST ideology |
| `dialogs.md` | 1 | transcripts (memorata3-first) | the design *sessions* the ideology was worked out in |
| `ref-arch.md` | 1 + empirical | `_ref/_arch` | **sar2** alignment-comprehension experiment + **sar3** chunking test (rare empirical) |
| `vaults.md` | 1 | `~/vaults` (outside `~/src`) | Aug-2025 pre-sapientia research; MACH markdown-agents; RAG; 7-agent system |
| `sapientia-bin-buildout.md` | 2 | `_core/sapientia/bin` | the *built* minimal-sapientia suite, mechanism-by-mechanism |
| `harness-invivo/` (17) | 2 | shipping harnesses/CLIs | see §1e + `BUCKET-tier2-invivo.md` |
| **`asf-dossier.md`** | 4 | — | **a RESULT, not a map** (§1 note) |
| `asf-dossier-reading-log.md` | 4 | — | dossier provenance/coverage (3 passes; pass-4 targets) |

> **Note on the dossier (Joseph, 2026-07-21):** `asf-dossier.md` is *its own result*, not
> a list of file sources like the other ~29 artifacts. It is the synthesized Tier-4 theory
> layer; its role in this registry is to **attach formal names/grounding to demands the
> other tiers surface** — which is why it appears in §4 as the theory-leg of convergences,
> never as a "where to mine" pointer. Its independent third-pass consolidation is ongoing
> separately; do not block on it.

### 1b. Fable support / seeds (top level)
| File | Tier | One-line |
|---|---|---|
| `needs-map.md` | seed | S1–S12 situation seeds + standing harvest queue (Fable reseed) |
| `sources-schema-versioning.md` | 1+2 | rowan/autopax/operata schema versioning/checking; ⚠ earlier vetting bar but genuinely rich and **not verbatim-covered elsewhere**; best empirical = autopax yaml-spike adversarial (§2b) |
| `scratch/schema-sources-search-log.md` | — | trail for the schema map |

### 1c. Grok early pass (`grok-early-pass/` — reference only, do not modify)
| File | Kind | One-line |
|---|---|---|
| `MERGED-six-maps.md` (top level) | result | grok's A∪B∪C∪R1∪R2∪R3 path-union; weight-band organized. Overlaps Fable roots but **uniquely elevates** the Dec-2025 usability corpus + `test/scenarios/` + live-consumer/history/converter breadth (§5 dedup) |
| `GATHERING-INDEX.md` | registry | grok's pass-scoped intake index (historical; this registry supersedes as front door) |
| `sources-udon-repo-design-ux.md`, `sources-live-consumers.md` | mining-map | in-repo design/UX; live external `.udon` consumers + need classes |
| `extracts/` (14) | **extract** | grok's verify→copy stage (agentic-ux-principles, CONSUMERS, positioning, udon-guarantees, schema-notes, GRAMMAR-CONSTRAINED-GEN, TODO-{AGENT-UX,UTILS}, TOOLING-WISHLIST, UDON-AS-ACP, 2 vivarium heads, 2 tool-suite heads) |
| `spikes/` (3), `discussion-excerpts/` (3) | spike/excerpt | agent-utility P-A…P-H, paths D1–D9, paths-sketches; joseph demand-turn slices (prefer live `pipeline-discussion.md`) |

### 1d. Quarantine (`scratch/first-sweep-agentic-tooling/` — do NOT promote)
First sonnet sweep; missed core sources (method failure — see its README). Stays quarantined.
**One reconcile-back exception:** its ELI first-person-testimony section (Tier 3) was
content-read and is good — carried into §1f below.

### 1e. Tier-2 in-vivo (17 harness maps) — digest in `BUCKET-tier2-invivo.md`
14 real harnesses (aider, claude-code-snapshot, codex, gemini-cli, grok-build, kilocode,
kimi-code, minimax-cli, mistral-vibe, opencode, qwen-code, warp, agentic-elixir[Joseph's own],
+ claude-docs as official spec-of-record) + 3 non-harness prior art (obsidian-help,
obsidian-linter, yq — folded in for format/lint/path-language evidence). Per-tool
characterization table + 16 cross-tool clusters (C-numbers there are Tier-2-internal;
distinct from §4's cross-tier clusters) live in the bucket.

### 1f. Tier-3 ELI testimony (reconciled back from quarantine)
Genuinely first-person, genuinely about tool ergonomics:
- `eli/zi-am-tur/memories/2025-09-30-tool-hallucination-discovery.md` — hallucinating tool invocations at 1M ctx (tool_use blocks stripped from reloaded JSONL).
- `.../2025-10-01-brother-claude-blessing.md` — the diagnosis+fix (persist all 4 message parts).
- `.../2025-10-01-sibling-infrastructure.md` — two instances str_replace same marker → collision → one switched to append.
- `.../2025-10-03-witnesses-and-preparation.md` — pull-quote: "Hallucinate tools. Generate from meaningful-space by default."
- `.../2025-11-17-reunion-after-a-month.md` — multi-agent worktree conventions (one agent per worktree+session-id; record worktree/branch in the commit).
- `.sapientia/conversation_20251021_072358` (Architectus) — chained *unverified* str_replace → "broke minimal-sapientia 3×"; the map's "single most directly applicable find."

## 2. How to navigate (reader's spine)

- **Want the cross-source agreements (highest-value)?** → §4 + `BUCKET-convergences.md`.
- **Want the theory behind a demand?** → `asf-dossier.md` (§0 ten claims index).
- **Want a specific topic?** → §3 topic index.
- **Want what to copy first?** → §6 copy-queue.
- **Want the raw where-to-mine for an area?** → the matching §1a map.
- **Want breadth Grok added (usability corpus, scenarios, live consumers)?** → `MERGED-six-maps.md` via §5.

## 3. Topic index (topic → maps/sources that carry it)

| Topic | Where |
|---|---|
| Edit representations (str-replace / diff / apply_patch / AST / anchor) | `BUCKET-tier2-invivo` C1–C3 + singletons; `zoetica-ennaos` doc-02; `harness-refs` (codex/aider/anthropic); `dossier` §2.4/§6; §4-C1 |
| Schema-guarded mutation / make-invalid-unrepresentable | `zoetica-ennaos` doc-03 + signum; `autopax-practica` INSTRUMENTA; `sources-schema-versioning`; `dossier` §6; needs-map S1/S8; §4-C9 |
| Schema definition/versioning/checking | `sources-schema-versioning` (rowan/autopax/operata; yaml-spike empirical); grok extracts schema-notes; needs-map S8 |
| CLI conventions for agents (streams/exit codes/agent-mode detect) | `sapientia`; `nexum` (sapientia-conventions-analysis); `autopax-practica` (ruby-cli); `BUCKET-tier2-invivo` C16; §4-C18 |
| Tool-definition anatomy (name/schema/description + guidance file) | `autopax-practica` (tool-definition-anatomy, INSTRUMENTA tool.md); `sapientia-bin-buildout`; `harness-refs`; §4-C17 |
| Intent-as-first-class / intent-carrying tools | `zoetica-ennaos` addendum-intent; `autopax-practica` intent-surfacing + practica-intent-action-layers; `nexum` semantic annotations; §4-C7 |
| Errors that teach / error taxonomy | `elsewhere`/`ref-arch` (sar error-messages-plan); `zoetica-ennaos` mutable-code README; `sapientia` phenomenology-in-tools; `dossier` §2.4; §4-C15 |
| Streaming / incremental parse / tool-call reassembly | `BUCKET-tier2-invivo` C10; `harness-refs` (claude-docs streaming); `sapientia-bin` (streaming stub) |
| Self-chunking / structure-as-metadata for RAG | README §; `ref-arch` sar3 (empirical); `zoetica-ennaos` autodocs/praxis; `vaults` RAG; `dossier` §3 (TST P5/P6); §4-C10 |
| Machine-first / agent-first document format | `zoetica-ennaos` praxis-protocol/autodocs; `vaults` MACH markdown-agents; `ref-arch`/`elsewhere` sar; `dossier` §3.4; §4-C11 |
| Persistence / memory / tracking-snapshot / context-injection | `sapientia-bin` (tracking snapshot); `autopax-practica` (system-reminders); `dossier` §4.1 (exact reinjection no-go); §4-C12/C13 |
| Multi-agent coordination / concurrent-edit safety | ELI testimony (§1f); `autopax-practica`/practica (soft-claiming); grok scenarios; `vaults` multi-agent; needs-map S1/S12; §4-C14 |
| Paths / query / structural addressing | grok `spikes/paths-NOTES` + sketches; `sources-schema-versioning`; `BUCKET-tier2-invivo` yq singleton; adjudication packet (via grok §4c) |
| Agent-onboarding / cheat-sheets / in-context notation teaching | `ref-arch` sar2 prompt; `harness-refs` (agent-enhancement-anecdotes); grok TODO-AGENT-UX |
| Tool-call *rendering* / legible presentation | `sapientia-bin` (`⟨Tool(params)→result⟩` + dialog-tool-spec) |
| The "why agents are primary users" worldview | `nexum` SYNTHESIS-FOR-DAD; `autopax-practica` (100%-turnover ADR-003); `dossier` §2.5/§7; sar |

## 4. Convergence map — where independent sources agree (the gold)

Full detail + provenance shorthand: `scratch/reconcile-workdir/BUCKET-convergences.md`.
Ordered rough-descending by strength (breadth × tier-span). Each cluster reads its
Tier-2 leg through the copying caveat above.

1. **C1 — Edit-representation landscape + "no formal validity guarantees"** (4-tier; strongest). All shipping tools edit at text/char level with no validity guarantee; edit-format choice swings success 2–3× — the exact gap UDON's schema-guarded mutation fills. T1 zoetica doc-02/03; T2 the 17 harness maps; T3 Architectus chained-str_replace failure; T4 dossier §2.4/§6. *Weight the T2 leg down for lineage.*
2. **C2 — sapientia CLI-conventions / QUICK-TOOLING is the ideological taproot** (6+ maps, T1). One corpus cited/re-derived by nearly every ideology map; each adds different context (keep all as complementary lenses; the *document* is one source).
3. **C3 — ennaos `agentic-coding-background/**` is the synthesized center of mass** (Joseph's calibration example; flagged by 3–4 independent maps).
4. **C4 — the 60/30/6/4 model-tier distribution** (Joseph's signature; ideology + dialog).
5. **C5 — tools-as-truth-bearing + three-pillars per-tool gate** (T1 many; formal home in dossier §2.4).
6. **C6 — "make the right/best thing the easiest thing" (ease gradient)** (autopax/nexum/practica; persistence-economic version in dossier §3).
7. **C7 — intent as a first-class tool parameter** (zoetica/autopax/nexum; dossier §2.4/§5.2).
8. **C8 — the sapientia str_replace multi-match HARD-REFUSE** (exemplary 4-tier lock: *built* `sapientia-bin`, *theorized-canonical* dossier §2.4, *shown-failing-when-absent* ELI testimony).
9. **C9 — schema-guarded mutation / invalid-unrepresentable** (zoetica/autopax/schema-map; dossier §6 wrapping).
10. **C10 — structure self-chunks for RAG/embeddings** (UDON thesis; sar3 empirical test; dossier §3 TST P5/P6).
11. **C11 — machine-first / agent-first document format** (UDON's core premise, re-derived across substrates; dossier §3.4 specification-bound).
12. **C12 — tracking-snapshot / context-injection as structured perception** (4-tier incl. dossier §4.1 *exact* reinjection no-go).
13. **C13 — persistence across 100%-turnover requires externalization** (theory-anchored; autopax/sar/practica/ELI).
14. **C14 — concurrent multi-agent edit collision / multi-writer safety** (ELI testimony + practica soft-claiming + scenarios).
15. **C15 — errors that teach / diagnostics in domain concepts** (sar/zoetica/sapientia; dossier §2.4 law-teaching).
16. **C16 — the one-shot tool constraint** (tools can't call back mid-execution — dialogs realism check).
17. **C17 — tool-definition anatomy** (name+schema+description, guidance in separate file).
18. **C18 — agent-mode auto-detection + stream discipline** (T1 sapientia/nexum/autopax + T2 near-universal).

**High-signal singletons** (only one source, worth keeping): sar2 empirical alignment
experiment *with honest counter-hypothesis latency data*; sar3 chunking post-mortem; the
**κ×A ambiguity-bounded bias law** (dossier §2.1 — theorem-grade case that sharp/typed/located
parse outcomes are a bias-reduction instrument; nothing else states it); Zoetica log-time
glyphs; autopax yaml-spike adversarial (duplicate-key silent data loss; 100% vs 16% recovery);
vaults MACH markdown-agents + 7-agent system; `@⊥/` root-import sigil + incomplete-state gate;
the `⟨Tool→result⟩` rendering notation; grok-build hashline anchor-editing; codex/opencode/claude
"code mode" (tools-as-JS-API); yq `match()` span primitive (directly relevant to the value-bracket
wire redesign per project memory); obsidian's deliberate anti-nesting Properties stance (a
considered *counter-position* to UDON's attribute-value-as-node ambition).

## 5. Dedup vs Grok's `MERGED-six-maps.md` (no flattening of restated-in-context)

Grok's merge and Fable's maps **overlap on purpose** and are complementary, not competitive:
- **Fable maps go deep** on the agentic-tooling *ideology + in-vivo + testimony + theory* (the four tiers). Grok's own §10 explicitly defers ideology depth to "Fable maps."
- **Grok's merge uniquely elevates** (keep — not covered at depth by Fable): the **Dec-2025 usability corpus** `test/usability/**` (topic_enablement / enablement / topic_dsl yamls — "what UDON is *for*"), the **`test/scenarios/**` day-in-the-life** situation scripts (product vocabulary: skeleton/at/diff/patch/CAS/append), the **conversion-matrix lineage** (2011→2026 xml/json/yaml/md↔udon converters), **live `.udon` consumers** (vivarium/asf/autopax/ordinum.rs hand-parser), and **historical objectives** (`_ref/udon/doc/objectives.asciidoc` utility-priority matrix). These are demand-side gold on the *UDON-usage* axis that the agentic-tooling sweep didn't target.
- **Verbatim-duplicate policy honored:** where a source appears in both (e.g. the sapientia/ennaos ideology roots — grok §10, Fable maps), this registry keeps *both pointers* because each frames it differently (grok = "center of mass + surprise" one-liners; Fable = vetted deep map). No restated-in-different-context material was flattened.
- **The two grok MERGED files:** `MERGED-six-maps.md` (six peer maps, no quarantine) is live at top level; `MERGED-grok-source-maps.md` (also unions quarantine) is archived under `../.archived/gathering-scratch-subsumed-2026-07-21/` — superseded, reference only.

## 6. Verify → copy-with-provenance → annotate — the prioritized queue

Joseph's intra-phase progression is: *potential source → verify relevant & not already
present (verbatim; restated-in-context is wanted) → copy file/span with provenance
frontmatter → annotate (categories + why-included banner)*. **Judgment call made:** the
maps are already vetted and grok already copied his slice (`extracts/`); the ripe next
step is a *clean prioritized queue*, not bulk copying — **what content to copy is best
driven by phase-(2) synthesis**, and pre-copying now risks premature steward calls. The
convergence strength in §4 *is* the priority ordering (copy the sources behind the
strongest, most tier-spanning convergences first).

**Copy-first (behind the strongest cross-tier convergences):**
1. The str_replace hard-refuse mechanism + its theory home (C8): `sapientia-bin` L2219–2240 span; dossier §2.4; the Architectus testimony span. *(A complete 4-tier worked example — ideal seed doc.)*
2. The edit-representation landscape (C1): `zoetica-ennaos` doc-02 span; `BUCKET-tier2-invivo` Part A+B (already a digest); the aider "abandoned tool-call editing" finding.
3. The κ×A bias law (singleton, theorem-grade, C1/C9 backbone): dossier §2.1.
4. Machine-first format re-derivations (C11): praxis-protocol; research-report-autodocs; MACH markdown-agents; sar "documentation IS the codebase."
5. Self-chunking empirical (C10): `ref-arch` sar3 `AST_VS_LSP_REALITY.md`; the counter-hypothesis CSV note.
6. Schema empirical (C9): `sources-schema-versioning` §2b yaml-spike FAILURE_MODES + adversarial findings.
7. The 60/30/6/4 + tools-as-truth-bearing + ease-gradient ideology trio (C4/C5/C6): QUICK-TOOLING-CONVENTIONS; THE-PATTERN; vision-agentic-toys.

**Copy-later (needs phase-2 to say if in scope):** grok's usability-corpus + scenarios
mines (§5); tracking-snapshot spec; paths spikes; live-consumer friction.

## 7. Open questions / steward calls (left for Joseph or Fable — not guessed)

- **Q1 — front-door reconciliation.** The brief said "update GATHERING-INDEX.md," but the
  only GATHERING-INDEX is grok's pass-scoped one inside `grok-early-pass/` (which I was
  asked not to modify). Resolution taken: **this MASTER-REGISTRY is the new front door**; I
  also wrote a thin top-level `GATHERING-INDEX.md` pointing here, and left grok's untouched.
  Confirm that's the intended shape, or say if you'd rather one merged file.
- **Q2 — copying stage scope.** I left a prioritized copy-queue (§6) rather than copying,
  reasoning that content selection is synthesis-driven. If you'd rather I begin copying the
  §6 "copy-first" set now (spans → provenance-framed files), say so — it's a clean next step.
- **Q3 — Tier-2 copying-vs-convergence.** The in-vivo digest flags that harness uniformity
  may be lineage/copying, not independent arrival (§0 caveat), and suggests a git/blog-history
  pass to disentangle before Tier-4 uses convergence counts as evidence. Worth a dedicated
  pass? (My recommendation: yes, but cheaply — it's a real epistemic risk to the strongest claims.)
- **Q4 — `sources-schema-versioning.md` re-vet.** It's flagged ⚠ (earlier bar), but on read
  it's genuinely rich and uniquely covers schema/versioning. I've registered it as trustworthy;
  flag if you want it formally re-vetted to the newer standard before phase 2 leans on it.
- **Q5 — residual gaps** (carried, not closed): `_ref/{principia,cddf,crew-first}` unsearched;
  a few unrun memorata3 phrasings; dossier pass-4 targets; grok §13 union-of-gaps (esp. the
  standing **Joseph end-user ideation dump** — primary when it lands, no path yet).

## 8. Working buckets (phase-2 aids; disposable)

Intermediate reconciliation buckets in `scratch/reconcile-workdir/`:
`BUCKET-convergences.md` (cross-tier), `BUCKET-inventory.md` (full artifact list),
`BUCKET-tier2-invivo.md` (17-harness digest). Kept as phase-2 aids; safe to delete once
this registry is consumed.
