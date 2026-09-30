# 09 — Reserved syntax: exactly what lite refuses, and what the tree keeps

## Settled (Joseph, 2026-09-29)

**Reserve, don't ignore.** Future syntax is recognized just well enough to refuse it, so no lite-accepted document can change meaning later. Reserved families: `!` in all its forms, `@` references, and `!{{…}}` interpolation.

## Q1 — Exactly which spellings, in which positions?

What 0.10.0 recognizes, and what the proposal in `../../JOSEPH-FOR-0.10.01-FIX.md` would add (which lite must also keep open):

| Spelling | Where 0.10.0 recognizes it | Future proposals | Candidate lite rule |
|---|---|---|---|
| `!name …` | line start or same-line scan; `!` + identifier char | parsed like an element | reserved |
| `!:kind:` | same | block code | reserved |
| `!{…}`, `!{:kind:…}`, `!{{…}}` | inside text (flow) and value positions | `!{{` replaced by `@{…}` | reserved everywhere they'd be recognized |
| `@name`, `@[k]`, `@.t` | line start, same-line scan, value positions | selectors, later paths | reserved |
| `@{…}` | inside `[key]` brackets (K16) | also in prose (FIX proposal) | reserved in brackets **and in prose** |
| `@` + name inside prose (`email @joseph`) | literal text | none known | literal? or reserved? |
| `!` in prose (`!important`, `![img](x)`, `!=`) | literal text (fails guard / text-space) | none known | literal |

Sub-question: must lite reserve anything that *no* current proposal makes live, just in case (for example `@name` in prose)? Reserving more protects the future; reserving less keeps ordinary prose (`@mentions`, `!important`) clean.

## Q2 — What does the tree hold for a refused spelling?

```udon
|post :author @person[jw]
  !if @{admin}
    |panel
  Hello !{{name}}.
```

**A — error, and the bytes are kept as ordinary text or string values**

```text
document
└ element post
    author "@person[jw]"            ; anomaly: error, reserved `@`
    ├ text "!if @{admin}\n"         ; anomaly: error, reserved `!`
    ├ element panel                 ; ← or is this indented block text? (see Q3)
    └ text "Hello !{{name}}.\n"     ; anomaly: error, reserved `!{{`
```

**B — error, and the bytes are kept in a distinct `reserved` node or value**

```text
document
└ element post
    author reserved "@person[jw]"
    ├ reserved "!if @{admin}"
    │   └ element panel
    └ text "Hello " · reserved "!{{name}}" · ".\n"
```

**C — warning instead of error, with either keep shape**

## Q3 — What about the lines indented under a reserved line?

In full UDON a `!if` owns the lines below it. Should lite:

- **A)** treat them as children of the reserved node, as in B above;
- **B)** keep them as text of the reserved line; or
- **C)** parse them normally as if the reserved line weren't there?

## Interactions

- [12](12-missing-values-and-what-counts-as-valid.md): whether an error makes a document not-valid-lite.
- [11](11-code-blocks.md): `!:kind:` is reserved, so fences are lite's only code form.
- [06](06-suffix-characters.md): if suffixes are reserved (alternative C there).
