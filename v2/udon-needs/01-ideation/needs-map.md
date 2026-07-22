---
source: Fable session 2026-07-21 (morning-after review of the v2-spec night; seeded from pipeline-discussion turns)
gathered: 2026-07-21
status: gathered source material — NOT an authoritative decision document.
  One input among many for phase (2) synthesis. The "row shape" below is a
  candidate *shape* for phase (2)'s deliverable (or an intermediate), offered
  as an idea, not a mandate.
---

# Input/Output Needs Map — gathered seed

**Posture (phase 1 — gathering):** wide open. Add situations freely — bad ideas, duplicates, half-thoughts, 15-year-old udon-c notions all welcome; tag each with its source so synthesis can weigh provenance. The old guardrail this file carried ("do not flesh out from supply-side imagination") applies to *synthesis and decision* phases, not here — filtering at intake is the one mistake gathering can make.

**Where this came from:** the situations below are the ones visible from [pipeline-discussion.md](../pipeline-discussion.md) (the 2026-07-21 morning turns) at the moment v2 was reseeded. They are seeds, not an enumeration.

## Candidate row shape (an idea for phase (2)'s deliverable)

Each situation might eventually carry:

- **Who / when** — the actor and the real moment (agent mid-edit, CI gate, human in Obsidian, …)
- **Consumes** — what inputs, in what form, with what already resolved
- **Produces** — what outputs, and what the consumer does next with them
- **Timing shape** — one-shot / chunky-streaming / unbounded stream / interrogated product (e.g. precompiled template queried for its scope shape)
- **Mid-stream reconfiguration?** — can dialects/schema change while consuming?
- **What it demands of products** — the boundary-contract pulls (the payload facts a pre-drawn pipeline can't guess)

## Gathered situations (seeds — add freely)

| # | Situation | Seed pointers |
|---|-----------|---------------|
| S1 | Agent edit under schema guard — jq/yq-like span-sensitive mutation, indent-free authoring of prose/raw blocks, mutation rejected if it would violate schema | discussion ~537 |
| S2 | Unbounded stream consumer — events, no accumulation; expects typed values already processed? badly-typed value behavior? | discussion ~535–536 |
| S3 | Chunky streaming consumer — bounded accumulation (ADR-style), subtrees shipped as they close | discussion ~536 |
| S4 | Template precompile → interrogate scope shape → build — scope-context often UDON itself → directives converge on paths | discussion ~532, 564, 608 |
| S5 | Markdown processing — the several distinct user-side situations it implies (render, convert, author-in-md, …; enumerate before designing) | discussion ~528 |
| S6 | Round-trips — house-style fixpoint + json / toml / yaml / markdown / rust-native targets; each direction's loss policy | discussion ~529 |
| S7 | Dialect definition & use — define / compile / validate / declare / invoke; in-vivo sub-parsers (`&lt;` → e.g. existing descent timespec grammar); ordering & override rules | discussion ~530–534 |
| S8 | Schema definition & use — composable/nested? static? conformance & linting tools | discussion ~536–538 |
| S9 | Config load — the plain "parse my config, give me values" case (types resolved, errors surfaced how?) | — |
| S10 | Memory / corpus import — documents as agent memory substrate; self-chunking for retrieval | README self-chunking §; agent-utility spike (archived) |
| S11 | Syntax highlighting / editor UX — event-driven, resumable, partial-input tolerant | ux/ (live), archived HUMAN-UX lane |
| S12 | Mid-stream reconfiguration across any of the above — "now this dialect rules" | discussion ~535 |

## Known harvest sources (standing queue — none fully mined)

- Joseph's end-user input + ideation dump (incoming — primary)
- Archived spikes: `../../.archived/second-pass/spikes/{paths,agent-utility}/NOTES.md` §8 demand tables (re-read paths under the S4 template/paths pull — discussion ~608)
- `ux/TODO-AGENT-UX.md`, `TODO-UTILS.md` wishlists (live repo)
- December usability corpus (`test/usability/`, stale but evidence)
- Sapientia-era agentic-tooling ideology; `sapientia/cli-conventions/**` (Joseph consolidating into `~/src/archema-io/harness/agentic-tooling/`)
- autopax / rowan / operata schema-versioning & checking ideas
- Past udon survey ideation in this repo's history; udon-c-era discussions (`memorata3-search` etc.)
- Usage snippets across `~/src/`; grok's memory search
