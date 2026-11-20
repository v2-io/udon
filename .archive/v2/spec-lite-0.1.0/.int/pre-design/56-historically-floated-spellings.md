# 56 — Spellings floated in the past but never adopted: plain text in lite, or reserved?

*Raised by the history survey (files 50–69), 2026-09-29. Neutral: the question, the alternatives, and where it has come up. Sources are pointers for the second pass, not authority.*

## The question

[09](09-reserved-syntax.md) Q1 asks whether lite should reserve spellings that *no current proposal* makes live. This file supplies the concrete candidates: forms that were proposed, used in examples, or briefly decided at some point in UDON's history, and that lite would otherwise read as ordinary text. For each, lite can **leave it as text** (a later revival would change the meaning of existing lite documents) or **reserve it** (costs whatever ordinary prose happens to contain it).

## Candidates (chronological by first appearance)

| Spelling | What it was | Where / when | What lite reads today |
|---|---|---|---|
| `:{label …}` | an inline ("embedded") attribute inside prose, attaching to the enclosing element — or, in 2026, one "not connected to any element" | `_older/udon-c/docs/DECIDED.md` (2011: "Inserted complex attribute, affecting the parent or root node"); Joseph 2026-01-03: *"I wonder also if we should allow inline attributes not connected to any element: `"Just like the other guy said." -- Fred :{src http://www.fred...} :{page 219}` — Or possibly that's just taking the symmetry too far :-)"* | text |
| `!{-name …}` | a directive run for effect, output discarded | DECIDED.md (2011); `overview.udon` (`:-expression{…}`) | reserved already (`!`) |
| `\|name{…}` / `!name{…}` | element / directive with a brace body | Dec 2025; Joseph 2025-12-27 rejected `!\w+{…}` because the parser can't know it's a directive until it reaches `{` ("*!some-really-…-long-directive is really just prose*") | `\|name` opens an element; `{…}` is its text |
| `<( … )>`, `<{ … }>`, `<: … :>` | 2011 embedded element / expression / interpolation brackets | `_older/udon/examples/overview.udon` | inside prose: text; at a value position: a `<…>` box ([07](07-untyped-angle-box.md)) |
| `#` comments, `#{…}`, `#\|` | 2011 comment forms (replaced by `;`) | `overview.udon`, `ws-and-comments.udon`, DECIDED.md | text |
| `\| text` (pipe-space) | an explicit text line / anonymous list item: `\|list \| one \| two \| three` | `overview.udon` (2011) | text (protects Markdown tables, [08](08-pipes-and-markdown-tables.md)) |
| `\|\| data` | anonymous element with immediate data | DECIDED.md (2011) | ? (`\|` followed by `\|`: fails the guard → text?) |
| `'\|`, `':`, `'!`, `';` | leading apostrophe as the line-start escape | Dec 2025 – Jan 2026 (Joseph 2026-01-01 table: `'\|abc` → `"\|abc"`); replaced by `\` | text, apostrophe kept |
| `\|[id]`, `\|{[id]}` | a reference spelled with `\|` instead of `@` | Joseph 2026-01-03 | anonymous element with a key |
| trailing `\` before the newline | "hard return" | Joseph 2026-01-03, 2026-01-13; 0.10.0 §7.4 keeps it as the explicit final newline | ruled in 0.10.0 — see [57](57-line-breaks-in-text.md) |
| ` \| ` (framed pipe-space) mid-line on an element's line | "the rest is the element's text," ending an open attribute value | Joseph 2026-07-15: *"I would also not mind `\|el :alpha something \| and this is the text child of \|el`... but it would be creating a whole new bag of problems... but it *looks* so good!"* — the framed ` \ ` took this job (K10/K13) | text inside the open value |
| `(…)` "shielded" label/value | parenthesis-delimited labels and values | DECIDED.md (2011) | text |
| a prefix-grouping form for attribute labels (Stylus-style) | DRY a shared prefix, desugaring to flat labels | OPEN **ATTR-GROUP** (Joseph 2026-08-07: *"I still don't mind it as basic nested naming convention to DRY the prefix"*); spelling undecided | depends on spelling |

## Alternatives

### A — reserve nothing beyond `!`, `@`, `!{{`

Everything in the table stays text (or whatever it is today). Revival of any of them later is a breaking change for lite documents.

### B — reserve a short list chosen from the table

For example `:{` in prose (the only row with a live open question behind it, ATTR-GROUP aside).

### C — reserve by shape: any `X{` where `X` is a marker character (`| ! ; : @`)

`|{`, `;{`, `!{` are already forms; `:{` and `@{` would join them as reserved. This gives one rule for brace forms.

## Interactions

- [09](09-reserved-syntax.md) Q1 and Q2.
- [06](06-suffix-characters.md): suffix characters, another retired-meaning family.
