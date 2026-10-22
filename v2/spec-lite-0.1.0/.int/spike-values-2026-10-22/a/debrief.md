# Debrief, spike a: how lite's values come to mean what they mean

*To Joseph, from spike a (Opus 5.5 and six forks of it), 2026-10-22. Written last, from [synthesis.md](synthesis.md) and the fork pages. Scores are my hypotheses against CTQ-FACTORS, never measurements. In the trees, because `‹…›` and `<…>` blur for you: `⸨…⸩` is a «text», `"…"` a «string», `⟬…⟭` raw carried content, and `#integer` a classification attached to a text. All four are illustrative, not a proposal for the transcript.*

## The short of it

1. **Lite never gives a value its meaning; a reader does.** Lite only decides three things: what the tree keeps about a value, which spellings it commits, carries or refuses, and the one default reading every consumer gets. Slot types, aliases (`port` = u16 | standard-port), unit meanings, coercion and canonical display live in the reader's layer, your dialect. Lite owes that layer the spelling, the form, the address (which element, which attribute) and the order, and it already gives most of them.
2. **The streaming objection that moved you to "C with the view" doesn't separate C from whole-run typing.** The view computes the same thing at the same moment. That reopens the "magic of udon values", on other grounds.
3. **What came out on top:**
   - a bare run is a text, and the parser attaches a fixed classification (nil, true, false, a JSON number) when the whole run spells one;
   - quotes mean exactly these characters;
   - `<…>` is closed when unlabeled (assert, or an error that says what you meant), and `<name: body>` carries a notation;
   - slot types stay outside the document;
   - `:` never ends a bare label.
4. **One question of yours decides more than any branch: is a refinement a change?** It comes up in §5.

## 1. Streaming: the same work under B and under the view

Your example, as a value:

```udon
|el :n 4938422222222222222222222222222222222222222222222222222222222222222222222222412124124124p
```

Under the bare-run rule, where this run ends never depends on what it spells. It ends at the line's end, at a ` |name` or ` :name`, or at a framed ` ; ` or ` \ `, whatever its characters are.

- **So a parser can stream every character from the first.** A small finite-state classifier runs beside the scan and says at the close: "spells an integer", or here, because of the `p`, "spells nothing".
- **The view does exactly the same.** It reads the finished text, so whoever wants the classification waits for the run's end either way, and whoever doesn't, waits for nothing either way.
- **Checked by running it** (`forks/classification/f1_check.py`):
  - a million-digit run is emitted from its first character with nothing held;
  - the streaming classifier agrees with the view on 400,000 fuzzed runs.
- **What does cost something is the event model.** 0.9's wire announces a kind before the characters, which is why descent needed HOLD/RELEASE for `$key`. Lite specifies the tree, not the wire.

The real resource limit sits where JSON implementations found it: converting a huge digit run into a host number (jackson caps numbers at 1000 digits; CPython caps int conversion at 4300 digits, CVE-2020-10735). That limit is the same under every option, and it belongs in the host mapping guide.

**Your words on both sides, from history.jsonl, checked:**

- 2026-10-21, morning: typing `:d 3` as anything but numeric was "opposed to the magic of udon values".
- Later that day, after `4938…p`: "C with the view."
- 2026-07-15: you voted that `599239492002394992929999.7e12 apples` error, because text "would need potentially unlimited lookahead".

Streaming has decided this twice, and the cost it was avoiding turns out not to exist.

**One reading of CTQ B1 this needs from you.** "Every construct's kind is known within a few characters" still holds if the construct is "a bare run", known at its first character, and the classification is an attachment that arrives at its close. **Does "kind" in B1 mean the construct, or does it include the classification?**

## 2. How a bare value gets its kind: text with a classification attached

Your view, made normative: the parser attaches the classification, every parser identically, and the default reading uses it.

- **A view whose default is left open isn't a design.** Two consumers would disagree about `:enabled true`, which is YAML's competing-schemas failure.
- **The value is still its spelling.** The class is an attachment that changes no arity, the way you want comments and meta attached.

```udon
|server[web] :port 8080 :enabled true :weight 0.75 :backup nil :name "8080"
|part :zip 01234 :version 1.10 :id 1e10
|book :title 1984 is a novel :year 1949
|box :width 920px :timeout 5m :length 5m
|step[3]
```
````tree
root
  |server
    :$key ⸨web⸩
    :port ⸨8080⸩ #integer
    :enabled ⸨true⸩ #true
    :weight ⸨0.75⸩ #decimal
    :backup ⸨nil⸩ #nil
    :name "8080"
  |part
    :zip ⸨01234⸩                 ← no class: JSON numbers have no leading zero
    :version ⸨1.10⸩ #decimal     ← the hazard no spelling rule can fix
    :id ⸨1e10⸩ #decimal
  |book
    :title ⸨1984 is a novel⸩
    :year ⸨1949⸩ #integer
  |box
    :width ⸨920px⸩               ← no class; a slot type `length` reads it
    :timeout ⸨5m⸩                ← minutes, by the slot `timeout: duration`
    :length ⸨5m⸩                 ← meters, by the slot `length: length`
  |step
    :$key ⸨3⸩ #integer
