# UDON Core Specification

**Universal Document & Object Notation — 0.10.0-alpha.1 (value-space unification)**  
**Status:** normative for surface recognition and core semantics.  
**Companions:** [GLOSSARY.md](GLOSSARY.md) (vocabulary) · [MODEL.md](MODEL.md) (what recognition produces) · [SEMANTICS.md](SEMANTICS.md) (equivalence) · [CARVEOUTS.md](CARVEOUTS.md) (deliberately unspecified, with reasons) · [DELTAS.md](DELTAS.md) (behavior changes, ledgered) · [RATIONALE.md](RATIONALE.md) (non-normative why).

> **Version note.** 0.10.0-alpha.1 is the value-space unification: the 2026-08 rulings (DELTAS, K-series) stated natively rather than as patches on the 0.9.1 consolidation, which lives beside this suite as the pre-unification record. Open questions raised by the rewrite live in [working-notes/UNIF-PASS-QUESTIONS.md](working-notes/UNIF-PASS-QUESTIONS.md); where a subsection flags one, the flagged reading is a lean, not law.

This document is the contract for how UDON source text maps to the model in MODEL.md. It does not teach style (pedagogy is a separate pillar), define an event/wire encoding (deliberately absent — see README), or specify Host projection, Schema constraint, or Dialect meaning beyond what recognition must carry.

The key words MUST, MUST NOT, SHOULD, SHOULD NOT, and MAY are per RFC 2119.

*New to UDON? Read [TUTORIAL.md](TUTORIAL.md) or Appendix A (the annotated surface map) first. Implementers pressed for time: **§0 is the spec in one page** — every section below is one of its axioms in full detail.*

---

## 0. The machine (the axioms)

Seven ideas generate this language. Everything in §§1–15 is one of them stated in full; a rule that cannot be traced to one of them is either sugar over one or a defect worth reporting.

- **A1 — Columns are the syntax.** A document is lines; a line's column (its leading-space count) is the only structural operator. Deeper = child, same = sibling, shallower = closed (the Nesting Rule, §2.1). There are no closing tags because the column *is* the closing tag.

- **A2 — A line is a compressed stack of virtual lines.** Structure written mid-line sits at its true column, exactly as if written vertically (§2.1); along a line, each space-preceded, guard-confirmed block-form marker begins the next virtual line — that set *is* the value-terminator set (§6.4). Two operators manipulate the stream: a framed `\` is an explicit break into text (§4), and an inline form's `}` closes without a break — which is why only inline forms nest inside braces (§5.6: a block form's only closer is a break, and braces suspend them).

- **A3 — Sameline is value-space; block interiors are text-space.** All sameline material is an attribute value — the only question is which attribute (§2.2, §6). Prose lives in block interiors, where markers are literal (§7). One value grammar serves every value context; contexts differ only in added terminators and line root (§6.6). *(Inline-form interiors are the one deliberately mixed region — flow, §5.6/§7.3.)*

- **A4 — Everything named about an element is an assignment.** An element is name? + ordered assignments + ordered content, nothing else (§5.1). Every convenience — identity `[k]`, traits `.t`, suffixes, sameline text — is sugar desugaring to designated assignments (`$key`, `$traits`, `$?`…, `$main`), never a parallel mechanism (§5.3, §6.10). Assignments carry a label and ordered heterogeneous content (§6.1); repetition stacks, silently, and last-wins does not exist (§6.7); every assignment takes a value (§6.2).

- **A5 — Every construct closes geometrically or delimitedly.** Geometry (EOL, dedent, EOF) closes silently; a promised printed closer that never arrives warns and keeps (§13). End-of-input behavior is derived, not enumerated: EOF ≡ end-of-line + full dedent.

- **A6 — Typing is syntactic and the bare set is frozen.** Type comes from written syntax, never content-sniffing; the bare scalar set is closed forever, and all growth lives visibly in the envelope `<…>` (§11). A dialect structurally cannot retype bare space.

- **A7 — Keep everything; severity is loss.** Recognition never silently drops author-visible bytes; Warning means kept-but-check, Error means loss or a genuinely absent required value — and the sole core Error is the missing required value (§14).

**Scope guard.** The axioms are the arc, not a second rulebook: their normative content is exactly the law of the sections they cite. Where a reading of an axiom would decide something the sections leave open (CARVEOUTS, working-notes), the sections govern — the tension is a finding to surface, never a derivation to apply silently.

---

## 1. Conformance

A conforming **recognizer**:

1. Maps any finite UTF-8 input to a Document (MODEL §1) — content, anomalies, and result — per this specification.
2. Implements **Keep-Everything** wherever this document defines a keep path (§14).
3. Recognizes every marker, value form, and sugar desugaring here.
4. Treats meaning above recognition as optional: it MUST recognize Envelope and Dynamics *syntax*; it MAY leave their bodies unresolved when no Dialect is loaded.

A conforming recognizer is NOT required to implement any Dialect, Schema, mixin expansion, Markdown interpretation, or Reference resolution.

When a canonical fixture suite is published for a version of this contract, passing it is the operational definition of compliance; until then this prose is authoritative. A demonstrated divergence between prose and suite is a defect in one of the two, resolved by ruling — never by an implementation's behavior.

### 1.1 What the core fixes, and what it leaves open

The core fixes **syntax** and **core semantics**: marker recognition and guards, indentation geometry and the Nesting Rule, the frozen bare scalar set, assignments and stacking, definition (`|`) vs reference (`@`), envelope *syntax*, extent (geometric vs delimited) including end of input, and the anomaly contract. Everything else belongs to a consumer:

| Concern | Owner |
|---|---|
| Projection (validated string → native value) | Host |
| Constraint (what is allowed/required) | Schema |
| Exotic typing (what envelope contents mean) | Dialect |
| Reference resolution mode | Host (menu, §12.2) |
| Duplicate `(name, key)` policy | Document layer (menu, §12.3) |
| Mixin inheritance | Host (experimental, §12.4) |
| Markdown inside Text | layers above recognition |
| `$main` presentation (AST placement, text stitching) | Host (§6.10) |

Three boundary rules keep the split honest:

- **Menu vs knob.** The core MAY fix an option space and a default; a consumer picks within the menu and MUST NOT invent options outside it.
- **Dialects are not Schemas.** A dialect says what a value *means*; a schema says what is *allowed*. They never trade jobs.
- **Additivity.** Dialects act only inside envelopes (§11.6); bare recognition is frozen. Loading a dialect can never retype an existing document.

---

## 2. Source text and geometry

A UDON document is a sequence of Unicode scalar values encoded as UTF-8, divided into **lines** by U+000A. A final line need not end with a newline; end of input is newline-equivalent for geometric constructs (§13).

**Column** is the count of leading U+0020 SPACE characters before a line's first other character, counted from 0.

**Indentation is spaces only.** A tab participating in a line's indentation is an anomaly: the line's structural column cannot be honored, so the line is kept as **text of the current column owner** (best-effort, using the spaces before the tab as its column), with a **Warning** — a coherent keep exists, so by §14's own definition this is not an Error. A tab anywhere else (inside text, values, comments, verbatim bodies) is ordinary content.

### 2.1 The Nesting Rule

Open structural items (elements, block directives, block comments, block verbatim) form a stack, each with a **base column** — the column of its introducing marker. When a new structural line begins at column `c`:

```text
pop while c <= stack_top.base_column
then push the new item under the resulting top
```

Consequences:

- **Deeper column ⇒ child.** To be inside an element you must be at a column strictly greater than its marker's.
- **Same column ⇒ sibling** (the old top closes first).
- **Shallower column ⇒ dedent** — every open item at ≥ the new column closes, innermost first.

**Sameline nesting.** Elements introduced later on the same line occupy their true columns: `|a |b |c` is equivalent, for all hierarchy purposes, to the same elements on successive lines at those columns. A following line reasons against the resulting stack exactly as if the vertical form had been written. Once an item has closed, its former column has no residual meaning.

**Exception — text interior.** Once an element has an established **content base** for block text (§7.2), a line indented *deeper* than that base is inside the text — literal, even if it begins with a marker-looking character. Structure resumes at or left of the base.

A consistent sibling indent (commonly 2 spaces) is RECOMMENDED style, not a rule of the language. *(No ratified rule names a default indentation unit for tooling that must synthesize one — open item IND; see CARVEOUTS.)*

### 2.2 The two spaces: value-space and text-space

*(Axiom A3 in full.)* Every position in a document is in one of two spaces, and which one you are in predicts what characters mean. (One deliberately mixed region sits outside both: an inline form's brace interior, which follows flow rules — §5.6, §7.3.)

**Value-space** is every sameline position: the run of a line from its first marker through its end, traversed by the **Line Scan** (§6.4). In value-space there is no prose category — *all sameline material is an attribute value; the only question is which attribute*. Markers are live throughout the scan wherever a value has finished (§6.4's terminators); unquoted text is a value like any other, with its own closing delimiters.

**Text-space** is the block interior: lines that do not open structure at a structural column are **text of their column owner** (§7). Text-space is where prose lives. Within a text line, marker characters are literal, with the framed ` ; ` comment as the one carve-out (§8) — the old *commit* model, now scoped to text-space only.

**Structure Position** is the state in which markers are recognized: the start of every line's content at a structural column, and along the Line Scan wherever the scan sits between values. At Structure Position these markers are candidates, each confirmed by a short **guard** (§3):

| Marker | Opens |
|---|---|
| `\|` | element (§5); `\|{` inline element |
| `:` | attribute (§6) |
| `!` | directive / verbatim (§9, §10) |
| `;` | comment (§8) |
| `@` | reference (§12.2) |
| ` ``` ` | fence (§10) |

One further character is special at Structure Position and inside value-space: the escape `\` (§4).

Inside flow, the **inline forms** (§7.3) are recognized independently — they are flow's own structure, not line structure.

### 2.3 Bounded lookahead (language law)

Every guard resolves within a few characters, single-level, with no unbounded backtracking. This is a constraint on the **language**, not an implementation note: new syntax MUST stay inside the bound. Its consequence is streamability — a chunk boundary mid-guard simply waits for the missing characters; a document parses identically whole or byte-at-a-time. Chunk boundaries are never end of input.

---

## 3. Marker guards

- **`|`** opens an element when followed by: an identifier-start character (`XID_Start`), `[`, `.`, `'`, `{`, or a suffix character (`?` `!` `*` `+` — so anonymous `|?` parses). Otherwise `|` is text — in particular `| ` (pipe-space) is always literal, which preserves Markdown tables. A line-initial `|{` opens an **inline element** as the first segment of a flow line, participating in hierarchy at its column.
- **`!`** opens a dynamic when followed by an identifier character or `:` (`!if`, `!:lang:`). So `![img](x.png)`, `!=`, `!(` are text. The `!{…}` family is flow-level (inline forms), not this block rule.
- **`@`** marks a reference when followed by `[`, `.`, or an identifier-start character. `@` has equal footing with `|` in the Line Scan and in value position.
- **`:`** opens an attribute when followed by a non-space character — the label runs to the next space (§6.2). A `:` followed by space or end of line is text. Where no attribute can open (under an open assignment body — §6.8), a guard-passing `:`-line is warned text.
- **`;`** opens comments per the position table in §8.
- **` ``` `** opens a fence at any Structure Position (§10.3) — never inside text-space deeper than an established content base.

A marker character that **fails its guard** is ordinary text, and the line's (or value's) fate is decided as if it were any other character.

> **Least-surprise note.** Because a bare label may start with characters like `-` and `/`, framed emoticon shapes in *sameline* text (` :-)` ` :/`) pass the `:` guard and open attributes. This is accepted collateral, weighed on frequency: sameline text is value-space and careful territory; escape (`\:-)`) or quote when sameline text must carry such shapes, and syntax highlighting surfaces the misread instantly. Text-space prose is unaffected.

---

## 4. The escape `\`

`\` is UDON's only escape. It has exactly two operations, distinguished by its **frame**, plus a literal fallback:

| Spelling | Operation |
|---|---|
| **Framed ` \ `** — whitespace before, whitespace or end-of-line after | **Commit to text mode**: the rest of the physical line is text — leading spaces after the `\` preserved (the column-anchor idiom below), dead to markers *and* to the framed ` ; ` comment. If a value was open, the `\` first terminates it (it is one of §6.4's terminators). Ownership of the text follows §6.5 — the `\` sets the text's *mode*, never its owner. |
| **Attached `\X`** — `\` immediately before a character that would otherwise be structural at this position | **Escape one character**: `X` is literal; the token continues as ordinary text material; the scan machinery stays live after it — the framed ` ; ` still comments, §6.4's terminators still terminate. |
| **Anywhere else** | a literal backslash. `C:\Users\me`, a trailing `\` inside a token, `\w` mid-word all pass through; any escape-sequence reading (`\n`, line-joining) belongs to host layers. |

A literal leading backslash doubles: `\\x` → text `\x` (the first escapes the second).

**The column-anchor idiom.** A framed line-initial `\` occupies no column: the text after it backs into the `\`'s own column, and — being the line's first content — that column becomes the content base (§7.2). This makes a `\`-anchored first line the idiom for indenting a whole text block; only the first line needs it:

```udon
|el |another
   \     all of this is output indented,
         and deeper lines need no marker;
