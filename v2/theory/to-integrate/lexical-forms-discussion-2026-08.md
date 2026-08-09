# Lexical forms — the three-forms question (2026-08-09, thinking out loud)

**Register: pre-validation brainstorm** (DISCUSSION-THOUGHTS discipline — jaw
thinking out loud in session, explicitly "not necessarily asking for any
resolution"; nothing here is ruled; the K1–K16 rulings it touches stand until
he says otherwise). Captured because it may be the conceptual successor to the
K9–K16 value-space arc.

## The seed (jaw, verbatim)

On the reference value form: "there is actually an open debate right now-- or
rather unsettled design question. We're considering potentially something
like this: `@<{   }>` for the value form."

The crystallization: "there are / should be probably three distinct forms of
many things. block/geometric, value, and embedded (or maybe it's
embedded-value...) distinctly embedded in prose, where at least I have
continued to loosely conflate value-form with embedded-form..."

And the diagnosis of why it's unexplored: "because we couldn't nail down the
directives and haven't the references yet (other than some small simple parts
provisionally) we haven't fully explored exactly what it means to embed (even
interpolation is a hack at the moment because we don't have exactly in place
what it is we are pulling the text in from / the context-object-- that work,
btw, is being explored still w/ references/paths...)"

## The form matrix (ruled law + inferred; *italic* = borrowed/unsettled)

| Construct | Block / geometric | Sameline (in the scan) | Value (in a slot) | Embedded (in prose) |
|---|---|---|---|---|
| **Element** | `\|el` (owns lines below) | `\|a \|b` chaining (true columns) | *borrowed×2:* block-form `\|name` binds as node (one-way door, §6.8) **or** `\|{…}` self-delimits (K9/K16) | `\|{el …}` flow segment |
| **Attribute** | `:a 1` own line (line root, collects) | `:a 1` mid-scan | — (attributes aren't values; K4) | — (` :a` mid-prose literal) |
| **Reference** | `@name` reference-child line | `@name` mid-scan (equal footing with `\|`) | *conflated with block:* bare `@…` · `@<{…}>` **under debate** | `@{…}` — **demanded (K16 addendum), undefined**; today literal text |
| **Directive** | `!name` (head + geometric body) | `!name` mid-scan — *head swallows rest of line* (K3 footgun) | directive as node value (K3, inert) — *borrowed block spelling* | `!{name …}` (UDON-parsed body) |
| **Interpolation** | — (line-initial `!{{` fails guard → flow) | via value/flow only | `!{{expr}}` whole-value (S5: also whole-key) | `!{{expr}}` — *same spelling as value* |
| **Verbatim** | **two forms:** `!:kind:` (geometric) · fence (delimited) | `!:kind: body here` (§10.1 same-line body); fence openable mid-scan | *borrowed×2:* `!:kind:` node value · `!{:kind:…}` at a slot (S11-flip) | `!{:kind: …}` flow segment |
| **Comment** | `;` line-initial (geometric — owns deeper lines) | framed ` ; ` (to EOL) | *deliberately none:* `;{}` at a slot yields `""` (ruled) | `;{…}` (contributes no text) |
| **Text itself** | text-space content (block prose) | → `$main` contribution (K9) | quoted string / bare token | it *is* the prose |
| **List** | — | — | `[…]` only | — (literal chars) |
| **Envelope** | — | — | `<…>` only | — (literal `<`) |

## Observations (coordinator, concurred-in-session as thinking material)

1. **The conflation isn't uniform — each construct conflates a *different*
   pair**, which is why it stayed invisible: elements and verbatims conflate
   value-with-embedded (position decides); references conflate
   value-with-block (bare `@` serves both). No construct distinguishes all
   three (four, with sameline).
2. **The value column is the only column the language never minted spellings
   for.** Block = uniform bare sigils; embedded = uniformly `{…}`-composed
   (`\|{` `!{` `!{{` `!{:` `;{`, now `@{`); every value-column entry is
   *borrowed* from another column. **The position machinery — clean
   value-expected positions, the one-way door, R4-mid-flow — is the interest
   paid on never minting value forms.** Position disambiguates because
   spelling doesn't.
3. **The two constructs with native value spellings — list `[…]` and envelope
   `<…>` — are exactly the two needing zero position machinery.** Strongest
   structural argument for the `@<{ }>` instinct: `<…>` is where the language
   already mints value-ness. If three-forms ripens, the natural generator:
   bare sigil = geometric · `{…}`-composed = embedded · `<…>`-composed =
   value.
4. **Comments are accidentally the design exemplar** — the only construct
   with a complete non-conflated form set: distinct block (geometric,
   line-owning!), sameline (framed), embedded (`;{}`), and a *deliberate*
   value-hole (`;{}` at a slot → `""`).
5. **Interpolation's row shows three smells at once** — no block form,
   value≡embedded conflation, and meaning dependent on an undefined
   context-object — all pointing at the references/paths work, where jaw says
   the context-object exploration lives.
6. **Held tension, not resolved:** K16 (same day) doubled down on
   position-as-disambiguator ("a key is a value slot"). Correct given today's
   spellings. If three-forms lands, much of that machinery is what it would
   retire — this note is *upstream* of several fresh rulings, which is why it
   stays a brainstorm.

## What would move this forward (when it ripens — not now)

- The references/paths work defining the context-object (interpolation's
  missing referent) and the `@{…}` embedded form K16 already demanded.
- A spike sketching the `<…>`-composed value-form generator across the matrix
  (`\|<{…}>`? `@<{…}>`? …) and pricing what position machinery each minted
  form would retire vs. what spelling burden it adds — frequency-weighted per
  jaw's least-surprise calculus.
- The directive nail-down (K3 kept them deliberately inert precisely so this
  exploration could happen on faithfully-carried forms).
