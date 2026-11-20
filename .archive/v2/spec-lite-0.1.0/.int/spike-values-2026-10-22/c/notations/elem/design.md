# Design N-elem: a notation value is an element

*Spike c, round two, fork "elem" (Opus 5.5, 2026-10-22). One of five spelling designs worked in parallel (`raw`, `args`, `std`, `slot`, `elem`). The shared reader model is `../reader-model.md`; this page uses it and says where it diverges. Labels: **checked** (read in a card or file, named), **instinct** (what I'd write or expect as a writer and reader), **guess**, **taste**. Scores are my hypotheses against CTQ-FACTORS; nothing was measured.*

## The design in one paragraph

Lite already has a node with a name, a namespace (a `/` or `:` inside a label), named parameters (attributes), named variants (traits), a body (`$main`, or the lines below), an inline form that is bounded (`|{…}`), a block form whose body is raw (a fence), and a place in every value position (an attribute's value may be an element: [[rule:element-values]], decided). That is everything a notation needs. So **a notation value is an element whose name is a notation**: `:when |date 2026-10-01`, `Meet on |{date 2026-10-01}.`, `:qty |qty 5 m`. **Lite's grammar adds nothing.** The meaning attaches in the reader. An element in a value position, whose name resolves to a notation in scope and which has no children, is **read** as that notation's value: its `$main` is the body, its attributes are parameters, its traits are variants. The raw tree never changes. An element whose name is unknown stays an ordinary element, which every consumer already handles. `<…>` keeps one job: asserting a parameter-free primitive (`<8080>`, `<true>`, `<>`). By the core fork's first test, those kinds are exactly the ones that need no name, while notations always have one.

## Why it is more than "no new syntax" (taste, with the reason)

The core fork's test 1 sorts kinds into **parameter-free** ones (nil, booleans, numbers, strings, lists) and **parameterized** ones (dates need a calendar and maybe a zone or format; quantities need a unit system; money needs a currency; regexes need a flavour). This design gives each group the structure it needs:

- a parameter-free kind needs no name and no parameters, so a one-character mark (`<…>`) is enough;
- a parameterized kind needs a name, a namespace, parameters, variants, sometimes nested values and sometimes many lines. That is an element, so the element is used.

Any design that puts notations inside `<…>` has to reinvent, inside the brackets, the parts elements already have: a name syntax, a namespace separator, a parameter syntax, nesting, a multi-line form. This design uses the ones lite has already specified and tested.

## The rules

### In lite (the grammar): nothing new

Every spelling on this page parses under the current cards, given two things that are open but leaned: the embeds design puts left-over text inside `|{name …}` into `$main`, as on an element's line ([[rule:inline-element-value-end]], Joseph's R2 "embedded = element-rooted sameline (+`}`)"); and the one-embed reading option is on by default (Joseph's 2026-10-09 aspiration, [[def:reading-option]]). This design needs both settled that way; see "What it depends on".

### In the reader companion (where meaning attaches)

**R1. When an element is a notation value.** A reader reads an element as a notation value when all three hold:

1. **it is in a value position**: an attribute's value; a value on the lines under an attribute; a list item; or the only piece of a value whose text is one embed (the one-embed reading). An element in a child position is structure, always. Inline `|{…}` in prose stays a piece of the text, and a renderer may present it as its value (below).
2. **its name resolves to a notation in scope** (`../reader-model.md`, "Names, namespaces, aliases").
3. **it has no children.** Attributes and traits are allowed: they are the notation's parameters and variants.

All three are structural, so this is not value-sniffing: nothing about the *body's characters* decides whether the element is a notation. If any condition fails, the element is an element.

**R2. Body.** The body is the element's `$main`: one value, either a «text» (the usual case, `2026-10-01`), a «delimited-string» (when the body holds characters lite would read as structure: `'\d+-\w+'`), or a list (the notation then applies to each item: `|date [2026-01-01 2026-07-04]`). A notation with no body (`|today`) is allowed if the notation says so. For a fence, the body is its lines.

**R3. Parameters and variants.**
- An **attribute** is a valued parameter: `|date 27-03-05 :format YY-MM-DD`.
- A **trait** is a named variant: `|date.basic 20261001` (ISO 8601 basic format), `|re.pcre '\d+'`.
- An attribute whose name the notation doesn't declare is a **reader error that teaches** (see the sameline hazard, below).

**R4. Nesting.** A parameter's value can itself be a notation value: `|interval :from |{date 2026-01} :to |{date 2026-06}`. The reader reads inner values first. Depth is bounded by the tree's own depth.

**R5. The tree before and after.** The raw tree holds the element exactly as parsed. The logical tree holds, at the same position, a read value: `{type, value, notation, params, spelling, form}`. Here `notation` is the resolved name, `params` the read attributes and traits, `spelling` the body as written, and `form` one of `element`, `inline`, `fence`. Emitting as written reproduces the element; emitting canonically writes `|name canonical-body` with canonical parameters. An unknown notation's logical node is the element itself.

**R6. Errors.** Lite's errors are the ones elements already have. The reader's errors carry the element's span:

- a bad body: "`2026-13-01` is not a std/date: month 13";
- an undeclared parameter;
- a slot mismatch;
- under a strict reader, an unknown name: "no notation `acme/sku` in scope; it stays an element".

Each says what was probably meant.

## Spellings, every position

```udon
|event
  :when |date 2026-10-01
  :room 4B
|event :room 4B :when |date 2026-10-01
|event :when |{date 2026-10-01} :until |{date 2026-12-01} :room 4B
|event
  :dates
    |date 2026-01-01
    |date 2026-07-04
|event :dates |date [2026-01-01 2026-07-04]
|p Meet on |{date 2026-10-01} in room 4B.
|report
  :query
    ```sql
    SELECT * FROM t WHERE day = '2026-10-01'
    ```
```

| Position | Spelling | Note |
|---|---|---|
| block attribute | `:when |date 2026-10-01` | the cleanest |
| last on a sameline | `:when |date 2026-10-01` | the date owns the rest of the line ([[rule:element-after-attribute-with-no-value]]) |
| anywhere on a sameline | `:when |{date 2026-10-01}` | the brace bounds it; **the recommended sameline spelling** |
| attribute body | one element per line under the attribute | stacked values |
| list of values | `|date [a b c]` (a notation over a list) | avoids embeds-in-lists, which is open |
| prose | `|{date 2026-10-01}` as a piece of text | renders as text, or `<time datetime="…">` in HTML |
| many lines | a fence: ```` ```sql ```` | the fence is the block form of a notation element; its name is the notation |

## The trees, before and after

```udon
|event :when |{date 2026-10-01} :room 4B
```
**Raw tree** (lite's; one-embed reading on):
````tree
root
  |event
    :when |date
      :$main ‹2026-10-01›
    :room ‹4B›
````
**Logical tree** (a reader with `std` in scope):
````tree
root
  |event
    :when 2026-10-01::std/date   {spelling "2026-10-01", form inline}
    :room ‹4B›
````
**Logical tree** (a reader with no notations): identical to the raw tree. `when` holds an element `date` whose `$main` is ‹2026-10-01›. Nothing is lost or guessed. A JSON converter with no notations gives `"when": {"date": "2026-10-01"}` (element mapping); with `std` it gives `"when": "2026-10-01"` (std/date's JSON form).

## The sameline hazard, worked to the end

[[rule:element-after-attribute-with-no-value]] (decided) gives an element that follows a waiting attribute "the rest of the line". So:

```udon
|event :when |date 2026-10-01 :until |date 2026-12-01
```
````tree
root
  |event
    :when |date
      :$main ‹2026-10-01›
      :until |date
        :$main ‹2026-12-01›
````
`until` belongs to the first date, not to the event. The parser is silent, because this is correct lite. **What catches it:** R3, since std/date declares no `until` parameter. The reader says: "`until` is not a parameter of std/date. It belongs to the date because it follows it on the line. Did you mean `:when |{date 2026-10-01} :until |{date 2026-12-01}`?" So the trap is caught for every known notation and stays silent for unknown ones (where it is only structure anyway). Writing advice: on a sameline, always brace a notation value. Instinct: after one look at the brace form I'd write it unprompted, because it looks like what it is (a bounded thing in a line).

I tried to remove the hazard outright, and the attempt is a finding. Excepting notation elements from "the rest of the line" would need the parser to know which names are notations, which breaks R1's "the grammar adds nothing" and puts a registry into lite. The decided rule stays, and the brace form is the fix.

## Naming, namespacing, aliases

- **Names are labels**, so they get the labels lean's characters: `date`, `u16`, `acme/sku`, `css/length`. `/` is allowed inner and last in a bare label (*checked*, `.int/labels-ascii-and-positions-2026-10-20.md`), so `|acme/sku AB-12` needs no quoting. `:` stays free for XML's own prefixes (`|svg:rect`), so a notation `acme/sku` and an XML element `acme:sku` never collide.
- **Resolution** as in the reader model: short names through the vocabularies in scope and then `std`; qualified names through their first segment.
- **Vocabularies are lite documents**, and in this design that is especially natural, because a notation definition and a notation value are the same kind of thing. An illustrative vocabulary:

  ```udon
  |vocabulary[net]
    |union[port]
      |notation u16
      |enum[standard-port] [smtp ssh http https]
  ```
- **Scope** as in the reader model (reader configuration < file name < root attribute). A root attribute like `:vocabulary net` reads the way XML's `xmlns` attributes do: data that a reader honors.

## Dates (the std notations, spelled)

| Intent | Spelling | Reads as |
|---|---|---|
| calendar date | `|date 2026-10-01` | std/date 2026-10-01 |
| partial date | `|date 2026-10`, `|date 2026` | month, year precision |
| basic format | `|date.basic 20261001` | variant via trait |
| domain format | `|date 27-03-05 :format YY-MM-DD` | 2027-03-05; `YY` means 20YY unless `:century 19`. A pivot that depends on the reading date was rejected: it would make a document's meaning depend on when it is read (B3) |
| local time | `|time 09:00` | std/time |
| instant | `|instant 2026-01-10T14:30Z` | RFC 3339 date-time |
| zoned | `|zoned 2026-01-10T07:30-07:00[America/Denver]` | RFC 9557 (the `[…]` is inside a run, not at a value start, so it is text) |
| Joseph's `<dt: 2026 PDT>` | `|date 2026 :zone PDT` | a year, reckoned in a zone. The reader warns that `PDT` is an abbreviation (ambiguous across regions); `:zone America/Los_Angeles` is the unambiguous spelling |
| duration | `|duration 30s`, `|duration P1Y2M`, `|duration 5m` | inside std/duration, `m` is minutes (shorthand `s m h d w mo y`, plus ISO) |
| interval | `|interval 2026-01/2026-06`, or `|interval :from |{date 2026-01} :to |{date 2026-06}` | ISO 8601 interval body, or nested values |

## Units

| Intent | Spelling | Reads as |
|---|---|---|
| 5 metres | `|qty 5 m` | std/qty: number, space, UCUM code. Within UCUM, `m` is metre and `min` minute (*checked*). The number-space-code pairing is this notation's convention: UCUM defines unit terms only (*relayed as checked* by the spike agent) |
| 5 minutes | `|qty 5 min`, or `|duration 5m` | either notation; each resolves `m` by its own dictionary |
| 1.5 GiB | `|qty 1.5 GiBy` | UCUM byte is `By`; `Gi` is a proposed binary prefix |
| 50% | `|qty 50 %` | |
| 37.5 °C | `|qty 37.5 Cel` | UCUM `Cel` (*relayed as checked*) |
| 920px | `|css/length 920px` | not UCUM; a CSS notation reads CSS's own spelling |
| money | `|money 9.99 USD` | ISO 4217 code; an exact decimal |

**How `5m` is resolved:** by the notation named, never by the literal alone. `|duration 5m` is minutes, `|qty 5 m` metres, and bare `5m` in a slot is whatever the slot's notation says. Units belong to notations, not to a universal unit syntax.

**Unit elements were tried and dropped.** Spelling the unit as the element name (`|m 5`, `|min 5`, `|px 920`) is concise and very domain-forward, but UCUM's short codes collide with HTML element names: `a` is UCUM's year and HTML's anchor, and `s` is the second and the strikethrough. The collision is with C2 (weight 10). Kept as a vocabulary option (`|px 920` for a CSS vocabulary, where no collision exists), not as std.

## What `<…>` is left for, and the future forms

- **`<…>` asserts a parameter-free primitive** (the mark fork's M1): `<8080>`, `<0.5>`, `<true>`, `<nil>`, `<>`, `<"…">`, committed at the `<` with a mismatch an error. `<date:…>` and every other interior stay errors. They aren't needed, since notations are elements.
- **`<{…}>` (embedded value)** is unnecessary: `|{…}` already is an embedded value here. `<{` stays an error.
- **A reference kept as a reference** (`@<…>`): `|ref people/jw`, a std notation whose value is an unresolved reference, against `@{people/jw}`, which resolves. That gives Joseph's quote/unquote distinction a principled home without spending `@<`.

## The composite set N1–N18

```udon
|n1  :on |date 2026-10-01
|n2  :at |{instant 2026-01-10T14:30Z} :at-local |{zoned 2026-01-10T07:30-07:00[America/Denver]}
|n3  :opens |{time 09:00} :year |{date 2026 :zone PDT}
|n4  :born |date 27-03-05 :format YY-MM-DD
|n5  :t1 |{duration 30s} :t2 |{duration P1Y2M} :t3 |{duration 5m}
|n6  :span |interval 2026-01/2026-06
|n7  :w |{css/length 920px} :len |{qty 5 m} :disk |{qty 1.5 GiBy} :share |{qty 50 %} :temp |{qty 37.5 Cel}
|n8  :price |money 9.99 USD
|n9  :addr |i64 0x73DDF
|n10 :port ssh
|n10 :port 22
|n10 :port |port ssh
|n11 :pat |{re '\d+-\w+'} :home |{url https://example.com} :id |{uuid 3f2b8c1e-9d4a-4b7e-8f00-2a1c5e6d7b90} :blob |{b64 SGVsbG8=}
|n12
  :query
    ```sql
    SELECT * FROM t
    ```
|n13 :holidays |date [2026-01-01 2026-07-04]
|n13
  :holidays
    |date 2026-01-01
    |date 2026-07-04
|n14 :sku |acme/sku AB-12
|n15 :when |instant 2026-01-10T14:30Z
|p   Meet on |{date 2026-10-01}.
|li  \<https://example.com>
|n17 :owner |ref people/jw :link @{people/jw}
|n18 :a |date 2026-10-01 :b |date.basic 20261001
```

Notation: `‹…›` a text; `X::std/name` a read value; `→` the logical tree for a reader with `std` in scope; "raw" the lite tree.

| | Raw tree (abridged) | Logical (`std` in scope) | Verdict |
|---|---|---|---|
| N1 | `on |date $main ‹2026-10-01›` | `2026-10-01::std/date` | renders |
| N2 | two element values, bodies as texts | instant; zoned instant with `America/Denver` kept | renders |
| N3 | `|time ‹09:00›`; `|date ‹2026› :zone ‹PDT›` | time 09:00; year 2026 in PDT, with a warning on the abbreviation | renders |
| N4 | `born |date $main ‹27-03-05› :format ‹YY-MM-DD›` (the date is last on the line, so `:format` is its own: here the hazard is what makes it work) | 2027-03-05, format kept for canonical re-emission | renders |
| N5 | three duration elements | 30 s; P1Y2M; 5 min | renders; `5m` resolved by the notation |
| N6 | `|interval $main ‹2026-01/2026-06›` | interval Jan–Jun 2026 | renders (or nested form) |
| N7 | five elements | CSS length; 5 m; 1.5 GiBy; 50 %; 37.5 Cel | renders |
| N8 | `|money ‹9.99 USD›` | 9.99 USD exact | renders |
| N9 | `|i64 ‹0x73DDF›` | 474591, range-checked as i64; the host binding picks storage | renders; `|rust/i64` also spellable, scored down on A5 |
| N10 | ‹ssh›, ‹22›, and `|port ‹ssh›` | via the `port` slot type: `ssh` the enum arm, 22 the u16 arm; the literal `|port ssh` the same, by the alias | renders, slot-first; the literal form exists for slots without a schema |
| N11 | `|re` with a single-quoted body (backslashes literal: [[rule:single-quote-escapes]]); url; uuid; b64 | regex; URL; UUID; bytes | renders. A bare `|{re \d+-\w+}` errors at `\d` ([[rule:value-line-escapes]], proposed), with a fix: quote it |
| N12 | a fence named `sql` as `query`'s value | an SQL notation if in scope; else a fence | renders; **fences are the block form of this design, not a separate thing** |
| N13 | `|date $main [‹2026-01-01› ‹2026-07-04›]`; or two stacked date values | two dates either way | renders |
| N14 | `|acme/sku ‹AB-12›` | unknown: stays the element; strict reader raises with a fix | renders, degrades gracefully: JSON `{"acme/sku": "AB-12"}`, XML-ish `<acme-sku>AB-12</acme-sku>` |
| N15 | an instant element in a slot typed date | error: "slot `when` expects std/date; this is std/instant. Did you mean `|date 2026-01-10`?" | renders the conflict as a teaching error |
| N16 | the date is a piece of the paragraph's text; `\<` is text | prose shows "Meet on 2026-10-01."; an HTML renderer may emit `<time datetime="2026-10-01">` | renders. The unescaped `|li <https://…>` is an M1 error with that fix |
| N17 | `|ref ‹people/jw›`; `@{people/jw}` | a kept reference; a resolvable one | renders |
| N18 | `|date ‹2026-10-01›`; `|date.basic ‹20261001›` | the same date twice; emit-as-written keeps both spellings; canonical writes `|date 2026-10-01` both times. `|date 20261001` without the trait is a reader error: "did you mean `|date.basic 20261001`?" | renders |

## Composite lines (the choice mixed with other rules)

```udon
|ev :when |{date 2026-10-01} :room 4B ; set by Ana
|ev :when |{date 2026-10-01} \ bring snacks
|ev :title 1984 :when |{date 1984-06-08}
|td :w |{css/length 920px}
|ev :when |{date 2026-10-01} ;{tentative}
```
````tree
root
  |ev
    :when |date
      :$main ‹2026-10-01›
    :room ‹4B›            (framed comment attached: ‹set by Ana›)
  |ev
    :when |date
      :$main ‹2026-10-01›
    :$main ‹bring snacks›
  |ev
    :title ‹1984›
    :when |date
      :$main ‹1984-06-08›
  |td
    :w |css/length
      :$main ‹920px›
  |ev
    :when ‹|{date ‹2026-10-01›} ;{tentative}›
````
Line 3: `:title 1984` ends at the start ` :when`, so `title` is ‹1984›. Line 5 is the interesting one. The value is a text with **two** pieces (the inline date and an inline comment), so the one-embed reading doesn't apply and the date is a piece of text, not a value. A reader asking `date(:when)` gets an error that teaches: "`when` holds text with a date and a comment; move the comment out (`:when |{date 2026-10-01} ; tentative`)". This is the same shape as Joseph's `:width 7 ;{px}` gotcha, and it behaves the same way.

## What it depends on (open items it needs settled one way)

1. Inside `|{name …}`, left-over text is `$main` ([[rule:inline-element-value-end]] leaves it open; Joseph's R2 reading supports it).
2. The one-embed reading is on by default ([[def:reading-option]], his aspiration).
3. A fence can be an attribute's value (a body under the attribute). The cards place a fence by its column ([[rule:fence-anywhere-structure]]); the PEG review noted it as missing from the grammar draft, not as ruled out.
4. Embeds inside list items stay open. This design doesn't need them, because a notation applies over a list.

## Honest costs

- **Errors in bodies are reader-time, not parse-time** (B4). Lite can't say `|date 2026-13-45` is wrong; a reader can, with the same span precision. Every design that keeps notation definitions out of lite pays this. Only `std` (lite knowing the notations) avoids it.
- **The sameline hazard** above: caught for known notations, silent for unknown ones, avoided by the brace form.
- **Element-valued attributes have no XML spelling** (the decided rule's own cost). With notations known, a converter writes `when="2026-10-01"`. Without them, the value is lost to XML attributes.
- **A cold reader may take `:when |date 2026-10-01` as structure.** It *is* structure in the raw tree; the reading is "an element named date holding 2026-10-01", which is true and points the right way.
- **Bodies are texts under the run rule**, so a body holding ` :x`, ` |x` or ` ; ` must be quoted. For dates, units and money this never happens; for regexes and code it does, and the fix (single quotes, or a fence) is ordinary lite.
- **Verbosity on a sameline**: `|{date 2026-10-01}` is 18 characters, against 17 for `<date:2026-10-01>`. A wash.

## Vetoes and scores (hypotheses)

- **B1 bounded streaming: pass.** `|` commits at once; the element's name ends at a space or bracket, as for every element. Nothing here waits on a body to decide structure.
- **B2 reserve, don't ignore: pass,** trivially. No new syntax. An unknown notation is an element, whose meaning a later UDON can't change without changing elements.

| Factor (weight) | Score | Basis | Conf. |
|---|---|---|---|
| A1 agent-subjective (9) | 8 | taste: one idea (an element names what it is) carrying both structure and typed values; reads like XML's `<time>` | low |
| A2 generative guessability (10) | 7 | instinct: having seen `|{a :href …}` and one `|{date …}`, I'd guess `|{qty 5 m}` and `|{money 9.99 USD}` unprompted; the sameline brace rule is the one thing to learn | medium |
| A3 cold comprehension (10) | 8 | `|date 2026-10-01` says "date"; structure and value readings agree on what it holds | medium |
| A4 agentic readability (10) | 8 | known forms; braces bound values visually | medium |
| A5 domain-forward (9) | 7 | domain words (`date`, `money`, `qty`) as names; still one name per value where no slot helps | medium |
| A6 spec clarity (9) | 9 | the grammar is unchanged; one reader paragraph (R1–R6) | medium |
| A7 syntactic simplicity (8) | 10 | zero productions added | high |
| A8 parsimony (8) | 10 | no new characters; `<` keeps one role | high |
| A9 conciseness (6) | 6 | brace form about equal to `<name:…>`; block form shorter | high |
| A10 self-description (5) | 7 | the notation name sits on the value | medium |
| A11/A12 human read/write (5/2) | 7 / 6 | | low |
| B3 stability (10) | 9 | one raw tree; readings differ only by registry | high |
| B4 errors that teach (8) | 7 | reader errors are good (undeclared parameter, slot mismatch, unknown name), but come later than parse | medium |
| B5 parse speed (9) | 9 | nothing added to the parser | high |
| B6 headroom (7) | 10 | spends no syntax at all | high |
| C1 structured data (10) | 7 | JSON round trip needs notation-aware conversion for typed values; the primitives still have `<…>` | medium |
| C2 XML/HTML (10) | 8 | notation elements map to XML elements; an XML attribute can't hold one unless the notation is known | medium |
| C3 Markdown in prose (9) | 9 | `|{date …}` is an ordinary embed; frees `<` from notation use | medium |
| C4 types, notations, units (8) | 9 | every intent N1–N18 renders, params and nesting included | medium |
| C5 schemas, slot types (8) | 8 | slot types read bare values; the literal form serves slots without schemas; checked against each other | medium |
| C6 extensibility, dialects (8) | 9 | namespaced names, vocabularies as UDON, unknown names degrade to elements | medium |
| C7 predictable tree and API (8) | 8 | typed getters accept bare text (slot notation) or a notation element | medium |
| C8 other languages (8) | 9 | fences are notation values: one concept | medium |
| C10 round trip (7) | 9 | the element is kept exactly | high |

**Card radius (checked against the outline):** no grammar card changes. To settle: [[rule:inline-element-value-end]] (`$main` inside braces) and [[def:reading-option]] (one-embed default on), both already open. To write: a reader companion (R1–R6 plus the std library). To adjust: [[rule:opaque-span-raw-text]] (`<…>` becomes M1, primitives only), [[def:typed-value]] (a «notation-value» is an element read by a notation), [[rule:fence-default-handler]] (a fence handler is a notation). About six records, none of them a reversal of a decided rule.

## Verdict for lite 0.1

**This design can be lite 0.1's whole answer to notations,** because lite 0.1 already parses all of it. What 0.1 has to ship is the reader companion (R1–R6) and the std library table, plus settling the two open embed questions the way their cards already lean. The meaning is on the table above. Nothing is deferred except what a reader chooses to know.

Where it is weakest, compared with an in-bracket design: the sameline brace rule, reader-time body errors, and XML attribute values. Where it is strongest: zero grammar, zero headroom spent, graceful degradation of unknown notations, and one concept for elements, notations and fences.
