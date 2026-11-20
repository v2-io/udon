# ANG-4c: `<…>` as a value fence, closed when unlabeled

*The branch this fork recommends. Fork `angle` of spike a, 2026-10-22. Scores and their basis: [scores.md](scores.md). The reasoning it rests on: [functions-and-the-no-go.md](functions-and-the-no-go.md).*

## The rule, as a card might state it

Inside `<…>` (one line, matched brackets nest, escapes as today), the first character after `<` decides, and the decision is never revisited:

| Starts with | It is | Otherwise |
|---|---|---|
| `>` | **nil**: `<>` (Joseph's lean) | |
| `"` or `'` | a **delimited string**; `>` must follow its closing quote | error |
| a digit, `+`, `-` or `.` | a **number** by the standard set's number grammar; the whole interior must match | error: "isn't a number; did you mean …?" |
| a letter | `nil`, `true` or `false` if that is the whole interior; or a **notation**: a label, optional `[key]`s and `.trait`s, then `:` and a space, then a **body** to the matching `>` | error: "did you mean `"…"` for text, or `<name: …>`?" |
| anything else | error (reserved) | |

A notation's head is read by the label rules; its body is carried as raw text, unread. Which notations exist, and what their bodies mean, is up to a handler for the name, as with fences ([[rule:fence-default-handler]]). Lite's default handler carries every name.

In one line: **unlabeled `<…>` is closed (the standard set, asserted); labeled `<name: …>` is open (carried for whatever reads `name`).**

## The composite set

Bare values are drawn under Joseph's current lean (a bare run is a «text»; the typed-primitive view noted at the right). If DP1 lands elsewhere, the bare lines change and the `<…>` lines don't. Tree glyphs follow the 2026-10-21 handoff's lean (`⸨…⸩` a «text», `⟬…⟭` raw, `"…"` a string) and are illustrative; `notation NAME` is my placeholder for the new node.

**K1, the JSON case.** Either spelling; the second asserts.

```udon
|server[web] :port 8080 :enabled true :weight 0.75 :backup <>
|server[web] :port <8080> :enabled <true> :weight <0.75> :backup <>
```
```tree
root
  |server
    :$key ⸨web⸩
    :port ⸨8080⸩          view: 8080
    :enabled ⸨true⸩       view: true
    :weight ⸨0.75⸩        view: 0.75
    :backup nil
  |server
    :$key ⸨web⸩
    :port 8080
    :enabled true
    :weight 0.75
    :backup nil
```

**K2, identifiers.** `:zip 01234 :version 1.10 :commit 1234567 :part 1e10`: all texts. `<…>` never touches them unless the author asserts a number. Whether the *view* turns them into numbers is the classification fork's question (DP3), not this one. To be certain of text, quote.

**K3.** `|book :title 1984 :year <1949>` and `|book :title 1984 is a novel :year 1949`: the titles are texts either way.

**K4, temporal.** The default is bare text that a slot or schema reads as a date; the notation is for an author who wants to say so in the document:

```udon
|decision :date 2026-07-21 :at 10:12
|decision :date <date: 2026-07-21> :at <time: 10:12> :window <dur: 60s> :stamp <datetime: 2026-07-21T14:20>
|decision :date <2026-07-21>
```
```tree
root
  |decision
    :date ⸨2026-07-21⸩
    :at ⸨10:12⸩
  |decision
    :date notation date ⟬2026-07-21⟭
    :at notation time ⟬10:12⟭
    :window notation dur ⟬60s⟭
    :stamp notation datetime ⟬2026-07-21T14:20⟭
```
The third line is an **error**: "`2026-07-21` isn't a number. For a date, write it bare (`2026-07-21`) or name its notation (`<date: 2026-07-21>`)." The estate's `<2026-07-21>` spelling is ideation, not demand (Joseph's note); my instinct is that an agent with no exposure writes a date bare, as TOML and YAML taught it, and that the error above teaches the named form in one pass.

