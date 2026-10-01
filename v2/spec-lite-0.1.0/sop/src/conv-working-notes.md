---
kind: convention
awaiting-second: true
awaiting-decision: false
needs-work: false
per: [working-notes-and-frozen, open-questions-in-working-notes, notes-disposition-at-freeze, notes-drained-not-history]
depends: [def:record]
---

# Working notes on any record

*Any ⟦record⟧ may have working notes. They are drained continually, so they mostly hold open work, and they never hold history. Before a record can be considered frozen, every note is dispositioned: resolved, kept in the body, deferred, or promoted.*

## Statement

- **Every record of every kind may have working notes:**
  - a `## Working notes` section in Markdown records;
  - a `notes:` field on a fixture case, or a record-level `notes:` key in a fixture file. A key rather than a YAML comment, so a linter can see that notes exist (for the frozen rule and for `needs-work`).
- **A record with any working notes cannot be considered frozen.** That holds wherever its kind has an equivalent state: `final`, or the top rung of its verification ladder.
- **Whether an empty heading is present doesn't matter**, to Joseph or to the engine.
- **Why a place for notes matters:** a partial position (a hunch, an unverified lean, "I haven't checked X") then always has a sanctioned home. Without one, it gets dropped, or pushed into the body as though it were settled.
- **What notes hold:** open questions that bear on the record, by pre-design number where one exists ([[decision:open-questions-in-working-notes]]); doubts and unverified leans; known work; and, until they are dispositioned, sources, cautions and dead ends ([[decision:notes-disposition-at-freeze]]).
- **Notes are not history** ([[decision:notes-drained-not-history]]). What happened and when, changelog entries, and breadcrumbs of past work that won't be needed go to the changelog and to git, never here. "Revised on…", "superseded by…", "changed because…" notes are history.
- **Drain them continually.** It is highly encouraged, though not enforced, that notes be dispositioned as soon as they can be, so that for the most part they hold open work only. An empty, still-relevant-only notes section is far better than accumulated cruft that has to be re-adjudicated every time it is read.
- **Each note is dispositioned before the record is frozen**, and may be at any time before that:
  - **resolved:** incorporated into the body, or found moot, and deleted;
  - **kept:** moved into a body section the kind's cadence names, such as **Discussion**, **Sources**, **Cautions** or **Regression guards** ([[conv:record-cadence]]); in a fixture file, a case's kept reason goes in `why:`;
  - **deferred:** moved to an outline row (`gap` or `proposed`), a question, or the changelog, with its reason;
  - **promoted:** made into a record of its own, and cited.
- **The evidence behind a verification level is not a working note.** The verifying act writes it into frontmatter, beside the level ([[conv:verification-and-status]]).

## How a violation shows

A record at its kind's top rung, or in a `final`-like state, whose working notes are non-empty; a `needs-work: true` flag with no note behind it; a verification level whose evidence is in working notes rather than frontmatter; a working note that records history (encouraged draining is not checked).

## Discussion

- Joseph asked for "making sure there is allowances for working-notes everywhere…" (2026-09-30, in the message that also asked for Markdown and for decisions to carry reasoning and assumptions; `sop/influx/jaw-proposal-and-feedback.md` §1.12).

## Working notes

