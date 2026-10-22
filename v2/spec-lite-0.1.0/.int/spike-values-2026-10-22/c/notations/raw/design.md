# Design N-raw: a value in a named notation, spelled inline or as a fence

*Spike c, round two, the `raw` design fork (Opus 5.5, 2026-10-22). Designed to its strongest form; where a part couldn't be made clean, that is said with the reason. Labels: **checked** (read in a card, a spec or a standard, place named), **instinct** (what I'd write or expect as a target writer and reader), **guess**, **taste**. Scores are hypotheses against `CTQ-FACTORS.md`. The shared reader model is `../reader-model.md`; this design follows it except where it says so (§3).*

## 1. The idea in one paragraph

Lite already has a construct that says "this is in another notation; its handler reads it": the **fence**. ```` ```sql ```` names a notation, its body is never scanned, and a handler interprets the opening line's traits and attributes ([[rule:fence-opener-line]], [[rule:fence-default-handler]], checked). N-raw adds the **inline spelling of the same thing**: `<name: body>`. Both are **notation values**: a notation name with optional parameters, plus a verbatim body, which lite carries and a reader reads. One concept and two spellings, chosen by length: one line goes inline, more than one goes in a fence. `<…>` with no name keeps M1's job (assert a portable primitive: `<8080>`, `<nil>`, `<>`).

```udon
|event :on <date: 2026-10-01> :at <instant: 2026-01-10T14:30Z> :timeout <duration: 5m>
  :query ```sql
    SELECT id FROM t WHERE day = '2026-10-01'
    ```
```

## 2. The grammar (what lite 0.1 would card)

### 2.1 The inline form

```text
explicit-value  = "<" ws* ( notation-value | primitive | "" ) ws* ">"
notation-value  = head ":" ws+ body
head            = notation-name ( "." trait )*
notation-name   = label                      ; labels lean: "/" and ":" allowed inner
trait           = label | quoted-name
body            = verbatim characters, up to the ">" that matches the opening "<"
```

1. **Kind-first.** After `<` (and optional space): `"`, `'`, a digit, `+`, `-` → a primitive (M1). `>` → nil (`<>`). A letter or `_` → a label is read. If the label is exactly `nil`, `true` or `false` and is followed by `>`, it is that primitive. If it is followed (after optional traits) by `:` and at least one space, it is a **notation head**. Anything else is an error that says what was probably meant. The decision is made within the label plus two characters (checked against the labels lean: a label can't start with a digit, so `<2026-…>` is never a head).
2. **The separator is a colon followed by whitespace.** `<date:2026-10-01>` (no space) is an error: "did you mean `<date: 2026-10-01>`?". The space is what keeps three things apart. These are the gains of this rule:
   - `:` inside names, which the labels lean admits (`xml:lang`): `<rust:i64: 0x73DDF>` is the name `rust:i64` and the body `0x73DDF`, which is exactly Joseph's own spelling;
   - URLs and autolinks: `<https://example.com>` has no space after its colon, so it is **an error, never a silent notation**. That closes the one silent collision the mark fork found in M2;
   - `mailto:`, `urn:` and every other URI scheme: the same, for the same reason.
