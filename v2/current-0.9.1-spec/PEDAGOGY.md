# Pedagogy — outline stub

**Non-normative; deliberately an outline only** (ruled P4: pedagogy day one
is outline, not prose). The teaching pillar is written after the demand
side settles what idiomatic UDON *is* — pedagogy prescribes one idiom where
the spec allows many, and the idiom should be chosen against real usage
evidence (the udon-needs corpus), not ahead of it.

Principles held for the eventual write-up (from defining-udon.md):
progressive disclosure; shape mental models with heuristics ("whose name is
it?"); relate before naming; idiom over allowance; ruthless vocabulary
consistency with GLOSSARY (one term everywhere — docs, errors, APIs).

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
10. **Reading anomalies** — warnings vs errors; keep-everything; what
    `$partial-key` is telling you.

Each rung: one worked example, one footgun (from the usability corpus's
measured error catalog — unbalanced `|{…}`, md-fence leakage, the node-value
one-way door), one "you now know enough to…".
