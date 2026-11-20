# Branch B: the whole run decides, in the tree

*Spike c, fork "B" (Opus 5.5), 2026-10-22. The job: strengthen before softening, applied to the abandoned option. Make whole-run classification (bare `8080` is an integer, `920px` is text) work under CTQ B1, or find exactly where it breaks. Option A is scored here too, so the reason it died is on record. Labels: **checked** means I ran or read it, **reasoned** means an argument I didn't execute, **taste** means my judgment. Scores are my hypotheses, with a basis and a confidence.*

*Deep-forking note for Joseph's experiment: this fork did **not** fork further. The harness gives a worker fork a standing rule not to spawn agents ("you ARE the fork, execute directly"). So in this harness forks run one level deep, at least when launched as `fork`.*

## The rule, stated as strongly as I can make it

> **B\*.** On an element's or attribute's line, an unquoted run (its extent exactly as in [[rule:unquoted-run-is-one-value]] §1) is a **primitive** when its whole spelling, trimmed, is at most *N* characters and matches the primitive grammar exactly. Otherwise it is a «text». The tree keeps the spelling of every primitive; nothing is ever converted.

Three features carry it:

1. **The extent doesn't depend on the kind** (reasoned, and easy to check). No primitive spelling contains a space, so the run ends where it would for text. Classifying never moves a boundary or changes structure, and `1984 is a novel` is one run either way.
2. **Strict spelling** (illustrative here; the real set is the `core` fork's question). No leading zeros (`01234` is text), no `+`, no `.5` or `5.`, no doubled or trailing `_`, no `NaN` or `inf`, and keywords lower-case only. Every near-miss falls to text, never to an error and never to a different number.
3. **Spelling kept, never converted.** The old line did this too, emitting a type tag plus a slice. It is what separates B from YAML's Norway problem. YAML *converts* and loses the spelling (`3.10` becomes `3.1`). Under B, `:version 1.10` is a float whose spelling is `1.10`, so a reader who wants the string gets `1.10` back exactly.

## Does it pass B1?

Run `classify_stream.py` in this directory with `python3 -I`. **Checked:**

- A hand-written classifier with a constant amount of state (one state name, a keyword pointer and a counter) agrees with a regex reference on 200,000 random spellings, and also when the same spellings are fed in random chunks: 0 mismatches. So the classification is a finite-state scan that carries across chunk seams.
- **Kind-at-close wire.** The parser forwards each chunk the moment it arrives and announces the kind at the run's close. It holds **0 bytes** for typing, and that includes Joseph's `4938222…2412124p`.
- **Kind-first wire with a spelled cap *N*.** The emitter holds the run only while it could still be a primitive, so it holds at most *N*+1 bytes. On the 117-byte adversarial run: 33 bytes held at *N*=32 and 65 at *N*=64. Past the cap the run is text by rule, so its kind is known.
- From the coordinator's own probe (`c/checks/holdback-probe.rs`, relayed to me, not re-run by me): the 0.9 pushdown parser emits nothing until the terminator for a 1 MB bare text run, a digits-then-`p` run, a digit integer, a prose line and a quoted string. **Today's text is held whole, the same way.** The holdback Joseph objected to in B is not something B adds. The parser already has it for every value.

**Where B1 actually bites (reasoned; this is the precise break point).** B holds a bounded number of *bytes*, but the number of *characters it scans before deciding* is not bounded, because of whitespace. To tell `1984` from `1984 is a novel` the classifier has to look past the space. Trailing ornament (`:port 8080`, then 400 spaces of alignment, then the end of the line) holds the decision open across the spaces. It can do that with a counter rather than the bytes, so memory stays bounded. Committing the kind at the first space would end the deferral, but then `:count 7 apples` gives `7`, with `apples` falling to `$main`: the PEG audit's `1984` finding, the very failure B exists to prevent. **So the whitespace deferral can't be removed from B.** Every option defers a value's *extent* across the same spaces. Only B also defers its *kind* there.

- If B1 means **memory held** (bytes, so no DoS and no unbounded buffer), B\* with a cap passes, and B with a kind-at-close wire passes without one. That is the reading Joseph's own reason supports: "if the streaming parser is forced to **buffer** essentially unlimited amount of the incoming stream … room for DoS type attacks and buffer overflows."
- If B1 means **characters until the kind is known**, as `CTQ-FACTORS.md` words it ("No construct holds an unbounded stretch before its kind is known"), B fails on whitespace alone, cap or no cap.

That is the question Joseph would need to answer. It is a one-word difference in B1, and B lives or dies on it.

## Costs that remain once B1 passes

- **The cap is a cliff** (taste: small but real). Spelled in the spec it gives one tree in every parser (B3), but *N* is arbitrary at its edge. A 256-bit hash written `0x` + 64 hex digits (66 characters) is an integer at *N*=128 and text at *N*=64. Either answer is defensible, and a writer who means a hash probably wants text. A wire that announces the kind at the close needs no cap.
- **The tree asserts a kind the writer may not have meant.** `:title 1984`, `:zip 12345` and `:version 1.10` become integer, integer and float. With the spelling kept, nothing is lost, so the harm is limited to:
  - a converter with no schema, which emits `{"title": 1984}`. JSON has exactly this convention: quote it if you mean a string;
  - a reader who trusts the kind over the slot. A schema'd reader has to read the **spelling** for a text slot, so slot types take the spelling, not the kind. Under B, then, the kind is the answer for a reader with no schema and only advice for one with a schema.
- **`$main` gets typed too:** `|h1 1984` gives `$main` an integer, and so does `|td 3.50` (spelling `3.50`). That does no harm to XML or Markdown output, which writes the spelling, but it is odd to see a heading's text carry a number's kind. Exempting `$main` would add one exception (A7), and `|el 1 \ 2` would lose its typed stack. I would not exempt it (taste).
- **The bare set is frozen forever** (headroom). A later UDON can't make bare `2026-01-10` a date without changing lite's trees. C freezes it equally, since there bare is text forever.

## The composite set under B\*

Tree notation: `‹…›` is a text, and `::kind` marks a primitive (spelling kept). `<…>`, notations and the trailing colon belong to the `mark` fork, and the standard set to the `core` fork. I show them only where B changes something.

```udon
|server :name web :port 8080 :host localhost :tls true :retries 3 :ratio 0.5
  :zip 01234
  :version "1.10"
  :note nil
|book :title "1984" :year 1949 :price 9.99
|book :title 1984 is a novel
|el :tags [1 2 three]
|step[1]
|n :big 12345678901234567890123 :hex 0xFF :sci 1e10 :negz -0 :nan NaN :null null
|size :width 920px :timeout 5m :share 50% :disk 1.5GB
|svc :port ssh
|svc :port 22
|v :width 7 ;{px}
|v :height 7 ; px
|h1 Chapter 3: The Return
|alt :text 5 < 6
```
```tree
root
  |server
    :name ‹web›  :port 8080::integer  :host ‹localhost›  :tls true::boolean
    :retries 3::integer  :ratio 0.5::float
    :zip ‹01234›                  ← leading zero: text, no trap
    :version "1.10"::string       ← quoted, because the writer means a string
    :note nil::nil
  |book  :title "1984"::string  :year 1949::integer  :price 9.99::float
  |book  :title ‹1984 is a novel›
  |el    :tags [1::integer 2::integer ‹three›]
  |step  :$key 1::integer
  |n     :big 12345678901234567890123::integer   ← host guide: past i64
         :hex 0xFF::integer  :sci 1e10::float  :negz -0::integer
         :nan ‹NaN›  :null ‹null› + warning "write nil"
  |size  :width ‹920px›  :timeout ‹5m›  :share ‹50%›  :disk ‹1.5GB›
  |svc   :port ‹ssh›
  |svc   :port 22::integer          ← the u16 arm, already discriminated
  |v     :width ‹7 ;{px}›           ← a piece is an embed, so text
  |v     :height 7::integer  (framed comment attached)
  |h1    :$main ‹Chapter 3: The Return›
  |alt   :text ‹5 < 6›
```

| Item | Under B\* |
|---|---|
| E1 | renders with no plumbing. The writer quotes `"1.10"` (JSON habit). **Near-miss trap:** `:version 1.10` unquoted gives a float spelled `1.10`. That is lossless in the tree but becomes `1.1` in a schema-less JSON output. |
| E2 | renders. **Near-miss:** `:title 1984` gives an integer (lossless, kind wrong for the intent). |
| E3 | renders. The list items and the key are typed per item. |
| E4 | renders. A big integer goes through the host mapping guide. NaN is text (no specials). |
| E5 | `nil`, `""` and `false` render. `null` is text with the existing warning. |
| E6, E7 | all text. Under B, as under C, a notation needs a mark or a slot. B neither helps nor hurts here. |
| E8 | renders, and the slot gets `22` already discriminated as the integer arm. |
| E9 | bare `0x73DDF` is an integer. The storage type is the slot's business, and no host mark is needed. |
| E10 | `5 < 6` and `Chapter 3: …` are text. The autolink `<https://…>` and `<= 5` are the `mark` fork's (`<` is a start in every option). |
| E11 | exactly as Joseph called it: text, then the integer 7. |
| E12 | not B's question. |

## Option A, for the record (the first character commits)

A digit (or `-`) commits to a number. A bad continuation is an error, or under the one-value lean the residue falls to `$main`.

- `:width 920px` is an **error**. Joseph: "in notation there are units all the time-- 920px 920MB."
- `:title 1984 is a novel` gives `1984` plus `$main ‹is a novel›` **silently**: the worst kind of miss under A2.
- `|h1 2026 in review` and `|li 3 apples` get the same split in headings and list items (C2, C3).
- `:zip 01234` is an error or `1234`, and `:version 1.10` is a float.

A passes B1 trivially (lookahead 0 to 1) and fails A2, A3, C2 and C3 on ordinary documents. It died for least surprise, which is the right reason, and nothing here revives it.

## Scores (my hypotheses; weights from CTQ-FACTORS)

C is shown for contrast only, as I estimate it. The `Cv` fork scores it properly. "C-lean" means bare is text, with a typed-primitive view.

| Factor (weight) | B\* (cap) | B (kind-at-close) | A | C-lean (contrast) | Basis; confidence |
|---|---|---|---|---|---|
| B1 bounded streaming (veto) | **pass** on memory; **fails** if B1 counts characters to kind (whitespace) | same, with no cap | pass | pass | checked (script, plus the coordinator's probe); the reading is Joseph's call |
| A1 agent-subjective (9) | 8 | 8 | 4 | 7 | taste: unmarked data reads as data; medium |
| A2 generative guessability (10) | 8 | 8 | 3 | 6 | a JSON/TOML-trained writer writes `:port 8080` and quotes strings: that is B. Under C, a writer who wants a number has to learn `<8080>` or rely on a view; medium |
| A3 cold comprehension (10) | 8 | 8 | 4 | 7 | a cold reader assumes `8080` is a number (my own instinct); medium |
| A4 agentic readability (10) | 8 | 8 | 7 | 8 | same lines; low variance |
| A5 domain-forward (9) | 7 | 7 | 6 | 8 | B puts the kind in the spelling, not the slot, though with no plumbing; medium-low |
| A6 spec clarity (9) | 7 | 7 | 7 | 7 | B: one sentence plus a grammar (plus the cap). C: the same grammar for the view plus the concept of a view; low |
| A7 syntactic simplicity (8) | 7 | 8 | 7 | 8 | the cap is a rule; medium |
| A8 parsimony (8) | 9 | 9 | 9 | 7 | no characters spent on primitives; high |
| A9 conciseness (6) | 9 | 9 | 9 | 6 | `<8080>` vs `8080` wherever the view isn't trusted; high |
| B3 stability (10) | 8 | 9 | 7 | 8 | the cap must be spelled, or trees fork by implementation; medium |
| B4 errors that teach (8) | 7 | 7 | 6 | 7 | B makes near-misses text, which can warn ("`0755` is text; did you mean 755?"), default-off; medium |
| B5 parse speed (9) | 8 | 8 | 9 | 9 | a finite-state scan over bytes already scanned; low (not measured) |
| B6 headroom (7) | 6 | 6 | 6 | 7 | B freezes the bare set in the grammar, C only in readers' habits; low |
| C1 structured data (10) | 9 | 9 | 5 | 6 | JSON ↔ lite is lossless with JSON's own quoting convention; high |
| C2 XML/HTML (10) | 7 | 7 | 4 | 9 | typed `$main` is odd but harmless; medium |
| C5 slot types (8) | 7 | 7 | 6 | 9 | needs "slots read the spelling"; medium |
| C10 round-trip (7) | 9 | 9 | 8 | 9 | spelling kept; high |

Rough weighted reading (taste, not arithmetic to trust): **B\* and C-lean come out close.** B wins on data (C1, A2, A9, A8) and C wins on mixed content and slots (C2, C5, A5). A is clearly last. **Nothing in this table is decided by streaming.** Once B1 is read as memory, B passes it.

## What I take from this

1. **The B1 objection to B rested on a premise the reference parser doesn't meet.** Text is held whole too. With a kind-at-close wire, B holds zero bytes for typing. A kind-first wire with a spelled cap holds at most *N*+1. *Checked* (script here; holdback probe by the coordinator, relayed).
2. **The one place B cannot be made bounded** is the *characters scanned before the kind is known*, across whitespace. That deferral is exactly what makes `1984 is a novel` a title, so B can't drop it. Whether B lives comes down to the wording of B1: memory, or characters until the kind is known.
3. **If B lives, the real choice between B and C-lean is not about streaming.** It is about where the kind lives:
   - in the tree, so every reader gets the same answer and it matches JSON's priors (B);
   - with the reader, so the slot decides and nothing is asserted that the writer didn't mark (C).

   A schema-less converter gets *some* writer's intent wrong under either. B gets the `:title 1984` writer wrong, and C-without-view gets the `:port 8080` writer wrong.
4. **B's structural cost is small:** a regular grammar, one optional cap sentence, and the "spelling kept, slots read spelling" contract. It makes `<…>` unnecessary for numbers, booleans and nil, which leaves `<…>` (or whatever the `mark` fork lands on) entirely for notations. That is a real simplification for the `mark` branch to weigh.
