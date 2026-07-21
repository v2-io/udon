# Pedagogy outline (pillar 3 — sketch)

**Non-normative.** The teaching layer's shape, per the progressive-disclosure
and mental-model principles in `../defining-udon.md`. This is an outline with
the load-bearing choices made, not the finished manual.

## The disclosure ladder

Each level is usable on its own; nothing at a level requires vocabulary from
a later one.

1. **It's Markdown that holds together.** Plain prose is valid UDON. Write
   text; it belongs to the document. (`#` isn't special; tables survive.)
2. **Name things.** `|element` for structure, indentation for nesting, no
   closing tags. `:key value` for facts *about* a thing. The one test worth
   teaching immediately: *whose name is it?* — the parent's label → `:`,
   the thing's own name → `|`.
3. **Point and classify.** `[key]` makes an element findable (`@[key]`
   points at it); `.trait` says what kinds of thing it is. Flags: `:done?`.
4. **Structure inside sentences.** `|{em like this}` when Markdown can't
   say it; `;{notes to self}`. The one gotcha to teach here, with the
   teachable pair: *braces = text, no braces = the value* (`:x |{em hi}` vs
   `:x |em hi`).
5. **Values with types.** Quoting rules, numbers, lists, and the envelope:
   bare is only ever the boring seven; anything smarter goes in `<…>`.
   Teach the *why* in one line: your dates can never be Norway'd.
6. **Dynamics and verbatim.** `!if`/`!for`/`!{{x}}` (the host's language),
   `!:lang:` for code. Fences exist for the rare byte-exact case — teach
   `!:lang:` as the default.

## Mental models to install (heuristics, not rules)

- **Columns are the syntax.** Everything closes by dedent; a line of nested
  elements *is* the vertical form written compactly. (The one diagram this
  manual must have: elements on one line with their columns marked, then
  the same tree drawn vertically.)
- **A line starts open and commits.** Markers work until the first real
  word; after that everything is text except ` ; `. This replaces
  memorizing "where is `|` special?"
- **`\` = "the rest is text."** Don't teach four cases; teach the slogan,
  then show it at line start and before `|{`.
- **Repeat a key to say it twice.** `:tag a :tag b` — UDON never overwrites.
- **When something looks wrong, nothing was thrown away.** Warnings mark
  spots; the content is all still there.

## Idiom over allowance (the "one way" list)

Where the spec allows several forms, the manual shows exactly one:

| Need | Teach | Not |
|---|---|---|
| emphasis, code, links in prose | Markdown | `\|{em}` / `\|{code}` |
| code blocks | `!:lang:` | fences |
| several values, one key | stack the key | trailing text after a value |
| map-valued attribute | named node carrier | attribute-under-attribute |
| element as a value | `:x \|node` (block form) | anything with braces |
| sibling layout after inline nesting | expand to vertical form when in doubt | clever column alignment |

## Sequencing note

Levels 1–3 should be teachable in under five minutes with one running
example that grows (a small config or an article). The attribute-vs-child
test and the open/commit model are the two ideas that predict everything
else; every later surprise (ownership, the one-way door, the inline-form
principle) is derivable from them plus "columns are the syntax."
