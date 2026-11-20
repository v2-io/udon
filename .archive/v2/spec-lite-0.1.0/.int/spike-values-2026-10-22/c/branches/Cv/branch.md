# Branch Cv: a bare run is always text, and the reader brings the kind

*Spike c, fork "Cv" (Opus 5.5, 2026-10-22). Joseph's current lean (C with the view, 2026-10-21), pushed to its implications. Scores are this agent's hypotheses, with basis and confidence; nothing here was measured. Labels: **checked** (read in a card or file), **guess**, **taste**.*

## Landing, in one paragraph

The lean holds up, and it gets sharper once you decide what "the view" is. **The view works best as a typed read, not as a second tree**: `int(:port)` on the text `8080` gives 8080, and on `8080x` it gives an error at the call. That is the same move as Joseph's cardinality lean (2026-10-21: store vectors, and let strict getters raise "without touching the tree"). One principle covers both: **the tree records what was written, and the reader brings what it expects.** Under it, lite's `<…>` only has to carry the portable primitives (nil, booleans, numbers, delimited strings), committed at the `<` and an error on a mismatch. Every richer notation (dates, durations, units, `ssh`-or-22 ports) is written bare and typed by the slot. So the branch needs no dialect spelling inside lite at all, and a non-primitive interior like `<2026-01-10>` can be reserved (an error) without costing writers anything, because they write `2026-01-10` bare. The real cost is concentrated in one place: **schema-less data whose consumer needs numbers**, such as udon-to-JSON with no schema. There, every number and boolean needs `<…>`, or the converter has to classify bare runs, and classifying breaks the "bare is text" promise in exactly the cases where it mattered (`:version 1.10` → 1.1). I land on the converter emitting strings by default, with classification as an explicit opt-in, and I count the cost honestly in C1, A2 and A9.

## The decision points inside Cv, and where each went

### Cv.1: what the view is

| Option | What it is | Fate |
|---|---|---|
| **pull** | typed getters on the raw tree: `text(:port)`, `int(:port)`, `bool(:tls)`, each parsing the text by the standard notation and raising on mismatch | **chosen** |
| push | a second tree in which every bare run spelling a primitive has been converted | dropped: it puts back every trap the lean removed, whenever it's on (`:zip 01234`, `:version 1.10`, `:title 1984`), and "on by default" would be option B under another name |
| converter policy | what a tree-to-JSON/YAML tool does with bare runs when no schema is given | a separate decision (Cv.2) |

Why pull fits (taste, with one check). It is kind-first wherever it is used: the caller names the kind before it reads the value, so the slot supplies the kind, the cheapest place in `00-frame.md`'s geometry. It is also the cardinality-getter idea applied to kind: `value(:x)` raises on a stack, and `int(:x)` raises on `8080x` (checked: [[def:value]] working notes, 2026-10-21). And the gotcha Joseph called expected survives as reader behavior. `int(:height)` on `:height 7 ; px` gives 7. `int(:width)` on `:width 7 ;{px}` raises, because that text has an embed piece and isn't one run.

### Cv.2: the default for consumers that have no slot

The generic converter (lite to JSON with no schema) is the one consumer with no expectation to bring.

- **Strings by default, `--classify` to opt in** (chosen). This keeps "bare is text" true for every default consumer. A writer who wants a JSON number writes `<8080>`.
- Classify by default: concise, but `:version 1.10` → `1.1`, and a writer who learned "bare is text" is silently betrayed. Within Cv this is worse than B, because B at least *says* bare digits are numbers. Dropped.
- Classify only with a strict notation (no leading zeros, no `.10`-style trailing zeros?): it can't tell `1.10` from `1.5`, both valid floats. Dropped as unable to remove the trap.

### Cv.3: what `<…>` must carry for writers who have no slot

