---
kind: definition
awaiting-second: true
awaiting-decision: true
needs-work: true
terms: [reserved]
per: [reserve-not-ignore, reserved-is-an-error]
depends: [def:anomaly]
consequences: [rule:reserved-spellings, rule:prose-line-start-reserved, rule:escaped-reserved-is-text, rule:nested-attributes]
---

# reserved

*Something is «reserved» when lite gives it no meaning and refuses it with an «error», so that a later version of UDON is free to give it one.*

## Terms

- **reserved:** said of a spelling or a construction that lite does not define and that a later UDON may. A «document» that contains one has an «error» ([[decision:reserved-is-an-error]]); escaping it, where lite defines an escape, makes it text ([[rule:escaped-reserved-is-text]]).

## Invariants

- Nothing «reserved» is ever read as text or ignored ([[decision:reserve-not-ignore]]).
- Everything «reserved» is an «error»; not every «error» concerns something «reserved» (an unclosed delimiter is malformed, not reserved).

## Examples

```udon
|post
  @alice said so.
|db
  :port
    :nested 1
```

`@alice` at the start of a prose line is a reserved spelling ([[rule:prose-line-start-reserved]]); `:nested 1` under an attribute is a reserved construction ([[rule:nested-attributes]]). Each is an «error».

## Avoid

"Joseph" marks his own words; everything else is an agent's or a spec draft's.

- **reserved = kept as bytes and passed on** — [[decision:reserve-not-ignore]]'s 2026-09-29 outcome ("It keeps the bytes and reports that the spelling is reserved"), `.int/reserved.md` ("A lite parser refuses these and keeps the bytes"), and 0.9/0.10's treatment of `!` and `@`. Joseph, 2026-10-01: "older 0.9 and 0.10 specs … deferred decisions about special syntaxes like ! directives and references-- but retained the bytes. That ambiguity caused a lot of confusion".
- **reserved = warn and continue** — Joseph's own 2026-08-30 tiny-parser request ("It would need to warn when there are constructs … that it encounters that it won't parse"), which he withdrew: "I was wrong about warn. It should error." (2026-10-01).
- **reserved = ignored on receipt** — the IETF/RFC sense ("reserved for future use; MUST be zero and MUST be ignored by receivers"), and XML's extensibility convention. Lite is the opposite: refuse.
- **reserved for `$key`, `$traits`, `$main`…** — Joseph, 2026-07-12: ""the non-reserved ones" -- I would be careful about calling them reserved instead of specially-designated ones or something..." (`history.jsonl` L15844); 0.10.0: "Designated, not reserved". The `$` attribute names are *designated*: they have meaning now.
- **refused** — the agent's word in the decision records ("refuse it", "refusal"). A fine verb, but not a separate term.
- **"not lite"** — used in cards as shorthand ("is not lite"). It reads as a verdict on the whole document, which is right for an «error», but it doesn't say whether the thing is reserved or malformed.

## Working notes

- **Not reviewed with Joseph.** Joseph, 2026-10-09: "I haven't looked at any or been asked about any of those things … but the idea that they can just kind of organically be whatever would cause serious trouble really soon if allowed to continue." Every term here is provisional until he rules on it; `.int/lexicon-inventory-2026-10-09.md` lists where each came from.
- **The word is Joseph's,** from lite's first message ("would specifically *disallow* any grammar that is going to be used in the future", 2026-09-29) through "It will *reserve* those other constructs so that the parser errors" (2026-09-30) to his 2026-10-08/09 uses below. The lexicon inventory lists it as settled. What's open is its scope and its noun.
- **Two senses in his use. *Reading (mine)*:**
  1. **Future syntax with a known direction:** `!` directives, `@name` references, `!{{…}}`. Something in full UDON is expected to use it.
  2. **A construction deliberately left undefined for now**, with no designed future meaning:
     - "nested attributes right now should be a reserved construction that causes an error in lite" (2026-10-08);
     - "newlines in embedded comments are simply reserved with error" (2026-10-08);
     - `\b`: "I'm fine erroring as reserved for right now" (2026-10-08);
     - the trailing backslash: "dropping trailing backslash *as a reserved construct that errors for now*" (2026-10-09);
     - "implicit missing value for attribute is not supported / reserved" (2026-10-09).

  Both senses come to the same rule: an «error» now, a later version free to define it. *Question:* is that one concept, or should sense 2 have its own word ("undefined", "unsupported", "not yet in lite")? Sense 2 doesn't promise that anything is coming; sense 1 suggests it.
- **The noun.** The cards say "reserved spelling" ([[rule:reserved-spellings]]). Joseph says "reserved syntax" (2026-09-30), "reserved construction" and "reserved construct" (2026-10-08/09), and "what characters or constructions are reserved" (2026-09-30). "Spelling" fits `@alice`. It doesn't fit "an attribute line owned by an attribute" or "a newline inside `;{…}`", which are positions or shapes rather than spellings. Yet [[rule:reserved-spellings]]'s table already lists such rows. "Construction" (his) covers both.
- **Register in error messages.** Joseph, 2026-10-08: the newline-in-span error should say "'**lite** doesn't support newlines in ....' so that it doesn't get accidentally adopted in non-lite settings as a prohibition." *Reading:* the user-facing register he wants is "lite doesn't support X", which says "not here, not never". "Reserved" is the spec's word; "not supported in lite" is the message's. That split may be worth stating in [[view:anomalies]].
- **What the word invites.** "Reserved word" suggests a list of *words* (Java `goto`, ECMAScript's future reserved words). Lite reserves characters in positions (`@` at a prose line start but not mid-line) and line shapes (nested attribute lines). A reader expecting a keyword list may miss the positional ones. [[rule:reserved-spellings]] answers with its "Where" column.
- **Precedents that error, as lite does:**
  - YAML 1.2.2 §5.3: "The "@" (x40, at) and "`" (x60, grave accent) are reserved for future use", and a plain scalar cannot start with them;
  - ECMAScript future reserved words such as `enum`, a SyntaxError (from memory, not re-checked);
  - Java's `goto` and `const` (from memory).
  - *Contrast:* YAML says unknown directives should be ignored with a warning, and RFC fields are ignored on receipt.
- **My lean (this agent's):** keep «reserved» (his, and it says the right thing about the future); define it to cover both senses, since they share their rule and his use already spans them; prefer his "construction" over "spelling" as the noun the definition uses; keep "lite doesn't support …" as the message register.
