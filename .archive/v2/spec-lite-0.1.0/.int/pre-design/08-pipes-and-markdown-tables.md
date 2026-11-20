# 08 — Pipes in text, and Markdown tables

## Settled (Joseph, 2026-09-29)

Whether lite gets a *structured* table construct is left for later. This file covers only how existing Markdown tables and pipe characters behave in lite.

## Current rule (0.10.0 §3)

`|` opens an element only when followed by a letter (`XID_Start`), `[`, `.`, `'`, `{`, or a suffix character (`? ! * +` — see [06](06-suffix-characters.md)). Otherwise `|` is ordinary text. In particular `| ` (pipe then space) is always text, so that Markdown tables survive.

## How common table shapes read under that rule

```udon
|doc
  | Name | Role |
  |------|------|
  |:-----|-----:|
  | jw   | dev  |
```
```text
document
└ element doc
    ├ text "| Name | Role |\n"
    ├ text "|------|------|\n"         ; `|-` fails the guard → text
    ├ text "|:-----|-----:|\n"         ; `|:` fails the guard → text
    └ text "| jw   | dev  |\n"
```

The spaced style and the divider row are safe. The **tight** style is not:

```udon
|doc
  |Name|Role|
  |jw|dev|
```

Here `|N` and `|j` pass the guard and open elements. What the rest of each line becomes is not clearly stated (a name ends at `|`; is `|Role|` then a same-line element? text?). Something like:

```text
document
└ element doc
    ├ element Name
    │   └ element Role …?          ; or $main "|Role|"?
    └ element jw …
```

Also: `a|b` mid-token in prose is text; `|` followed by a digit (`|2|3|`) fails the guard (digits aren't `XID_Start`), so that is text.

## Alternatives for lite

### A — leave the rule as is; document that tables must be written spaced

`| a |`, not `|a|`, or escaped: `\|a|b|`.

### B — add a rule: a line whose first non-space character is `|` and whose last is `|` is text (a table row)

This is new grammar, and it needs lookahead to the end of the line — does that fit 0.10.0 §2.3's bounded-lookahead law?

```udon
|doc
  |Name|Role|
```
```text
document
└ element doc
    └ text "|Name|Role|\n"
```

It would also catch a legitimate element such as `|p see the ||| here|`.

### C — tables live in a fence or a box for a Markdown vocabulary, not as prose

Heavier for authors; no new rule.

### D — reserve `|` followed by a name and immediately by another `|` (`|word|`) in lite

This keeps the future open for a table construct.

## Interactions

- [03](03-semicolon-in-prose.md): other prose-safety questions.
- Measured background: `theory/to-integrate/refine-more/markdown/commonmark-non-conflict-table.md` (all 652 CommonMark spec examples run through the parser; non-conflict held except fences).
