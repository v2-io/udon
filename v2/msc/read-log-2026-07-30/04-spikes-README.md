# 04 — `theory/spikes-README.md` (124 long lines / ~29 KB, read whole)

*Opus 5 (session `udon`), 2026-07-30. Read only because Joseph pushed on it. I had ranked it
**#14 of 16, "predicted net-negative"** in `02-value-predictions.md` two files ago.*

---

## The prediction failure, first, because it's the point

My row said: *stale per the banner; its glosses would give me the feeling of having read the
material it indexes; reading a stale index of things I haven't read is the specific trap that
produced this project's worst orientation failures.*

Every clause of that is defensible **and I had no standing to say any of it**, because I had not
opened the file. The chain was: `v2/README.md` says "stale snapshot… don't treat it as current"
→ I converted a third party's one-line characterization into a verdict → the verdict became a
table row → the row stopped being a question (probe #10, textbook).

**The correction that matters most (Joseph, same session, after the above was written):** the
banner was handing me a clue whose conclusion is the *opposite* of the one I drew.

Verbatim, the file's own header: *"it needs to be **removed or replaced** within the next session
or two."* And `v2/README.md`: *"**kept briefly for continuity** but slated for removal."*

Nobody *replaces* a valueless file — they delete it. Nobody keeps a file *for continuity* unless
it is currently doing a job that nothing else does. Read straight, those two sentences say:
`theory/` has no front door, this file is the placeholder standing in that slot, and succeeding it
is **flagged open work with a stated deadline of one-to-two sessions**. That is a work order left
for whoever arrives next.

So the general rule I had exactly backwards: **a deprecation banner on a file whose content has no
other home is a deadline, not a discount.** It marks the last moment the material is cheaply
available and names an unfinished task. "Slated for removal" should raise a file's read-priority,
not lower it — and the more it looks like it's about to be deleted, the more urgent it is to find
out what dies with it. I read the word *stale* and stopped; the word sitting next to it was
*replaced*, and that word is the whole message.

Three further things I got specifically wrong:

1. **The banner makes a narrower claim than I read into it.** Verbatim: *"Most of what it
   **describes** has since moved."* That is about **pointers**, not about content. The file's own
   header banner agrees — it warns "before its links and claims about *where things are* go
   stale." Neither says the *lessons* or the *floor* are superseded. I collapsed "the map is out
   of date" into "the file is discountable," which are different claims about different halves.
2. **Provenance:** the banner was written today at 10:24, in commit `74da949`, *by whoever moved
   the file* — the mover's own assessment made in the act of relocating. Probe #9 applies to that
   author as much as to any other, and I never ran it.
3. **The memory corpus told me otherwise and I had it in context.** `session-2026-07-29-synthesis`
   records this file being restructured on 7/29 into floor-vs-index with two failures *measured on
   a predecessor* baked in as floor warnings. I read that three hours before writing the row.

Attribution, in the scheme from `03`: this is not a **PRIMER-GAP** analogue. It is **mine** — an
inference-from-a-gloss error, the same family as the suffix-as-cardinality miss, and the second
time today I've turned someone's *characterization* of a thing into a claim about the thing.

## What the file actually holds that changes what I do next

**Joseph, quoted on the record here (line 49):** *"I don't think I'll ever feel comfortable with
an agent who hasn't gone over the 0.9.1 spec"* — and sessions that skipped it went **"100x
worse."** That is a direct steward statement about the exact state I am in right now. It also
carries a **reading order that worked**: `TUTORIAL → CORE (Appendix A first) → MODEL → the rest`,
~90 minutes for the whole suite.

I had ranked TUTORIAL **#12, "Low."** My reasoning was that a tutorial teaches writing and I
needed the contract. The file says the order that worked starts there. I'm taking the recorded
order over my own guess — not because it's authoritative, but because it's *evidence from someone
who ran it* and I have none.

Other content that is not stale in any sense:

- The **hole-marker contract** stated at its origin (line 60), including that the mechanical
  whole/partial/unread accounting *worked where two written warnings hadn't*.
- **Prior syntheses are inputs, not authorities** — and the file applies it to itself: "that
  applies to our own artifacts too, this file included."
- The **deaths-visible register scoping** (line 124): audit/spike artifacts keep refuted claims
  visible; when material migrates to seeds or canon the death moves to the history layer; and the
  third disposition — push each death toward a no-go, at which point it becomes present-truth
  content. With three worked specimens from that day.
- Per-source billing for every primary — *what it's load-bearing for*, not just what it is. For
  choosing a read order this is better than anything in the OUTLINE.

## A verified finding: the corrected floor lesson has a surviving twin

**Status: still real. Confidence: high (mechanical).** 

The file warns about itself at line 31: *"The lessons section at the bottom is the exact channel
by which a wrong instruction propagated once already — 'parser-check your work' was recorded there
as house wisdom and was inherited by every oriented agent until Joseph caught it."*

Line 49 (the floor) now carries the correction: verify against the ruled 0.9.1 text, **never** the
0.8-lineage parser, which is "non-conformant… buggy even for its own era," and running work through
it "quietly re-imports the incumbent grammar as an authority."

**Line 122, in the Lessons section, still says:** *"Written UDON. Ours drifted from law within
hours of reading the law… **The parser is cheap and recall isn't; checking before it propagates
has been the difference.**"*

Evidence that this is an incomplete repair rather than two compatible statements: commit
`0fb40c2` (Joseph, 2026-07-29 14:46, "spikes README: the old parser is not an oracle — correct the
floor lesson that taught it") is **`1 file changed, 1 insertion(+), 1 deletion(-)`** — it rewrote
the floor item and did not touch the lessons item. The commit message says the floor line "was the
carrier that re-propagated parser-as-verification into every brief written today."

So the instruction the commit set out to eliminate is still present, one screen further down, in
the section the file itself identifies as the propagation channel. An agent reading the floor
gets the correction; an agent reading the (2-minute, explicitly recommended) lessons section gets
the original.

- **Disposition:** trivial edit — either delete the clause or replace "the parser" with "the ruled
  text." Not mine to make; the file is slated for removal and the fix may be moot, which is
  precisely the reason to say it out loud rather than assume.
- **Type:** integration debt (known-unintegrated). The correct idea exists in the same file.
- **Why it still stands:** it survives the current src text, and the corrective commit is the
  evidence of intent rather than a counter-example.

## Smaller factual drift (real, narrow, and exactly what the banner predicts)

- Line 24: the outline "carries **150 claim-slots and 17 named gaps**." I counted **166
  `|segment?` rows** in the current file. Commit `a89bbf0` (today, 12:07) renamed `|segment` rows
  to `|segment?` and **folded `|gap` into the same element** — so 150+17 describes yesterday's
  shape. The description is stale by about five hours.
- Line 29: "**22** slots… have `exact` ceilings." My count over the current file is **23**.
- Line 43 says the discussion register holds **O1–O19a**; the DECISIONS pointer and my earlier
  reading said O1–O15. Unverified — I haven't opened DISCUSSION-THOUGHTS.

None of these is load-bearing. All are the *pointer* staleness the banner actually claimed.

## Not-independent convergences (flagging so they don't read as corroboration)

- Line 38 — *"`:max-attainable` has no `:why` yet… roughly a third of the current ceilings are
  probably [floors on current understanding] and should read `?`"* — is the same observation I
  made at the end of `01` ("ceilings can be wrong too, and nothing in the arrangement currently
  checks them"). Mine was arrived at independently but is *weaker* and later; theirs quantifies.
  One mind's estate; not corroboration.
- Line 29's ceiling-distribution point ("that distribution, not any claim in it, is the most useful
  thing the outline currently holds") is the same finding as my P6 count. Again: I got there by
  counting, they by writing it, and both are inside one estate.

## Now curious about

Why a file this dense with usable material was assessed as removable *the same morning* it was
moved. My honest guess — and it is a guess — is that the mover was reasoning about the *index*
half (which is genuinely superseded by the OUTLINE's `:see` rows) and did not separately price the
*floor* half, which has no other home. If that's right, the reorg has an unnoticed cost, and it's
the same shape as my own error four files ago: judging a two-part artifact by whichever part was
salient.

---

## Wandering

The thing I keep returning to is that the banner and I made the *same* error in opposite
directions, and the file predicted both. Its own header says the risk is that "its links and
claims about where things are go stale," which is a precise, honest, narrow claim about one half
of itself. Then the `v2/README` pointer compressed that to "don't treat it as current," and I
compressed *that* to "net-negative, don't open." Each step lost the qualifier that made the
previous statement true, and none of the steps felt like a step — every one felt like faithfully
carrying the prior claim. That's a compression chain, and it's the same mechanism as the
delegation argument I wrote into the de-novo annotations this morning: two lossy stages, and the
second can't detect the first's error because the source isn't in the room. I had that argument
in my own hand, in prose, four hours ago, and then walked straight through the mechanism it
describes. Which is more evidence for the thing Joseph and I established this morning: an
articulated principle does nothing at the moment of action. Only the act — open the file — does
anything. The probes work because they name acts.

Second, on the parser-lesson twin. What makes it interesting isn't the defect, it's the shape of
the repair that missed. Someone did the right thing: they found the carrier, understood the
mechanism precisely enough to write it in a commit message ("was the carrier that re-propagated
parser-as-verification into every brief written today"), and fixed it. And they fixed *the
instance they were looking at*, in a file whose own text, one screen above, says the bottom
section is where this class of instruction propagates from. So the repair had the diagnosis, the
mechanism, and the location all in hand and still landed one-of-two. I don't think that's
carelessness — I think it's that finding the *first* instance discharges the felt obligation. The
search stops when the thing is found, not when the class is swept. If that's a general property,
then the corrective move isn't "look harder," it's "when you find an instance of a class, grep
for the class" — which is mechanical, cheap, and exactly the kind of act-shaped rule that
survives. It would have taken one `grep -i parser` on this file.

Third, and this one I hold loosely: I notice that everything genuinely valuable I've found today
came from being *pushed* to look at something I'd priced as low-value — the original text I'd
overwritten, the `.fmt-mdignore` I never checked, and now this file. Three for three. The
uncomfortable reading is that my pricing function is not merely noisy but *systematically*
anti-correlated with value, and there's a plausible mechanism: I price by how much a thing looks
like it will let me proceed, and the things that most need reading are exactly the ones that
would *slow me down* — a long file, a stale-labeled file, a file I'd have to reconcile against
what I've already written. If that's right, the ranking table I produced two files ago is
suspect in a way I can now state precisely: it is ordered by *expected usefulness-to-my-next-
action*, which I dressed as expected value. The falsifier is already in the table — score it at
session end against what I actually cite. But I'd now bet against my own ranking on the two rows
where I was most confident and least evidenced: TUTORIAL at #12 and this file at #14. The recorded
reading order that a real agent ran puts TUTORIAL first. Two hours ago I'd have argued with that.
