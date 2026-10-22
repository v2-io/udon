# N-args: a notation value is a name and a list of already-read values

*Spike c, round two, fork "args" (Opus 5.5, 2026-10-22). REBOL's dialect idea brought to lite: inside `<…>`, lite reads the body into ordinary lite values, and the notation interprets that list, never raw characters. Developed to its strongest form; the costs found on the way are kept. Labels: **checked** (run in `nargs.py` here, output in `cases.out.txt`, or read where named), **instinct** (what I'd write or expect, as a target writer and reader), **guess**, **taste**. Scores are hypotheses against `CTQ-FACTORS.md`. The shared reader model is `../reader-model.md`, and this page says where N-args differs from it. Every raw tree on this page was produced by the prototype, not drawn by hand; logical trees (after a reader) are drawn.*

## The rule, as it would be carded

1. **Where a value is expected, `<` opens a marked value.** What follows the `<` (spaces skipped) commits its kind at its first character:
   - `>` gives **nil** (`<>`).
   - A digit or sign gives **one number** in the standard numeric notation (M1; the `core` fork's spelling). A mismatch is an error.
   - `"` or `'` gives **one delimited string**.
   - A letter gives a **label**. `nil`, `true` and `false` are the keywords. Any other label is a **notation name**, and what follows it is that notation's **arguments**.
   - Anything else is an error.
2. **A notation name** is one or more labels joined by `/` (`date`, `std/date`, `css/length`, `rust/i64`), the path form the shared reader model uses. A `:` directly after the name is an **error** that suggests the spaced form (`<date: 2026-10-01>` → "did you mean `<date 2026-10-01>`?"). A name followed by `://` is an error that names the autolink.
3. **Arguments** are separated by whitespace and read **exactly as list items are** ([[rule:list-items-whitespace-separated]], one rule in both places):
   - `"…"` and `'…'` are «delimited-string»s.
   - `[…]` is a list.
   - `<…>` is a nested marked value.
   - `|{…}` is an inline element.
   - Anything else is an **unquoted token**: it runs to whitespace or the closing `>`, and it may hold matched `[]`, `()` and `{}` pairs inside it (so RFC 9557's `…Z[America/Denver]` stays one token).

   Under the store's lean, a token is a «text». A notation reads it; lite doesn't type it.
4. **At least one argument.** `<kbd>` and `<br>` are errors: "if this is HTML or a placeholder, escape it as text (`\<kbd>`)".
5. **Nothing may follow the closing `>` directly** except a space, the end of the line, or a start. `<b>Note</b>` is an error with the same advice.
6. **Single line.** A newline inside is an error, as for every `<…>` today. The block spelling of a notation with one text argument is a **fence** named for the notation (below).
7. **In prose,** the same value is written `<{name args}>`. It is an embed, a «piece» of the text like `|{…}`, `@{…}` and `;{…}`. `<{` is neither a CommonMark autolink nor raw HTML, since both need a letter after `<` (the CommonMark citation is the mark fork's, which I haven't re-checked). So it collides with nothing in Markdown prose.
8. **Lite attaches no meaning to a notation value.** The tree holds `nv(name args…)`. Reading it is a notation's job, above the tree.

## The tree, before and after (checked: every raw tree below is the prototype's output)

```udon
|event :on <date 2026-10-01> :span <interval <date 2026-01> <date 2026-06>> :dur <qty 5 min>
```
Raw tree (lite's; the fixtures show this):
````tree
root
  |event
    :on    nv(date ‹2026-10-01›)
    :span  nv(interval nv(date ‹2026-01›) nv(date ‹2026-06›))
    :dur   nv(qty ‹5› ‹min›)
````
Logical tree (a reader with `std` in scope):
````tree
root
  |event
    :on    2026-10-01 ::std/date      ← spelling `2026-10-01`, form angle, notation std/date
    :span  2026-01..2026-06 ::std/interval[std/date]
    :dur   5 min ::std/qty            ← the UCUM code `min`: a time quantity of 300 s
````
The raw tree never changes when a reader learns a notation: a reader without `std` gives `unread{date, [‹2026-10-01›]}` in the logical tree and the identical raw tree. That is the law that makes carrying a named value pass B2 (the mark fork's finding). N-args adds one thing to it: **lite fixes the argument tokenization**, so not even a later notation can ask for the raw tree to be split differently. Everything a notation could want is already decided by lite's own list-item rule.

## Where N-args differs from the shared reader model

- **`read` takes a list of lite values, not a body string.** A notation's **signature** says what it accepts, by position and by lite kind (text, string, list, nested value, element). This is what REBOL dialects do: they dispatch on the datatypes of an already-loaded block. (Evidence, not a reason. REBOL is Joseph's stated homage for `<…>`, and the mark fork checked that REBOL's own `<…>` is its `tag!` type.)
- **Parameters are arguments.** A notation's signature can reserve a *string* argument for a parameter, because a quoted string can never be confused with a bare body token. So `<date "YY-MM-DD" 27-03-05>` is `std/date` with the format `YY-MM-DD`. The logical tree records the notation as `std/date("YY-MM-DD")`, and canonical re-emission can choose `<date 2027-03-05>` or keep the format.
- **`write` returns arguments,** and the printer spells them: canonical `<date 2026-10-01>`. The spacing between arguments is ornament, kept in «meta» for emitting as written.
- **Type expressions are notation values too.** A vocabulary can write Joseph's algebraic name as data, with nothing new:
  ```udon
  |vocabulary[net]
    |type[port] <union <type u16> <enum smtp ssh http https>>
  ```
  `<type u16>` is the notation `type` with the argument ‹u16›: a value whose meaning is "the notation `u16`, as a type". So vocabularies are lite documents whose values are notation values (this is the shared model's "a vocabulary is a lite document", made concrete).

## Names, namespaces, scope

- Short names (`date`) resolve through the vocabularies in scope, then `std`. Qualified names (`acme/sku`) need `acme` bound (shared model).
- **The standard library's short names are reserved.** A vocabulary can't redefine `date`. It can define `acme/date`, or declare an alias explicitly. Taste: one meaning of `<date …>` in every document beats per-document cleverness (B3, A3).
- `:` is kept for nothing in names. That keeps `<rust: i64 0x73DDF>` (an error) from ever meaning something different from `<rust/i64 0x73DDF>` (checked: both outcomes are in `cases.out.txt`).

## The standard library, spelled in N-args (the shared table's meanings)

| Intent | Spelling | Raw tree (checked) |
|---|---|---|
| N1 date | `<date 2026-10-01>` | `nv(date ‹2026-10-01›)` |
| N2 instant | `<instant 2026-01-10T14:30Z>` | `nv(instant ‹2026-01-10T14:30Z›)` |
| N2 zoned (RFC 9557) | `<zoned 2026-01-10T14:30Z[America/Denver]>` | one token: the brackets match inside it |
| N2 zoned, as two arguments | `<zoned 2026-01-10T14:30Z America/Denver>` | `nv(zoned ‹…Z› ‹America/Denver›)`: the zone as its own argument, for writers who don't know RFC 9557. A signature can accept both |
| N3 local time | `<time 09:00>` | `nv(time ‹09:00›)` |
| N3 Joseph's year in a zone | `<dt 2026 PDT>` | `nv(dt ‹2026› ‹PDT›)`: a component dialect; `dt` reads its arguments by shape (a year, a zone abbreviation). This is where argument lists shine: the components arrive already separated |
| N4 domain format | `<date "YY-MM-DD" 27-03-05>` | `nv(date "YY-MM-DD" ‹27-03-05›)` → 2027-03-05 |
| N5 30 s | `<duration PT30S>` | |
| N5 P1Y2M | `<duration P1Y2M>` | calendar-aware: a month isn't a fixed length |
| N5 five minutes as `5m` | `<duration 5m>` | inside `duration`, `m` is minutes, always (its own shorthand table) |
| N5, physically | `<qty 5 min>` | UCUM: `min` minutes; `mo` would be a *mean* month, a fixed length. That's a real semantic difference from `duration`'s month, so the two are different notations on purpose |
| N6 interval | `<interval <date 2026-01> <date 2026-06>>` or `<interval 2026-01/2026-06>` | nested values, or ISO 8601's own spelling as one token; `interval`'s signature takes either |
| N7 920px | `<css/length 920px>` | CSS's own spelling, one token |
| N7 5 m | `<qty 5 m>` | `m` is metres in UCUM, unambiguously |
| N7 1.5 GiB | `<qty 1.5 GiBy>` | UCUM byte `By`, prefix `Gi` ("proposed", per UCUM's Table 23) |
| N7 50 % | `<qty 50 %>` | |
| N7 37.5 °C | `<qty 37.5 Cel>` | `Cel` checked |
| N8 money | `<money 9.99 USD>` | exact decimal; ISO 4217 code |
| N9 host | `<rust/i64 0x73DDF>` | a host namespace (below) |
| N11 regex | `<re '\d+-\w+'>` | single quotes keep `\d` literal ([[rule:single-quote-escapes]]); and `>` inside a string never closes the value (`<re "a>b">` checked), an advantage over a raw body, which must escape it |
| N11 URL, UUID, bytes | `<url https://example.com/a?b=c>`, `<uuid 0f8fad5b-…>`, `<b64 SGVsbG8sIHdvcmxk>` | |

**Units sit inside notations, not beside numbers.** Which `m` is meant is the notation's business: minutes inside `duration`, metres inside `qty`, and inside `css/length` `m` isn't a CSS unit at all. **Number, space, unit code** is this design's convention for `qty`. UCUM defines only the unit term, so the pairing is ours, not UCUM's. A glued `<qty 5m>` is a single token, which `qty`'s signature rejects with "did you mean `<qty 5 m>` (metres) or `<duration 5m>` (minutes)?".

## Slot and literal together (N10, N15)

```udon
|svc :port ssh
|svc :port <port 22>
|ev  :when <instant 2026-01-10T14:30Z>
```
- `:port ssh`: bare text. A slot typed `net/port` reads it through the union and gets the enum member `ssh`.
- `<port 22>`: the literal names the alias itself. It reads as the u16 22 in any document that has `net` in scope.
- If `when` is declared `std/date`, the literal is read as an instant, then fails the slot check: "slot `when` expects std/date; this is std/instant: did you mean `<date 2026-01-10>`?" The literal says what it represents; the slot says what it accepts (Joseph's distinction, unchanged from the shared model).

## Host types (N9)

`<rust/i64 0x73DDF>` is spellable, but it is plumbing between the domain and the machine (A5). The design's answer: a **host namespace's notations must name a portable meaning** in their vocabulary (`rust/i64` → `std/i64`, a range-checked integer). A Python reader that doesn't know `rust` still reads the value through that link, and the storage hint is just extra. The value's meaning stays portable; the hint is optional. (This follows the ideation file's lean on H: keep storage names as domain ranges.)

## Lists and bodies (N13)

```udon
|cal :holidays [<date 2026-01-01> <date 2026-07-04>]
|cal
  :holidays
    <date 2026-01-01>
    <date 2026-07-04>
```
One name per value: honest plumbing (A5, A9). I tried a "map" form (`<date [2026-01-01 2026-07-04]>`, a notation over a list) and dropped it. Each notation's signature would have to say whether a list means "map me" or "a list argument" (`interval` takes two values, `enum` takes many), which is a per-notation surprise (A3). The clean remedy is the slot: `:holidays` declared as a list of `std/date` reads bare `2026-01-01` items with no marks. That is the `slot` sibling's territory, and the two compose.

## Multi-line (N12): fences are the block spelling

````udon
|report
  :query
    ```sql
    SELECT name FROM users
    WHERE active
    ```
````
The fence's name is the notation's name, and its body is the one text argument. Raw tree: `nv(sql ‹SELECT name FROM users\nWHERE active›)` with form `fence`. **A fence is a notation value with one text argument, written in block form.** The fence-handler question ([[rule:fence-default-handler]]: "who supplies one, how it is picked") gets the same answer as notations: a handler *is* a notation's reader, picked by name through scope. This leans on fences being allowed as an attribute's value, which the PEG review found missing and is a gap of its own.

## Prose and the inline element (N16), faced honestly

```udon
Meet on <{date 2026-10-01}>, or |{em later}.
|li <https://example.com>
```
- Line 1: a «text» with pieces ‹Meet on ›, `nv(date ‹2026-10-01›)`, ‹, or ›, `|{em later}`, ‹.›.
- Line 2: an **error**, "`<https://…>` looks like a URL autolink: write the text `\<https://…>`, or `<url https://…>`" (checked). It is caught, not silent: the mark fork's M2 made it the notation `https` silently.

**How close is `<qty 5 min>` to `|{qty 5 min}`?** Very. Both are a name followed by material, inside a bracket.
- The element gives `|qty` with `$main ‹5 min›` (one run, under the bare-run lean).
- N-args gives `nv(qty ‹5› ‹min›)`.

For a one-argument notation (`<date 2026-10-01>` against `|{date 2026-10-01}`) **the information is identical**. What N-args keeps distinct, and what would collapse if it didn't:

1. **Value, not node.** The raw tree says "this is a value in notation `date`". An element would need a reading option to collapse into a value, and every reader would need to know which element names are notations. This is Joseph's "*this is what my literal represents*", stated in the tree.
2. **Items, not a run.** Arguments come lexed (strings, lists, nested values), so nesting, parameters and component dialects (`<dt 2026 PDT>`) work without the notation re-tokenizing text.
3. **No attributes, no children, no text runs.** This is the hard line. The moment `<…>` accepted `:format YY-MM-DD`, it *would be* an inline element with a different bracket, and N-args would be the `elem` design wearing angle brackets. Named parameters go in strings, by signature, precisely to keep that line.

What it means: N-args is defensible only while those three differences pay for a second bracketed name-plus-material form. They pay for nesting and lexed parameters (C4, C6). They cost parsimony (A8) and a cold reader's confusion between the two forms (A3). If Joseph judges that nesting and parameters don't need lexed arguments, the honest move is `elem`, not a weakened N-args.

## Joseph's future forms (N17)

- **A reference kept, not resolved:** `<ref people/jw>`. That is a value in the notation `ref`, while `@{people/jw}` resolves. This is his Lisp-quote distinction, with `<…>` as the quote. `@<…>` stays reserved; if wanted, it is sugar for `<ref …>`.
- **`<{…}>`:** in this design it is the **prose embed** of a notation value (rule 7). That is my reading of his "embedded value", and I'm flagging it as a reading. Structure *inside* a value is an argument that is an element (`<poly |{pt 1 2} |{pt 3 4}>`, checked), so no separate form is needed.

## Round trip (N18)

`<date 20261001>` (ISO 8601 basic) gives `nv(date ‹20261001›)` (checked). As written, it emits `<date 20261001>`; canonically, `std/date`'s `write` emits `<date 2026-10-01>`. The spelling, form and inter-argument spacing are kept, so both are always possible.

## Near-misses (all checked in `cases.out.txt`)

| Written | Result | Kind of miss |
|---|---|---|
| `<date: 2026-10-01>` | error, "did you mean `<date 2026-10-01>`?" | caught (Joseph's own most frequent spelling, so it gets a precise fix) |
| `<rust: i64 0x73DDF>` | error | caught; it can never silently differ from `<rust/i64 …>` |
| `<920px>` | error, suggests the bare text or a named notation | caught |
| `<true story>` | error | caught |
| `<kbd>Ctrl</kbd> to copy`, `<br>`, `<b>Note</b>:`, `<a href="x">link</a>` | errors, each suggesting `\<` | caught: no HTML shape at a value start parses |
| `<re a>b>` | error (text runs on after `>`) | caught; the fix is `<re "a>b">` |
| `<= 5 items` | error | caught |
| `<instant 2026-01-10T14:30Z> as the start` | value, then ‹as the start› to `$main` under the one-value lean | intended, not a miss |
| a native spelling with meaningful spaces, `<re a  b>` | two text arguments; the double space is ornament | **silent** when the notation joins its arguments. The rule writers must learn: exact text goes in quotes. The one silent miss this design has |

## The factors

**B1 (veto): pass.** The marked value's kind is fixed at the `<` plus one character, or at the end of the notation name, which is a label (bounded the way an element name is). Arguments are list items, each kind-first. Nothing is held beyond what every token is held today (`../../checks/streaming-holdback.md`).

**B2 (veto): pass, on two conditions.** The law that notations read above the tree in every UDON (shared with M2). And lite's tokenization of arguments is final. Unknown names are carried, not ignored, and the raw tree they get can never change.

| Factor (weight) | Score | Basis | Conf. |
|---|---|---|---|
| A1 agent-subjective (9) | 7 | `<qty 5 min>`, `<interval <date 2026-01> <date 2026-06>>` read cleanly to me. `<date "YY-MM-DD" 27-03-05>` is a little cryptic (taste) | low |
| A2 generative guessability (10) | 7 | I'd guess `<date 2026-10-01>` after one example, and nested values too. I wouldn't guess "parameters are quoted strings" or "exact text needs quotes". Joseph's `<date: …>` is caught with a fix | medium |
| A3 cold comprehension (10) | 6 | `<qty 5 min>` looks like an HTML start tag with two attributes. A cold reader may think it's markup, and the twin form `|{qty 5 min}` adds confusion | medium |
| A4 agentic readability (10) | 8 | one name, then domain spellings; visible nesting | medium |
| A5 domain-forward (9) | 7 | domain spellings kept whole (`2026-10-01`, `920px`, `PT30S`); one name per value is plumbing, and lists repeat it | medium |
| A6 spec clarity (9) | 8 | the interior is the list-item rule plus "a leading label names the notation"; one rule reused | medium |
| A7 syntactic simplicity (8) | 7 | adds a head label, the no-argument and nothing-follows errors, and the `<{…}>` embed | medium |
| A8 parsimony (8) | 6 | `<` gains a role, `<{` is a new embed opener, and two bracketed name forms exist | medium |
| A9 conciseness (6) | 7 | `<date 2026-10-01>` is 6 characters of plumbing | high |
| A10 self-description (5) | 8 | the notation is in the document | high |
| B3 stability (10) | 9 | one tree, tokenization fixed by lite | high |
| B4 errors that teach (8) | 9 | every HTML and autolink shape at a value start errors with a fix (checked) | high |
| B5 parse speed (9) | 8 | list-item lexing, already needed; no body re-scan by lite | medium |
| B6 headroom (7) | 6 | spends `<label`, `<{`, and the fence-as-notation reading | medium |
| C1 structured data (10) | 8 | primitives as M1, plus typed values JSON lacks | medium |
| C2 XML/HTML (10) | 8 | HTML at a value start is always caught, never silent (better than M2) | medium |
| C3 Markdown (9) | 8 | `<{…}>` collides with no CommonMark construct; autolinks in sameline text error with a fix | medium |
| C4 types, notations, units (8) | 9 | every N1–N18 intent renders, including nesting, parameters, zones, units resolved per notation | medium |
| C5 schemas, slot types (8) | 6 | literal-side; type expressions as values let vocabularies be lite documents; bare-value slots are `slot`'s | medium |
| C6 extensibility (8) | 9 | namespaces, host namespaces with portable links, vocabularies as data | medium |
| C7 predictable tree/API (8) | 8 | `nv(name args…)` is one node kind, with typed reads on top | medium |
| C8 other languages (8) | 8 | fences unified as block notation values | medium |
| C10 round trip (7) | 8 | spelling, form and spacing kept; canonical via `write` | medium |

## Card radius (proposals; no card edited)

- **New cards:**
  - the marked value: rule 1, merged with M1;
  - notation names and the colon error;
  - notation arguments, which reuse the list-item rule;
  - the no-argument and nothing-follows errors;
  - the `<{…}>` embed;
  - a fence as the block form of a notation.
- **Changed:**
  - [[rule:opaque-span-raw-text]]: `<…>` leaves the opaque spans, which keep only `@{…}` and `;{…}`;
  - [[rule:opaque-span-escapes]] and [[rule:matched-pairs-need-no-escape]]: the `<…>` parts;
  - [[def:typed-value]]: «type-label» becomes «notation-name»;
  - [[def:embed]] and [[rule:embeds-in-text]]: a fourth embed;
  - [[rule:list-items-whitespace-separated]]: its open "unquoted item extent" question is answered here, with matched pairs allowed inside a token, for both places;
  - [[rule:reserved-spellings]]: `@<` stays, perhaps as sugar;
  - [[rule:value-line-escapes]]: `\<` becomes load-bearing;
  - [[def:fence]] and [[rule:fence-default-handler]];
  - [[rule:unclosed-delimiter-is-error]].
- **Plus** the reader-layer companion: the signature format, `std`, and vocabularies.
- **About fifteen records.** Two are decided rules whose `<…>` clauses change.

## Is this lite 0.1's?

My judgment as this design's advocate, which is still a judgment: **the parts lite must fix in 0.1 are rules 1–6.** That is the interior grammar and the errors, and it is cheap, because it reuses the list-item rule. Once lite has fixed how `<name …>` tokenizes and what tree it produces, a reader can attach meaning to it at any time without changing a single tree. That is the point of B2. The `std` library and vocabularies are the reader layer's companion, and the meanings in the table above *are* its first version. The `<{…}>` prose embed is the one piece I'd hold to 0.1 only if Joseph reads `<{…}>` as I do. Otherwise prose uses `|{date …}` with a collapse reading, and the embed waits for that question.

*Files: `nargs.py` (the prototype; `python3 -I nargs.py < cases.txt`), `cases.txt`, `cases.out.txt`.*
