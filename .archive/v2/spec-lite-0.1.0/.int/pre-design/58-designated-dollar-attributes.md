# 58 — The designated `$` attributes: names, hand-written forms, and whether traits are always a list

*Raised by the history survey (files 50–69), 2026-09-29. Neutral: the question, the alternatives, and where it has come up. Sources are pointers for the second pass, not authority.*

## The questions

Lite keeps `[key]` and `.traits` as sugar for designated attributes (`$key`, `$traits`; also `$main` for element-line text). Three details the history keeps returning to:

1. **Traits always a list?** Under the stacking "default read" (K15: one contribution reads as the value, several read as a list), `|el.a` gives `$traits "a"` and `|el.a.b` gives `$traits ["a" "b"]`. Joseph has twice asked for traits to be a list even with one member.
2. **Hand-written `$` attributes.** Is `|el :$key jw` exactly the same tree as `|el[jw]`? Is `|el :$main hello` the same as `|el hello`? What about `:$traits a` written on its own line under the element, or `:$foo` (a `$` name the sugar never produces)?
3. **The names themselves** (`$key`/`$traits` vs `id`/`class`, `$`-prefixed or plain) — history below, in case lite wants to revisit.

## Where it has come up (chronological)

- **Joseph, 2025-12-23**: *"An ID value is, just like in xhtml, another attribute. That means the value within the brackets [v] is the equivalent of `|element :'$id' v`."*
- **Joseph, 2025-12-25**: `.class1.class2` == `:'$class' [class1 class2]` — written as one list.
- **Joseph, 2026-01-02**: *"I was already planning on changing the spec to output 'id' instead of '$id' — (and 'class' instead of '$class')."* 2026-01-14: *"I believe we've decided that the class (or $class) attribute always contains an Array, which may have only one item."* Same day, the rename to **key** / **traits**: *"I like 'key' (with an alias of 'id' and 'identity') over identity for the 'published' name, keeping 'traits' (with an alias to 'class' and 'classes')."*
- **Joseph, 2026-07-11** (the identity rulings): *"I would be perfectly happy with '$key' and '$traits' as the main default sugar and removing the id/class reservation as aliases."* *"I want to also leave '$*' as perfectly reasonable attribute names. The syntactical sugar just happens to pair up with some of them."* And: *"one nuance that I forgot about that the implementation needs to decide is whether the specially-designated $traits is *always* an array/list even if there was only one given (makes app-dev a bit more simple)."* He also asked that they be called "specially-designated," not "reserved." **2026-07-12**, listing items for the new FULL-SPEC-TODO: *"make sure traits as always-array is captured as one of the only parser-special-casing beyond the desugaring..."*
- **0.10.0 §5.3**: "Two traits are two `$traits` assignments (stacking) — never one list." "Designated, not reserved": `:$key 3890` is writable directly, and "a generator that only writes attributes produces a document indistinguishable from the sugared form." But "sugar-produced assignments are born finished" (K8), while "a longhand `:$key` is an ordinary attribute and takes deferred content like any other" — so the two spellings are not identical in every position.
- **K15 (2026-08-09)**: the default read; "always-list is an accessor, not the default."

## Alternatives

### For (1)

- **A** — default read (0.10.0 + K15): `|el.a` → `$traits "a"`.
- **B** — `$traits` is always a list in the lite tree: `|el.a` → `$traits ["a"]`, `|el` → no `$traits` (or `[]`?).
- **C** — every label is always a list in the tree (K15's accessor view made the tree's shape); see [13](13-ast-shape.md) Q4.

### For (2)

- **A** — longhand and sugar are the same tree wherever both are legal (0.10.0), with the born-finished difference for deeper lines.
- **B** — lite accepts only the sugar for `$key`/`$traits`/`$main`; a hand-written `:$…` label is an ordinary attribute whose name starts with `$` (so `:$key jw` is *not* identity).
- **C** — hand-written `$` labels are reserved in lite.

## Interactions

- [13](13-ast-shape.md) Q2 (dedicated fields vs designated attributes) and Q4 (stacking shape).
- [06](06-suffix-characters.md): `$?`, `$!`, `$*`, `$+` are the suffix sugar's designated attributes.
- [53](53-element-line-text-continuing-below.md): `$main`.
