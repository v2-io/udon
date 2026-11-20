# spec-lite-0.1.0 — reserved syntax

A lite parser refuses these and keeps the bytes. The exact positions and the shape of the refusal are still open ([pre-design/09](pre-design/09-reserved-syntax.md)).

| Reserved | Where |
|---|---|
| `!` followed by a name character: `!name` | at the start of a line, in a same-line scan, in value positions |
| `!:` — `!:kind:` | same |
| `!{` — `!{name …}`, `!{:kind: …}`, `!{{…}}` | anywhere it would open, including prose |
| `@` followed by a name character, `[`, `.`, `{`, or `<`: `@name`, `@[k]`, `@.t`, `@{…}`, `@<…>` | at the start of a line, in a same-line scan, in value positions, inside `[key]` brackets |
| `@{` | anywhere it would open, including prose |

**Still open** (09, 56, 62, 87):
- `@name` and `!word` at the start of a prose line, and mid-prose
- `<{` and `<"` forms
- spellings floated in the past but never adopted
