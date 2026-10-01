---
kind: decision
awaiting-second: true           # true until someone other than the writer has checked this record against its sources, above all the Outcome against the Quote
awaiting-decision: true         # true while the decider's call is still wanted; the call clears it, and so does a deliberate deferral (say so in the Outcome)
needs-work: false               # true while known work remains; the details go in Working notes
title: "[Short title: the problem and the chosen solution]"
status: proposed                # lifecycle: proposed | accepted | rejected | superseded | deprecated
decided-by: proposed            # authority: steward | ratified | council | supported | defacto | proposed | transition
decided: ""                     # YYYY-MM-DD the call was made (empty until accepted or rejected)
updated: YYYY-MM-DD             # YYYY-MM-DD this file last changed in substance
deciders: []                    # who made the call, e.g. [Joseph (steward)]; agents count, marked as agents, e.g. "aat-refactored coordinator (agent, Opus 5.5)"; a delegate adds "under delegated authority (<grant slug>)"
consulted: []                   # whose view was sought before the call, and was given
informed: []                    # who needs to know the outcome (e.g. parser implementers, vsect, udon team)
wording: rendering              # verbatim | rendering: whose words the Decision Outcome is in; usually rendering, even when a Quote is located; verbatim when the decider wrote it
grounds-recorded: at-decision   # at-decision | reconstructed: were Drivers and Assumptions written from what was said when the call was made, or recovered later?
supersedes: []                  # decisions this replaces: [{adr: slug, how: revised | invalidated | alternate, scope: whole | partial}]
superseded-by: []               # same shape; set on this record when a newer one supersedes it
closes: []                      # (lite) pre-design question numbers this answers, e.g. ["07"]
leaves-open: []                 # (lite) parts of those questions deliberately not decided here, e.g. ["07 Q3"]
---

# [Short title: the problem and the chosen solution]

## Context and Problem Statement

[A few sentences: what has to be decided, and why now. Link the pre-design question file(s) or the discussion it came from. If the question arose from a failure, a collision between rules, or a fixture that could not be settled, name it. If this partly supersedes an older decision, name the parts it replaces.]

## Decision Drivers

* [Driver, linked to the objective or principle it comes from, e.g. [[obj:reserve-dont-ignore]].]
* [Driver not traceable to any objective or principle. Say so: an unlisted driver is either a missing objective or a preference, and a later reader needs to know which.]
* [Driver the deciders did not give themselves. (**inferred, unconfirmed**: whose reading, and where.)]

## Assumptions

*Required. What must stay true for this decision to stay right. Each assumption that could break becomes a line in "Reopen when".*

