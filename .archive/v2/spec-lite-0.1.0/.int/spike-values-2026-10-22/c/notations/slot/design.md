# Design N-slot: the notation lives on the slot

*Spike c, round two, fork "slot" (Opus 5.5, 2026-10-22). The design pushed to its strongest form, answering `../00-round-two.md` and rendering N1–N18. Labels: **checked** (read in a card, file or standard, with the place), **instinct** (what I'd write or expect as a target writer and reader), **guess**, **taste**. Every score is a hypothesis.*

## The design in one paragraph

A value is written in its domain's own spelling (`2026-10-01`, `5m`, `ssh`, `920px`), and what it means comes from **the slot that holds it**. The slot's **type** is found in one of three places. It can be written on the attribute name in the document (`:when<date> 2026-10-01`). It can be declared in a **vocabulary**, a lite document that names types, notations, aliases and unions, and says which slots of which elements hold them. Or it can come from a vocabulary the reader is given. **A type owns its notations**: `date` knows how to read `2026-10-01`, and `duration` knows that `m` in `5m` is minutes. So `5m` means minutes in a `duration` slot and metres in a `length` slot, with no mark on the value. Lite's raw tree holds the value's spelling and, if one was written, the slot's annotation, uninterpreted. Reading attaches meaning above the tree and never changes it. Literal marks stay what M1 made them: assertions of the portable primitives (`<8080>`, `<nil>`, `<>`).

## 1. Spelling

### The annotation on an attribute name

```udon
|event :when<date> 2026-10-01 :timeout<duration> 5m :length<length> 5m
```

- **Form:** an attribute name, then **immediately** (no space) `<`, a **type reference**, then `>`. A type reference is a label, optionally namespaced with `/` (`css/length`, `rust/i64`), optionally followed by a parenthesized parameter text (`date(YY-MM-DD)`). Nothing else: no unions, no lists, no nesting of types in the document. Those live in vocabularies, by name (§3).
- **Why `<…>` and not `.` or `:`** (taste, plus checked facts):
  - `:` collides with `xml:lang` under the labels lean (checked: `.int/labels-ascii-and-positions-2026-10-20.md` row `:`, "inner and last"). The mark fork's T3 already died on this.
  - `.` reads as nesting to TOML-, Spring- and JSON-path-trained writers (instinct: `server.port` is `{server: {port: …}}` to me). Keeping `.` an **error** in attribute names (checked: same file, row `.`, "**error** in an attribute name") turns that hazard into a teaching error. `:server.port 8080` gives: "attributes don't nest by dots; write `:server` with `:port` on the lines below, or quote the name".
  - `<…>` after a name has the generic-type prior (`Vec<u8>`, `List<Date>`, `Map<K,V>`), which reads "of type" with no teaching (instinct, A2/A3).
  - Its cost is A8: `<` gets two roles. On a value it asserts a primitive; directly after a name it names a type. Position decides, and both near-misses are caught:
    - `:when <date> 2026-10-01` (stray space): `<date>` in value position is not a primitive, so it's an error, "did you mean `:when<date> …`?" (M1's rule).
    - `:port<8080>` (missing space): `8080` is not a label, so it's an error, "did you mean `:port <8080>`?".
- **Today:** a `<` directly after a bare label is an error under the labels lean (brackets "stay structural"), so the annotation is a widening of what lite accepts. No accepted document changes.

### On an element's own line (`$main`) and in prose

`$main` is an attribute, so the same form works when it has to be explicit: `|due :$main<date> 2026-10-01`. Normally a vocabulary types it (`|slots[due] :$main date`), and the line is just `|due 2026-10-01`.

In prose, a value is marked the way HTML's `<time datetime="…">` marks it: an inline element whose slot is typed.

```udon
|p Meet on |{time :at 2026-10-01 October 1st} at the usual place.
```

The vocabulary says `time`'s `at` is an `instant-or-date`. This is the slot model, not a new form (C2: it is HTML's own model).

### Lists and attribute bodies

The slot's type applies to **every scalar the slot holds**: each stacked occurrence, each list item, each line of an attribute body.

```udon
|holidays :dates<date> [2026-01-01 2026-07-04 2026-12-25]
|holidays
  :dates<date>
    2026-01-01
    2026-07-04
```

