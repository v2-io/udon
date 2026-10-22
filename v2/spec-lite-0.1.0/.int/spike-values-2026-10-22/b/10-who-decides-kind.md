# Branch page: who decides a value's kind (D1, D2, D3)

*Spike b, 2026-10-22. Labels: **[checked]** against a file or source; **[inferred]** my reasoning; **[taste]** my preference; **[hyp]** a score or estimate with no measurement behind it. Trees use the cards' current notation: `‹…›` a «text», `"…"` a string, a bare number or `true`/`nil` a value of that kind; `⇒` marks what the default reading gives.*

## 1. The decision collapses to one bit and one set

Three facts, together, take most of the A/B/C dispute apart.

**(a) Every branch keeps the spelling.** [checked] The old parser emitted a kind tag plus a zero-copy slice (`old-numeric-typing.md` §1, "What 'parsed to' means here"). The lite lean keeps the spelling as a «text». The 0.9 tree held `Value::Integer(Cow<str>)`. No branch on the table loses `8080` as written.

**(b) Bounded streaming does not separate B from C.** [ran, by fork S: `fork-S-streaming.md`] The 0.9 pushdown parser, fed 200 KB runs in 1 KB chunks, emits no content event before a run ends: digits, letters, `4…4p`, spaced text, prose and quoted strings alike. Joseph's `4938…2p` is held whole today and comes out as `BareValue` at the `p`. Both B and C hold exactly one run, and in lite a run never crosses its line, so both are bounded by the line. If the wire ever emits content in fragments, C streams text from the first character and B streams the same text with its kind as a trailer, and a finite automaton running alongside costs O(1). Either way the information, the order and the memory are the same. The streaming question that *is* real, whether content is emitted in fragments or the line is capped, is independent of typing. Today the only cap is the recursive wrapper's 4 KB line buffer; the pushdown parser has none ([checked] `parser.rs` 7857 `with_max_buffer(4096)`; no cap found in `parser_pd.rs`).

**(c) The view is a default schema.** A slot that has no type still gets read somehow, by whoever reads it. The "typed-primitive view" is that reading. [checked, YAML 1.2.2 §3.3.2, read by me and by fork R] This is YAML's architecture: a plain scalar gets the non-specific tag `?`, a quoted one gets `!` (a string), and resolution "must only depend on … (1) the non-specific tag of the node, (2) the path leading from the root to the node and (3) the content". The path is the slot. YAML's failures came from its default schema's breadth (`yes`, `~`, `Null`) and from having more than one schema, across 1.1 and 1.2 loaders. Fork R's table (`fork-R-precedents.md`, "The convergence") places lite's lean: text in the tree, with a conservative JSON-sized default reading. No system it checked does exactly that; the nearest is YAML resolving by path with a smaller schema.

What remains is:

- **one bit:** in the absence of a slot type, is a bare `8080` read as a number or as text? and
- **one set:** which spellings that reading recognizes.

Everything else (whether the parser or a view does the reading, whether the kind comes first or last) is either the same design described twice, or plumbing.

## 2. The hazard that decides the bit: `:debug false`

The bit is usually argued on `:port 8080`, where either answer is harmless; Joseph's "ensure the ports add up" function works both ways. The example that decides it is the boolean:

```udon
|server :name web :port 8080 :debug false
```

If bare runs are read as text wherever no slot type is known (branch β4 below):

````tree
root
  |server
    :name ‹web›
    :port ‹8080›
    :debug ‹false›
````

A schema-less consumer in any dynamic language (Python, Ruby, JS, Elixir) that writes `if server["debug"]` gets the *non-empty string* `"false"`, **which is truthy**. [ran: the string `"false"` is truthy in Python, JS (node), Ruby and Elixir.] A JSON export writes `"debug": "false"`. The failure is silent: no error, a different meaning, in the most common configuration line there is. The CTQ weights silent misses above errors (A2, A3 footnotes). And E1-style data (C1, 10) is exactly where people will write it.

The opposite hazard, reading numeric-looking text as a number, is real too (E2):

```udon
|pkg :version 1.0 :zip 01234 :sha 1234e56
```

Read as JSON numbers, `1.0` becomes a float (JS prints it `1`), `1234e56` becomes 1.234e59, and `01234` is either 1234 or an error. These hazards are less frequent than booleans and nils, and the next section removes most of them.

**So:** text-by-default trades a rare hazard for a frequent one. [inferred; the frequency is my own instinct as a writer of this kind of data, not a sample: asked to write a server config in lite cold, I would write `:debug false` bare without a second thought, and I would have to stop and think to remember to quote a version. Per Joseph's note, the corpus's own documents are not evidence here, and none was used. Confidence moderate-high.]

