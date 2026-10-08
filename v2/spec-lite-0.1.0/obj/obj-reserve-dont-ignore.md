---
kind: objective
awaiting-second: true
awaiting-decision: true
needs-work: false
force:
per: [reserve-not-ignore, reserved-is-an-error, forward-compat-aspiration]
depends: [def:document]
---

# Reserve, don't ignore

*Anything a future full UDON gives meaning to, and lite does not define, is refused now; beyond that, lite aims (as an aspiration, not a promise) for documents that full UDON reads the same way.*

## Statement

1. Every spelling that a future full version gives meaning to, and that lite does not define, MUST be reserved in lite. A lite parser MUST treat a reserved spelling as an error: it halts and reports what it found and where, and produces no «tree» for that «document».
2. As a design aspiration, not a promise: where practical, a «document» a lite parser accepts is read the same way by future full versions of UDON; where not practical, as compatibly as possible. «meta» is free to evolve beyond lite.

## Grounds

- **The need, in Joseph's words.** "In the corpus right now we have a ton of need for this lite parser and tooling-- and I absolutely don't want them accidentally putting in essentially reserved syntax that would change the documents' behavior later unexpectedly" (2026-09-29, `.int/STEWARD-VERBATIM.md`).
- **The contract, in his words.** "It will *reserve* those other constructs so that the parser errors so that it is not used on documents whose behaviors or parsing result changes when run through a more full udon parser in the future" (2026-09-30).
- **Why refuse rather than keep the bytes.** "older 0.9 and 0.10 specs in udon (not lite) also deferred decisions about special syntaxes like ! directives and references-- but retained the bytes. That ambiguity caused a lot of confusion and made the language evolve a lot slower for a season-- hence the very deliberate call right now in udon-lite to go further and disallow them completely" (2026-10-01).
- **Why an aspiration, not a promise.** "let us downgrade that to an aspiration, not a directive or promise. Opaque spans for example now will be their own branch in the AST later, among other things. We can say that's a design aspiration where practical, and where impractical we attempt to make it as "compatible as possible"." (2026-10-08).
- **Decisions:** [[decision:reserve-not-ignore]], [[decision:reserved-is-an-error]], [[decision:forward-compat-aspiration]].

## What discharges it

No threshold: clause 1 is met or broken by the reserved-spellings rule; clause 2 is reviewed, not tested.

- the rules that list what is reserved and where ([[rule:reserved-spellings]]), written as a bare list ([[decision:reserved-list-form]]);
- what "accepts" means: no reserved spelling at least, and whatever else 12 Q1 decides ([[rule:valid-lite]]);
- [[prop:forward-stability]]: a review of how far the rules meet clause 2's aspiration, checked by someone other than its author.

## Epistemic status

An objective is chosen, not derived. What can be checked is whether the rules refuse every reserved spelling (clause 1); clause 2 is a review, [[prop:forward-stability]]'s job.

## Discussion

- **It asks something of full UDON too.** Full UDON should aim to give new meaning only to spellings lite refuses. The history of 09 shows why it matters: future spellings have repeatedly been chosen *because* they were plain text at the time.
- **It is the estate's first forward commitment, held as an aspiration.** Joseph has said repeatedly that UDON owes nothing backward ("there is *zero* need for backwards compatibility", 2025-12-26 UTC; "no backward compatibility (that isn't very easily overcome) -- no public external usage yet", 2026-08-08 UTC; `~/.claude/history.jsonl` lines 5734 and 18791, located by `.int/principles-survey-2026-10-01.md` §3 N6). Once lite documents exist in the corpus, that freedom narrows for whatever lite defines: the refusal in clause 1 is firm, and clause 2 asks later versions to stay as compatible as practical.
- **It runs the opposite way from the usual forward-compatibility rule.** Formats like XML's extensibility conventions ask *old* readers to ignore what they don't know, so new documents still parse. Lite asks its own readers to refuse anything newer, and asks *new* readers (full UDON) to agree with what lite accepted wherever practical (clause 2, an aspiration).

## Working notes

- **⟦force⟧ is empty: Joseph's call.** The udon team's lean is `critical`: Joseph calls it the first thing he decided about lite, and a break would silently change documents already written.
- **The cost to prose** (under clause 1): decided 2026-10-08, a prose line starting `@alice` or `!important` is refused ([[decision:reserved-line-starts-in-prose]]). [[obj:markdown-text-passes-through]] should name those lines as collisions.
