# 89 — Empty and degenerate forms: what each one produces

## The question

Small shapes that every parser meets in real files and tests, several with no stated answer:

```udon
|                     ; a pipe alone on a line
|[]                   ; nameless element, empty key
|el[]  |el[ ]         ; empty key, closed
|{}                   ; empty inline element
|el ""                ; element-line text that is an empty string
|el :a "" :b [] :c [ ] :d <> :e \
|el                   ; element followed only by blank lines, then end of file


:                     ; a colon alone
;                     ; a semicolon alone
```

## Why lite must decide

Fixtures in three languages will disagree on these first. Each needs one of: a value, an empty node, text, or an anomaly.

## What the texts say

- **2011, `udon-c/docs/DECIDED.md`:** "`|[]` would be an anonymous node with no id or classes"; "`|| some data`" for immediate data. **2011 `syntax2.udon`:** a lone `|` is a nameless element; `| there` a nameless element with text.
- **2026-07-18 rulings** (CHANGELOG): closed whitespace-only brackets: `|el[ ]` → nil key; `[ ]` → empty list; a closed empty `<>` stays the no-dialect text for now ("the `< >` → nil collapse is a dialect-era refinement"). An *unclosed* whitespace bracket keeps its whitespace.
- **2026-07-19:** `|{}` "a valid, empty anonymous embedded ELEMENT"; `:a \` is a kept empty string.
- **0.10.0 §3:** `|` is an element only when followed by a name start, `[`, `.`, `'`, `{`, or `? ! * +`; so a lone `|` (followed by end of line) is text. `:` followed by space or end of line is text. `;` at line start is a comment even with nothing after it (EOF ≡ newline).
- **`spec/TODO-SPEC-CORE.md`** (2026-07-16 silences): "empty identity bracket `|el[]` — empty key, or a key whose value is the empty list `[]`?" (later ruled nil for the closed-whitespace case; `[]` with nothing inside is not separately stated).

## Alternatives, per form

| Form | Candidate readings |
|---|---|
| `\|` alone | text "\|" (0.10.0) · empty nameless element (2011) · reserved |
| `\|[]`, `\|el[]` | nil key · empty-string key · empty-list key · no key at all |
| `\|el ""` | element-line value "" · text of two quote marks (file 73) |
| `:b []` vs `:c [ ]` | both empty lists · `[]` something else |
| `:d <>` | empty box (file 07 Q4) · nil · text "<>" |
| element + trailing blank lines at EOF | blank lines kept in the element · dropped as layout (file 13 Q5) |
| `:` alone, `;` alone | text · empty comment |

## Interactions

- [07](07-untyped-angle-box.md) Q4, [12](12-missing-values-and-what-counts-as-valid.md), [13](13-ast-shape.md) Q5, [73](73-is-the-element-line-a-typed-value.md), [77](77-identity-keys-and-traits.md).