**K5 and K6, units.** Bare by default: `:width 920px :margin 1.5em :opacity 50%`, `:timeout 5m :length 5m`, with the slot deciding minutes or meters (the slots fork's ground). An author who must say it in the document names it: `:timeout <dur: 5m>`, `:length <len: 5m>`. `<920px>` is an error that suggests `920px` bare or `<px: 920>`.

**K7, aliases.** `:port ssh`: a text; the alias belongs to the slot's vocabulary. Nothing here.

**K8, a host type.** `:reg <u64: 0xff>`: a notation named `u64` with body `0xff`. `:reg <0xff>`: the number 255, host type left to the consumer. My lean (taste) matches the coordinator's: host storage names belong in a schema, and the head is there for authors who can't avoid it.

**K9, a notation with parameters.** The key carries them, meaning what a key always means ("which one"):

```udon
|ev :when <dt[DD-MM-YY]: 05-03-27> :also <dt.iso8601: 2026-07-21>
```
```tree
root
  |ev
    :when notation dt
      :$key ⸨DD-MM-YY⸩
      ⟬05-03-27⟭
    :also notation dt
      :$traits [iso8601]
      ⟬2026-07-21⟭
```
Joseph's own imagining puts the notation on the slot (`:when:dt(YY-MM-DD)<27-03-05>`); that half is the slots fork's question. If both exist, slot and literal declare the same thing in two places, and a rule for which wins is needed.

**K10.** The value nil: `<>` (or `<nil>`, or bare `nil` under the view). The text `nil`: `"nil"`, or in prose. The empty string: `""` or `<"">`.

**K11, HTML.** Prose is untouched (`<` means nothing in prose). On a value line, `:html <b>bold</b>` is an error suggesting `"<b>bold</b>"`. An element with `xml:lang="en"` is `|p :xml:lang en`, if the label lean holds.

**K12, lists.** `:nums [1 2 3]` (texts, view → numbers) or `:nums [<1> <2> <3>]`; `:tags [a b c]`. A notation's inner spaces stay inside its brackets, so `[<date: 2026-07-21> x]` has two items.

**K13, keys.** `|step[3]` (a text key) or `|step[<3>]` (an integer key); `|user[jw]`.

**K14, insisting.** `:port <8080>`; the typo `:port <8O80>` is an error at the `O`.

**K15, notations lite doesn't know.** `:color <color: #3221f9>`, `:price <money: 9.99 USD>`, `:at <geo: 40.71 -74.00>`, all carried. Or bare, as texts.

**Composite lines.**

```udon
|server[web] :port <8080> :timeout <dur: 30s> :started <datetime: 2026-07-21T14:20> ; prod
|p Chapter 3: The Return
  See |{a :href /x the docs} for more ;{link checked 10-21}.
|cfg :tags [<1> two <date: 2026-07-21>]
```
```tree
root
  |server
    :$key ⸨web⸩
    :port 8080
    :timeout notation dur ⟬30s⟭
    :started notation datetime ⟬2026-07-21T14:20⟭
      ; prod                         (attached to :started, by the framed-comment lean)
  |p
    :$main ⸨Chapter 3: The Return⸩
    ⸨See |{a …} for more ;{link checked 10-21}.⸩
  |cfg
    :tags [1 ⸨two⸩ notation date ⟬2026-07-21⟭]
```
`<…>` changes nothing about `C-b`: prose and `$main` text never open it. (`Chapter 3:` doesn't trigger [[rule:main-label-colon-warns]]: its first word has no colon.)

## What it changes on the cards (impact radius)

- [[rule:opaque-span-raw-text]] (provisional): `<…>` leaves the opaque-span family; `@{…}` and `;{…}` stay raw. Statement rewritten as the table above.
- [[def:opaque-span]], [[def:typed-value]], [[def:value]] (all provisional): «explicit-typed-value» becomes the closed form; a new term for the labeled form («notation»?); «type-label» becomes the notation's name, and the coordinator's "no term in lite" lean no longer holds, since the tree now has that part.
- [[rule:matched-pairs-need-no-escape]], [[rule:opaque-span-escapes]], [[rule:newline-in-opaque-span-is-error]]: apply to a notation's body; a string interior follows the string rules, which also answers the open "`>` inside a string inside `<…>`" question.
- [[rule:unclosed-delimiter-is-error]]: unchanged.
- [[rule:reserved-spellings]]: gains the unlabeled-interior errors (or they live on the new card).
- [[rule:fence-default-handler]]: generalizes to "the handler for a notation's name", shared with `<…>` (a new definition card for «handler» or «notation»).
- The `rule:bare-typing` gap: its number grammar is now used twice, committing inside `<…>` and (under any classifying DP1) recognizing bare.
- `<>` as nil: carded here.
- Strengths touched: all provisional or lean; nothing `decided` changes except the 2026-10-08 steward call "raw text for typed delimited values", which Joseph himself reopened on 2026-10-20 and 10-22.

## Costs and open edges, honestly

- **The role of a letter-led interior is decided at the end of its label** (`<dt: …>` vs `<dtx>`), not at a fixed character count. It is the same as every label in lite (an element name streams until it ends), so I count it as bounded by a token, not unbounded. **Guess** that Joseph accepts token-bounded as bounded; worth confirming.
- **A missing space** (`<dt:2026>`) is an error that suggests `<dt: 2026>`, not a silent raw value. Times (`<10:12>`) and URLs (`<https://x>`) never read as heads: the first is digit-led (a number error, suggesting a notation), the second has no space after its colon (an error suggesting a quoted string).
- **Two ways to write a number** (`8080` and `<8080>`) under a classifying DP1. They give the same value with different forms in «meta»; the logical tree collapses them (Joseph's `<"asdf">` ≡ `"asdf"`).
- **Colon space as the head separator** gives `:` a third role (attribute marker, label character, notation head). It is also the gesture of his trailing-colon lean (`:when: <dt: 2026-07-21>`): "name, colon, space, value" in both places. **Taste:** I find that coherence a plus.
- **Spec surface:** one table and one shared handler concept. More than the raw box, less than any design with temporal shapes in the classifier.
- **Not decided here:** whether lite carries *every* notation name (fence-like) or reserves all names in 0.1 except none. Carrying is consistent with fences; reserving is the strictest reading of B2. It's the "is a refinement a change?" question.
