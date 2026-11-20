# DP1: where a bare run's classification lives

*Classification fork, spike a, 2026-10-22. Scores are my hypotheses (basis and confidence given), not measurements. Tree drawings use the cards' current notation plus `#integer` etc. for a classification attached to a value; the notation is illustrative only, since [[rule:tree-transcript]] owns it.*

## The decision point

`:port 8080`. Every option agrees the run's extent is the same and that `"8080"` is a string. They differ on what the tree says about the run `8080`:

| | Branch | `:port 8080` in the tree | Who decides it's a number |
|---|---|---|---|
| C0 | bare is text, no reading | `‹8080›` | nobody in lite; write `<8080>` |
| Cv | the typed-primitive view, its default left open (as carded today) | `‹8080›` | a consumer that turns the view on |
| Cc | **text plus a normative class** | `‹8080› #integer` | lite: every parser attaches the same class |
| B | the class is the kind | `8080::integer` (spelling kept in meta) | lite |

## What the branches turn out to be

**Streaming doesn't separate Cv, Cc and B** ([F1](f1-streaming.md)). Two other things do.

**1. Cv is not a stable point; its default *is* the decision.** With the view off by default, consumers get C0 plus a convenience some of them turn on. With it on by default, and the view specified exactly, it is Cc under another name. While the default stays open, two consumers of one document can disagree about whether `:enabled true` is true. That is YAML's schema plurality in miniature: YAML's plain scalars are resolved by whichever schema a library picked (failsafe, JSON, core, or 1.1-style), and the same file reads differently across libraries. *(From memory, not re-checked: PyYAML resolves with 1.1-style rules, so `on`, `yes` and `0755` read differently there than under 1.2's core schema.)* I count that as evidence against B3 (one tree per document in every parser) and C7 (a predictable tree and API), not as a reason in itself. Lite's view would be one tiny fixed set, so the plurality would only be on/off, but on/off is enough to make `true` mean two things.

**2. Cc and B hold the same information but give values different identities.** Both keep the spelling and the class, so in information they are isomorphic. They differ in what a value *is*:

- Under Cc a value is its spelling. `|step[3]` and `|step[03]` are different keys; `[3]` and `[3.0]` are different keys. A repeated-attribute or duplicate-key check compares spellings.
- Under B a value is a number with a spelling attached. Is `[3]` the same key as `[3.0]`? As `[1e0]`? B has to answer numeric equality across spellings, for keys, for duplicate detection and for every consumer's comparisons. Every answer is a rule somebody can be surprised by.

And they differ where a number lands in text-shaped places:

```udon
|h1 1984
|book :title 1984 :year 1949
```
````tree
Cc:                         B:
root                        root
  |h1                         |h1
    :$main ‹1984› #integer      :$main 1984::integer      ← a heading whose main is a number
  |book                       |book
    :title ‹1984› #integer      :title 1984::integer
    :year ‹1949› #integer       :year 1949::integer
````

Under Cc the heading is the text `1984`, which a data reading may also take as the number. Under B the heading *is* a number. A cold reader (A3) of a B tree is surprised there; a reader of a Cc tree isn't.

**3. Forward extension: Cc can grow, B can't.** Under Cc a later version can attach a new class to spellings that had none (a quantity, a date) without changing any accepted tree: the text is the same and an attachment is added. Under B, a later class turns a value whose kind was text into one whose kind is date, which changes accepted trees. That is what B2 (reserve, don't ignore) exists to prevent and what B6 (headroom) measures. C0 is also on Cc's path: shipping C0 now and adding classes in 0.1.1 is additive. **C0 → Cc is one monotone path; B is off it.**

## The four branches against the factors