* [Assumption.] (**recorded**: stated by a decider at the time; cite where)
* [Assumption.] (**inferred, unconfirmed**: an agent's reading; confirm with the decider before anything else leans on it)
* *If none were recorded, write "None recorded". Do not reconstruct them.*

## Considered Options

* [Option 1: name] (chosen)
* [Option 2: name]
* *If only one option was ever on the table, say so. That is information too.*

## Decision Outcome

Chosen: [Option 1], because [the reasoning, as the deciders gave it. If they gave none beyond the drivers above, say that rather than supplying a reason].

[Anything more about what was chosen, as bullets. For a decision still `proposed`, write "Undecided", with why and what it waits on.]

### Quote

> [The decider's own words, verbatim.]
>
> — [Who], [YYYY-MM-DD] ([where the words are kept, e.g. `sop/influx/jaw-proposal-and-feedback.md` §1.6])

*If the words exist only in a chat, say so, and add a working note to carry them into a kept file. If none can be found, write "Not located": the Outcome is then a rendering, and nothing in this record may be presented as the decider's words.*

*If the decider wrote the Outcome themselves, as a delegate does, the Outcome is their words (`wording: verbatim`). Say so here instead of quoting, and link the grant the authority comes from. Quote the grantor only for words that speak to this decision.*

*Provenance that stays true belongs here, after the quote, not in Working notes: whose proposal the choice was, why `decided-by` has the value it has, which part of the outcome rests on different authority.*

### Positive Consequences

* [Good consequence]

### Negative Consequences

* [Bad consequence, including costs accepted knowingly]

### What changes

*What this decision moves, so that it can't be accepted and then never carried out. Name records as `[[kind:slug]]`. This is the decision's trail at decision time; it is not kept current afterwards, and git holds what followed. Each record whose text rests on this decision cites it in its own `per:`, which is the only maintained link; what rests on a decision is derived from those citations ([[sop/decision:record-to-decision-links-for-now]], for now).*

* Records written or amended: [e.g. [[rule:implied-root]]]
* Questions closed: [the records whose working notes carry the questions in `closes`; those notes are removed when this is accepted]
* (lite) `dat/` cases: [ids that flip from descriptive to canonical, or change their tree]
* (lite) Anything this makes forward-unstable, or newly forward-stable ([[obj:reserve-dont-ignore]]): [or "none"]

## Pros and Cons of the Options

*Optional. Use it when the options were argued in detail; otherwise the drivers and consequences above carry the argument.*

### [Option 1] (chosen)

* Good, because [argument]
* Bad, because [argument]

### [Option 2]

* Good, because [argument]
* Bad, because [argument]

## Reopen when

* [A condition that reopens this, usually an assumption above breaking.]
* *If none is known, write "None recorded". For a decision still `proposed`, list what would bring it to a decision.*

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

*Optional. Open work: threads, doubts, leads, things not yet checked, such as a quote still to be carried into a kept file or a ratification still to come. Drain it continually; each note is dispositioned (resolved, kept, deferred or promoted) before the record counts as frozen ([[sop/decision:notes-disposition-at-freeze]]). A kept note goes in the body: provenance with the Quote, background in Context, and Cautions or Regression guards in sections of those names just before this one. Never history: "corrected on…", "superseded by…", "changed because…" belong in the changelog and git ([[sop/decision:notes-drained-not-history]]); a supersession is already carried by `superseded-by`. If there are no notes, leave the section empty or leave it out. A placeholder such as "(none yet)" reads as a note.*

---

## About this template (delete this section when copying)

Carried from MADR (the template Joseph supplied), with changes for this corpus. Each change has a reason. The process decisions in `sop/adr/` are made from this file too, and they are the best worked examples of it.

**One template, two decision sets.** Lite's decisions live in `adr/` and belong to the udon team. This corpus's process decisions live in `sop/adr/` ([[sop/decision:sop-own-vsect-and-decisions]]). Lines marked *(lite)* apply only to lite's decisions. A process decision leaves those frontmatter fields empty and drops those bullets.

**Frontmatter**

- **The filename is the slug, not a number** (`adr/<slug>.md`, e.g. `adr/reserve-not-ignore.md`). A ⟦record⟧'s ⟦identity⟧ is (kind, slug), never a position or a number. `supersedes` and `superseded-by` name slugs. If a numbered listing is wanted, it is a generated view.
- **The three ⟦flags⟧ are here because every record carries them** ([[sop/conv:record-flags]]). On a decision they say what its lifecycle can't:
  - `awaiting-second`: a decision written up by an agent is a rendering, and the most dangerous failure a decision has is a rendering carried as the decider's words ([[sop/ref:hazards]]). A second reader who checks the Outcome against the Quote clears it. For a delegated decision the Quote is the grant, which can't confirm any particular Outcome, so the second reader asks instead: is it within the grant; does it contradict, narrow or reverse anything the grantor said, anywhere; were the options fairly put, including a stronger one; and is the reasoning stated? (Proposed by the second look of 2026-09-30, `sop/influx/adr-check-notes.md`.)
  - `awaiting-decision`: a `proposed` decision is usually waiting for its decider. It is not waiting when the decider has deliberately deferred it until something happens. The flag keeps "waiting on the steward" apart from "parked".
  - `needs-work`: known work, such as a quote not yet carried into a kept file.
- **`status` and ⟦decided-by⟧ are separate fields.** `status` is the lifecycle (is this in force?). `decided-by` is authority (who stood behind it, and how firmly). They move independently, so they don't share a field. For example, `accepted` + `supported` is a real and common state: act on it, and revisiting it is cheap. MADR's single Status field fuses the two. `defacto` ("decided without really being decided") and `transition` (rejected, but still present somewhere) live in `decided-by`, because they are honesty states about authority. When parts of one outcome stand on different authority, give the main one and say which part differs under the Quote, or split the decision.
- **⟦supersedes⟧ is typed and scoped** (verisectorium RC1, 06-EDGES; [[sop/def:supersession]]):
  - `revised`: the same decision, updated;
  - `invalidated`: an assumption broke, or it was shown wrong;
  - `alternate`: a sibling choice, e.g. per profile;
  - `whole` or `partial`: whether the whole record is superseded. A partial supersession names its parts in Context.
  - Chains of `revised` resolve to the current record; the other two do not chain.
- **The edges that live in frontmatter are the ones nothing else can hold:** `supersedes` and `superseded-by`, which carry a type and a scope, and *(lite)* `closes` and `leaves-open`, whose targets are pre-design question numbers rather than records. The other edges are read from where they already are:
  - the records that rest on this decision are the ones that cite it in their own `per:`;
  - the objectives and principles it answers to are the `[[kind:slug]]` links in its Decision Drivers.
- **No `affects` or `drivers-cite` field.** `affects` would restate, on the decision, the `per:` citations of the records that rest on it. In the 26 decisions in `sop/adr/` (2026-09-30) it had drifted the way the `questions:` field did before it was dropped ([[sop/def:record-fields]]). Every one of the 26 is cited through `per:`, but 20 had `affects: []`. The 6 that filled it listed only some of their citers, in filename forms that don't resolve, and four named `main-outline`, which is a view, not a record. `drivers-cite` would restate the links in Decision Drivers; it dates from before `[[kind:slug]]` links existed, and all 26 left it empty. A fact kept in two places drifts, so each is kept in one.

**Body**

- **The reasoning is the Decision Drivers together with the Outcome's "because"**, which is what [[sop/conv:decisions]] calls the required Reasoning section. A driver the deciders did not give is marked as inferred, the same way an assumption is, because an agent's framing of why reads exactly like the decider's.
- **Assumptions are required, and each carries its provenance.** A decision can be reopened only on the grounds that were written down. An assumption breaking is the cleanest reopen trigger, and it works only if the assumption was written down at the time. `grounds-recorded: reconstructed` marks drivers or assumptions recovered after the fact. Those can be useful, but a reason reconstructed later reads exactly like one given at the time, so they are marked.
- **⟦wording⟧ and the Quote section keep the decider's words apart from anyone's rendering.** `wording` is about the Outcome's text. An Outcome written by anyone but the decider is a `rendering`, even when the Quote beside it is verbatim; one the decider wrote, as a delegate does, is `verbatim`. This carries v2's conflict protocol for its K-rows: when a record conflicts with another, go back to the decider ("when you said X, were you also implying Y?") instead of weighing one record against another.
- **"What changes"** names the records and `dat/` cases a decision moves, and the open questions it removes from records' working notes (open questions live there: [[sop/decision:open-questions-in-working-notes]]). Without it, a decision can be accepted and the text never updated. It records the trail as of the decision and isn't maintained after; the current set of records resting on a decision is derived from their `per:`.
- **"Reopen when"** holds the falsifiers, one condition per bullet. A decision with no reopen condition is either very stable or unexamined, so when none is known it says "None recorded" rather than leaving the list to the reminder line below it.
- **Consulted / Informed** are from MADR and are also RC1's consultation dimension. Recording who was asked before the call is what separates a consulted decision from an announced one.
- **Pros and Cons of the Options is optional.** MADR marks it optional too. Leave it out entirely rather than as an empty heading.
- **An empty required section says so.** Assumptions and Reopen when take "None recorded"; Considered Options says when there was only one; a consequence list with nothing in it says "None". An empty body section reads as "not yet written". (Working notes are the exception: there, empty means no open work, and a placeholder would read as a note.)

**Decisions made under delegated authority.** When the decider delegates a class of decisions (e.g. [[sop/decision:setup-delegated-to-coordinator]]), each decision made under the grant:

- names the delegate in `deciders`, under the grant;
- carries `decided-by: supported` and `status: accepted`: it is in force, on provisional authority;
- carries `awaiting-decision: true` until the store's decider ratifies it ([[sop/decision:decider-per-store]]), and lists "the decider declines to ratify it" under Reopen when;
- links the grant in its Outcome. The Outcome is the delegate's own words, so `wording: verbatim`, and the grant is linked rather than quoted again in every record it covers.

On ratification, `decided-by` becomes `ratified` and `awaiting-decision` becomes `false`; neither is an edit to the outcome. The grant's own record never lists the decisions made under it: they are the ones that cite it.

**After acceptance** (a proposal inferred from how the process decisions have been kept; no decision records it yet):

- The choice is never changed in place. Changing it takes a new decision that supersedes this one.
- What may change: `status`, `superseded-by`, `updated`, the flags, `decided-by` when authority firms up (e.g. `supported` to `ratified` once the steward confirms), and Working notes.
- A rendering shown not to match what the decider said is corrected in place, with a note saying what was corrected. That repairs an attribution; it does not reopen the choice.
- ⟦working-notes⟧ don't hold an accepted decision back. A record with notes cannot be considered frozen ([[sop/decision:working-notes-and-frozen]]), but `accepted` means "in force", not "frozen". A decision's outcome is fixed from acceptance whether or not it has notes.

**Links from this file.** Records in this store are linked as `[[kind:slug]]`, and SOP-store records as `[[sop/kind:slug]]` ([[sop/decision:cross-store-links]]). A process decision made from this template links other process decisions as `[[decision:slug]]`, which resolves in its own store.

**Not carried from MADR:** the numbered title prefix, for the slug reason above.

**Open points about this file:**

- It declares `kind: decision` so that copies do. It is not a decision record: files named `TEMPLATE.md` or `<kind>.template.md` are excluded from resolution ([[sop/decision:templates-are-not-records]]).
- `title:` repeats the heading. No copy has drifted yet, but it is the same two-places pattern as `affects`. No other kind carries a title field.
