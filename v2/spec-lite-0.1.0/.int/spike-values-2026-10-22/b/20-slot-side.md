# Branch page: the slot side (D5 where slot types live, D6 unions, D7 units, D9 the trailing colon)

*Spike b, 2026-10-22. Labels as on the other pages. Every spelling of a schema below is illustrative, as Joseph's own were ("not proposing a spelling-- just the concept").*

## 1. The finding that prunes most of D5: a slot declared on one occurrence is a literal assertion in disguise

Joseph's distinction is "*this is what the slot is* vs *this is what my literal represents*." Push it one step. A slot type is a claim about **every** value that can stand in that place: every `port` of every `server`. A claim made on **one** occurrence only is about that occurrence's value, which makes it a literal claim, whatever side of the name it is written on.

Take his own imagining:

```udon
|event :when:iso8601 <dt: 2026 PDT>
```

Both halves speak about this one value. `:iso8601` (slot side) and `dt:` (literal side) are two notations claimed for the same spelling, and nothing extends to the next `|event`. Written per occurrence, a "slot type" duplicates the literal assertion `<…>` already gives, and costs plumbing on every line (A5, weight 9):

```udon
|server :port:u16 8080
|server :port:u16 22
|server :port:u16 ssh      ; and the union has to be repeated too
```

So **a slot type, to be one, has to be stated once and range over occurrences.** That rules out every per-occurrence spelling as a *slot* mechanism (σ2 below) without needing to compare spellings. [inferred; I think this is the most useful conceptual result on this page.]

## 2. Branches for D5

### σ1: no slot syntax in lite. Slot types are data, addressed by element and attribute names (recommended)

The slot is already *named* in every document: element name (or trait) plus attribute name, `server`/`port`. A vocabulary (schema) maps those addresses to types, unions and aliases. The vocabulary is **itself a lite document**, so the type system costs lite no syntax at all. Joseph's "algebraic names", sketched:

```udon
; server.schema.ud   (file naming per the existing convention; spelling illustrative)
|type standard-port :one-of [smtp ssh http https]
|type port :one-of [<u16> standard-port]
|element server
  :port port
  :debug <bool>
  :version <text>         ; this is what fixes E2's `:version 1.0`
  :width length
```

A document bound to it (by its file name `x.server.ud`, by the consumer, or by a root attribute such as `:$schema server`; how it is bound is not lite's business either):

```udon
|server :port ssh :debug false :version 1.0
|server :port 22
```
````tree
root
  |server
    :port ‹ssh›       ⇒ (slot port)    standard-port "ssh"
    :debug ‹false›    ⇒ (slot bool)    false
    :version ‹1.0›    ⇒ (slot text)    ‹1.0›     ← the default reading is overridden
  |server
    :port ‹22›        ⇒ (slot port)    22
````

The raw tree is the same with or without the schema. Only the reading changes. That is the property that makes this safe: **a schema can never change what a document parses to, only how it is read**, which matches the reading-option invariant already on [[def:reading-option]].

The lightest form of σ1 is **β7, kind by strict getter** (page 10, §4): `get_int(:port)` *is* a slot type, written where the consumer already is.

**Cards it touches:** none. σ1 adds nothing to lite. It needs [[obj:represent-structured-data]]'s working note answered (lite's job is to keep spelling and form; schemas are another layer) and the reading-option card to say that schemas are readings.

### σ2: per-occurrence slot annotation on the attribute name (`:port:u16 8080`)

Pushed to make it work:

- **`:` as the separator collides with XML's namespaced names.** `:xml:lang en` and `:xlink:href …` are names C2 (weight 10) needs. The coordinator's label lean allows `:` inside labels ([checked] `.int/labels-ascii-and-positions-2026-10-20.md` line 21, "`xml:lang`, `svg:rect`, `xlink:href`"). So `:port:u16` is ambiguous, and it would always resolve toward namespaces.
- Another separator (`:port::u16`, `:port/u16`, `:port<u16>`) escapes the collision, but not §1: every one is per occurrence, and every one duplicates `<…>`.
- **Dead**, on §1 (redundant with literal assertion; A8 parsimony, two places to say one thing) and on C2 for the colon spelling. The finding is §1.

### σ3: once per document, in the document (a header block declares slot types)

This is σ1 with the vocabulary written inline, as a top-level element. It needs no lite syntax if the vocabulary is data, so **σ3 is a convention inside σ1**, not a branch of its own. Collapsed.

