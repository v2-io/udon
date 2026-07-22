---
slug: progressive-disclosure-read-path
type: demand
evidence: [T1, T2]
status: estate-convergent (T1 design-of-record) with T2 context-economy echo
stage: drafted
consumers: both
depends: [addressing-is-the-long-pole, context-economy]
sources:
  - ../../01-ideation/02-provenanced/commentary/spikes/agent-utility-NOTES.md  # §2 payload table
  - ../../01-ideation/02-provenanced/copies/I3-design-of-record/udon-agentic-body.md  # read whole
  - ../../01-ideation/02-provenanced/syntheses/tier2-invivo-digest.md  # C11
---

# The read path: glance → focus, and payloads that answer "where am I?"

**Claim.** The read side of agent-document interaction has a converged
shape in the design corpus: **progressive disclosure** — a cheap structural
glance first (skeleton, counts, paths), then focused descent on demand —
with every payload carrying the orientation data an agent needs to act
without re-reading the file: copy-pasteable paths, breadcrumbs, line
numbers, and explicit confidence.

## The evidence

- **T1 (design of record, read whole):** the udon-agentic tool catalog is
  the fullest statement of what read-side payloads must carry, and its
  conventions section is quietly the most transferable part: **line
  numbers always** ("enables agents to correlate across calls"),
  **breadcrumbs with line numbers at each level**, **summaries as counts
  in parentheses**, **explicit confidence indicators** ('high'/'medium'/
  'low' with explanation when not high), and an error format that is
  error-as-menu (`:suggestions` carrying resolvable paths with line
  numbers). Its `session` tool is progressive disclosure made stateful —
  current location, expanded/collapsed state, staged changes, navigation
  history — "dramatically reduces context usage for multi-step work." Its
  `trace` tool (what references this / what does this reference, with
  locations) is the impact-analysis half: read-before-write due diligence
  as a first-class query.
- **T1 (the spike's payload table):** skeleton/path-map (multiplicities,
  attribute names without bodies), focused subtree + breadcrumb (where am
  I, siblings summary, refs in/out), structural diff (move vs delete+add),
  impact/side-effects (broken refs), validation verdict, confidence,
  teaching refusal — one row per payload, each answering a different
  question an agent actually asks mid-task.
- **T2 (the echo):** the ecosystem's context-management machinery
  (#context-economy) is progressive disclosure applied *to tool results* —
  previews with disk-spill recovery paths, content-aware pruning against a
  focus question. What no shipping harness has is the *structural* glance:
  their skeletons are file trees and grep hits, not document shapes. The
  gap is the same one as editing: text-level tools over structured
  documents.

## What it generates

- **For UDON:** glance/skeleton is the second-cheapest high-value utility
  after validation (it needs only the assembly product + paths), and
  skeleton lines doubling as valid paths is the design decision that makes
  the whole read-write loop compose: what you see is what you can address
  is what you can edit. The DL-budget frame prices it: a glance that costs
  200 tokens instead of a 5,000-token full read is a strategy-complexity
  subsidy (#context-economy).
- **For the harness:** the payload conventions (paths, breadcrumbs,
  counts, confidence, menu-shaped errors) transfer to *any* tool output
  regardless of notation — they are the read-side half of
  #errors-that-teach, and several (line numbers, previews) are already
  ecosystem floor.

## Honest edges

All shape, no measurements: nobody has measured glance-vs-full-read
context savings or task-success deltas on real agent workloads (the
December usability corpus predates these designs and is stale). The
catalog's session tool assumes single-agent use — its staged-changes model
meets #freshness-and-atomicity's multi-writer reality only via the
re-resolve-at-commit rule, which the design states but no code enforces
yet.
