# Composite & nested types via nested `<…>` envelopes

*Direction, not ratified — captured 2026-07-14 from Joseph. This is where the
`<…>` typing envelope is headed "when we get there"; recorded so the idea isn't
lost. Nothing here is in FULL-SPEC yet.*

## The problem it solves

Numeric composition — a rational whose parts are complex, a ratio of complex, a
complex with rational parts — doesn't compose cleanly anywhere we looked:

- **Ruby** does it with *arithmetic + operator overloading*, so operator
  precedence fights the intent: `/` binds tighter than `+`, so a bare
  `3+4i/1+2i` is `3+6i`, not `(3+4i)/(1+2i)`. You must parenthesize or call
  `Complex(…)`.
- **UDON's current grammar** doesn't compose at all: rational = `int/int` + `r`,
  complex = `(int|float)` parts; neither nests. `1/2+3/4i` just falls to a
  string.

## The direction: `<…>` is a nested, typed constructor

UDON is **operator-free**, so it has none of Ruby's precedence problem — a
composite value is *lexed*, not computed. Composition therefore lives in the
`<…>` typing envelope, which **nests**: the label is the type, the
space-separated body holds the components, and a component may itself be a `<…>`
envelope or a bare core scalar.

Joseph's example:

    <r: <i: 3 -7> 0d83.23>

reads as **Rational( numerator = Complex(3, -7), denominator = 83.23 )** — a
rational whose numerator is a complex number and whose denominator is an
explicit-decimal float. Label `r` = rational; label `i` = complex/imaginary;
components are positional and space-separated; leaves are bare core scalars
(`0d83.23`). No operators, no precedence — the structure is entirely explicit.

This generalizes far past numerics: any dialect can offer a constructor of this
shape — `<point: 3 4>`, `<interval: <t: …> <t: …>>`, `<matrix: <row: 1 2> <row:
3 4>>` — a typed, nestable, S-expression-ish literal.

## What it implies for the core

- **`<…>` must be `<>`-balanced (nesting), not "first `>` terminates".** The
  current Explicit-Typing prose says "`>` terminates the value"; for nesting it
  must be the *matching* `>` (depth-counted, like the brace-balancing already
  used in `|{…}` / `!{…}`). This is the one core refinement the direction
  requires.
- The core recognizes the envelope and its nesting/balance and hands the body to
  the dialect; the **dialect** parses the body (labels, component arity, whether
  components are positional or named).

## Open sub-questions (for when we get there)

- Positional vs. named components (`<r: 3 4>` vs. `<r: num=3 den=4>`)?
- Separator rules inside the body (space-only? something else)?
- How a dialect declares its constructor grammar (arity, component types).
- Whether the bare rational/complex core types survive at all, or whether *all*
  rational / complex / composite numerics move into a `numeric@1` dialect,
  leaving bare = int / float / bool / nil / string / list. (The pending
  "bare-vs-dialect for rational/complex" fork.)
- Interaction with the label ladder (`<type:…>` / `<dialect:type:…>`): is `r` a
  type within a default numeric dialect, or its own thing?
