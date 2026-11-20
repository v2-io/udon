# DP7: the trailing `:` on attribute names

*Slots fork, spike a, 2026-10-22. Labels as in `dp6-slot-types.md`. Joseph's lean (2026-10-22): "I would like the ornamental trailing ':' on attribute names, or even making it compulsary, a light lean right now, pending a separate discussion on types and the type system." The types discussion is this spike, so this page is that discussion's answer for the colon.*

## First, what the types discussion does to it

One reason to wait was that the trailing colon might be where a type goes: `:port: 8080` as `:port:<empty type> 8080`, and `:port:u16 8080` later. **DP6 closes that door**, because `:` is an XML NameChar inside real attribute names (`xml:lang`, `xlink:href`, `xmlns:gd`), and the label lean already allows it inside labels. So `:a:b` must stay the name `a:b`. The trailing colon can only ever be ornament. If inline slot types are ever wanted, they belong after the name in a bracket that isn't a NameChar (`:port<u16>`, DP6 S2c), not between colons. The colon question is then purely about beauty, guessability and cost, and it can be decided now.

## A trap in today's lean, with no trailing-colon rule at all (from the cards)

The label lean puts `:` at "inner and last" positions. Under it, a writer who types the YAML-shaped `:host: localhost` gets **an attribute named `host:`**, not `host`. That is silent: it parses, to a different tree, the miss CTQ A2 weighs most. My own instinct, as the kind of writer lite targets, is that I'd write `:host: localhost` some of the time, carrying `host:` over from YAML and Elixir. So "no trailing colon" is not a neutral status quo: it needs `:` to be barred from the last position of a bare label (an error that teaches), or it leaves the trap in place.

## Branches

### T1: no ornament; `:` never last in a bare label (alive)

```udon
|server :host localhost :port 8080
|server :host: localhost
```
The second line is an error: "a bare name can't end in `:`; did you mean `:host localhost`?" One spelling; the YAML habit is caught and taught (B4).

### T2: an optional ornamental `:` after an attribute name (alive; Joseph's light lean)

Rule: a bare attribute name followed directly by one `:` and then a space or the end of the line is the same name; the `:` is ornament, kept in «meta» for round-trip and gone from the tree.

```udon
|server :host: localhost :port: 8080
|server
  :host:    localhost
  :timeout: 30s
  :author:
    |person :name: Jane Doe
|el :xml:lang: en :xlink:href /x
```
````tree
root
  |server
    :host ‹localhost›
    :port ‹8080›
  |server
    :host ‹localhost›
    :timeout ‹30s›
    :author
      |person
        :name ‹Jane Doe›
  |el
    :xml:lang ‹en›
    :xlink:href ‹/x›
````
*Meta:* each occurrence written with the ornament carries it (`colon: true`, say), so a printer can write the document back as it was.

Pushed through the other rules:

- **Names with inner colons survive:** `:xml:lang: en` is the name `xml:lang`. The label rule becomes "`:` inner only", as in T1.
- **The `$main` colon warning gets a one-character fix.** `|server host: localhost` warns, and the suggestion becomes "did you mean `:host: localhost`?", a single inserted character instead of a rewrite. For an agent, the smallest correct edit is the most teachable one (B4).
- **"Pretend each sameline part is on its own line"** still holds: `:a: 1` on its own line is the same as `|el :a: 1`.
- **Alignment** (Joseph's beauty example): with padding, the colon marks where the name ended (`:timeout:   30s`), as aligned YAML and Go struct literals do. Mild; *taste*.
- **Edges, to rule:** `:a::` is an error (a bare name can't end in `:`, then ornament). `:a:b c` is the name `a:b`, while `:a: b c` is `a` with `b c`: one space decides. That is the same kind of edge as `|el.x` vs `|el .x`, and an agent reading plain text sees the space (A4, M).
- **What it doesn't extend to:** element names. `|h1: Title` would collide with prose habits (`|li Note: …`) and isn't asked for.

### T3: the trailing `:` compulsory (pruned)

```udon
|server :host: localhost :port: 8080
|el :a 1        ; error: an attribute name must end in ':'
```
**Why it's pruned.** It changes the spelling of every attribute in every card example, fixture and existing document (the largest impact radius available to a lite change), and the most frequent construct gains a character and a second role for `:` (A8 parsimony, A9). Leading-plus-trailing `:host:` also isn't a form any common notation uses: Ruby and Elixir have `:host` (a symbol) or `host:` (a label), never both. So writers would often omit one or the other, and every omission would be an error. Those errors are caught, but there would be many (A2). Its one real gain, a single spelling, T1 has too.

## Scores (my hypothesis)

| Factor (weight) | T1 as the lean stands (`:` last allowed) | T1 + `:` never last | T2 ornament | T3 compulsory | basis / confidence |
|---|---|---|---|---|---|
| A1 agent-subjective (9) | 6 | 6 | 8 | 7 | `name: value` reads as a pair; Joseph's own lean (L) |
| A2 generative (10) | 3 | 6 | 9 | 5 | YAML/Elixir-shaped writing: silent / caught / accepted / often caught (M) |
| A3 cold comprehension (10) | 7 | 8 | 7 | 8 | two spellings cost a reader a moment (L) |
| A4 agentic readability (10) | 8 | 8 | 8 | 7 | dense lines get noisier under T3 (L) |
| A6 spec clarity (9) | 8 | 9 | 8 | 8 | T2 adds one rule (M) |
| A7 syntactic simplicity (8) | 8 | 9 | 7 | 8 | two spellings (H) |
| A8 parsimony (8) | 8 | 8 | 6 | 5 | `:` gains a second role (H) |
| A9 conciseness (6) | 8 | 8 | 8 | 5 | +1 character per attribute under T3 (H) |
| B4 errors that teach (8) | 2 | 7 | 9 | 7 | silent trap / caught / one-character fix (M) |
| C10 round-trip (7) | 9 | 9 | 7 | 9 | T2 needs the ornament kept in meta (H) |
| **weighted mean** | 6.6 | **7.7** | **7.7** | 6.9 | |

T1-fixed and T2 tie on my numbers. They disagree only on whether to spend a second spelling on beauty and a gentler fix. T2 trades A7 and A8 for A1, A2 and B4. I lean **T2**, and the reason is the warning's one-character fix. *Taste, held lightly.* The tie is honest, so the call is Joseph's.

Impact radius: T1 changes the label lean ("`:` inner only") and the `$main` warning's text. T2 changes those two and adds one sentence to [[def:attribute-name]] (or a small rule card), plus ornament in «meta» on [[rule:tree-transcript]]. T3 changes every card with an attribute in it.