The minimum: `<nil>`, `<true>`, `<false>`, numbers, `<"…">`, and `<>` as nil (Joseph's lean, 2026-10-22). Each commits at its first character and is an error on a mismatch (his 2026-10-21 "<920px> error I can understand"). Two consequences:

- **Non-primitive interiors can be reserved.** `<2026-01-10>` → error ("lite has no date notation inside `<…>`; write it bare and let the slot type it, or quote it"). This passes B2 (reserve, don't ignore) at no writer cost, and leaves `<name:…>` free for full UDON (B6). It differs from today's card, which carries any interior as raw text ([[rule:opaque-span-raw-text]], provisional): under Cv a raw `<2026-01-10>` would be a fourth value kind with no meaning, which a later dialect would retype, changing the trees lite produced.
- **Sub-branch Cv.3b, the mark on a container: tried and kept as an option.** `<[1 2 3]>` asserts that every item is a primitive (committed, so `<[1 2 three]>` is an error at `three`). It cuts list plumbing from N marks to one. Its cost is one more thing `<` means, though it is the same meaning (assert primitives), distributed. Joseph's call. I lean mildly for it, because numeric arrays are where Cv's plumbing hurts most.
- **Sub-branch Cv.3c, a subtree-wide "classify my bare primitives" switch** (`|server.typed :port 8080`, or a directive): pushed and dropped. It is kind-first and concise, since it precedes the values, but it is a parse-mode directive in disguise. Lite has no directives (`!` is reserved), and a reader of `:port 8080` would have to look up the ancestors (A3). It belongs in full UDON as a directive, if anywhere.

### Cv.4: what the lean forces elsewhere (named for the sibling forks, not decided here)

- Bare `nil`, `true` and `false` are texts. Nil is spelled `<nil>` or `<>`. That reverses [[rule:nil-spelling]] (decided for this version). The bare-`null` warning becomes, if kept, a default-off "bare `nil`/`null`/`true` is text; did you mean `<nil>`?" (topic of `core`).
- [[rule:missing-value]]'s message names `nil`. Under Cv it would name `<>` (or `<nil>`), `''` and `\`.
- Keys and lists hold texts: `|step[1]` has key ‹1›, so `|step[01]` and `|step[1]` are *different* keys. **taste:** that is right for keys, since a key identifies and isn't arithmetic.

## The composite set, rendered

Tree notation as in the cards: `‹…›` text, `"…"` string, bare numerals for numbers, `nil`/`true` for those kinds.

```udon
|server :name web :port 8080 :host localhost :tls true :retries 3 :ratio 0.5 :zip 01234 :version 1.10 :note <>
|server :name web :port <8080> :host localhost :tls <true> :retries <3> :ratio <0.5> :zip 01234 :version 1.10 :note <>
|book :title 1984 :year <1949> :price <9.99>
|book :title 1984 is a novel
|cfg :tags [<1> <2> three] :alt <[1 2]>
|step[1]
|big :n <12345678901234567890123> :h <0xFF> :e <1e10> :z <-0>
|e :a <> :b "" :c <false> :d null
|t :on 2026-01-10 :at 2026-01-10T14:30Z :timeout 30s :span P1Y2M :d 27-03-05
|u :width 920px :timeout 5m :length 5m :share 50% :size 1.5GB
|svc :port ssh
|svc :port 22
|id :v 0x73DDF
|a Click here :href https://example.com
|li <https://example.com>
|h1 Chapter 3: The Return
|m :width 7 ;{px}
|m :height 7 ; px
```

| Item | Result under Cv | Verdict |
|---|---|---|
| E1, first line | every value a text except `:note` nil. A slot-typed reader gets 8080, true, 3, 0.5; zip ‹01234› and version ‹1.10› stay exact | **renders**, with no trap at all for zip or version |
| E1, second line (schema-less, JSON-bound) | port 8080, tls true, retries 3, ratio 0.5 typed in the tree | **plumbing: 4 marks for 10 facts** |
| E2 | title ‹1984›, title ‹1984 is a novel›, year 1949, price 9.99 | renders; the title can't be misread |
| E3 | tags [<1> <2> ‹three›]; with Cv.3b `<[1 2]>`; key ‹1› | renders with plumbing (a mark per item, or one with 3b) |
| E4 | integer past 2^64 carried exactly as a number kind with its spelling; the host mapping guide decides representation; `<-0>` and NaN depend on the `core` fork | renders; bare `12345…` would be an exact text, also lossless |
| E5 | nil, "", false, ‹null› (plus a warning if `core` keeps one) | renders; the JSON-habit `null` becomes text (near-miss, caught only by a warning) |
| E6 | all texts; a slot typed date/instant/duration parses them; **`27-03-05` as YY-MM-DD can't be stated in the document**, only in the slot's notation | renders the first four; **can't render the format choice without a slot** (`mark`'s territory) |
| E7 | all texts; `5m` minutes vs metres is resolved by the slot names `timeout`/`length` | **renders, the branch's best case**; no literal branch can resolve `5m` without the slot anyway |
| E8 | ‹ssh› and ‹22): the slot type u16 \| standard-port reads both | renders exactly as the domain thinks |
| E9 | ‹0x73DDF›; `i64` storage is the host's from the schema; `<0x73DDF>` gives an integer kind if `core` keeps hex | renders; the host type isn't stated in the document (deliberate: the ideation file's lean on H) |
| E10 | `|a :href https://example.com Click here` (the natural order) makes href ‹https://example.com Click here›, because the run reaches the next start. Written `|a Click here :href …` it renders. `|li <https://example.com>` is an **error** (`<` commits). `|li <= 5 items` is an error. `:alt 5 < 6` is fine. `Chapter 3:` is fine | the href near-miss is the bare-run rule, not Cv's; **the autolink collision is Cv's**, and it comes from making `<` a committing mark at a value's start. Caught (an error), not silent. Fix: `\<`, or quotes |
| E11 | both texts in the tree; `int(:height)` 7, `int(:width)` raises | renders; Joseph's gotcha survives at read time |
| E12 | not Cv's question. Noted for `mark`: the labels lean lets `:` be a bare label's last character (`.int/labels-ascii-and-positions-2026-10-20.md`), so `:host:` is the name `host:` unless the two are reconciled; `:xml:lang` needs `:` inside names | — |

## Card radius (checked against the cards on 2026-10-22)

Beyond what the lean already put on the cards:

| Card | Change | Firmness now |
|---|---|---|
| [[rule:unquoted-run-is-one-value]] | the view becomes the typed read (pull); Implications updated | lean |
| [[def:reading-option]] | the typed-primitive view leaves the list of reading-options; a typed read is an API expectation, beside the cardinality getters | provisional |
| [[rule:nil-spelling]] | nil is `<nil>` / `<>`; bare `nil` is text; the warning changes or goes | "decided for this version" (Joseph's 2026-10-09 call, revised 10-21) |
| [[rule:missing-value]] | the message names `<>` | decided for this version |
| [[rule:opaque-span-raw-text]] | `<…>` splits from `@{…}`/`;{…}`: primitives only, commit/error; any other interior reserved | provisional |
| [[def:typed-value]] | «implicit-typed-value» has no members: drop it; explicit = `<…>` primitives | provisional |
| [[def:value]] | the kind list stays; numbers, booleans and nil only via `<…>` | provisional |
| [[rule:key-holds-a-value]], [[rule:list-items-whitespace-separated]] | examples: `:$key 1` → ‹1›, list `3` → ‹3› | decided |
| [[rule:reserved-spellings]] | add `<` with a non-primitive interior | decided, needs-work |
| [[rule:inline-comments]] | the gotcha restated at read time | — |
| [[rule:value-line-escapes]] | loses one reason (escaping a leading digit) | proposed |
| [[obj:represent-structured-data]] | Statement 2 holds (marks decide kind); "the same data" now costs marks for schema-less use | force empty |
| `rule:bare-typing` (gap) | becomes "what may stand inside `<…>`" | gap |
| PEG (`.int/peg-2026-10-21.md`) | `number` leaves the bare-value production | provisional |

About 14 records, two of them decided by Joseph (nil spelling, missing value), plus a wording change in two decided rules' examples. **Impact radius: moderate.** The weight is mostly in reversing bare `nil`, which the lean already implies.

## Scores (0–10; hypotheses)

| | Factor (weight) | Score | Basis | Conf. |
|---|---|---|---|---|
| A1 | Agent-subjective (9) | 6 | one clean principle; but `<8080>` in data reads as plumbing to me, and `:tls <true>` looks fussy | low |
| A2 | Generative guessability (10) | 5 | JSON/YAML-trained writers will write `:port 8080` meaning a number and won't guess `<8080>`. The miss is kind-only and recovered by any slot-typed reader, but silent for a schema-less converter | medium |
| A3 | Cold comprehension (10) | 7 | with no exposure, a reader predicts `8080` is a number (a miss); after one sentence of exposure ("bare is always text"), every bare value reads right, and no spelling ever hides a kind | medium |
| A4 | Agentic readability (10) | 8 | fewer kinds to track per line; marks are visible and rare outside data | medium |
| A5 | Domain-forward (9) | 7 | 9 where a slot exists (E6–E8: ports, units, dates read as the domain thinks); 4 for schema-less data | medium |
| A6 | Spec clarity (9) | 9 | the spine is one sentence: bare is text, `<…>` is the only kind mark, the reader brings the kind | high |
| A7 | Syntactic simplicity (8) | 9 | no number grammar on the bare path; the number grammar exists only after a committing `<` | high |
| A8 | Parsimony (8) | 8 | `<` has one role (assert a primitive) | medium |
| A9 | Conciseness (6) | 5 | schema-less data pays a mark per number and boolean | high |
| A10 | Self-description (5) | 5 | kinds live in slots outside the document | medium |
| A11/A12 | Human read / write (5/2) | 7 / 6 | `<3>` is easy to type and read | low |
| B1 | Bounded streaming (veto) | **pass** | a bare run's kind is known at its first character (text); `<` commits | high |
| B2 | Reserve, don't ignore (veto) | **pass** | if non-primitive `<…>` interiors are errors (Cv.3); fails if they stay raw | high |
| B3 | Stability (10) | 9 | one tree; nothing classified in it. Different readers may type differently, but that's outside the tree | high |
| B4 | Errors that teach (8) | 7 | `<920px>`, `<2026-01-10>` and `|li <https://…>` all error with a fix; the JSON-habit bare number is silent | medium |
| B5 | Parse speed (9) | 9 | bare runs are never classified; conversion is paid only on typed reads | medium |
| B6 | Headroom (7) | 8 | `<…>` spends only the primitives; `<name:…>` stays free | medium |
| B7 | Size (3) | 7 | marks cost bytes only in schema-less data | medium |
| C1 | Structured data (10) | 5 | lossless, and no zip/version traps; but JSON fidelity needs marks or an opt-in classifier | medium |
| C2 | XML/HTML (10) | 8 | XML attribute values are all strings, typed by the schema: Cv is XML's model. Cost: `<…>` at a value's start collides with tags and autolinks (caught) | medium |
| C3 | Markdown (9) | 8 | same autolink collision in sameline text; prose is unaffected | medium |
| C4 | Types, notations, units (8) | 6 | all carried, by the slot; nothing can state a notation in the document (E6's YY-MM-DD) | medium |
| C5 | Schemas, slot types (8) | 9 | the branch's center: a slot type reads a text in its own notation | medium |
| C7 | Predictable tree/API (8) | 9 | typed reads and cardinality getters are one API idea | medium |
| C10 | Round-trip (7) | 9 | spelling and form kept; nothing converted | high |

## What I'd put to Joseph

1. Is the view a typed read (`int(:port)`, raising like the strict cardinality getters) rather than a converted tree? (My lean: yes.)
2. Should the generic converter emit bare runs as strings by default, so that "bare is text" stays true for every default consumer, with classification opt-in? Or is that too high a price for JSON-shaped data?
3. Should a non-primitive `<…>` interior be an error (reserved) rather than raw? Under this branch nobody needs it raw, because dates and units go bare.
4. Should `<[1 2 3]>` assert a whole list of primitives?

## On deep forking

I didn't fork further. As a fork, the harness's instructions told me not to spawn agents, so the experiment stops at one level here. I branched in this file instead (Cv.1–Cv.4, with 3b and 3c as sub-branches).
