# For Joseph — pilot A, cycle 1 (Intro + Part I opening four)

Two kinds of entry, per the steward channel: a call that smells like yours, and
a couple of findings I suspect may fire your memory.

## A call that is genuinely yours (a design ruling I made and want ratified)

**The shape of the epistemic-status recalibration.** The first-cycle work item
said the evidence tiers are provenance-genres not epistemology, and named ASF's
ladder (exact / conditional / robust-qualitative / heuristic / discussion-grade)
as the model. It did not say *how* the strength axis relates to the existing
register axis (derived/evidenced/decided/proposed). I ruled it this way, and it
is a real call, not a mechanical follow-through:

- **Three orthogonal axes**, not a merge: **genre** (where evidence came from) ·
  **register** (what kind of speech-act the claim is) · **strength** (how
  defeasible it is).
- **Strength only applies to the two truth-apt registers** (derived, evidenced).
  A **decided** claim takes *no* strength rung — a decision isn't strong-or-weak,
  it's a different kind of object; asking "how confident are we that we chose X"
  is a category error. A **proposed** claim is *hypothesis* by definition, so its
  register already fixes its rung.
- I extended ASF's five rungs with **measured** (empirical-number-with-conditions)
  and **hypothesis** (untested prediction), because this report has empirical and
  imaginative claims the pure-theory ladder doesn't cover. Flagging the extension
  explicitly in case you want the report to stay closer to ASF's exact five.

If any of that is wrong-shaped, it is cheap to change now (it lives in the
methods chapter's "The three axes" + "The frontmatter machinery" sections and is
propagated into four chapters' frontmatter + the counter-register Weight column).
The full reasoning + the alternatives I considered are in
`notes/pilot-A-workflow-feedback.md` Part 5 item 1.

## Findings that may fire your memory

1. **The κ×A strengthening — is the "wrapping is a certificate, not a knob"
   framing yours, and stated where I can cite it exactly?** In
   observation-infrastructure I strengthened "A is the one knob anyone gets" by
   naming the W₁/W₂ wrapping constructions and arguing they don't dislodge A —
   they buy a *provable* separation certificate, not a material behavioral bias
   reduction. My source is the asf-dossier's rendering of
   `disc-w1-structural-bound-boundary.md`: *"the thing being bought is a proof,
   not a meaningful behavioral delta."* That is a sharp, quotable line. If there
   is a crisper primary statement of it in the ASF corpus (or if the
   dossier's compression drifted from your intent), that is exactly the kind of
   thing your read would catch that no search of mine would. The strengthened
   claim is load-bearing for the whole chapter's "existential, not ergonomic"
   thesis, so it is worth your eye.

2. **The refusal-contract laws-file idea (errors-that-teach capability card 1).**
   I proposed that a tool's machine-readable `law:` fields could accumulate
   across a session into a durable, inheritable laws-file — "the slow stratum of
   the world model made explicit." This felt, while writing it, like it might be
   a thing you have already built or sketched somewhere in the PROPRIUM/CHRONICA
   or shoshin work (a laws layer distinct from episodic memory). If a precedent
   exists, it upgrades this card from *proposed* to *evidenced-elsewhere* and I'd
   want to cite it. If it doesn't, the card stands as a proposal — but your
   memory is the only place that distinction is stored.

3. **A small register datum, offered as amusing-but-real.** Writing the methods
   chapter, I hit the exact thing its own text already notes — that the report
   had to *invent* a typographic convention (`> [!capability]`, the strength
   rungs in bold) to mark a claim's register, which "is itself a small demand
   datum for the notation work: registers-on-content is exactly what a
   structure-and-prose format could carry natively." I felt that friction
   first-hand doing the retrofit: I was hand-maintaining register metadata in
   prose and frontmatter that a UDON attribute (`:register proposed
   :strength hypothesis`) would carry structurally. Live dogfooding evidence for
   the annotation-and-metacognition chapter's thesis, from inside the report's
   own production.

---

# For Joseph — pilot B, cycle 1 (the V/VI straddle)

*(A note on convergence first: pilot A's point 3 above — that producing this
report forced us to hand-invent a register convention a UDON attribute could
carry natively — is a datum I hit independently doing the annotation retrofit.
Two pilots, different divisions, same friction, unprompted. Logging that we
converged, because convergence-across-independent-vantages is the report's own
unit of proof and it applies to us too.)*

## A call that smells like yours (ruling-adjacent — the annotation designator)

Deepening `annotation-and-metacognition`, I went to CORE to check a hedge in
the chapter ("`$`-designated attributes *nearly* [strippable]"). What I found
strengthened the chapter: the **designated-attribute accessor split**
(`all_attributes` includes the `$`-names; `attributes` excludes them) is
*already* a strippable-AND-queryable channel by construction — a designated
annotation is an ordinary attribute (path-queryable) that the plain-attributes
accessor drops (dumb structural strip). So the "strippability vs queryability"
tension the chapter called unresolvable is mostly resolved by a mechanism you
already shipped for identity/traits. I rewrote the chapter to say so.

**The call that's yours:** the general *designator* question is on record as an
OPEN stub (DECISIONS S15). The chapter now leans on the *shape* of the
designated-attribute mechanism without claiming UDON has a ratified annotation
designator — but the natural next question is exactly that: **would you want
annotations (confidence / decision / uncertainty / provenance) to be a
designated-attribute class** — some marker in the `$`-family or a sibling — so
they inherit strip-by-accessor and query-by-path for free? And the narrower
design question I reframed the chapter's tension into: what should *stripped*
mean — **view-level exclude** (accessor omits it, text keeps it; free today) vs
**text-level erase** (physically gone from the bytes, like a stripped comment;
needs a serializer pass)? Annotation may want both, for two strip-meanings.
I've left this as the chapter's stated open problem rather than guessing your
intent — flagging because it's a live-ledger adjacency, and because you
designed the `$` mechanism, so you'll know instantly if I've read its reach
right or wrong.

## A finding that may fire your memory (templates de-novo → seal boundaries)

I ran a de-novo end-user elicitation on templating/dynamics (cross-lineage
agent, no project context) to thicken the report's thinnest chapter — landed
whole at
`01-ideation/02-provenanced/copies/de-novo-testimony/templates-testimony-grok-2026-07-22.md`,
weighed as one unprimed practitioner's account. It independently reproduced the
chapter's own structural claims (interrogable-contract templates;
interpolation-to-text vs structural-splice as different operators that must not
merge — "same double-brace for both is a design crime"; failed-evaluation as a
document state), which is real corroboration.

The one that felt like it might already live somewhere in your work: **seal
boundaries.** The agent, unprompted, wanted a rendered region that becomes a
*commitment* (sent to a user, used as a premise by a later agent) and that a
re-run of the template **cannot silently change** — it must fork, version, or
explicitly invalidate dependents. That resonates hard with CHRONICA's
hash-chain / attested-history posture and with the annotation chapter's
verifiability-of-the-past demand. I landed it as a proposed capability card in
templates, but if there's an existing seal/commitment primitive in the
PROPRIUM/CHRONICA design, it upgrades from *proposed* to *evidenced-elsewhere*
and I'd cite it. Your memory is the only place that distinction is stored.

## A smaller one (revive-or-retire the old annotation syntax?)

The annotation chapter notes "an early experimental syntax [for agent residue]
exists in old material and is *not valid under the current language*." I left
it as-is (the chapter's discipline — conventions only until ruled — is right).
But if that old experiment is something you'd want reconsidered now that the
demand is stated three ways (design work + lived ELI testimony + theory), it's a
one-line steer and I (or the next window's agent) can pull it into the ideation.
