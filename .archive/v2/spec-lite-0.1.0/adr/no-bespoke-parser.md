---
kind: decision
awaiting-second: true
awaiting-decision: true
needs-work: false
title: "No bespoke reference parser for lite now; descent's grammar is the reason"
status: accepted
decided-by: supported
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
leaves-open: []
---

# No bespoke reference parser for lite now; descent's grammar is the reason

## Context and Problem Statement

On 2026-08-30 Joseph asked for tiny, dependency-free "simplified udon" parsers in several host languages (`v2/INBOX-REQUESTS.md`). On 2026-09-29 the agent proposed delivering lite as a short spec, a fixture file, and "a small reference parser in Python that runs the fixtures", and asked whether to build the parser in that pass.

## Decision Drivers

* Bespoke parsers have not kept up with the language's changes and nuance; the descent grammar has. (**recorded**, under the Quote)

## Assumptions

* Lite is close enough to mainline UDON that the descent grammar can carry it. (**recorded**: "very, very similar to the actual mainline udon")

## Considered Options

* Build a small bespoke Python reference parser now (the agent's offer).
* Don't; rely on the descent grammar (chosen).

## Decision Outcome

Chosen: no bespoke reference parser is built for lite now. Joseph's reason is that bespoke parsers were thrown away because they couldn't follow the changes and nuance, while the descent grammar does.

Not decided here:

- **Which grammar artifact lite's parser comes from.** In the same sentence Joseph calls mainline "the actual mainline udon that we are replacing here in v2", so "descent" may mean the descent approach and toolchain rather than the existing 0.9 grammar file.
- **Whether this sets aside the 2026-08-30 tiny-parser request**, or only answers the offer to build one now.

### Quote

> This "lite" is very, very similar to the actual mainline udon that we are replacing here in v2-- and which already has a lightning fast recursive descent declarative grammar definition-- there have been a handful of agents that have built tiny bespoke python parsers that got thrown away because they couldn't reliably follow the changes and the nuance very easily compared to the descent grammar. So I'm really not worried about "Making sure same-line capture works" (not sure what you're quoting there).
>
> — Joseph, 2026-09-29 evening (2026-09-30T00:18Z), `.int/STEWARD-VERBATIM.md`

*The reasoning is his. His words answer why he isn't worried about testing same-line capture; reading them as a decision not to build the offered parser is the agent's, so `supported` (no objection on record), and the open parts above are his to settle.*

### Positive Consequences

* One grammar to keep in step with the spec.

### Negative Consequences

* Until a descent-generated lite parser exists, lite's fixtures have nothing to run against.

### What changes

* Lite's fixtures are written to be run against a descent-generated parser.

## Reopen when

* Lite diverges far enough from mainline that a shared grammar becomes a burden.
* The tiny-parser request turns out to be still wanted alongside it.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

- **For Joseph:** does "descent" here mean the descent approach and toolchain, or the existing 0.9 grammar? And is the 2026-08-30 tiny-parser request set aside, or still wanted for later?
