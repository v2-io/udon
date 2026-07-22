# Notes for the OUTLINE (cycle 1, pilot A — Intro + Part I opening four)

*The workflow asks outline-evolution proposals as an expected output, and a
cycle that leaves the outline unchanged owes a justification. Here is both:
what I looked at, what held, and the one structural pressure I did surface.*

## Did the structure hold in my division? Mostly yes — one real pressure.

My four chapters (methods, counter-register, observation-infrastructure,
errors-that-teach) sit in a tight, correct dependency order:
methods → {counter-register, observation-infrastructure} → errors-that-teach.
The recalibration I did this cycle *confirmed* one adjacency rather than
disturbing it: the counter-register turns out to be a direct **instance of the
methods discipline** — its whole job is strength-*capping* theses, which is the
claim-level-strength machinery applied. Its placement immediately after methods
is discovered-correct, not merely inherited. No reorder proposed there.

## The one structural pressure I want to surface (PROPOSED, not pinned)

**The methods chapter is carrying two distinct jobs and is overloaded.** It is
simultaneously (a) *the evidence-and-register discipline* (the three axes, the
strength ladder, the strengthen-before-soften stance) and (b) *the report's
convention registry* — it is where the `[!capability]` card template is
defined, where the frontmatter field schema is specified, where the notation
conventions live. Every chapter reaches back to it for the card template
specifically, but that template is buried mid-paragraph in a chapter whose
front half is about epistemology.

Proposal to consider (downstream decides): split the **convention registry**
(card template + frontmatter-field schema + the notation/apparatus conventions)
into its own short chapter or a promoted `CONVENTIONS.md` the way `NOTATION-KEY.md`
already is apparatus. That would let the methods chapter be purely about
*evidence and honesty* and give the card template a findable home. I did **not**
do this — it is outside my division and it is a genuine judgment call about how
much apparatus belongs in a reader-facing chapter vs a reference file. Flagging
as the canary asks me to.

## Report-wide propagation this cycle started (needs a coordinator decision)

The epistemic-status recalibration (the known first-cycle item) landed a
**three-axis model** — genre / register / strength — and a frontmatter schema
change: the old overloaded `status:` string is replaced by split
`register:` + `strength:` fields, with `evidence:` staying as genre and
`stage:` as maturity. **I migrated only my four chapters' frontmatter** (the
in-division exemplars), per the edit-isolation rule. The other 26 chapters still
carry the old `status:` string. This is deliberate — a schema change lands as an
exemplar + a carry-forward note rather than a silent whole-report rewrite — but
it means:

- Every subsequent window's agent should migrate their chapters' frontmatter to
  the split fields (methods chapter "The frontmatter machinery" section is the
  spec; my four chapters are worked examples of each register/strength case).
- The coordinator may prefer to do the 26-chapter `status:`→`register:`+`strength:`
  migration in one mechanical pass rather than window-by-window, since it is
  low-judgment once the convention is fixed. Either works; naming the choice.

## Vocabulary the report now owns (for consistency in later windows)

The strength ladder is **exact / conditional / robust-qualitative / measured /
heuristic / hypothesis / discussion-grade** (ASF's own five, plus *measured* and
*hypothesis* for this report's empirical and proposed claims). Later windows
should tag headline claims from this fixed list, not invent adjacent words
("theorem-grade" → *conditional*; "high confidence" → the rung that fits).
