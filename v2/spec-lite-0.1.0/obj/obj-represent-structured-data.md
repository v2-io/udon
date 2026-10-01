---
kind: objective
awaiting-second: true
awaiting-decision: true
needs-work: false
force:
per: []
depends: []
---

# Lite can carry the data people use JSON and YAML for

*Records, lists, and scalar values can be written in lite and read back as the same data, so lite can stand in for JSON or YAML as a data layout.*

## Statement

1. Lite MUST be able to represent records (named fields with values), lists (ordered values), and nesting of both.
2. Lite MUST be able to represent the scalar values such data holds, with each value's kind decided by how it is written.

## Grounds

- "a simple predictable data layout / xml equivalent / yaml-or-json alternative" (Joseph, 2026-08-30, `v2/INBOX-REQUESTS.md`).
- `.int/README.md`, "What lite is for": "The corpus already needs a basic, stable UDON *now*, for data and document layout: an XML/HTML, YAML, or JSON alternative." (A coordinator's rendering of the 2026-09-29 session; Joseph's own words for it are the line above.)
- Lite's first customer is vsect, whose records are data: "udon-lite is a prerequisite for vsect … we get to make sure that lite is particularly apt for us here" (Joseph, 2026-09-30, `.int/STEWARD-VERBATIM.md`, "Elsewhere").

## What discharges it

- the value rules ([[rule:unquoted-values]], [[rule:quoted-strings]], [[rule:implicit-typing]], [[rule:explicit-typed-values]], [[rule:lists]], [[rule:repeated-labels]]);
- the rules for values on the lines under a label ([[rule:values-below-the-label]]);
- a correspondence between lite trees and JSON and YAML, with what each loses stated ([[expl:data-mappings]]), and idiomatic fixtures converted from real JSON and YAML.

## Epistemic status

Chosen, not derived. Checkable by conversion: take real JSON and YAML data, write it in lite, and see whether anything has no spelling or comes back different.

## Discussion

- **How strong "the same data" is, is the main open question.** JSON tells `1` from `"1"`, and holds strings with any characters. Whether lite must round-trip every JSON value exactly, or serve the same purposes without being a lossless encoding, decides several rules:
  - a string with both quote kinds has no single-line spelling if lite strings have no escapes (75);
  - whether bare `8080` is an integer or a string (66, 72);
  - how a list of records is written (83);
  - whether `:x 1 :x 2` and `:x [1 2]` read the same (65).
- **Typing by spelling.** Joseph, 2025-12-31: "one of the main differentiators for UDON is the fact that it parses values instead of string+value-peeking like yaml has always done" (`~/.claude/history.jsonl` 6418). Any scalar typing lite does is by spelling, never by sniffing the content, which is what keeps `Norway` from becoming `false`.
- **The duplicate-key failure.** YAML's one silent, unrecoverable corruption is a duplicate key (the Dec-2025 stress test, quoted in `.int/principles-survey-2026-10-01.md` #7). Lite's answer to repeated labels (65) and repeated element keys (54) has to avoid it.

## Working notes

- **⟦force⟧ is empty: Joseph's call.** The udon team's lean is `required`: an intention for this version.
- Whether this should be "lossless for JSON" (stronger) or "fit for JSON's and YAML's uses" (weaker) is the first thing to ask him; the rules above differ under each.
