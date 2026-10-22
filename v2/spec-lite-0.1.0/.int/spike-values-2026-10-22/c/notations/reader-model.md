# The reader model: how a notation's meaning attaches

*Spike c, round two, written by the spike agent while the five spelling designs (`raw`, `args`, `std`, `slot`, `elem`) were being worked. This is the part every design needs whichever spelling wins: what a notation is, how a name finds one, and what the tree holds before and after. Where a design changes something here, its page says so. Labels: checked / guess / taste.*

## What a notation is

A **notation** is a named reader with three parts:

| Part | What it does | Example for `std/date` |
|---|---|---|
| `read(body, params) → value or error` | turns a spelling into a value of its type | `2026-10-01` → the date 2026-10-01; `2026-13-01` → error "month 13" |
| `write(value, params) → body` | the canonical spelling (C in the ideation map) | the date → `2026-10-01` |
| `type` | what the values are (T), for checking against a slot (S) | `date` |

Plus, optionally, **host bindings** (H): the type each host maps it to (Rust `chrono::NaiveDate`, JS `Temporal.PlainDate`, Python `datetime.date`). The six questions from the ideation map then each have one home: R is the spelling in the tree, N is the notation, T its type, S the slot's declared type, C its `write`, and H its host binding.

## Names, namespaces, aliases

