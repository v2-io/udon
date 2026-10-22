# Fork R: what other notations know about slot types, literal types, unquoted values, annotations, units and unions

*Spike b, research fork, 2026-10-22. Precedent here is evidence, weighed against `CTQ-FACTORS.md` (Joseph, relayed: "useful only inasmuch as it meets those factors"), and never a reason by itself. Per his second relayed note, nothing from the UDON corpus is used here as evidence of how agents write or read. Where an old UDON parser's *behaviour* is cited (e.g. `:version 1.0` → Float), it is a fact about that machine, not about usage. The external systems' documented failures (YAML's Norway, StrictYAML's cases) are reports from the wider world, weighed by the factors. **[checked]** = read in the primary source today (URL given); **[recalled]** = from memory, not re-read today.*

## Lessons for lite's decision points, first

### 1. Observation 2 holds, and holds more strongly than stated (D1, D2) [checked]

YAML 1.2.2 §3.3.2: "nodes lacking an explicit tag are given a non-specific tag: "!" for non-plain scalars and "?" for all other nodes." Resolution "must only depend on the following three parameters: (1) the non-specific tag of the node, (2) the path leading from the root to the node and (3) the content (and hence the kind) of the node." "Application specific tag resolution rules should be restricted to resolving the "?" non-specific tag, most commonly to resolving plain scalars." Quoted scalars resolve to `str` (§3.3.2, "vanilla … string").

