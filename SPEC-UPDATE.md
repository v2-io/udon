# UDON Spec Updates - December 2024

This document captures terminology clarifications and grammar refinements
discovered during the phase-3 parser rewrite. These should be incorporated
into the main SPEC.md.

## Terminology: Positional Contexts

The parser operates in different contexts that affect parsing behavior.
Clear terminology prevents confusion:

| Term | Meaning | Example |
|------|---------|---------|
| **block** | On its own indented line | `:key value` as child of element |
| **sameline** | On the element definition line | `\|el :key value Content` |
| **inline** | Embedded in prose/text flow | `\|{em text}`, `;{comment}`, `!{dir}` |
| **embedded** | Inside `\|{...}` delimiters | Synonym for inline element context |

### Block vs Sameline

```udon
|article
  :author Alice                    ; block attribute
  :date 2024-12-31                 ; block attribute

|section :id intro :class lead     ; sameline attributes
  This is block prose that can span
  multiple lines with consistent indentation.

|p Sameline prose here |{em with inline element} and more
```

**Block context:**
- Attributes on their own indented lines
- Prose that sets the indent-column for continuation
- Values can contain spaces without quoting

**Sameline context:**
- Attributes/content on the element definition line
- Prose that does NOT set indent-column
- Values are space-delimited (quote for spaces)

### Inline Elements

Inline elements use `|{...}` syntax and appear within prose:

```udon
|p Click |{a :href /home here} to continue.
```

Inside `|{...}`:
- Element identity follows same rules
- Sameline attributes work the same way
- Content terminates at `}` (brace-balanced)
- Nested `|{...}` allowed (not `|name` block form)

## Comment Contexts

Comments behave differently based on context:

| Context | `;` Behavior | Example |
|---------|--------------|---------|
| Document root | Line comment | `; file header comment` |
| Block prose | **Literal** (not comment) | `use x; do y` |
| Sameline prose | Line comment | `\|p text ; comment` |
| Block attr line | Line comment | `:key value ; comment` |
| Sameline attrs | Line comment (after values) | `\|el :k v ; comment` |
| Inline/embedded | `;{...}` only | `\|{em text ;{note}}` |

### Why Block Prose Differs

Block prose sets an indent-column and captures literal content including
semicolons. This allows code examples, prose with semicolons, etc.

```udon
|pre
  function foo() {
    return x; // semicolon is literal
  }
```

Sameline prose is brief (single line) and commonly followed by comments:

```udon
|li Item one ; TODO: expand this
|li Item two
```

## Value Terminator Rules

Different contexts have different terminator sets for bare (unquoted) values:

### Block Attribute Values

```udon
|el
  :key value with spaces allowed here
  :url https://example.com/path?q=1;s=2
  :note this has a semicolon too ; but THIS is a comment
```

**Terminators:** `\n` or ` ;` (space followed by semicolon)

- Values extend to end of line
- Spaces allowed without quoting
- `;` preceded by space starts comment
- `;` without preceding space is part of value

### Sameline Attribute Values

```udon
|el :key1 value1 :key2 value2 ; comment
|el :url https://x.com :class foo
```

**Terminators:** `\n` or `␣` (space)

- Space delimits values
- Use quotes for values with spaces: `:key "hello world"`
- `;` after values starts comment (child of element)
- `:` after space starts next attribute

### Embedded Attribute Values

```udon
|p Click |{a :href /home :class link here} now.
```

**Terminators:** `\n`, `␣`, or `}`

- Same as sameline, plus `}` closes the embedded element
- `}` is NOT consumed (returned for proper bracket matching)

### Array Item Values

```udon
:tags [one two three]
:coords [1.5 2.3 4.1]
```

**Terminators:** `\n`, `␣`, or `]`

- Space separates array items
- `]` closes array (not consumed)
- Context (block vs embedded) doesn't affect array terminators
- `}` before `]` is malformed (unspecified behavior)

## Summary: Bare Value Terminators

| Context | Terminators | Space? | Notes |
|---------|-------------|--------|-------|
| Block attr | `\n`, ` ;` | In value | Comment needs ` ;` |
| Sameline attr | `\n`, `␣` | Terminates | Quote for spaces |
| Embedded attr | `\n`, `␣`, `}` | Terminates | Don't consume `}` |
| Array item | `\n`, `␣`, `]` | Terminates | Don't consume `]` |

## Function Naming Convention

Parser functions should use this terminology consistently:

| Old Name | New Name | Purpose |
|----------|----------|---------|
| `inline_attr` | `sameline_attr` | Attr on element line |
| `block_attr` | `block_attr` | Attr on own line (unchanged) |
| `bare_value` | `bare_value_block` | Block attr values |
| `bare_value_inline` | `bare_value_sameline` | Sameline attr values |
| (new) | `bare_value_embedded` | Embedded attr values |
| (new) | `bare_value_array` | Array item values |
| `inline_text` | `sameline_text` | Text on element line |
| `embedded` | `embedded` | `\|{...}` (unchanged) |

## Open Questions

1. **Quoted strings in arrays:** Do they follow same rules?
   Currently: quotes handled before bare_value dispatch

## Escape Sequences for Semicolons

Different contexts use different escape mechanisms for literal `;`:

| Context | Escape Method | Example |
|---------|---------------|---------|
| Block prose | N/A (`;` is literal) | `code; more code` |
| Block attr value | Quote the value | `:sql 'SELECT *; DROP'` |
| Sameline attr/prose | Backslash | `|el :k val<BS>;ue ; comment` |
| Embedded | Backslash | `|{em text<BS>;more}` |

(`<BS>` = backslash character)

**Rationale:**
- Block prose preserves literal content (code, etc.) - no escape needed
- Block attr values support quoting naturally (same as spaces)
- Sameline/embedded use backslash (consistent with other escapes)

## Clarified Behaviors

**Empty/missing values:** When an attribute has no value (followed immediately
by `:`, `\n`, or context terminator), the parser emits `BoolTrue`:

```udon
|button :disabled :type submit
; disabled → BoolTrue, type → "submit"
```

This supports flag-like attributes naturally.

---

*This document supplements SPEC.md. Merge relevant sections after review.*
