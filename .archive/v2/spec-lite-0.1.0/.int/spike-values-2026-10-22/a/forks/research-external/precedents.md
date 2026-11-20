# External precedents, one at a time (spike a, research-external fork)

*Each entry has three parts: what the notation does, how it bears on the CTQ factors, and which decision point it informs (the DPs are in `../../notes.md`). **Checked** means I fetched the primary source on 2026-10-22 and the quote comes from that fetch. **Memory** means from training and not re-verified. The CTQ weighing is my judgment. Per Joseph, a precedent is evidence weighed against CTQ-FACTORS, never a reason in itself. Real-world usage of outside notations counts as evidence. The estate's own UDON does not, and this file doesn't use it.*

---

## 1. XSD Datatypes 1.1: lexical space, value space, canonical mapping, ordered unions (checked)

**What it does.** §2.2: "The value space of a datatype is the set of values for that datatype." §2.3: "The lexical space of a datatype is the prescribed set of strings which [...] maps to values"; the lexical mapping is that relation. §2.3.1: the canonical mapping is "a prescribed subset of the inverse of a lexical mapping which is one-to-one", and "A conforming schema processor implementation is not required to implement canonical mappings." §2.4.1.3, unions: the union's lexical mapping is the ordered union of its members', "not necessarily a function". Validation tries members in declared order, and "the first of its members in order which accepts the instance as valid is the active member type". The instance can override with `xsi:type`. The spec's own example is `<size>1</size>`, which is an integer, while `<size xsi:type='xs:string'>1</size>` is a string.

**Against the factors.** Joseph's map already has standard names here: spelling R is the *lexical representation*, notation N is the *lexical mapping*, represented type T is the *value space*, canonical spelling C is the *canonical mapping*, and slot type S is the datatype a schema declares for an element or attribute. The precedent therefore supports the split he drew (C4, C5). A spec that reuses these terms may help A6 (spec clarity) for readers who know XSD. XSD also shows the cost of declaration-heavy typing: everything lives in a separate schema language, and XSD is the archetype of plumbing (A5, A10).

**Bears on.**
- **DP10 (aliases).** `port = u16 | standard-port` is an XSD union, and XSD had to answer the overlap question. Its answer is that order decides, with a per-instance override. That is the ideation file's observation ("explicit literal marks become necessary mainly where a slot's union has overlapping arms"), worked out in a deployed standard.
- **DP6.** Typing lives on the slot (the schema), and a literal is marked only to override.
- **Weakness for lite.** First-match-by-order is itself a source of surprise (A3, B3).

## 2. YAML 1.2.2: plain scalars get a non-specific tag and a schema resolves them (checked)

**What it does.** §3.3.2: nodes without an explicit tag get "a non-specific tag: “!” for non-plain scalars and “?” for all other nodes". "Resolving the tag of a node must only depend on" the non-specific tag, "the path from the root to the node", and the node's content. It "must not consider presentation details such as comments, indentation and node style". Chapter 10 defines three schemas:
- **Failsafe:** "guaranteed to work with any YAML document".
- **JSON:** an unmatched plain scalar is an error.
- **Core:** "the recommended default schema"; an unmatched plain scalar resolves to `str`.

The Core int pattern is `[-+]? [0-9]+`, so `01234` resolves to an integer. The JSON schema's pattern forbids leading zeros. The Core float pattern `[-+]? ( \. [0-9]+ | [0-9]+ ( \. [0-9]* )? ) ( [eE] [-+]? [0-9]+ )?` matches `3.10`. In PyYAML, a `ScalarEvent(anchor, tag, implicit, value, style, …)` carries a pair of `implicit` flags, and `add_implicit_resolver(tag, regexp, first)` maps a plain-scalar regexp to a tag (checked).

