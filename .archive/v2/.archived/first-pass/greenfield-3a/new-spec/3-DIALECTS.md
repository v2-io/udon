# UDON Dialects and Dynamics

**Universal Document & Object Notation**  
*Version 0.9.0-alpha.2 (Draft)*

This document specifies the standard Host extensions for UDON. Because core UDON is strictly a syntactic layer, the meaning of explicitly typed values (the `<...>` envelope) and dynamic blocks (`!`) are defined by **Dialects**. 

A conformant parser recognizes the syntax of these constructs, but a Host environment is required to interpret them according to the rules below.

---

## 1. The `temporal@1` Dialect

The `temporal@1` dialect defines standard representations for dates, times, durations, and relative offsets.   
All temporal values in UDON MUST be written inside the explicit typing envelope (`<...>`), as core UDON no longer recognizes bare temporal values.

### 1.1 Valid Temporal Patterns

When the `temporal@1` dialect is active, it parses the string content of the envelope into native temporal types based on the following ISO 8601-derived patterns:

| Pattern | Type | Example |
|---------|------|---------|
| `YYYY-MM-DD` | Date | `<2025-01-03>` |
| `YYYY-MM` | YearMonth | `<2025-01>` |
| `HH:MM:SS` (or `HH:MM`) | Time | `<14:30:00>` |
| `YYYY-MM-DDTHH:MM:SSZ` | DateTime (UTC) | `<2025-01-03T14:30:00Z>` |
| `YYYY-MM-DDTHH:MM:SS+HH:MM`| DateTime (Offset) | `<2025-01-03T14:30:00+05:30>` |
| `P[nY][nM][nD]T[nH][nM][nS]`| Duration (ISO) | `<P1Y2M3DT4H5M6S>` |
| Number + `s, m, h, d, w, mo, y`| Duration (Shorthand)| `<30s>`, `<2h>`, `<1mo>` |
| `+<duration>` or `-<duration>`| Relative Offset | `<+30d>`, `<-1h>` |

### 1.2 Strictness and Validation

- **Leading Zeros:** ISO 8601 requires leading zeros. A pattern like `<2025-1-3>` will fail temporal validation and fall back to being treated as an unparsed string by the dialect.
- **Negative Zero Offset:** `-00:00` MUST be accepted as equivalent to `Z` (UTC).
- **Fractional Seconds:** Fractional seconds are supported to nanosecond precision (e.g., `<14:30:00.123456789>`).

---

## 2. Dynamics (`!`) - The Baseline Dialect

The `!` prefix in core UDON denotes a Dynamic form. Core UDON recognizes the syntax (`!name`, `!{{...}}`), but the execution and evaluation of these forms belong to the Host. The baseline dialect provides a Liquid-style expression and control-flow language.

### 2.1 Interpolation

The `!{{expr}}` syntax evaluates `expr` in the Host environment and inserts the result. 

- If an attribute value is *entirely* an interpolation (`:key !{{val}}`), the Host evaluates the expression to determine the final type (which may be a number, boolean, etc.).
- If an interpolation is mixed with text (`:key prefix_!{{val}}_suffix`), the value is forced into a **Prose Content sequence**, and the interpolated result is coerced to a string.

### 2.2 Expression Grammar

Expressions inside `!{{...}}` and control-flow directives support standard logical operators:
- **Comparison:** `==`, `!=` (or `<>`), `<`, `>`, `<=`, `>=`
- **Logical:** `and`, `or` (Evaluated **Right-to-Left** with no precedence).
- **Membership:** `contains`

**Truthiness Rules:**  
Only two values are falsy in the baseline dialect: `false` and `nil` / `null`.  
*All other values*, including `0`, `""` (empty string), and `[]` (empty list), are explicitly **Truthy**.

### 2.3 Control Flow Directives

Block directives use the `!name` syntax to drive logic. The baseline dialect supports:

- **Conditionals:** `!if`, `!elif`, `!else`, `!unless`.
- **Iteration:** `!for item in collection`.
- **Variable Assignment:** `!let local_var = expression`.
- **Inclusion:** `!include partials/name`.

Because UDON relies on indentation rather than closing tags, control flow blocks naturally scope their contents based on standard dedentation rules.

```udon
!if user.is_logged_in
  |greeting Welcome back, !{{user.name}}!
!else
  |greeting Hello, Guest!
```

### 2.4 Filters

Expressions support pipe-based filters: `!{{ value | filter_name arg }}`.  
Standard filters include `capitalize`, `format`, `first`, and `currency`.
