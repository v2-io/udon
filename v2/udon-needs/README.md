# udon-needs — end-user needs → Parsing Framework

**What this directory is for.** End-user and agent-facing needs for UDON, and
the bridge from those needs to the architectural and syntactic decisions that
eventually become the **Parsing Framework** (what we used to call “the
pipeline” when we were arguing about stages first). The home for demand-side
work in the v2 effort; parent overview is [`../README.md`](../README.md).

**Deliberation record.** The conversation that reoriented this whole effort
lives next to the work:

- **[`pipeline-discussion.md`](pipeline-discussion.md)** — fold → accumulation
  list → demand-side inversion → night spine → archive → graduation → this
  flow. Section headings below point into it by line for the main turns.

---

## How we got here (history, not procedure)

UDON’s live authority remains `spec/CORE.md` (0.9-alpha) with a long CHANGELOG
of rulings. Greenfield clean-room rewrites (2a / 3a / 3b and pristine inputs)
explored how to re-specify the language; those trees now sit under
[`../.archived/first-pass/`](../.archived/INDEX.md).

In parallel, the 0.8/0.9 work had concentrated on a stable **event stream**
and a minimal text reconstruction (“the fold”) because that was the tactical
bottleneck. That was real progress — and it left a lot of “the host decides”
underspecified.

### The fold conversation

[`pipeline-discussion.md`](pipeline-discussion.md) opens mid-sitting on what
“fold” and “result channel” actually mean for fixtures and wire law
(Joseph ~L5–L7; Fable’s first definition ~L11–L39; diagram clarification
~L49–L94).

Joseph’s objection (~L98–L130) is the pivot: there isn’t one fold. A long list
of determinations need *different amounts of accumulation* after the wire —
ornamental blanks, text-block grouping, stacking, key integrity, mixins,
dialect check vs evaluate, schema, liquid early-check vs late process, and so
on. He also proposed a testable **ornamental** criterion (double round-trip
fixpoint: strip ornamental → model → house-style, then again, model and
bytes stable).

Fable and Grok then named a four-stage pipeline (Recognition / Assembly /
Resolution / Evaluation), generalized “result channel” to **verdict**, and
treated ornamental as the quotient between byte/recognition identity and
core semantic identity (~L134–L307). Useful vocabulary — and still mostly a
*supply-side* map of what recognition can and can’t know.

### Demand-side inversion

Joseph’s next turn (~L311–L343) listed what was still missing for confidence
in any pipeline architecture: **utility / user-directed needs**, **paths**,
**dialects** (selection, value types, directives, embeds), **schema** — so that
later SPEC, events, utilities, extension points, and parsers have something
real to serve. He asked for process lattice and milestones more than more
wire detail.

Fable named the inversion explicitly (~L347–L392): boundary *contents* are
pulled by callers (paths, dialects, schema, tools), not deduced from what a
recognizer can determine. Grok concurred and weighted paths as the long pole
(~L396–L485).

### The night spine and the morning correction

With process ownership, a Grok session built a large `v2-spec/` spine
(PROCESS, SPEC, WIRE, ADM, fixtures, spikes, …). Some of that was real:
thin DECISIONS/OPEN, agent-utility and paths demand spikes, holding multi-line
and exact wire encoding open. Much of it was **supply-side mass** under a
banner that stage *names* were “stable enough to use.”

Fable’s morning audit (~L494–L521): letter of the inversion partly honored;
balance inverted (dense spine, thin dialects/schema). Joseph’s follow-up
(~L525–L542) went further: the four-stage ontology itself is premature
hypothesis — counterexamples include in-vivo dialect sub-parsers, template
precompile → query-for-scope → build, schema-guarded agent edit (needs an
*inverse*), N-way round-trips, mid-stream reconfiguration, and the idea that
`[…]` (and friends) might be **sugar for dialect-typed capture**, which would
**dissolve** “multi-line policy” as a Core per-construct table rather than
settle it. Sampling list, not a hotlist: the point is that demand setups
reshape input/output needs into something more like a **DAG/DCG** of products
than a fixed line.