**The failure record (checked).**
- **Norway:** `NO` → false under 1.1.
- **The "Python 3.1 problem":** `python-version: 3.10` is read as the float 3.1. The fix is to quote it ([hugovk.dev](https://hugovk.dev/blog/2021/the-python-3-1-problem/), [GitHub docs issue](https://github.com/github/docs/issues/14764)). This matches the 1.2 Core float pattern too, so it is not only a 1.1 relic.
- **`postgres: 9.3.0` → `9.3`** becomes a float, and **the surname `Null`** becomes None (StrictYAML's page, below).

**Against the factors.**
- **DP1.** YAML is the deployed version of "C with the view": the parser reports a plain scalar, and a schema (a view) classifies it from its finished content. Its record separates two causes:
  - **Plurality.** Several schemas exist, the default differs across versions, and PyYAML stays on 1.1. That is a stability failure (B3: "one tree per document in every parser").
  - **Membership.** The resolved set includes spellings that common identifiers and words collide with (`NO`, `Null`, `3.10`). That is a least-surprise failure (A2, A3) and a silent one, the kind the CTQ weighs most.

  A lite view that is one fixed, normative, small set and on by default removes the first cause. It does not remove the second for numbers: `3.10` is a number in every grammar.
- **DP3.** The JSON schema's int pattern (no leading zero) and the Core one (leading zeros allowed) differ on exactly `01234`.
- **DP6.** YAML lets resolution depend on the path, so a slot-aware resolver is legal YAML. This is slot typing by convention, and it has precedent there.

## 3. The formats with no bare strings: JSON, TOML, EDN (checked)

**What they do.**
- **TOML:**
  - Values must be one of the listed types, so there are no unquoted strings.
  - "Leading zeros are not allowed" in decimal integers.
  - "Each underscore must be surrounded by at least one digit on each side."
  - "Arbitrary 64-bit signed integers … should be accepted and handled losslessly. If an integer cannot be represented losslessly, an error must be thrown."
  - Dates and times are native: offset date-time, local date-time, local date, local time.
- **EDN:** "No integer other than 0 may begin with 0". "Symbols begin with a non-numeric character".
- **JSON (RFC 8259):** a number has no leading zero (memory; the YAML JSON-schema pattern above agrees).

**Against the factors.** These formats escape the identifier problem by construction: a bare spelling must be a value, so a string is always quoted. Lite can't do that, because bare text is its prose and XML side (C2, C3), and `:title War and Peace` has to work. But their number grammars converge on one rule: **no leading zero**. If the standard-set classifier adopts the JSON number grammar, `01234` (a zip code) and `007` simply are not numbers and stay text (DP3), with no invention on lite's part. `1.10`, `3.10` and `1234567` remain numbers in every one of these grammars, so no grammar rule protects versions or numeric IDs. Only "text by default" or "exact decimal kept as spelled" does.

## 4. KDL v2: bare identifier strings coexist with numbers, so number-looking identifiers are errors and keywords take a sigil (checked)

**What it does.**
- "A String is either an Identifier String (like `foo`), a Quoted String … or a Multi-Line String."
- "Identifiers that look like numbers (such as `1.0v2` or `-1em`) and identifiers that are the language keywords without their leading `#` must be treated as syntax errors."
- Keywords are `#true`, `#false`, `#null`, `#inf`, `#-inf`, `#nan`; bare `inf`, `-inf`, `nan` are illegal.
- Numbers: `.1` is invalid; underscores may not come first (`_12` is not a number); there is "no logical distinction … between real numbers, integers, and floating point numbers".
- Type annotations: "written as a set of `(` and `)` with a single String in it", on values or node names. "KDL does not specify any restrictions on what implementations might do with these annotations. They are free to ignore them". The reserved list "MAY be recognized": `i8`–`i128`, `u8`–`u128`, `isize`, `usize`, `f32`, `f64`, `decimal64`, `decimal128`, `date-time`, `time`, `date`, `duration`, `decimal`, `currency`, `country-2`/`-3`, `country-subdivision`, `email`, `hostname`, `ipv4`, `ipv6`, `url`, `uuid`, `regex`, `base64`, `base85`, and others.

**Against the factors.** KDL is the closest living relative: a document and config notation with bare string identifiers and bare numbers. Facing lite's exact problem, it chose:
1. Option **A** for numbers: a number-looking bare word is an **error** (`-1em`). Joseph rejected this for lite because "in notation there are units all the time" (A5).
2. **Sigiled keywords**, `#true` and `#null`. That is the same move as lite's `<true>`/`<nil>` under C (DP8). KDL v1 had bare `true`/`null`; v2 changed it (memory: the motivation was the YAML-style collision of bare words with keywords).
3. **Annotations that are open and ignorable**, with a reserved vocabulary (DP4, DP5).

KDL is evidence that the "errors over guesses" side (B3, B4) was chosen by a modern format at the cost of units in bare position. Lite's CTQ weighs A5 (9) and C4 (8) for units, so lite can rationally diverge, but it should know it is diverging from its nearest relative.

## 5. Formats that drop implicit typing: StrictYAML, NestedText, Tcl (checked)

**What they do.**
- **StrictYAML:** "Everything is a string by default", and types come from a schema. Its examples: Norway, `postgres: 9.3`, Christopher Null. It calls implicit typing "a major violation of the UX principle of least astonishment".
- **NestedText:** "All leaf values must be simple text or empty". For naming a file's schema it recommends a double suffix, `officers.addr.nt`. That is the same convention as UDON's `name.schema.udon` (A5's "file and schema naming").
- **Tcl:** "each value is conceptually a string" (EIAS), with dual-ported objects that hold a string representation and a cached internal one ("They can stand on either leg, or on both"). Converting back and forth repeatedly, "shimmering", costs performance.

**Against the factors.** These are DP1's option (a), C strict: text always, meaning from the slot. They show it is a coherent design that fixes YAML's silent misses (A3, B3). The price is C1: every consumer needs a schema or its own conversion to get JSON-equivalent data. *Memory and taste, unverified:* neither StrictYAML nor NestedText has become a common JSON or YAML replacement, which weakly suggests that cost is felt.

Tcl is the existence proof for DP1's option (c), "text with a cached classification". The string is primary, the internal representation is derived and cached, and the cost is shimmering only when a consumer alternates readings.

## 6. Units: the CSS tokenizer, UCUM, ISO 8601, F# (checked)

**What they do.**
- **CSS Syntax 3 §4:** a `<dimension-token>` has a numeric value, a type flag (integer or number), a sign and "a unit composed of one or more code points". `<percentage-token>` has value and sign. §4.3.3 "consume a numeric token" yields a dimension whenever an ident follows the number. §4.3.13: `e`/`E` starts an exponent only when a digit follows, optionally after a sign. So `2em` is dimension(2, em) and `1e3` is a number (my application of the rule). *Memory:* whether a unit is *valid* is decided by each property's grammar, not the tokenizer.
- **UCUM:** `m` is meter, `min` minute, `mo` month, `s` second, `%` percent (case-sensitive). The aim is one meaning per code. **ISO 8601** durations use `T` to separate months from minutes (`P5M` vs `PT5M`, memory).
- **F#:** units go on literals in angle brackets, `1.0<cm>`, `55.0<miles/hour>`, `3u<days>`. They are "used for compile-time unit checking but are not persisted in the run-time environment".

**Against the factors (DP9, and K5/K6).** CSS is the clean precedent for a **quantity class**:
- The lexer classifies *shape* (number + unit identifier) without knowing what the unit means.
- The slot (the property) decides which units it accepts.

This splits Joseph's "units = a bit of both slot-type & literal-hint & coercion" exactly: the literal hints, the slot types, and conversion is the reader's job.

UCUM against the old UDON shorthand (`5m` = minutes) shows `5m` has no meaning without a named unit vocabulary. That vocabulary is a convention or a slot (A5), which is what K6 needs.

F#'s `<…>` on a numeric literal is a unit annotation: a second meaning that agents trained on F# bring to `920<px>`-like spellings (A2; a note for the angle-bracket fork).

## 7. Tags on literals: EDN, SQL, Elixir, RDF, REBOL (checked)

**What they do.**
- **EDN:** `#inst "1985-04-12T23:20:50.52Z"`, `#uuid "…"`. For a tag with no handler, "the implementation can either report an error, call a designated 'unknown element' handler" or "create a well-known generic representation that contains both the tag and the tagged element".
- **SQL:** typed literals `DATE '…'`, `TIME`, `TIMESTAMP`, `INTERVAL`, a type name followed by a quoted string. Postgres accepts `type 'string'` for any type and validates at parse. Tom Lane calls the form "a wart … we wouldn't have it if the SQL standard didn't insist" and prefers the suffix cast `'string'::type`, because only the prefix form is restricted to a literal ([pgsql thread](https://postgresql.org/message-id/2689933.1594668620%40sss.pgh.pa.us)).
- **Elixir:**
  - Calendar sigils `~D[2019-10-31]`, `~T[23:00:07.0]`, `~N[…]`, `~U[2019-10-31 19:59:03Z]`.
  - Eight delimiter choices, `<…>` among them.
  - User sigils are a function `sigil_x`, with single lowercase letters or multi-letter uppercase names.
- **RDF 1.1:**
  - A literal is "a lexical form" plus "a datatype IRI".
  - An ill-typed literal "is not *syntactically* ill-formed", and "Implementations *MUST* accept ill-typed literals and produce RDF graphs from them".
  - Unrecognized datatypes: processors "are not required to recognize datatype IRIs", and "SHOULD NOT reject such RDF".
- **REBOL:** the type comes from lexical form alone:
  - time `10:30`, date `29-Feb-2000`, money `$123`;
  - tuple `1.2.3` ("at least two periods"; `1.2` is a decimal), commonly used for version numbers;
  - pair `100x200`, issue `#707-467-8000`, email, url, file `%file.txt`;
  - tag `<a href="index.html">`, which begins with `<` and ends with `>`.

**Against the factors.**
- **DP4 and B2 (reserve-don't-ignore, a veto).** RDF is the strongest precedent that carrying a tagged literal unvalidated is forward-stable. The identity is the pair (datatype, lexical form), never the value, so a processor that later learns the datatype derives the value without changing the graph. It can count as "carry, don't ignore" only because the lexical form plus tag is kept whole. That is Joseph's "<<undetermined-value>>" (his 2026-10-20 sketch). EDN shows the same three-way choice lite faces (error, handler, generic carry) and leaves it to the reader, which lite can't do under B3 (stability: one tree in every parser). Lite has to pick one.
- **DP5, placement.** Prefix tags dominate: EDN, KDL, SQL, Elixir. That favors B1 (bounded streaming) and B5 (parse speed), because the parser knows the notation before the body. Suffix forms (Postgres `::type`, Rust `0xffu64`, C++ `5_min`, F# `<cm>`) lex the body generically first. Lane's remark is a usability counterpoint: a suffix generalizes beyond literals. That matters only where a language has expressions, which lite has none of.
- **REBOL** is the maximal standard set. Its type for versions (tuple) is exactly what K2 (`1.10`) lacks elsewhere. But a large lexical set multiplies collisions (section 9) and spec surface (A6, A7). *Memory/taste:* REBOL's lexer is known for edge-case surprises. Its `<…>` is a tag string, not a typed value, which is a different homage from the one lite's `<…>` makes.

## 8. Slot typing at scale: ProtoJSON, CUE (checked)

**What they do.**
- **ProtoJSON:**
  - int64, uint64 and fixed64 are "string" in JSON ("ProtoJSON serializers emit int64s as strings"), and for every integer type "Conformant parsers will accept either quoted or unquoted".
  - Timestamp is a string, `"1972-01-01T10:00:20.021Z"`, "Z-normalized with 0, 3, 6 or 9 fractional digits".
  - Duration is a string, `"1.000340012s"`.
  - Bytes are base64.
- **CUE:** disjunctions, `protocol: "tcp" | "udp" | "sctp" | "dccp"`. A value must unify with at least one arm, and with exactly one at export. *Memory:* CUE also writes ranges such as `int & >=0 & <=65535` on the same footing as values.

**Against the factors.** ProtoJSON is slot typing that makes the literal's own kind irrelevant: under a slot declared int64, `1` and `"1"` mean the same. Its canonical output (Z-normalized, 0/3/6/9 digits) is Joseph's C, the canonical re-emission, owned by the slot type. All of this is A5 (domain-forward) at scale, and it confirms that under a schema, DP1's classification only matters to schema-less readers. CUE's disjunction is his "algebraic names" (DP10) in a deployed language, with no special notation on the literal side at all.

## 9. Real-world damage from implicit typing (checked)

**What happened.** In 2020 the HGNC renamed 27 human genes because Excel read their symbols as dates: SEPT1 → SEPTIN1, MARCH1 → MARCHF1. A 2016 study found gene-name conversion errors in about a fifth of the supplementary spreadsheets of some 3,600 genetics papers (19.6% in one report) ([GIGAZINE](https://www.gigazine.net/gsc_news/en/20200807-genes-rename-microsoft-excel), [FAPESP](https://revistapesquisa.fapesp.br/en/automatic-conversion-in-excel-changed-to-prevent-errors-in-genetic-studies/)). Add the YAML cases in section 2.

**Against the factors (DP2, DP3; A3, B3).**
- The worst damage comes from **temporal shapes in bare position**, the widest and most collision-prone class.
- The damage was unrecoverable because the tool **kept the converted value and threw away the spelling**.

Lite always keeps the spelling, so a lite misclassification can be undone by any reader that looks. Under a default getter that converts, though, it is just as silent. That argues for the old line's 2026 partition (temporal out of bare position), and for the spelling staying primary in the tree whatever DP1 decides.

## 10. Streaming and long values: the evidence on F1 (checked, with my inference marked)

**What it does.**
- **JSON** announces a number's kind at its first character, yet implementations still had to defend against long numbers. jackson-core 2.15+ has `StreamReadConstraints.maxNumberLength`, default 1000, "to prevent potential denial-of-service attacks". A 2026 advisory (CVE-2026-18401) found the async parser skipped the check ([jackson-core README](https://github.com/FasterXML/jackson-core/blob/2.16/README.md), [OpenCVE](https://app.opencve.io/cve/CVE-2026-18401)).
- **CPython** CVE-2020-10735: converting very long digit strings to int was quadratic, so conversion was capped at 4300 digits, configurable with `PYTHONINTMAXSTRDIGITS` ([LWN](https://lwn.net/Articles/907572), [cpython#96834](https://github.com/python/cpython/issues/96834)).
- **YAML** resolves a plain scalar from its finished content (section 2): classification at the scalar's close is the standard architecture of the most widely used format with bare-scalar typing.
- **Tcl** classifies lazily, after the string exists (section 5).

**Bearing on F1 (my inference from the above).** Knowing the kind early did not remove the long-value hazard in JSON. The hazard is the *conversion*, which needs the whole digit run whenever the kind was announced, and it is bounded everywhere by a consumer-side length limit. That supports F1's claim: what costs memory and time is conversion, not classification, so B and C-with-the-view carry the same hazard, and both are bounded the same way (a conversion limit in the host mapping guide).

**Not found:** a deployed format that streams a bare scalar's characters in chunks and then emits its class as a trailer. XML SAX streams character chunks with no class at all, and YAML and Tcl classify at the end. Each half has precedent; their combination, as F1 proposes it, I didn't find.

---

## Sources (all fetched 2026-10-22 unless marked)

- [YAML 1.2.2](https://yaml.org/spec/1.2.2/) §3.3.2, ch. 10
- [XSD 1.1 Part 2](https://www.w3.org/TR/xmlschema11-2/) §2.2, §2.3, §2.3.1, §2.4.1.3
- [KDL spec](https://kdl.dev/spec/) §3.8 and numbers/strings
- [EDN](https://github.com/edn-format/edn)
- [CSS Syntax 3](https://www.w3.org/TR/css-syntax-3/) §4, §4.3.3, §4.3.13
- [TOML 1.0](https://toml.io/en/v1.0.0)
- [RFC 7493 I-JSON](https://www.rfc-editor.org/rfc/rfc7493) §2.2
- [RDF 1.1 Concepts](https://www.w3.org/TR/rdf11-concepts/) §3.3, §5.4
- [ProtoJSON](https://protobuf.dev/programming-guides/json/)
- [CUE disjunctions](https://cuelang.org/docs/tour/types/disjunctions/)
- [UCUM](https://ucum.org/ucum)
- [F# units of measure](https://learn.microsoft.com/en-us/dotnet/fsharp/language-reference/units-of-measure)
- [Elixir sigils](https://elixir.hexdocs.pm/sigils.html)
- [REBOL/Core datatypes](https://www.rebol.com/docs/core23/rebolcore-16.html)
- [StrictYAML: implicit typing removed](https://hitchdev.com/strictyaml/why/implicit-typing-removed/)
- [NestedText basic syntax](https://nestedtext.org/en/latest/basic_syntax.html)
- [Tcl_Obj (Tcl wiki)](https://wiki.tcl-lang.org/page/Tcl_Obj)
- [PyYAML documentation](https://pyyaml.org/wiki/PyYAMLDocumentation)
- [The Python 3.1 problem](https://hugovk.dev/blog/2021/the-python-3-1-problem/); [GitHub docs issue 14764](https://github.com/github/docs/issues/14764)
- Excel and gene names: [GIGAZINE](https://www.gigazine.net/gsc_news/en/20200807-genes-rename-microsoft-excel), [FAPESP](https://revistapesquisa.fapesp.br/en/automatic-conversion-in-excel-changed-to-prevent-errors-in-genetic-studies/)
- Long numbers: [jackson-core README](https://github.com/FasterXML/jackson-core/blob/2.16/README.md), [CVE-2026-18401](https://app.opencve.io/cve/CVE-2026-18401), [LWN on CVE-2020-10735](https://lwn.net/Articles/907572), [cpython#96834](https://github.com/python/cpython/issues/96834)
- SQL typed literals: [Tom Lane, pgsql-docs 2020](https://postgresql.org/message-id/2689933.1594668620%40sss.pgh.pa.us)
