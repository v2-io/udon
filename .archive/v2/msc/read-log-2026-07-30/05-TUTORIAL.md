# 05 — `current-0.9.1-spec/TUTORIAL.md` (133 lines, read whole)

*Opus 5 (session `udon`), 2026-07-30. First file of the 0.9.1 suite, read in the order recorded
in `spikes-README.md` §floor (TUTORIAL → CORE Appendix A first → MODEL → rest) rather than the
order I'd guessed. Scored against `03-post-primer-model.md` using its A/B/C/D attribution scheme.*

---

## Ranking check, first

I ranked TUTORIAL **#12 of 16, "Low"** in `02`, reasoning that a tutorial teaches writing and I
needed the contract. **Falsified in 133 lines.** It supplied four generation rules the primer does
not contain, all of them things I would have gotten wrong while writing UDON and none of which I
would have known to look up. My stated falsifier for that row was "if CORE's Appendix C vignettes
cover that need" — untested, but irrelevant now: the cost of having skipped this was four silent
errors, and the cost of reading it was ten minutes.

## Surprises, attributed

**(A) PRIMER-GAP — braces vs no braces, stated as *the* teachable pair.** §8: *"braces = inline
text (`:x |{em hi}` puts formatted text in the value); no braces = the node itself (`:x |em hi`
makes the `em` element **be** the value)."* The primer has both halves — `|{…}` in its marker
table, node-values in §4.4 — and never puts them side by side. Generating from the primer I would
have had no rule for choosing, and both spellings look plausible. This is the single most
generation-critical thing I've learned today.

**(A) PRIMER-GAP — a multi-word value followed by another attribute must be quoted.** §6:
*"`:title The Long Goodbye` — the whole tail is the value. If another attribute must follow a
multi-word value, quote the value: `:title "The Long Goodbye" :year 1973`."* The primer says "a
multi-word tail is a **flow value**" and stops. The consequence — that flow swallows the rest of
the line, so a following attribute is unreachable without quotes — is exactly the kind of thing
that produces confidently-wrong output. Same family as the one-way door, which the primer *did*
give me.