3. **The body is verbatim.** It is never scanned for escapes: a backslash is a backslash, as in a fence body ([[rule:fence-body-not-scanned]]). The only structure lite sees in a body is `<` and `>`, which nest as matched pairs ([[rule:matched-pairs-need-no-escape]]). The body ends at the `>` that matches the opening `<`. One run of whitespace after the separator, and any whitespace before the closing `>`, is frame, not body (Joseph's 2026-10-21 trimming lean).
4. **A body that can't be written that way goes in a fence.** That means a body with an unmatched `<` or `>`, or one that spans lines. The inline error says so: "`<expr: a > b>` closed at the first `>`; for a body with an unmatched `>`, use a fence: ```` ```expr ````."
5. **One line.** A newline before the closing `>` is an error that names the fence form ([[rule:newline-in-opaque-span-is-error]], with its message improved).

*Why verbatim and no escapes:* the store's current lean for `<…>` is "only `\\`, `\<`, `\>`; any other backslash an error" ([[rule:opaque-span-escapes]], checked). That makes `<re: \d+>` an error, and the only legal regex is `<re: \\d+>`, so every regex and every Windows path is written in a spelling that isn't its own. In N-raw the body *is* the other notation's spelling, which then owns its own escapes (a regex's `\d`, a path's `\`). This is the same contract fences already have, and the inline form inherits it. The price is that unmatched brackets move to the fence. Taste plus a check: a body needing an unmatched `>` is rare outside comparison expressions, and those are exactly what fences are for. This changes a provisional card (§9).

### 2.2 The block form

A fence's opening line already reads like an element's line: a name, keys, traits, attributes, `$main`, and a framed comment, all handed to the fence's handler (checked). Under N-raw:

- The fence name **is a notation name** (`sql`, `std/date`, `acme/sku`).
- Its traits **are the notation's parameters**, the same as the inline form's (`.YY-MM-DD`, `.exact`).
- Keys, attributes and `$main` on the opening line are parameters too. They are open to a handler only in the block form, because the inline head is a name plus traits.
- `.exact` (keep indentation) is a **standard trait every handler accepts**, so [[rule:fence-exact-trait]] becomes one instance of "traits are parameters".
- A fence with no handler in scope keeps the default handler's behavior: dedent, accept keys, `.exact` and a comment. That is what lite does today, so lite's tree is unchanged.

**The one concept, stated once:** a *notation value* is a notation name, its parameters, and a verbatim body. Inline it is `<name.params: body>`. In block form it is a fence, whose opener carries name, params, keys and attributes, and whose body is the lines up to the closer.

### 2.3 In text (prose and sameline text): `<{…}>`

Joseph's "embedded value" gets this meaning. `<{head: body}>` is a notation value **as a piece of a text**: a fourth embed beside `|{…}`, `@{…}` and `;{…}`, with the same interior as the inline form.

```udon
|p Meet on <{date: 2026-10-01}> at the usual place.
```

Its closer is `}>`, chosen so that a `}` inside the body (`<{json: {"a":1}}>`) can't end it early. Matched `{}` count, just as `<>` do. *Guess, taste:* `<{` at a text position is very rare in Markdown and HTML prose; it's escaped as `\<{` ([[rule:prose-escaped-embeds]] gains one row). In a value position you write `<date: …>` directly; `<{…}>` there is an error that suggests it.

### 2.4 `@<…>`: a reference as a value, kept

A reference to a value, never resolved, is a value in the reference notation. So `@<people/jw>` is the short form of `<ref: people/jw>`, and the address theory owns the body. Compare `@{people/jw}`, the embed that renders its referent. This gives Joseph's "reference kept as a reference, not resolved in place" its own spelling, so `@{<…>}` is no longer needed for it. It is also why `@<…>` should stay a value-position form and not become an embed: a kept reference is data, and data goes in a value.

## 3. How a reader attaches meaning

Following `../reader-model.md`, with three choices made concretely:

1. **Names.** `/` separates namespaces (`std/date`, `acme/sku`, `css/length`). An unqualified name resolves through the vocabularies in scope, then `std`. `:` inside a name is just a label character, so `rust:i64` is a single name some vocabulary can define. Joseph's two spellings, `<namespaced/type: val>` and `<rust:i64: 0x73DDF>`, both parse; the first is the convention. Taste: `/` also matches the world's existing registry of notation names, IANA media types (`text/csv`, `application/json`). A fence named `text/csv` reads the way a writer expects (instinct).
2. **Parameters are traits**, and a notation definition lists the traits it accepts. Unknown traits are reader errors ("`std/date` has no parameter `.basik`; did you mean `.basic`?"). Traits are labels, so most format parameters can be written bare (`.YY-MM-DD`). Ones that can't are quoted (`.'%Y/%m/%d'`, [[def:quoted-name]]).
3. **A parameter that changes meaning is part of the value's notation** in the logical tree, so canonical re-emission can drop it only by resolving it (§6, N4).

**Before and after:**

````tree
raw tree (lite):     :on   ⟨date: ‹2026-10-01›⟩              form angle, span 1:8–1:28
logical tree:        :on   date 2026-10-01  {notation std/date, written "date", spelling ‹2026-10-01›, form angle}
````

The raw tree is the same under every reader. Once a reader knows `std/date`, it adds the second line, and the first line doesn't change. That is the "read above the tree" law the mark fork found necessary for B2. Under N-raw it is a law lite *states* rather than merely obeys: **lite carries notation values; it never reads them. A full UDON parser produces the same raw notation node and reads it in the logical layer.**

**Unknown notations** become `unread{acme/sku, ‹AB-12›}`. A strict typed read raises "no notation `acme/sku` in scope (vocabularies in scope: std, net)". A converter emits the value as written (`"<acme/sku: AB-12>"`) by default, or as `{"$notation": "acme/sku", "$body": "AB-12"}` when asked to stay lossless.

**Fences under the same model:** ```` ```sql ```` with a `sql` notation in scope reads to whatever that notation's type is (a parsed query, or just a checked text). With none in scope, the body stays text. This is today's behavior, now with a name for what was already happening.

## 4. Slot and literal

N-raw composes with the slot design (`../slot/`) without needing it.

- A slot whose vocabulary declares a notation reads bare values through it: in a slot declared `std/date`, `:on 2026-10-01` gives the date.
- A literal's notation **overrides the slot's notation** for that value, and the result is **checked against the slot's type**. In a `date` slot, `<date.YY-MM-DD: 27-03-05>` passes. `<instant: 2026-01-10T14:30Z>` fails with "slot `on` expects a date; this is an instant. Did you mean `<date: 2026-01-10>`?". It is coerced only if the slot declares the coercion, which would have to name a zone.
- **Algebraic names** are unions in a vocabulary: `port` = `std/u16 | net/service` (an enumeration). Two notation names are spelled:
  - `<port: ssh>` and `<port: 22>` read through the union, trying each arm in order, so the first arm that reads wins and `22` is the u16 22;
  - bare `ssh` and `22` read the same way in a slot declared `port`.

  The literal form is needed only where there's no slot.

## 5. The standard library: exact spellings

These are meanings, as a companion to lite (not lite's grammar). Each row is `name`: what it reads → its type, and its canonical form.

### Dates and times

| Name | Reads (checked against RFC 3339 / RFC 9557 where cited) | Canonical | Type |
|---|---|---|---|
| `date` | RFC 3339 `full-date` `2026-10-01`; ISO 8601 reduced precision `2026-10`, `2026` (precision kept). Params: `.basic` (`20261001`); a pattern trait of `YYYY YY MM DD` and separators (`.YY-MM-DD`, `.DD.MM.YYYY` quoted where needed). `YY` means 20YY; another pivot is a pattern with `YYYY` or a vocabulary's own notation | `2026-10-01` | calendar date with precision |
| `time` | RFC 3339 `partial-time` `14:30:00`, `14:30:00.25`; `14:30` accepted (ISO 8601 allows it); `24:00` not accepted (taste: one spelling of midnight) | `14:30:00` | wall-clock time |
| `datetime` | RFC 3339 `date-time` with the offset optional: no offset → local (floating); offset → instant; with an RFC 9557 suffix `[Area/City]` → zoned (`!` critical honored, checked). Lowercase `t`/`z` accepted (RFC 3339 allows them) | uppercase `T`/`Z`, as written otherwise | local / instant / zoned date-time |
| `instant` | `datetime` that **requires** an offset or `Z` | as written | a point on the UTC line |
| `duration` | Two spellings, decided by the first character. ISO 8601 (`P1Y2M`, `PT30S`, `P2W`; components in order; a fraction only on the last) when it starts with `P`. Shorthand when it starts with a digit: `30s`, `5m`, `2h`, `1d`, `2w`, `1mo`, `1y`, `250ms`, and compounds in descending order (`1h30m`). Inside `duration`, **`m` is always minutes and `mo` months** | ISO 8601 | duration (calendar and exact parts kept apart) |
| `interval` | ISO 8601 `start/end`, `start/duration`, `duration/end`; each side read by `datetime`/`date`/`duration` | as written | interval |

Joseph's `<dt: 2026 PDT>`, a year in a zone: `datetime` reads `2026[America/Los_Angeles]` as a year-precision zoned value. RFC 9557's suffix is defined only on full timestamps, so this is **std's own extension**, labeled as such. `PDT` is refused with a suggestion ("`PDT` is an abbreviation that several zones use; did you mean `[America/Los_Angeles]`?"), since abbreviations aren't a zone database. If a domain needs abbreviations, its vocabulary defines a notation that maps them.

### Quantities and units

| Name | Reads | Canonical | Type |
|---|---|---|---|
| `qty` | a number, optional space, a UCUM case-sensitive unit term: `5 m`, `5 min`, `1.5 GiBy`, `50 %`, `37.5 Cel`. The number-space-unit pairing is **this notation's convention, not UCUM's**: UCUM defines unit terms only (checked by a sibling, `../00-round-two.md`). UCUM print symbols `°C`, `°F` are accepted as input | number, one space, c/s code | quantity (value + unit with dimension) |
| `bytes` | number + SI or IEC byte unit: `1.5 GB` (10⁹), `1.5 GiB` (2³⁰), `B`, `kB`, `KiB`, … | as written | byte count |
| `css/length` | a CSS `<length>` or `<percentage>`: `920px`, `2em`, `50%` | as written | CSS length |
| `money` | an exact decimal and an ISO 4217 code: `9.99 USD` (or `USD 9.99`) | `9.99 USD` | amount + currency; the decimal is exact |
| `dec` | an exact decimal: `0.10` keeps its scale | as written | decimal (Joseph's `0d83.23` question gets its answer here, as a notation, not a prefix) |

**How `5m` is resolved:** it never stands alone. In `duration` it is minutes, in `qty` it is metres (UCUM `m`), and in `css/length` it is an error ("no CSS unit `m`"). In a slot, the slot's notation decides. **The unit's meaning belongs to the notation that reads it, never to the spelling.** A writer who writes `<qty: 5m>` meaning minutes gets metres, so `qty` is a near-miss trap for time. The reader catches it whenever a slot has a dimension (a `timeout` slot expecting time rejects a length: "this is 5 m (a length); did you mean `<duration: 5m>` or `<qty: 5 min>`?").

**The bel trap, found while checking UCUM:** in UCUM, `B` is the **bel**, so `<qty: 1.5 GB>` would be 1.5 gigabel. `qty` refuses `B`-family terms from anyone who plausibly meant bytes: "UCUM `B` is the bel; did you mean `<bytes: 1.5 GB>` or `<qty: 1.5 GBy>`?". This is the case for a separate `bytes` notation. *(The bel as UCUM's `B` is from memory; the byte code `By` was checked.)*

### Other standard notations

| Name | Reads |
|---|---|
| `url` | an RFC 3986 URI reference (`<url: https://example.com/a?b=c>`) |
| `uuid` | the 8-4-4-4-12 hex form; lowercase canonical |
| `re` | **I-Regexp, RFC 9485** (checked: October 2023, "a flavor of regular expression limited in scope to enable interoperation", a subset of XSD regexps). Other flavours are other notations (`pcre/re`, `js/re`) or a parameter (`<re.pcre: …>`) |
| `b64`, `hex` | bytes in RFC 4648 base64 / hex |
| `i8` … `i64`, `u8` … `u64` | an integer in the standard numeric notation, checked against the range. This is a **domain range**, never a storage instruction; each host's binding picks storage (the ideation file's lean on H) |
| `ref` | an address-theory reference, kept (`@<…>` is its short form) |