## 3. Which set: the lossless criterion picks JSON's grammar

A default reading is a guess the writer didn't assert. A guess should be **lossless**: reading it back to a spelling gives the spelling written. That gives a test for each candidate member:

| Spelling | Lossless in every host? | Default-read? |
|---|---|---|
| `true` `false` `nil` | yes | **yes** |
| `-?(0\|[1-9][0-9]*)` integers | yes (with bignums; the host mapping guide handles 2^53) | **yes** |
| `0755`, `007`, `01234` (leading zero) | no: 755, 7, 1234 | **no, stays text** |
| `1_000_000` | no (the underscores are lost) | no (but see `<…>`) |
| `0xFF` | no (255) | no (but see `<…>`) |
| `+5`, `.5`, `5.` | no | no |
| `0.75`, `1.5e-3` | yes for shortest-repr hosts, mostly | **yes** |
| `1.0`, `1.50` | no in JS (`1`, `1.5`) | edge, see below |
| `2026-01-10` | host date types disagree | no |
| `920px`, `1/3r`, `3+4i` | no host equivalent | no |

What survives is, almost exactly, **JSON's number grammar plus `true`/`false`/`nil`** (RFC 8259 §6: `-? (0 | [1-9] DIGIT*) (. DIGIT+)? ([eE] [+-]? DIGIT+)?`). [checked: RFC 8259 §6 ABNF, fetched today: `number = [ minus ] int [ frac ] [ exp ]`, `int = zero / ( digit1-9 *DIGIT )`, "Leading zeros are not allowed."; no `+`, no bare `.5` or `5.`.] That is the most-trained number grammar any agent has seen, so it costs nothing in guessability, and its surprises are the ones agents already expect.

**The `1.0` edge.** JSON allows `1.0`; a lossless-only rule would refuse it. Two sub-branches:

- **β3a, JSON exactly.** `1.0` reads as a number. `:version 1.0` is the residual hazard; slot types fix it.
- **β3b, canonical-only.** A fraction with a trailing zero stays text. `:version 1.0` would stay text, but so would `:ratio 1.0`, which is a real float, and `:version 2.5` would read as a float anyway, which is inconsistent. **Pruned:** too clever. It costs A6 and A7 to fix one case, and it fixes it inconsistently. [taste + inferred]

## 4. The branches, pushed

### β1: first character commits (A)
`:size 920px` is an error. Joseph rejected it ("in notation there are units all the time"), and it fails E3 and E7 (`1984 is a novel`). **Dead**, for the reason he gave. Kept only for completeness.

### β2: whole-run typing by the old line's rich set (B-rich)
The run is read by `values.desc`'s set: hex, underscores, rationals, complex, durations, dates. Every surprise in `old-numeric-typing.md` §5 applies to undeclared text: `30s` is a duration, `5m` means minutes, `1d12h` is two values, `$9.99` absorbed (later fixed), `:version 1.0` a float. Each one is a silent different reading of text the writer never asserted. **Dead on B3 and A3**: the rich set is fine as an *assertion* (β3's `<…>`) and harmful as a *guess*. It dies, but the finding is that it belongs inside the assertion, not that it's wrong.

### β3: spelling kept; one normative default reading by JSON's grammar; assertions in `<…>` (recommended)

- **Raw tree:** a bare run is a «text», as the 2026-10-21 lean says. Nothing in the parser changes.
- **Default reading (normative, frozen, on wherever no slot type is known):** a «text» that is exactly one plain run spelling `true`, `false`, `nil`, or a JSON number reads as that value. Anything else, including a run with an embed, an inline comment or a space, stays text.
- **Slot types override** the default reading (next page): a slot of type text reads `1.0` as the text `1.0`.
- **Delimited values are never re-read.** `"8080"` is a string and stays a string; `<8080>` is an asserted number. The writer's assertion beats the reader's guess.
- **`<…>` holds the rich set, strictly checked**: `0xFF`, `1_000_000`, `0o755`, with commit and error, as Joseph has it ("now we *can* commit/error"); empty `<>` is nil.

Rendered:

