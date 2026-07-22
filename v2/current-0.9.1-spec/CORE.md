# UDON Core Specification

**Universal Document & Object Notation — 0.9.1 (consolidation)**
**Status:** normative for surface recognition and core semantics.
**Companions:** [GLOSSARY.md](GLOSSARY.md) (vocabulary) · [MODEL.md](MODEL.md)
(what recognition produces) · [SEMANTICS.md](SEMANTICS.md) (equivalence) ·
[CARVEOUTS.md](CARVEOUTS.md) (deliberately unspecified, with reasons) ·
[DELTAS.md](DELTAS.md) (behavior changes vs 0.9.0-alpha.2, ledgered) ·
[RATIONALE.md](RATIONALE.md) (non-normative why).

This document is the contract for how UDON source text maps to the model in
MODEL.md. It does not teach style (pedagogy is a separate pillar), define an
event/wire encoding (deliberately absent — see README), or specify Host
projection, Schema constraint, or Dialect meaning beyond what recognition
must carry.

The key words MUST, MUST NOT, SHOULD, SHOULD NOT, and MAY are per RFC 2119.

---

## 1. Conformance

A conforming **recognizer**:

1. Maps any finite UTF-8 input to a Document (MODEL §1) — content, anomalies,
   and result — per this specification.
2. Implements **Keep-Everything** wherever this document defines a keep path
   (§14).
3. Recognizes every marker, value form, and sugar desugaring here.
4. Treats meaning above recognition as optional: it MUST recognize Envelope
   and Dynamics *syntax*; it MAY leave their bodies unresolved when no
   Dialect is loaded.

A conforming recognizer is NOT required to implement any Dialect, Schema,
mixin expansion, Markdown interpretation, or Reference resolution.

When a canonical fixture suite is published for a version of this contract,
passing it is the operational definition of compliance; until then this
prose is authoritative. A demonstrated divergence between prose and suite is
a defect in one of the two, resolved by ruling — never by an
implementation's behavior.

### 1.1 What the core fixes, and what it leaves open

The core fixes **syntax** and **core semantics**: marker recognition and
guards, indentation geometry and the Nesting Rule, the frozen bare scalar
set, attribute stacking and order, definition (`|`) vs reference (`@`),
envelope *syntax*, extent (geometric vs delimited) including end of input,
and the anomaly contract. Everything else belongs to a consumer:

| Concern | Owner |
|---|---|
| Projection (validated string → native value) | Host |
| Constraint (what is allowed/required) | Schema |
| Exotic typing (what envelope contents mean) | Dialect |
| Reference resolution mode | Host (menu, §12.2) |
| Duplicate `(name, key)` policy | Document layer (menu, §12.3) |
| Mixin inheritance | Host (experimental, §12.4) |
| Markdown inside Text | layers above recognition |

Two boundary rules keep the split honest:

- **Menu vs knob.** The core MAY fix an option space and a default; a
  consumer picks within the menu and MUST NOT invent options outside it.
- **Dialects are not Schemas.** A dialect says what a value *means*; a
  schema says what is *allowed*. They never trade jobs.

- **Additivity.** Dialects act only inside envelopes (§11.6); bare
  recognition is frozen. Loading a dialect can never retype an existing
  document.

---

## 2. Source text and geometry

A UDON document is a sequence of Unicode scalar values encoded as UTF-8,
divided into **lines** by U+000A. A final line need not end with a newline;
end of input is newline-equivalent for geometric constructs (§13).

**Column** is the count of leading U+0020 SPACE characters before a line's
first other character, counted from 0.

**Indentation is spaces only.** A tab participating in a line's indentation
is an anomaly: the line's structural column cannot be honored, so the line
is kept as **text of the current column owner** (best-effort, using the
spaces before the tab as its column), with a **Warning** — a coherent keep
exists, so by §14's own definition this is not an Error. A tab anywhere else
(inside text, values, comments, verbatim bodies) is ordinary content.
*(Ruled L4, 2026-07-21 — supersedes the 0.9.0-alpha.2 line-lost posture;
see DELTAS.)*

### 2.1 The Nesting Rule

Open structural items (elements, block directives, block comments, block
verbatim) form a stack, each with a **base column** — the column of its
introducing marker. When a new structural line begins at column `c`:

```text
pop while c <= stack_top.base_column
then push the new item under the resulting top
```

Consequences:

- **Deeper column ⇒ child.** To be inside an element you must be at a
  column strictly greater than its marker's.
- **Same column ⇒ sibling** (the old top closes first).
- **Shallower column ⇒ dedent** — every open item at ≥ the new column
  closes, innermost first.

**Sameline nesting.** Elements introduced later on the same line occupy
their true columns: `|a |b |c` is equivalent, for all hierarchy purposes, to
the same elements on successive lines at those columns. A following line
reasons against the resulting stack exactly as if the vertical form had been
written. Once an item has closed, its former column has no residual meaning.

**Exception — prose interior.** Once an element has an established
**content base** for block text (§7.2), a line indented *deeper* than that
base is inside the text — literal, even if it begins with a marker-looking
character. Structure resumes at or left of the base.

A consistent sibling indent (commonly 2 spaces) is RECOMMENDED style, not a
rule of the language. *(No ratified rule names a default indentation unit
for tooling that must synthesize one — open item IND; see CARVEOUTS.)*

### 2.2 Structure Position

**Structure Position** is the state in which markers are recognized — and
the only such state. It is entered:

1. at the start of every line's content at a structural column (structure,
   text, and fences interleave freely — the state recurs every line), and
2. along the **Line Scan** (§6.4): the run through elements and attributes
   on an element-rooted line, before any prose begins.

At Structure Position these markers are candidates, each confirmed by a
short **guard** (§3):

