---
kind: objective
awaiting-second: true
awaiting-decision: true
needs-work: false
force:                    # not set: the udon team's call (see Working notes)
per: [reserve-not-ignore]
depends: [def:document]
---

# Reserve, don't ignore

*Any «document» a lite parser accepts produces the same «tree» under every future full version of UDON.*

## Statement

Clause 1 is the promise. Clause 2 is what lite's rules owe to keep it.

1. For any «document» that a conforming lite parser accepts, a conforming parser for every future full version of UDON MUST produce the same «tree».
2. Every spelling that a future full version gives meaning to, and that lite does not define, MUST be reserved in lite. A reserved spelling is recognized just well enough to be refused, and its bytes are kept. It is never read as ordinary text.

## Grounds

- **The problem it answers.** Joseph, 2026-09-29: "In the corpus right now we have a ton of need for this lite parser and tooling-- and I absolutely don't want them accidentally putting in essentially reserved syntax that would change the documents' behavior later unexpectedly."
- **Whose words these are.** Joseph asked for a lite that would "specifically *disallow* any grammar that is going to be used in the future (!,@,etc.)". The agent working with him proposed that "disallow" should mean *reserve*, not *ignore*, and wrote the promise that became clause 1: "any document a lite parser accepts produces exactly the same tree under every future full version." Joseph replied: "100% agreed on reserve, not ignore. That's definitely what I meant by deliberately disallowing it." So clause 1's wording is the agent's, and Joseph accepted it. `.int/README.md` §"The one contract" is a later rendering of the same exchange.
- **Alternatives set aside.**
  - *Ignore*: read future syntax as ordinary text. It is simpler to implement, but a «document» that is valid today could then quietly change meaning when full UDON arrives.
  - *A file marker* (84 Q3) is a complement, not a replacement. It would narrow what clause 2 has to reserve.
- **Decision.** `reserve-not-ignore`, seeded 2026-09-30 and not yet an ADR (see *Working notes*).
- **Source.** The quotes are from session `5930da5d-2aed-49ea-ac8b-ed619c1d6a0d` in `~/.claude/projects/-Users-josephwecker-v2-src-arch-firmatum-udon/`: Joseph's turns at 2026-09-29T23:55Z and 2026-09-30T00:02Z, and the agent's reply between them. In local time, all three are from the evening of 2026-09-29.

## What discharges it

No threshold: the rules themselves meet this objective or break it, and a derived property says which. None of these records is written yet, and naming the rules is the udon team's. Only the property has an outline row, so its link is reported as unwritten, not as a dangle ([[sop/decision:links-to-unwritten-records]]).

- the rules that refuse reserved spellings, and what the «tree» keeps for a refused spelling;
- what "accepts" means;
- if lite adopts a file marker (84 Q3), a marker rule. It would let a full parser read a marked file by lite's rules, and so narrow what clause 2 has to reserve;
- [[prop:forward-stability]], the claim that those rules actually meet clause 1. It can only be stated once they exist, and someone other than its author checks it.

Clause 1 binds full UDON's design as well as lite's rules. Unless there is a marker, a later version may give new meaning only to spellings that lite refuses. That follows from clause 1; it is not a separate decision. The history of 09 shows why it matters: future spellings have repeatedly been chosen *because* they were plain text at the time (`@<`, `@{`, a line-initial `!{`; `09-reserved-syntax.discussion.md`, "Threads worth noticing", item 1).

## Epistemic status

An ⟦objective⟧ is chosen, not derived, and no check makes it true. What can be checked is whether the rules meet it, and that is [[prop:forward-stability]]'s job. The objective is only as definite as its terms, and three terms in clause 1 are still open: "accepts", "every future full version", and how much of the «tree» "the same «tree»" covers. The questions are in *Working notes*.

No ⟦verification-level⟧ is written. The objective ladder in `.vsect/kinds.yaml` starts at `authorized`, which needs the decision as an accepted ADR, and that ADR doesn't exist yet.

## Working notes

- **⟦force⟧ is empty on purpose:** setting it is the udon team's ([[sop/dir:scope]]).
- **`per:` cites seeded decisions that are not ADRs yet** (`.old/vsect-init/DECISIONS.md`), so those entries dangle until the udon team converts them.
- **Open questions** bearing on it: 12, 09, 84 Q3, 60 (in `.int/pre-design/`).