| Factor (weight) | C0 | Cv (open) | **Cc** | B | basis (short) |
|---|---|---|---|---|---|
| A1 agent-subjective (9) | 5 | 6 | 8 | 7 | taste: `<8080>` on every number reads as plumbing; Cc's tree reads as written |
| A2 generative guessability (10) | 3 | 5 | 8 | 8 | an agent writes `:enabled true`, `:port 8080` meaning typed values, and quotes to force a string (JSON/YAML instinct). Under C0 that's a silent miss on every typed value |
| A3 cold comprehension (10) | 6 | 6 | 8 | 6 | B's heading-as-number; Cv's reader can't know which reading applies |
| A5 domain-forward (9) | 4 | 7 | 9 | 9 | plumbing per domain fact: C0 adds `<…>` to each |
| A6 spec clarity (9) | 8 | 5 | 7 | 7 | C0: one sentence. Cc: two ("bare is text"; "lite notes when it spells nil/true/false/a number"). Cv: raw tree + view + an open default |
| A7 syntactic simplicity (8) | 9 | 8 | 7 | 7 | the classifier is one production (JSON's number) and three keywords |
| A9 conciseness (6) | 4 | 8 | 9 | 9 | |
| B1 bounded streaming (veto) | pass | pass | pass | pass | F1 |
| B2 reserve, don't ignore (veto) | pass | pass | pass | strained | B commits unclassed spellings to kind text, so later classes change trees |
| B3 stability (10) | 9 | 5 | 9 | 8 | Cv: two readings in the wild; B: numeric equality edges |
| B4 errors that teach (8) | 5 | 6 | 7 | 7 | C0's misses produce no error; a warning would fire on every JSON-style document |
| B5 parse speed (9) | 9 | 9 | 8 | 8 | a DFA beside the scan; near free |
| B6 headroom (7) | 8 | 8 | 8 | 5 | point 3 above |
| C1 structured data (10) | 3 | 6 | 9 | 9 | JSON's numbers, booleans and null map directly |
| C5 schemas and slot types (8) | 8 | 8 | 9 | 7 | a slot type reads the spelling; under B it must coerce numbers back to strings for ids |
| C7 predictable tree and API (8) | 7 | 4 | 8 | 7 | |
| C10 round-trip (7) | 9 | 9 | 9 | 8 | |
| **weighted mean** | **6.40** | **6.55** | **8.20** | **7.48** | `scores.py` |

The old line's kind-first design with its whole standard set (B-old) scores 5.62 on the same factors; see [dp2](dp2-the-standard-set.md) for why it dies.

**Confidence:** high that Cc beats Cv and C0 on A2, A5 and C1, and that Cv's open default costs B3 and C7; medium on the Cc-over-B margin, which rests on two judgments (identity by spelling is less surprising; forward extension matters) that Joseph may weigh differently. The factors overlap on purpose (A2, A3 and A5 all reward the same thing here), so the margins are larger in the sum than they should be.

## Cc, stated as a card would state it (a sketch, not a card)

1. A bare run is one «text», whatever it spells. *(unchanged from today's lean)*
2. When the whole run is one plain piece and spells exactly `nil`, `true`, `false` or a number in the standard set ([dp2](dp2-the-standard-set.md)), the «tree» attaches that classification to the text. Every parser attaches the same classification to the same spelling. It is an attachment, so it changes no cardinality.
3. A value's identity is its spelling: two values are the same when their kinds and characters are the same; the classification never makes two spellings equal.
4. Consumers choose a reading: the text, or the data reading, which takes a classified run as nil, a boolean or a number ([[expl:data-mappings]]). Strict getters (`as_int()`, `as_bool()`) fail on a run with no matching class, the way Joseph's cardinality getters fail on arity.

The typed-primitive view, on this branch, stops being an option and becomes clause 2 plus the data reading in 4.

## Where it would still surprise (kept, not hidden)

- `:width 7 ;{px}` has no class (two pieces) and `:height 7 ; px` is `#integer`. Joseph called this expected; it stays a gotcha to write down.
- An invisible trailing tab or no-break space after `8080` is content, so the run has no class. A warning could catch it: "this would be an integer but for a trailing U+00A0".
- A bare title that is all digits (`:title 1984`) is `#integer`, so a data reading exports `"title": 1984`. The writer who cares writes `"1984"`, as in YAML. A slot type fixes it without the writer's help. See [dp3](dp3-identifiers.md).