```udon
|server :name web :port 8080 :debug false :owner nil :ratio 0.75 :tags [a b 2]
|pkg :version 1.0 :zip 01234 :mode <0o755> :mask <0xFF> :big <1_000_000>
|item :count 7 apples :size 920px :width 7 ;{px}
|book :title 1984 is a novel :year 1949
|q :x "8080" :y <8080> :z <>
```
````tree
root
  |server
    :name ‹web›
    :port ‹8080›          ⇒ 8080
    :debug ‹false›        ⇒ false
    :owner ‹nil›          ⇒ nil
    :ratio ‹0.75›         ⇒ 0.75
    :tags [‹a› ‹b› ‹2›]   ⇒ [‹a› ‹b› 2]
  |pkg
    :version ‹1.0›        ⇒ 1.0           ← the residual hazard; a slot type fixes it
    :zip ‹01234›          (leading zero: stays text)
    :mode 0o755           (asserted; the integer 493, spelling kept)
    :mask 0xFF
    :big 1_000_000
  |item
    :count ‹7 apples›
    :size ‹920px›
    :width ‹7 ;{px}›      (a comment piece: not one plain run, stays text)
  |book
    :title ‹1984 is a novel›
    :year ‹1949›          ⇒ 1949
  |q
    :x "8080"             (asserted string; never re-read)
    :y 8080
    :z nil
````

Composite lines, mixing this with other rules:

```udon
|el :c 1 z              ; ‹1 z›: not one run, stays text
|el :c 1 \ z            ; :c ‹1› ⇒ 1, then $main ‹z›
|el :height 7 ; px      ; :height ‹7› ⇒ 7, framed comment attached
|li Note: keep it dry   ; $main ‹Note: keep it dry›, the label-colon warning (default-off)
|el :a null             ; ‹null›, stays text, the existing warning ("did you mean nil?")
```

