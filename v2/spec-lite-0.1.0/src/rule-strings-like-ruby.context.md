# Context: [[rule:strings-like-ruby]]

*History and provenance for the card beside it, kept for whoever later wonders why the rule is what it is. Not spec text and not a record; nothing here binds.*

- **Before lite.** In the 0.10.0 draft a quoted string had no escapes: it ended at the next quote of its own kind, so a string holding both quote kinds, or a newline, had no single-line spelling (its L2; lite pre-design 75).
- **How it was decided (2026-10-08).** The agent put escapes to Joseph as three options, leaning C with raw single quotes:
  - A: strings take escapes; opaque spans keep "any `\X` gives `X`";
  - B: one rule everywhere, JSON's escapes plus the span's closer, any other `\X` an error;
  - C: as B, but any other `\X` kept as written.

  Joseph answered with his own option, opening "Not sure I saw this question": essentially Ruby's string rules. It differs from the agent's lean in two ways: single quotes take `\'`, so they aren't raw; and spans keep their own rule. Asked about two edges, he confirmed an unknown escape in `"…"` is an error and `#{…}` passes through as text.
- **How firm.** His words: "I think … should essentially be just like ruby strings"; on newlines, "I'm going to lean with you"; on the edges, "right" and "go ahead and error". On the escape list: "agree" (`\s`, surrogate pairs), "I can support" (`\v` `\a`), "I'm fine erroring as reserved for right now" (`\b`); the rest of the list is the escape-sequence report's proposal, relayed and unobjected; the `\u{…}` spacing details are an agent default (`.int/escape-sequences-2026-10-08.md`).
- **Records.** First written as the decision record `adr/quoted-strings-like-ruby.md` (2026-10-08, `steward`), folded into this card when cards became the decisions (2026-10-09) and retired; git keeps it.
- **His further words that day:** "I'm going to lean with you on disallowing newlines within delimited strings -- but allowing \n and other common escape sequences." And: "I *think* we actually have an improved set of escape sequences defined in the mainline old 0.9 udon spec if you want to send an agent looking for anything about it" (the search found none).
- **His string/text worry** (2026-10-08, "I do worry about "string" being its own distinct type from "text" :-)") is carried in [[def:string]].
