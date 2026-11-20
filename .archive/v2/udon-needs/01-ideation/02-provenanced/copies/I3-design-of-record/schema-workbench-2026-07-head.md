---
source: live repo file `design/schema-workbench-2026-07.md` at gather time — HEAD EXCERPT (lines 1-97 of ~1167)
gathered: 2026-07-21
status: gathered source material — partial excerpt (head only; full file ~1167 lines is a comparative survey + file-by-file ledger, mostly model-knowledge/bookkeeping); NOT authoritative
paths:
  - design/schema-workbench-2026-07.md:1-97
source_commit: 3d8e5b9c52b2a581c4ab9021984423073a694693
categories: [agentic-tooling, schema, rowan-waiting-customer, convergence-vs-authorship, indentation-hazard, design-of-record]
why_included: |
  Head excerpt — the demand-bearing part. Two load-bearing threads: (1) ROWAN IS THE
  FIRST WAITING CUSTOMER, not just prior art — Joseph: "I got tired of all of the ruby
  DSL for the schema definitions and started craving udon and decided I wasn't going to
  move it forward anymore until udon was really ready," with DATED evidence (rowan's
  schema-first ADR 2025-12-10 → udon revival 2025-12-23 → hand-written Ash-shaped UDON
  schemas 2025-12-24: the craving is immediate, not hindsight) — a concrete cross-project
  demand pull and an acceptance test ("can rowan's vocabulary be written in it, better
  than the Ruby?"). (2) WHY SCHEMAS MATTER MORE HERE: UDON's indentation hazard is worse
  than Python's because wrong-scope content is VALID, silently re-parented — schemas
  restore the loud failure. The banner also carries the CONVERGENCE-VS-AUTHORSHIP
  discipline verbatim (Joseph: "I wouldn't read too much into the convergences you see —
  it was all me"), the single most important caveat for reading this whole one-author
  corpus. The excised body (§1-§7 survey + §6 ledger) is comparative model-knowledge and
  file bookkeeping — pointer, not copy. Full file cross-refs udon-schema-exploration
  (the "13 Puzzle Pieces" single-source-of-truth vision) and schema-notes-2026-07 (copied).
---

# Schema workbench — sources, survey, and where the thinking is

> **Status: workbench / source index.** Staging document for the schema
> layer: what's been read, comparative survey, open readings. **Forming
> design note (next step toward ratification):**
> [`schema-notes-2026-07.md`](schema-notes-2026-07.md) (2026-07-18) — not
> ratified; Joseph-facing freezes and forks. This workbench remains the
> archaeology and survey; the notes file is the position to argue with.
> Opened 2026-07-16 (Claude, at Joseph's request). Expect eventual archive
> once a ratified `schema-model-*.md` exists.
>
> **Epistemic note:** the comparative survey (§3) is model knowledge, not a
> fresh survey — verify anything before it becomes load-bearing. Everything
> in §1–§2 is first-hand read or probe-verified unless marked otherwise.
>
> **⚠ Correction — do not read rowan↔udon agreement as convergence**
> (Joseph, 2026-07-16): *"I wouldn't read too much into the convergences
> you see — it was all me."* Rowan and udon share one author. Where an
> earlier draft of this document called rowan's DSL shape "independent
> corroboration" of a udon position, that was **false weight**: it is one
> person being consistent across two projects, which is evidence about the
> *author's* instincts, not about the design being forced. Struck
> throughout. What survives as genuine evidence is a shorter list, and it
> is worth knowing which is which:
> - **Mechanical facts** — the 0.9 probe results; what CORE ratifies.
> - **External empirical data** — rowan's 1,950-migration survey; rowan's
>   naive-agent guessability tests.
> - **Genuinely independent agents** — e.g. the two EOF reviewers who
>   never saw each other; the corpus-building agent's `operata.domain.udon`
>   port landing on the same 0.9 idiom as this document's hand-run probes
>   (§7), neither having seen the other.
> - **What Joseph reached for by hand before any theory** (§1, December
>   examples) — *not* independent, but a real usability datum about the
>   primary author, and arguably the strongest signal available for a
>   notation whose point is being pleasant to write.
>
> **The pattern behind the correction, since it recurred three times in one
> session and future readers will have the same reflex:** I kept reading
> *design intent* as *independent convergence*. Rowan's DSL matching a udon
> position; the December examples matching CORE's identity model; the
> element suffixes fitting a schema's required/optional need — each felt
> like separate paths meeting, and each was **one designer being
> consistent with himself over eight months**. Joseph, on the suffixes:
> *"I absolutely put those in the syntax because I had schemas on my mind.
> This is you catching up with me to help me catch up with me."* The
> fitness in all three cases is **real and load-bearing** — a design whose
> parts were built for each other is *better*, not worse. But it is
> evidence of **coherent authorship**, not of a forced solution, and it
> carries none of the corroborative weight that genuine independence would.
> When this document says a thing "fits," assume intent until shown
> otherwise.

---

## 0. Why the schema layer matters more here than in most formats

Two reasons, both Joseph's:

1. **UDON's indentation hazard is worse than Python's** (2026-07-16):
   *"python will break catastrophically if some code gets the wrong indent
   or even if a block gets put at the wrong scope — whereas it won't be as
   obvious to udon except thanks to schemas."* Wrong-scope content in UDON
   is **valid**, just silently re-parented. Schemas are what restore the
   loud failure. (The edit tool removes the *write-side* hazard by
   computing indentation; schemas cover everything else.)
2. **Rowan is the first waiting customer, not just prior art**
   (2026-07-16): *"I got tired of all of the ruby DSL for the schema
   definitions and started craving udon and decided I wasn't going to move
   it forward anymore until udon was really ready."* So the acceptance test
   for any design here is: **can rowan's vocabulary be written in it,
   better than the Ruby?**

**A dated detail worth holding** (checked, not remembered): rowan's
document-schema-first ADR is **2025-12-10**; udon's revival commit is
**2025-12-23**; `design/examples/ash-like-*.udon` are **2025-12-24**. Within
two weeks of settling rowan's schema architecture, Joseph was hand-writing
Ash-shaped schemas in UDON. The craving is dated and immediate, not
hindsight.

**The deferral, stated (Joseph, 2026-07-16)** — this is the lane's actual
status and it is not "unexplored": *"path, schema, and dialects were all
**deferred so we could get the parser core working**, which is what we've
done today until this session where I'm letting us pre-explore a bit."*
So the schema layer is **deliberately postponed work with a completed
prerequisite**, not a blank page. Three consequences for whoever reads
this next:

1. **The prerequisite is now met.** The parser core is compliant
   (`core-v0.9.0` pending only densification + rulings), which is what the
   deferral was waiting on.
2. **The deferral is why the December DSLs went quiet**, not disinterest —
   and why they are *still the state of the art* eight months later
   (§7). Nothing superseded them; nothing was allowed to.
3. **This session is explicitly pre-exploration** — *"gathering up the
   resources"* — not design. §5's design note is the *next* session's job,
   with more room to think (his framing). **Do not converge here.**

