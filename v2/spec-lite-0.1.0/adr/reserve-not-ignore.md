---
kind: decision
awaiting-second: true
awaiting-decision: false
needs-work: false
title: "Lite reserves future syntax rather than ignoring it, so no accepted document changes meaning later"
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
superseded-by: [{adr: reserved-is-an-error, how: revised, scope: partial}]
closes: []
leaves-open: ["09", "12 Q1", "84 Q3", "87"]
---

# Lite reserves future syntax rather than ignoring it, so no accepted document changes meaning later

## Context and Problem Statement

Joseph asked for a lite subset that "would specifically *disallow* any grammar that is going to be used in the future (!,@,etc.)". "Disallow" could mean two things: read the future spellings as ordinary text (ignore), or recognize them just well enough to refuse them (reserve). The agent proposed reserve, and wrote the promise that follows from it.

## Decision Drivers

* The corpus needs lite tooling now, and documents written for it must not change meaning when full UDON arrives (Joseph's own reason, under the Quote).
* "the same silent-retyping problem the frozen bare types exist to prevent" (**inferred, unconfirmed** as Joseph's: the agent's reason for reserve over ignore, 2026-09-29T23:56Z).

## Assumptions

* Agents and authors will write lite documents before `!`, `@` and interpolation are designed. (**recorded**: "In the corpus right now we have a ton of need for this lite parser and tooling")
* Full UDON will give new meaning only to spellings lite refuses, unless some marker lets a full parser read a file by lite's rules. (**inferred, unconfirmed**: this follows from the promise rather than being stated; 84 Q3 asks about a marker)
* Refusing a spelling is acceptable to authors, even where it costs ordinary prose (for example a prose line starting `@alice`). (**inferred, unconfirmed**: 87 and 09 Q1 ask how much this costs)

## Considered Options

* Ignore: read future syntax as ordinary text.
* Reserve: recognize future syntax just well enough to refuse it, keep its bytes, and report it (chosen).

## Decision Outcome

Chosen: reserve, because ignoring would let a document that is valid lite today quietly mean something else once full UDON arrives.

- A lite parser recognizes future syntax just well enough to refuse it. It keeps the bytes and reports that the spelling is reserved. It never reads future syntax as ordinary text.
- The promise this buys: any document a lite parser accepts produces the same tree under every future full version of UDON.
- Out of lite, and reserved: `!` in all its forms (including `!:kind:` code blocks), `@` references, and `!{{…}}` interpolation. Exactly which spellings, in which positions, is open (09). This list is the agent's (2026-09-29T23:56Z), under Joseph's own "(!,@,etc.)"; he didn't object to it, which is `supported` weight for the list itself, not `steward`.

### Quote

> 100% agreed on reserve, not ignore. That's definitely what I meant by deliberately disallowing it. In the corpus right now we have a ton of need for this lite parser and tooling-- and I absolutely don't want them accidentally putting in essentially reserved syntax that would change the documents' behavior later unexpectedly.
>
> — Joseph, 2026-09-29 evening (2026-09-30T00:02Z), `.int/STEWARD-VERBATIM.md`

> It will *reserve* those other constructs so that the parser errors so that it is not used on documents whose behaviors or parsing result changes when run through a more full udon parser in the future.
>
> — Joseph, 2026-09-30T16:02Z, describing lite to the aat-refactored session (`~/.claude/history.jsonl`; `.int/STEWARD-VERBATIM.md`, "Elsewhere")

*Whose words: the agent named the choice "reserve, not ignore" and wrote the promise ("any document a lite parser accepts produces exactly the same tree under every future full version"; its text is in the same file). Joseph's account of it, 2026-09-30: "it was a restatement of my very original explanation for what lite needed to be- so it was essentially the first thing decided by me that was communicated to an agent." So the decision is his own, `steward`; first recorded as `supported` (the default for an assent nobody asked about) and corrected on his answer.*

### Positive Consequences

* A lite document can be written today without risk of a later change in meaning.
* A lite parser reports what it can't handle, which is the "aware of what it can't do" behavior the 2026-08-30 tiny-parser request asked for.

### Negative Consequences

* Lite must decide, now, every spelling a future version might give meaning to. Without a file marker that includes spellings no proposal yet uses.
* Some ordinary prose may be refused.
* The corpus lite exists to serve already uses reserved forms. 09's history found `!:md:`, `!:sh:` and `!:text:` blocks in live vivarium and ASF documents, and `@{term}` about 190 times in `.ud` files (not re-counted here). Those documents are not valid lite as they stand.

### What changes

* Lite's first objective, [[obj:reserve-dont-ignore]] (now an `example` row), is to state this.
* (lite) Forward stability: this is the decision that makes forward stability a requirement at all.

## Reopen when

* A file marker (84 Q3) is adopted, and reserving less becomes possible.
* Refusal proves too costly for real prose (87), and some spelling needs a different treatment.
* Converting the live corpus's reserved forms proves too costly for documents lite is meant to serve.

*Reopening means a new decision that supersedes this one. This outcome is never edited in place.*

## Working notes

- Answered 2026-10-01: Joseph says the 2026-08-30 "warn" was wrong and a reserved spelling is an error that halts parsing; recorded in [[decision:reserved-is-an-error]], which replaces this record's "keeps the bytes".

