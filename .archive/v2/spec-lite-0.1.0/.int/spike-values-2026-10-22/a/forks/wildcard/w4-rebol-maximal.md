# W4. REBOL-maximal lexical typing: dead, with one thing salvaged

*Wildcard fork, spike a. Status: **dead**.*

## The idea, pushed to the end

Joseph called `<…>` "an homage to REBOL." REBOL's real move was the opposite of a bracket: dozens of datatypes recognized purely from spelling, with no marks at all (**from memory**, REBOL 2/3): `10:30` time, `1-Jan-2000` date, `$9.99` money, `50%` percent, `100x200` pair, `1.2.3` tuple, `user@x.com` email, `http://…` url, `%file` file, `#abc` issue, `<tag>` tag, `#{FF}` binary. The maximal branch: every bare run is classified into the largest set of shapes, with no `<…>` needed for anything.

## Where it led

Written out against the composite set, every K item gets a "natural" spelling. That is REBOL's charm, and it is real domain-forwardness (A5): `:at 10:30`, `:price $9.99`, `:size 100x200`.

Then the costs, one factor at a time (hypotheses):

- **B3 stability (10).** Every parser must agree on every shape boundary: is `1.2.3` a tuple or a version text; is `10:30:99` a time; is `#abc` an issue or a color. The old line had about a dozen temporal shapes and had to defer validation entirely (**checked**, `.int/old-numeric-typing.md` §4 item 6, §5).
- **A6 spec clarity (9), A7 simplicity (8).** The spec's spine would become a datatype catalog.
- **A2 generative guessability (10).** My instinct as a writer: I wouldn't predict REBOL's spellings (`1-Jan-2000`, `100x200`); there is little REBOL in what agents have read. Shapes I *would* guess: ISO dates and times, `30s`, `50%`, `$9.99`.
- **C1 / D2 host portability.** Most of these have no host type (pair, tuple, issue, money). The coordinator's hypothesis, that a kind belongs in the core when every host has a near-lossless equivalent, kills most of the set.
- **Prose-like values.** Under the bare-run rule a whole run decides, so `:title 10:30 Train` stays text. Under a classify-as-attachment design (the parent's F1), a wrong class is advisory and the text survives. That makes a large set *less dangerous* than in REBOL, but no less costly for B3 and A6.

It died on B3 and A6: a branch whose spine is a catalog can't be "short, coherent and easy to apply."

## What it taught, and what survives

The shapes I'd expect any agent to write unprompted are few: ISO date, time, datetime, a duration like `30s`, a quantity like `920px` or `50%`. Those are exactly the shapes the old line partly typed, and exactly the ones that cost it the most. So the real question isn't REBOL's breadth but where those few shapes go: classified in the default reading (cheap if advisory, costly for stability), named as notations (W1, or `<…>`), or left as text for slot types to read (the most domain-forward). That's the classification and slot forks' ground, and this branch hands it to them rather than deciding it.
