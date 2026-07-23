# Dialect: baseline Dynamics (`!`)

**Status:** normative for the *baseline* Dynamics Dialect; optional for Core conformance.  
**Core syntax:** [../CORE.md](../CORE.md) §12.  
A Host MAY substitute another `!` Dialect; a conformant Recognizer needs none of this document’s *evaluation* rules.

---

## 1. Role

Core recognizes Dynamics forms and builds ADM nodes (Directive, Interpolation, Verbatim). This Dialect defines:

- Expression language inside interpolations and directive conditions
- Truthiness
- Baseline control-flow directives (`if`, `elif`, `else`, `unless`, `for`, `let`, `include`, …)
- Filters

---

## 2. Inline form recap (Core)

| Syntax | Form |
|--------|------|
| `!{{expr}}` | Interpolation |
| `!{:kind: …}` | Inline Verbatim (not evaluated as expression) |
| `!{directive …}` | Inline Directive; body UDON-parsed |

Disambiguation after `!{`: `{` → interpolation; `:` → Verbatim; else directive.

Empty interpolation `!{{}}` is valid; Host defines empty-expression behavior.

---

## 3. Interpolation and filters

```
!{{ value | filter1 | filter2 arg }}
```

- Expression is unparsed by Core; this Dialect parses a Liquid-style expression.
- Filters are left-to-right applications.
- Whole-value interpolation in Attribute position is an Interpolation Value.
- Mixed literal + interpolation is a **Flow Value** (segments), not a List.

### 3.1 Operators

| Category | Operators |
|----------|-----------|
| Comparison | `==` `!=` `<>` `<` `>` `<=` `>=` (`<>` ≡ `!=`) |
| Logical | `and` `or` (right-to-left, no precedence) |
| Membership | `contains` |

**Not in baseline:** parentheses, arithmetic (use filters), ternary, unary negation (use `== false` or `unless`).

### 3.2 Truthiness

Only **false** and **Nil** (`null`/`nil`) are falsy.  
Empty string, `0`, and `[]` are **truthy**.

Keywords `empty` and `blank` (as in Liquid-style checks) MAY be provided by the Host filter/test library; they are not Core types.

---

## 4. Control flow (block)

```udon
!if condition
  …
!elif other
  …
!else
  …

!unless condition
  …

!for item in collection
  …

!let name = expression
  …

!include path
```

- Indentation delimits bodies (no closing tags).
- Recognition accepts any directive name; this Dialect defines evaluation for the baseline set above. Unknown names: Host-defined (pass through / Error).

**Inline control flow** is not specified in this baseline  
(e.g. no `!if{cond}{then}{else}` yet).

---

## 5. Evaluation model (Host)

1. Resolve Interpolations and Directive conditions against a Host binding environment.
2. For `!if` / `!for` / etc., include or repeat body Content in the expansion tree.
3. Verbatim forms are never expression-evaluated by this Dialect.

Expansion is a Host Document-layer transform. The Core ADM before expansion remains available for tooling that must see templates unevaluated.

---

## 6. Host-specific Dialects (non-normative)

Hosts MAY provide Elixir/EEx-, Jinja-, or JS-flavored expression interiors while keeping Core `!` *syntax*. Documents SHOULD declare Dialect identity via a future pragma; until pragmas exist, Host configuration binds the Dialect.