| Marker | Opens |
|---|---|
| `\|` | element (§5); `\|{` inline element |
| `:` | attribute (§6) — phase-gated |
| `!` | directive / verbatim (§9, §10) |
| `;` | comment (§8) |
| `@` | reference (§12.2) |
| ` ``` ` | fence (§10) |

One further character is special at Structure Position: the escape `\` (§4).

**Committing to prose.** The first content word ends Structure Position for
that physical line: from there to end of line, marker characters are
literal, with exactly **one** exception — the whitespace-framed sameline
comment ` ; ` (§8). This one state plus that one carve-out is what keeps
Markdown tables, `:-)`, a mid-prose `!`, and after-prose backticks literal
while `|li Item one ; TODO` still reads naturally.

Inside flow, the **inline forms** (§7.3) are recognized independently of
Structure Position — they are flow's own structure, not line structure.

### 2.3 Bounded lookahead (language law)

Every guard resolves within a few characters, single-level, with no
unbounded backtracking. This is a constraint on the **language**, not an
implementation note: new syntax MUST stay inside the bound. Its consequence
is streamability — a chunk boundary mid-guard simply waits for the missing
characters; a document parses identically whole or byte-at-a-time. Chunk
boundaries are never end of input.

---

## 3. Marker guards

- **`|`** opens an element when followed by: an identifier-start character
  (`XID_Start`), `[`, `.`, `'`, `{`, or a flag-suffix character
  (`?` `!` `*` `+` — so anonymous `|?` parses). Otherwise `|` is text — in
  particular `| ` (pipe-space) is always literal, which preserves Markdown
  tables. A line-initial `|{` opens an **inline element** as the first
  segment of a flow line, participating in hierarchy at its column.
- **`!`** opens a dynamic when followed by an identifier character or `:`
  (`!if`, `!:lang:`). So `![img](x.png)`, `!=`, `!(` are text. The `!{…}`
  family is prose-level (inline forms), not this block rule.
- **`@`** marks a reference when followed by `[`, `.`, or an
  identifier-start character. `@` has equal footing with `|` in the Line
  Scan and in value position.
- **`:`** is **phase-gated** rather than character-guarded: it opens an
  attribute only while the owning element has not entered its content phase
  (§6.9), and only when followed by a key (bare or quoted). A `:` not
  followed by a key is text.
- **`;`** opens comments per the position table in §8.
- **` ``` `** opens a fence at any Structure Position (§10.3) — never after
  the line has committed to prose, never deeper than an established content
  base.

A marker character that **fails its guard** is ordinary text, and the
line's (or value's) fate is decided as if it were any other character.

---

## 4. The escape `\`

`\` is UDON's only escape. Its meaning is fixed entirely by **position**;
there is no set of escapable characters to memorize.

| Position | Effect |
|---|---|
| **Structure Position** | consumed; the rest of the physical line is prose text. Dead to line-level structure and to the framed sameline comment (a framed ` ; ` there is literal); alive to inline forms, which remain individually escapable. |
| **In flow, immediately before an inline opener** (`\|{`, `!{`, `;{`) | consumed; the opener is literal; flow continues normally. |
| **Value-expected position** (a plain attribute still needs a value, no token started) | consumed; the value becomes flow text (§6.5) — same surrendered-comment posture. |
| **Anywhere else** | a literal backslash. `C:\Users\me`, a trailing `\`, `\w` mid-word all pass through; any escape-sequence reading (`\n`, line-joining) belongs to host layers. |

A literal leading backslash doubles: `\\x` → text `\x` (the first is
consumed at Structure Position, the second is already text).

A consumed Structure-Position `\` occupies no column: the text after it
backs into the `\`'s own column, and — being the line's first content — that
column becomes the content base (§7.2). This makes a `\`-anchored first line
the idiom for indenting a whole text block; only the first line needs it:

```udon
|el |another
   \     all of this is output indented,
         and deeper lines need no marker;
```

A `\` beginning a line's content *deeper than an established content base*
is not at Structure Position — the whitespace before it was already text —
so it passes through literally, silently (host tooling MAY warn).

An **empty forced tail is a real, kept value**: value-position `:a \` with
nothing after it is an empty-string value — no warning, not a missing
value, peer to `:a ""` (ruled 2026-07-19). A lone Structure-Position `\` at
end of input likewise forces an empty prose line that must survive.

`'` is not an escape anywhere — it delimits strings, names, and keys.
Inside quoted strings, `\` is ordinary content (§11.3).

```udon
\|element            ->  |element         ; would-be element -> prose
\:not-an-attr        ->  :not-an-attr
\@name see this      ->  @name see this
\\path\to            ->  \path\to         ; literal leading backslash
|p see \|{em x}      ->  literal "|{em x}", prose continues
|el :count \7 apples ->  count = "7 apples" (text, not integer 7)
```

---

## 5. Elements

### 5.1 Shape

An element is **name (optional) + ordered attributes + ordered content** —
nothing else. Identity, traits, and flag suffixes are sugar over
**designated attributes** (§5.3); the model has no parallel fields
(MODEL §3).

### 5.2 Names

A bare name is a Unicode identifier: first character `XID_Start` (letters —
not digits, `_`, or `-`); each subsequent character `XID_Continue` or `-`
or `/`. Kebab-case is first-class (`|my-element`); `/` is conventional
namespacing with **zero** core semantics (`|acme/widget`). Any other
character ends the bare name; names containing one take single quotes
(`|'weird name'`). Which Unicode version supplies the `XID_*` properties is
a host decision; the rule (UAX #31 plus `-` `/`) is the core's.

The flag-suffix characters `? ! * +` are **not** name-continue characters
for elements — a trailing one is a flag suffix (§5.4). (Traits and
attribute keys have wider continue-sets; see below and §6.2.)

### 5.3 Identity and classification (sugar)

```udon
|element[key].trait1.trait2
```

- **Identity `[key]`** — what makes this element *this one*. The bracket
  interior uses the normal value rules (§11): `[1]` is integer `1`,
  `["01"]` the string `"01"`, `[abc-123]` the string `abc-123`. An
  interpolation may be the whole key: `|div[!{{id}}]` → `$key` carries the
  interpolation, host-evaluated (ruled S5).
- **Traits `.trait`** — what *kinds* of thing it is; plural, stackable,
  order-preserved. A bare trait is an identifier whose continue-set also
  includes `? ! * +` (so `.foo?` is the trait `foo?`); other characters
  take quotes (`.'ns.kind'`).

**Both desugar** into ordinary assignments to designated attributes:

| Written | Means |
|---|---|
| `\|el[k]` | `\|el :'$key' k` |
| `\|el.a.b` | `\|el :'$traits' a :'$traits' b` |
| `\|el?` | `\|el :'$?' true` (likewise `!` `*` `+` → `$!` `$*` `$+`) |

Two traits are two `$traits` assignments (stacking, §6.7) — never one list.

**Designated, not reserved.** Any `$`-key is legal. Because `$` is not a
bare-key character, longhand takes quotes (`:'$key' 3890`) — friction by
convention, not proscription — so a generator that only writes attributes
can produce a document indistinguishable from the sugared form.

**Identity is contiguous** with the name (plus one optional trailing
space-separated flag suffix). A `.trait` after a space is not identity —
`|p .gitignore is a file` has no traits.

**Unclosed identity → `$partial-key` (fail-safe).** If the `]` never
arrives — end of input, or an interior newline under this version's current
behavior (§13.2) — the captured-so-far value desugars under
**`$partial-key`**, not `$key`, with a Warning citing the opener. The
distinct name is deliberate: a consumer reading `$key`, or resolving a
reference, automatically **excludes** a truncated identity rather than
acting on it — for references especially, acting on a truncated key would
be dangerous. The partial value is kept. The same rule protects a
reference's selector key.

**Empty closed brackets** (single-line whitespace only): identity `|el[ ]`,
reference key `@[ ]` → **nil** key; an array `[ ]` → **empty array** (0
items, not `[nil]`). The collapse requires a proper close — an *unclosed*
whitespace bracket keeps its whitespace verbatim plus the unclosed Warning.

### 5.4 Flag suffixes

A trailing `?` `!` `*` `+` on the element identity desugars to a designated
boolean attribute (`|field[name]?` → `:'$?' true`). The core performs only
the expansion; meaning belongs to the consuming schema or dialect (a schema
might read `?` optional / `!` required; a grammar might read `?` 0-or-1,
`*` 0-or-more, `+` 1-or-more).

Positions — after the name, after the key, or space-separated at the end:

```udon
|name?      |name?[key]      |name?[key].trait
|name[key]?                  |name[key].trait ?
```

**Suffixes stack**: `|field?!` ≡ `|field :'$?' true :'$!' true` (ruled S1).

Because suffix characters are trait characters, a suffix touching a trait
belongs to the trait:

```udon
|el.bar?         ; traits: ["bar?"]
|el.bar ?        ; traits: ["bar"], $? = true
|el?.bar         ; $? = true, traits: ["bar"]
```

### 5.5 Anonymous elements

The name is optional: `|[k]`, `|.trait`, `|.trait :adapter pg`, `|?` are
elements with no name, ordinary in every other respect. The core attaches
no meaning to namelessness; consumers may (mixins, §12.4).

### 5.6 Inline elements `|{…}`

Within flow, `|{…}` opens an inline element:

- Brace-balanced; closes at the matching `}` (nested balanced `{}` fine).
- Name, identity, traits, suffixes, and attributes work as in §5–§6, with
  `}` as an additional (unconsumed) bare-token terminator.
- **Bracket mode:** inside `|{…}`, only inline forms nest — the block form
  `|name` does not exist there (`|ul |{li |{a Home}}`, never `|{li |a Home}`).
- **Multi-line** (settled): an inline element may span lines. Continuation
  indentation is geometry (skipped); each content line carries its
  terminator; the opener line's terminator belongs to the form when its
  line ends inside the braces. Consumers concatenate for a single string —
  exact by the text law.
- **Empty `|{}`** is a valid, empty anonymous inline element (ruled S4).
- Intervening text between sibling inline forms — including a single
  space — is real content (round-trip fidelity).
- An inline element is a child of its containing element, sibling to the
  surrounding text segments.

---

## 6. Attributes

### 6.1 Labeled edges

Every element has attributes (a labeled, ordered edge list) and content (a
positional node sequence). An attribute's key names what its value is *to
the element* (`my author`, `my timeout`); a child names what it *is*. That
— **whose name is it?** — is the design test, not "scalars vs structure":
an edge may terminate at a leaf value, a node, or repeat (stacking).
Restricting attributes to scalars was XML residue, not a UDON decision.

Attributes appear **sameline** (on the element's definition line),
**block** (on their own indented line), and inside inline elements — one
value grammar throughout; only terminator sets and tail ownership differ
(§6.6).

**Root-level attribute.** A line-initial `:key` with no owning element is a
**Warning**; the line is kept as document-level text, `:` included —
nothing is lost, so severity is Warning under §14. Attributes are edges of
elements; there is no phantom owner, and root attributes have no portable
meaning. *(Ruled L1, 2026-07-21 — supersedes alpha.2's "undefined"; see
DELTAS.)*

### 6.2 Keys and flag keys

A bare key is a Unicode identifier (`XID_Start` start) whose continue-set
is `XID_Continue` plus `-` `/` `?` `!` `*` `+`. Anything else takes single
quotes (`:'weird key'`). `/` is namespacing convention, core-inert.

A **terminal `?`** selects **flag** (presence/boolean) semantics — the flag
follows the *name*, so quoted and bare are identical (`:ready?` ≡
`:'ready?'`), and the stored key includes the `?`. A `?` elsewhere in a key
is just a character. The alignment with suffix sugar is by construction:
`|el?` desugars to `:'$?' true`, and `$?` — ending in `?` — is itself a
flag key.

**Plain keys always take a value.** A plain `:key` with no value material —
end of line with nothing indented under it, or a context terminator — is an
**Error**; the assignment still stands with value **Nil** (the shape never
carries less than the source suggested; the Error explains the Nil).
Presence flags are spelled with `?`:

```udon
|button :disabled? :type submit    ; disabled? = true, type = "submit"
```

**The flag rule.** After `:key?`, the next token in value position decides:

1. Exactly `true`, `false`, `null`, or `nil` **alone** at its boundary →
   that is the flag's value, consumed.
2. **Anything else** — a bare word, `|node`, `:next`, end of line — the
   flag snaps to `true` and that material is **re-owned by the continuing
   scan**: never the flag's body, never a warned extension, never warned.
3. A flag's value always finishes on its own line; deeper material under a
   flag key is the ordinary finished-value case (§6.7).

```udon
|el :a?                        ; a? = true
|el :a? false                  ; a? = false
|el :a? |beta                  ; a? = true; |beta is el's child
|el :a? well it sure is true   ; a? = true; el text "well it sure is true"
```

### 6.3 Value kinds

An assignment's value is one of:

| Kind | Forms |
|---|---|
| **Scalar** | quoted string, number, `true`/`false`/`null`/`nil` alone, list `[…]`, envelope `<…>` |
| **Reference** | `@…` (an inert selector, §12.2) |
| **Interpolation** | `!{{…}}` (carried unparsed; host evaluates) |
| **Node value** | block-form `\|element`, block verbatim `!:lang:`, or a fence — the value *is* that node |
| **Flow value** | prose-shaped text, including any value that begins with or contains an inline brace form |

Types live on the map side — attribute values and array items. The
envelope is meaningful in value position and nowhere in free prose.

A reference in value position is the attribute's value; the same reference
as a block line (or after a finished value at a boundary) is the
**element's** reference child — `@` and `|` behave identically here.

### 6.4 The Line Scan and the bare-token boundary

A `:` passing its phase gate opens an attribute; after the key, its value
material is collected; then the **Line Scan** continues for the current
owner — uniformly, sameline and block alike (a block line is *not* one
value running to end of line):

```udon
|el
  :a 1 :b 2      ; two attributes
```

Most value shapes announce their extent from their first character — digit
or sign → number, `"`/`'` → string, `<` → envelope, `[` → list, `@` →
reference, block-form `|name` → node — and self-terminate. A committed
token that goes wrong mid-way (`12ab`) falls through, token-locally, to an
ordinary bare token; the boundary rule then applies at its end
(`:x 12ab :y 3` → `x="12ab"`, `y=3`).

**The bare-token boundary.** A bare token holds the scan provisionally open
at its end. The next non-space character decides:

- **A guard-confirmed block-form marker** — `:` opening a key, `\`, a
  fence, block-form `|` / `@` / `!` (`|name`, `|[k]`, `|.t`; `@name`,
  `@[k]`, `@.t`; `!name`, `!:lang:`), or a framed ` ; ` — the token stood
  alone: a single-token value, exactly as if quoted; the scan continues.
- **Anything else** — plain text *or any inline brace form* — commits a
  **flow value** beginning with this token, running to end of line (or a
  framed ` ; `), owned per §6.5.

A marker character that **fails its guard** is not a boundary: `:3`, `|~`,
`!=`, a lone `|` are plain text and commit the flow value together with the
token before them.

**The inline-brace principle** (ruled 2026-07-19). No inline brace form —
`|{…}`, the `!{…}` family, `;{…}`, or the anticipated `@{…}` — is ever a
boundary marker or a mode exit. Inline forms are flow-level: met at a
bare-token boundary (or in value-expected position) they commit/continue
**text mode**, firing inside the flow value as segments, exactly as in
prose — `;{…}` reducing to `""` (comments are not value segments). Hence:

```udon
|el :n value |{em x} :a 1
; n = the flow value ⟨"value " |{em x} " :a 1"⟩ — no :a attribute exists
; ≡ |el :n \|{em x}-wise ownership; the framed ` ; ` affordance REMAINS
; active in a brace-committed flow value (unlike \-forced text)
|el :n ;{}        ; n = ""  (empty-string value, not a missing value)
|el :n |{em x}    ; n = flow value whose sole segment is inline em
|el :n |em x      ; n = the em NODE (block form binds; braces inline text)
```

**Keywords at the boundary.** `true` / `false` / `null` / `nil` are typed
only when the token finishes alone; followed by text they are the first
word of flow (`:alpha true story` → the string `"true story"`).

**Boundary at `;`:** a framed ` ; ` (space before; space or EOL after)
finishes the token and opens a comment; `;{` is an inline form (commits
flow); an unframed `;x` is literal (commits flow).

### 6.5 Ownership of flow values

When a flow value commits, its owner is decided by priority:

| # | Condition | Owner |
|---|---|---|
| 1 | An attribute to the left still needs a value, or is **collecting** | that attribute's value |
| 2 | else: the nearest element on the line to the left | that element's content (the tail — content phase begins, §6.9) |
| 3 | else | ordinary column ownership — text of whoever owns the column. Not an anomaly. |

**Collecting:** on a **block attribute line** (rooted by `:key`, no element
on it) the attribute remains the line's collector even after its value
finishes — further same-line material is a warned extension (§6.7). On an
**element-rooted line** an attribute never collects past its finished
value — the element takes the tail (the sameline decompress). This
asymmetry is the whole difference between the two contexts.

```udon
|el :first value :another with some text
; first="value"; another=flow "with some text"          (row 1)
|el :first value :another "with" some text
; first="value"; another="with"; el tail "some text"    (row 2)
```

**Deferred values.** If a key line ends with no finished value, the deeper
lines under it are the value's body, under ordinary column and content-base
rules — a multi-line flow value, or a node:

```udon
|el
  :body
    line one

    line two with |{em emphasis}
```

**Value-position `\`.** Where a plain attribute still needs a value, `\` is
consumed and the value becomes flow text: the rest of the physical line is
its first extent and gives up the framed-comment affordance; deeper lines
may continue it as a deferred value. A `\` at a *finished* value's boundary
is the ordinary boundary escape — the rest of the line is text, owned by
the rows above; the `\` sets the text's *mode*, never its owner.

### 6.6 Contexts and terminators

One value grammar; contexts differ only in bare-token terminators and tail
ownership:

| Context | Bare-token terminators | Tail after a finished value |
|---|---|---|
| Element-rooted line | space, EOL | element's content (row 2) |
| Block attribute line | space, EOL | warned extension (§6.7) |
| Inline element `\|{…}` | space, EOL, `}` (unconsumed) | inline element's content |
| List item | space, EOL, `]` (unconsumed) | *(items have no tails)* |

- A framed ` ; ` opens a comment on element and block-attribute lines
  (never inside `\`-forced text). An unspaced `;` is token content
  (`:url https://example.com/a?q=1;s=2`).
