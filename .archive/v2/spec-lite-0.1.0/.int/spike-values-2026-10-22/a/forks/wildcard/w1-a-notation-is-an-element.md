# W1. A notation is an element

*Wildcard fork, spike a. Status: **alive**, and the one idea from this fork I think is worth Joseph's attention. Labels: **checked** = verified against a card or file this session; **guess** = my inference; **taste** = my preference.*

## The idea, in one line

When a value's literal needs to say *what it is* beyond the standard set (a date, a u64, a color, a day-first date), write it as an element: `:when |{date 2026-10-22}`. The element's name names the notation, its `$main` is the spelling, and its attributes are the notation's parameters. Lite already has every piece of this, so it adds no syntax.

## Why it isn't arbitrary: UDON's own "whose name is it?" test

The README's rule for attribute vs child (**checked**, `udon/README.md`): an attribute name is "the **parent's** relationship-label (`my author`, `my timeout`)"; an element name is "the thing's **own** name (what it *is*)".

Joseph's second distinction in the span is "*this is what the slot is* vs *this is what my literal represents*". Put the two side by side:

| His distinction | Whose perspective | UDON's construct for that perspective |
|---|---|---|
| what the slot is | the parent's: "my `when`" | the **attribute name** `:when` |
| what my literal represents | the value's own: "I am a date" | an **element name** `|date` |

So UDON already has a place for each side, and neither needs a new bracket. A type label inside `<…>` (`<date:…>`) is a second spelling of an element name. His own 2026-07-22 spelling makes the overlap visible (**checked**, quoted on `def/def-typed-value.md`): `<timespan 3m5d>`, a name, a space and a body, which is the shape of `|{timespan 3m5d}` with different brackets.

## How it reads (composite set)

Bare-value behavior below follows the current lean (a bare run is a «text»; the typed-primitive view may read one as a number). W1 is orthogonal to that: it is about values *beyond* the standard set. Trees use the cards' notation.

