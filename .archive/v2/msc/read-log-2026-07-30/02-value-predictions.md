# 02 — predicted value of files/dirs for this session, before reading them

*Opus 5 (session `udon`), 2026-07-30, at Joseph's request. Written before opening any of the
Tier-1 files. "Value" here means **value to this session's work** — orienting well enough to
be a useful thinking partner on udon's next high-level steps — not general importance. Each
row carries a falsifier so the ranking can be scored later rather than remembered
favorably.*

## First, my selection bias, since that's what prompted the question

I went to `DECISIONS.md` / `OPEN.md` first. Honest reconstruction of why: they were modified
most recently, `v2/README.md` names them as present-truth, and they're small. Under that sits
something less flattering — **I was orienting to the *state of the work* rather than to the
*thing the work is about***, which is the exact failure the 7/29 predecessor was corrected for
and which I had read in memory an hour earlier.

And I discounted `udon-0.9.1-primer.md` — listed it as unread, didn't prioritize it. The reason
is legible in retrospect: I rank sources by apparent authority tier (ledger > spec > "primer"),
and *primer* sounds derivative. It was written by an agent that had read all nine spec files
whole, every example traces to a ruled section, and it gave me more per line than anything else
I read today. That's [[devaluing-others-sources]] in a new costume: discounting a secondary
artifact for being secondary instead of assessing its reliability.

**The correction I'd generalize:** rank by *information density per line about the object*, not
by the artifact's position in an authority hierarchy. A good distillation beats a ledger for
orientation; the ledger wins only when you need to know what is *ruled*.

---

## The table

| Rank | File / dir | Predicted value | Why I think so | What would falsify |
|---|---|---|---|---|
| 1 | `theory/to-integrate/primary/type-algebra.md` | **Highest** | Counted: **21 of the OUTLINE's 23 `:max exact` rows cite it**; 33 inbound `:see` total. It is the only place this corpus can claim proof rather than argument — the sole falsifiable column holding Parts III & IV up. | It turns out to be a sketch whose "exact" ceilings were assigned aspirationally, in which case its value drops and *the ceilings themselves* become the finding. |
| 2 | `current-0.9.1-spec/CORE.md` (882 ln) | **Highest** | The contract. Primer §8 names five sections carrying recognition load (§2.1, §2.2, §6.4, §6.5, §14.1) + Appendix C's worked vignettes. I currently hold the *law* second-hand and cannot cite it at point of use — which the standing rule requires before any load-bearing recommendation. | If the primer proves a faithful enough proxy that opening CORE changes nothing I'd say. I doubt this: the primer omits the vignettes and all the §-level precision. |
| 3 | `current-0.9.1-spec/CARVEOUTS.md` (115 ln) | **Highest per line** | Every deliberately-open item *with the demand-side reason it is open and what would close it*. Memory calls it the estate's highest-value file for spike work; the primer says it exists because three clean-room agents, given the spec without reasons, all confidently closed an already-invalidated question. For "what are the next high-level steps," a register of open items and their closing conditions is closer to the answer than anything else in the repo. | If it's thinner than its reputation — a list without the reasons actually attached. |
| 4 | `theory/to-integrate/primary/DISCUSSION-THOUGHTS.udon` | **High** | Joseph's own brainstorms verbatim (O1–O18), pre-validation, with per-item assessment. Distinguishes *what he actually thinks* from *what agents synthesized about what he thinks* — the single hardest thing to reconstruct from anything else, and the thing I'm most likely to get wrong by interpolation. | If it turns out to be mostly already-absorbed items whose live content sits in OPEN/OUTLINE. |
| 5 | `current-0.9.1-spec/MODEL.md` (145 ln) | **High** | The ADM is the comparative object and the conformance target's output. The primer distilled it well, but Part II of the OUTLINE (`def-population`, `def-serving`, the four file roles) is built on it and every one of those is `:max axiomatic` — definitions I'd need exact. | If MODEL is thin and CORE carries the model text in practice. |
| 6 | `theory/to-integrate/primary/MINEFIELD-MAP.md` | **High** | 31 inbound cites; Part VIII essentially wholesale, plus M13 anchoring the co-occurrence-boundary chapter in Part IV. Thirteen failure mechanisms stated as mechanisms — the constraint surface any design proposal has to clear. | Its own header reportedly marks three mines as resting on theory-plus-recall rather than fetched primaries; if that's most of the load-bearing ones, value drops. |
| 7 | `theory/to-integrate/primary/late-misc-synopsis.md` | **High** | 15 inbound cites, 10 of them `conditional`; owns §3 (paths / seven speaking occasions / arity) and §4 (the fiat strata) — i.e. two whole chapters. Paths is one of the two territories everything else is waiting on. | If it's a synopsis of material better read at its own primaries, per the estate's "a synthesis is an input, not an authority" rule. |
| 8 | `theory/to-integrate/primary/db-theory.md` | **Medium-high** | 23 inbound cites spread across Parts I, II, IV, VII — connective tissue rather than a single result. Also the "poster child" per a recent commit message. | Spread-out citation may mean it's a *lens* rather than load-bearing content — valuable to read once, not to hold precisely. |
| 9 | `theory/to-integrate/primary/underlying-logical-model.md` | **Medium-high** | 12 cites, 6 of them `axiomatic` — it supplies Part II's definitions. Letter register, marked provisional, and memory says its "elephant" hypothesis (agentic tooling works better over the logical corpus than the file layout) is Joseph's own and pre-validation. | If the definitions have already been superseded by the OUTLINE's own phrasings. |
| 10 | `current-0.9.1-spec/{SEMANTICS,GLOSSARY}.md` | **Medium, on demand** | Needed for precision *at point of use* — equivalence claims and formal terms. Not orientation reading; the kind of file you open at the moment you rely on it. | — |
| 11 | `current-0.9.1-spec/RATIONALE.md` | **Medium** | The "why" behind the commitments. The primer already carries the main reasons, so marginal value depends on how much it holds that didn't survive distillation. | If it's fully absorbed into the primer's §4. |
| 12 | `current-0.9.1-spec/TUTORIAL.md` (133 ln) | **Low — but flagged** | I'd normally skip a tutorial. Counter-consideration I don't want to lose: primer §8 says the defense against emitting wrong UDON is *preferring the spec's own examples to invented ones*. TUTORIAL is plausibly the densest supply of citable examples in the estate. So its value is not pedagogical — it's as an example bank. | If CORE's Appendix C vignettes cover that need, TUTORIAL stays low. |
| 13 | `udon-needs/` (whole) | **Low this session, high in general** | It's the demand corpus and it's large. The center of gravity moved to `theory/` today, and `theory/`'s `:see` rows point at `to-integrate/`, not at `udon-needs/`. Reading it now would be orienting to last week's front. | If the next high-level step turns out to be demand-side (e.g. the priorities bridge), this inverts immediately. |
| 14 | `theory/spikes-README.md` (29 KB) | **Low — predicted net-negative** | `v2/README.md` banners it as a stale 7/28 snapshot slated for removal. Per the hole-marker contract its *glosses* would give me the feeling of having read the material it indexes. Reading a stale index of things I haven't read is the specific trap that produced this project's worst orientation failures. | If it contains the "floor" material (register rules, hazards, the ten claims) in a form that exists nowhere else — in which case it isn't stale, it's *unmigrated*, and that's a finding about the reorg rather than about the file. |
| 15 | `current-0.9.1-spec/DELTAS.md` (22 ln) · `PEDAGOGY.md` (47 ln) | **Low** | Small; DELTAS is change-routing, PEDAGOGY is outline-only by ruling (**P4**). | Cheap enough that being wrong costs nothing. |
| 16 | `BEST-WITH-UDON.md` (101 ln) | **Unknown — genuinely** | I have no model of this file. Name suggests positioning ("what UDON is best with"). Listing it because an honest table should contain the thing I can't rank. | — |

