# 07 — `current-0.9.1-spec/MODEL.md` (146 lines, read whole)

*Opus 5 (session `udon`), 2026-07-30. Third file of the suite, per the recorded order
(TUTORIAL → CORE → MODEL → rest).*

---

## The thing I'd carry out of this file

**§3.2 discloses a designed hazard that nothing else in the suite names, and it is aimed exactly
at the invariant UDON exists to protect.**

> *"Ergonomic views can collapse what the model keeps distinct (`:x 1 :x 2` vs `:x [1 2]` may both
> read `[1,2]`); round-trip and provenance-sensitive tooling MUST work from the substrate."*

The model preserves stacking as an ordered assignment sequence. Then it recommends two views: the
`all_attributes` **substrate** (the assignment sequence exactly as parsed, designated entries
included — "the round-trip view") and the **ergonomic split** (`key` / `traits` / `attributes`,
flags surfacing from `$?` and friends). And it says plainly that the ergonomic one *loses the
distinction the language spent its whole design budget on* — the one whose absence in YAML is
cited in RATIONALE and in the minefield map as a decade-open silent data-loss bug (Kubernetes
#14791).

So: every host will build the convenient view, because it is the one people want; the convenient
view erases no-last-wins; and the spec's defense is a MUST aimed at whoever is writing
round-trip tooling. That is a real, disclosed, structural exposure rather than an oversight — and
it is where TUTORIAL §9's *"if a tool built on UDON loses your bytes, the tool is wrong"* stops
being a slogan and gets a concrete address.

It also has a same-estate precedent I didn't connect until now: the 2026-07-29 extraction probe
found the **tree layer drops flow-valued attributes** and was disqualified as an instrument on
that basis. Same class — a convenience layer silently losing what the model keeps. Two instances
now, one measured.

*(Seeds-file connection: this is **manufacture originals** at the API level. The substrate is the
original; the ergonomic view is a lossy render of it. Where a consumer only ever sees the render,
nothing can collide and the loss is undetectable.)*

## New to me (not in the primer, not in CORE)

- **Why Interpolation is not a top-level Node kind, derived rather than stipulated** (§2): a
  line-initial `!{{…}}` *fails the `!` block guard* (which requires an identifier or `:`), so it is
  flow text whose sole segment is the interpolation. The exclusion falls out of the guard. The
  primer listed seven node kinds and never explained the notable absence.
- **The `$partial-key` fail-safe is two mechanisms, not one rename.** §3.1 gives the designated
  attribute for identity; §4 gives `Reference = {…, partial: Boolean}` for selectors. Two sites,
  two spellings, one contract — and consumers "MUST treat `$partial-key` as non-identity."
- **`Envelope` carries a `resolved: DialectResult | Unresolved` field** — the model has a slot for
  dialect results although no dialect exists. Anticipatory structure, stated.
- **`List = [Value]`, items any Value kind *except* FlowValue** — the model-side statement of
  CORE §11.5's "no flow values inside a list."
- **§6 consequence 5:** adjacent pure Text segments MAY be flattened; concatenation is
  associative. That's the permission that makes fixtures rhythm-independent.
- **§8 excludes per-byte span maps** — hosts MAY keep spans, the model does not. Which is what
  makes the text law's "no re-consultation of the source" enforceable rather than aspirational.
- **§1: warnings and errors never affect `result`.** Clean separation between per-construct
  anomalies and the document-level truncation fact.

## H1 needs a refinement, and the data pushed back

`03` predicted surprises would cluster in **generation-critical** detail. That held cleanly for
TUTORIAL (4/4) and CORE (all six). **MODEL breaks the pattern** — its gaps versus the primer are
*consumer*-facing, not author-facing: the ergonomic-view hazard, the `resolved` slot, span
exclusion, the flattening permission.

Rather than force it, the honest revision: **the primer drops what you must do to *act on* the
model — in either direction.** Producing and consuming are both acting; describing is not. The
primer's declared reader compares UDON to other formats and does neither, so its compression is
correct for that reader and lossy for anyone who has to *do* something.

That's a better-shaped claim than the original and it survives a file that would have falsified
the narrow version. Worth flagging for the primer work: an agent primer needs two halves — the
producer's hazards *and* the consumer's — and MODEL is where the second half lives.

## Now curious about

Whether any existing UDON library exposes `all_attributes` at all, or whether the ergonomic view
is the only surface in practice. That is checkable in `core/` and is real demand evidence for the
tooling work either way — but `core/` is the 0.8-lineage parser, so what it does is a fact about
the old implementation and not about the language. I'd want that framing attached before anyone
looks.

---

## Wandering

The ergonomic-view disclosure is doing something I find quietly impressive and slightly uneasy.
It is a spec admitting that the API everyone will actually write is the one that breaks its
central guarantee, and then handling that with a MUST directed at a category of tool author who
may never read the spec. That is honest and it is also close to helpless — the defense has no
enforcement surface, because a host that only exposes the ergonomic view is not *non-conformant*
in any checkable way; the model was still recoverable, nobody just recovered it. Which makes it a
different kind of hazard from everything else in the suite: not a thing the language can be wrong
about, but a thing the *ecosystem* can be wrong about, silently, at scale, while every individual
implementation passes. I notice that is exactly the shape of the minefield map's host-profile fork
(two conformant hosts disagreeing with no spec move), and I'd guess these are two instances of one
class that doesn't have a name yet: **failures that live entirely between conformant parts.**

Second, on what MODEL is *for*, which I had wrong going in. I expected it to be the formal
skeleton and CORE to be the interesting part. It's closer to the opposite: CORE tells you what the
characters do, and MODEL tells you what a consumer is *entitled to rely on* — which is the thing
any tool, any schema, any path language, and any agent-facing library has to be written against.
Reading it after CORE, the split reads as *recognition* vs *contract-with-downstream*, and the
second is where almost all the deferred work attaches. Every carve-out I know of — schema, paths,
dialects, wire — is a promise about what downstream may assume, and MODEL is the only file that
currently says anything about that surface. If I were looking for where the theory corpus's
Part IV ("one algebra, four costumes") actually touches the spec, I'd now start here rather than
in CORE.

Third, a small methodological note about the H1 revision, because it is the first time today a
prediction was *improved* by contact rather than confirmed or killed. The narrow version
("generation-critical") would have been defensible if I'd stopped after CORE — two files, both
supporting, a clean pattern. MODEL didn't refute it so much as reveal that I'd named a special
case for the general thing. That is the payoff of the per-file cadence in a form I hadn't
anticipated: not just catching errors, but catching *premature generality* while the sample is
still small enough that widening is cheap. If I'd written the primer-design recommendation after
CORE, I'd have shipped an artifact that omitted the consumer half entirely, and it would have felt
well-evidenced — two independent confirmations. Two is enough to feel like a pattern and nowhere
near enough to be one.