```

An **empty forced tail is a real, kept value**: value-position `:a \` with nothing after it is an empty-string value — no warning, not a missing value, peer to `:a ""` (end-of-line is the trailing frame). A lone framed `\` at end of input likewise forces an empty text line that must survive.

`'` is not an escape anywhere — it delimits strings, names, and quoted labels. Inside quoted strings, `\` is ordinary content (§11.3).

```udon
\|element              ->  |element        ; escaped marker -> text line
\:not-an-attr rest     ->  :not-an-attr rest
|el :hello \:value     ->  hello = ":value"      (escaped; ordinary token)
|el :a x \ y z         ->  a = "x"; $main = "y z"    (framed: text mode)
|el :a some words \ b  ->  a = "some words"; $main = "b"  (terminates the open value)
\\path\to              ->  \path\to        ; literal leading backslash
|p see \|{em x}        ->  literal "|{em x}", flow continues
|el :count \7 apples   ->  count = "7 apples" (escaped digit: text, not integer)
```

---

## 5. Elements

### 5.1 Shape

An element is **name (optional) + ordered assignments + ordered content** — nothing else. Identity, traits, suffixes, and sameline text are sugar over **designated attributes** (§5.3, §6.10); the model has no parallel fields (MODEL §3).

### 5.2 Names