- **Parameter (2) is the slot.** YAML's architecture already *is* "a bare spelling is resolved against where it sits; a quoted one is a string." The three things lite's lean has (bare spelling kept, quoted = string, resolution outside the parser by a view) map onto YAML's "?", "!", and schema.
- **What failed was the default schema, not the architecture.** The 1.2.2 Core schema (§10.3) resolves `null | Null | NULL | ~ | (empty)` to null, `true | True | TRUE | false | …` to bool, decimal, `0o` and `0x` ints, floats including `.inf` and `.nan`, and anything else to `str` [checked]. 1.1 added `yes/no/on/off` and sexagesimal [recalled]. Loaders kept implementing 1.1, so one document gave different data in different hosts [recalled; StrictYAML's checked examples below]. Against CTQ: B3 (one tree in every parser) failed through schema *plurality*; A3 (cold comprehension) failed through schema *breadth*.
- **The 1.2 JSON schema makes an unmatched plain scalar an error**, not a string (§10.2: "the YAML processor should consider them to be an error") [checked]. That is a variant nobody in lite has named: the default resolution as strict, rejecting bare text in typed position. It is useless for lite as a general default, since bare text is lite's commonest value, but it may be the right behaviour for a slot whose declared type is numeric.
- **The lesson for lite:** if the typed-primitive view becomes the default resolution, there should be **exactly one**, frozen, and small. Its members should be the ones the CTQ test (C1, D2) admits: nil, true/false, and decimal numbers. YAML-Core's `Null`/`TRUE`/`~` and REBOL's `yes` are the members that cost.

### 2. A recent, independent move toward the lite lean: KDL 2.0 (D1, D8) [checked]

KDL 2.0 changelog: "Bare identifiers can now be used as values in Arguments and Properties, and are interpreted as string values." "`null`, `true`, and `false` are now `#null`, `#true`, and `#false`." "Using the unprefixed versions of these values is a syntax error." Bare `inf`, `-inf`, `nan` are illegal identifiers (spec §3.14.1). No rationale is given in the changelog or the spec.

- A team designing for least surprise made the bare word a string and put the keywords behind a mark. That is lite's `<nil>`/`<true>` (C), and it makes bare `null` an error, where lite gives a warning.
- **KDL kept numbers bare and typed.** In KDL a bare word can't start with a digit [recalled], so a digit commits to a number: that is option (A). KDL carries no prose and no units, so that costs it nothing. In lite, digit-initial text (`1984 is a novel`, `2 cups flour`, `920px`) is ordinary (C3, C4), which is exactly the ground Joseph gave for rejecting (A). **The crux distinction between lite and every config language is that lite carries prose.** It is the reason the config-language answer (numbers bare) doesn't transfer.

### 3. Every mature schema system has the same three layers (D5, D6) [checked: XSD, JSON-LD, YAML; recalled: StrictYAML's schema API, KDL Schema]

| | Instance spelling | Slot type, declared once, elsewhere | Instance-side override |
|---|---|---|---|
| XML + XSD | every attribute value is a string | schema simple type | `xsi:type` |
| JSON-LD | plain JSON string | term definition with `@type` in a `@context` (embedded or by URL) | value object `{"@value", "@type"}` |
| YAML | plain scalar (`?`) / quoted (`!`) | resolution by path (application schema) | explicit tag `!!int`, `!foo` |
| StrictYAML | "Everything is a string by default" | `Map({"port": Int()})` [recalled] | n/a |
| KDL | value | KDL Schema (separate spec) [recalled] | `(type)value` annotation |

- **XSD's vocabulary is the coordinator's R/T/N/C table, settled 20+ years ago:** lexical space (R), value space (T), lexical mapping (N), canonical mapping and canonical representation (C) (XSD 1.1 Part 2 §2.2–2.3.1) [checked]. Lite need not invent words for these. Whether to borrow XSD's is a naming question for Joseph.
- **Unions: ordered, first match wins, with an instance override.** XSD §2.4.1.3: "validated against the member types in the order in which they appear in the definition until a match is found"; it concedes "a given literal may map to one value or to several values of different primitive datatypes", and `xsi:type` picks [checked]. This is Joseph's `port = u16 | standard-port` (D6). The design that has worked is ordered arms plus a literal-side override, and lite's `<…>` would play `xsi:type`'s part.
- **Whitespace is a pre-lexical step, controlled by the slot type** (XSD's `whiteSpace` facet: preserve/replace/collapse, applied "before" the lexical mapping) [checked that it precedes; the three values recalled]. This bears on lite's trimming ruling: trimming a bare value is what XSD calls `collapse`, and XSD lets the slot choose. Lite's ruling (always trim; ` \ ` keeps) is the fixed-default version.
- **Domain vocabularies by name exist as a standard:** JSON-LD's context coerces "the value into an IRI" for a term declared `"@type": "@id"` (§3.2) and "Contexts can either be directly embedded into the document … or be referenced using a URL" (§3.1) [checked]. This is Joseph's "algebraic names" and A5 (domain-forward) as deployed practice: a slot type declared once per vocabulary, carrying zero plumbing per value.
- **Against CTQ:** this three-layer split scores well on A5 (domain-forward: plumbing lives once, not per value), B3 (the instance tree doesn't depend on the schema) and C5. XSD's and JSON-LD's machinery scores badly on A1, A6 and A9. The lesson is to take the layering, not the machinery.

### 4. Annotation that never changes lexing: EDN (D4, B1, B2, B6) [checked]

EDN: "`#` followed immediately by a symbol starting with an alphabetic character indicates that that symbol is a tag", applied to the next element. "Tag symbols without a prefix are reserved by edn for built-ins"; user tags "must contain a prefix component". Unknown tags: the reader may "report an error", call a handler, or build a generic representation. "Thus you can build new distinct readable elements out of (and only out of) other readable elements."

- **The payload is always a core form** (`#inst "1985-04-12T23:20:50.52Z"`, a string). A parser that knows no tags still produces a complete, checkable tree. Lite's current `<…>` is the other model: an opaque interior handed to a dialect.
- **Against CTQ:** the EDN model is stronger on B1 (trivially bounded), B2 (an unknown tag is still a well-formed tree, so refusing it needs no guess about the extent), C7, A6 and A7. It is weaker on A5 and A9, because a date pays for quotes (`#inst "…"`). The same idea appears as ideation in the corpus: the fresh-Claude dialects testimony (2026-07-28, §10, in `v2/udon-needs/…/de-novo-testimony/`) asked for envelope contents as "a small CLOSED sub-grammar" so an unaware tool can tell "well-formed nonsense" from "garbage". Per Joseph's relayed note, it is corpus written by fiat, so it is ideation, not evidence of what agents need.
- **The namespace rule answers B6 (headroom) directly:** unprefixed names are reserved for the standard set, and user names must be prefixed. Lite could state now that unprefixed type names inside `<…>` belong to UDON, at no cost.
- It also fits the composite-types direction (`<r: <i: 3 -7> 0d83.23>`, `design/composite-types.md`). EDN's "out of (and only out of) other readable elements" is that nesting, with a closed lexer.

### 5. The maximal standard set is a list of CTQ losses: REBOL (D3) [checked]

REBOL types ~20 scalars by lexical form: `$12.34` money, `10:30` time, `1/3/1999` and `5-Oct-1999/10:30` dates, `1.3.0` tuple, `100x50` pair, `info@rebol.com` email, `%file.txt` file, `#707-467-8000` issue, `http://…` url, and **`<a href="index.html">` tag!**: REBOL's `<…>` *is* markup. Its own documentation lists the ambiguities:

- `1.2` is a decimal, `1.2.3` a tuple: the semver trap again, as in UDON's old `:version 1.0` → Float.
- `1,23` is a decimal: a comma separator.
- "Two-digit years are read relative to the current year": **a document's meaning changes with the clock.** That is a straight failure of B3, and the cleanest argument against any temporal shorthand with an implied century (Joseph's `:when:dt(YY-MM-DD)<27-03-05>` needs an explicit pivot or it inherits this).
- `true/on/yes`, `false/off/no` are all logic: Norway again.
- `#"R"`, `#707…` and `#{…}` share `#`; the next character decides.

Lite's homage is to the right ancestor: REBOL's `<…>` already meant markup, so lite inherits the clash between `<…>` and inline HTML in text (the parent's E6) from the source.

### 6. Name-first, writer-chosen delimiters: Elixir sigils and SQL typed literals (D4) [Elixir checked; SQL recalled]

Elixir: `~D[2019-10-31]`, `~T[23:00:07.0]`, `~N[2019-10-31 23:00:07]`, `~U[2019-10-31 19:59:03Z]`; "8 different delimiters" (`/ | " ' ( [ { <`); custom sigils are "a single lowercase character or an uppercase character followed by more uppercase characters and digits"; "Optional modifiers are added after the final delimiter"; uppercase sigils do no escaping or interpolation.

SQL: `DATE '2026-01-10'`, `TIMESTAMP '…'`, `INTERVAL '3' DAY`; PostgreSQL also `'…'::date` [recalled].

- Both put the name before the payload, which is Joseph's "decide sooner and piecewise": the notation is known before any payload character.
- **Writer-chosen delimiters** remove the escaping cost on the opaque-span card ("An unbalanced bracket in content (`<a -> b>` …) has to be escaped"): the writer picks a delimiter the payload doesn't use. The cost is A7/A8: more spellings for one construct.
- **A2 guess [taste/inference]:** SQL's `DATE '…'` and Elixir's `~D[…]` are heavily represented in training data, so "name, then the payload in a delimiter" is probably the most guessable shape for a typed literal. `<dt:…>` is guessable after one exposure; an agent with no exposure would not invent it.

### 7. Storage names as domain ranges: CUE (H layer, D5) [checked]

CUE "does not distinguish between types and values: only the relationship of values in the lattice is important"; `uint16` is predeclared as `>=0 & <=65535`, a range, with no storage meaning; disjunctions take defaults: "Any element of a disjunction can be marked as a default by prefixing it with an asterisk".

- This settles the straddle the ideation file flagged (`u16` as both domain and storage): define the name as a domain range, and let each host derive its storage. It backs the coordinator's recorded lean.
- CUE needs evaluation (unification), so it is out for lite ("lite evaluates nothing"). It is relevant to how full UDON might write schemas *in UDON*: a slot type is itself a value.

### 8. Units: CSS's dimension token (D7) [checked]

CSS Syntax §4.3.3: after a number, "If the next 3 input code points would start an ident sequence … Consume an ident sequence. Set the dimension-token's unit to the returned value"; a following `%` makes a percentage. The lookahead is three code points, and "This algorithm will not consume any additional code points."

- **This is a variant of (A) that nobody in the record named: "a digit commits to a number *or a dimension*."** It is bounded, `920px` is not an error, and `920px` arrives already split into number and unit.
- It fails lite on the same ground KDL's numbers do. CSS has no prose values: `:title 1984 is a novel` becomes a number plus residue, and `2 cups flour` a dimension (`2` with unit `cups`?). So it isn't a way out of (A)'s prose problem. It is evidence that **if a slot is declared `length`, the slot's notation can be CSS's**: a three-code-point decision, no holdback.

### 9. Bare = resolve, quoted = literal, in languages that evaluate (D2) [recalled]

In HCL2's native syntax, Nix, and Lisp, a bare identifier is a *reference* resolved in an environment, and a string is quoted. Lite evaluates nothing, but "resolve against the slot" is the non-evaluating form of "resolve in an environment." So observation 3 (aligning the Lisp quote with slot-vs-literal) has a long line of precedent. YAML's `?`/`!` (§1) is the non-evaluating version of it already.

### 10. Everything-is-a-string with schemas has shipped: StrictYAML (D1) [checked stance; recalled API]

"Everything is a string by default"; the cited failures: Norway (`NO` → False), `postgres: 9.3.0` a string but `9.3` a float, the surname "Null" → None. This is lite's lean, (C) plus slot schemas, as a library with users, and it shows the design is livable for config data. Its known cost [recalled, not checked]: without a schema every consumer converts by hand, which is exactly the gap the typed-primitive view fills.

## The convergence, and the one real disagreement

Every system with schemas separates **the spelling in the instance**, **a slot type declared once and elsewhere**, and **an instance-side override**. They differ only on **the default when there is no slot type**:

| Default with no schema | Systems | Cost against CTQ |
|---|---|---|
| everything is a string | XML, StrictYAML, env vars, CSV | C1 (JSON's use needs a schema or a view) |
| lexical typing, strings must be quoted | JSON, TOML, KDL (keywords marked in v2) | A2/A3 fine for data; C3/C4 fail (prose, units) |
| aggressive lexical typing of unquoted text | YAML 1.1/Core, REBOL | B3, A3 (Norway, `9.3`, two-digit years) |
| unquoted non-primitive is an error | YAML 1.2 JSON schema | unusable for prose |

Lite's lean (bare is text in the tree; a small fixed default resolution as a view) is row 1 in the tree and a *conservative* row 2 in the view. That combination is unusual: no checked precedent offers it directly. Its nearest neighbour is YAML-with-path-resolution, using a JSON-sized default schema instead of the Core one.

**Counter-evidence for the synthesis, honestly weighed.** JSON and TOML, the formats agents have read most, mark *strings* and leave numbers bare, so agents' priors (A2, A3) expect `:port 8080` to be a number. Under the lean that expectation is met only where the default view is on. So the surprise cost of (C) lands exactly where the view is off, and **whether the view is on by default (and normative) is where (C) wins or loses A2/A3.** KDL 2.0 kept numbers bare while removing bare keywords; its reason (a digit can't start a word) doesn't hold in lite.

## Sources

- YAML 1.2.2: https://yaml.org/spec/1.2.2/ (§3.3.2, §6.9.1, §10.2, §10.3)
- KDL spec: https://kdl.dev/spec/ (§3.7–3.10, §3.14.1–3.16); changelog: https://raw.githubusercontent.com/kdl-org/kdl/main/CHANGELOG.md
- EDN: https://github.com/edn-format/edn
- XSD 1.1 Part 2: https://www.w3.org/TR/xmlschema11-2/ (§2.2, §2.3, §2.3.1, §2.4.1.3)
- REBOL Core datatypes: http://www.rebol.com/docs/core23/rebolcore-16.html
- Elixir sigils: https://elixir.hexdocs.pm/sigils.html
- CUE spec: https://cuelang.org/docs/reference/spec/
- CSS Syntax 3: https://www.w3.org/TR/css-syntax-3/ (§4.3.3, §4.3.9)
- JSON-LD 1.1: https://www.w3.org/TR/json-ld11/ (§3.1, §3.2)
- StrictYAML: https://hitchdev.com/strictyaml/why/implicit-typing-removed/
