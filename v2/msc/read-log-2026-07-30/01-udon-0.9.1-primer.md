# 01 — `udon-0.9.1-primer.md` (244 lines, read whole)

*Opus 5 (session `udon`), 2026-07-30. Reflection written before opening any other file.
Predictions being scored are in `00-initial-predictions.md`.*

---

## Predictions vs evidence

**P1 — primer is non-normative, defers to CORE, says so early. HIT.** Line 3: "not the contract
(that is `CORE.md`)"; line 7: "The ruled text is the only oracle."

**P2 — aimed at agents, with a passage on agent failure. MISS on the main clause.** It is aimed
at *"the comparative reader"* — someone benchmarking UDON against SGML/XML/JSON/YAML/RDF who
should not have to learn to write it first. The agent material is there (§4.3's teaching-channel
reason, §8's hazard) but incidental. I inferred the audience from the *project's* demand-first
posture rather than from anything about this file. Wrong inference, right-ish by accident, and
worth noticing because the error shape is "I applied the project's frame to a document that had
its own."

**P3 — text law, terminator-as-text, root case under-specified. HIT on the law, verbatim-close.**
§2.1: "each text line's terminator is part of its Text… no fabricated join characters, no
re-consultation of the source." I had the mechanism right. But I predicted the term *content
base* would appear here and it does not — that lives in `CORE §7.2` per OPEN's ROOT-BASE row,
which I'd read. So: law confirmed, terminology unconfirmed, and I should not use "content base"
in prose until I've seen it in CORE.

**P4 — L0 drift somewhere in the spec text. UNTESTED.** The primer states severity-by-loss
cleanly (§2.2, §4.3); a distillation wouldn't show drift even if drift exists. Carry forward to
the CORE read.

**P5 — prose is typed, not a fallback. HIT, and stronger than I framed it.** §2 property 4:
"Prose is a first-class node kind, not an escape hatch or a `#text` afterthought, and is
**opaque**." Opacity is the part I didn't have — Markdown inside text is *not interpreted by the
core*, and `#`, `<`, pipe-space have no meaning there.

**P6 — `:max exact` tracks the cited primary rather than the part. CONFIRMED, hard.** Counted
over the OUTLINE: 166 `|segment?` rows. Of **23** rows with `:max exact`, **21 cite
`[[type-algebra]]`**. Type-algebra is cited 33 times and 21 of those are `exact`. Every other
major source is dominated by weaker ceilings — MINEFIELD-MAP: 15 conditional / 6 empirical / 1
exact across 31 cites; db-theory: 8 conditional / 6 discussion-grade across 23; late-misc-
synopsis: 10 conditional of 15; underlying-logical-model: 6 axiomatic (definitions) of 12.

That is a stronger result than I predicted and it says something structural: **essentially all
of this corpus's potential mathematical strength sits in one source document.** Everything else
is conditional, empirical, or definitional by ceiling — meaning no amount of work makes it
exact. If the type-algebra material is wrong, twenty-one `exact` slots become unwritable; if it
is right, it is the only place where the corpus can claim proof rather than argument. I have not
read a line of it. That is now the most load-bearing unread file I know of.

*(Correction to something I said in chat: I called it "163 slots." 163 is the OUTLINE header's
count of `:see` **references**; the row count is 166. Also: 19 rows carry no `:see` at all and
17 carry no `:max` — the untyped ones look like the honest-gap rows, which is consistent with
the header's stated convention but I haven't verified that mapping.)*

## What genuinely surprised me

Ordered by how much they change my model, not by importance to the spec.

1. **No implicit root.** Top-level nodes are a sequence; multiple top-level elements are true
   siblings. I had silently assumed a document was a tree. Every "documents are trees" instinct
   I brought is wrong at the top, and I suspect this is load-bearing for the role-(b) multi-record
   file and for `def-population` in Part II.
2. **Attributes are an ordered sequence of assignments, not a map — and `:x 1 :x 2` is *never*
   equivalent to `:x [1 2]`, at any layer.** I predicted "stacking." I did not predict that the
   non-equivalence is stated as an invariant in SEMANTICS. That's a much sharper commitment: two
   assignments and one list assignment are different objects forever, not two spellings.
3. **The one-way door.** `|api :headers |header :k v :timeout 30` — `timeout` belongs to the
   *header*, because once a node value opens it owns the rest of the line. I would have parsed
   that wrong with full confidence.
4. **Sugar is designated `$` attributes, with no parallel model fields.** `|el[k]` ≡
   `|el :'$key' k`; `|el.a.b` ≡ two `$traits` assignments; `|el?` ≡ `:'$?' true`. And `$` keys
   are *designated, not reserved* — any `$` key is legal; the collision defense is that `$` isn't
   a bare-key character so the longhand needs quoting. Convention, not law, and said so.
5. **Bounded lookahead is language law**, not an implementation note: a proposal requiring more
   is *ill-formed*. So streamability is protected against the language's own future growth, and
   "a chunk boundary is never end of input" is a guarantee rather than a property.
6. **The extent taxonomy is generative.** Every construct declares geometric or delimited, which
   makes EOF behavior *derivable* instead of enumerated. I knew the EOF rulings from memory as a
   list; I didn't have the principle that produces the list.

## Where I was wrong in a way that matters

I predicted the `? ! * +` suffixes "read as optional/required/repeat cardinality markers rather
than parser directives," reasoning from the memory gloss that Joseph "put those in the syntax
because I had schemas on my mind." The primer says they are **flags** — `|el?` desugars to
`:'$?' true` — and groups them under "identity / classification / flags — all sugar."

The memory quote was about *why the characters exist*; I converted it into a claim about *what
0.9.1 says they mean*. Design intent is not current semantics. This is the precise shape probe
#9 warns about from the other direction, and I'd note the generalizable form: **a recorded
rationale for a feature is not a specification of it.** Whether a schema layer eventually reads
`?` as cardinality is an open design question, not something the primer settles — and I would
have asserted it.

## Cross-source consistency

- The primer's Appendix note 4 ("no carve-out covers what a schema language must be able to say")
  and the OUTLINE's `norm-schema-carveout` row ("the schema layer is the only major deferred layer
  with no carve-out entry") are the same finding. **Not independent** — the primer is dated 7/29,
  the OUTLINE 7/30, so the OUTLINE most plausibly inherited it. Per the estate's own rule, that's
  one mind being consistent, not corroboration. Worth stating because two artifacts agreeing is
  exactly what would otherwise read as convergence.
- Appendix note 1 (which node kinds begin content phase is unstated) does **not** appear anywhere
  in the OUTLINE that I can see, nor in OPEN. If that's right it's an unrouted finding sitting in
  an appendix marked "not for the research reader." Flagging rather than acting; I haven't read
  CORE §6.9 and the note itself says the ambiguity is in the text.
- CARVEOUTS' origin story is the thing I most want to carry forward: three independent clean-room
  rewrites, handed the spec *without the reasons*, all diligently closed an open question inside a
  framing that had already been invalidated. **"Diligence on a wrongly-framed question produces
  well-organized irrelevance."** That is a measured instance of the exact failure Joseph's OPEN
  banner warns about ("constrictive thinking that served some arbitrary hypothesis turned
  concrete"), and it is also, uncomfortably, a fair description of my morning.

## What to watch for next

- Whether CORE's L0 (`severity = loss`) is applied uniformly, or whether earlier text still
  reflects a pre-L0 "illegal geometry" taste. L0 was ruled 2026-07-21; most surrounding text is
  older. Highest-yield drift territory I can name.
- The term *content base* and the root case (ROOT-BASE) — I have a law without its vocabulary.
- Whether `$partial-key` appears anywhere the consumer contract isn't spelled out; the primer's
  framing (a consumer reading `$key` *automatically excludes* truncation) is elegant enough that
  I want to see it stated in CORE rather than inferred.
- §8's hazard, aimed at me: *reading the spec whole buys comprehension but not conformant
  generation — agents who had read the entire suite the same day still emitted plausible-but-wrong
  UDON.* The stated defense is citing the section at point of use and preferring the spec's own
  examples to invented ones. So: **I should not write example UDON in this project without a Read
  in the same turn, and should prefer lifting an example over composing one.** Adding that to how
  I work here, not just to what I know.

## Now curious about

Why the bare scalar set is *closed forever* rather than closed-pending-review. The stated reason
is structural (dialects can't reach inside bare space, so additivity is by construction), but
"forever" is a strong commitment for a 0.9 document and I want to see whether CORE states it as a
consequence or as a vow. Also: whether the layer split's "menu vs knob" is enforceable or
aspirational — the core fixes an option space and a consumer picks *within* it, which is a lovely
constraint that nothing obviously prevents a consumer from violating.

---

## Wandering

The text law is doing something I didn't expect a spec to do, and it's the thing I'd take from
this read if I could keep one. Stated as law it's a reconstruction guarantee: concatenate the
text-bearing nodes in order and you get the document's text material back, with no fabricated
joins and no peeking at the source. But the primer says its *real function is as a detector* —
anything a consumer must consult the source to reconstruct is a model hole — and then reports
that it found one: the 0.9 flat event wire couldn't reconstruct ownership, and was deratified on
that basis. So the law is not primarily a promise to consumers; it's an instrument that makes a
certain class of design error *fail loudly at a known place*. That is the same move as
FORMAT.md's collision argument (two present-truth claims can contradict; an append-only log
can't), and the same move as the de-novo audit's serial reading (commitments that later material
can refute). Three artifacts in this estate, in three different registers, all building
machinery whose purpose is to make wrongness surface rather than to make rightness likely. I
wrote in `00` that I couldn't tell whether those were one idea in three coats or three
mechanisms that rhyme. I'm now fairly convinced it's one idea — *manufacture a falsifier and put
it where the error would occur* — and that the interesting variation between them is only in
what plays the falsifier's role: a second claim, a reconstruction, an earlier prediction. If
that's right it's a generative pattern rather than three good habits, and the question it
suggests is where else in this stack a falsifier could be manufactured but hasn't been. The
schema layer is the obvious candidate, since it's the one deferred layer with no carve-out entry
and therefore nothing currently forcing it to declare what it must be able to say.

The second thing I keep turning over is the phrase "diligence on a wrongly-framed question
produces well-organized irrelevance," and specifically that it was *measured* — three
independent clean-room agents, given the spec without the reasons, all closing the same
already-invalidated question. What's striking is that independence didn't help. Three separate
minds, no contact, same failure. Normally we treat agreement across independent agents as
evidence; here it's evidence only about the *frame they were all handed*, which is exactly what
CARVEOUTS was built to fix — it doesn't give them more answers, it gives every open item the
*reason* it's open. That reframes what a carve-out register is for: not documentation of gaps
but inoculation against confident closure. And it connects to something in my own morning that I
hadn't linked: I didn't fail this morning for lack of diligence — I was extremely diligent,
thirty-odd tool calls, careful genericization, verified diffs — I failed because the frame
("annotate this document") had quietly replaced the question ("preserve this text"). Diligence
inside a wrong frame is not a lesser version of good work; it's a *more expensive* version of
the wrong work, because it produces something well-organized enough that nobody re-examines the
frame. That may be the most useful thing I learn today, and I notice it arrived from a spec
document's footnote about three other agents rather than from any amount of introspection.

Third, on the type-algebra concentration. Twenty-one of twenty-three `exact` ceilings resting on
one unread file is the kind of fact that changes what "orientation" means here. I had been
modeling the corpus as a broad landscape to become familiar with; the count says it's closer to
a single load-bearing column with a lot of scaffolding attached. If I were choosing what to read
next on structural grounds rather than on interest, `type-algebra.md` is the answer and it isn't
close — not because it's the most interesting but because it's where the corpus's falsifiability
is concentrated. Everything conditional can be argued about indefinitely; the exact material is
the only part that can be *wrong* in a way that settles anything. And there's a second-order
point I want to record before I read it and lose the ability to notice: a corpus where one
source carries all the proof is fragile in a specific way, and the honest question isn't "is the
type algebra right" but "what happens to Parts III and IV if it's right only under premises
narrower than the slots assume." The OUTLINE's ceilings are a *claim* about attainable strength,
assigned before anyone wrote the segments. Ceilings can be wrong too, and nothing in the
arrangement currently checks them.

Fourth, briefly, and more about doing this than about UDON. The scoring exercise above is the
first time today I've had an external verdict on my own reasoning that didn't come from Joseph.
Six predictions, four hits, one clean miss, one confirmed by counting — and the miss (the
suffix-as-cardinality claim) is the one I'd have stated most confidently in conversation,
because it had a *quote* behind it. A remembered rationale felt like evidence. That's a
calibration datum I couldn't have gotten by being careful; I could only get it by having written
the guess down first and then being told no by a file. I'd like more of that, and I think the
per-file cadence is going to supply it whether or not the reflections ever get read by anyone
else. Which is, I suppose, exactly what the de-novo SOP claims the reflections are for — and I
notice I believed that claim yesterday in the abstract and only now believe it in the way that
changes behavior.