A bare name is a Unicode identifier: first character `XID_Start` (letters — not digits, `_`, or `-`); each subsequent character `XID_Continue` or `-` or `/`. Kebab-case is first-class (`|my-element`); `/` is conventional namespacing with **zero** core semantics (`|acme/widget`). Any other character ends the bare name; names containing one take single quotes (`|'weird name'`). Which Unicode version supplies the `XID_*` properties is a host decision; the rule (UAX #31 plus `-` `/`) is the core's. Because XID properties change across Unicode versions, this is a **declared host-profile boundary**: a recognizer MUST state the Unicode data version it resolves `XID_*` against, and non-ASCII identifiers are **not portable** across implementations declaring different versions (ASCII names are stable everywhere). Pinning a version and an upgrade procedure is a future ruling (CARVEOUTS §UNI).

The suffix characters `? ! * +` are **not** name-continue characters for elements — a trailing one is a suffix (§5.4). (Attribute keys have a far wider character set; §6.2.)

### 5.3 Identity and classification (sugar)

```udon
|element[key].trait1.trait2
```

- **Identity `[key]`** — what makes this element *this one*. A key is not a different syntax; it is a **value slot**: the bracket interior takes the full value grammar (§6.4) with `]` as an additional unconsumed terminator — `[1]` is integer `1`, `["01"]` the string `"01"`, `[abc-123]` the string `abc-123`, `[one two]` the text `"one two"`, `[[one two]]` the list `["one","two"]`, `[<2026>]` an envelope, `[!{{id}}]` an interpolation, `[|{x}]` an inline element (the same value its longhand `:$key |{x}` binds). Material after a finished value inside the bracket is a **further stacked `$key` assignment, without warning**: `["one" two]` ≡ `|x["one"][two]`. Two spellings are held out of the bracket *sugar* for now, both lightly (either could be revisited): **block forms** (`|name` — geometric forms inside a single-line delimited bracket; a super-complex multiple-child key takes the longhand `:$key` form, always legal), and **bare `@` references** — a reference as a key takes the brace form `@{key}` (delimited slots take delimited forms; a bare selector nests brackets ambiguously). What *matching* a structural key means is a paths-era question (CARVEOUTS §PATHS); resolution defaults to inert meanwhile.
- **Multiple identity designators stack**: `|x[a][<uuid7:38493…>]` — each bracket desugars to its own `:$key` assignment, in order, like any repeated attribute.
- **Traits `.trait`** — what *kinds* of thing it is; plural, stackable, order-preserved. A bare trait is an identifier whose continue-set also includes `? ! * +` (so `.foo?` is the trait `foo?`); other characters take quotes (`.'ns.kind'`).

**All sugar desugars** into ordinary assignments to designated attributes:

| Written | Means |
|---|---|
| `\|el[k]` | `\|el :$key k` |
| `\|el.a.b` | `\|el :$traits a :$traits b` |
| `\|el?` | `\|el :$? true` (likewise `!` `*` `+` → `$!` `$*` `$+`) |
| `\|el some text` | `\|el :$main "some text"` (§6.10) |

Two traits are two `$traits` assignments (stacking, §6.7) — never one list.

**Designated, not reserved.** Any `$`-key is legal, and — because `$` is an ordinary key character — the longhand needs no quotes: `:$key 3890` is writable directly, so a generator that only writes attributes produces a document indistinguishable from the sugared form. (The pre-K12 quoted spelling `:'$key'` remains valid.)

**Sugar-produced assignments are born finished**: deeper lines never attach to a `$key`/`$traits`/`$main`/suffix assignment produced by sugar — they are the element's content, as always. (A longhand `:$key` is an ordinary attribute and takes deferred content like any other.)

**Identity is contiguous** with the name (plus one optional trailing space-separated suffix). A `.trait` after a space is not identity — `|p .gitignore is a file` has no traits (`.gitignore is a file` is the element's `$main`).

**Unclosed identity → `$partial-key` (fail-safe).** If the `]` never arrives — end of input, or an interior newline under current behavior (§13.2) — the captured-so-far value desugars under **`$partial-key`**, not `$key`, with a Warning citing the opener. The distinct name is deliberate: a consumer reading `$key`, or resolving a reference, automatically **excludes** a truncated identity rather than acting on it — for references especially, acting on a truncated key would be dangerous. The partial value is kept. The same rule protects a reference's selector key.

**Empty closed brackets** (single-line whitespace only): identity `|el[ ]`, reference key `@[ ]` → **nil** key; an array `[ ]` → **empty array** (0 items, not `[nil]`). The collapse requires a proper close — an *unclosed* whitespace bracket keeps its whitespace verbatim plus the unclosed Warning.

### 5.4 Suffixes

A trailing `?` `!` `*` `+` on the element identity desugars to a designated attribute with the explicit value `true` (`|field[name]?` → `:$? true`). The core performs only the expansion; meaning belongs to the consuming schema or dialect (a schema might read `?` optional / `!` required; a grammar might read `?` 0-or-1, `*` 0-or-more, `+` 1-or-more).

Positions — after the name, after the key, or space-separated at the end:

```udon
|name?      |name?[key]      |name?[key].trait
|name[key]?                  |name[key].trait ?
```

**Suffixes stack**: `|field?!` ≡ `|field :$? true :$! true`.

Because suffix characters are trait characters, a suffix touching a trait belongs to the trait:

```udon
|el.bar?         ; traits: ["bar?"]
|el.bar ?        ; traits: ["bar"], $? = true
|el?.bar         ; $? = true, traits: ["bar"]
```

*(Suffix sugar writes an explicit `true`; it is now the only place a bare `?` carries built-in meaning. Retiring it too is an open steward option — working-notes.)*

### 5.5 Anonymous elements

The name is optional: `|[k]`, `|.trait`, `|.trait :adapter pg`, `|?` are elements with no name, ordinary in every other respect. The core attaches no meaning to namelessness; consumers may (mixins, §12.4).

### 5.6 Inline elements `|{…}`

Within flow, `|{…}` opens an inline element:

- Brace-balanced; closes at the matching `}` (nested balanced `{}` fine).
- Name, identity, traits, suffixes, and attributes work as in §5–§6, with `}` as an additional (unconsumed) bare-token terminator.
- **Bracket mode:** inside `|{…}`, only inline forms nest — the block form `|name` does not exist there (`|ul |{li |{a Home}}`, never `|{li |a Home}`). *(Derivable under the virtual-line model: a block form's only closer is the LF/dedent machinery, and braces suspend LFs — see RATIONALE.)*
- **Multi-line** (settled): an inline element may span lines. Continuation indentation is geometry (skipped); each content line carries its terminator; the opener line's terminator belongs to the form when its line ends inside the braces. Consumers concatenate for a single string — exact by the text law.
- **Empty `|{}`** is a valid, empty anonymous inline element.
- **Interior text model:** an inline element's interior is genuinely mixed text-and-structure; the `$main` sugar does not apply inside braces, and intervening text between nested inline forms — including a single space — is interior content (round-trip fidelity). *(Contrast with brace forms at value positions, §6.4, where whitespace separates values.)*
- An inline element in flow is a segment of that flow; an inline element **as a value** is the value (§6.4).

---

## 6. Attributes

### 6.1 Labeled edges

Every element has assignments (a labeled, ordered edge list) and content (a positional node sequence). An assignment's label names what its content is *to the element* (`my author`, `my timeout`); a child names what it *is*. That — **whose name is it?** — is the design test, not "scalars vs structure": an edge may terminate at a leaf value, a node, several stacked values, or a heterogeneous body. Restricting attributes to single scalars was XML residue, not a UDON decision — this is *attribute-content unification*.

```text
Assignment = { label, content: [Item] }        (MODEL §3)
```

The common case — one value — is a one-item content, exactly as an element with one child is unremarkable. **On the line axis attributes are NOT element-like**: the Line Scan's one-value-per-slot discipline is what keeps `|el :a 1 :b 2` two attributes (the honest name is attribute-*content* unification, not attribute-as-element).

Assignments appear **sameline** (on the element's definition line), **block** (on their own indented line), and inside inline elements — one value grammar throughout; only terminator sets and line roots differ (§6.6).

**Root-level attribute.** A line-initial `:label` with no owning element is a **Warning**; the line is kept as document-level text, `:` included — nothing is lost, so severity is Warning under §14. Attributes are edges of elements; there is no phantom owner, and root attributes have no portable meaning. *(Ruled L1.)*

### 6.2 Labels

An assignment's name-side is its **label** ("key" is reserved for identity — §5.3; the disambiguation exemplar: `$key` keeps its spelling because it *is* the identity key, held by an assignment whose **label** is `$key`). A **bare label** is a contiguous run of non-space characters following the `:`. Beyond Unicode identifier characters, the run may contain — **in any position** — `*` `$` `#` `!` `?` `^` `.` `,` `-` `+` `_` `=` `~` `/` `:` `;` `|`, and interior `'` or `"`. A *leading* `'` or `"` instead selects a quoted label (`:'weird key'`), inside which anything but the closing quote is literal. `/` is namespacing convention, core-inert.

There are no flag labels and no built-in label semantics — the retired implicit-true default was not worth the complication it bought: `?` `!` `*` `+` and every other character are simply part of the name. Application-level conventions (arity suffixes, grouping prefixes) are free to assign meaning; the core stores the spelling.

**Every assignment takes a value** — an edge with no terminus is malformed, not smaller. A `:label` with no value material — end of line with **nothing indented under it**, or a context terminator — is an **Error**; the assignment still stands with value **Nil** (the shape never carries less than the source suggested; the Error explains the Nil). The "nothing indented under it" clause is load-bearing: when deeper lines *do* follow, the assignment's **deferred body opens instead** (§6.5) and no missing-value Error fires. Presence is written explicitly:

```udon
|button :disabled? true :type submit    ; presence is explicit
```

Four distinct states, one Error (§11.4): **Absent** (no assignment) · **Nil** (`:label nil`, or the Error-produced Nil) · **False** (`:key false`) · **True** (`:key true`, or suffix sugar).

### 6.3 Value kinds

An item of an assignment's content is one of:

| Kind | Forms |
|---|---|
| **Scalar** | quoted string, bare single-token string (§11.1), number, `true`/`false`/`null`/`nil` alone, list `[…]`, envelope `<…>` |
| **Reference** | `@…` (an inert selector, §12.2) |
| **Interpolation** | `!{{…}}` (carried unparsed; host evaluates) |
| **Inline value** | an inline element `\|{…}` or inline verbatim `!{:kind:…}` standing as a value (§6.4) |
| **Node value** | block-form `\|element`, block verbatim `!:lang:`, a fence, or a block directive `!name` (carried inert — §9) — the value *is* that node |
| **Text value** | unquoted text (§6.4) or `\`-forced text; a flow — it may contain inline segments |

Types live on the value side — assignment values and array items. The envelope is meaningful in value position and nowhere in text-space.

A reference in value position is the attribute's value; the same reference as a block line (or after a finished value at a terminator) is the **element's** reference child — `@` and `|` behave identically here.

### 6.4 The Line Scan and value terminators

A `:` passing its guard opens an attribute; after the label, its value material is collected; then the **Line Scan** continues — uniformly, sameline and block alike:

```udon
|el
  :a 1 :b 2      ; two attributes
```

**Self-announcing values.** Most value shapes announce their extent from their first character — digit or sign → number, `"`/`'` → string, `<` → envelope, `[` → list, `@` → reference, `!{{` → interpolation, block-form `|name` → node — and self-terminate; the scan continues after each. A committed token that goes wrong mid-way (`12ab`) falls through, token-locally, to an ordinary text token (`:x 12ab :y 3` → `x="12ab"`, `y=3`).

**Brace forms at a value position.** At a **value-expected position** — a value slot where no text has committed — an inline element `|{…}` or inline verbatim `!{:kind:…}` **self-delimits as a value** (brace-balanced) and the scan continues; whitespace between values is a separator, not content. This holds **wherever a value is expected** — the sameline `$main` slot, attribute value slots (sameline and block), list items, identity/selector bracket interiors, and a deferred body's first line (§6.5) — one value grammar, no per-context table. **Mid-flow the rule inverts**: once a text value has committed, a brace form is a segment of it, never a terminator (`:n value |{em x} :a 1` → `n` holds the whole flow, `:a` included).

```udon
|el |{embed-1} |{embed-2}   ; two stacked $main values — siblings, no space content
|el :n |{em x} :a 1         ; n = the inline element; :a is a real attribute
```

**Unquoted text values** are just like quoted text values, with different closing delimiters. One begins at any value position where the material is not self-announcing, and runs until —

- a space followed by a **guard-confirmed block-form marker** — `:label`, `|name`, `@ref`, `!name`, `!:…:`, a fence — which terminates the value and continues the scan;
- a **framed `\`** (§4) — terminates the value and commits the rest of the line to text mode;
- a **framed ` ; `** — terminates the value and opens a sameline comment;
- **end of line**, or the context's terminator (`}` in an inline element, `]` in a list or identity bracket — unconsumed).

```udon
|element :something something else
  :another one  :and-another <please>
; four attributes: something="something else", another="one", and-another=<please>
|element :first with a value and :second with it's own
; two attributes — ` :second` is a framed guard-confirmed marker
|el :url https://x.io/a?q=1;s=2 :b 1
; unspaced ; and : are token content; b is an attribute (framed ` :b` terminates)
```

A marker that **fails its guard** is not a terminator — it is ordinary content of the open value (`3:1` unspaced, `| ` pipe-space, `!=`). An **attached `\X`** escape (§4) makes a would-be terminator ordinary content: with a text value **open** at that position, the escaped material joins it and the value continues — `:a hello \:-) how are you?` → `a = "hello :-) how are you?"`, no `$main`. *(Open lean — working-notes Q8.)*

**Keywords at a terminator.** `true` / `false` / `null` / `nil` are typed only when the token finishes alone — its end meets a terminator. Followed by more text they are the first word of a text value (`:alpha true story :b 1` → `alpha="true story"`, `b=1`).

### 6.5 Slots and line roots (ownership)

Ownership on a line follows two rules, in order:

1. **The open slot owns.** An attribute whose value is still expected (label just read, or an escape opening its value) owns the next value material.
2. **Otherwise, the line root's stack.** After a value finishes, further value material belongs to the **line root**: on an **element-rooted line**, further values stack as the element's **`$main`** (§6.10) and further `:label`s open new attributes; on a **block attribute line** (rooted by `:label`, no element on it), further values **stack on that label** (silently) and further `:label`s open new sibling attributes.

Block text lines (text-space) follow ordinary column ownership (§7) — not an anomaly, not this section.

```udon
|el :first value :another with some text
; first="value"; another="with some text"
|el :first value :another "with" some text
; first="value"; another="with"; $main="some text"        (line root: element)
|el
  :first "one" two                       ; first ≈ ["one","two"] — stacked, silent
```

**Deferred bodies.** If an assignment's label ends its line with no finished value — sameline and block attributes uniformly — the deeper lines under it are the assignment's **content**, under ordinary column and content-base rules: heterogeneous items, exactly like element content. **The body's first line carries the value-expected position**: a lone self-announcing token there types (`:port` + deeper `5432` → Integer 5432), `nil` alone is Nil, a brace form is a value (§6.4), a text-committing line begins text. Only the first line is ever value-special — later lone tokens are ordinary text (no per-line typing: re-wrapping text must never retype a document) — with `\` and quoting as the first-line escapes.

```udon
|el
  :body
    line one

    line two with |{em emphasis}
  :recipe
    1234                ; first line: typed Integer item
    and here is prose   ; then ordinary content
    |step :n 1          ; heterogeneous items are fine
    ; a comment — preserved as an item (MODEL §5)
```

**Value-position `\`.** Where an attribute still expects a value, an attached `\X` escapes into a text value owned by that attribute (`:count \7 apples` → `"7 apples"`); a lone `:a \` is the kept empty string (§4). At any *finished*-value position, `\` behaves per §4 with ownership by the rules above — the `\` sets the text's mode, never its owner.

### 6.6 Contexts and terminators

One value grammar; contexts differ only in added terminators and line root:

| Context | Added terminators | Post-value material goes to |
|---|---|---|
| Element-rooted line | *(none beyond §6.4)* | `$main` stack / new attributes |
| Block attribute line | *(none beyond §6.4)* | the label's stack / new attributes |
| Inline element `\|{…}` | `}` (unconsumed) | the inline element's interior content |
| List item | `]` (unconsumed) | *(items have no tails — next item)* |
| Identity / selector bracket | `]` (unconsumed) | further stacked `$key` (silent) |

- A framed ` ; ` opens a comment on element and block-attribute lines (never inside framed-`\` text mode). An unspaced `;` is token content.
- Inside `|{…}` there are **no framed sameline comments** — a bare `;` is literal; only `;{…}` comments there (revisit with dialects). One edge is narrower than that rule: a framed ` ; ` after **value-`\` text** inside an inline element (`|{a :title Home \ Welcome! ; hm}`) is **unspecified this version** — do not rely on either reading.
- `}` is not a terminator inside `[…]`: an inline element's `}` must follow the `]`; a `[` unclosed at the `}` is an unclosed list (content kept, Warning).

### 6.7 Stacking: a label names a collection

A label names a **collection of contributions**. Each occurrence of the label appends its value as one item — sameline, block, or interleaved with other labels, all the same act — and a bracketed list is one contribution that *is* a sequence. Nothing flattens and nothing is lost: nesting written is nesting kept.

```udon
|el
  :x 1
  :x [2 3]
  :x [4 [5 6]]
