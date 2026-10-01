---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "One .vsect/kinds.yaml declares each kind's aliases, where it is found, and its verification ladder"
status: accepted
decided-by: steward
decided: "2026-09-30"
updated: 2026-09-30
deciders: [Joseph (steward)]
consulted: [aat-refactored coordinator (agent, Opus 5.5), spec-lite fork (agent, Opus 5.5)]
informed: []
wording: rendering
grounds-recorded: at-decision
supersedes: []
superseded-by: []
closes: []
leaves-open: []
---

# One .vsect/kinds.yaml declares each kind's aliases, where it is found, and its verification ladder

## Context and Problem Statement

`[[kind:slug]]` needs a resolution procedure. Joseph gave the steps; the agents proposed guards and a file format; Joseph proposed merging the two files (`sop/influx/jaw-proposal-and-feedback.md` §1.5–§1.8, §3.13).

## Decision Drivers

* Bespoke and pragmatic for now.
* Explicit directory lists instead of `**/`.
* Kinds fleshed out from a tooling perspective.

## Assumptions

* None recorded.

## Considered Options

* Two files: `kind-map.yaml` (aliases) and `kind-match.yaml` (globs)
* One `kinds.yaml` in which each kind declares aliases, globs and verification ladder (chosen)

## Decision Outcome

Chosen: a `.vsect/kinds.yaml` at the root of each store: the project root for lite, and `sop/.vsect/kinds.yaml` for the SOP store.

- **Each kind declares** its canonical name, aliases, an ordered list of globs using `<kind>` and `<slug>` tags over explicit directories, and its verification ladder.
- **Explicit bindings** (kind:slug → path) are consulted first.
- **The first matching file whose frontmatter kind matches wins.** Frontmatter uses the canonical name; links may use aliases.
- **Notes for the future linter, not rules now:** report a later match as a collision, and write checked resolutions back into the bindings.
- **Agreed guards** (§1.6 "1--5, agreed"): every step checks the frontmatter kind; linting checks every step for collisions; resolutions are written back; archives and influx never answer (made automatic by the explicit directory lists); each kind declares its extensions.

### Quote

> Propose a format but I think it should show the resolution steps we discussed, except **/... is replaced by explicit {src,obj,def,...}/*.{ud,md,yaml} -- we can keep it bespoke and pragmatic for now-- literally a list of globs with <kind> and <slug> replacement tags, first match w/ correct frontmatter marker wins. … Another option is to merge the two and have each kind declare its alias(es) *and* the glob for where they're found. oh- just read your #8-- yes, that would add three things and allow us to really start to flesh out kinds from a tooling perspective...
>
> — Joseph, 2026-09-30 (`sop/influx/jaw-proposal-and-feedback.md` §1.7–§1.8)

### Positive Consequences

* Adding or changing a kind is an edit to one file, and needs no separate decision ("easy now to simply update the kinds.yaml", §1.9).

### Negative Consequences

* Resolution by glob fails silently when files move, until bindings and collision checks exist.

### What changes

* `.vsect/kinds.yaml` and `sop/.vsect/kinds.yaml` are created.

## Reopen when

* A store moves to a database (don), and globs stop being the address.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

* The guards were the agents' proposals, agreed by Joseph; the file format and merge are his.