**(A) PRIMER-GAP — the `\` positions, enumerated.** §7 gives three: line start → whole line is
prose (`\|not-an-element`); immediately before a value → value is text (`:count \7 apples` → the
string `"7 apples"`); anywhere else → a literal backslash (`C:\Users\me`). The primer said only
"meaning fixed by **position** alone," which is the principle with the content removed. **I
predicted this specific gap in `03`** and it landed exactly.

**(A) PRIMER-GAP (thin) — a flag key can carry an explicit value.** §5: *"`:active?` — a flag:
present means true. (`:active? false` says no.)"* The primer's table row reads "flag key: bare
presence means `true`," which implies a non-bare form exists without saying what it means. Small,
but it's the difference between knowing `?` is part of the **key spelling** and thinking `?` *is*
the truth marker.

**(A) thin — `nil ≡ null`** stated as equivalence; the primer lists both as literals without
relating them.

**No (B), (C) or (D) this file.** Nothing the primer said was contradicted, nothing I misread,
and nothing I had invented got tested. That's a clean result for the primer's *accuracy* and a
poor one for its *sufficiency*.

## H1 scoring: supported, 4/4 in the predicted direction

`03` predicted: *"the surprises will cluster in generation-critical detail rather than in model or
philosophy… §3's 'two ideas predict most of it' is true for reading and materially insufficient
for writing."*

All four substantive gaps are generation rules — escape positions, brace choice, flow-value
quoting, flag spelling. **Zero** are conceptual; the model, the layering, and the philosophy
arrived intact from the primer. One file is not a result, but the direction is unambiguous and the
mechanism is now visible rather than inferred: the primer compresses by keeping *what is true
about UDON* and dropping *what you must do to produce it*, which is the correct compression for
its declared reader (a comparative reader who explicitly does not need to write) and the wrong one
for an agent.

Worth stating plainly for the primer work: **the two documents are not long-and-short versions of
each other.** The primer is a description; TUTORIAL is a procedure. An agent primer needs the
second kind and would not be produced by lengthening the first.

## One small cross-file inconsistency

§5 calls the sugar keys *"reserved-by-convention names (`$key`, `$traits`)"*. The primer is
explicit that they are **designated, not reserved** — any `$` key is legal, and the collision
defense is that `$` isn't a bare-key character so longhand requires quoting. "Reserved" is the
word the primer takes care to reject.

TUTORIAL is non-normative and says CORE wins, so this isn't a defect in the suite. Flagging it
because the loose word is the one that propagates: an agent that learns "reserved" will later
believe `$myfield` is illegal, and nothing in the tutorial would correct that. Not verified
against CORE yet — I have the primer's claim, not the ruled text. **Do not act on this until
CORE §4.5-equivalent is read.**

## What I now expect from CORE

- Appendix A to be the "annotated one-screen map" TUTORIAL points at, and to be the densest page.
- The escape rule to have more positions than three (TUTORIAL is teaching the settled core only).
- Something on what happens when a flow value contains marker characters — TUTORIAL's commitment
  rule covers prose, but a flow *value* after `:title` is a different position and I don't know
  whether commitment works identically there. **Flagging as a real hole in my model, not a
  prediction.**
- The `:active? false` case to interact with the desugaring: if `|el?` ≡ `:'$?' true`, what does
  `:active? false` desugar to, and is `active?` the key or is `active` the key with a `?` marker?
  I genuinely don't know and the tutorial's phrasing works either way.

---

## Wandering

The tutorial teaches almost entirely in **contrast pairs** — *whose name is it* (attribute vs
child), *open→commit* (marker vs text), *braces vs no braces* (inline text vs node value), *bare
vs quoted* (flow vs terminated). It never gives a rule without giving the thing the rule is
against. In `03` I guessed that rules-with-their-defeated-alternative resist degradation under
recall, because a plausible wrong neighbor doesn't fit the reason; a contrast pair is the same
mechanism in a cheaper form — it encodes the neighbor *directly*, so misremembering it produces a
visible collision instead of a confident substitute. That's now two independent artifacts in this
estate (the primer's §4 commitments-with-defeated-alternatives, and this) built on what looks like
the same insight about how instruction survives transmission. Neither says so. If I were writing
the agent primer, that would be the organizing principle rather than a stylistic tic: **every rule
ships with the thing it isn't.**

Second, a thing I want to record before CORE gives me more precise vocabulary and I lose the
naive form of it. §9 ends: *"If a tool built on UDON loses your bytes, the tool is wrong."* That
sentence is doing something the primer's equivalent doesn't — it converts a language property
(keep-everything, severity-by-loss) into an **obligation on a third party** the reader might
become. The primer states the same content as a fact about UDON; the tutorial states it as a rule
about you. And I notice the tutorial's version is the one I'll remember, which is uncomfortable
because it's also the less precise one. Possibly the lesson is that a spec property becomes
memorable exactly when it's re-expressed as a constraint on the reader's future behavior — which
would be an argument for an agent primer being written in the second person about *what you must
not do*, not the third person about what the language is. That's a testable difference in primer
design and it would be cheap to run: two primers, same content, one descriptive and one
obligation-shaped, then measure conformant generation.

Third: I keep noticing that the material which would have saved me from error is distributed
across documents by *audience* rather than by *topic*. The flow-value quoting rule lives in
TUTORIAL because it's a writing hazard; the flow-value *definition* lives in the primer and
presumably CORE because it's a model fact; the reason multi-line lists are unreliable lives in
CARVEOUTS because it's an open question. Three files, one topic, and no single document from
which an agent could generate correct UDON involving a multi-word attribute value near a list.
That's not a criticism of the suite — the split is principled and each file is honest about its
scope — but it does suggest the agent-primer question isn't "which existing file to extend." It's
that the suite is organized for *specification*, and generation cuts across its axes. If that's
right, the artifact wanted is a **hazard-indexed** document — organized by the mistake, not by the
concept — and it would necessarily be assembled from all three registers. I'd want to test that
framing against the December usability harness results before believing it, since that harness
apparently measured agent enablement over UDON contexts and might already say what agents actually
get wrong. I haven't read it. Noting that as the next thing I'd reach for if the primer work
becomes the task, rather than reaching for it now.