## On READMEs specifically

Joseph's observation is that agents either ignore READMEs entirely or open them first, with
little thought either way. My predicted rule for *this* estate, offered as a rule to be tested:

**A README here is high-value as a routing-and-staleness instrument and low-value as content** —
and the two are separable by one cheap mechanical check: `git log -1` on the README versus the
directories it describes. Concretely, today:

- `v2/README.md` — last touched 10:24 today, and *still* frames v2 as "two live bodies of work
  as of 2026-07-22." `theory/` landed the same morning and appears only as a bolted-on pointer
  under "Working here." So the file is fresh and its framing is stale, which is the failure mode
  a timestamp alone won't catch.
- `udon/CLAUDE.md` (root) — 8 days old, still names `udon-needs/` the center of gravity.
- `theory/` — **no README exists.** The front door is `CLAUDE.md` → `FORMAT.md` (a symlink) plus
  `OUTLINE.udon`, both of which are conventions-and-spine rather than orientation.

That last one is the interesting gap and I'd flag it as a real (small) finding rather than a
preference: the most active directory in the repo has no artifact answering *what is this, what
state is it in, what would you work on here*. `FORMAT.md` answers "how do I write a segment,"
which is a different question, and its §12 open-questions section is closer to a research agenda
than a front door. An agent arriving cold at `theory/` has to reconstruct the situation from a
725-line outline of gaps.

**What I'd predict a `theory/README` would need to carry, if one is ever written** (offered as a
prediction about content, not a recommendation to write it): that `src/` is empty by design and
every row is a gap; that the OUTLINE is a proposal about organization rather than a finding; that
`to-integrate/primary/` holds the sources and `refine-more/` holds material not yet load-bearing;
and the one number that reorients anyone instantly — 21 of 23 exact ceilings rest on one file.

## Scoring note

This table is a prediction. The check is: at session end, which files did I actually cite, and
which did I open and abandon? If the ranking above is worth anything, it should beat what I'd
have picked by feel — and my morning's evidence is that what I pick by feel is *state-of-work
documents that let me sound oriented quickly.*