````

**The standard set is JSON's literals: nil, true, false, and JSON's number grammar.**

- **Why that set.** The classification fork ran four tests on candidate members: portable to every host, recognized by shape alone, the same meaning in every slot, needed without a schema. They pick out exactly this set.
- **What leaving a spelling out costs:** little, because a slot can still read it.
- **What putting one in wrongly costs:** a silent misreading.
- **Side effect:** every classified number is a valid JSON number token, so lite → JSON copies it byte for byte.
- **Out of the set:**
  - Units, `0x`, underscores, rationals and dates go to slots or notations.
  - A "quantity" class turns into "a number followed by letters": `10am`, `3rd`, and `0xff` read as 0 with the unit `xff`.

**What I'd want you to see in those trees:**

- **`:timeout 5m` vs `:length 5m`.** This is why units felt to you like both a slot type and a literal hint. The symbol on the literal is half a claim, and the slot's dimension completes it; neither half decides alone. Lite keeps the spelling, and the slot reads it.
- **`:version 1.10` and `:id 1e10`.** No rule about spelling can tell a number from an identifier; only the slot can, or the writer's quotes. My own instinct as a writer is to write all of these bare and mean text. The identity-by-spelling tree keeps them exact, so only a schema-less data reading can lose the trailing zero.
- **`|h1 1984`.** It is a heading's text that a data reading may take as a number, not a number in the tree. Whole-run typing as the kind (B) would make the heading a number, and `|step[3]` and `|step[3.0]` would need a numeric-equality rule.

**Scores** (classification fork, weighted against CTQ):

| Option | Score |
|---|---|
| text + class | 8.20 |
| class as the kind (B) | 7.48 |
| the view as carded | 6.55 |
| text only, numbers in `<…>` | 6.40 |
| the old line's whole set | 5.62 |

Confidence is high that text + class beats the open view and text-only, and medium on text + class over B.

**nil:** `:backup nil` keeps [[rule:nil-spelling]]'s Statement, and a bare `null` still warns. `<>` is a second spelling of nil.

## 3. `<…>`: closed when unlabeled, open when labeled

`<…>` has been asked to do seven jobs: assert, end itself, carry, name a notation, compose, be nil, and quote (`@{<…>}`). One unlabeled bracket can't both reject `<920px>` (your "error I can understand") and carry `<2026-10-01>` unread. A label separates the two. The angle fork's lead:

```udon
|server[web] :port <8080> :backup <> :when <date: 2026-07-21> :reg <u64: 0xff>
|ev :on <dt[DD-MM-YY]: 05-03-27> :note "a <b>bold</b> claim"
|bad :a <920px> :b <2026-07-21> :c <8O80>
```
````tree
root
  |server
    :$key ⸨web⸩
    :port ⸨8080⸩ #integer            ← same tree as bare 8080; the form <…> in meta, the assertion held
    :backup nil
    :when notation date ⟬2026-07-21⟭
    :reg notation u64 ⟬0xff⟭
  |ev
    :on notation dt
      :$key ⸨DD-MM-YY⸩
      ⟬05-03-27⟭
    :note "a <b>bold</b> claim"
````

`|bad` is an error at its first `<…>`, and each of its three would say what you probably meant:

- `<920px>`: "isn't a number; did you mean `920px` bare, or a notation `<px: 920>`?"
- `<2026-07-21>`: "for a date, write it bare, or name its notation: `<date: 2026-07-21>`."
- `<8O80>`: "isn't a number: the `O` after `8`; did you mean `<8080>`?"

**How the interior reads.** The first character decides, and the decision is never revisited:

| Interior starts with | It is | Otherwise |
|---|---|---|
| `>` | nil (`<>`) | |
| `"` or `'` | a delimited string; `>` must follow its closing quote | error |
| a digit, `+`, `-` or `.` | a number by the standard set's grammar; the whole interior must match | error |
| a letter | `nil`, `true` or `false` if that is the whole interior; otherwise a notation head, then `: ` (colon and space), then a body carried raw | error |
| anything else | reserved | error |

A notation's `[key]` and `.traits` mean what they mean on elements, and its handler is picked by name, as a fence's is.