; x's contributions, in order: 1 · [2 3] · [4 [5 6]]
; default read: [1 [2 3] [4 [5 6]]] — flattening beyond this is the app's call
```

The **default read** (MODEL §3.2): one contribution reads as the value itself (`:x 1` → `1`; `:x [2 3]` → the list `[2 3]`); several read as the list of contributions in order. An always-list accessor is available for uniform consumer code. A consequence needing no rule of its own: `:attr |{a} |{b}` (two contributions) and `:attr [|{a} |{b}]` (one contribution that is that list) read the same — until a further contribution stacks, at which point the grouping the author wrote distinguishes them (`[[a b], c]` vs `[a, b, c]`).

Last-wins does not exist in UDON, and stacking is **silent** everywhere. Spelling the same contribution set as stacked occurrences vs a bracketed literal is **ornamentation** — same class as edge blank lines (§7.4): the model records the difference, an assembler MAY annotate the flavor (e.g. `contributed-as: stacked · array · deferred`) so faithful round-trip reconstructs spelling without spans, and data consumers ignore it.

What is *allowed* (e.g. forbidding a multi-valued `$key`) is schema territory, never core.

### 6.8 Node values

An assignment's value may **be** a node — a block-form element, block verbatim, fence, or block directive (inert, §9) — with no anonymous wrapper:

```udon
|api :headers |header :name Content-Type :value application/json
|el
  :beta
    |veni-vidi-vici :working 1234
