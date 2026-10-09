---
kind: definition
awaiting-second: true
awaiting-decision: true
needs-work: false
terms: [anomaly, error, warning]
per: [errors-stop-parsing, reserved-is-an-error]
depends: [def:document]
consequences: [rule:no-break-space-counts-as-space, rule:column-shifting-whitespace-error, rule:unclosed-delimiter-is-error]
---

# anomaly · error · warning

*An «error» stops parsing: there is no «tree». A «warning» marks correct lite that may not do what was meant: the «tree» is produced and carries it.*

## Terms

- **anomaly:** an «error» or a «warning» a parser reports, with where it is.
- **error:** something a lite «document» may not contain. Parsing stops, the parser reports what it found and where, and no «tree» is produced. A «document» with no «error» is valid lite.
- **warning:** something that "*is* technically correct udon/udon-lite and does do a specific thing-- but possibly not what you intended it to do" (Joseph). The «tree» is produced; the «warning» travels with it.

## Invariants

- An «error» and a «tree» never come together.
- A «warning» never makes a «document» invalid.
- "Error" here means *not lite*, not mainline UDON's "something was lost".

## Working notes

- **Not reviewed with Joseph.** Joseph, 2026-10-09: "I haven't looked at any or been asked about any of those things … but the idea that they can just kind of organically be whatever would cause serious trouble really soon if allowed to continue." Every term here is provisional until he rules on it; `.int/lexicon-inventory-2026-10-09.md` lists where each came from.

- **Joseph's words** (2026-10-08, `.int/STEWARD-VERBATIM.md`):
  > My current lean is that any *error* right now is a failure / stop. … Disallowed == error == stop/fail. In some ways it will be treated more like a standard programming language, where something missing a closing delimiter is just a straight-up error and halt and you've done something wrong. Whereas *warnings* are for "this *is* technically correct udon/udon-lite and does do a specific thing-- but possibly not what you intended it to do..."

- Whether a parser reports only the first «error» or several is open.
- Each card states its own errors and warnings; the full list is a companion view generated from them.
