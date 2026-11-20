---
source: lineage-disentangle pass over the 17 harness-invivo repos (git histories, in-repo attributions, README fork statements, vendored subtrees, citation URLs)
gathered: 2026-07-21
status: synthesis — verdicts confidence-tiered (established / probable / unknown); an honest "unknown" is preferred to a manufactured tree
paths:
  - 02-provenanced/characterizations/harness-invivo/*.md   # the maps whose counts this reweights
  - 02-provenanced/syntheses/tier2-invivo-digest.md         # the C1–C16 within-Tier-2 clusters
  - 02-provenanced/syntheses/CONVERGENCES.md                # the Tier-2 caveat this resolves
  # repos examined (external; HEAD SHA at examination = source_commit):
  - ~/src-ext/aider @ 5dc9490b
  - ~/src-ext/codex @ 0fb559f0f
  - ~/src-ext/grok-build @ 7cfcb20
  - ~/src-ext/kilocode @ 938919ab72
  - ~/src-ext/opencode @ f5573281c
  - ~/src-ext/qwen-code @ 68b4440f9
  - ~/src-ext/warp @ 37c26a8b
  - ~/src-ext/minimax-cli @ 3615170
  - ~/src-ext/mistral-vibe @ 0685654
  - ~/src-ext/kimi-code @ a41a09c3
  - ~/src/_ref/gemini-cli @ 2515b89e2
  - ~/src/_ref/claude-code-snapshot @ d7de150
categories: [tier-2, lineage, provenance, evidence-weighting, edit-formats, tool-schemas]
why_included: >
  Resolves CONVERGENCES.md's load-bearing Tier-2 caveat — separates copying/lineage
  from independent arrival so phase-2 synthesis doesn't count one influential design
  as N independent votes. Bottom line: three shipping "convergences" collapse to a
  single origin each (apply_patch → OpenAI; the opencode-family clusters → one fork;
  the gemini-family clusters → one fork), and the ecosystem-wide str_replace/todo/
  ask-user uniformity is convention-adoption of Claude Code, not independent invention.
  What survives reweighting is the cross-TIER triangulation and a genuinely-independent
  fuzzy-match-ladder convergence.
---

# Tier-2 lineage map — copying vs. independent arrival across the 17 harnesses

> **Who this is for and why.** Phase-2 synthesizers, before Tier-4 theory leans on "N harnesses agree" as evidence weight; and the harness programme, which cares about the lineage picture in its own right. The one-line takeaway: **the shipping uniformity is mostly one-design-adopted-widely, not many-teams-arriving- independently.** That does *not* zero out Tier-2's value — survivorship-by-adoption is still real evidence — but it changes the *kind* of claim the counts support (see "How to reread the counts" at the end).

## Confidence tiers used

- **ESTABLISHED** — documentary proof: identical root-commit hash, an explicit README/attribution fork statement, a vendored source subtree present in-repo, or a direct citation URL to the origin.
- **PROBABLE** — strong circumstantial: near-verbatim convention text across unrelated codebases with a known common influence, but no direct copy provable.
- **UNKNOWN** — couldn't be settled from the trees; stated as such.

---

## Part 1 — The family tree (established lineage nodes)

| Child | Parent / origin | Verdict | Evidence |
|---|---|---|---|
| **qwen-code** | **gemini-cli** (fork) | ESTABLISHED | qwen-code's root commit is *byte-identical* to gemini-cli's: `add233c5…` "Initial commit of Gemini Code CLI" (same SHA in both repos). README §157: "originally based on Google Gemini CLI v0.8.2 … Starting from Qwen Code v0.1, we stopped syncing with upstream." So: forked, then diverged. |
| **kilocode (Kilo CLI)** | **opencode** (fork) | ESTABLISHED | README L171: "Kilo CLI is a fork of [OpenCode]." In-repo: packages are literally scoped `@opencode-ai/core`, `@opencode-ai/effect-drizzle-sqlite`, …; there is a whole `packages/opencode/` subtree; its `tool/edit.ts` differs from real opencode's by only 65 of ~750 lines. *(Note: kilocode-the-VS-Code-extension is separately Roo/Cline lineage; the **CLI** surface that generates the C2/C3/C8/C12/C14 rows IS opencode.)* |
| **grok-build** | **codex** (vendored subtree) | ESTABLISHED | Literal vendored tree `crates/codegen/xai-grok-tools/src/implementations/codex/` containing `apply_patch/`, `read_file/`, `grep_files/`, `list_dir/`. grok-build ships its own novel work (hashline) *alongside* vendored codex tools — it is a vendor-plus-original, not a fork. |
| **apply_patch envelope** (the `*** Begin Patch` format) | **OpenAI** (codex / GPT-4.1 "apply patch" cookbook, Apr 2025) | ESTABLISHED | codex is the reference impl (`codex-rs/apply-patch/`, `prompt_with_apply_patch_instructions.md`). opencode's `apply_patch.txt` is the OpenAI envelope verbatim. warp cites the origin by URL in code: `https://cookbook.openai.com/examples/gpt4-1_prompting_guide#apply-patch` and names its type `V4AEdit`. grok-build vendors codex's. kilocode inherits it via opencode. |
| **str_replace / `text_editor` edit tool** | **Anthropic Claude Code** (`text_editor_20250728`) | PROBABLE (imitation, not code-copy — Anthropic's impl isn't open) | The name `text_editor_20250728`/`str_replace` originates in Anthropic's docs (present only in `claude-docs` and in warp's *bundled Anthropic skills*, nowhere as shared code). Multiple maps note "Claude-Code-style"/"mirrors Claude Code conventions" (grok-build, kilocode `anthropic.txt`, qwen-code, kimi-code, warp). Each harness reimplements its own str-replace (different code, different languages) — so this is **convention-imitation of one influential design**, not vendoring. |
| **ask-user "(Recommended)" convention** | **Anthropic Claude Code** `AskUserQuestion` (probable common ancestor) | PROBABLE | opencode `question.txt`: *"add '(Recommended)' at the end of the label"*; kimi-code `ask-user.md`: *"append '(Recommended)' to its label"* — near-verbatim across unrelated codebases. opencode↔kilocode share it by fork; opencode↔kimi share it as a Claude-Code-family convention, not a direct copy. |
| **`<state_snapshot>` compaction prompt** | gemini-cli → qwen-code (fork) | ESTABLISHED (as fork inheritance) | Both carry it at the same path `packages/core/src/core/prompts.ts`; qwen inherited it from the gemini-cli fork. The "two independent sources" reading in digest C11 is one source counted twice. |

**Genuinely independent origins (no fork/vendor lineage found):**

- **aider** — oldest repo in the set (Aider-AI/aider, history to Aug 2024). Its SEARCH/REPLACE block dialect and its per-model `edit_format` A/B-tuning table are its *own* early contribution, predating most of the ecosystem. The single strongest "independent arrival" node for edit-format-as-a-tunable-variable thinking. Its abandonment of tool-call-based editing (`RuntimeError("Deprecated")`) is independent primary evidence, not downstream of anyone.
- **gemini-cli** — Google first-party original; its LLM-as-repair-layer (`llm-edit-fixer.ts`) is unique and independent.
- **codex** — OpenAI first-party; the *origin* of apply_patch, not a copier.
- **claude-code** — the *origin/influence node* for str_replace, ask-user, todo, ToolSearch, subagent shapes; upstream of the copies, not a copier.
- **kimi-code** — own monorepo; adopts Claude-Code-family *conventions* (ask-user, todo) in independently-written code; its `ToolAccesses` declared-resource concurrency model is unique.
- **mistral-vibe** — own hexagonal-architecture build; no fork/vendor evidence; its numbered instruction-hierarchy is its own. str-replace is convention-adoption in independent code.
- **minimax-cli** — thin client, no edit tool at all; its reverse-direction schema export is unique. Independent.
- **warp** — own Rust harness; *adopts* OpenAI's V4A apply-patch (cited) but its 3-tier fuzzy matcher and the rest are its own.

---

## Part 2 — Cluster-by-cluster reweighting (digest C1–C16)

Reading key: **raw** = the vote-count the digest reports · **independent** = how many survive as separate arrivals after collapsing forks/vendored-copies/single-origin adoptions · **verdict** on what kind of evidence it is.

| Digest cluster | Raw | Independent | Lineage verdict |
|---|---|---|---|
| **C1 str-replace default** | 11/14 | ~2–3 origins, N adopters | **Convention-adoption of Claude Code**, not independent invention. aider's SEARCH/REPLACE is the one clearly-independent alternate origin. Reread as survivorship (below), not as 11 votes. |
| **C2 fuzzy-match ladder** | ~8 | **~5–6 (survives)** | kilocode=opencode (fork → 1), gemini=qwen (fork → 1). Genuinely independent ladders remain: aider, gemini-cli, warp, grok-build, claude-code, +mistral's strict variant. Different code, different languages, same graduated-tolerance shape → **this is the one cluster that survives as genuine independent convergence.** The *problem* (raw LLM `old_string` is almost-but-not-byte-exact) was hit independently; the *solution shape* recurs. |
| **C2b LLM-as-repair-layer** | 1 (gemini-cli) | 1 | Singleton; unaffected. Inherited by qwen (fork) — still one origin. |
| **C3 apply_patch envelope** | 5 | **1 origin (OpenAI), 0 independent** | **Collapses hardest.** codex=origin; opencode adopts verbatim; kilocode=opencode; grok-build vendors codex; warp cites the cookbook. Five "votes" = one reference format adopted. **Not** evidence agents independently need this envelope. |
| **C4 model-conditional routing** | 5 | ~4 | aider's per-model table is independent and primary; opencode's `usePatch=gpt-*` routing is inherited by kilocode (fork → 1). Meta-pattern still broadly independent. |
| **C5 "prefer dedicated tool over shell" microcopy** | 7 | ~4–5 | Near-verbatim text; opencode=kilocode (fork). Strong *convention* spread (Claude-Code-family), partly independent restatement. |
| **C6 read-before-edit gate** | 8+ | ~6 | opencode=kilocode, gemini=qwen collapse. Still broadly independent as an enforced invariant; qwen-code's dedicated `priorReadEnforcement.ts` is its own hardening. |
| **C7 deferred tool loading** | 5 | ~3 | claude-code is origin; qwen-code map *explicitly notes mirroring the harness doing this sweep* (Claude Code ToolSearch); qwen also inherits infra from gemini fork. codex and kimi-code are more plausibly independent. Partial lineage. |
| **C8 disk-spill-with-preview** | 5 | 4 | opencode=kilocode share *identical 2000-line/50KB thresholds* — that's the fork, not agreement (1 not 2). claude-code, kimi, codex independent. |
| **C9 structured-output contract** | 8 | ~7 | Mostly independent; the real split (constrained decoding vs after-the-fact JSON) the digest already flags is orthogonal to lineage. |
| **C10 streaming tool-call reassembly** | 5 | ~4–5 | Largely independent (forced by each provider's wire format); gemini/qwen partial overlap. Genuine shared *problem*. |
| **C11 context-mgmt around tool results** | 6 | ~5 | gemini `<state_snapshot>` = qwen `<state_snapshot>` is fork inheritance (1 not 2); rest independent with real technique diversity. |
| **C12 ask-user "(Recommended)"** | 6 | ~2–3 | opencode=kilocode (fork); opencode↔kimi = Claude-Code-family convention. The recurring "(Recommended)" + 1-4Q/2-4-options shape is **one convention adopted**, not six inventions. Digest already suspected "downstream of the same original." |
| **C13 subagent-as-tool** | 9 | ~6 | opencode=kilocode, gemini=qwen collapse; "brief it like a colleague" text recurs verbatim (kimi, kilocode) = convention spread. Read-only-by-tool-omission is a genuinely independent *technique* seen in ≥3. |
| **C14 todo tool** | 8 | ~2–3 origins | **"most uniform micro-convention" = strongest COPY signal, weakest independent-arrival.** Near-word-for-word rules (one `in_progress`, never-done-if-red) across teams ⇒ Claude-Code TodoWrite convention adopted wholesale. opencode=kilocode fork. |
| **C15 AGENTS.md scoping** | 6 | ~4 | grok-build vendors codex's `agents_md` prompt (codex+grok → 1). Directory-tree nearest-wins model otherwise independently adopted. kimi-code's "untrusted data" stance is a genuine *divergence* (real signal, unaffected by lineage). |
| **C16 headless/agent-mode I/O contract** | 14 | broadly independent | Each harness's CLI/TTY-detection is independently built to the same forced constraint (machine caller needs clean JSON + exit codes). **Survives** as genuine — this is convergence under a hard external constraint, not copying. |

---

## Part 3 — Effect on the cross-TIER clusters (CONVERGENCES.md #1–18)

**Key point for phase-2: the lineage caveat mostly does *not* threaten the cross-tier clusters — it threatens the within-Tier-2 vote-counts.** The cross-tier clusters (#1–18 in CONVERGENCES.md) triangulate across tiers whose failure modes are *independent* (ideology can be aspirational; shipped practice can be lineage; testimony can be n-of-few; theory can have an abstraction gap). Lineage only compromises the *Tier-2 leg*. Where a cluster stands on ≥2 tiers, discounting the Tier-2 leg to "one influential design" still leaves the triangulation intact.

Concretely:

- **#1 edit-representation landscape / "no validity guarantees"** — its Tier-2 leg is exactly the C1/C3 material that collapses. But it also stands on zoetica (ideology), Architectus testimony (Tier-3), and dossier §2.4/§6 (theory). **The cross-tier claim survives; drop the "many harnesses independently agree" framing and keep "the whole shipping ecosystem edits at text/char level with no validity guarantee" — which is true precisely *because* they share lineage.** The uniformity is real; its cause is common-descent, and that's arguably a *stronger* statement of the gap UDON targets.
- **#8 str_replace multi-match HARD-REFUSE** — the "4-tier lock" is its strength: built (sapientia) + theorized (dossier §2.4) + shown-failing (Architectus) are the independent legs. The Tier-2 leg (that shipping tools refuse multi-match) is Claude-Code-convention-adopted, but the *other three legs are independent* — so this remains the best worked example. Just don't add "and N harnesses independently invented it."
- **#17 tool-definition anatomy** and **#18 agent-mode auto-detection** — #18's Tier-2 leg (C16) survives as genuine independent convergence (hard external constraint); #17 is partly convention-spread but multiply-tiered.

**Net:** no cross-tier cluster needs to be *dropped*; several need their prose changed from "independently converged across N harnesses" to "uniform across the shipping ecosystem (largely by common descent from Claude Code / OpenAI reference designs)." The uniformity-by-descent is itself a finding worth stating plainly.

---

## Part 4 — How to reread the Tier-2 counts (the practical rule for phase-2)

1. **Never cite a raw harness-count as "N independent votes" for these clusters:** C1 (str-replace), C3 (apply_patch), C12 (ask-user), C14 (todo), C15 (AGENTS.md). These are *one design adopted*, not many arrivals. For C3 in particular, the honest count of independent arrivals is **one** (OpenAI).
2. **Collapse these fork pairs to one wherever they co-occur in a count:** `kilocode ≡ opencode` (Kilo CLI is an opencode fork) and `qwen-code ≡ gemini-cli` (fork, pre-divergence infrastructure). grok-build's codex-derived tools are `≡ codex`.
3. **Two clusters survive as genuine independent convergence — lean on these:** **C2** (the graduated fuzzy-match ladder — independently reinvented against the same empirical fact that LLM `old_string` is almost-but-not-byte-exact) and **C16** (headless I/O contract — independently built against a hard external constraint). These are "many teams hit the same wall and built the same shape" — the evidence type the caveat was worried about losing, here genuinely present.
4. **The most-uniform clusters are the most-copied, not the most-needed.** C14 (todo) being "near word-for-word across teams" is a *tell of copying*, not of deep need. Invert the intuition: suspiciously-verbatim uniformity ⇒ lineage; independent arrivals show *shape*-convergence with *implementation* divergence (that's C2).
5. **Uniformity-by-descent is still a real finding** — "the entire shipping ecosystem edits at text/char level with no formal validity guarantee, because they all descend from two reference designs that made that choice" is a legitimate and arguably *sharper* statement of the gap than "N teams independently chose it." Use that framing; don't silently inflate it into independent corroboration.

---

## Method / evidence log

**Approach.** For each of the 17 repos: `git remote -v`, root-commit and HEAD (`git log --reverse`), README/attribution grep for fork/vendor statements, in-repo grep for the origin's names/subtrees, and direct diff where a fork was suspected. Web search was available but **not needed** — every verdict above is settled from the trees, in-repo attributions, and citation URLs already committed in the code.

**Established-tier evidence (documentary):**
- qwen-code ⟵ gemini-cli: identical root SHA `add233c5043264d47ecc6d3339a383f41a241ae8` in both repos; qwen README §157.
- kilocode-CLI ⟵ opencode: kilocode README L171; `@opencode-ai/*` package scopes; `packages/opencode/` subtree; `edit.ts` 65/750-line diff.
- grok-build vendors codex: `crates/codegen/xai-grok-tools/src/implementations/codex/…` subtree (apply_patch, read_file, grep_files, list_dir).
- apply_patch ⟵ OpenAI: opencode `apply_patch.txt` = OpenAI envelope verbatim; warp `crates/ai/src/diff_validation/mod.rs:30` cites the cookbook URL; codex `codex-rs/apply-patch/` reference impl.

**Probable-tier (convention-imitation, no code-copy provable):**
- str_replace/`text_editor` naming confined to `claude-docs` + warp's *bundled Anthropic skills*; every harness's str-replace is independently-written code → imitation of Claude Code's design, not vendoring.
- ask-user "(Recommended)" near-verbatim across opencode + kimi-code (unrelated codebases, different languages) → common Claude-Code ancestor, not direct copy.

**Genuinely independent (no lineage found):** aider (own SEARCH/REPLACE, 2024 origin), gemini-cli (Google original), codex (OpenAI original), claude-code (the influence node), kimi-code, mistral-vibe, minimax-cli, warp (own harness, adopts one cited format).

**Unknowns / not chased (honest gaps):**
- The *timing* of who-adopted-str_replace-first among the non-Anthropic harnesses isn't pinned — the origin (Claude Code) is clear, the adoption order isn't, and it doesn't change the weighting. Left UNKNOWN.
- Whether kimi-code's deferred-tool-loading (C7) is truly independent of Claude Code's ToolSearch or a convention-adoption — its code is independent but the idea's provenance isn't provable from the tree. Marked PROBABLE-partial, not established.
- `warp`'s actual JSON tool schemas live in an external unvendored proto (dry well by design per its map) — lineage of its *schemas* (vs its cited V4A format) is UNKNOWN.
- obsidian-help/obsidian-linter/yq are prior-art, not harnesses; excluded from the copying analysis (they share no lineage with the agent-harness set).

**Repos examined at the SHAs in frontmatter `paths:`.** Fork/vendor findings are stable against those pins; live repos may advance.

*— lineage-disentangle pass, 2026-07-21.*