**Dates are bare by default,** read by a slot. `<date: …>` is for an author who wants to say so in the document. Your 10-20 option (anything that isn't a primitive passes through raw) is dominated: it can't reject `<920px>`. Today's raw box can't hold a number at all once bare runs are text.

**My reconciliation, so the two fork leads compose:** under text + class there is no separate number kind, so `<8080>` gives the same tree as `8080`, plus a check that held and a value that ends itself. That matches your `<"asdf">` ≡ `"asdf"` in the logical tree.

**The rival: a notation as an element** (the wildcard fork):

```udon
|server[web] :timeout |{dur 30s} :port 8080
|p Doors open at |{time 19:30} sharp.
```
````tree
root
  |server
    :$key ⸨web⸩
    :timeout ⸨|{dur ⸨30s⸩}⸩            ← a text whose one piece is an element
    :port ⸨8080⸩ #integer
  |p
    ⸨Doors open at |{time ⸨19:30⸩} sharp.⸩
````

Why it is second in value position:

- **The value is a piece of a text,** so a reading option has to turn it into a value.
- **Without braces it silently takes the rest of the line.** `:timeout |dur 30s :port 8080` makes `port` the `dur` element's attribute, as [[rule:element-after-attribute-with-no-value]] says. No warning can catch that.

Its real strength, a typed value inside prose (`|p` above), costs nothing under any branch, since inline elements in prose already exist. **The question under the choice is yours: is a date a leaf of the tree or a node?** My lean is a leaf.

**Scores** (angle fork):

| Design | Score |
|---|---|
| closed-unlabeled / open-labeled | 1250 of 1660 |
| open variant | 1117 |
| closed with no notations at all | 1083 |

## 4. Slots and the colon

**Slot types outside the document (8.4).** A schema, the `name.schema.udon` convention, a vocabulary. Inline slot types die or wait:

- **`:when:dt` dies.** `:` is a name character in `xml:lang` and `xlink:href`, so `:port:u16` reads as one attribute name.
- **Slot types as traits (`:port.u16 8080`) die.** Stacking `:port.u16 8080 :port 443` gives one slot two types, which shows a per-value type is an annotation on that value, not a slot type.
- **`:port<u16>` collides with nothing,** and the label lean already makes it an error. Leaving it an error keeps that room for full UDON at no cost.

**A trap in today's label lean** (`:` allowed inside and at the end of a bare label, checked):

```udon
|server :host: localhost
```
````tree
root
  |server
    :host: ⸨localhost⸩             ← an attribute named "host:"
````

Whatever you decide about the ornamental colon, `:` shouldn't end a bare label. With that rule:

- **Your light lean (optional ornament):** `:host: localhost` ≡ `:host localhost`, and the `$main` colon warning's fix becomes one inserted character: `|server :host: localhost`.
- **No ornament at all** ties with it.
- **A compulsory trailing colon is pruned:** it changes every attribute on every card and matches no common notation.

## 5. The question two forks answered without asking you

Both leads claim forward stability on the same premise.

- **Text + class:** "a later version can add a class (dates, say) without changing an accepted tree; the text is the same and an attachment is added."
- **`<name: body>`:** it carries a body a later version may read.

Each is stable only if **adding** information to an accepted tree doesn't count as changing it under reserve-don't-ignore, which is a veto:

```udon
|ev :at 2026-07-21 :span <iv: 2026-01/2026-06>
```
````tree
lite 0.1:   :at ⸨2026-07-21⸩            :span notation iv ⟬2026-01/2026-06⟭
later:      :at ⸨2026-07-21⸩ #date      :span notation iv ⟬2026-01/2026-06⟭ → interval
````

- **If that isn't a change,** both leads stand as written, and "no class" has to be specified as "not classified by this version", never "known not to be a date".
- **If it is,** lite 0.1 is the closed `<…>` with no notations, every class fixed now, and each widening its own later decision.
- **The cards already answered it once, for fences:** a fence named `sh` carries its body for whatever handler later reads `sh`. **Is a refinement a change?**

## 6. What I'd ask you, in the order I'd ask

1. **The 1984 line under each option.** Which tree do you expect, and does the classification belong to the language (every parser, normative) or to a reader?

   ```udon
   |el :d 3 :title 1984 :zip 01234 :name "3"
   ```

   - text + class: `:d ⸨3⸩ #integer`, `:title ⸨1984⸩ #integer`, `:zip ⸨01234⸩`, `:name "3"`
   - class as the kind (B): `:d 3`, `:title 1984` (a number in the tree), `:zip ⸨01234⸩`, `:name "3"`
   - text only: every `#…` gone, and `:d <3>` needed for a number

2. **B1:** may the classification arrive at the run's close, as an attachment?
3. **Is a refinement a change?** (§5)
4. **Is a date a leaf or a node?** (`<date: 2026-07-21>` vs `|{date 2026-07-21}`)
5. **`:` never at the end of a bare label,** and then optional ornament or none?

## What this doesn't cover, honestly

- **No score was measured.** They are one agent family's hypotheses, and the forks' scales differ (compare only within a decision point).
- **The streaming check models runs on one line.** It leaves out fences, escapes, nested embeds and the real label guard.
- **Open edges:**
  - what `<>` is under identity by spelling (nil's spelling is `nil`; `<>` has none);
  - whether prose is ever classified (the forks read never; the cards imply it without saying it);
  - a notation head is decided at its label's end, which is token-bounded like an element name, but that wants your yes.
- **No deployed format I know of streams a bare value and trails its class.** Both halves exist separately (Tcl, YAML); the combination is new.
- **Nothing here is a card edit.** The proposed card changes are in [synthesis.md](synthesis.md) §7.
- **Six forks ran one level deep.** None forked further.
