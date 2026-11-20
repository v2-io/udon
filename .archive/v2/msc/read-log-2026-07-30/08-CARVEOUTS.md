# 08 — `current-0.9.1-spec/CARVEOUTS.md` (116 lines, read whole)

*Opus 5 (session `udon`), 2026-07-30. Ranked #3 in `02-value-predictions.md` ("highest per line");
that ranking holds, for reasons I had roughly right and one I didn't.*

---

## The countable fact

Sixteen carve-outs. Each carries what would close it. Sorting by the closer:

| Closed by | Items |
|---|---|
| **dialect work** (spike / layer / definition / standard-types) | **ML, ENV-ROUTE, ENV-EMPTY, DIALECT-DEF, RC-SPELL** — plus **PRAGMA** (dialect+schema) and **ANNOT** (paths/dialects/schema) partly |
| paths spike | PATHS, and ANNOT partly |
| a steward call / ruling | S4-SCOPE, UNI |
| other demand or downstream work | MD, MIXIN, IND, S9, W, CODES |

**The dialect work gates five carve-outs outright and two more partly — roughly seven of sixteen.**
And DIALECT-DEF says, in its own words: *"this is the largest named hole in the demand-side work
— **no dialect spike has ever run**."*

That is a mechanical fact about the register rather than a judgment about priorities, and it's the
first thing I've seen today that answers "what is actually blocking what" without anyone's
estimate in it. Recording it as a fact; the priority call isn't mine.

## The schema asymmetry, sharpened

The primer's appendix flagged that no carve-out covers *"what a schema language must be able to
say."* Confirmed against the primary: **there is no SCHEMA entry among the sixteen.** PRAGMA
mentions schema *declaration*; ANNOT lists schema among its blockers; the layer itself has no row.

But I think the primer's framing is slightly off and the sharper version is an **asymmetry**, not
an absence. A schema layer isn't *unspecified in 0.9.1* — it's assigned to a different owner in
CORE §1.1, which is a layer boundary rather than a carve-out. Except that **PATHS and DIALECT-DEF
are also other layers, and they get full entries with demand-side reasons and closing
conditions.** So of the three deferred layers the core defers *to*, two are registered with their
reasons and one is not — and the unregistered one is the one CORE hands cardinality, uniqueness,
and `$key` multiplicity to in four separate places.

The consequence is concrete, given this file's own opening: it is *"normative as to scope"* and
says authors MUST NOT rely on any particular behavior for listed items. The schema layer, being
unlisted, carries no such protection.

## A thing the document does to itself that I'd not seen before

**S4-SCOPE flags one of the suite's own descriptions as non-authoritative.** The suite's prose and
Appendix B describe `InconsistentIndentation` as firing for prose *and* comment-continuation
lines — and the carve-out says that is *"inherited from live CORE's registry, **not ratified**…
do not cite it as settling S4."*

So the spec contains a statement, and elsewhere contains a statement that the first statement
doesn't count. That's FORMAT.md's collision mechanism operating *inside a single document*, and
it's a cheaper instrument than I'd realized: you don't need two competing claims in two files,
you need one claim plus a register that says which claims are load-bearing.

## Two things restated more precisely than the primer had them

- **The register's origin.** Three clean-room rewrites on 2026-07-20 — handed the spec *without
  the reasons* — all three closed ML per-construct. *"The openness is design intent; the reason is
  the load-bearing part."*
- **ML may dissolve rather than resolve.** If bracketed/quoted captures are sugar for dialect-typed
  captures, each capture's grammar owns its own line-span exactly as nested `<…>` routing already
  does, *"and there is no per-construct table to close."* Closing rows now would pin answers the
  dialect mechanism would immediately overrule.
- **PATH-1 as a live constraint on tooling**: *"do not build tools that assume document-scope is
  permanent."*

## The primer finding, and it's the sharpest one today

The primer's §6 says CARVEOUTS *"is unusual and worth citing directly… every open item travels
with the demand-side reason it is open and what would close it"* — then lists about ten of the
sixteen **by name only**, with a parenthetical reason for one.

So it **describes the property and carries none of it.** A reader of the primer knows that reasons
exist and holds zero of them — which is exactly the state the three clean-room agents were in when
they produced well-organized irrelevance.

And the honesty makes it *worse*, not better: because the primer names the property explicitly, a
reader comes away feeling they've been told the important thing about the file. An unmentioned
gap invites a look; a described-but-untransmitted one closes the question.

**Attribution: (A) PRIMER-GAP**, and the most consequential of the day — not because the primer
was wrong, but because a described gap doesn't feel like one.

---

## Wandering

The dialect count reorganized my picture of this project more than any single claim I've read
today, and it did it arithmetically rather than by argument. Seven of sixteen open items wait on a
spike that has never run. Before this file I had a fuzzy sense that "dialects, paths, schema" were
the three deferred territories, held roughly equally — the outline treats them roughly equally,
the primer lists them together, my own value-prediction table treated them as peers. The register
says otherwise, and says it in a form nobody has to be persuaded of. What strikes me is how
different that is from the way I'd been *forming* priorities all day: by salience, recency, and
what I'd just been reading. This is the same lesson as the `:max exact` count — twenty-one of
twenty-three citing one file — arriving from an unrelated direction. Both times the fact was
sitting in a structured artifact, countable in one command, and invisible to a reading that was
paying attention to content rather than to distribution. I want to add that to the seeds: **when
an artifact is structured, count it before you interpret it** — the distribution is often the
finding, and it is the one thing a careful read reliably misses.

The second thing is the S4-SCOPE move, which I keep turning over because it inverts something I
assumed about specs. I had been treating "the spec says X" as the terminal move — the thing that
ends an inquiry. Here the spec says X in one place and, in another, says *that saying doesn't
count yet*. Which means the document has an internal authority gradient, and reading it linearly
gives you no access to that gradient at all: §7.2 and Appendix B read as ordinary normative prose,
and only the register reveals that one of them is inherited-but-unratified. That has an
uncomfortable implication for how I've been citing CORE all afternoon — I've been treating every
sentence in it as equally load-bearing, and at least one demonstrably isn't. I don't currently
know how many others are in that state, and CARVEOUTS only flags the ones somebody noticed. That
is a genuine, uncomfortable uncertainty and I'd rather carry it than resolve it prematurely: it
goes on the recurrence counter as *"what else in the ruled text is inherited rather than ruled?"*

Third, on the primer finding, which I think generalizes past this project. The failure mode isn't
compression — the primer compresses well and honestly almost everywhere. It's that **naming a
property can substitute for transmitting it**, and the naming is what closes the reader's
question. "Every item travels with its reason" is a true, useful, well-intentioned sentence that
leaves the reader with a *model* of CARVEOUTS and none of its content, and the model is
satisfying enough that nothing prompts the read. That is structurally identical to the memory
index's warning about itself, to the onboarding-gloss contract, and to my own morning with the
spikes-README banner — four instances now, and in every one the anesthetic was *accurate*. Which
is why I don't think "be more accurate" is anywhere near the fix. The fix, if there is one, is
that a summary of an artifact whose value is its *content* should be uncomfortable to stop at —
should read as obviously partial — and the way to do that is probably to carry two or three actual
items in full rather than fifteen by name. A sample transmits; a list describes.