## 6. Canonical re-emission

The logical value keeps `{notation, written name, params, spelling, form}`.

- **As written** is the default, and round-trips byte for byte (C10): spelling, name as written, form.
- **Canonical** calls the notation's `write` and emits the shortest name that resolves to the same definition in the target scope. **It drops a parameter only by resolving it**:
  - `<date.basic: 20261001>` becomes `<date: 2026-10-01>`;
  - `<date.YY-MM-DD: 27-03-05>` becomes `<date: 2027-03-05>`, because the century is decided once and written out;
  - `<duration: 1h30m>` becomes `<duration: PT1H30M>`.
- A fence re-emits as a fence. Canonicalizing a one-line fence to inline (or the reverse) is a formatter's option, never a reader's default.

## 7. The composite set, N1–N18

Raw tree rows show `⟨name.params: ‹body›⟩` for a notation value (form angle unless marked). The logical rows show what `std` gives.

```udon
|n1 :on <date: 2026-10-01>
|n2 :at <instant: 2026-01-10T14:30Z> :local <datetime: 2026-01-10T07:30-07:00[America/Denver]>
|n3 :opens <time: 09:00> :season <datetime: 2026[America/Los_Angeles]>
|n4 :born <date.YY-MM-DD: 27-03-05>
|n5 :a <duration: 30s> :b <duration: P1Y2M> :c <duration: 5m>
|n6 :span <interval: 2026-01/2026-06>
|n7 :width <css/length: 920px> :length <qty: 5 m> :disk <bytes: 1.5 GiB> :share <qty: 50 %> :temp <qty: 37.5 Cel>
|n8 :price <money: 9.99 USD>
|n9 :addr <i64: 0x73DDF> :raw <rust:i64: 0x73DDF>
|n10 :port <port: ssh>
|n10 :port <port: 22>
|n11 :pat <re: \d+-\w+> :home <url: https://example.com> :id <uuid: 0f8fad5b-d9cb-469f-a165-70867728950e> :blob <b64: SGVsbG8=>
|n12
  :query ```sql
    SELECT id FROM t
    WHERE day = '2026-10-01'
    ```
|n13 :holidays [<date: 2026-01-01> <date: 2026-07-04>]
|n13
  :holidays ```date.each
    2026-01-01
    2026-07-04
    ```
|n14 :sku <acme/sku: AB-12>
|n15 :when <money: 9.99 USD>
|n16 Meet on <{date: 2026-10-01}> at the usual place.
|li \<https://example.com>
|n17 :owner @<people/jw>
|n18 :a <date: 2026-10-01> :b <date.basic: 20261001>
```