- Inside `|{…}` there are **no framed sameline comments** — a bare `;` is
  literal; only `;{…}` comments there (ruled; revisit with dialects —
  CARVEOUTS).
- `}` is not a terminator inside `[…]`: an inline element's `}` must follow
  the `]`; a `[` unclosed at the `}` is an unclosed list (content kept,
  Warning).

### 6.7 Stacking and warned extension

**Stacking.** Same-key assignments accumulate — ordered, heterogeneous, in
source order. Stacking is the uniform rule for *every* attribute;
last-wins does not exist in UDON. It is what makes trait sugar mere
desugaring. Stacking and list values are orthogonal:

```udon
|el :x 1 :x 2         ; two assignments (x = [1, 2] through a list view)
|el :x [1 2] :x [3]   ; two assignments whose values are lists
```

What is *allowed* (e.g. forbidding a multi-valued `$key`) is schema
territory, never core.

**Warned extension.** Material arriving after a key's value is already
finished — trailing text on a block attribute line, or a deeper second
value / sibling node / text under a finished key — is kept as a **further
assignment** under that key, with a **Warning**; never dropped, never
fatal, never a nested "multi-segment" value kind (MODEL §3):

```udon
|el
  :attr "first" and here's another one   ; WARN; attr ≈ ["first", "and here's…"]
  :when <7:02pm>
    extra deeper text                    ; WARN; when ≈ [<7:02pm>, "extra…"]
```

