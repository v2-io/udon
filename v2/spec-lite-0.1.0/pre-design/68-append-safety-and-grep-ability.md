# 68 — Should lite guarantee append-safety and first-line greppability, and what would that forbid?

*Raised by the history survey (files 50-69), 2026-09-29, second continuation. Neutral: the question, the alternatives, and where it has come up. Sources are pointers for the second pass, not authority.*

## The question

The largest live UDON document (`arch/vivarium/DECISIONS.decision-log.udon`, ~1700 lines, started 2026-07-12) is written to two stated properties, in its own header:

> *FAST-APPEND, INTERLEAVE-FREE: … an agent can APPEND a new decision cheaply (e.g. `>>`) WITHOUT first reading the file, and concurrent appends don't garble: each |decision is a SELF-CONTAINED, TOP-LEVEL block (starts at column 0). There is NO wrapping parent element — so a new entry is appended at EOF with no need to read, parse, or re-close anything above it. Append the whole block in ONE write, preceded by a single blank line. O_APPEND makes a single write() atomic on POSIX.*
>
> *⚠ :supersedes GOES ON THE |decision[...] LINE ITSELF — never on its own line — so that `grep '^|decision\['` yields the whole supersession chain in one read.*

The udon-needs gathering (`udon-needs/01-ideation/02-provenanced/commentary/I5-live-consumers-witness.md`, need class 5) records this as a demand: "append-friendly docs (no forced single-root wrapper) + concurrent append", and need class 3: "`[key]` identity density for greppable first lines".

Should lite state, as a property of the language, that **appending a well-formed top-level block to the end of any well-formed lite document never changes the meaning of the bytes already there**, and that **an element's identity and attributes can be found from its first line**? Or is that a usage convention outside the spec?

## What could break the property today (0.10.01 as read)

| Prior tail | Appended block | What happens |
|---|---|---|
| final line without a newline | `\n|decision…` needs the writer to add the newline; a bare `>>` of `|x…` glues onto the last line | EOF is newline-equivalent (§11.3) but appending is a byte operation, not a line operation |
| an unclosed inline `|{…}` or `!{…}` (delimited, multi-line) | the appended block becomes part of its extent | delimited closers win over geometry (DELTAS 12); the block is swallowed, with a Warning citing the opener |
| an unclosed fence ` ``` ` | absorbed as fence content | the fence closes only at a line starting with ` ``` ` |
| an unclosed `"…"` / `'…'` quote value | swallowed if strings may span lines ([75-quoted-strings](75-quoted-strings.md), other survey, unread) | see [05](05-values-across-lines.md) |
| an unclosed `[key` identity bracket | not affected: identity brackets have an EOL fail-safe (§ delimited-spans table) | `$partial-key` + Warning |
| tail ends inside an indented text block / element | a column-0 line is a dedent to the top level | fine, by geometry |
| a blank line before the block | ornamentation only | fine |

So the geometric constructs (elements, assignments, text blocks) are append-safe by construction; the *delimited* ones are safe only when closed. A lite spec that promises append-safety has to say what an unclosed delimited construct means for the *next* block, i.e. give each delimited construct an EOL or dedent fail-safe as brackets already have.

## Alternatives

### A — a stated lite property, with fail-safes on every delimited construct

Lite says: geometry closes everything, and every delimited form either fits on one line or has a declared fail-safe boundary such as a column-0 line. Cost: constrains multi-line `|{…}`, multi-line quoted strings and fences (for example, "a column-0 line always closes an open span, with a Warning").

### B — property stated only for documents that parse without Warnings

Appending to a *clean* document is safe; appending to a broken one is the writer's problem. No new grammar rules, weaker promise (the tail state is exactly what a concurrent writer cannot see).

### C — a convention documented in the tutorial (top-level blocks, `>>`, the one-line-header rule), not a language property

What the vivarium document does today; costs the language nothing and promises nothing.

## Sub-questions

- Greppability is a *style* property with a hard syntactic edge: `grep '^|decision\['` works only if the identity and every attribute the reader needs sit on the first line. What if lite let attributes live on later lines (see [88-where-attribute-lines-may-sit](88-where-attribute-lines-may-sit.md), other survey, unread)? Does lite want to promise or recommend "all identity-bearing attributes on the element line"?
- A document with **no wrapping root** is the norm here (`forest` in the greenfield MODEL; [04](04-root-and-top-level-text.md)). Append-safety depends on it.
- If a lite writer appends at column 0 after an *indented* tail, do blank lines or comment banners at column 0 (the vivarium logs use `; ──…` banners) change ownership of what follows? See [55](55-which-node-owns-a-blank-line.md), [78-what-a-comment-owns](78-what-a-comment-owns.md) (other survey).

## Where it came up

- `arch/vivarium/DECISIONS.decision-log.udon` header (2026-07-12); Joseph's `:supersedes` placement ruling recorded inside it: "(Joseph, 2026-07-12.)".
- `udon-needs` I5 witness, need classes 3 and 5; `CONSUMERS.md` (DECISIONS: "heaviest temporal exposure, actively growing (897→903 lines within hours)").
- `spec-0.10.01/CORE.md` §11 (EOF ≡ end-of-line + full dedent; delimited constructs keep and warn) and DELTAS 12 (delimited spans law and declared fail-safes).

## Interactions

[04](04-root-and-top-level-text.md), [05](05-values-across-lines.md), [10](10-inline-elements-and-inline-comments.md), [11](11-code-blocks.md), [55](55-which-node-owns-a-blank-line.md).
