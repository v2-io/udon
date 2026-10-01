---
kind: objective
awaiting-second: true
awaiting-decision: true
needs-work: false
force:
per: [reserve-not-ignore, reserved-is-an-error]
depends: [def:document]
---

# Reserve, don't ignore

*Any «document» a lite parser accepts produces the same «tree» under every future full version of UDON; anything a future version gives meaning to is refused now.*

## Statement

1. For any «document» that a conforming lite parser accepts, a conforming parser for every future full version of UDON MUST produce the same «tree».
2. Every spelling that a future full version gives meaning to, and that lite does not define, MUST be reserved in lite. A lite parser MUST treat a reserved spelling as an error: it halts and reports what it found and where, and produces no «tree» for that «document».

## Grounds

- **The need, in Joseph's words.** "In the corpus right now we have a ton of need for this lite parser and tooling-- and I absolutely don't want them accidentally putting in essentially reserved syntax that would change the documents' behavior later unexpectedly" (2026-09-29, `.int/STEWARD-VERBATIM.md`).
- **The contract, in his words.** "It will *reserve* those other constructs so that the parser errors so that it is not used on documents whose behaviors or parsing result changes when run through a more full udon parser in the future" (2026-09-30).
- **Why refuse rather than keep the bytes.** "older 0.9 and 0.10 specs in udon (not lite) also deferred decisions about special syntaxes like ! directives and references-- but retained the bytes. That ambiguity caused a lot of confusion and made the language evolve a lot slower for a season-- hence the very deliberate call right now in udon-lite to go further and disallow them completely" (2026-10-01).
- **Decisions:** [[decision:reserve-not-ignore]], [[decision:reserved-is-an-error]].

## What discharges it

No threshold: lite's rules meet this objective or break it, and a derived property says which.

- the rules that list what is reserved and where ([[rule:reserved-spellings]]), written as a bare list ([[decision:reserved-list-form]]);
- what "accepts" means: no reserved spelling at least, and whatever else 12 Q1 decides ([[rule:valid-lite]]);
- [[prop:forward-stability]]: the claim that the rules actually meet clause 1, checked by someone other than its author.

## Epistemic status

An objective is chosen, not derived. What can be checked is whether the rules meet it, which is [[prop:forward-stability]]'s job.

## Discussion

- **It binds full UDON too.** Unless lite adopts a file marker (84 Q3), a later version may give new meaning only to spellings lite refuses. That follows from clause 1. The history of 09 shows why it matters: future spellings have repeatedly been chosen *because* they were plain text at the time.
- **It is the estate's first forward promise.** Joseph has said repeatedly that UDON owes nothing backward ("there is *zero* need for backwards compatibility", 2025-12-26 UTC; "no backward compatibility (that isn't very easily overcome) -- no public external usage yet", 2026-08-08 UTC; `~/.claude/history.jsonl` lines 5734 and 18791, located by `.int/principles-survey-2026-10-01.md` §3 N6). Once lite documents exist in the corpus, that freedom ends for whatever lite defines. That is what makes this objective expensive to get wrong, and why everything else lite decides is weighed against it.
- **It runs the opposite way from the usual forward-compatibility rule.** Formats like XML's extensibility conventions ask *old* readers to ignore what they don't know, so new documents still parse. Lite asks *new* readers (full UDON) to agree with everything lite accepted, and lite's own readers to refuse anything newer.

## Working notes

- **⟦force⟧ is empty: Joseph's call.** The udon team's lean is `critical`: Joseph calls it the first thing he decided about lite, and a break would silently change documents already written.
- **Open:** how much "the same «tree»" covers. If «meta» such as source spans is part of the «tree» (60, 13), a later version that counts columns differently (79) would break clause 1 although no spelling changed meaning.
- **Open:** the cost to prose. Under clause 2, a prose line starting `@alice` or `!important` may be refused (87, 09 Q1); see [[obj:markdown-text-passes-through]].