The warning marks a real refactoring hazard: joining that block line onto
the element's line would change ownership (row 2 — the tail would become
the element's). Deliberate multiplicity is written by stacking the key or
using a list. Flags are exempt from same-line extension (flag rule 2
re-owns instead); deeper material under a flag follows the ordinary rule.

### 6.8 Node values

An attribute's value may **be** a node — a block-form element, block
verbatim, or fence — with no anonymous wrapper:

```udon
|api :headers |header :name Content-Type :value application/json
|el
  :beta
    |veni-vidi-vici :working 1234
|el :script !:sh: make build
```

- **Block form binds; brace form is text**: `:x |em hi` → `x` is the `|em`
  node; `:x |{em hi}` → `x` is flow containing an inline element. *Drop the
  braces to bind an element as the value; keep them to inline it as text.*
- **The one-way door.** Once the node opens, its Line Scan owns the rest of
  the line — identity, attributes, prose, children. `|api :headers |header
  :k v :timeout 30` gives `timeout` to the *header*. Put the outer
  element's attributes first, or defer the node to a block.
- **No attribute-under-attribute.** A deeper line that is itself `:key`
  directly under an open attribute value (not inside a node value) is an
  **Error**; the offending line is kept as **text of the open value**, the
  Error annotating it (ruled L6 — see DELTAS). Maps-of-maps take a named
  node carrier: `:theta` + deeper `|config :first 1 :second 2`.