|el :script !:sh: make build
```

- **Block form and brace form both bind at a value-expected position**: `:x |em hi` and `:x |{em hi}` both make the `em` element the value, and are model-equivalent (SEMANTICS §2). They differ mid-flow, where a brace form is a segment and a block form is a terminator.
- **The one-way door.** Once a block-form node opens, its Line Scan owns the rest of the line — identity, attributes, text, children. `|api :headers |header :k v :timeout 30` gives `timeout` to the *header*. Put the outer element's attributes first, or defer the node to a block.
- **No attribute-under-attribute.** A deeper line that is itself `:label`-shaped directly under an open assignment body (not inside a node value) is kept as **text of the open body** with a **Warning** — text that looks like an attribute. *(The language has no nested attributes, so no intended structure is absent — Warning, not Error; and warn-before-disallow keeps the grouping-sugar door open — OPEN ATTR-GROUP.)* Maps-of-maps take a named node carrier: `:theta` + deeper `|config :first 1 :second 2`.
- To give an element both attributes and a node child on one line, order does it: `|el :a 1 |beta`.

### 6.9 Late attributes (accept and warn)

Attributes may appear **after** an element's block content has begun: a line-initial `:label` at the element's attribute column is a **real attribute of that element**, with a **Warning**. The Warning marks likely-unintended placement, not invalidity; deliberate late attributes are legal.

```udon
|element this prose is the first child
  :status pretty much open      ; ordinary attribute — silent ($main is sugar,
                                ; not content: the attribute window is open)
  Some more children
  :a-rogue-attribute <value>    ; attribute of element, with a Warning
```

- `$main` assignments (sameline text) do **not** begin content: a sameline-only element is fully open to silent block attributes below.
- An attribute's deferred body does not begin its *element's* content: `:desc` + body lines, then `:next 1` at the sibling column, is an ordinary silent attribute.
- Under an *attribute's* open body the rule is different — there, a `:label`-shaped line is warned **text** (§6.8), because attributes cannot have attributes.
- **Consumer note (streaming identity):** because designated keys are ordinary attributes, a late `:$key` is now possible with only a Warning — resolvers and duplicate-detection MUST NOT treat an element's identity as complete before the element closes.

### 6.10 The element's value: `$main`

An element's sameline text is sugar for the designated attribute **`$main`**: *sameline is value-space — all sameline material is an attribute value, and unowned material's attribute is `$main`.*

```udon
|element[123]  And here is some sameline text
  :attr1  <1234>
===
|element :$key 123 :$main "And here is some sameline text" :attr1 <1234>
```

- **The sameline slot is a typed value position.** Self-announcing values become `$main` values and return the scan — `|element "here we go!" |child …` chains; `|element <1234>` gives an envelope `$main`. Unquoted text is a text value per §6.4's terminators. Sequences are **stacked `$main` assignments** (the substrate; an array is the view): `|a "Some text" some more text` → two `$main`s.
- **Guidance:** sameline text is a scalar — start a *body* of text next-line-indented, especially if it opens with `"`, `<`, or `[`; or escape the opener (`\"Hello," she said` keeps the quotes visible — §4).
- **`$main` is an ordinary attribute with respect to the text law** (MODEL §6): it is *not* text material — it is an attribute on the wire, and parser/host parameters decide its AST presentation (e.g. a `first_is_main`-style re-injection knob). Sameline text and block text are therefore **different documents by design** — reflowing between them is a semantic edit (SEMANTICS §3). This also closes a real model hole: sameline-vs-block text position was previously recoverable only via spans.
- Inline elements written at the `$main` slot are values (§6.4); inline elements *inside* a committed `$main` text value are its segments. The interior-content rule of §5.6 is untouched.
- `$main` establishes no content base and does not begin content (§6.9, §7.2).

---

## 7. Text

### 7.1 Text-space and flow

**Flow** is the one prose-shaped content model: an ordered sequence of segments — text runs, inline elements, interpolations, inline directives, inline verbatims, inline comments — that resolves to text once each segment's layer processes it (comments stripped, interpolations evaluated, inline elements rendered). Flow has three homes with one rule set: block text (element content), text values (§6.4), and inline-form interiors.

Any line that does not open structure at Structure Position is flow text of its column owner — **text-space**, where prose lives. Text is **opaque** to the core: Markdown inside it is not interpreted; `#`, `<`, and pipe-space have no meaning there. Which Markdown subset renderers honor is a companion-layer concern (CARVEOUTS). Style guidance (prefer Markdown for simple emphasis; reserve `|{…}` for attributed structure) is pedagogy, not this contract.

Sameline text is `$main` (§6.10) and establishes no content base; block text does.

### 7.2 The content base and dedentation

1. The element's `$main`, if any, establishes nothing.
2. The first indented text line establishes the **content base** — the author's choice of column, anywhere strictly inside the parent (deeper than the parent's marker; at most an inline child's column when one exists).
3. Each later line at ≥ the base contributes its text with base-many leading spaces stripped; extra indentation beyond the base is preserved as text.
4. A line shallower than the base but still inside the element **warns** and re-bases: the base becomes the shallower column and parsing continues. (Per-line delivery means earlier lines were stripped by the old base; the warning marks the inconsistency.)
5. A line deeper than an established base is *inside the text*: markers there are literal (§2.1 exception). Structure resumes at or left of the base.

Each text line's terminator is part of its text; stripped indentation is geometry (MODEL §6, the text law). Fences strip nothing (§10.3).

### 7.3 Inline forms

All brace-delimited forms recognized inside flow; the character after the opener disambiguates with no lookahead:

| Form | Meaning |
|---|---|
| `\|{name … content}` | inline element (§5.6) |
| `!{{expr}}` | interpolation — ends at the **first** `}}` |
| `!{name …}` | inline directive; body is UDON flow |
| `!{:kind: …}` | inline verbatim (§10.2) |
| `;{…}` | inline comment; contributes no text |

Brace counting: `|{…}`, `;{…}`, `!{…}`, `!{:kind:…}` close on the balancing `}`; `!{{…}}` alone closes on the first `}}` (a single `}` is expression content). Unbalanced-brace content belongs in block forms. `\` before an opener makes it literal (§4).

### 7.4 Blank and whitespace-only lines (the two-layer model)

- A blank line whose whitespace does **not** protrude past the text content base is a **blank line** at the recognition layer (whitespace covered, round-trip safe) and contributes `"\n"` to text reconstruction.
- Whitespace protruding **past** the base is text content, extra whitespace preserved (ordinary dedentation).
- A framed `\` on an otherwise-blank line forces a kept empty text line.
- **Interpretation is the consumer's**: interior blanks between text lines are newlines; leading/trailing blanks at structure boundaries are **ornamentation** (UDON-level decoration, not text content) — or kept as literal blank-line nodes for reversibility. (Exact placement of blank-vs-dedent at structural seams is deferred — S9, CARVEOUTS.)

**Final-terminator disposition**: interior newlines within a text run are text. A run's final terminator riding *inside* its last content-bearing line (…`\ tail`⏎ then structure) is ornamental — trimmed by the consumer; an author's `\` at the very *end* of a line (empty forced tail) is an **explicit** newline — kept. "The only reason I'd put the backslash at the end like that is because I *do* want the explicit newline."

---

## 8. Comments

`;` comments by position:

| Position | Behavior |
|---|---|
| Line start, structural column | line comment |
| After a finished value (framed ` ; `) | line comment |
| Within an open unquoted text value (framed ` ; `) | line comment — terminates the value (§6.4) |
| In block text **at** the content base | line comment |
| In block text deeper than the base | literal |
| In framed-`\` text mode (any) | literal |
| Inside `\|{…}` (bare) | literal — only `;{…}` comments there |
| In flow, as `;{…}` | inline comment |

The **frame** for a sameline comment is whitespace before the `;` and whitespace or end-of-line after: `x ; c` comments; `x ;c`, `1;2` do not; a trailing `x ;` is an empty comment.

The frame requirement is a property of the *framed* positions only. In the no-frame positions (line start at a structural column; after a finished value on element/block-attribute lines), a `;` opens the comment with or without a following space — `;comment` at line start is a comment (a host MAY surface a style advisory for the missing space; see Appendix B).

**Comments are carried, not discarded** — they appear in the model (MODEL §5) and consumers decide their fate (documentation extraction, TODO tracking, stripping). Comment content is inert: never interpreted.

**Continuation.** A line comment owns everything indented deeper than it — markers, structure, fences, everything — until a line at or left of its column. The first continuation line sets the comment's strip column (content-base shape); deeper lines keep their extra indent as comment text. This is what lets one `;` silence an entire block, including structure that is itself failing to parse. Comments participate in the column hierarchy like any node (a comment at column 0 closes everything open).

Inline `;{…}` framing whitespace is **preserved** on strip (both framing spaces are prose; pure concatenation keeps them; revisit with dialects). To output a literal `;` at line start, lead with `\` (§4).

```udon
; a comment
  still part of the comment (any structure here is comment text)
