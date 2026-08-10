# Pass 2 — arc reframing, for Joseph's morning

**One decision blesses or reverts everything here; three questions follow at
your leisure.** Branch `unif-pass-2` (based on pass 1's branch). Companion:
[UNIF-PASS-QUESTIONS.md](UNIF-PASS-QUESTIONS.md) (pass 1's Q2/Q4/Q5/Q7 — still
yours; Q2 is sharpened below).

## What I chose and why

**Restructured pass 1; did not start blank.** Pass 1's section text is
ledger-verified — a blank rewrite would forfeit that verification and hand you
two 900-line variants to diff over coffee. The arc problem wasn't the
sections; it was that the spine — the small set of ideas everything derives
from — existed only scattered (§2.2, §6.4, RATIONALE, Appendix A's "two
ideas"). The session kept discovering that every relic fell to one of a
handful of principles; the spec now *leads* with them.

## The one decision: §0, the axioms

CORE now opens with **§0 "The machine"** — seven axioms (A1 columns · A2
virtual lines · A3 two spaces · A4 everything-is-an-assignment · A5 two
extents · A6 frozen syntactic typing · A7 keep-everything/severity-is-loss),
each citing the sections that state it in full, with a **scope guard**: axioms
never decide what the sections leave open — tensions are findings, not silent
derivations. This promotes the virtual-line/dual-operator picture from
RATIONALE-material to normative *framing* (its content is exactly the ruled
law; the framing is what's new). Bracket mode becomes a derivation instead of
a stipulation; the K10 terminator set becomes "the markers that would start a
fresh line"; the two-space model gets its honest third region named (inline
interiors are deliberately mixed — previously true but unnamed).

**If the arc lands:** the mechanical follow-up is a physical reorder I did
NOT execute (it would churn every section number the ledger and theory docs
cite, so it wants your blessing first):

| Part | Sections (current numbering) | Why |
|---|---|---|
| I — The machine | §0 · §1 · §2 | as now |
| II — Value-space | §3 + §4 + §6.4 **merged** (one mechanism: guards, escape, terminators, currently 300 lines apart) · §11 (types, pulled up — the reader currently meets values in §6 and their typing 500 lines later) · §5 + §6 (elements & assignments & sugar) | the worst seams in the current arc |
| III — Text-space | §7 · §8 | |
| IV — Periphery | §9 · §10 · §12 | |
| V — The contract | §13 · §14 · §15 · appendices | |

Revert cost if you dislike §0: one commit, self-contained.

## Q2, sharpened — pick a principle, not cells

Pass 1 left clean-value-position scope as three per-context leans (lists YES ·
identity NO · deferred-first-line NO). Working the axioms against them exposed
that **those leans don't follow from any single principle** — two candidate
principles are each internally uniform and give different tables:

| Context | Pass-1 leans | **P-scan**: clean positions exist wherever the Line Scan (incl. K7's transported position) runs | **P-line**: value positions live on (virtual) lines; delimited-capture interiors are not lines |
|---|---|---|---|
| List items `[\|{a} \|{b}]` | YES | NO (a list is a delimited capture with item slots, not the scan) | NO |
| Identity brackets | NO | NO | NO |
| Deferred body's first line | NO | YES (K7 transports the value position there) | YES (it is a real line) |

All three columns agree only on identity brackets. **When you said** "the
current spec is the hack — the tell is the space… `:$main [|{embed-1},
|{embed-2}]` period," **it was assumed** the rule's reach could be settled
per-context; **the question now:** were you implying a *principle* — and if
so, is it "where the scan runs," "what is a line," or a third one — so all
three cells fall out of one sentence instead of three rulings?

## Q8 — new, found in pass 1's own text (a real seam, not style)

§6.4 contained a visibly unresolved parenthetical for **attached escape under
an open value**. K13-consistent reading (now in the text, flagged):

```udon
|element :attribute hello \:-) how are you?
; attribute = "hello :-) how are you?"   — escaped material JOINS the open value; no $main
```

**When you said** (introducing this very example, pre-K13-split) "It's ' \ '
that commits to text, right?", **it was assumed** after K13 that the attached
spelling `\:-)` escapes one character and — because `:attribute`'s unquoted
value is still open — the emoticon joins *that value*, not `$main`. The framed
spelling ` \ :-) ` still gives your original reading (`attribute="hello"`,
`$main=":-) how are you?"`). **Does the implication hold** — attached-escape
material lands in whatever value is open, with the framed form as the way to
break out — or did you want any escaped emoticon after a value to read as
`$main`?

## Relic observations (eyes-open items, no action taken)

1. **Appendix A's "two ideas" undersold the machine** — fixed to cite the
   axioms; nothing behavioral.
2. §6.6's context table now reads as *derived* from A2/A3 — a future pass
   could generate it; left as-is.
3. Pass 1's Q5 relics (content-phase retirement, suffix sugar as last
   bare-`?`, `EscapeOutsideHeadPosition`, the element-guard suffix clause)
   all stand; the axioms strengthen the case for the third (past-base `\` is
   text-space by A3 — the advisory describes nothing).

## Deliberately not done

- **No blank rewrite** (reasons above). — **No variant branches**: I made no
  functional change whose impact was unclear; Q2/Q8 are questions, not
  changes, and everything landed is framing over ruled law. — **No sonnet
  probes**: fork hard-rules bar me from spawning agents; the pass-1-vs-pass-2
  comprehension probe remains a good idea for the parent to run if wanted.