- One node per declaration is the warning-free shape; stack the key for
  more. A second sibling node at the value's depth is a warned extension.
- To set a flag *and* give the element a child node: `|el :a? |beta`.

### 6.9 Content phase and late `:`

All attributes of an element precede its content. Once content has begun —
a child, text, or a sameline tail (row 2) — the element is in **content
phase**: a later line-initial `:` at what would have been that element's
attribute column is **text** of whoever owns the column, with a **Warning**
(text that looks like an attribute).

```udon
|el :a 1 and a tail
  :b 2          ; WARN — el is past its attribute phase; ":b 2" is el's text
```

---

## 7. Text and flow

### 7.1 Flow

**Flow** is the one prose-shaped content model: an ordered sequence of
segments — text runs, inline elements, interpolations, inline directives,
inline verbatims, inline comments — that resolves to text once each
segment's layer processes it (comments stripped, interpolations evaluated,
inline elements rendered). Flow has three homes with one rule set: element
content (prose), flow values (§6.5), and inline-form interiors.

Any line that does not open structure at Structure Position is flow text of
its column owner. Text is **opaque** to the core: Markdown inside it is not
interpreted; `#`, `<`, and pipe-space have no meaning there. Which Markdown
subset renderers honor is a companion-layer concern (CARVEOUTS). Style
guidance (prefer Markdown for simple emphasis; reserve `|{…}` for
attributed structure) is pedagogy, not this contract.

Sameline text (an element's tail) does not establish a content base; block
text does.

### 7.2 The content base and dedentation

1. The element's sameline tail, if any, establishes nothing.
2. The first indented text line establishes the **content base** — the
   author's choice of column, anywhere strictly inside the parent (deeper
   than the parent's marker; at most an inline child's column when one
   exists).
3. Each later line at ≥ the base contributes its text with base-many
   leading spaces stripped; extra indentation beyond the base is preserved
   as text.
4. A line shallower than the base but still inside the element **warns**
   and re-bases: the base becomes the shallower column and parsing
   continues. (Per-line delivery means earlier lines were stripped by the
   old base; the warning marks the inconsistency.)
5. A line deeper than an established base is *inside the text*: markers
   there are literal (§2.1 exception). Structure resumes at or left of the
   base.

Each text line's terminator is part of its text; stripped indentation is
geometry (MODEL §6, the text law). Fences strip nothing (§10.3).

### 7.3 Inline forms

All brace-delimited forms recognized inside flow; the character after the
opener disambiguates with no lookahead:

| Form | Meaning |
|---|---|
| `\|{name … content}` | inline element (§5.6) |
| `!{{expr}}` | interpolation — ends at the **first** `}}` |
| `!{name …}` | inline directive; body is UDON flow |
| `!{:kind: …}` | inline verbatim (§10.2) |
| `;{…}` | inline comment; contributes no text |

Brace counting: `|{…}`, `;{…}`, `!{…}`, `!{:kind:…}` close on the balancing
`}`; `!{{…}}` alone closes on the first `}}` (a single `}` is expression
content). Unbalanced-brace content belongs in block forms. `\` before an
opener makes it literal (§4).

### 7.4 Blank and whitespace-only lines (the two-layer model)

Ruled S6 (2026-07-19):

- A blank line whose whitespace does **not** protrude past the prose
  content base is a **blank line** at the recognition layer (whitespace
  covered, round-trip safe) and contributes `"\n"` to text reconstruction.
- Whitespace protruding **past** the base is prose content, extra
  whitespace preserved (ordinary dedentation).
- A Structure-Position `\` on an otherwise-blank line forces a kept empty
  text line.
- **Interpretation is the consumer's**: interior blanks between text lines
  are newlines; leading/trailing blanks at structure boundaries are
  **ornamentation** (UDON-level decoration, not text content) — or kept as
  literal blank-line nodes for reversibility. (Exact placement of
  blank-vs-dedent at structural seams is deferred — S9, CARVEOUTS.)

**Final-terminator disposition** (ruled, three worked examples): interior
newlines within a text run are text. A run's final terminator riding
*inside* its last content-bearing line (…`\ tail`⏎ then structure) is
ornamental — trimmed by the consumer; an author's `\` at the very *end* of
a line (empty forced tail) is an **explicit** newline — kept. "The only
reason I'd put the backslash at the end like that is because I *do* want
the explicit newline."

---

## 8. Comments

`;` comments by position:

| Position | Behavior |
|---|---|
| Line start, structural column | line comment |
| After a finished value (framed ` ; `) | line comment |
| In sameline prose (framed ` ; `) | line comment |
| In block text **at** the content base | line comment |
| In block text deeper than the base | literal |
| In `\`-forced or value-`\` text (any) | literal |
| Inside `\|{…}` (bare) | literal — only `;{…}` comments there |
| In flow, as `;{…}` | inline comment |

The **frame** for a sameline comment is whitespace before the `;` and
whitespace or end-of-line after: `x ; c` comments; `x ;c`, `1;2` do not; a
trailing `x ;` is an empty comment.

**Comments are carried, not discarded** — they appear in the model
(MODEL §5) and consumers decide their fate (documentation extraction, TODO
tracking, stripping). Comment content is inert: never interpreted.

**Continuation.** A line comment owns everything indented deeper than it —
markers, structure, fences, everything — until a line at or left of its
column. The first continuation line sets the comment's strip column
(content-base shape — ruled L7); deeper lines keep their extra indent as
comment text. This is what lets one `;` silence an entire block, including
structure that is itself failing to parse. Comments participate in the
column hierarchy like any node (a comment at column 0 closes everything
open).

Inline `;{…}` framing whitespace is **preserved** on strip (both framing
spaces are prose; pure concatenation keeps them — ruled S18, revisit with
dialects). To output a literal `;` at line start, lead with `\` (§4).

```udon
; a comment
  still part of the comment (any structure here is comment text)