\; this line is output as text starting with ";"
|li Item one ; TODO expand     ; framed -> comment
|li ratio 1;2 done             ; unframed -> literal
```

---

## 9. Dynamics (syntax only)

The `!` marker introduces **dynamics**. The core recognizes five forms and carries them; their meaning belongs to a host dialect (the baseline Liquid-style dialect lives in the DYNAMICS companion; a conforming recognizer needs none of it):

| Form | Recognition |
|---|---|
| `!name …` at Structure Position | **directive** — any name (the core does not enumerate); head-line remainder carried unparsed; deeper content parsed as UDON, closed geometrically |
| `!:kind:` | block verbatim (§10.1) |
| `!{{expr}}` | **interpolation** — expression carried unparsed |
| `!{name …}` | inline directive (UDON-parsed body) |
| `!{:kind: …}` | inline verbatim (§10.2) |

Directives nest by column like elements; a dedent closes them. `!else` / `!elif` chains are dialect semantics over adjacent directives, not core structure. *(A directive standing as a value has no sameline adjacency slot for a chain; under K5 a following `!else` on a deeper line lands in the assignment's content, restoring adjacency there.)*

**Placement.** A block directive may sit anywhere an element can — child position, and value position as a node value (§6.3, §6.8) — but not where block-form elements also cannot go (list items, bracket interiors). In this version directives are **inert**: recognized, carried verbatim (head unparsed, body as UDON), never resolved — deliberately, so dialect experiments can run on faithfully carried forms.

> [!warning] The head swallows the rest of the line. A directive's head-line remainder is carried **unparsed**: in `|el :x !if cond :y 2`, the `:y 2` is part of the head string — not an attribute of `el`, not an attribute of anything. This is one step harsher than the node-value one-way door (§6.8), where a trailing `:key` at least binds to the node. Put the outer element's attributes first, or defer the directive to a block line.

Interpolations may appear in flow, as whole values, as list items, and as a whole identity key. A mixed literal-and-interpolation value (`pre!{{x}}post`, `!{{base}}/path`) is a **text value** — text and interpolation segments, whole-value `!{{x}}` the one-segment degenerate.

A **nameless** `!{` at end of input (nothing after the opener) is text `"!{"` — no directive ever started.

---

## 10. Verbatim

**Verbatim** is content never parsed as UDON: one family carrying a `form` and optional `kind` around an opaque body, in three geometries:

| Form | Syntax | Extent | Dedent |
|---|---|---|---|
| block | `!:kind:` | geometric (dedent) | to the body's first-content-line column (the raw base) |
| fence | ` ``` ` | delimited (closing fence) | none — byte-exact |
| inline | `!{:kind: …}` | delimited (balanced `}`) | n/a |

"Raw," "freeform," and "blob" as free nouns are retired in favor of this family (GLOSSARY).

### 10.1 Block form

```udon
|example
  !:elixir:
    def hello do
      IO.puts("world")     ; not UDON — captured exactly
    end
```

The colon-wrapped kind passes to the host uninterpreted. The body is every deeper line, dedented to the **first content line's column**; deeper indentation is preserved as body; a line at or left of the directive's column ends the block. The body MAY begin on the directive line itself — `!:sh: echo hi` captures `echo hi` — whitespace after the closing `:` separates; a same-line tail does **not** establish the raw base (same shape as fences). An empty same-line body after the separator is an **empty body**, not "no body". All of this holds uniformly in node-value position (`|el :script !:sh: make build`).

### 10.2 Inline form

```udon
|p The response was !{:json: {"status": "ok", "count": 42}} as expected.
```

Brace-counted (balanced `{}` allowed); a single space after the kind's closing `:` is a separator, not body. Unbalanced braces need the block form. At a value-expected position the inline form **is the value**; mid-flow it is a segment, uniform with the other inline brace forms.

### 10.3 Fence

A fence opens at any Structure Position — line start or in the Line Scan after elements and attributes — never inside text-space deeper than an established content base. Its indentation sets its structural parent; everything after the opening backticks begins the body (its kind, for free). The body is captured **byte-exactly**: no dedentation, no marker interpretation, blank body lines are literal newlines, every body line keeps its terminator.

A line whose first non-space content is ` ``` ` closes the fence, at any indentation (whitespace right of the closer is trimmed; the closer must be followed by its line end). Indentation *of* the closing line was already body on the preceding lines — put the closer at column 0 unless that indent is wanted.

Use a fence when byte-exactness matters (assembling files without indent control, broken tooling); use `!:lang:` for ordinary code samples.

---

## 11. Values and types

### 11.1 Syntactic typing and the frozen bare set

Type comes from written syntax, never from sniffing content. The **bare scalar set** — recognized from bare syntax alone — is **closed forever**: string, integer, float, boolean, nil, list. Every other type is written in the envelope (§11.6). Nothing is ever added to bare recognition; this is what makes dialect growth structurally unable to retype existing documents (YAML's Norway problem is the canonical counter-case).

| Syntax | Type |
|---|---|
| `"…"` or `'…'` | String |
| `42`, `1_000_000`, `0xFF`, `0o755`, `0b1010`, `0d42` | Integer |
| `3.14`, `1e10`, `1.5e-3` | Float |
| `true`, `false` (lowercase, alone at a terminator) | Boolean |
| `null`, `nil` (alone; equivalent) | Nil |
| `[…]` | List |
| `<…>` | Envelope (dialect-typed; not itself a core scalar) |
| otherwise | String (single token meeting a terminator) or text value |

`TRUE`, `True` are strings. A bare `2026-07-11` is the string `"2026-07-11"` — **all temporal values require the envelope** (the `temporal@1` dialect; the old bare-temporal model is superseded).

**Rational and complex are not bare scalars** (`1/3r`, `3+4i`, `5i`). Bare numeric recognition is frozen to integer + float. Their future home is a standard-types dialect via the envelope; the in-dialect spelling is open (CARVEOUTS). Unquoted, those spellings are ordinary text values today.

### 11.2 Numbers

**Integers** — optional leading `+`/`-`; `_` between digits of any base, value-neutral; four bases by explicit `0`-prefix:

| Base | Prefix | Example |
|---|---|---|
| Decimal | none, or `0d`/`0D` | `42`, `1_000_000`, `0d42` |
| Hexadecimal | `0x`/`0X` | `0xFF` |
| Octal | `0o`/`0O` | `0o755` |
| Binary | `0b`/`0B` | `0b1010` |

A leading `0` before more decimal digits is decimal — `0755` is `755`; `0d` is the explicit way to *say* decimal.

**Floats** are decimal numbers with a fractional part (`.` + digits), an exponent (`e`/`E`, optional sign, digits), or both. A decimal token with neither is an integer.

### 11.3 Strings

`"…"` and `'…'` quote. A string closes at the next occurrence of its own quote character; interior bytes — `\` included — pass through untouched (§4 does not apply inside strings). **There are no core in-string escapes**: to contain one quote kind, use the other (`"it's"`, `'say "hi"'`); hosts MUST NOT invent core escapes (the positional-`\` story stays whole; doubling would collide with adjacent quoted list items, §11.5).

The bare fallback: an unquoted single token that is nothing else is a string.

### 11.4 Booleans and nil

Lowercase only, typed only when alone at a terminator (§6.4). `null` ≡ `nil`. Four distinct states, none of them the missing-value Error:

- **Absent** — label not present
- **Nil** — label present, explicitly no value
- **False** — boolean false
- **True** — explicit `true`, or element suffix sugar (`$?` etc.)

Attributes require a value; there is no implicit nil and no implicit true (a bare `:label` is the §6.2 Error with value Nil). Absent = no assignment; Nil = an assignment whose value is Nil, written `nil` or Error-produced.

### 11.5 Lists

`[…]` in value position: items space-delimited, each typed independently by the **full** value rules — numbers, strings, envelopes, nested lists, references, interpolations, and inline elements/verbatims (§6.4: item slots are value-expected positions) are all valid items. No multi-word unquoted text inside a list — a bare item is one token; quote items with spaces. A quoted item's closing quote ends it: `["x"y]` and `["x""y]` are two items each, like `["x" y]`. `[ ]` (whitespace only, closed) is the empty array. Two notes: hosts projecting lists to native arrays need a policy for structured items (same knob family as `$main` presentation); an *unclosed* `|{` item at end of line falls under the multi-line carve-out (CARVEOUTS §ML) — the same tension multi-line strings in lists already have, needing no rule of its own.

### 11.6 The envelope `<…>`

Every non-core type is written inside `<…>` in value position — assignment values and list items alike. In text-space or inside quotes, `<` is ordinary. To write a literal string beginning `<` as a value, quote it.

```udon
:when <2026-07-11>                          ; unlabelled
:size <u64:0xf902>                          ; type-labelled
:span <temporal:interval:2026-01/2026-06>   ; dialect-and-type-labelled
```

- A bare value beginning `<` opens the envelope; the **matching** `>` (depth-counted — nested envelopes parse) closes it.
- **Envelopes span newlines** (settled multi-line): an interior newline is content; unclosed at end of input → content kept, Warning (§13).
- **Envelope ladder:** `<content>` → `<type:content>` → `<dialect:type:content>`, least to most specific. *(Rename from “label ladder” provisional — UNIF-PASS-QUESTIONS Q7.)*
- **Unlabelled dispatch:** offered to the document's declared dialects in declared order; first claim wins; if all decline, an **Error**. No sniffing race. Which dialects are active by default is a host choice.
- **No dialect loaded (interim):** a conforming recognizer still parses the envelope's extent, carries the value as its full lexical form with a Warning (`:dur <5m>` → the string `"<5m>"` + no-dialects warning), and loses nothing; when dialects land the same document retypes identically, minus the warning. A closed empty `<>` stays this interim string; the `< >` → nil collapse is a dialect-era refinement (CARVEOUTS).
- **Nested-envelope routing** — who hands inner typed values to whom — is deliberately open; only the `<>`-balanced span is guaranteed (CARVEOUTS).

The envelope is the visible core/dialect boundary: bare means frozen core scalar or string; `<…>` means a dialect answers. Dialects never touch bare space, so adding one can never silently retype a document.

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

- **Traits are selection criteria** — they filter which definition matches; a reference never decorates or mutates its target. Deliberately absent: suffixes, attributes, predicates, nesting. To vary content, define a new element.
- The tuple is **frozen at three fields** pending path design — no incremental growth; a path syntax, when it comes, replaces it wholesale, and cross-document addressing is in scope for that design. **Inputs the paths design inherits:** multi-key elements exist (`$key` designators stack), so what `@x[k]` matches against a stacked-key element is a paths question; structural-key matching is likewise deferred there. See CARVEOUTS.
- **Inside a key bracket**, a reference takes the brace form: `|el[@{key}]`. The bare `@` spelling is held out of the bracket sugar (delimited slots take delimited forms — a bare selector nests brackets ambiguously). The `@{…}` inline reference form is thereby demanded; its full grammar is paths-era work.
- The core recognizes; it never resolves. Resolution **menu**: `transclude` | `merge-attributes` | `leave-inert` (default inert). Key-only `@[k]` may be ambiguous across names; recognition succeeds; resolve time MAY error.
- An unclosed selector key fails safe exactly like identity: the selector is marked partial and resolvers MUST exclude it (§5.3).

### 12.3 Duplicate definitions

Two elements of the same name sharing a key are a **duplicate definition** — never a re-open or merge. This is a Document-layer concern over `(element-name, key)`; the streaming recognizer cannot and does not check it. **Menu** (default **error**):  
`error | allow-if-identical | first-wins | last-wins | keep-all`, plus an optional `warn` modifier. `allow-if-identical` compares by tree equality ignoring spans. References play no part in uniqueness. *(Late `$key` assignments — legal with a Warning per §6.9 — mean identity is complete only at element close.)*

### 12.4 Mixins (experimental, non-core)

A host MAY read an anonymous, trait-only element as a mixin — elements carrying the same trait inherit its attributes:

```udon
|.defaults
  :adapter postgres
|database[prod].defaults
  :database prod_db      ; a mixin-aware host also gives it adapter
```

The core sees only what is written; a recognizer that does no mixin resolution is fully conformant. (Ruled S13: remains a host experiment.)

### 12.5 Annotation convention (non-core)

Inline annotation is a named-element convention — e.g.  
`|{note :confidence 0.7 …}` with a schema-owned vocabulary, strippable by consumers. Richer annotation syntax is deferred to the demand-side work (CARVEOUTS).

---

## 13. Extent and end of input

### 13.1 Geometric vs delimited

Every construct closes one of two ways, and every new construct MUST declare which:

- **Geometric** — extent from geometry: end of line, dedent, or end of input. Elements, assignments and their deferred bodies, comments, directives, block verbatim, text blocks.
- **Delimited** — only at a matching printed end-sequence: quoted strings, lists, identity/selector brackets, inline forms, interpolations, envelopes, fences.

This taxonomy is what makes end-of-input behavior derivable rather than enumerated.

### 13.2 Multi-line status (current version)

Three delimited forms are **settled multi-line** and stay that way: the inline element `|{…}`, the fence, and the envelope `<…>` (interior newlines are content).

For **every other** delimited form — quoted strings, `[…]` lists, identity and selector brackets, `!{{…}}` interpolation, `;{…}` inline comments, and the `!{…}` / `!{:kind:…}` inline directive/verbatim — spanning a line terminator is **deliberately not specified**, pending the demand-side aux work (dialects, schemas, paths, value typing). This is a carve-out with a reason, not an oversight: if bracketed and quoted captures turn out to be sugar for dialect-typed captures, each capture's grammar owns its own line-span and there is no per-construct table to close — the question dissolves rather than resolves. **Do not close this per-construct**; see CARVEOUTS (ML) for the full reasoning and what would settle it.

> [!caution] CURRENT BEHAVIOR (non-normative, descriptive only) The 0.9-era reference parser: strings and interpolations span the newline (content); lists and identity keys close at the newline with their content kept and a Warning (identity via `$partial-key`). Ratified only as "undefined-but-warn-before-disallow" (S2): pinning fixtures must be framed descriptively ("PINS CURRENT PARSER"), and a future version may define multi-line or warn — it will not silently change meaning. **A fixture or tool that treats this table as expected behavior of the language — rather than of that parser — is non-conformant with this suite's scope claim.**

### 13.3 End of input

At true end of input, every open construct closes, innermost first:

- A **geometric** construct closes by its ordinary end rule, **silently** — EOF is newline-equivalent, and a missing final newline is never, by itself, an anomaly. Every remaining EOF edge is governed by **EOF ≡ end-of-line + full dedent** — no special cases (`;`⟨EOF⟩ ≡ `;⏎`; a bare marker as the final byte is text by its failed guard, not an unexpected EOF).
- A still-open **delimited** construct keeps everything that arrived (which may be nothing beyond the opener), closes, and yields **one Warning citing where it opened**; nested open constructs yield one warning each, unwinding innermost-first. Kept content is delivered before the warning (content first, then the unclosed signal, then the close).

**The incomplete-input result.** A delimited construct still open at true end of input additionally marks the **document** result `incomplete-input` (MODEL §1): the input is presumed truncated or unfinished. This is a per-document result — surfaced by the consuming layer as non-success (a non-zero exit, an `Err`) — not a per-construct signal and not an event. Only frames open *at* end of input feed it; a delimited construct closed early by an interior newline (per §13.2's current behavior) leaves a complete document.

For streaming input, "end of input" is the producer's explicit signal, never a chunk boundary.

---

## 14. Anomalies

### 14.1 Two severities, defined by loss

| Severity | Meaning |
|---|---|
| **Warning** | everything kept; may not match author intent |
| **Error** | something was **lost**, or a required value is **genuinely absent** as written; recognition continues |

**Error = loss** is mechanically checkable: if every author-visible byte is represented in the model as structure or text, severity MUST be Warning — unless a more specific rule names Error because something the author *intended* is genuinely absent from the model even though the bytes survive. **One case carries that justification** — `:label` with no value → assignment with Nil + Error (§6.2 — the intended **value** is absent). It is the language's sole core Error: "fail on error" means a genuinely missing required value or truncation (`incomplete-input`), nothing else. An Error MUST NOT halt recognition; nothing after an error point may be silently discarded.

### 14.2 Keep-Everything

Wherever a coherent keep-everything response exists, a conforming recognizer MUST keep all input content and warn rather than drop. Known coherent keeps: text-value fallback with the marker restored, content-base re-basing, late attributes (accepted, §6.9), tab-line best-effort keep, `$partial-key`, and unclosed delimited extents (content kept, opener cited). Silent drop of author-visible material is non-conformant.

The response ladder above (a) warn-and-keep — (b) warn-and-drop, (c) error-and-drop, (d) halt, (e) reject — belongs to **consumers**: whether accumulated anomalies justify dropping, halting, or rejecting is consumer policy over the complete model (menu vs knob), never a second recognition mode. Anomalies never suppress content and content never suppresses anomalies: the model carries both.

### 14.3 Representative cases

| Situation | Severity | Keep shape |
|---|---|---|
| Unclosed delimited construct | Warning (+ incomplete-input at EOF) | partial content, opener cited |
| Unclosed identity/selector `[` | Warning | `$partial-key` / partial selector |
| Late attribute after block content | Warning | **accepted** as the element's attribute |
| `:label` under an open assignment body | Warning | text of the open body |
| Inconsistent text indent | Warning | re-base content base |
| Root-level `:label` | Warning | document-level text |
| Tab in indentation | Warning | best-effort keep as text of current owner |
| `:label` missing its value | Error *(the sole core Error)* | assignment with Nil |

---

## 15. Design principles (normative constraints)

1. **Sameline is value-space; prose lives in bodies.** All sameline material is an attribute value; late block attributes are accepted with a Warning (§6.9).
2. **Spaces only** in indentation.
3. **Syntactic typing**: a frozen bare set + explicit envelopes; dialects structurally cannot retype bare space.
4. **Stacking, not last-wins** — and stacking is silent.
5. **Bounded lookahead** as language law.
6. **Sugar is designated attributes** (`$key`, `$traits`, `$?`…, `$main`), never parallel model fields.
7. **References inert at core.**
8. **Keep-everything; severity = loss.**
9. **Every construct declares its extent kind** (geometric or delimited) and inherits its EOF story from it.
10. **The text law** (MODEL §6): document text reconstructs by pure in-order concatenation of text; anything a consumer must consult the source to reconstruct is a model hole. (`$main`, like every assignment, is not text material — host stitching presents it.)

---

## Appendix A — annotated surface map (non-normative)

The §0 axioms predict nearly everything here — most visibly **A1** (columns are the syntax: deeper = child, same = sibling, shallower = closed) and **A3** (sameline is value-space: everything on a marker-opened line is a value belonging to some attribute — named ones after each `:label`, and `$main` for the element's own text). Elements written on one line sit at their real columns (A2):

```udon
|a |b |c        ; three elements, nested — identical to the
                ; vertical form below (columns are real):
|a
   |b
      |c
```

The rest is the marker inventory, annotated:

```udon
; a comment (owns anything indented deeper than it)
|element[key].trait :attr value :ok? true
;        │    │      │           └ presence is explicit — no implicit-true
;        │    │      └ attribute: the PARENT's label for the value  (§6.1)
;        │    └ trait: what KINDs of thing it is — stacks           (§5.3)
;        └ identity: what makes it THIS one; @[key] points at it    (§5.3)
  :block-attr one value :and-another 2
; └ same value grammar on its own line; markers terminate values    (§6.4)
  :node-attr |config :first 1 :second 2
;            └ the |config node IS the value (block or brace form)  (§6.8)
  Block prose with |{em inline}, !{{interp}}, and ;{a note}.
; └ text-space: markers literal; braces = inline forms INSIDE text  (§7)
  :late 1   ; still a real attribute — warned as late               (§6.9)
  :when <2026-07-11>
;       └ envelope: everything beyond the frozen bare scalars —
;         a dialect types it. **Bare recognition is frozen forever,
;         so adding a dialect can never silently retype a document
;         (no Norway problem, structurally).**                      (§11.6)
  !:python:
    print("| not udon here")   ; verbatim body — never parsed       (§10.1)
  @other[key]                  ; reference — inert selector         (§12.2)
\| this whole line is literal text (the \ escaped the marker)       (§4)
```

Sugar is honest: `|element[key].trait? Title text` and  
`|element :$key key :$traits trait :$? true :$main "Title text"` are the **same element** (§5.3, §6.10). And nothing is ever thrown away: malformed input keeps its bytes, with a Warning marking the spot (§14).

## Appendix B — Working anomaly-code inventory (non-normative)

The current working vocabulary of anomaly codes, carried so tooling and spike agents share names. **All spellings are working names** — SPEC vocabulary and generator derivation must agree before any becomes contract; severities and keep shapes follow this suite, which supersedes older per-code definitions. Retired: `AttributeValueExtendedByTrailingText`, `AttributeSecondValue` (stacking is silent).

| Code | Situation (§) | Severity |
|---|---|---|
| `InconsistentIndentation` | text or comment-continuation line under the content base but still inside the owner (§7.2 r4); a line at/left of the owner's column is an ordinary dedent, not this. *Scope note: pending OPEN S4 (steward call)* | Warning |
| `NoDialectsLoaded` | envelope recognized, no dialects bound; lexical pass-through (§11.6) | Warning |
| `AttributeAfterChildren` | late attribute after block content (§6.9) — **accepted as an attribute** (keep shape changed by K14; the code name survives) | Warning |
| `AttributeUnderAttribute` | `:label`-shaped line directly under an open assignment body (§6.8) → text of the open body (severity per K8; name predates the ruling) | Warning |
| `Unclosed<Construct>` family | each delimited construct's missing closer (§13.3): String, Array, InlineElement, InlineComment, Interpolation, TypeEnvelope, Fence, IdentityKey, InlineDirective, InlineRaw | Warning |
| `NoTabs` | tab in indentation (§2) — severity Warning per L4 (name predates ruling) | Warning |
| `MissingAttributeValue` | `:label` with no value material → Nil (§6.2) — the sole core Error | Error |
| `EscapeOutsideHeadPosition` | past-base `\` (§4) — consumer-layer, optional | advisory |
| `CommentMissingFollowingSpace` | `;comment` in a no-frame position (§8) — host style advisory, optional | advisory |

## Appendix C — recognition vignettes (non-normative)

Three inputs and the Document each produces (shapes per MODEL; anomaly codes are Appendix B working names).

**1. Happy path, sugar and longhand identical:**

```udon
|user[jw].admin :active? true Joined 2025.
```

```text
Document { result: complete, anomalies: [] }
└ Element user
    assignments: $key="jw" · $traits="admin" · active?=true · $main="Joined 2025."
    content:    (empty — sameline text is $main, not content)
```

**2. The `$partial-key` fail-safe** — an editing accident, not a disaster:

```udon
|user[jw
  :name Jo
```

```text
Document { result: complete, anomalies: [Warning UnclosedIdentityKey @1:6] }
└ Element user
    assignments: $partial-key="jw" · name="Jo"
```

The truncated key lands under `$partial-key`, so nothing that reads `$key` or resolves `@[jw]` acts on it. (Under *current parser behavior* the newline closes the bracket and the rest of the document parses normally — that route is descriptive, §13.2/ML; the `$partial-key` fail-safe itself is law. Had the input *ended* inside a delimited construct, `result` would be `incomplete-input`.)

**3. The sole core Error, the looks-like-attribute Warning, and a late attribute:**

```udon
|server :host
|db
  :port
    :nested 1
  content line
  :zone us-1
```

```text
Document { result: complete,
           anomalies: [Error MissingAttributeValue @1:9,
                       Warning AttributeUnderAttribute @4:5,
                       Warning AttributeAfterChildren @6:3] }
├ Element server
│   assignments: host=Nil
└ Element db
    assignments: port=":nested 1\n" · zone="us-1"   (zone: late, accepted — K14)
    content:     Text "content line\n"
```

`host` had no value material and nothing indented under it, so it stands with Nil — the intended value is absent, the language's one Error. `port`'s deferred body opened, and its first line is itself `:label`-shaped — the attribute-under-attribute case: the line survives as text of `port`'s open body with a Warning — the language has no nested attributes, so nothing the author could legitimately intend is missing. `zone` arrives after `db`'s block content: a real attribute, warned as late. Recognition continued; every byte is in the model.