```udon
|decision[x] :date |{date 2026-07-21} :at |{time 10:12} :window |{dur 60s}
|snapshot :at |{datetime 2026-07-21T14:20}
|job :timeout |{dur 5m} :length |{len 5m}
|reg :value |{u64 0xff}
|ev :when |{date 05-03-27 :fmt YY-MM-DD}
|ev :when |{date.dmy 05-03-27}
|swatch :fill |{color #3221f9} :price |{money $9.99} :at |{geo :lat 40.7 :lon -74.0}
```
````tree
root
  |decision
    :$key ‹x›
    :date ‹|{date ‹2026-07-21›}›
    :at ‹|{time ‹10:12›}›
    :window ‹|{dur ‹60s›}›
  |snapshot
    :at ‹|{datetime ‹2026-07-21T14:20›}›
  |job
    :timeout ‹|{dur ‹5m›}›
    :length ‹|{len ‹5m›}›
  |reg
    :value ‹|{u64 ‹0xff›}›
  |ev
    :when ‹|{date ‹05-03-27› :fmt ‹YY-MM-DD›}›
  |ev
    :when ‹|{date .dmy ‹05-03-27›}›
  |swatch
    :fill ‹|{color ‹#3221f9›}›
    :price ‹|{money ‹$9.99›}›
    :at ‹|{geo :lat ‹40.7› :lon ‹-74.0›}›
````

Each value is a «text» whose only piece is one embed (**checked**, [[rule:embeds-in-text]]). With the one-embed reading option, which "as an aspiration … defaults to on" (**checked**, [[def:reading-option]]), a consumer sees `:date |date :$main ‹2026-07-21›`. Where the leftover `2026-07-21` goes inside braces is still open (**checked**, [[rule:inline-element-value-end]]: "waits for the embeds discussion"); I've shown it in the inline element, as `$main` would put it.

What each composite item shows:

- **K6, `5m` minutes vs meters.** The literal names the dimension (`|{dur 5m}`, `|{len 5m}`); the unit stays in the spelling. With a schema, plain `:timeout 5m` is enough, and that is the domain-forward spelling. W1 is only for writers who have no schema.
- **K9, his `:when:dt(YY-MM-DD)<27-03-05>`.** The notation's parameter becomes an attribute (`:fmt YY-MM-DD`) or a trait (`.dmy`). A trait fits his own gloss: a trait "says what kind of thing the element is" (**checked**, [[def:trait]]), here which variant of the date notation. `$main` comes first, before the parameters, because an attribute's run takes everything up to the next start; `|{date :fmt YY-MM-DD 05-03-27}` gives `fmt` the text `YY-MM-DD 05-03-27` (**checked** against [[rule:unquoted-run-is-one-value]]).
- **K15, notations lite doesn't know.** Color, money and geo need nothing from lite. A structured notation (`geo` with `lat` and `lon`) comes free: under `<…>` it would need an interior grammar.
- **Composite and nested types** (the old `<r: <i: 3 -7> 0d83.23>`) nest the same way, `|{r |{i 3 -7} 0d83.23}`, *if* nested embeds are allowed. They are undesigned (**checked**, TODO-MSC "Embeds as a whole").
- **In prose, the same construct:** `|p Doors open at |{time 19:30} sharp.` A typed value in running text has no spelling under `<…>`, which lite recognizes only in value positions; prose recognizes only `|{` `@{` `;{` (**checked**, [[rule:prose-passes-through]]). This is HTML's own pattern: `<time datetime="…">` and `<data value="…">` are elements that carry typed values in prose (**from memory**, the HTML Living Standard). That's precedent, counted only as evidence that the shape is familiar to agents (A2, A3), not as a reason. What counts under the factors is that one construct serves typed values in data and in text (A6, A7, C2, C3).

### The composite lines

```udon
|server[web] :port 8080 :timeout |{dur 30s} :started |{datetime 2026-07-21T14:20} ; prod
|p Chapter 3: The Return
  Doors open at |{time 19:30} ;{local time} sharp.
|el :tags [1 two |{date 2026-07-21}]
```
````tree
root
  |server
    :$key ‹web›
    :port ‹8080›
    :timeout ‹|{dur ‹30s›}›
    :started ‹|{datetime ‹2026-07-21T14:20›}›
      ; prod                         ← framed comment, attached to the nearest attribute
  |p
    :$main ‹Chapter 3: The Return›
    ‹Doors open at |{time ‹19:30›} ;{local time} sharp.›
  |el
    :tags [‹1› ‹two› ‹|{date ‹2026-07-21›}›]   ← only if embeds are recognized in list items (open)
````

C-c depends on an open question: whether an embed is recognized inside a list item, so its inner space doesn't split the item (**checked**, TODO-MSC "Embeds inside other forms").

## The trap: the block form takes the rest of the line

Without braces, `:started |datetime 2026-07-21T14:20 :timeout 30s` is legal UDON, and `:timeout` becomes an attribute **of the `datetime` element**, not of the server (**checked**, [[rule:element-after-attribute-with-no-value]]: "the rest of the line MUST be the element's"; its example `|el :x |em hi :y 2` puts `y` under `em`). That is a *silent* miss (it parses to a different tree), which CTQ A2 weights more than an error. My instinct as a writer: I'd reach for the braces only after being burned once. Teaching rule: "write a notation in braces unless it is the last thing on its line." A warning can't tell a notation element from any other element value, so the trap can't be caught; it can only be taught. **This is the branch's main cost.**

## Variants

- **W1a: keep `<…>`, only to assert the standard set.** `<8080>`, `<true>`, `<nil>`, `<>` (his nil lean): commit at `<`, an error on a mismatch, which gives K14 (insisting on a number so a typo errors). Anything else inside `<…>` is an error with a "did you mean `|{date 2026-07-21}` or bare `2026-07-21`?" (B4). `<…>` then has one job, the interior grammar is just the standard set, and notations never go in it.
- **W1b: no `<…>` at all.** `<` is reserved in values. K14 can't be written in lite: lite can't validate an element's content, so `|{int 8080}` is carried, not checked. This frees the most syntax (B6), at the cost of losing write-site validation (B4).
- **W1c: the notation as a trait on an unnamed element,** `|{.date 2026-07-21}`. A nameless element whose trait says what kind of thing it is ([[rule:traits-may-follow-spaces]] already allows `|.asdf` as a nameless element with a trait). It reads as "a date-kind thing"; it is one character longer and less guessable. I'd keep it as a possible convention, not the rule (**taste**).

## Against CTQ-FACTORS (my hypotheses, low confidence throughout)

R is the comparison point: my reconstruction of the store's leading direction (`<…>` carries notations: unlabeled interiors undetermined or raw, labeled `<name:body>` raw, the standard set inside committing). Scores are 0–10 for each factor; the weighted means come from `scores.py` in this folder.

| Factor (weight) | R | W1a | W1b | Basis |
|---|---|---|---|---|
| A2 generative guessability (10) | 6 | 6 | 5 | My own instinct: for a plain date I'd write it bare; for an annotated one, `<…>` and `|{date …}` come equally once each is shown; W1's block-form trap costs it. Estate usage not counted, per Joseph. |
| A3 cold comprehension (10) | 6 | 7 | 7 | Reading `|{u64 0xff}` cold, I'd say "a u64 whose text is 0xff". `<u64:0xff>` reads as "something typed", maybe an HTML tag. |
| A4 agentic readability (10) | 7 | 6 | 6 | `<…>` is shorter and denser. |
| A6 spec clarity (9) | 5 | 7 | 8 | W1 adds no rule, but it leans on the least-designed part of lite (embeds). |
| A7 syntactic simplicity (8) | 5 | 7 | 8 | No interior grammar for labels, nesting or parameters. |
| A8 parsimony (8) | 5 | 7 | 8 | No character gains a role. |
| A9 conciseness (6) | 8 | 6 | 5 | `|{date 2026-07-21}` is 18 characters; `<2026-07-21>` is 12. |
| B2 reserve-don't-ignore (veto) | pass? | pass | pass | R passes only if "undetermined" counts as giving no meaning. W1 passes cleanly: the tree is already its final shape, and a later dialect interprets it without changing it. |
| B4 errors that teach (8) | 7 | 7 | 4 | W1b can't error on `|{int 80x80}`. |
| B6 headroom (7) | 4 | 6 | 8 | W1 spends no brackets, but it does commit full UDON to "notations are elements in the tree". |
| C1 structured data (10) | 7 | 6 | 6 | A naive JSON mapper turns `|{date …}` into an object unless it knows the convention. |
| C4 types, notations, units (8) | 5 | 8 | 8 | Parameters and composites come free. |
| C6 extensibility (8) | 6 | 8 | 8 | A dialect is a vocabulary of element names: the same mechanism schemas already use. |
| Weighted mean, all factors | 6.15 | 6.86 | 6.79 | The full vectors are in `scores.py`. |

How to read the totals: a 0.7 gap built from my own guesses is a direction, not a result. It comes almost entirely from simplicity, parsimony, headroom and C4, and it is paid for in conciseness, density, the JSON mapping and the block-form trap.

## Where it pushes on other cards (impact radius)

- [[rule:opaque-span-raw-text]] (provisional): `<…>` leaves the opaque-span family (W1a) or becomes reserved (W1b); `@{…}` and `;{…}` stay.
- [[def:typed-value]] (provisional): «explicit-typed-value» either shrinks to "the standard set asserted" (W1a) or goes; «type-label» is not needed (the element name is the label).
- Embeds become load-bearing for values: the one-embed reading option's default, `$main` inside braces, nested embeds, embeds in list items. All of these are open already, so W1 raises their priority rather than creating them.
- [[rule:element-values]] and [[rule:element-after-attribute-with-no-value]] (decided): unchanged, but the trap above needs a teaching note on the latter.
- `@{<…>}` ("reference kept as a reference"): untouched by W1. That embed use of `<…>` was never a typed value (his "already a little unprincipled").

## What would kill it

- If Joseph wants a typed value to be a *leaf* in the tree, never a node, W1 is the wrong shape. That question ("is a date a scalar or a node?") is underneath the whole branch, and I don't know his answer.
- If embeds settle so that `$main` doesn't apply inside braces, the spelling has to change (`|{date :v 2026-07-21}`), which loses most of the charm.
