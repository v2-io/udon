---
kind: objective
state: [drafted]
per: [reserve-not-ignore]
depends: []
questions: ["09", "12", "84"]
max: decided
---

# Reserve, don't ignore

*Any document a lite parser accepts produces the same tree under every future full version of UDON.*

## Statement

This objective constrains the rule set, not parsers directly:

- Every spelling that a future full UDON gives meaning to, and that lite does not define, MUST be reserved in lite. A reserved spelling is recognized just well enough to be refused; it is never read as ordinary text.
- For any document that a conforming lite parser accepts, every future full UDON parser MUST produce the same tree.

## Grounds

- **The problem it answers.** Lite ships before `!` and `@` are designed. Without this objective, a document written today could silently change meaning when full UDON arrives, and nobody would learn about it until then.
- **Alternatives set aside.** *Ignore* (read future syntax as plain text) is simpler to implement but breaks the promise above. *Version-marked files* are raised in 84 Q3 as a complement, not a replacement.
- **Decision.** `reserve-not-ignore` in `../DECISIONS.md`.

## What discharges it

This objective is met by rules plus one derived property, none of which are written yet:

- the reserved-spelling rules ([[rule-reserved-spellings]]) and what the tree keeps for them ([[rule-reserved-keep-shape]]);
- the definition of "accepts" ([[rule-valid-lite]], question 12 Q1). Under 12's option B, every warning's keep-shape becomes a permanent promise;
- [[prop-forward-stability]], the claim that the rule set actually meets this objective. It can only be stated once the rules above exist.

## Epistemic status

Objective; `max: decided` because it is a choice, not a truth-apt claim. Two terms in the statement are still open, and the objective is only as definite as they are:

- **"Accepts"** is open (12 Q1).
- **"Every future full version" covers only spellings lite reserves.** 84 notes that without a file marker, lite must reserve everything that could ever change meaning, including `@name` in prose (09 Q1). How much to reserve is a steward-purpose question (09 Q1, 87).

## Working notes

- The wording of the italic line is carried from `../influx/README.md` §"The one contract". That README records the decision as Joseph's but is the coordinator's rendering; Joseph's verbatim words are not in this repo as far as I searched (README, STEWARD, pre-design/README).