Archive and reseed (~L655–L726): clean-rooms and night spine →
`v2/.archived/`; DECISIONS + OPEN graduated without the R/A/R/E ontology;
needs-map skeleton; center of gravity → **this directory**.

---

## Demand-side flow (Joseph, ~L753–L776)

With room for overlap and breadth-first iteration (not a strict waterfall):

```text
(1) Gathering & Ideation
  ↳ (2) Additional Ideation, Consolidation, Normalization, & Synthesis
        (with delegated help / passes across multiple LLM substrates)
    ↳ (3) Utility / Capability Priorities (possibly with voting)
      ↳ (4) Decisions on {paths, dialects, schemas, embeds, misc spec}
        ↳ (5) Actual end-user Parsers / Utilities pipeline (possibly with voting)
          ↳ (6) Additional engine needs (e.g. round-trip fixed-point)
            ↳ (7) Decisions on pipeline / DAG / DCG architecture
              ↳ (8) “Pipeline” spec — more likely “Parsing Framework” when we get there
```

### Notes on that flow (Joseph; negotiable)

From the same turn — kept here as context for how (1)–(8) relate, not as a
separate process constitution:

- **Prediction / forward-looking.** Earlier steps are not forbidden to
  *mention* implications for later ones (e.g. “this would imply schema
  rejection at the streaming level…”). That is different from insisting on an
  implementation route or architecture, or from treating end-user need
  priority as if it were the same thing as backend-detail priority — those
  adjudications belong to the decision stages.
- **Parallel work.** Decision work especially often runs at several levels at
  once: upstream suggests; downstream decides with fuller context.
- **Downstream constraint.** Later stages aren’t “done” until they have what
  they need from upstream to adjudicate. Stated at full strength (ratified
  2026-07-21): **a later phase inherits its validity from the completed
  prior phase.** Synthesis over an incomplete gathering doesn’t produce a
  partial thesis — it produces a *confidently wrong* one, because the
  absence isn’t visible from downstream; no amount of later effort
  substitutes for a missing input (this is the sufficiency law, W0, wearing
  process clothes). Two corollaries for practice: (a) value-judgments like
  “weak signal, skip it” exercised during gathering are a later phase’s
  judgment being spent early — during (1), the bar is the vision question,
  not anticipated synthesis-worth (the SC#7 overrule is the canonical
  incident); (b) before a phase is declared complete, probe it with
  **question-shaped audits** (e.g. the `memorata3 "use udon for"` coverage
  audit) from a few independent angles — completeness can’t be proven, but
  “the obvious things are done” can be checked rather than assumed.
- **Non-permanent.** Right shape *for now*; likely simplifies once a v2 core
  already covers a large share of needed functionality.
- **Future-proofing.** Downstream may synthesize lower-priority needs via
  architecture when easy. Priorities are more a mandate about what matters
  most for release than a ban on providing for known or unknown futures —
  *unless* doing so would significantly impede the important capabilities.
  Foreclosing a future UDON capability should only be because something
  better required it; agentic coding at speed favors thoughtful architecture
  whose assumptions and prior reasoning are well preserved so reorganization
  stays possible.

---

## Layout

| Path | Role |
|------|------|
| [`pipeline-discussion.md`](pipeline-discussion.md) | Full deliberation record (primary historical source) |
| [`01-ideation/`](01-ideation/) | Scratch staging for (1): usage scenarios, agentic/utility ideas, library-consumer situations, mined snippets — any phase |
| [`01-ideation/needs-map.md`](01-ideation/needs-map.md) | Early gathered seed (situations visible from the discussion at reseed); one input among many for (2), not a mandate |

Phase (2)’s main synthesis document will likely be some modification of that
needs-map (or a sibling); exact shape is still open.

### Provenance on gathered material

