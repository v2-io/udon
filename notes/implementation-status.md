# UDON Implementation Status

**Comparison of spec, implementations, and proposals across sources.**

Last updated: 2025-01-14

---

## Legend

| Symbol | Meaning |
|--------|---------|
| ✅ | Implemented / Specified |
| ❌ | Not implemented / Not specified |
| 🔄 | Partial / In progress |
| ⚠️ | Inconsistency or decision needed |
| 📝 | Proposal (in feedback.md or udon-*.md) |

---

## Sources

| Source | Description | Status |
|--------|-------------|--------|
| **CORE.md** | Authoritative specification | Current |
| **libudon** | Rust parser (descent-generated) | Current defacto |
| **udon-ruby** | Ruby gem with native extension | Behind libudon |
| **udon-*.md** | Design documents (ast, paths, agentic) | Ahead of spec |
| **feedback.md** | Agent suggestions and proposals | Proposals |
| **descent examples** | udon_complete.desc | Reference |

---

## Core Features

| Feature                    | CORE | libudon | udon-ruby | descent example | Notes |
| -------------------------- | --------- | ------- | --------- | --------------- | ----- |
| Elements `\|name`          | ✅         | ✅       | ✅         | ✅               |       |
| Keys `[key]`               | ✅         | ✅       | ✅         | ✅               |       |
| Traits `.class`            | ✅         | ✅       | ✅         | ✅               |       |
| Suffixes `?!*+`            | ✅         | ✅       | ✅         | ✅               |       |
| Attributes `:key value`    | ✅         | ✅       | ✅         | ✅               |       |
| Text/prose                 | ✅         | ✅       | ✅         | ✅               |       |
| Hierarchy (indent)         | ✅         | ✅       | ✅         | ✅               |       |
| Comments `; ...`           | ✅         | ✅       | ✅         | ✅               |       |
| Brace comments `;{...}`    | ✅         | ✅       | ✅         | ✅               |       |
| Embedded `\|{...}`         | ✅         | ✅       | ✅         | ✅               |       |
| Arrays `[...]`             | ✅         | ✅       | ✅         | ✅               |       |
| Freeform ` ``` `           | ✅         | ✅       | ✅         | ✅               |       |
| Block directives `!name`   | ✅         | ✅       | ✅         | ✅               |       |
| Inline directives `!{...}` | ✅         | ✅       | ✅         | ✅               |       |
| Raw blocks `!:lang:`       | ✅         | ✅       | ✅         | ✅               |       |
| Interpolation `!{{...}}`   | ✅         | ✅       | ✅         | ✅               |       |

---

## Value Types

| Type                    | CORE | libudon | udon-ruby | descent example | Notes                      |
| ----------------------- | --------- | ------- | --------- | --------------- | -------------------------- |
| Integer                 | ✅         | ✅       | ✅         | ✅               |                            |
| Float                   | ✅         | ✅       | ✅         | ✅               |                            |
| Bool (true/false)       | ✅         | ✅       | ✅         | ✅               |                            |
| Nil (null/nil)          | ✅         | ✅       | ✅         | ✅               |                            |
| Hex `0xFF`              | ✅         | ✅       | ✅         | ✅               |                            |
| Octal `0o755`           | ✅         | ✅       | ✅         | ✅               |                            |
| Binary `0b1010`         | ✅         | ✅       | ✅         | ✅               |                            |
| Rational `1/3r`         | ✅         | ✅       | ✅         | ✅               |                            |
| Complex `3+4i`          | ✅         | ✅       | ✅         | ✅               |                            |
| **Date** `2025-01-03`   | ✅         | ✅       | ❌         | ❌               | libudon values.desc has it |
| **Time** `14:30:00`     | ✅         | ✅       | ❌         | ❌               | libudon values.desc has it |
| **DateTime**            | ✅         | ✅       | ❌         | ❌               | libudon values.desc has it |
| **Duration** `30s`      | ✅         | ✅       | ❌         | ❌               | libudon values.desc has it |
| **RelativeTime** `+30d` | ✅         | ✅       | ❌         | ❌               | libudon values.desc has it |
| ISO Duration `P1DT2H`   | ✅         | ✅       | ❌         | ❌               | libudon values.desc has it |

---

## References

| Feature | CORE | libudon | udon-ast.md | feedback.md | Notes |
|---------|-----------|---------|-------------|-------------|-------|
| Reference syntax | `@[id]` | `@[id]` | `@element[key]`, `@[key]` | ⚠️ `\|[id]` proposed | feedback.md proposes dropping `@` |
| Block reference | `@[id]` | ✅ | ✅ | 📝 `\|[id]` | Insert element by id |
| Attr merge ref | `:[id]` | ✅ | ✅ | ✅ | Merge attributes |
| Typed reference | n/a | ❌ | `@element[key]` | n/a | AST doc shows `@user[1]` |

**Decision needed:** Stick with `@[id]` or adopt `|[id]`?

---

## Key/ID Attribute Name

| Source | Bracket `[x]` expands to |
|--------|--------------------------|
| **CORE.md** | `:'$id' x` (quoted attribute name) |
| **libudon parser** | `Attr($id)` then value |
| **udon-ast.md** | Uses `key` terminology |

**Observation:** CORE uses `$id`, AST doc uses `key`. These might be synonyms or might need reconciliation. The `$` prefix suggests a reserved/special attribute.

---

## Escape Mechanisms

| Context | CORE | libudon | feedback.md |
|---------|-----------|---------|-------------|
| Block-level escape | `'` preferred, `\` alternate | `'` only | 📝 Unify on `\` |
| Sameline escape | `\` | `\` (in strings) | ✅ |
| Hard return `\<newline>` | Not specified | ❌ | 📝 Proposed |

**Decision needed:**
- Unify escaping on `\` everywhere? (feedback.md recommends)
- Implement `\<newline>` for hard line breaks?

---

## Additional Features

| Feature | CORE | libudon | feedback.md | udon-*.md |
|---------|-----------|---------|-------------|-----------|
| BlankLine events | ❌ | ✅ | ❌ | ❌ |
| Warning events | ✅ (inconsistent indent) | ✅ | ❌ | ❌ |
| Quoted names `'complex name'` | ✅ | ✅ | ✅ | ✅ |
| Comment continuation | ✅ | ✅ | ✅ | ✅ |
| Markdown subset | Mentioned | ❌ | 📝 Djot-inspired | ❌ |
| Floating attributes `:{ }` | ❌ | ❌ | 📝 Avoid | ❌ |

---

## Terminology Differences

| Concept | CORE | udon-ast.md | Notes |
|---------|-----------|-------------|-------|
| Bracket content | `id` | `key` | AST uses "key" consistently |
| Element identity | `id` | `key` | "key is singular, traits are plural" |
| Trait/class | `class` | `trait` | AST prefers "trait" |

**Recommendation:** Standardize on AST terminology (key, trait) as it's more general than HTML-derived terms.

---

## Schema-Related Proposals

| Feature | feedback.md | udon-schema-exploration.md |
|---------|-------------|----------------------------|
| Schema syntax | RelaxNG-compact inspired | Puzzle piece 1 |
| Cardinality suffixes | `?!*+` in schema | Same |
| Type definitions | `\|type[name]` | Puzzle piece 2 |
| Composition constraints | Not addressed | Puzzle pieces 3-4 |
| Dialect declarations | Not addressed | Puzzle piece 12 |
| Soft/hard regions | Not addressed | Multiple pieces |

---

## Sync Status

### udon-ruby needs updating:
- Missing: Date, Time, DateTime, Duration, RelativeTime types
- Missing: BlankLine events
- Sync with libudon's values.desc

### descent example (udon_complete.desc) needs updating:
- Missing: Date, Time, DateTime, Duration, RelativeTime types
- Missing: BlankLine type

### Spec (CORE.md) decisions needed:
1. `@[id]` vs `|[id]` for references
2. `$id` vs `key` terminology
3. `\<newline>` for hard breaks
4. Escape unification (`'` vs `\`)
5. BlankLine events (implementation detail or spec?)

---

## Priority Reconciliation Tasks

1. **Sync udon-ruby with libudon** - Especially temporal types
2. **Decide on reference syntax** - `@` vs no `@`
3. **Standardize terminology** - key vs id, trait vs class
4. **Document BlankLine/Warning events** - Add to spec if keeping
5. **Update descent example** - Bring in line with libudon values.desc
6. **Hard break decision** - `\<newline>` or not

---

*This document is a snapshot for coordination. Update as decisions are made.*
