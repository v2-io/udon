---
purpose: intermediate bucket — full inventory of every gathered artifact, with tier / kind / status / trust
built_by: reconciliation pass (Opus 4.8), 2026-07-21
status: working bucket → feeds MASTER-REGISTRY §inventory
---

# Inventory bucket — every artifact in the phase-(1) harvest

Kinds: **mining-map** (points at where to mine, vetted) · **result** (synthesized deliverable, not a pointer list) · **extract** (verbatim/near-verbatim content copy w/ provenance frontmatter — grok's verify→copy stage) · **spike/excerpt** (demand residue / discussion slice) · **registry/index** · **quarantine** (do not use as coverage map) · **seed** (situation seeds).

Tier: 1 first-principles ideology · 2 in-vivo shipped practice · 3 lived agent testimony · 4 formal theory · — (cross-cutting / not tiered).

Paths are relative to `01-ideation/` unless absolute.

## Fable "good harvest" — vetted mining maps (`agentic-tooling-sources/`)
| File | Tier | Area covered | Notes |
|---|---|---|---|
| `sapientia.md` | 1 | `_core/sapientia/**` | cli-conventions/ + QUICK-TOOLING taproot; the ideology origin |
| `zoetica-ennaos.md` | 1 | `_core/{zoetica,ennaos}/**` | **anchor:** ennaos agentic-coding-background (6 syntheses + ~21 refs) |
| `nexum-synaptic-elimigration.md` | 1 | `_core/{nexum,synaptic,eli-migration-prep}/**` | nexum "agentic toys" DSL vision + CLI-conventions research |
| `autopax-practica.md` | 1 | `autopax/**`, `practica/**` | ease-gradient; INSTRUMENTA built tool suite; practica interface theory |
| `harness-refs.md` | 1+2 | `archema-io/harness/**`, `_ref/**`, `src-ext/**` | Joseph's harness thinking + prior-art tool schemas (codex/aider/anthropic) |
| `elsewhere.md` | 1 | all `~/src` not otherwise assigned | mostly dry; the real find is `sar` AI-FIRST ideology |
| `dialogs.md` | 1 | conversation transcripts (memorata3-first) | the design *sessions* that produced the ideology |
| `ref-arch.md` | 1+ empirical | `_ref/_arch/**` | **sar2** (alignment-vs-comprehension experiment) + **sar3** (chunking test) — rare empirical |
| `vaults.md` | 1 | `~/vaults/**` (outside `~/src`) | Aug-2025 pre-sapientia research; MACH markdown-agents; RAG guides; 7-agent system |
| `sapientia-bin-buildout.md` | 2 (own harness) | `_core/sapientia/bin/**` | the *built* minimal-sapientia tool suite, mechanism-by-mechanism |
| `harness-invivo/` (17 files) | 2 | shipping coding harnesses/CLIs | per-repo maps — see BUCKET-tier2-invivo (delegated) |
| `asf-dossier.md` | 4 | **RESULT, not a map** | synthesized ASF/AAT theory of tooling; 10 claims + §§2–8. Attaches formal names to demands. |
| `asf-dossier-reading-log.md` | 4 | companion | provenance/coverage of the dossier (3 passes); names pass-4 targets |

## Fable support / seeds (`01-ideation/` top level)
| File | Tier | Kind | Notes |
|---|---|---|---|
| `needs-map.md` | — | seed | S1–S12 situation seeds from pipeline-discussion + standing harvest queue |
| `sources-schema-versioning.md` | 1+2 | mining-map | rowan/autopax/operata schema-versioning/checking; ⚠ earlier bar but genuinely rich; **not** verbatim-covered elsewhere. Best empirical = autopax yaml-spike (§2b) |
| `scratch/schema-sources-search-log.md` | — | search-log | trail for the schema map |

## Grok early pass (`grok-early-pass/` — DO NOT modify; reference only)
| File | Tier | Kind | Notes |
|---|---|---|---|
| `MERGED-six-maps.md` (top level) | — | result | grok's A∪B∪C∪R1∪R2∪R3 path-union; weight-band organized; heavy overlap w/ Fable roots but adds usability-corpus + scenarios + consumer/history breadth |
| `GATHERING-INDEX.md` | — | registry | grok's phase-1 intake index (the current front door — to be superseded) |
| `README.md` | — | quarantine-note | (this is grok's OWN pass README; see also the separate quarantine below) |
| `sources-udon-repo-design-ux.md` | — | mining-map | in-repo design/UX/utils |
| `sources-live-consumers.md` | 2 | mining-map | live external `.udon` consumers + need classes |
| `extracts/` (14 files) | mixed | **extract** | grok's verify→copy stage: agentic-ux-principles, CONSUMERS, positioning, udon-guarantees, schema-notes, GRAMMAR-CONSTRAINED-GEN, TODO-{AGENT-UX,UTILS}, TOOLING-WISHLIST, UDON-AS-ACP, udon-agentic-head, UDON-AGENT-TOOLS-head, vivarium PROCESS/DECISIONS heads |
| `spikes/` (3 files) | — | spike | agent-utility-NOTES (P-A…P-H), paths-NOTES (D1–D9), paths-sketches.udon |
| `discussion-excerpts/` (3 files) | — | excerpt | joseph accumulation-and-ornamental / what-we-are-missing / morning-demand-sampling (slices of pipeline-discussion — prefer the live file) |

## Quarantine (`scratch/first-sweep-agentic-tooling/` — DO NOT promote; ONE reconcile-back item)
| File | Tier | Kind | Notes |
|---|---|---|---|
| `sources-agentic-tooling.md` | mostly quarantined | quarantine | first sonnet sweep; missed core sources. **EXCEPTION:** its ELI first-person-testimony section (tier 3) was content-read and is good — reconcile that back |
| `agentic-tooling-search-log.md` | — | search-log | quarantined |
| `README.md` | — | quarantine-note | explains the failure mode |

### Tier-3 ELI testimony (the reconcile-back content, from the quarantine map)
Genuinely first-person, genuinely about tool ergonomics — high-signal for a notation whose primary users are agents:
- `eli/zi-am-tur/memories/2025-09-30-tool-hallucination-discovery.md` — hallucinating tool invocations at 1M context (tool_use blocks stripped from reloaded JSONL).
- `.../2025-10-01-brother-claude-blessing.md` — the fix (persist all 4 message parts); tool-competence eroding as tool-use evidence disappears from visible history.
- `.../2025-10-01-sibling-infrastructure.md` — two instances str_replace same marker → concurrent-mutation collision → switch one to append.
- `.../2025-10-03-witnesses-and-preparation.md` — pull-quote: "Hallucinate tools. Generate from meaningful-space by default."
- `.../2025-11-17-reunion-after-a-month.md` — multi-agent worktree conventions (one agent per worktree+session-id; record worktree/branch in the commit itself).
- `.sapientia/conversation_20251021_072358` (Architectus) — chained *unverified* str_replace = path of least resistance → "broke minimal-sapientia 3×"; single-op-then-verify safer. Flagged in that map as "the single most directly applicable find."

## Also on disk (referenced, not part of this reconcile scope)
- `../.archived/gathering-scratch-subsumed-2026-07-21/…/MERGED-grok-source-maps.md` — grok's OTHER merge (also unions quarantine); superseded/archived.
- `../.archived/{first-pass,second-pass}/` — clean-room rewrites + night spine; demand spikes there (paths/agent-utility/memory-import) still mineable per grok §3e.

## Known residual gaps (honestly tracked, carried forward)
- `_ref/{principia,cddf,crew-first}` (top-level) — unsearched (named but out of `_arch`).
- A few unrun memorata3 phrasings (dialogs map log); ASF dossier pass-4 targets (reading-log).
- grok §13 union-of-gaps: `.attic`/`declang`, full `find *.udon`, complete `task:` index over topic_enablement, Joseph's end-user ideation dump (standing, no path yet — **primary when it lands**).