- **A notation name is a path of labels**, `std/date` or `acme/sku`, written with `/` (Joseph's `<namespaced/type: val>`, 2026-07-21). Taste: `/` because the names are addresses. A notation name *refers* to a definition the way `@{people/jw}` refers to a person, so resolution can follow the address theory's own rules for references and scopes instead of inventing a second scheme. This is a guess about fit; I haven't read `~/src/address-theory` for this round.
- **Short names resolve through scope.** `date` is looked up in the vocabularies in scope, in order, then in `std`. A qualified name (`acme/sku`) needs its first segment bound in scope.
- **An alias is a notation defined as another** (`port` → `u16 | standard-port`). Joseph's algebraic names are unions of notations and enumerations, and are aliases too. They are defined in **vocabularies**.
- **A vocabulary is a lite document of definitions**: data, not directives. Lite needs nothing new to carry one, because a vocabulary is just a tree a reader knows how to read. One shape it could take (illustrative, not a proposal for lite's grammar):

  ```udon
  |vocabulary[net]
    |union[port]
      |notation std/u16
      |enum[standard-port] smtp ssh http https
    |alias[when] std/instant
  ```

## How a document comes under a vocabulary

Lite has no directives, so the possibilities are things lite already has.

1. **The file name** (the `name.schema.ud` convention Joseph cited, 2026-10-22). Known before the first byte, so kind-first.
2. **Root attributes.** Top-level attribute lines belong to the root ([[rule:top-level-attributes]]). A reader convention can read, say, `:vocabulary net` written before the first child as the document's scope. That is still data, and it is kind-first when written at the top. A reader meeting it later has to treat it as applying from there on, or as an error.
3. **The reader's own configuration** (an application that knows its documents).

Scope is inherited down the tree. My lean: all three, with the most specific winning (reader configuration < file name < root attribute). Lite's spec says nothing about any of them; they belong to the reader layer's companion.

## Before and after: what the tree holds

**Raw tree (lite's):** a notation value is a node holding the name as written, the body as written, its form (angle, fence, slot-declared, …) and its span. Nothing is read. This is the tree fixtures show.

**Logical tree (a reader's, Joseph's "full-ast → logical-ast"):** the same position holds a **read value**: `{type, value, notation (resolved name), spelling, form}`. The spelling and form are kept, so emitting as written is always possible. Emitting canonically calls `write`. **The raw tree never changes when a reader learns a notation.** That is the condition under which carrying a named body passes the B2 veto (the mark fork's finding): a reader that knows `acme/sku` and one that doesn't produce the same raw tree and different logical ones.

**Unknown notations** read to `unread{name, body}` in the logical tree. A strict typed getter raises "no reader for `acme/sku` in scope; known: …". A lenient one hands back the body as text. Nothing is lost, and nothing is guessed.

## Slot and literal together

- A **slot type** (from a vocabulary, a schema, or the document) is a **constraint plus a default notation for bare values**. The `port` slot reads bare `ssh` and `22` through its union.
- A **literal's notation** is the **reading**: it overrides the slot's default notation for that one value.
- After reading, the value's type is **checked against the slot's type**. A literal `<instant: 2026-01-10T14:30Z>` in a `date` slot reads as an instant, then fails the check: "slot `when` expects std/date; this is std/instant. Did you mean `<date: 2026-01-10>`?" Coercions happen only where the slot's type declares them (an instant → date coercion would have to say which zone).

## Errors: whose and when

- **Lite's** (parse time): only shape. Unclosed delimiters, a malformed name, reserved interiors.
- **The reader's** (read time): bad bodies (`2026-13-01`), unknown notations under a strict reader, slot mismatches. They carry the raw tree's spans, so they point at the source as precisely as lite's errors do. Every one should say what was probably meant ([[rule:anomalies-suggest-a-fix]]).
- The exception is a design in which lite itself knows some notations (`std`). There, those bodies are checked at parse time.

## A standard library (the notations `std` would ship, as meanings)

| Name | Reads | Canonical | Type | Notes |
|---|---|---|---|---|
| `std/date` | RFC 3339 `full-date` `2026-10-01`; also `2026-10`, `2026` as partial dates | `2026-10-01` | calendar date (partial allowed) | no time, no zone |
| `std/time` | `09:00`, `09:00:30.5` | `09:00:00` | wall time | no zone; `24:00` per RFC 3339? decide |
| `std/instant` | RFC 3339 `date-time` with `Z` or an offset | as written, or normalized to `Z` | a point on the UTC line | |
| `std/zoned` | RFC 9557: an instant plus `[Area/City]`, `!` critical | as written | zoned date-time | Joseph's `2026 PDT` is a *partial* zoned date: `std/zoned` with a year and an abbreviation, which RFC 9557 doesn't allow. It needs its own reading (abbreviations are ambiguous: PDT is also used outside the US) |
| `std/duration` | ISO 8601 `P1Y2M`, `PT30S`; and shorthand `30s`, `5m` (minutes), `1mo`, `2h` | ISO form | duration | inside `std/duration`, `m` is always minutes |
| `std/qty` | UCUM: `5 m`, `5 min`, `1.5 GiBy`, `50 %`, `37.5 Cel` | number, space, UCUM code | quantity | `m` is metres; units are the UCUM codes (checked: `Cel` for °C). UCUM defines only the unit term; the number-space-unit pairing is this notation's own convention |
| `css/length` | `920px`, `2em`, `50%` | as written | CSS length | outside UCUM (no `px` in the part of UCUM checked) |
| `std/money` | `9.99 USD` (ISO 4217 code) | `9.99 USD` | decimal amount + currency | the decimal is exact; the host binding says how |
| `std/re` | a regex body | as written | regex | flavour named by a parameter |
| `std/url`, `std/uuid`, `std/b64`, `std/hex` | the usual | lowercase/normalized | | |
| `std/u8`…`std/u64`, `std/i8`…`std/i64` | the standard numeric notation, range-checked | decimal | bounded integer | what `u16` in `port` means; a storage name kept as a *domain range*, as the ideation file's lean on H asked |

## Parameters

A notation may take parameters, which are part of the notation, not the body: `date` with format `YY-MM-DD`, and `re` with flavour `pcre`. They show up in every spelling design (in the name, after it, as arguments, or on the slot), and the reader model only needs them to reach `read`. **A parameter can change meaning** (`YY` fixes a century), so it has to be part of what the logical tree records as the value's notation, so that canonical re-emission can say it.