Joseph’s interest for (1): each item should be able to show **provenance as
description** and **provenance as actual files** (the same idea often appears
in several places). That may become a column or field in (2); for now it is
intake hygiene so synthesis can weigh sources.

Fable’s first try in this tree uses YAML frontmatter on gathered files, e.g.
on `needs-map.md`:

```yaml
source: …          # descriptive origin
gathered: YYYY-MM-DD
status: gathered source material — NOT an authoritative decision document.
```

Later items may also list concrete paths (discussion lines, design docs,
`~/src/…` snippets, memorata hits, session vaults). Same need; format can
evolve — do not treat the first frontmatter shape as frozen schema.

---

## Known source piles for (1) (none fully mined)

From Joseph (~L779–L790) and the discussion’s own residue:

- The needs-map seed (and any less-prescriptive rewrites of it)
- Brainstorms already in [`pipeline-discussion.md`](pipeline-discussion.md)
  (accumulation list ~L101–L118; utility/paths/dialects/schema list ~L311–L332;
  morning sampling of demand counterexamples ~L527–L542)
- Sapientia-era agentic tooling ideology and e.g. cli-conventions (Joseph
  consolidating toward something like `~/src/archema-io/harness/agentic-tooling/`)
- autopax / rowan / operata ideas on schema versioning and checking
- Past UDON survey and ideation in this repo’s history
- Many past Claude/Grok discussions in udon and related projects (including
  old udon-c), often via `memorata3-search`
- Usage snippets across `~/src/`
- Grok workspace memory search (`~/.grok/memory/…`)
- Archived spikes: `../.archived/second-pass/spikes/{paths,agent-utility}/NOTES.md`
  (demand tables §8; agent-utility harvest §9)
- Live lanes / design: `ux/TODO-AGENT-UX.md`, utils/human-ux TODOs,
  `design/agentic-ux-principles.md`, `design/udon-agentic.md`, ACP-format
  notes, guarantees, etc. (shape, not current CORE law)
- And more as they turn up

---

## Related (outside this directory)

| Path | Role |
|------|------|
| [`../DECISIONS.md`](../DECISIONS.md) | Thin present-truth language ledger (graduated; independent of archived stage ontology) |
| [`../OPEN.md`](../OPEN.md) | Live questions (incl. ML reframed as possibly dissolved) |
| [`../.archived/INDEX.md`](../.archived/INDEX.md) | What was archived, value vs mistake residue, cherry-pick hints |
| `../../spec/CORE.md` + `../../spec/msc/CHANGELOG.md` | Live 0.9 oracle / rulings until cutover |
| `../../core/` | Differential parser oracle |

---

## Pointers into the discussion (main turns)

| Topic | Approx. lines in [`pipeline-discussion.md`](pipeline-discussion.md) |
|-------|---------------------------------------------------------------------|
| Fold definition / C5–C6 | ~L5–L94 |
| Joseph accumulation list + ornamental fixpoint | ~L98–L130 |
| Fable stages + verdict + ornamental sharpenings | ~L134–L161 |
| Grok on fold / stages / ornamental | ~L164–L307 |
| Joseph “what we are missing” + process goals | ~L311–L343 |
| Fable demand-side inversion + milestones | ~L347–L392 |
| Grok lattice + milestones | ~L396–L485 |
| Fable night-spine audit (letter vs mass) | ~L494–L521 |
| Joseph counterexamples + DAG/DCG + array-as-sugar / ML dissolve | ~L525–L542 |
| Fable: product graph, ML open, needs map charter | ~L546–L568 |
| Grok independent morning judgment | ~L572–L651 |
| Joseph archive plan | ~L655–L686 |
| Grok archive + cherry-pick stance | ~L691–L709 |
| Fable graduation + PROCESS keep-list (provisional) | ~L713–L746 |
| **Joseph demand-side flow + notes + udon-needs** | **~L750–L795** |

Line numbers drift if the file is edited; search section headings (`## Joseph`,
`## Fable`, `## Grok`) when in doubt.