(The body form assumes the `rule:attribute-bodies` gap lands as one value per line.)

### Vocabularies, written in lite

```udon
; file: net.vocab.ud
|vocabulary[net] :uses std
  |type[u16] :is integer :min <0> :max <65535>
  |type[standard-port] :one-of [smtp ssh http https imap]
  |type[port] :union [u16 standard-port]
  |slots[server]
    :host hostname
    :port port
    :timeout duration
  |slots[*]
    :created instant
```

- `|type[x]` defines a type: as a constraint on another (`:is`, `:min`, `:max`), as an enumeration (`:one-of`), as a union of named types (`:union`, tried in order), or as an alias (`|type[port-number] :is port`). Joseph's algebraic name is `|type[port] :union [u16 standard-port]`.
- `|slots[element-name]` gives each attribute of that element a type; `|slots[*]` applies to any element. The attribute's value is a type reference, read by the same type-reference grammar as the inline annotation.
- A vocabulary is **data, not a directive**. It is an ordinary lite document whose tree a reader loads. Its own slots are typed by a built-in meta-vocabulary, so it is self-hosting with one fixed point.

## 2. The raw tree (before any reader)

Lite parses the annotation's structure and attaches no meaning:

```udon
|event :when<date> 2026-10-01 :port 22
```
````tree
root
  |event
    :when {type-ref: date} ‹2026-10-01›
    :port ‹22›
````

