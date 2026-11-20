# N-std: lite knows a small standard set of notations inside `<…>`

*Spike c, round two, the `std` design fork (Opus 5.5, 2026-10-22). Developed to its strongest form; the places where it still costs something are named, not hidden. Labels: **checked** (run or read, with the place), **instinct** (what I'd write or expect, as a target writer and reader), **guess**, **taste**. Scores are hypotheses. The reader model shared by all five designs is `../reader-model.md`; this page says where N-std departs from it. Executable model: `discriminate.py` (output in `discriminate.out.txt`).*

## The design in one paragraph

Inside an unlabeled `<…>`, lite recognizes a **closed standard set** by spelling. The set is the portable primitives (nil, booleans, numbers, delimited strings), **RFC 3339 dates and times** with the RFC 9557 zone suffix, **ISO 8601 durations and intervals**, **quantities** (a number, a space, and a UCUM unit code or an ISO 4217 currency), and **URIs and email addresses in exactly CommonMark's autolink shapes**. Each is validated at parse time (month 13 is an error) and held in the raw tree as **kind plus spelling, never converted**. Everything else is written **named**: `<name: body>`, with the body carried raw and read by a notation above the tree. Every unlabeled interior outside the set is an error that says what was probably meant, so the set can only grow into what lite refuses today. A standard-set value is, in the logical layer, the same value as its named long form (`<2026-10-01>` ≡ `<std/date: 2026-10-01>`). The set is a built-in abbreviation for `std`, not a second meaning system.

**The proposal is N-std★** ("Made beautiful", below). It is the same set spelled the way a typesetter writes it: `<5 m>`, `<37.5 °C>`, `<1 h 30 min>`, `<09:00–17:00>`, `<9.81 ± 0.02 m/s²>`, `<€9.99>`, `<2026-01-10 14:30 America/Denver>`, and tagged strings `<re'\d+'>` for named notations. The ISO spellings are accepted on read. The sections in between describe the plain set it builds on.

## Why it is worth designing at full strength (the case for)

- **The common notations need no name, and are checked where they're written.** `:when <2026-10-01>`, `:timeout <PT30S>`, `:dose <5 mg>`, `:home <https://example.com>`. A typo is a parse error with a fix, at the line where it happened, in every parser (B4, B3). Under a raw-body design the same typo surfaces only in a reader that knows `date`, possibly never.
- **Every member's spelling is an existing standard that agents already write** (instinct): RFC 3339 dates are what I'd write in any data file, ISO durations are what I'd emit for a timeout in a JSON API, and UCUM codes are what a clinical or scientific system expects. Nothing in the set is UDON-invented except the space between a number and its unit (checked by the spike agent: UCUM defines unit terms only, "White space is not recognized in a unit term", and says nothing about pairing a number with a unit; `number SPACE unit` is our convention).
- **The Markdown autolink stops being a collision and becomes a value.** `|li <https://example.com>` is an error under M1 and a silent wrong notation under M2. Here it is a URI, which is exactly what Markdown means by it. Re-emitted as written (spelling and form are kept), it is the same autolink (C3).

## The set and its grammar

Interiors are matched **whole** (after trimming the ornamental spaces just inside the brackets). Nothing is a prefix match, so nothing splits a value in two (the old line's `30seconds` defect can't happen).

| Kind (subkind) | Spelling | Source of the spelling | Checked at parse time |
|---|---|---|---|
| `nil` | `<>`, `<nil>` | Joseph's lean, 2026-10-22 | — |
| `bool` | `<true>`, `<false>` | core fork | — |
| `number` (int, float) | the standard numeric notation of `../../branches/core/spelling.md` (strict: no leading zeros, `_` between digits, `0x`/`0o`/`0b`) | core fork | shape |
| `string` | `<"…">`, `<'…'>` | delimited-string rules | as today |
| `date` | `YYYY-MM-DD` | RFC 3339 `full-date` | month 01–12; day valid for the month, leap years included |
| `date` (year-month) | `YYYY-MM` | ISO 8601 reduced precision | month |
| `time` (local) | `HH:MM`, `HH:MM:SS`, `HH:MM:SS.f` (1–9 fraction digits) | RFC 3339 `partial-time` | hour 00–23, minute 00–59, second 00–60 (leap second, RFC 3339) |
| `datetime` (local) | `DATE` `T` `TIME` | RFC 3339 without offset | as above |
| `datetime` (offset): an instant | `DATE` `T` `TIME` (`Z` \| `±HH:MM`) | RFC 3339 `date-time` | offset hours 00–23, minutes 00–59 |
| `datetime` (zoned) | an offset datetime + `[Area/City]`, optional `!` inside the bracket | RFC 9557 (one zone tag only) | the zone name's **shape** only; whether it exists is the reader's (tzdb changes) |
| `duration` | ISO 8601 `P…` in RFC 3339 Appendix A's form: `PnYnMnDTnHnMnS` in order, or `PnW` alone; fraction only on seconds; optional leading `-` | RFC 3339 App. A | order, non-empty, `T` not trailing |
| `interval` | `start/end`, `start/duration`, `duration/end`; start and end are any date or datetime kind above | ISO 8601 | each side as its kind; not duration/duration |
| `quantity` | `NUMBER` `SPACE` `UNIT`; `UNIT` is a UCUM case-sensitive unit term | UCUM for the unit; the pairing is ours | the unit's **shape** (UCUM term syntax); the atom table is the reader's (below) |
| `quantity` (money) | `NUMBER` `SPACE` `[A-Z]{3}` (other than `RAD` and `REM`) | ISO 4217 code | shape; whether the code exists is the reader's |
| `uri` | `scheme://…`, no spaces, `<` or `>` inside | RFC 3986 scheme; CommonMark autolink | shape |
| `email` | `local@domain` in CommonMark's email-autolink shape | CommonMark 0.31.2 §6.5 | shape |
| **named** | `NAME` (`/` `NAME`)* [ `(` params `)` ] `:` body | Joseph's `<namespaced/type: val>`, `dt(YY-MM-DD)` | the name's shape; the body is raw (the reader's) |

**What I left out, and why.** Each of these is reachable through the named form:

| Left out | Why |
|---|---|
| UUID | no host has a native type beyond a validated string, and its hex-first spelling collides with dates and numbers in the first character. `<uuid: …>` |
| bytes / base64 / hex | `<b64: …>` |
| regex | its flavour is a parameter, so it fails "parameter-free" |
| CSS lengths | `px` isn't a UCUM unit (checked, UCUM 2.2 essence, below), and CSS's `%` and `em` are relative units that need a containing block: `<css: 920px>` |
| two-digit years, week dates (`2026-W05`), ordinal dates (`2026-274`) | errors now, so they're the room the set can grow into |
| ISO basic format (`20261001`) | it is a number: `<20261001>` is the integer 20261001 |
| zone abbreviations (`PDT`) | ambiguous; the error says so |

**UCUM facts this rests on** (checked: UCUM 2.2 `ucum-essence.xml`, revision date 2024-06-17, fetched 2026-10-22):

- There is no `px`. Degrees Celsius is `Cel`; `By` is byte; `GiBy` is gibibyte (UCUM marks the binary prefixes as proposed).
- The only case-sensitive UCUM terms spelled with exactly three upper-case letters are `RAD` and `REM`, whether as a bare atom or as a prefix plus a metric atom. Hence the money exception.

**Why the unit atom is the reader's.** UCUM is versioned (2.2 now). If lite validated atoms, a document with an atom added in UCUM 2.3 would be an error in one parser and fine in another (B3). So lite checks the unit term's shape and holds the spelling; the reader checks it against UCUM. `<920 px>` therefore parses, as quantity(920, `px`), and fails at read time: "`px` is not a UCUM unit; for a CSS length write `<css: 920px>`".

## How an interior is told apart: decided within a few characters (B1)

From the model (`discriminate.out.txt`, which reports where each case's kind became certain):

- **Most classes are fixed within 5 characters.** Number at the 1st, duration at the 2nd, time at the 3rd, the date family at the 5th.
- **Two refinements come later, each at a bounded point.** A quantity is a number until the space that ends it, where its unit is known: the 6th character in `<37.5 Cel>`, or later for a long number. An interval is a date until its `/`: the 8th character in `<2026-01/2026-06>`, the 17th in `<2026-01-10T14:30/PT1H>`.
- **Named notations are fixed at the end of their name**, which is capped at 64 characters.

A wire that emits the number (or the start date) as soon as it is known, and the unit (or the `/` and the end) after it, holds no more than the class prefix.

| First character(s) | Class |
|---|---|
| `>` | nil |
| `"` `'` | string |
| `P` + digit or `T`; `-P` | duration |
| digit or sign | the first non-digit after the leading digit run decides: `-` after exactly four digits → the date family (date, year-month, datetime, interval); `:` after exactly two → time; end, `.`, `e`, `_`, `x`/`o`/`b` after `0` → number; a space after a complete number → quantity; anything else → error |
| letter | read the label: `>` → `true`/`false`/`nil` or an error; `://` → URI; `@` → email; `/`, `(` or `:` → named |
| anything else | error |

Within a class, the *exact* kind can come later. Date vs datetime is decided at the `T`. Interval is decided at the `/` after a complete start, which has bounded length: the fraction is capped at 9 digits and the zone name at 64, so the worst case is about 100 characters. A kind-first wire can emit the class at once and the refinements as they arrive (`Temporal`, then `date`, then `/`, then the end). Read either way (memory held, or characters until the class is known), **B1 passes**. One reservation this costs: a notation name can't be `P` followed by a digit or `T` (`<P2: …>` is read as a duration and errors), so it's listed among the reserved name shapes.

## What the trees hold

**Raw tree (lite's, the one fixtures show):** a standard-set value is a scalar with **kind, subkind and spelling** (classify, never convert). Its structured kinds keep their parts:

```udon
|e :when <2026-10-01> :at <2026-01-10T14:30Z[America/Denver]> :dose <5 mg> :price <9.99 USD>
   :span <2026-01/2026-06> :ref <acme/sku: AB-12>
```
````tree
root
  |e
    :when  2026-10-01::date.angle
    :at    2026-01-10T14:30Z[America/Denver]::datetime.zoned.angle
    :dose  qty(5::number, ‹mg›::unit).angle
    :price qty(9.99::number, ‹USD›::currency).angle
    :span  interval(2026-01::date.ym, 2026-06::date.ym).angle
    :ref   named(acme/sku, ‹AB-12›).angle
````

**Logical tree (a reader's):** each standard-set value becomes the same read value as its named long form, `{type: std/date, value: 2026-10-01, spelling: "2026-10-01", form: angle}`, through the host binding (table below). `named(acme/sku, …)` reads through `acme/sku` if that notation is in scope. Otherwise it reads to `unread{acme/sku, "AB-12"}` (reader model). **The raw tree never changes when a reader learns a notation.**

**Equivalence.** `<2026-10-01>` and `<std/date: 2026-10-01>` differ in the raw tree (kind `date` vs `named`) and are equal in the logical tree. Their forms differ, so each round-trips as written.

## How the set grows without changing trees (B2)

Two paths, both safe:

1. **Into today's errors.** The unlabeled interior space is partitioned into the set and errors; nothing is carried raw unlabeled. A later version may give a meaning only to an interior that 0.1 rejects, such as `<2026-W05>`, `<2026-274>`, `<R5/2026-01-01/P1D>` (ISO recurrence), `<5m>` (if that ever became a shorthand), or a bare symbol `<ssh>` (a Ruby-style symbol kind). Every document lite accepted keeps its tree.
2. **Through names.** A named notation is carried raw and read above the tree, under the law the mark fork found: in every UDON, a notation reads above the tree and never changes the raw tree. A new notation (`<geo: 40.7,-74.0>`) needs no change to lite.

One structural rule keeps both paths safe: no interior may carry structure (nodes). `<{…}>` is the value embed (below), and in it the inside is again one standard-set interior, never a node.

## Naming, namespacing, parameters, nesting

- **A name is a path of labels joined by `/`:** `std/date`, `acme/sku`, `rust/i64`. Short names resolve through scope (reader model). `std/…` names are always in scope.
- **Parameters go in one parenthesized group after the name**, held raw and given to the notation: `<date(YY-MM-DD): 27-03-05>`, which is Joseph's own `dt(YY-MM-DD)`. A parameter is part of the value's notation in the logical tree, so canonical re-emission keeps it (`YY` fixes a century).
- **The colon is the name's end; spaces after it are ornament.** `<date:2026-10-01>` and `<date: 2026-10-01>` are the same, and both are named. A URI needs `://` (checked against the model), so the two never meet. **Cost, named:** `<mailto:jw@example.com>`, `<urn:isbn:…>` and `<tel:+1…>` are *named* notations (`mailto`, `urn`, `tel`), not the `uri` kind. `std` defines those three names as URI notations, so a reader gets a URI either way. The raw tree, though, says `named` for them and `uri` for `https://…`.
- **Nesting.** Standard-set kinds nest only where the grammar says so (an interval's ends). A named body is raw, so nesting there is the notation's business: `<geo/path: <geo: 1,2> <geo: 3,4>>` carries the body `<geo: 1,2> <geo: 3,4>` (matched brackets need no escape), and `geo/path` reads it.
- **Host-specific notations are names in a host namespace:** `<rust/i64: 0x73DDF>`. Scored low on A5 (plumbing), but possible. The better spelling of N9 is `<0x73DDF>`, with the storage type in the slot (`std/i64`), which keeps H out of the document.

## Block form, lists, bodies, prose

- **Multi-line values are fences.** The fence's name is the notation name. A fence's body is never scanned, so it is the block-form counterpart of a named body (C8). An attribute takes a fence on the lines below as its value; the PEG review found that missing.
- **Lists and attribute bodies** hold standard-set values item by item: `:dates [<2026-01-01> <2026-07-04>]`. A slot-side declaration that types a whole body is the `slot` design's. N-std composes with it (below).
- **In prose, `<{…}>` is the value embed.** Every embed is `X{…}` (`|{`, `@{`, `;{`, and the reserved `!{`), so `<{` opens a piece of the text holding one value: `Meet on <{2026-10-01}>.` gives the pieces `‹Meet on ›`, `2026-10-01::date`, `‹.›`. It is Joseph's "embedded value", given a meaning. Plain `<…>` in prose stays Markdown, as today. The inside of `<{…}>` is a standard-set interior or a named one; never structure.
- **`@<path>` is a reference in value position:** "the value at this address", which a reader may resolve or keep. `@{path}` stays the reference as a piece of text. Lite resolves neither. The form records which was written, and "kept, not resolved" is the reader's choice for `@<…>` (it's an `@` reference spelled with the value mark).

## Slot and literal together (composes with the `slot` design)

- A bare value in a slot that declares a notation is read by that notation: `:when 2026-10-01` in a `std/date` slot gives the date. N-std changes nothing about bare values.
- A literal carries its own kind. In a slot of a different type it's a reader error with a suggestion (N15).
- **The algebraic name** `port = u16 | standard-port` is a vocabulary's (reader model). N-std's contribution is only that `<22>` is a checked number. `ssh` stays text for the union to read.

## Host mapping (a companion, not the spec)

| Kind | Rust | JS | Python | Ruby | No native type |
|---|---|---|---|---|---|
| date | `chrono::NaiveDate` | `Temporal.PlainDate` | `datetime.date` | `Date` | — |
| year-month | a struct | `Temporal.PlainYearMonth` | `(year, month)` | — | a record |
| time | `NaiveTime` | `Temporal.PlainTime` | `datetime.time` | — | — |
| datetime local / offset / zoned | `NaiveDateTime` / `DateTime<FixedOffset>` / `chrono_tz` | `PlainDateTime` / `Instant` (+ offset kept) / `ZonedDateTime` | `datetime` (naive / aware / `zoneinfo`) | `Time` / `DateTime` | — |
| duration | a components struct (ISO months aren't fixed lengths) | `Temporal.Duration` | components (no calendar duration in stdlib) | `ActiveSupport::Duration` or components | a record of components |
| interval | `(start, end-or-duration)` | same | same | `Range` when both ends are points | — |
| quantity | `(Decimal or f64, unit string)` | `{value, unit}` | `pint` if present, else a tuple | `{value, unit}` | value + unit, spelling kept |
| money | `(Decimal, currency)` | `{amount: string, currency}` (keep exact) | `(Decimal, str)` | `BigDecimal` + code | never a binary float |
| uri / email | `url::Url` / string | `URL` / string | `str` | `URI` / string | string |

*From memory of these libraries, not re-checked today; the `Temporal` names are the TC39 proposal's.* The guide's rule of thumb: the spelling is always available, and a host converts only into a type that loses nothing the spelling says.

## Errors that teach (checked: model output)

| Written | Error |
|---|---|
| `<2026-13-01>` | month 13 is out of range (01–12) |
| `<2026-02-29>` | day 29 is not in 2026-02 (2024-02-29 is accepted) |
| `<2026-1-5>` | dates are zero-padded YYYY-MM-DD: did you mean `<2026-01-05>`? |
| `<2026-01-10 14:30>` | date and time are joined with T: `<2026-01-10T14:30>` |
| `<5m>` | a quantity has a space before its unit: `<5 m>` (metres) or `<5 min>` (minutes); a duration is `<PT5M>` |
| `<50%>` | a quantity has a space before its unit: `<50 %>` |
| `<09:00 PDT>` | zone abbreviations are ambiguous: use an offset or an IANA zone with a date |
| `<9:30>` | times are zero-padded HH:MM: did you mean `<09:30>`? |
| `<27-03-05>` | a date needs a four-digit year; for a two-digit year use `<date(YY-MM-DD): …>` |
| `<P1W2D>` | not an ISO 8601 duration: components in order, or PnW alone |
| `<hello>`, `<kbd>` | `kbd` isn't a value inside `<…>`: the text `kbd` (bare), the string `<"kbd">`, or a named notation `<kbd: …>`? (To add: "if this is HTML, escape it: `\<kbd>`") |
| `<= 5>` | `=` can't start a value inside `<…>` (to add: "escape the `<` for text: `\<= 5`") |
| `<920 px>` | *(reader)* `px` is not a UCUM unit; for a CSS length, `<css: 920px>` |
| `<5 MIN>` | *(reader)* `MIN` is not an ISO 4217 currency; UCUM is case-sensitive: `<5 min>` |

## The composite set, N1–N18

```udon
|n1 :on <2026-10-01>
|n2 :at <2026-01-10T14:30Z> :at-local <2026-01-10T07:30-07:00[America/Denver]>
|n3 :opens <09:00> :era <dt: 2026 PDT>
|n4 :born <date(YY-MM-DD): 27-03-05>
|n5 :a <PT30S> :b <P1Y2M> :c <5 min>
|n6 :span <2026-01/2026-06>
|n7 :width <css: 920px> :len <5 m> :disk <1.5 GiBy> :share <50 %> :temp <37.5 Cel>
|n8 :price <9.99 USD>
|n9 :addr <0x73DDF>
|svc :port ssh
|svc :port <22>
|n11 :pat <re: \\d+-\\w+> :home <https://example.com> :id <uuid: 0f8fad5b-d9cb-469f-a165-70867728950e> :blob <b64: SGVsbG8=>
|n12 :query
  ```sql
  SELECT * FROM t
  WHERE d > '2026-01-01'
  ```
|n13 :dates [<2026-01-01> <2026-07-04>]
|n14 :sku <acme/sku: AB-12>
|n15 :when <5 min>
|p Meet on <{2026-10-01}>.
|li <https://example.com>
|n17 :ref @<people/jw> :note @{people/jw}
|n18 :on <2026-10-01> :also <20261001>
```
````tree
root
  |n1   :on 2026-10-01::date.angle
  |n2   :at 2026-01-10T14:30Z::datetime.offset.angle
        :at-local 2026-01-10T07:30-07:00[America/Denver]::datetime.zoned.angle
  |n3   :opens 09:00::time.angle
        :era named(dt, ‹2026 PDT›).angle
  |n4   :born named(date, params ‹YY-MM-DD›, ‹27-03-05›).angle
  |n5   :a PT30S::duration.angle   :b P1Y2M::duration.angle   :c qty(5, ‹min›).angle
  |n6   :span interval(2026-01::date.ym, 2026-06::date.ym).angle
  |n7   :width named(css, ‹920px›).angle   :len qty(5, ‹m›).angle   :disk qty(1.5, ‹GiBy›).angle
        :share qty(50, ‹%›).angle   :temp qty(37.5, ‹Cel›).angle
  |n8   :price qty(9.99, ‹USD›::currency).angle
  |n9   :addr 0x73DDF::number.int.angle
  |svc  :port ‹ssh›
  |svc  :port 22::number.int.angle
  |n11  :pat named(re, ‹\d+-\w+›).angle   :home https://example.com::uri.angle
        :id named(uuid, ‹0f8f…950e›).angle   :blob named(b64, ‹SGVsbG8=›).angle
  |n12  :query fence(sql, ‹SELECT * FROM t⏎WHERE d > '2026-01-01'⏎›)
  |n13  :dates [2026-01-01::date.angle 2026-07-04::date.angle]
  |n14  :sku named(acme/sku, ‹AB-12›).angle
  |n15  :when qty(5, ‹min›).angle
  |p    :$main text[‹Meet on ›, 2026-10-01::date.embed, ‹.›]
  |li   :$main https://example.com::uri.angle
  |n17  :ref ref(people/jw).angle   :note text[ref(people/jw).embed]
  |n18  :on 2026-10-01::date.angle   :also 20261001::number.int.angle
````

| Item | Verdict, and the honest note |
|---|---|
| N1 | renders, validated at parse time |
| N2 | renders; the zone is kept, and its existence is checked by the reader |
| N3 | `09:00` renders. **`2026 PDT` can't be a standard-set value:** a year alone is the integer 2026, and `PDT` is ambiguous. It renders only as the named `<dt: 2026 PDT>`, and a `dt` notation has to decide what PDT means. That is a meaning decision N-std makes on purpose: abbreviations never enter the set. |
| N4 | renders as named with a parameter; checked only by the reader |
| N5 | renders. Five minutes is `<PT5M>` (a calendar duration) or `<5 min>` (a physical quantity). These are different meanings, and N-std keeps both: a UCUM `mo` is a mean month, while ISO `P1M` is a calendar month. The companion says which to use. Bare `5m` in a slot declared `std/duration` reads as minutes (the slot design's). |
| N6 | renders, with each end typed |
| N7 | `5 m`, `1.5 GiBy`, `50 %` and `37.5 Cel` render; `920px` needs the name `css`. **Cost:** `<50 %>` with a space is unusual to my eye (instinct). Most writers will type `<50%>` and get the error. |
| N8 | renders; exact decimal through the host guide |
| N9 | `<0x73DDF>` is a checked integer; `i64` belongs in the slot (`std/i64`). `<rust/i64: 0x73DDF>` also works, as a named notation |
| N10 | `<22>` is a number and `ssh` is text; the union is the vocabulary's. **N-std adds nothing here.** |
| N11 | the URL is a standard-set value; regex, UUID and b64 are named |
| N12 | renders as a fence (block form of a named notation) |
| N13 | renders, one mark per item |
| N14 | renders; read as `unread{acme/sku, "AB-12"}` without acme in scope |
| N15 | renders in the tree; the reader errors: "slot `when` expects std/date; found a quantity, 5 min" |
| N16 | renders: the value embed in prose, and the autolink as a URI |
| N17 | renders: `@<…>` in value position, `@{…}` as a text piece |
| N18 | `<20261001>` is the integer 20261001 (ISO basic format is excluded). As written: both as written. Canonically: `2026-10-01` and `20261001`, because the second is a number. **A writer who meant a basic-format date gets a number, silently.** It is lossless (spelling kept), and a date slot reports it at read time. |

## Made beautiful: N-std★

*Added after Joseph's note to all the spikes ("For agents with all languages at their disposal-- not a single mention of "what if we used elixir-like sigils, but made more beautiful?" etc."). Everything above is the set as the standards already spell it. This section asks what a lite that **knows** dates, quantities and ranges looks like if it is spelled the way a careful typesetter writes them, and the way a scientist, a recipe or a timetable writes them. Invent first, judge after. Hard-to-type characters cost almost nothing here (A12 weighs 2), and agents read and write Unicode without effort (instinct).*

### The inventions, each with what I find beautiful in it

**1. Typeset quantities, SI's own rule.** A number, a space, a print symbol: `<5 m>`, `<20 µs>`, `<9.81 m/s²>`, `<230 V>`, `<4.7 kΩ>`, `<37.5 °C>`. The exception is the angle symbols, which attach: `<30°>`, `<12′>`, `<8″>`.

- *Rule checked:* NIST's SI guide, ch. 7: a space always separates the number from the unit symbol, except for °, ′ and ″ for plane angle; it's `30.2 °C`, not `30.2°C`. ISO 80000-1, through a secondary excerpt, puts `%` and `‰` under the same spacing rule (`10 %`).
- *Beautiful because* it's the spelling of a physics textbook. The superscript and the middle dot (`kg·m²/s²`) make a unit read as an expression, not a code.
- *Also accepted:* the UCUM code (`<5 m/s2>`, `<37.5 Cel>`) as the ASCII spelling.
- *Taste:* also accept `<50%>` attached. It's unambiguous, it's what English writers type, and SI's `<50 %>` stays the canonical form.

**2. Scientific notation that looks like science.** `<6.022 × 10²³>`, `<3 × 10⁸ m/s>`, `<1.6 × 10⁻¹⁹ C>`. The programmer's `6.022e23` stays accepted. *Beautiful because* the exponent is an exponent: a reader sees magnitude instantly, where `e23` has to be decoded.

**3. Uncertainty.** `<9.81 ± 0.02 m/s²>`, `<72 ± 3 %>`. A measurement is a value *and* how well it's known, and no data notation I know of carries that. *Beautiful because* it says what scientific data actually is. In the tree it's `qty(9.81, ± 0.02, ‹m/s²›)`.

**4. Ranges with the en dash.** `<09:00–17:00>`, `<18–24 °C>`, `<2026-10-01 – 2026-10-03>`, `<1–5>`.

- An unspaced dash goes between simple sides and a spaced one between compound sides, as Chicago and most typesetters do it.
- A shared unit is written once (`18–24 °C` is a range of two temperatures), and a shared date once (`<2026-10-01 09:00–17:00 America/Denver>` is a working day).
- *Beautiful because* it's how timetables, recipes and conference programs have always written ranges. ISO's `/` stays accepted.

**5. Durations as compound quantities.** `<1 h 30 min>`, `<2 wk 3 d>`, `<1 yr 2 mo>`. A sum of terms of one dimension, largest first.

- *Meaning decided here:* `yr`, `mo` and `wk` are **calendar** units, so `<1 yr 2 mo>` is ISO's `P1Y2M` and adds by the calendar. `h`, `min`, `s` and `d` are **elapsed** units.
- That makes the round-one distinction between a calendar duration and a physical quantity visible in the spelling, not hidden in the choice between `P…` and `<5 min>`.
- *Beautiful because* `<1 h 30 min>` is what anyone writes. ISO's `PT1H30M` stays accepted on read.

**6. Date-times typeset.** `<2026-01-10 14:30 America/Denver>`, `<2026-01-10 14:30 −07:00>`, `<2026-01-10 14:30 UTC>`.

- A space where RFC 3339 has `T`. RFC 3339 itself notes a space may be used for readability (from memory, not re-checked).
- The zone is a trailing IANA name with no brackets. `UTC` is the one name allowed in place of `Z`.
- The offset may use the true minus `−` (U+2212).
- The ISO and RFC 9557 spellings stay accepted.
- *Beautiful because* the instant reads the way a person says it, and the zone is a place, not a bracketed tag.

**7. Money with its sign, where the sign is unambiguous.** `<€9.99>`, `<£12>`, `<₹499>`, `<₩12 000>`, and `<9.99 USD>` for everything else.

- `$`, `¥` and `kr` are each shared by several currencies, so `<$9.99>` is an error: "`$` names several currencies: `<9.99 USD>`, `<9.99 CAD>`, …?"
- *Beautiful because* a price looks like a price. The ambiguity rule is the honest part, since the old line silently absorbed `$9.99` into a float.

**8. Size pairs.** `<1920 × 1080 px>`, `<210 × 297 mm>`. REBOL's `pair!`, made typographic. *Beautiful because* dimensions are written this way on every spec sheet.

**9. Tagged strings for named notations** (Python's `r"…"`/`b"…"` and JS tagged templates, inside the mark): `<re'\d+-\w+'>`, `<sql'SELECT 1'>`, `<b64'SGVsbG8='>`, `<uuid'0f8fad5b-…'>`.

- The body is a single-quoted string, so the escape rules already exist (only `\'` and `\\`), and `\d` stays `\d` with nothing doubled.
- `<name: body>` remains for bodies with no quote trouble.
- *Beautiful because* the notation name sits on the string like a sigil on a literal, which is Joseph's "elixir-like sigils, but made more beautiful". The quote both delimits and protects, so a writer never counts backslashes.

**10. Geographic points.** `<40.7128° N 74.0060° W>`. The angle rule (attached °) plus a hemisphere letter. *Beautiful because* it's how a coordinate is printed on a map.

**11. Vulgar fractions.** `<¾ cup>`, `<1½ in>`. *Beautiful because* recipes and carpentry write them this way.

### Judged (beauty first, then the rest)

| Invention | Keep? | Why |
|---|---|---|
| 1 SI quantities, print symbols | **keep** | The most beautiful single change, with no ambiguity: a space then a symbol. Normalization is needed for look-alikes: `µ` U+00B5 ≡ `μ` U+03BC, and `Ω` U+2126 ≡ U+03A9 (NFC already maps the second). The symbol table is SI plus the units accepted for use with it, plus `B`, `bit`, `px`, `pt`. Lite checks shape, the reader checks the symbol, as before. |
| 2 `× 10ⁿ` | **keep** | Decided at the `×` after a number; no collision. |
| 3 `±` | **keep** | Decided at the `±`; adds one kind field. Strangest, and it would be the one thing in lite no other data notation has (taste). |
| 4 en-dash ranges | **keep, with one guard** | Its cost is a look-alike: without highlighting, `2026-01–2026-06` mixes hyphens and an en dash (A4). The guard: compound sides take a *spaced* dash (`2026-01 – 2026-06`), and an unspaced dash between two dates is an error that teaches: "a range between dates is spaced: `<2026-01 – 2026-06>`". ISO `/` remains accepted. |
| 5 compound durations | **keep** | The calendar/elapsed split in the unit names is a real gain in meaning, not just looks. |
| 6 typeset date-times | **keep** | `T` and brackets stay accepted; the space form becomes canonical. |
| 7 currency signs | **keep, unambiguous signs only** | The error on `$` is part of the design, not a gap. |
| 8 size pairs | **keep** | Small, decided at `×` after a quantity-or-number. |
| 9 tagged strings | **keep, as the preferred named form** | It solves the regex-escaping cost the opaque-span card accepted ("Regexes … double their backslashes"). |
| 10 geo points | **drop, after trying** | Coordinates have half a dozen printed conventions (signed decimal, DMS, hemisphere first or last, comma or not), and choosing one looks arbitrary to most writers. `<geo'40.7128,-74.0060'>` names it instead. |
| 11 vulgar fractions | **drop, after trying** | Beautiful in a recipe, but the value is a rational, which has no portable host type (the core fork's test 2), and `1½` next to `1 1/2` invites two spellings. |

### The composite set, as N-std★ writes it (rows that change)

```udon
|n2 :at <2026-01-10 14:30 UTC> :at-local <2026-01-10 07:30 America/Denver>
|n5 :a <30 s> :b <1 yr 2 mo> :c <5 min> :d <1 h 30 min>
|n6 :span <2026-01 – 2026-06> :shift <2026-10-01 09:00–17:00 America/Denver>
|n7 :width <920 px> :len <5 m> :disk <1.5 GiB> :share <50 %> :temp <37.5 °C> :range <18–24 °C>
|n8 :price <€9.99> :fee <9.99 USD>
|n11 :pat <re'\d+-\w+'> :id <uuid'0f8fad5b-d9cb-469f-a165-70867728950e'>
|lab :g <9.81 ± 0.02 m/s²> :na <6.022 × 10²³> :sheet <210 × 297 mm>
```
````tree
root
  |n2   :at 2026-01-10 14:30 UTC::datetime.offset.angle
        :at-local 2026-01-10 07:30 America/Denver::datetime.zoned.angle
  |n5   :a qty(30, ‹s›)   :b dur(1 ‹yr›, 2 ‹mo›)::calendar   :c qty(5, ‹min›)   :d dur(1 ‹h›, 30 ‹min›)::elapsed
  |n6   :span range(2026-01::date.ym, 2026-06::date.ym)
        :shift range(2026-10-01 09:00, 2026-10-01 17:00, zone ‹America/Denver›)
  |n7   :width qty(920, ‹px›)   :len qty(5, ‹m›)   :disk qty(1.5, ‹GiB›)   :share qty(50, ‹%›)
        :temp qty(37.5, ‹°C›)   :range range(qty(18, ‹°C›), qty(24, ‹°C›))
  |n8   :price money(9.99, ‹EUR›, sign ‹€›)   :fee money(9.99, ‹USD›)
  |n11  :pat named(re, '\d+-\w+')   :id named(uuid, '0f8f…950e')
  |lab  :g qty(9.81, ± 0.02, ‹m/s²›)   :na 6.022 × 10²³::number.float   :sheet pair(qty(210, ‹mm›), qty(297, ‹mm›))
````
*(Every value keeps its spelling and the form `angle`; written once here instead of on each.)*

Two composite lines that mix the inventions with lite's other rules:

```udon
|event[launch].public :when <2026-10-01 09:00–17:00 America/Denver> :fee <€25> ; early-bird until <{2026-09-15}>
  Doors open at <{08:30}>; the talk runs <{45 min}> and the lab holds <{18–24 °C}>.
```
- The framed comment is still a comment, so the `<{…}>` inside it is comment text, not a value.
- The prose line holds three value embeds as pieces of its text. Re-emitted to Markdown it reads "Doors open at 08:30; the talk runs 45 min and the lab holds 18–24 °C."

```udon
|reading :sensor ab-12 :value <21.4 ± 0.1 °C> :at <2026-10-22 14:05:07 UTC> :ok <true>
```
- The bare `ab-12` stays text, and every kind is marked.
- A JSON converter emits `{"value": {"q": 21.4, "u": "°C", "pm": 0.1}, …}` through the host guide (the shape is the guide's).

### Grammar, streaming and the factors, for the additions (reasoned, not run)

- Every addition is decided at a bounded point after something already decided: `±` and `×` after a number, `–` after a complete item, `°` attached vs ` °C` spaced, a currency sign as the first character, `'` right after a notation name. **B1 passes as before.**
- **B2:** every misspelling of these forms is an error, so the error space stays the growth space.
- **A8 (parsimony) is the real cost.** `–`, `×`, `±`, `°`, `′`, `″`, superscripts, `·`, `µ`, `€` and others now have roles. All of those roles are **inside the mark**, though, each character has exactly one, and none of them means anything outside `<…>`.

| Factor (weight) | N-std | N-std★ | Why it moved |
|---|---|---|---|
| A1 agent-subjective (9) | 8 | **10** | it reads like typeset text; taste, but the most confident score on this page |
| A2 guessability (10) | 7 | 7 | gains `<1 h 30 min>`, `<50%>`, `<€9.99>`; loses on the spaced range dash. ISO spellings stay accepted, so nothing a writer guesses from ISO fails |
| A3 cold comprehension (10) | 8 | **9** | no `P1Y2M`, no brackets |
| A4 agentic readability (10) | 8 | 7 | hyphen vs en dash and hyphen vs minus look alike unhighlighted; the spaced-range guard catches the worst case |
| A6 spec clarity (9) | 5 | 4 | more forms; ISO and typeset both accepted |
| A7 simplicity (8) | 4 | 3 | the largest grammar of any design |
| A8 parsimony (8) | 8 | 6 | more characters with roles, all confined to the mark |
| B4 errors that teach (8) | 10 | 10 | `$`, the unspaced date range, `<5m>` |
| C4 types, notations, units (8) | 9 | **10** | uncertainty, ranges and calendar-vs-elapsed durations carry meaning no round-one design had |
| D2 host integration (7) | 5 | 4 | more forms per parser |

### What this changes in the 0.1 proposal

**N-std★ replaces N-std as this design's proposal for 0.1.** That's the set with inventions 1–9 kept and 10–11 dropped, the typeset spellings canonical, and the ISO, RFC and UCUM spellings accepted on read. If it had to shrink, I'd cut in this order:

1. pairs (8);
2. scientific `× 10ⁿ` (2), since `e` already serves;
3. intervals between datetimes;
4. never quantities, durations or the dash range, which are where the beauty and the meaning both are.

## Card radius (proposals; nothing edited)

- [[rule:opaque-span-raw-text]]: `<…>` leaves the opaque spans and gets its own card, "explicit values", with the grammar above.
- New cards: one per standard-set kind (date family, duration, interval, quantity, money, uri/email), each with its errors. Also the named form, the value embed `<{…}>`, and `@<…>` (today in [[rule:reserved-spellings]]).
- [[rule:reserved-spellings]]: `@<…>` leaves the list. The reserved name shapes are added (`P` followed by a digit or `T`; more than 64 characters).
- [[rule:newline-in-opaque-span-is-error]]: its error suggests a fence for multi-line notation values.
- [[obj:markdown-text-passes-through]]: autolinks in sameline text become URI values; prose is unchanged. Named as a collision turned into meaning.
- `rule:bare-typing` (gap): becomes "explicit values".
- [[def:typed-value]]: «explicit-typed-value» splits into standard-set values and named notation values.
- A host mapping guide (companion), and the `std` notation definitions (companion).

About 15 records, most of them new rather than changed. The heaviest is the new grammar itself.

## Scores (hypotheses against CTQ-FACTORS; basis inline; confidence low to medium)

| | Factor (weight) | N-std | Basis |
|---|---|---|---|
| A1 | Agent-subjective (9) | 8 | `<2026-10-01>` and `<5 mg>` read like the thing itself; taste |
| A2 | Generative guessability (10) | 7 | RFC 3339 and ISO durations are what I'd write unprompted; `<5m>` and `<50%>` will be written and caught |
| A3 | Cold comprehension (10) | 8 | dates, durations and URLs read cold; `<1.5 GiBy>` needs UCUM exposure |
| A4 | Agentic readability (10) | 8 | values look like their domain |
| A5 | Domain-forward (9) | 7 | domain spellings, but one mark per value where no slot exists |
| A6 | Spec clarity (9) | 5 | the spine now includes a temporal grammar, a quantity convention, URI and email shapes |
| A7 | Syntactic simplicity (8) | 4 | the largest grammar of the five designs; the old line's ~800 lines of value states are the scale warning (illustration, not evidence) |
| A8 | Parsimony (8) | 8 | one mark character, no new ones |
| A9 | Conciseness (6) | 8 | no names on common kinds |
| A10 | Self-description (5) | 8 | the literal says its kind |
| B1 | Bounded streaming (veto) | **pass** | most classes within 5 characters; quantity and interval refined at bounded points; exact kind within a spelled bound (about 100 characters for temporal) |
| B2 | Reserve, don't ignore (veto) | **pass** | unlabeled space is set ∪ errors; named bodies under the above-the-tree law |
| B3 | Stability (10) | 8 | validation is in every parser, so one tree; atoms and zones are deliberately left to the reader for stability across UCUM/tzdb versions |
| B4 | Errors that teach (8) | 10 | parse-time validation with fixes, at the line, in every parser |
| B5 | Parse speed (9) | 8 | single pass, constant state per class; more classification work than M1 |
| B6 | Headroom (7) | 6 | spends the unlabeled interior on a fixed set (growth only into errors) and `<{` on the value embed |
| C1 | Structured data (10) | 9 | dates and quantities typed in schema-less data |
| C2 | XML/HTML (10) | 7 | `<kbd>` at a value start is an error with an escape hint |
| C3 | Markdown (9) | 9 | autolinks become URIs that round-trip |
| C4 | Types, notations, units (8) | 9 | the common ones checked and typed; the rest named |
| C5 | Schemas and slot types (8) | 6 | composes, but literal kinds can contradict slots (N15) |
| C6 | Extensibility (8) | 7 | the named form is open; the set is closed |
| C7 | Predictable tree/API (8) | 8 | — |
| C10 | Round-trip (7) | 9 | spelling and form kept |
| D2 | Host integration (7) | 5 | every parser, a tiny one included, needs date validation with leap years, and the duration, URI and quantity shapes |

## What N-std would make lite 0.1's, and what it concedes

*(This section is about the plain set. The proposal is N-std★, above, which keeps all of this and adds the typeset spellings.)*

**For 0.1, as one design:** the primitives, the date family (date, year-month, time, local, offset and zoned datetime), durations, quantities with money, URIs and emails, the named form, the value embed, and `@<…>`. Intervals are the one member I'd cut if the grammar had to shrink. They are the only kind that nests, and they're rarer than the rest (instinct).

**Conceded, after trying:**

- Units aren't fully checked at parse time. They can't be without lite tracking UCUM's versions, which would cost B3, so the atom check stays with the reader.
- `<50 %>` and `<5 m>` need a space no one types by reflex. The no-space form was tried: `5m` collides with exponents (`1e3`), and `5mo` vs `5m` is a prefix-match hazard. The space is what makes the unit boundary unambiguous.
- `mailto:`, `urn:` and `tel:` are named, not `uri`, in the raw tree.
- ISO basic-format dates read as numbers.

**The largest cost** is A6 and A7. N-std puts a standard library inside the language. Its defense is B4, C3 and C4: these are the notations every writer meets, and the ones that most deserve errors at the line where they're written.