### σ4: the element's trait selects its schema (`|server.v2`)
Again data, read by a consumer; traits already exist. A convention inside σ1. Collapsed. [taste: nice for versioning vocabularies]

## 3. D6: unions with overlapping arms

`port = u16 | standard-port` is disjoint: digits vs words. Overlap is where the interesting cases are: `id = uuid | int` (disjoint), `version = semver | float` (`1.0` only matches float, so disjoint), `size = int | enum{0 small big}` (overlaps on `0`).

| Branch | Rule | Verdict |
|---|---|---|
| ordered choice | the first arm that reads the spelling wins | silent surprise when arms are reordered; **pruned** on B3 |
| disjoint arms required | a vocabulary whose arms both read some spelling is an error **when the vocabulary is loaded** | the notations in play (numbers, enums, dates) are regular languages, and whether two regular languages intersect is decidable (build the product automaton and check it for emptiness), so the check can be exact, with the overlapping spelling named as the example [checked: textbook automata theory] |
| ambiguity at read time | an ambiguous spelling is an error where it occurs; the writer resolves it with an assertion (`<0>`, `"0"`) | **recommended alongside the load-time check** for notations that aren't regular |

So explicit literal marks earn their place exactly where the coordinator's notes predicted: "where a slot's union has overlapping arms". The new part is that a vocabulary can find those places before any document is written. [inferred]

## 4. D7: units fall apart into their three layers

Joseph: "units (= seem to be a bit of both slot-type & literal-hint & coercion)". Under σ1 they divide cleanly:

| Part | Layer | In `:width 920px` |
|---|---|---|
| the **dimension** (length, mass, data size) | slot: `width: length` | declared once, in the vocabulary |
| the **unit** chosen (px, em, cm) | literal: part of the spelling | `px`, written by the author |
| **conversion** (px→em) | consumer | never lite's or the vocabulary's |

Without a vocabulary, `920px` is the text `920px` (page 10's default reading leaves it alone). Asserted, `<920px>` is outside the bare standard set, so it is an error ("<920px> error I can understand", Joseph 2026-10-21), and the message can suggest a labelled quantity literal (spelling per fork P). Units do not belong in the default reading: no host has a quantity type, so it fails page 10's lossless test. [inferred]

## 5. D9: the trailing colon on attribute names, decoupled from types

Under σ1 the trailing colon has no type role. It stands or falls on looks and reading alone.

- **Ornamental (`:host: localhost` ≡ `:host localhost`).** Cost: two spellings of one thing (A7). Harmless for guessability (A2), since a writer who adds it or leaves it out gets the same tree. Benefit [taste, low confidence]: with multi-word text values, the colon marks where the name ends without highlighting (A4): `|book :title: War and Peace :year: 1869`.
- **Interaction with labels.** If the ornament is allowed, a bare label can't *end* in `:`. [checked: Namespaces in XML 1.0, fetched today: `PrefixedName ::= Prefix ':' LocalPart`, `LocalPart ::= NCName`, and an NCName has no colon and is non-empty] That costs XML nothing: under XML Namespaces a name is `prefix:local` with a non-empty local part, so a namespace-valid name never ends in `:`. Plain XML 1.0 `Name` does allow a final `:`, but such names are pathological.
- **Compulsory (`:host: localhost` always).** One character per attribute (A9), and the look, to my eye, is neither Ruby's `{host: …}` nor UDON's `:host …` but both at once. [taste] The Elixir look Joseph likes is the suffix form, which was set aside for its text collisions.
- **No branch dies here.** It is a pure beauty and readability call, which is his to make. My lean, [taste]: ornamental-allowed, so the clean bare form stays the canonical one written back.

## 6. Scores [hyp]

| Factor (weight) | σ1 data + getters | σ2 per-occurrence annotation |
|---|---|---|
| A5 domain-forward (9) | 9 (the slot is named by the domain's own words) | 3 (plumbing per value) |
| A6 spec clarity (9) | 9 (adds nothing to lite's spec) | 5 |
| A8 parsimony (8) | 10 | 4 (a second separator) |
| A10 self-description (5) | 5 (the document doesn't name its schema unless bound) | 8 |
| B6 headroom (7) | 10 (spends no syntax) | 4 |
| C2 XML (10) | 10 | 3 (with the `:` spelling) |
| C5 schemas and slot types (8) | 9 | 5 |
| **weighted** | **509** | 242 |

Confidence high that σ1 dominates. The one place σ2 wins (self-description) is the factor Joseph lowered on purpose, for exactly this reason: "it implies a verbosity / config+explicit over convention+implicit."
