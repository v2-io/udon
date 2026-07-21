# UDON tour (non-normative pedagogy)

A progressive introduction. The contract lives in `../CORE.md`; this file only
builds a mental model.

---

## Level 1 — Prose with a little structure

UDON documents can look like Markdown with optional labeled blocks:

```udon
|article
  :author Ada

  UDON treats **documents and data** as the same thing.

  - lists still work
  - because `;` is the comment marker, not `#`
```

- `|article` opens an **Element** (a structural node).
- `:author Ada` is an **Attribute** (a labeled edge: “author of this article”).
- Indented lines are **Content** (prose or children).

---

## Level 2 — Whose name is it?

| Question | Use |
|----------|-----|
| Name describes the relationship to the parent | Attribute (`:headers …`) |
| Name describes what the thing *is* | Child Element (`\|header …`) |

```udon
|request
  :method POST
  :headers
    |header :name Content-Type :value application/json
```

---

## Level 3 — Identity and classification

```udon
|user[42].admin.active
  :email ada@example.com
```

- `[42]` → identity (`$key`)
- `.admin` `.active` → traits (`$traits`), ordered, stackable
- These are sugar for ordinary attributes (generators can write longhand)

---

## Level 4 — Values without the Norway problem

Type comes from **how you write it**, not from guessing:

```udon
|config
  :count 42
  :label "42"
  :on true
  :tags [a b c]
  :when <2025-01-03>    ; temporal dialect inside <…>
```

Bare `2025-01-03` is just a string. Temporal meaning requires `<…>`.

---

## Level 5 — Flow in prose

```udon
|p See the |{a :href /spec \ specification} for |{em details}.
```

- `|{…}` is an **inline Element** (structure inside text).
- Prefer Markdown for simple bold/italic when your renderer supports Layer-1.

---

## Level 6 — Dynamics (optional Dialect)

```udon
!if user
  Hello, !{{user.name | capitalize}}!
!else
  |a :href /login Sign in
```

Core only recognizes `!` forms; meaning comes from a Host Dialect.

---

## Heuristics worth keeping

1. **Attributes before children** on each Element.
2. **Spaces, not tabs**, for indent.
3. **Drop the braces** to bind an Element as an Attribute value; **keep braces**
   to put it in text: `:x |em hi` vs `:x |{em hi}`.
4. Same key twice **stacks** (keeps both), it does not overwrite.
5. When something looks wrong, check whether you are still in **attributes**
   or already in **content** (a late `:foo` is just text).

---

## Where to go next

- Cheat-sheet surface: `../../snippets/from-examples/cheatsheet.udon`
- Full contract: `../CORE.md`
- Vocabulary: `../GLOSSARY.md`