**What β3 does to existing cards** (impact radius; [checked] against each card's text):

- [[rule:unquoted-run-is-one-value]]: the Statement is unchanged. Implication 5's view becomes the normative default reading, defined with JSON's grammar.
- [[def:reading-option]]: the typed-primitive view leaves the reading options (it is no longer optional) and becomes a rule, perhaps `rule:default-reading`, filling the `rule:bare-typing` gap.
- [[rule:nil-spelling]]: **unchanged**. Bare `nil` reads as nil; `null` stays text with its warning. Its "to ask" note dissolves.
- [[rule:missing-value]]: **unchanged**. The message's `nil` reads as nil. Its "to ask" note dissolves.
- [[rule:opaque-span-raw-text]]: `<…>` leaves the opaque spans. It becomes an asserted literal with the rich set, empty = nil, and labels per fork P and the D5 page.
- [[def:typed-value]]: the explicit/implicit split becomes **asserted** (delimited) vs **bare**. That also answers the card's own worry that "implicit" suggests inference, since bare is now honestly a reading.
- [[obj:represent-structured-data]] Statement 2 ("each value's kind decided by how it is written") holds, more precisely: by form, and for bare by a fixed grammar.

The impact radius is *smaller* than pure C-without-view. Two decided cards (nil-spelling, missing-value) keep their meaning instead of growing `<nil>` questions. [inferred]

### β4: spelling kept; no default reading; slot types and getters only (C, view off)
Clean in principle: nothing is a guess. In practice it brings the `:debug false` hazard (§2) to every schema-less consumer, and JSON export of every bare value is a string. A writer who wants JSON types without a schema writes `:debug <false> :port <8080> :owner <nil>`, which is plumbing per fact (A5) and a guessability failure (A2): agents will write `false` bare, get a string, and get no error. **Attempts to make it work:**

- *A warning on every bare run that spells a primitive* ("did you mean `<false>`?"). It fires on most lines of every config document, so either it is default-off and catches nothing, or it is default-on and is noise. Fails B4.
- *Generic consumers refuse instead of guessing*, as YAML 1.2's JSON schema errors on an unmatched plain scalar (fork R §1): JSON export of a bare `false` with no slot type is an error. That is honest, but the most common line in config then needs a schema or a mark before it can be exported. Fails A5 and C1.
- *Strict getters only* (β7 without a default): fine for code that knows its slots, but it leaves export, display and dynamic access unanswered. That is the case §2 is about.

Each attempt either reintroduces a default reading by another name or moves the cost onto the commonest line. **Pruned on C1 and A2**, with the finding: **a notation that has bare booleans in its users' training cannot leave them unread.**

### β5: spelling kept; the view optional, consumer's choice (the lean as written today)
Under β5, `:debug false` is `false` to one consumer and `"false"` to another, from the same document and the same parser. B3's letter ("one tree") holds; its intent (one meaning) doesn't. Choosing on or off per consumer gives each consumer one of the other two branches. **Pruned**: it is β3 or β4 per consumer. It adds variability and settles nothing. The finding is that the lean's open bit ("whether the view is on by default") *is* the whole decision, and it has to be normative to be a decision.

### β6: frame rejection, no primitives in lite at all
Lite has only text, string, list and element; every kind comes from a schema. This is β4 plus removing primitive assertions from `<…>`. It is the most parsimonious. It fails C1 harder than β4, because there would then be no way to write a JSON `false` without a schema. **Dead on C1** (weight 10).

### β7, a reframe that lives inside β3: **kind by strict getter**
Joseph's "cardinality by API, not by shape" (2026-10-21: strict getters that raise without touching the tree) has an exact twin for kinds. `get_bool(:debug)`, `get_int(:port)` and `get_text(:version)` declare the slot type at the point of use. A getter *is* a slot type, written where the consumer already is, with no schema file. The default reading is what the *generic* getter (and JSON export) uses. Each strict getter reads the spelling by its own notation and errors on a mismatch: `get_int` on `‹1.0›` errors ("did you mean 1?"), and `get_text(:version)` returns `"1.0"` whatever the default reading says. This is how XML's DOM, INI files and environment variables have always worked. It is the lightest possible form of a slot type (A5): no declaration, no plumbing in the document. [inferred; taste: I find this the most elegant piece of the whole space, because it reuses a pattern Joseph already chose.]

## 5. Scores [hyp]

Single-agent hypotheses, 0–10 per factor. Each basis is in brackets and the confidence is noted. Only factors where branches differ are shown; the vetoes are listed separately.

**Vetoes.** B1 (bounded streaming): every branch passes, subject to fork S. B2 (reserve, don't ignore): β3 passes only if `<…>` errors on interiors it doesn't define; the rest pass.

| Factor (weight) | β2 rich | **β3 JSON** | β4 no default | β5 optional | basis |
|---|---|---|---|---|---|
| A2 guessability (10) | 5 | **9** | 4 | 5 | β3's bare set is JSON's; β4 fails the bare `false` everyone writes; β2's suffixes and dates aren't guessable |
| A3 cold comprehension (10) | 4 | **8** | 6 | 5 | β2 reads `30s` and `5m` silently; β3's only silent surprise is `1.0` |
| A5 domain-forward (9) | 6 | **8** | 5 | 6 | β4 forces `<false>` plumbing |
| A6 spec clarity (9) | 3 | **8** | 8 | 5 | β3's spine: "bare reads as JSON reads; `<…>` asserts" |
| A7 simplicity (8) | 3 | **8** | 9 | 6 | β4 has one fewer rule; β2 has a 21-state value machine |
| B3 stability (10) | 6 | **9** | 9 | 4 | β5 gives two meanings per document |
| B4 errors that teach (8) | 4 | **8** | 5 | 5 | β3's strict `<…>` errors can say "did you mean"; β4's failures are silent |
| C1 structured data (10) | 8 | **9** | 4 | 6 | JSON round-trip without plumbing |
| C10 round-trip (7) | 6 | **9** | 9 | 8 | lossless default |
| D2 host mapping (7) | 4 | **9** | 9 | 7 | the JSON core maps everywhere |
| **weighted sum** | 437 | **748** | 585 | 492 | 88 × 10 = 880 max over these factors (sums recomputed by script) |

Confidence: the **ranking** β3 > β4 > β5 > β2 is moderate-high. The margins are low-confidence. The β3/β4 gap rests almost entirely on the `false` hazard's frequency, which is a judgment, not a measurement. β1 and β6 are dead on factors Joseph has already spoken to.

## 6. What this asks of Joseph

1. **The bit, put as an example:** `|server :debug false` with no schema: should a generic consumer see `false` or `"false"`? (β3 says `false`; the current lean leaves it open.)
2. **The set:** is JSON's number grammar, plus `true`/`false`/`nil`, the right default reading? Leading-zero integers stay text (zip codes, file modes), and `0xFF` and `1_000` need `<…>`.
3. **Strict getters for kinds**, as the twin of his strict getters for cardinality.

## 7. Open edges I did not close

- **Keys:** should `|step[1]` get the default reading? Keys are identity, and identity compares spellings, so I'd guess not (`[1]` and `[01]` are different keys). [hyp]
- **Whether the default reading's result appears in fixtures** (a second line per value), or whether only the raw tree is shown and the reading is a function the spec defines. I lean to the second (A6: one tree per fixture). [taste]
- **List items** read item by item (`[a b 2]` ⇒ `[‹a› ‹b› 2]`). That seems right, but a mixed list is a JSON smell. [hyp]
