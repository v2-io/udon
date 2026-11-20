# Round two: designing notation values

*Spike c, opened 2026-10-22 after Joseph read the three spikes. His words, relayed by the coordinator: "These spikes were for designing meaning. A conclusion of "now if it's well designed, but a 'no' until it gets designed" is our premise when we started restated to ourselves by the spike agent whose job it was do actually consider all of the designs and propose them in a weighted way." Round one landed `<name:body>` (M2) and units inside a named notation (U3) on "later". That was the premise restated, not a design. This round designs them. "Defer" and "reserve for now" are not designs here. If one design is lite 0.1's and others are later, the round says which and why, with the meaning still on the table.*

## What a notation design has to answer

1. **Spelling**: of a notation value inline, on several lines, in a list, in an attribute body, and in prose if at all.
2. **The raw tree**: what lite's tree holds before any reader has attached meaning.
3. **How a reader attaches meaning**: where notations are defined; how a name resolves (registry, namespaces, aliases, what's in scope and how a document gets one); what an unknown notation does; when errors fire, and whose.
4. **The tree after**: what the logical layer holds once a notation has read the value. What is kept (spelling, notation, form) for round trip, and what canonical re-emission looks like.
5. **Naming, namespacing, nesting**: notation names, namespaces, parameters (`YY-MM-DD`), a notation value inside another (an interval of two dates), host-specific notations (`rust:i64`).
6. **Dates and units**: the specific notations a standard library would ship, with exact spellings, and how `5m` is resolved.
7. **Slot and literal together**: a slot that declares a notation, a literal that names one, and what happens when they disagree. Joseph's algebraic names (`port = u16 | standard-port`) and aliases.
8. **Joseph's future forms**: `@<…>` (reference to a value, kept), `<{…}>` (embedded value).
9. **The factors**: vetoes B1 (bounded streaming) and B2 (reserve, don't ignore), then CTQ scores with basis and confidence, and the card radius.

## Facts checked for this round (2026-10-22)

- **UCUM** (ucum.org/ucum): its case-sensitive codes include `m` metre, `min` minute, `mo` month, `a` year (Julian), `h` hour, `s` second, `d` day, `wk` week, `%` percent and `By` byte. It also has binary prefixes `Ki`, `Mi`, `Gi` and `Ti`, which its Table 23 marks as "proposed … not yet standardized". UCUM has a case-insensitive variant of every symbol. Degree Celsius is `Cel`. **UCUM defines unit terms only:** "White space is not recognized in a unit term", and it doesn't say how a number and its unit are written together. So `5 m` (number, space, code) is our convention, not UCUM's. **There is no pixel/`px` in the two-thirds of the page that was read; the last third wasn't checked.** So within UCUM, `5 m` is metres and `5 min` minutes, unambiguously. A CSS length needs a different notation.
- **RFC 9557** (April 2024, IXDTF): adds a bracketed suffix to RFC 3339 timestamps, `2022-07-08T00:14:07+01:00[Europe/Paris]`. A `!` inside the brackets marks the tag critical: the recipient "MUST NOT act on the IXDTF string unless it can process the suffix tag".

## The notation composite set (intents; every design renders these)

- **N1** a calendar date, 2026-10-01.
- **N2** an instant, 2026-01-10T14:30Z, and the same instant with the zone America/Denver kept.
- **N3** a local time 09:00, and Joseph's `<dt: 2026 PDT>` (a year in a zone).
- **N4** a date in a domain format, `27-03-05`, meaning YY-MM-DD (so 2027-03-05).
- **N5** durations: 30 seconds; P1Y2M; five minutes written `5m`.
- **N6** an interval from 2026-01 to 2026-06.
- **N7** quantities: 920px (CSS), 5 metres, 1.5 GiB, 50%, 37.5 °C.
- **N8** money: 9.99 USD.
- **N9** a host storage hint: Rust `i64`, written `0x73DDF`.
- **N10** the algebraic name: `port` = u16 | {smtp, ssh, http, …}, with values `ssh` and `22`; `port` as an alias.
- **N11** a regex `\d+-\w+`; a URL kept as a URL; a UUID; some bytes in base64.
- **N12** a multi-line value in another notation: a SQL query.
- **N13** a list of dates; the same dates as an attribute body.
- **N14** an unknown notation, `acme`'s SKU `AB-12`, read by a reader that doesn't know `acme`.
- **N15** a slot declared as a date, holding a literal that names a different notation.
- **N16** in prose: "Meet on 2026-10-01", with the date marked as a date; and a list item whose text is `<https://example.com>`.
- **N17** a reference kept as a reference; an embedded value.
- **N18** round trip: the date written `2026-10-01` and `20261001`, emitted as written and emitted canonically.
