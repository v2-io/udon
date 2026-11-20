---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "Lite uses the addressing theory's vocabulary where it applies"
status: accepted
decided-by: steward
decided: "2026-09-29"
updated: 2026-09-30
deciders: [Joseph (steward)]
consulted: [udon agent of session 5930da5d (agent, Opus 5.5)]
informed: []
wording: rendering
grounds-recorded: at-decision
supersedes: []
superseded-by: []
closes: []
leaves-open: ["77"]
---

# Lite uses the addressing theory's vocabulary where it applies

## Context and Problem Statement

Lite needs words for identity (keys, names, what a key stands for). The udon addressing theory defines them in `v2/references/def/`. But lite has no addressing at all: references are reserved syntax.

## Decision Drivers

* One vocabulary for identity across the udon work.

## Assumptions

* The addressing theory's terms are the core terminology for identity and referents. (**recorded**)
* Most of its terms still apply to a language with no addressing, with the possible exception of containment. (**recorded**)

## Considered Options

* Lite defines its own identity vocabulary.
* Lite adopts the addressing theory's, where it applies (chosen).

## Decision Outcome

Chosen: lite adopts the vocabulary in `v2/references/def/` wherever it applies, extending it if needed. Lite doesn't necessarily add to the addressing theory's `def/`: lite's own terms live in its own store.

Which terms apply was partly settled the same night:

- **Out**, at Joseph's direction ("Remove from lexicon entries that are not applicable to lite- like dangle"): dangle; and, by the agent on that direction, reference, referent, designator and generator (which name reserved syntax).
- **Kept**, by "with the possible exception of containment we will still want the rest": name, binding, mint, maintainer, collide, scope, containment (possibly not), root-scope, location.
- **Since unsettled:** root-scope was then dropped on the agent's own analysis after Joseph asked "are you *sure* root-scope is the same as the root node?", which he didn't confirm; and he flagged scope itself as undecided ("ID scoping" is on his short list).

### Quote

> Let's decide right now to adopt (and extend if we need to) what little we have in v2/references/def/** -- which should be our core terminology for identity, referents, etc.

> OK-- let's not necessarily add to addressing theory's def/ directory-- but let's start a spec-lite-0.1.0/lexicon.md and get our definitions nailed down nicely. …

> Remove from lexicon entries that are not applicable to lite- like dangle

> I may have been rash emphasizing addressing theory terms, as lite is very specifically and conspicuously missing addressing. But with the possible exception of containment we will still want the rest. (are you *sure* root-scope is the same as the root node?)
>
> — Joseph, 2026-09-29 evening (2026-09-30T02:04Z, 02:12Z, 02:14Z, 02:17Z), `.int/STEWARD-VERBATIM.md`

*His own call, so `steward`. The lists of what was removed and what remained are the agent's (02:14Z), on his direction. The `lexicon.md` in the second quote is replaced by [[decision:lite-lexicon-in-def]].*

### Positive Consequences

* Lite's identity terms will mean the same as the addressing theory's when full UDON adds addressing.

### Negative Consequences

* Some kept terms describe upkeep lite can't yet do (for example, collide without references to collide on), so each lite definition must say what the term covers in lite.

### What changes

* Lite's definitions cite `[[references/def:<slug>]]` rather than restating those terms.

## Reopen when

* The addressing theory's terms change in a way that no longer fits lite's identity model.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

- **Key: name or designator?** Joseph asked (02:12Z) whether 'designator' rather than 'name' is the term for what UDON calls a key, "correct me if I'm wrong". The agent answered (02:13Z) that under the addressing theory's third edition the key is the *name*, and designator is the use side (a future `@user[jw]`). He didn't respond; it is his to confirm when the key rule (77) is written.
- **"Lite is very specifically and conspicuously missing addressing"** is a scope statement in its own right; it may want citing from the reserved-syntax rule.
