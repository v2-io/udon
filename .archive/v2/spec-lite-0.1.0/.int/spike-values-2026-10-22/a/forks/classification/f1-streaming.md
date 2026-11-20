# F1: classifying a bare run needs no holdback

*Classification fork, spike a, 2026-10-22. **Checked** by executable test (`f1_check.py`, run with `python3 -I f1_check.py`); what the test models and doesn't is stated below.*

## The claim

The argument that removed whole-run typing (B) was holdback: with `4938222…2412124p`, a parser has to hold an unbounded prefix before it can say the value's kind. That argument assumed one thing: **the kind has to be announced before the characters.** Drop that assumption and the cost goes away:

1. **A run's extent never depends on what it spells.** Under [[rule:unquoted-run-is-one-value]] the run ends at a space followed by a start, at a framed ` \ `, or at the line end, whatever it spells. (Under first-character commitment, A, this was false: `920px` ended or errored at the `p`.)
2. **So the parser streams the run's characters as they arrive**, and a finite-state classifier runs beside the scan. When the run closes, the classifier's state *is* the classification, and the parser announces it then, as a trailer on the closed value.
3. **That trailer is exactly the typed-primitive view.** The view reads a completed text "whose whole content is one run spelling exactly a number, `true`, `false` or `nil`". It can only know that at the run's end too. Whoever wants the classification waits for the run's end under B, under the view, and under a trailer alike; whoever doesn't want it waits for nothing in any of them.

So **bounded streaming (B1) does not separate B from C-with-the-view.** Both pass it once the classification is a trailer. What separates them is who owns the classification and what a value's identity is ([dp1](dp1-where-the-class-lives.md)).

## What the test shows (checked)

`f1_check.py` has a scanner that finds the run's extent and never consults the classifier, a hand-written classifier with four fields of state (`st`, `kw`, `kwpos`, a flag) and no buffer, and the view as Python regexes that read the completed text.

- **Battery:** 27 runs (`8080`, `01234`, `1.10`, `1e10`, `nil`, `null`, `920px`, `7 apples`, `1984 is a novel`, `7 ;{px}`, `2026-10-22`, `8080   `, …): trailer and view agree on all of them. Each run followed by five tails (` :b x`, ` |c`, ` ; note`, ` \ more`, nothing) has the same extent with the classifier on and off.
- **Fuzz:** 400,000 random runs over `0123456789.-+eE_xnilutrefsapm%`, with and without a quantity class: trailer equals view on every one. *The fuzz caught a bug in my first hand-written machine (it sent `3e%` to "not a quantity" where the regex said quantity), which I fixed. A hand-made machine checked only against my own cases would have shipped it; this is the store's "checks must read the primary" lesson again, in miniature.*
- **Streaming:** a run of 1,000,011 characters (`4938`, a million `2`s, `412124p`): the first character is emitted after one character of input, the class (none) is known at the close, and nothing is held except at most two lookahead characters (the start guard, present in every branch) and a count of pending spaces. Without the final `p` the class at close is `integer`, with the same emission.

## What the test does not model

Fences, escapes inside runs, nested embeds, Unicode labels, and the real start guard (approximated as a letter, `$`, `'` or `"` after `|` or `:`). None of these makes extent depend on class, by reading the cards, but that was not executed.

## Costs that remain (honest)

- **The event vocabulary changes.** UDON's 0.9 wire puts a node's kind before its content: descent's changelog says the identity key's attribute name (`$key` vs `$partial-key`) "is only decidable once the closing `]` does or does not arrive — the ruled wire puts the Attr BEFORE the value events, which no lookahead-free single pass could otherwise produce", and HOLD/RELEASE was built to *buffer* events until then (`tools/descent/CHANGELOG.md`, checked). A key's length isn't bounded, so that buffer isn't either. A class trailer is the other way to do the same job. **Lite specifies the tree, not the wire** ([[def:document]]: parsing "produces one «tree», which is what lite specifies"), so this is an implementation choice for udon-core and descent, not a lite rule.
- **A consumer that converts still holds the digits.** Turning `4938…` into a host number needs all of them, in every branch, including C's `<4938…>`. That holding belongs to conversion, not to classification.
- **Trailing spaces are held as a count** (unbounded, in O(log n) memory), in every branch.
- **One real difference from C's committed form:** inside `<…>` a parser can raise an error at the first character that can't be a number (`<92x`); a trailer only says "no class" at the close. Both are bounded.

## What it changes for the decision

DP1's options (b) view, (c) normative class, (d) class-as-kind cost the same in streaming. The choice among them rests on stability (B3), the predictable API (C7), surprise (A2, A3) and headroom (B6), not on B1. Joseph's lean for C-with-the-view was argued on B1 ("8080 being text … is definitely ok to me surprisal-wise"), so the lean's *surprise* judgment stands, but its *streaming* ground doesn't discriminate.