- The attribute occurrence gets one new optional field, **type-ref**: the label path and the raw parameter text (`{type-ref: date, params: "YY-MM-DD"}` for `date(YY-MM-DD)`).
- The value is exactly what it would be without the annotation: a text, a string, a primitive, a list or an element.
- Vocabulary references (`:$vocab`, §3) are ordinary attributes in the raw tree.
- **The law (the B2 condition, as the mark fork stated it):** no vocabulary, type or notation ever changes the raw tree, in lite or in full UDON. Meaning is attached at the logical layer (Joseph's pipeline "udon → stream/wire → full-ast → logical-ast → API").

## 3. How a reader attaches meaning

### Finding a slot's type (most specific wins)

For an attribute occurrence `a` on an element `e`:

1. **The occurrence's own annotation** (`:a<T>`).
2. **Vocabularies in scope**, nearest first:
   1. `e`'s own `:$vocab`;
   2. each ancestor's `:$vocab`, outward to the root's;
   3. the vocabulary the file name names (`config.net.ud` → `net`, by UDON's existing `name.schema.ud` convention);
   4. the reader's configured default.

   Within each vocabulary: `|slots[e's name]`, then `|slots[*]`.
3. **None found:** the value is read as the raw tree has it. A bare run is a text; typed getters may still apply the standard reading (the `std` dial from round one).

`:$vocab` takes one name or a list (`:$vocab [net std]`), and a vocabulary's `:uses` pulls others in, in order. **Streaming rule:** a `:$vocab` governs only what follows it, so it is honored as the **first** attribute of its element (or the first top-level line for the root). Written later, it is a reader warning: "`$vocab` after content; it governs nothing before it". With that, the reader knows every slot's type when it reads the attribute's name: kind-first.

### Names and namespaces

- A vocabulary's name is a namespace. `net/port` resolves exactly. A short name `port` resolves through the vocabularies in scope, in order, nearest first.
- **The same short name in two vocabularies in scope**, defined differently, is a reader warning at load ("`port` is `net/port` here; `http/port` is shadowed; write `http/port` to use it"). The nearer one wins.
- `std` is the standard vocabulary (§6), always last in scope unless excluded.
- **Host types** are a vocabulary supplied by a host binding: `rust/i64` exists for a Rust reader; another host sees an unknown type (§3, unknown).

### Reading a value

Given the slot type `T` and the value `v`:

| `v` in the raw tree | What the reader does |
|---|---|
| a text with one run, or a delimited string | `T`'s notation reads its characters (quotes are only delimiters: `:when "2026-10-01"` reads the same as bare) |
| a text with embeds | error, unless `T` accepts texts (`text`, `markdown`) |
| a primitive from a mark (`<22>`, `<nil>`) | `T` must accept that kind as is (`u16` accepts `<22>`; `date` refuses `<22>`) |
| a list | each item by `T` (or by `T`'s item type, if `T` is a list type) |
| an element | `T` must be an element type, or the element's own vocabulary reads it |

A union tries its arms in order, and the first arm that reads the value wins. `:port ssh` → `standard-port`; `:port 22` → `u16` 22.

### Errors and warnings (reader-side, each with a "did you mean")

- **Doesn't read:** `:port 70000` → "`70000` is not a `port`: `u16` is 0–65535; `standard-port` is one of smtp, ssh, …".
- **Unknown type** (N14): `:sku<acme/sku> AB-12` with no `acme` vocabulary → the logical value is the text, marked `unresolved acme/sku`. A strict getter raises "no vocabulary in scope defines `acme/sku`". A default-on reader warning says the same.
- **Kind conflict:** `:when <5>` in a date slot → "`when` is a `date`; `<5>` is an integer. Did you mean `:when 2026-…`?"

These are the reader's errors, never the parser's. The tree exists, and a lenient reader still gets the text.

## 4. The tree after (logical layer)

````tree
logical
  |event
    :when 2026-10-01::date   (spelled ‹2026-10-01›; type date via annotation; notation std/date rfc3339)
    :port 22::port.u16      (spelled ‹22›; type net/port, arm u16; via vocabulary net)
````

Each typed value keeps its **spelling**, its **type** (and union arm), its **notation**, and **where the type came from** (annotation, which vocabulary, or the file convention). Nothing is lost for round trip.

**Re-emission:**
- **As written** (the default) writes the raw tree back byte for byte.
- **Canonical** asks each type for its canonical notation and rewrites the value *and*, where needed, the annotation. `:d<date(YYYYMMDD)> 20261001` becomes `:d<date> 2026-10-01`, because canonical dates need no parameter.

## 5. Naming, parameters, nesting

- **Parameters** belong to a type's notation and are carried raw by lite: `date(YY-MM-DD)`. `std/date` defines its pattern letters (`YYYY YY MM DD`) and the two-digit-year pivot (default 2000–2099; a parameter can set another, `date(YY-MM-DD, pivot 1950)`). Lite never parses the parameter text (A7).
- **Nesting** is by type, not by literal. `|type[span] :is interval(date)` or inline `:span<interval(month)> 2026-01/2026-06`. The `interval` notation reads `start/end` and hands each side to its parameter type. No value is ever written inside another value. That is the design's answer to N6, and what keeps every value bare.
- **Aliases:** `|type[when] :is instant`. A short name for a long one is also an alias in a vocabulary in scope.

## 6. Dates and units: the standard vocabulary `std`

A companion (not the spec), written as a lite vocabulary. Exact spellings:

| Type | Accepts | Canonical |
|---|---|---|
| `date` | RFC 3339 full-date `2026-10-01`; with a pattern parameter, that pattern | `2026-10-01` |
| `month`, `year` | `2026-10`, `2026` | same |
| `time` | `09:00`, `09:00:00`, `09:00:00.123` (RFC 3339 partial-time; 24-hour, two-digit fields) | `09:00:00` |
| `instant` | RFC 3339 date-time with `Z` or an offset; an RFC 9557 suffix `[America/Denver]` (checked: RFC 9557 §, the bracketed suffix; `!` = critical) | as written |
| `local-datetime` | `2026-01-10T14:30` (no offset) | same |
| `zoned-partial` | `2026`, `2026-10`, `2026-10-01`, then a space and an IANA zone or a zone abbreviation from a fixed table (`PDT` → America/Los_Angeles, DST) | as written |
| `duration` | ISO 8601 `P1Y2M`, `PT30S`; shorthand `30s`, `5m`, `1h30m`, `2d`, `3wk`, `1mo`, `1y` (in this notation `m` = minutes, `mo` = months) | ISO 8601 |
| `interval(T)` | `start/end` (ISO 8601), each side read by `T`; `start/duration` | same |
| `length`, `mass`, `temperature`, … | a number, an optional space, a UCUM unit of that dimension: `5 m`, `5m`, `37.5 Cel`, also `37.5 °C` and `37.5°C` as display aliases | number, space, UCUM code |
| `quantity` | any UCUM quantity: `1.5 GiBy`, `9.81 m/s2` | same |
| `bytes` | `1.5GiB`, `1.5 GiB`, `200MB`, `512 KiB` (IEC and SI prefixes on `B`) | `1.5 GiB` |
| `percent` | `50%`, `50 %` | `50%` |
| `money` | an exact decimal, a space, an ISO 4217 code: `9.99 USD` | same |
| `css/length` | CSS length: `920px`, `1.5em`, `50vw` | same |
| `integer`, `float`, `boolean`, `nil`, `text` | the standard notation (core fork) | — |
| `u8`…`u64`, `i8`…`i64` | integer **ranges**, never storage; a host derives storage | — |
| `regex`, `url`, `uuid`, `base64`, `hostname` | the usual notations (ECMAScript regex syntax; RFC 3986; RFC 9562 UUID; RFC 4648 base64) | lowercase UUID; others as written |

The UCUM facts are as checked in `../00-round-two.md`: `m` metre, `min` minute, `mo` month, `By` byte, `Ki`/`Mi`/`Gi` "proposed". The `bytes` type exists because `GiBy` is UCUM-correct and nobody writes it (instinct).

**How `5m` resolves:** `:timeout<duration> 5m` is five minutes (duration's shorthand). `:length<length> 5m` is five metres (UCUM `m`). A bare `5m` in an untyped slot is the text `5m`. This is round one's U1 completed: the slot gives the dictionary, and the dictionary belongs to the type.

## 7. Slot and literal together (N15)

- **The slot says `date` and the occurrence annotates another type:** the annotation wins for that occurrence, and the reader checks that it still fits the vocabulary's declaration. Say `ops` declares `when: date` and the writer writes `:when<epoch> 1767225600`. If `date` lists `epoch` among the notations it accepts, the value reads as the date of that instant. If not, the reader errors: "`when` is a `date` (vocabulary `ops`); `epoch` gives an `instant`. Did you mean `:when<date(epoch)> …`?" The answer is the parameter form, where the type stays `date` and the notation is chosen by parameter. **So the type is the slot's; the notation is choosable per occurrence.** That is Joseph's "*what the slot is* vs *what my literal represents*", in the one place where the literal side can speak.
- **A mark on the value:** it asserts a primitive kind, which the slot must accept (§3 table).
- **Two vocabularies disagree:** the nearer wins, with a shadowing warning (§3).

## 8. Joseph's future forms

- **A reference kept as a reference (`@<…>`):** in N-slot, keeping versus resolving is the slot's: a slot of type `ref` holds an address, never resolved (`:author<ref> people/jw`); `@{people/jw}` resolves. His Lisp-quote distinction then sits on the slot, where his "what the slot is" says it belongs. N-slot gives `@<…>` no separate role and leaves it reserved, as [[rule:reserved-spellings]] has it today. The kept-reference *meaning* is fully designed here, as the `ref` type.
- **An embedded value (`<{…}>`):** a structured value is an element (`:origin |point :x <1> :y <2>`), and the vocabulary types its slots (`|slots[point] :x integer :y integer`, and `:origin point`). N-slot needs no embedded-value form. Structure is elements, meaning is slots.

## 9. The composite set N1–N18

Raw tree first, then the logical value. `{T}` shows an occurrence's type-ref. The vocabularies `std` and `net` are in scope.

```udon
|vocab-demo :$vocab [net std]
  |e :d<date> 2026-10-01                                         ; N1
  |e :at<instant> 2026-01-10T14:30Z
  |e :at<instant> 2026-01-10T07:30-07:00[America/Denver]         ; N2
  |e :t<time> 09:00 :y<zoned-partial> 2026 PDT                   ; N3
  |e :born<date(YY-MM-DD)> 27-03-05                              ; N4
  |e :a<duration> 30s :b<duration> P1Y2M :c<duration> 5m        ; N5
  |e :span<interval(month)> 2026-01/2026-06                      ; N6
  |e :w<css/length> 920px :l<length> 5 m :s<bytes> 1.5 GiB :p<percent> 50% :temp<temperature> 37.5 °C   ; N7
  |e :price<money> 9.99 USD                                      ; N8
  |e :addr<i64> 0x73DDF                                          ; N9 (domain range)
  |e :addr<rust/i64> 0x73DDF                                     ; N9 (host vocabulary)
  |server :port ssh                                              ; N10
  |server :port 22
  |e :re<regex> '\d+-\w+' :u<url> https://example.com :id<uuid> 3f2a8c1e-0b7d-4f3e-9a51-6d2c8e4b1f07 :raw<base64> SGVsbG8=   ; N11
  |report
    :query<sql>
      ```
      SELECT id FROM t
      WHERE created > '2026-01-01'
      ```
  |holidays :dates<date> [2026-01-01 2026-07-04]                 ; N13
  |e :sku<acme/sku> AB-12                                        ; N14
  |e :when<epoch> 1767225600                                     ; N15 (with ops declaring when: date)
  |p Meet on |{time :at 2026-10-01 October 1st}.                 ; N16
  |li \<https://example.com>
  |e :author<ref> people/jw :origin |point :x <1> :y <2>         ; N17
  |e :d<date(YYYYMMDD)> 20261001                                 ; N18
```

| | Raw tree | Logical value | Verdict |
|---|---|---|---|
| N1 | `:d {date} ‹2026-10-01›` | 2026-10-01::date | renders |
| N2 | `{instant} ‹2026-01-10T14:30Z›`; `{instant} ‹…-07:00[America/Denver]›` | instants; zone kept | renders (RFC 9557 suffix) |
| N3 | `{time} ‹09:00›`; `{zoned-partial} ‹2026 PDT›` | 09:00::time; year 2026 in America/Los_Angeles | renders; `PDT` resolved through a fixed table, an honest weak spot (abbreviations aren't unique worldwide) |
| N4 | `{date params "YY-MM-DD"} ‹27-03-05›` | 2027-03-05 (pivot 2000) | renders; the parameter is the notation's |
| N5 | `‹30s›` `‹P1Y2M›` `‹5m›`, each `{duration}` | PT30S, P1Y2M, PT5M | renders; `m` = minutes by the type |
| N6 | `{interval params "month"} ‹2026-01/2026-06›` | interval(2026-01, 2026-06) | renders; nesting by type, not by literal |
| N7 | `‹920px›` `‹5 m›` `‹1.5 GiB›` `‹50%›` `‹37.5 °C›` with their types | css 920px; 5 m; 1.5 GiB; 50%; 37.5 Cel | renders |
| N8 | `{money} ‹9.99 USD›` | 9.99 USD (exact decimal) | renders |
| N9 | `{i64} ‹0x73DDF›`; `{rust/i64} ‹0x73DDF›` | 474591 in i64 range; a Rust reader stores an `i64`, other hosts warn "unknown `rust/i64`" and keep the text | renders; the first is the recommended spelling (A5) |
| N10 | `:port ‹ssh›`, `:port ‹22›` (no annotation) | standard-port ssh; u16 22, both via `net` | **renders with zero plumbing per value**: the design's strongest case |
| N11 | `{regex} '\d+-\w+'` (single-quoted, so the backslashes are literal: checked, [[rule:single-quote-escapes]]); url, uuid, base64 as texts | regex, url, uuid, bytes | renders. Note: a bare `\d` hits the proposed [[rule:value-line-escapes]] (an unknown `\X` is an error), so regexes are quoted. That's an error, not a silent miss. |
| N12 | `:query {sql}` holding a fence | sql text | renders; it assumes a fence may be an attribute's value (open: the PEG review found fences couldn't be). Alternatively the fence's own name `sql` is the type: ```` ```sql ````. |
| N13 | `{date}` over a list, and over a body | two dates | renders; one declaration covers every item |
| N14 | `{acme/sku} ‹AB-12›` | text, marked unresolved `acme/sku`; warning | renders; nothing lost, and an `acme` reader later gets the SKU |
| N15 | `{epoch} ‹1767225600›` | the date 2026-01-01, if `date` accepts `epoch`; otherwise a reader error suggesting `<date(epoch)>` | renders |
| N16 | `time` element, `:at ‹2026-10-01›`, `$main ‹October 1st›` | at = date | renders through an element (HTML's `<time>` model); the date is not marked in the run itself |
| N16b | `$main ‹<https://example.com>›` (escaped) | — | unbare `|li <https://…>` is M1's error; N-slot adds no collision |
| N17 | `{ref} ‹people/jw›`; an element value `point` | a kept address; a point | renders, by slot type; no new literal form |
| N18 | `{date params "YYYYMMDD"} ‹20261001›` | 2026-10-01 | as written: `:d<date(YYYYMMDD)> 20261001`; canonical: `:d<date> 2026-10-01` (annotation and value both rewritten) |

## 10. Where N-slot is weak (tried to make each work; this is what's left)

1. **A one-off value in a document with no vocabulary costs one annotation**, the same plumbing as naming it on the literal (`:when<date> 2026-10-01` vs `:when <date:2026-10-01>`). N-slot wins only where declarations are shared: vocabularies, lists, bodies, repeated attributes. **In data with a vocabulary that is nearly always.** In throwaway documents it is a tie.
2. **A heterogeneous list** (`[2026-01-10 P1D 09:00]`, each a different type) can't name each item's type in place. N-slot's answers: a union type in a vocabulary (`|type[when-ish] :union [date duration time]`), which works because their spellings are disjoint; or one element per item. Per-item naming in place needs a literal-side form, which this design gives up by choice. **This is the one honest gap.**
3. **Marking a value inside running prose** needs an inline element (`|{time …}`), not a bare marked run. In return, the element carries the human-readable text beside the machine value, which is what HTML found it needed.
4. **The meaning isn't visible on the value.** A reader seeing `:port 22` alone doesn't know it's a port of union type until they see the vocabulary. A10 is weighted 5 on purpose (Joseph: explicitness "doesn't compose"), and the file name or `$vocab` points at it.
5. **`<` has two roles** (type after a name, primitive on a value). Every near-miss between them is an error, never silent.
6. **The whole system is bigger than lite's part.** Lite adds one rule (the annotation form), one field (type-ref) and one designated attribute (`$vocab`). The resolution chain, the vocabulary format and `std` are companions. A6's "spine" stays short only if those are clearly companions.

## 11. Vetoes and scores (hypotheses)

| | Factor (weight) | Score | Basis | Conf. |
|---|---|---|---|---|
| B1 | Bounded streaming (veto) | **pass** | the type is known from the name (annotation) or from vocabularies loaded before the value (`$vocab` must come first); the parser holds nothing new | high |
| B2 | Reserve, don't ignore (veto) | **pass** | the annotation's structure is parsed; its meaning is attached above the tree, and the law forbids any reader from changing the tree; unknown types keep the value | high |
| A1 | Agent-subjective (9) | 8 | values read as the domain writes them; the plumbing collects in one vocabulary file (taste) | low |
| A2 | Generative guessability (10) | 7 | `:port<u16> 8080` is guessable from generic-type priors; with a vocabulary the writer writes bare values and is right by default; no silent misses introduced (errors for both `<` near-misses and for `:a.b`) | medium |
| A3 | Cold comprehension (10) | 8 | `:when<date> 2026-10-01` reads at once; a bare value in a vocabulary-typed slot reads as its domain spelling, and the cost is not knowing its exact type | medium |
| A4 | Agentic readability (10) | 8 | lines stay short; annotations sit by the name, not inside values | medium |
| A5 | Domain-forward (9) | 9 | zero plumbing per value where a vocabulary applies (N10, N13); the best of any design here by construction | medium-high |
| A6 | Spec clarity (9) | 7 | lite's part is one rule; the reader model (scope chain, unions) is a companion that must be learned | medium |
| A7 | Syntactic simplicity (8) | 8 | one production in lite; type expressions stay names with raw parameters | medium |
| A8 | Parsimony (8) | 7 | `<` takes a second role | medium |
| A9 | Conciseness (6) | 8 | high with vocabularies, a tie without | medium |
| A10 | Self-description (5) | 5 | meaning is often outside the document; deliberately low | high |
| B3 | Stability (10) | 9 | one tree; nothing typed by spelling | high |
| B4 | Errors that teach (8) | 8 | `:a.b`, both `<` near-misses and reader type errors all teach; type errors come at read time, not parse time | medium |
| B5 | Parse speed (9) | 9 | the parser does almost nothing new; conversion is per typed slot | medium |
| B6 | Headroom (7) | 7 | spends `<` after an attribute name; leaves `<name:…>` on values free for full UDON | medium |
| C1 | Structured data (10) | 7 | vocabulary-backed data round-trips exactly (a JSON Schema could be translated into a vocabulary); schema-less data still needs M1 marks or the `std` dial | medium |
| C2 | XML/HTML (10) | 9 | this is XML-with-schema's and HTML's own model (all attributes text; the spec types them; `<time datetime>`) | medium-high |
| C3 | Markdown (9) | 8 | prose untouched; no new collision | medium |
| C4 | Types, notations, units (8) | 8 | every N item renders; per-item naming in heterogeneous lists is the gap | medium |
| C5 | Schemas, slot types (8) | 10 | the design's center: aliases, unions, vocabularies, scope | high |
| C6 | Extensibility (8) | 8 | vocabularies are the extension mechanism; host vocabularies (`rust/`) are just vocabularies | medium |
| C7 | Predictable tree and API (8) | 9 | typed reads per slot; one optional field on an occurrence | medium |
| C9 | Composition, logical store (7) | 8 | vocabularies are lite documents in the store; `name.schema.ud` gives the default | medium |
| C10 | Round-trip (7) | 9 | spelling kept; canonical emission rewrites annotation and value together | medium |

## 12. Card radius (proposals; no cards edited)

- **New:** a rule for the attribute-name annotation (`name<type-ref>`, no space; the type-ref grammar; the two near-miss errors); a definition of «type-ref» (or «slot-type»); `$vocab` as a designated attribute, honored first; the law "reading never changes the raw tree" (or into [[decision:forward-compat-aspiration]]).
- **Changed:**
  - [[def:attribute-name]]: an annotation may follow the name.
  - The labels rule: `<` after a bare attribute name is no longer an error.
  - [[rule:reserved-spellings]]: `<` after a name comes off the list; `@<…>` stays.
  - [[def:reading-option]] / [[rule:unquoted-run-is-one-value]]: typed reads draw their type from the slot chain.
  - [[def:fence]] / [[rule:fence-default-handler]]: a fence's name is a type reference to its handler (one concept, if adopted).
- **Companions:** the vocabulary format and its meta-vocabulary; `std` (§6); the host vocabulary convention (`rust/`, `js/`).
- **Interactions:** the `rule:attribute-bodies` gap (one value per line under a typed slot); `$` as a label character (open in the labels work).

Roughly six records changed and four new, plus two companions. **Impact radius: moderate to high**, but all of it is additive: no accepted document changes.

## 13. Relation to the shared reader model (`../reader-model.md`)

This design follows the shared reader model: the notation's parts (read, write, type, host binding), scope by file name, root attribute or reader configuration with the most specific winning, unknown notations kept unread, and the raw tree never changed by reading. It diverges in four places:

- **The slot is primary, not the literal.** A slot's type picks the notation for bare values, and the per-occurrence override is a parameter on the slot's annotation (`<date(epoch)>`), not a literal-side name.
- **`$vocab`** is the root or element attribute that brings a vocabulary into scope, honored first.
- **Partial dates** are the separate types `month` and `year`, not partial `std/date`. Taste: a slot that wants a full date should reject `2026`.
- **The RFC 9557 zone suffix** is accepted by `instant`, not by a separate `zoned`. This one is genuinely open: a separate type is the better choice if slots want to require a zone.

Checked fact relayed by the spike agent: UCUM defines unit terms only, not how a number and a unit are written together. So "number, optional space, UCUM code" in `length`, `quantity` and the rest is `std`'s own convention. Celsius is `Cel`, and `°C` is a display alias that `std` accepts.

## 14. What lite 0.1 would take, if this design is chosen

The annotation rule, the `type-ref` field, `$vocab` and the law go into lite 0.1. `std` and the vocabulary format are the companions that give them meaning. Nothing in M1 changes; the two compose: M1 asserts primitives on values, and N-slot names types on slots.