| | Raw tree (lite) | Logical (std reader) | Verdict |
|---|---|---|---|
| N1 | `:on ⟨date: ‹2026-10-01›⟩` | date 2026-10-01 | renders |
| N2 | `⟨instant: ‹2026-01-10T14:30Z›⟩`, `⟨datetime: ‹2026-01-10T07:30-07:00[America/Denver]›⟩` | instant; zoned date-time (same instant, zone kept) | renders; the zone is RFC 9557's own spelling |
| N3 | `⟨time: ‹09:00›⟩`, `⟨datetime: ‹2026[America/Los_Angeles]›⟩` | time 09:00:00; year-precision zoned (std's extension) | renders; `PDT` is refused with a suggestion (§5) |
| N4 | `⟨date.YY-MM-DD: ‹27-03-05›⟩` | date 2027-03-05, notation std/date with param YY-MM-DD | renders, with the parameter where Joseph put it (on the notation), spelled as a trait |
| N5 | three `duration` values | PT30S; P1Y2M; PT5M | renders; `5m` is minutes because the notation is `duration` |
| N6 | `⟨interval: ‹2026-01/2026-06›⟩` | interval of two month-precision dates | renders in ISO's own spelling; no nested marks needed |
| N7 | five values | CSS length; 5 metre; 1.5 GiB; 50 %; 37.5 °C | renders; `1.5 GB` in `qty` is the bel error (§5) |
| N8 | `⟨money: ‹9.99 USD›⟩` | 9.99 USD, exact | renders |
| N9 | `⟨i64: ‹0x73DDF›⟩`, `⟨rust:i64: ‹0x73DDF›⟩` | integer 474591 in i64's range; the second is unread unless a `rust` vocabulary defines `rust:i64` | renders; the domain-range spelling is the recommended one (A5) |
| N10 | `⟨port: ‹ssh›⟩`, `⟨port: ‹22›⟩` | the net/service `ssh`; the u16 22 | renders through the union (§4); in a declared slot no mark is needed |
| N11 | four values, the regex body verbatim `\d+-\w+` | I-Regexp; URI; UUID; 5 bytes | renders; **the regex is written in its own spelling**, which the current escape lean forbids |
| N12 | a fence: `⟨sql: ‹SELECT id FROM t⏎WHERE day = '2026-10-01'›⟩` form fence, as `query`'s value | a `sql` value if a `sql` notation is in scope, otherwise text | renders; a fence as an attribute's value is the existing rule (checked: [[rule:fence-anywhere-structure]] notes) |
| N13 | a list of two notation values; or a fence `date.each` | a list of two dates, either way | renders; `.each` (a standard trait: one value per body line) is new and is this design's answer to repeated heads. Tried inline with whitespace separation, and dropped, because `money`'s bodies contain spaces |
| N14 | `⟨acme/sku: ‹AB-12›⟩` | unread{acme/sku, AB-12}; a strict read raises "no notation `acme/sku` in scope" | renders losslessly; meaning arrives when a vocabulary does, and the raw tree never changes |
| N15 | `⟨money: ‹9.99 USD›⟩` | read fine, then fails the slot check: "slot `when` expects a date; this is money" | caught at read time, with its span |
| N16 | text pieces `‹Meet on ›`, `⟨date: ‹2026-10-01›⟩` (embed), `‹ at the usual place.›`; the list item is `$main ‹<https://example.com>›` | a text with a date piece; the list item's text | renders. Unescaped, `|li <https://example.com>` is **an error, not a silent notation** (no space after the colon). With the space rule, the M2 collision is gone |
| N17 | `:owner ⟨ref: ‹people/jw›⟩` (written `@<people/jw>`) | a reference value, never resolved; compare `@{people/jw}` in text, which renders the referent | renders; the embedded value is `<{…}>`, as in N16 |
| N18 | `⟨date: ‹2026-10-01›⟩`, `⟨date.basic: ‹20261001›⟩` | both the date 2026-10-01 | as written: byte for byte. Canonical: `b` becomes `<date: 2026-10-01>` |

## 8. Vetoes and scores

- **B1 bounded streaming: pass.** The kind is known at `<` plus a label: "notation or keyword" at the first letter, and settled at the label's end. The body streams verbatim. Matched-bracket depth is a counter. The label's length is bounded as every name is.
- **B2 reserve, don't ignore: pass, by definition rather than reservation.** Lite defines notation values *now*, with a raw tree that the law in §3 fixes for every later UDON. What stays reserved: a head with no separator (`<date>`, `<date:x>`), `<` followed by any other punctuation, and `<{` in a value position.

| Factor (weight) | Score | Basis | Conf. |
|---|---|---|---|
| A1 agent-subjective (9) | 8 | `<date: 2026-10-01>` reads as what it is; one concept spelled two ways by length is beautiful to me | low |
| A2 generative guessability (10) | 7 | after one example, an agent writes `<duration: 30s>` and `<money: 9.99 USD>` unprompted (instinct). Misses: dropping the space (an error that teaches), and `qty` with `m` meaning minutes (caught only with a slot) | medium |
| A3 cold comprehension (10) | 9 | the name says what the body is in the domain's word; cold readers get it | medium |
| A4 agentic readability (10) | 8 | one bracket shape for every kind of literal; fences unchanged | medium |
| A5 domain-forward (9) | 7 | the notation name is a domain word (date, money, duration), not plumbing. Each marked value pays one word, which slots remove (§4) | medium |
| A6 spec clarity (9) | 8 | one concept, the notation value, unifying `<…>` and fences; the reader model is a companion | medium |
| A7 syntactic simplicity (8) | 8 | one head rule shared with element names and traits; no escape set in bodies | medium |
| A8 parsimony (8) | 9 | no new characters; `<` gains one role (named) next to its primitive one, separated by the head | medium |
| A9 conciseness (6) | 6 | `<date: …>` costs 8 characters per value without a slot | high |
| B3 stability (10) | 9 | one raw tree; reading never changes it | high |
| B4 errors that teach (8) | 9 | the separator, URL, bel, PDT, slot-mismatch and unmatched-bracket errors each name the fix | medium |
| B5 parse speed (9) | 9 | lite never reads bodies | high |
| B6 headroom (7) | 6 | spends `<label: ` and `<{` and `@<`, shapes full UDON's dialects would want anyway; leaves `<` + other punctuation, `<label>` without a separator, and the inline head's keys and attributes | medium |
| C2 XML/HTML (10) | 8 | tags and autolinks at a value start are errors, not silent | medium |
| C3 Markdown (9) | 8 | `<{` is a new prose embed (escaped `\<{`) | low |
| C4 types, notations, units (8) | 9 | every item in N1–N18 renders, units with a dictionary that disambiguates `5m` | medium |
| C5 schemas, slot types (8) | 8 | slot override and check, and unions as notations | medium |
| C6 extensibility (8) | 9 | namespaces, vocabularies as documents, fences and inline as one handler concept | medium |
| C8 other languages (8) | 9 | verbatim bodies make inline other-language values exact, as fences are | high |
| C10 round trip (7) | 9 | as written by default; canonical drops params only by resolving them | high |

## 9. What it changes in the store (proposals; no card edited)

| Card | Change |
|---|---|
| [[rule:opaque-span-raw-text]] | `<…>` leaves the opaque spans: primitives (M1), plus notation values with a head and a verbatim body |
| [[rule:opaque-span-escapes]] | `<…>` bodies take **no** escapes (verbatim, matched `<>`); `@{…}` and `;{…}` keep theirs |
| [[rule:newline-in-opaque-span-is-error]] | the message names the fence form |
| [[rule:fence-opener-line]], [[rule:fence-default-handler]], [[rule:fence-exact-trait]] | the fence name is a notation name, traits are parameters, `.exact` is a standard trait, and the handler is the notation's reader |
| [[def:fence]], [[def:typed-value]], [[def:opaque-span]] | one new term, «notation-value», covering both forms; «type-label» becomes the notation name |
| [[def:embed]], [[rule:embeds-in-text]], [[rule:prose-passes-through]], [[rule:prose-escaped-embeds]] | `<{…}>` joins the embeds; `\<{` is literal |
| [[rule:reserved-spellings]] | `@<…>` moves from reserved to defined (`<ref: …>`); new reserved rows for a head without a separator |
| a new card | the law: lite carries notation values and never reads them; every UDON yields the same raw node |
| `rule:bare-typing` gap | the primitive interior (M1) |

About 15 cards, mostly provisional. The decided ones touched are the fence trio (the change is to wording, not behavior) and the reserved list.

## 10. What is lite 0.1's

**All of the grammar in §2 is lite 0.1's.** That is the inline head, the verbatim body, the fence as the same concept, `<{…}>` and `@<…>`. They are cheap to parse and fix the raw tree, which is what B2 needs. The library in §5 and the reader model are **0.1's companion**: a reader that ships `std` reads them; a reader without it still produces the same raw tree and an `unread` value. Nothing in this design waits for a later version to have a meaning. What a later version adds is more notations, which are vocabularies, not grammar.

## 11. What couldn't be made clean

- **`qty` with `m`**: UCUM's `m` is metres, and a writer who means minutes can't be caught without a slot that knows the dimension. This is the cost of using a real unit standard rather than inventing one. `duration` is the notation writers will reach for in time slots, and it reads `m` as minutes.
- **Unmatched brackets inline**: they have to move to a fence. That's honest, but an inline comparison (`<expr: a > b>`) can't be written inline at all.
- **The colon-space separator** is a spacing rule that writers can get wrong. I made sure it fails as an error, never silently. I tried `<date|…>` and `<date 2026-10-01>` (space alone) as separators: the pipe reads as a union in Joseph's algebraic names, and space alone makes `<true story>` a notation named `true`. The colon-space survived both comparisons.