\; this line is output as text starting with ";"
|li Item one ; TODO expand     ; framed -> comment
|li ratio 1;2 done             ; unframed -> literal
```

---

## 9. Dynamics (syntax only)

The `!` marker introduces **dynamics**. The core recognizes five forms and
carries them; their meaning belongs to a host dialect (the baseline
Liquid-style dialect lives in the DYNAMICS companion; a conforming
recognizer needs none of it):

| Form | Recognition |
|---|---|
| `!name …` at Structure Position | **directive** — any name (the core does not enumerate); head-line remainder carried unparsed; deeper content parsed as UDON, closed geometrically |
| `!:label:` | block verbatim (§10.1) |
| `!{{expr}}` | **interpolation** — expression carried unparsed |
| `!{name …}` | inline directive (UDON-parsed body) |
| `!{:kind: …}` | inline verbatim (§10.2) |

Directives nest by column like elements; a dedent closes them. `!else` /
`!elif` chains are dialect semantics over adjacent directives, not core
structure.

Interpolations may appear in flow, as whole attribute values, as list
items, and as a whole identity key. A mixed literal-and-interpolation value
(`pre!{{x}}post`, `!{{base}}/path`) is a **flow value** — text and
interpolation segments, whole-value `!{{x}}` the one-segment degenerate (a
consequence of the inline-brace principle).

A **nameless** `!{` at end of input (nothing after the opener) is prose
text `"!{"` — no directive ever started (ruled 2026-07-18).

---

## 10. Verbatim

**Verbatim** is content never parsed as UDON: one family carrying a `form`
and optional `label` around an opaque body, in three geometries:

| Form | Syntax | Extent | Dedent |
|---|---|---|---|
| block | `!:label:` | geometric (dedent) | to the body's first-content-line column (the raw base) |
| fence | ` ``` ` | delimited (closing fence) | none — byte-exact |
| inline | `!{:label: …}` | delimited (balanced `}`) | n/a |

"Raw," "freeform," and "blob" as free nouns are retired in favor of this
family (GLOSSARY).

### 10.1 Block form

```udon
|example
  !:elixir:
    def hello do
      IO.puts("world")     ; not UDON — captured exactly
    end
```

The colon-wrapped label passes to the host uninterpreted. The body is every
deeper line, dedented to the **first content line's column**; deeper
indentation is preserved as body; a line at or left of the directive's
column ends the block. The body MAY begin on the directive line itself —
`!:sh: echo hi` captures `echo hi` — whitespace after the closing `:`
separates; a same-line tail does **not** establish the raw base (same shape
as fences and sameline prose). An empty same-line body after the separator
is an **empty body**, not "no body" (ruled S8). All of this holds uniformly
in node-value position (`|el :script !:sh: make build`).

### 10.2 Inline form

```udon
|p The response was !{:json: {"status": "ok", "count": 42}} as expected.
```

Brace-counted (balanced `{}` allowed); a single space after the label's
closing `:` is a separator, not body. Unbalanced braces need the block
form. In value position the inline form is a **flow segment**, uniform with
the other inline brace forms (ruled S11).

### 10.3 Fence

A fence opens at any Structure Position — line start or in the Line Scan
after elements and attributes — never after the line has committed to
prose, never deeper than an established content base. Its indentation sets
its structural parent; everything after the opening backticks begins the
body (an info label for free). The body is captured **byte-exactly**: no
dedentation, no marker interpretation, blank body lines are literal
newlines, every body line keeps its terminator.

A line whose first non-space content is ` ``` ` closes the fence, at any
indentation (whitespace right of the closer is trimmed; the closer must be
followed by its line end). Indentation *of* the closing line was already
body on the preceding lines — put the closer at column 0 unless that indent
is wanted.

Use a fence when byte-exactness matters (assembling files without indent
control, broken tooling); use `!:lang:` for ordinary code samples.

---

## 11. Values and types

### 11.1 Syntactic typing and the frozen bare set

Type comes from written syntax, never from sniffing content. The **bare
scalar set** — recognized from bare syntax alone — is **closed forever**:
string, integer, float, boolean, nil, list. Every other type is written in
the envelope (§11.6). Nothing is ever added to bare recognition; this is
what makes dialect growth structurally unable to retype existing documents
(YAML's Norway problem is the canonical counter-case).

| Syntax | Type |
|---|---|
| `"…"` or `'…'` | String |
| `42`, `1_000_000`, `0xFF`, `0o755`, `0b1010`, `0d42` | Integer |
| `3.14`, `1e10`, `1.5e-3` | Float |
| `true`, `false` (lowercase, alone at boundary) | Boolean |
| `null`, `nil` (alone; equivalent) | Nil |
| `[…]` | List |
| `<…>` | Envelope (dialect-typed; not itself a core scalar) |
| otherwise | String (single token) or flow value |

`TRUE`, `True` are strings. A bare `2026-07-11` is the string
`"2026-07-11"` — **all temporal values require the envelope** (the
`temporal@1` dialect; the old bare-temporal model is superseded).

**Rational and complex are not bare scalars** (`1/3r`, `3+4i`, `5i`).
Bare numeric recognition is frozen to integer + float (ruled R21, reaffirmed
L5). Their future home is a standard-types dialect via the envelope; the
in-dialect spelling is open (CARVEOUTS). Unquoted, those spellings are
ordinary bare strings / flow values today.

### 11.2 Numbers

**Integers** — optional leading `+`/`-`; `_` between digits of any base,
value-neutral; four bases by explicit `0`-prefix:

| Base | Prefix | Example |
|---|---|---|
| Decimal | none, or `0d`/`0D` | `42`, `1_000_000`, `0d42` |
| Hexadecimal | `0x`/`0X` | `0xFF` |
| Octal | `0o`/`0O` | `0o755` |
| Binary | `0b`/`0B` | `0b1010` |

A leading `0` before more decimal digits is decimal — `0755` is `755`;
`0d` is the explicit way to *say* decimal.

**Floats** are decimal numbers with a fractional part (`.` + digits), an
exponent (`e`/`E`, optional sign, digits), or both. A decimal token with
neither is an integer.

### 11.3 Strings

`"…"` and `'…'` quote. A string closes at the next occurrence of its own
quote character; interior bytes — `\` included — pass through untouched
(§4 does not apply inside strings). **There are no core in-string
escapes**: to contain one quote kind, use the other (`"it's"`,
`'say "hi"'`); hosts MUST NOT invent core escapes (ruled L2 — the
positional-`\` story stays whole; doubling would collide with adjacent
quoted list items, §11.5).

The bare fallback: an unquoted single token that is nothing else is a
string.

### 11.4 Booleans and nil

Lowercase only, typed only when alone at the boundary (§6.4). `null` ≡
`nil`. Four distinct states, none of them the missing-value error:

- **Absent** — key not present
- **Nil** — key present, explicitly no value
- **False** — boolean false
- **True** — flag key bare, or explicit `true`

### 11.5 Lists

`[…]` in value position: items space-delimited, each typed independently by
the **full** value rules — numbers, strings, envelopes, nested lists,
references, and interpolations are all valid items (ruled §1.8; the
enumeration is illustrative, the rule uniform). No flow values inside a
list — a bare item is one token; quote items with spaces. A quoted item's
closing quote ends it: `["x"y]` and `["x""y]` are two items each, like
`["x" y]`. `[ ]` (whitespace only, closed) is the empty array.

### 11.6 The envelope `<…>`

Every non-core type is written inside `<…>` in value position — attribute
values and list items alike. In prose or inside quotes, `<` is ordinary. To
write a literal string beginning `<`, quote it.

```udon
:when <2026-07-11>                          ; unlabelled
:size <u64:0xf902>                          ; type-labelled
:span <temporal:interval:2026-01/2026-06>   ; dialect-and-type-labelled
```

- A bare value beginning `<` opens the envelope; the **matching** `>`
  (depth-counted — nested envelopes parse) closes it.
- **Envelopes span newlines** (settled multi-line): an interior newline is
  content; unclosed at end of input → content kept, Warning (§13).
- **Label ladder:** `<content>` → `<type:content>` →
  `<dialect:type:content>`, least to most specific.
- **Unlabelled dispatch:** offered to the document's declared dialects in
  declared order; first claim wins; if all decline, an **Error**. No
  sniffing race. Which dialects are active by default is a host choice.
- **No dialect loaded (interim):** a conforming recognizer still parses the
  envelope's extent, carries the value as its full lexical form with a
  Warning (`:dur <5m>` → the string `"<5m>"` + no-dialects warning), and
  loses nothing; when dialects land the same document retypes identically,
  minus the warning. A closed empty `<>` stays this interim string; the
  `< >` → nil collapse is a dialect-era refinement (CARVEOUTS).
- **Nested-envelope routing** — who hands inner typed values to whom — is
  deliberately open; only the `<>`-balanced span is guaranteed (CARVEOUTS).

The envelope is the visible core/dialect boundary: bare means frozen core
scalar or string; `<…>` means a dialect answers. Dialects never touch bare
space, so adding one can never silently retype a document.

---

## 12. References, duplicates, mixins

### 12.1 Definition vs reference

`|` always **defines**; `@` **refers** to an element defined elsewhere.

### 12.2 References

A reference is an inert **selector** `(name?, key?, traits)`:

| Written | Selector |
|---|---|
| `@[mit]` | `(∅, mit, [])` |
| `@licence` | `(licence, ∅, [])` |
| `@licence[mit]` | `(licence, mit, [])` |
| `@.realized` | `(∅, ∅, [realized])` |
| `@licence[mit].realized` | `(licence, mit, [realized])` |

- **Traits are selection criteria** — they filter which definition matches;
  a reference never decorates or mutates its target. Deliberately absent:
  suffixes, attributes, predicates, nesting. To vary content, define a new
  element.
- The tuple is **frozen at three fields** pending path design — no
  incremental growth (ruled S14); a path syntax, when it comes, replaces it
  wholesale, and cross-document addressing is in scope for that design
  (PATH-1). See CARVEOUTS.
- The core recognizes; it never resolves. Resolution **menu**:
  `transclude` | `merge-attributes` | `leave-inert` (default inert).
  Key-only `@[k]` may be ambiguous across names; recognition succeeds;
  resolve time MAY error.
- An unclosed selector key fails safe exactly like identity: the selector
  is marked partial and resolvers MUST exclude it (§5.3).

### 12.3 Duplicate definitions

Two elements of the same name sharing a key are a **duplicate definition**
— never a re-open or merge. This is a Document-layer concern over
`(element-name, key)`; the streaming recognizer cannot and does not check
it. **Menu** (default **error**):
`error | allow-if-identical | first-wins | last-wins | keep-all`, plus an
optional `warn` modifier. `allow-if-identical` compares by tree equality
ignoring spans. References play no part in uniqueness.

### 12.4 Mixins (experimental, non-core)

A host MAY read an anonymous, trait-only element as a mixin — elements
carrying the same trait inherit its attributes:

```udon
|.defaults
  :adapter postgres
|database[prod].defaults
  :database prod_db      ; a mixin-aware host also gives it adapter
```

The core sees only what is written; a recognizer that does no mixin
resolution is fully conformant. (Ruled S13: remains a host experiment.)

### 12.5 Annotation convention (non-core)

Inline annotation is a named-element convention — e.g.
`|{note :confidence 0.7 …}` with a schema-owned vocabulary, strippable by
consumers (ruled C2). Richer annotation syntax is deferred to the
demand-side work (CARVEOUTS).

---

## 13. Extent and end of input

### 13.1 Geometric vs delimited

Every construct closes one of two ways, and every new construct MUST
declare which:

- **Geometric** — extent from geometry: end of line, dedent, or end of
  input. Elements, attributes and their deferred values, comments,
  directives, block verbatim, text blocks.
- **Delimited** — only at a matching printed end-sequence: quoted strings,
  lists, identity/selector brackets, inline forms, interpolations,
  envelopes, fences.

This taxonomy is what makes end-of-input behavior derivable rather than
enumerated.

### 13.2 Multi-line status (current version)

Three delimited forms are **settled multi-line** and stay that way: the
inline element `|{…}`, the fence, and the envelope `<…>` (interior newlines
are content).

For **every other** delimited form — quoted strings, `[…]` lists, identity
and selector brackets, `!{{…}}` interpolation, `;{…}` inline comments, and
the `!{…}` / `!{:kind:…}` inline directive/verbatim — spanning a line
terminator is **deliberately not specified**, pending the demand-side aux
work (dialects, schemas, paths, value typing). This is a carve-out with a
reason, not an oversight: if bracketed and quoted captures turn out to be
sugar for dialect-typed captures, each capture's grammar owns its own
line-span and there is no per-construct table to close — the question
dissolves rather than resolves. **Do not close this per-construct**; see
CARVEOUTS (ML) for the full reasoning and what would settle it.

> [!caution] CURRENT BEHAVIOR (non-normative, descriptive only)
> Today's reference parser: strings and interpolations span the newline
> (content); lists and identity keys close at the newline with their
> content kept and a Warning (identity via `$partial-key`). Ratified only
> as "undefined-but-warn-before-disallow" (S2): pinning fixtures must be
> framed descriptively, and a future version may define multi-line or warn
> — it will not silently change meaning.

### 13.3 End of input

At true end of input, every open construct closes, innermost first:

- A **geometric** construct closes by its ordinary end rule, **silently** —
  EOF is newline-equivalent, and a missing final newline is never, by
  itself, an anomaly. Every remaining EOF edge is governed by
  **EOF ≡ end-of-line + full dedent** — no special cases (`;`⟨EOF⟩ ≡ `;⏎`;
  a bare marker as the final byte is prose by its failed guard, not an
  unexpected EOF).
- A still-open **delimited** construct keeps everything that arrived
  (which may be nothing beyond the opener), closes, and yields **one
  Warning citing where it opened**; nested open constructs yield one
  warning each, unwinding innermost-first. Kept content is delivered
  before the warning (content first, then the unclosed signal, then the
  close).

**The incomplete-input result.** A delimited construct still open at true
end of input additionally marks the **document** result `incomplete-input`
(MODEL §1): the input is presumed truncated or unfinished. This is a
per-document result — surfaced by the consuming layer as non-success (a
non-zero exit, an `Err`) — not a per-construct signal and not an event.
Only frames open *at* end of input feed it; a delimited construct closed
early by an interior newline (per §13.2's current behavior) leaves a
complete document.

For streaming input, "end of input" is the producer's explicit signal,
never a chunk boundary.

---

## 14. Anomalies

### 14.1 Two severities, defined by loss

| Severity | Meaning |
|---|---|
| **Warning** | everything kept; may not match author intent |
| **Error** | something was **lost**, or a required value is **genuinely absent** as written; recognition continues |

**Error = loss** (ruled L0) is mechanically checkable: if every
author-visible byte is represented in the model as structure or text,
severity MUST be Warning — unless a more specific rule names Error for an
*absent intended value* (the one current case: plain `:key` with no value →
assignment with Nil + Error, §6.2). An Error MUST NOT halt recognition;
nothing after an error point may be silently discarded.

### 14.2 Keep-Everything

Wherever a coherent keep-everything response exists, a conforming
recognizer MUST keep all input content and warn rather than drop. Known
coherent keeps: warned extension, flow fallback with the marker restored,
content-base re-basing, late-`:`-as-text, tab-line best-effort keep,
`$partial-key`, and unclosed delimited extents (content kept, opener
cited). Silent drop of author-visible material is non-conformant.

The response ladder above (a) warn-and-keep — (b) warn-and-drop, (c)
error-and-drop, (d) halt, (e) reject — belongs to **consumers**: whether
accumulated anomalies justify dropping, halting, or rejecting is consumer
policy over the complete model (menu vs knob), never a second recognition
mode. Anomalies never suppress content and content never suppresses
anomalies: the model carries both.

### 14.3 Representative cases

| Situation | Severity | Keep shape |
|---|---|---|
| Unclosed delimited construct | Warning (+ incomplete-input at EOF) | partial content, opener cited |
| Unclosed identity/selector `[` | Warning | `$partial-key` / partial selector |
| Trailing material after a finished value (block attr line) | Warning | further stacked assignment |
| Late `:` after content phase | Warning | text |
| Inconsistent prose indent | Warning | re-base content base |
| Root-level `:key` | Warning | document-level text |
| Tab in indentation | Warning | best-effort keep as text of current owner |
| Plain `:key` missing its value | Error | assignment with Nil |
| Attribute under attribute | Error | offending line kept as text of the open value |

---

## 15. Design principles (normative constraints)

1. **Attributes before content** for each element (content phase).
2. **Spaces only** in indentation.
3. **Syntactic typing**: a frozen bare set + explicit envelopes; dialects
   structurally cannot retype bare space.
4. **Stacking, not last-wins.**
5. **Bounded lookahead** as language law.
6. **Sugar is designated attributes**, never parallel model fields.
7. **References inert at core.**
8. **Keep-everything; severity = loss.**
9. **Every construct declares its extent kind** (geometric or delimited)
   and inherits its EOF story from it.
10. **The text law** (MODEL §6): document text reconstructs by pure
    in-order concatenation of text; anything a consumer must consult the
    source to reconstruct is a model hole.

---

## Appendix A — quick surface map (non-normative)

```udon
; comment
|element[key].trait :attr value :flag?
  :block-attr multi word value
  :node-attr |config :first 1 :second 2
  Prose with |{em inline}, !{{interp}}, and ;{a note}.
  !:python:
    print("| not udon")
  ```
  byte-exact fence body
  ```
  @other[key]
\| this line is literal text
```
