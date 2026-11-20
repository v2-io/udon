# 50 — Inside `|{…}`: where does an attribute's value end and the inline element's text begin?

*Raised by the history survey (files 50–69), 2026-09-29. Neutral: the question, the alternatives, and where it has come up. Sources are pointers for the second pass, not authority.*

## The question

`|{a :href /docs the docs}` is the canonical HTML-link idiom, used in examples since at least December 2025. Is `the docs` the link's **text**, or part of `href`'s **value**?

## Why lite must decide

`|{…}` is in lite specifically for the XML/HTML use case, and this is the most common shape an inline element takes. The texts disagree:

- **The same question arises for block elements.** Joseph, 2026-07-11, illustrating something else (head position): `|p` ⏎ `  hello there` ⏎ `  |a :src http://google.com THE BEAST` ⏎ `  , how are you doing?` — written as if `THE BEAST` were the link text. Under K10 it is part of `src`'s value (or, if `src` ended at the space, `$main`, not content).
- **Pre-0.9 CORE and the greenfield rewrites (Dec 2025 – Jul 2026)** show `|{a :href /foo a link}`, `|{a :href / Home}`, `|nav |{a :href /about About}` as attribute-plus-text. Under the old "bare-token boundary" rule a single bare token finished the value, and the rest was content.
- **Joseph, 2026-07-16** (ruling R2 of the 0.9 review, the day after the "greedy text value" attribute model landed): *"Add the following too: `|{a :href /home :title Home \ Welcome home!}` and note that the following will probably be added once dialects are good to go: `|{a :href /home :title Home \ Welcome home! ; hope that helps}` (but that it will have unspecified results in 0.9)."* The framed ` \ ` is the breakout into the inline element's content; the greenfield CORE (2026-07-19) gives `title = "Home"; content " Welcome home!"` and `|{a :title "Home" here}` → `title = "Home"; content "here"`.
- **K10 (2026-08-08)** made an unquoted text value run until a framed marker, a framed ` ; `, a framed ` \ `, end of line, or the context terminator (`}` inside an inline element). 0.10.0 §6.4/§6.6 state this uniformly for inline elements. Read literally, `href = "/docs the docs"` and the element has no text.
- **0.10.0 TUTORIAL §8 (and 0.9.1's)** still shows `|p Deploy uses |{a :href /docs/deploy the deploy guide} — read it first.` as a link with text, which only works under the pre-K10 reading.
- Pre-design [10](10-inline-elements-and-inline-comments.md)'s example tree also assumes the pre-K10 reading.

## Alternatives

### A — K10 applies inside braces (0.10.0 as written)

```udon
|p See |{a :href /docs the docs}.
|p See |{a :href /docs \ the docs}.
|p See |{a :href "/docs" the docs}.
```
```text
document
├ element p
│   $main "See " · inline a(href "/docs the docs") · "."
├ element p
│   $main "See " · inline a(href "/docs"; " the docs") · "."     ; framed \ breaks out (spacing?)
└ element p
    $main "See " · inline a(href "/docs"; "the docs") · "."       ; quoted value self-terminates, rest is interior
```

### B — inside an inline element, an unquoted attribute value is one token; the rest is the element's text

```udon
|p See |{a :href /docs the docs}.
```
```text
document
└ element p
    $main "See " · inline a(href "/docs"; "the docs") · "."
```

A multi-word value then has to be quoted: `|{abbr :title "HyperText Markup Language" HTML}`.

### C — the same one-token rule everywhere (on element lines too)

This is the pre-K10 rule restored generally. It reverses K10 and K9's "sameline is value-space" direction, so it is listed only for completeness.

## Sub-questions

- Under A, what exactly does the framed ` \ ` leave as text — `" the docs"` or `"the docs"`? (0.10.0: "leading spaces preserved.")
- Is a separate rule for "inside braces" a least-surprise cost, or does it match what HTML authors expect?

## Where it came up

- `_archive/SPEC-UPDATE.md` (Dec 2025), pre-0.9 CORE "Inline Elements" section, greenfield `CORE.md` (Jul 2026): `|{a :href /home here}` as attribute + content.
- `v2/DECISIONS.md` K10 (2026-08-08); `spec-0.10.00/CORE.md` §6.4 "Unquoted text values," §6.6 context table (inline element row: post-value material goes to "the inline element's interior content").
- `spec-0.10.00/TUTORIAL.md` §8 line 113.

## Interactions

- [02](02-escape-inside-open-value.md): the framed/attached `\` distinction is the breakout tool under A.
- [10](10-inline-elements-and-inline-comments.md): inline element rules generally.
