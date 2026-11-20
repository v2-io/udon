# Pedagogy — outline + committed mental models

**Non-normative.** The full teaching *manual* stays deferred (P4): pedagogy prescribes one idiom where the spec allows many, and the idiom should be chosen against real usage evidence (the udon-needs corpus), not ahead of it. A **provisional baseline tutorial** covering only the settled core exists now at [TUTORIAL.md](TUTORIAL.md) (per Joseph's 2026-07-22 ask, which supersedes P4's outline-only for the baseline); this file holds the outline and the committed teaching choices the eventual manual builds on.

Principles held for the eventual write-up (from defining-udon.md): progressive disclosure; shape mental models with heuristics ("whose name is it?"); relate before naming; idiom over allowance; ruthless vocabulary consistency with GLOSSARY (one term everywhere — docs, errors, APIs).

## Ladder (draft)

1. **UDON as Markdown++** — prose, comments, one element with a tail.
2. **Structure** — elements, indentation/nesting, attributes, whose-name-is-it.
3. **Identity & classification** — `[key]`, `.trait`, flags `:ready?`, suffixes.
4. **Values** — bare scalars, quoting, lists, absent/nil/false/true.
5. **Text at scale** — content base, dedentation, `\`, fences vs `!:lang:`.
6. **Inline structure** — `|{…}`, `;{…}`, when to prefer Markdown.
7. **Envelopes** — `<…>` as "ask a dialect"; temporal as the worked example.
8. **References & reuse** — `@`, duplicates, mixin convention.
9. **Dynamics** — `!if`/`!for`/`!{{…}}` with the baseline dialect.
10. **Reading anomalies** — warnings vs errors; keep-everything; what `$partial-key` is telling you.

Each rung: one worked example, one footgun (from the usability corpus's measured error catalog — unbalanced `|{…}`, md-fence leakage, the node-value one-way door), one "you now know enough to…".

## The spine (2a's sequencing insight, committed to)

**The attribute-vs-child test and the open/commit model are the two ideas that predict everything else.** Every later surprise — ownership rows, the one-way door, the inline-form principle — is derivable from those two plus "columns are the syntax." Rungs 1–3 teach exactly these, in under five minutes, with one running example that grows.

## Mental models to install (heuristics, not rules — from 2a)

- **Columns are the syntax.** Everything closes by dedent; a line of nested elements *is* the vertical form written compactly. (The one diagram this manual must have: elements on one line with columns marked, then the same tree drawn vertically.)
- **A line starts open and commits.** Markers work until the first real word; after that everything is text except ` ; `. This replaces memorizing "where is `|` special?"
- **`\` = "the rest is text."** Teach the slogan, not four cases; then show it at line start and before `|{`.
- **Repeat a key to say it twice.** `:tag a :tag b` — UDON never overwrites.
- **When something looks wrong, nothing was thrown away.** Warnings mark spots; the content is all still there.

## Idiom over allowance (the one-way list — from 2a)

Where the spec allows several forms, the manual shows exactly one:

| Need | Teach | Not |
|---|---|---|
| emphasis, code, links in prose | Markdown | `\|{em}` / `\|{code}` |
| code blocks | `!:lang:` | fences |
| several values, one key | stack the key | trailing text after a value |
| map-valued attribute | named node carrier | attribute-under-attribute |
| element as a value | `:x \|node` (block form) | anything with braces |
| sibling layout after inline nesting | expand to vertical form when in doubt | clever column alignment |

(3b's `pedagogy/tour.md` — the whose-name-is-it worked table and its level-by-level running example — is the best existing draft of rungs 1–4; mine it when the manual is written.)
