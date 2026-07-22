# Epistemology system for the monograph — pilot B's proposal

*Grounded in what the V/VI division actually needed: `typing-and-schema-boundary`,
`templates-and-dynamics-demand`, `annotation-and-metacognition`, `context-economy`.
Weighed against ASF's FORMAT.md + LEXICON (read whole, not from digest), pilot A's
cycle-1 recalibration (genre/register/strength), and Joseph's charge (ASF-grade
rigor with principled differences; cite-don't-rederive; more nuanced empirical
registers; truth first, transmissibility as part of truth). Divergences from pilot
A and open forks are flagged for the coordinator's honest synthesis, not averaged.*

---

## 0. The one thing my division proved before any theory

Chapter `typing-and-schema-boundary` has four evidence legs in a single "wound by
wound" list, and **each one fails differently and is repaired differently**:

- the YAML stress test — a *self-run, reproducible adversarial measurement*
  (duplicate-key detection rate = zero). Repair if doubted: **re-run the protocol**.
- the MCP fault taxonomy — an *external published measurement* (407 issues / 385
  repos). Repair: **check the primary study, seek a corroborating one**.
- the production ADR gotcha catalog — a *field/practitioner report* of what bit an
  engineer. Repair: **corroborate with another practitioner or reproduce the retype**.
- the schema-evolution design — *one author's design reasoning*. Repair:
  **ground-validate against an implementation, or get an independent design vote**.

Pilot A's ladder collapses all four into one rung, `measured` (or spreads them
across the T1–T5 *genre* codes, which say where they came from, not how to fix a
doubt). That collapse is exactly what Joseph's "more nuanced empirical registers —
result / observation / testimonial / synthetic / …" is reaching for, and it passes
the anti-collapse test the coordinator named: **split only where the labels route
to different repairs.** These four route to four different repairs. So the empirical
refinement is not a nicety I'm importing from ASF — it is a demand my own chapter
raised, and I can point at the four sentences that raise it. Everything below builds
out from that.

---

## 1. The status ladder, refined (the core proposal)

Keep pilot A's three-axis frame (genre / register / strength) but **replace the
single coarse `measured` rung with an empirical family whose members are defined by
their repair**, and **add an `inherited` status for cite-don't-rederive**. The full
ladder I'd propose for `strength:` (claim-grain; see §3):

| Status | Means | Repair when doubted | Where my chapters use it |
|---|---|---|---|
| **axiomatic** | foundational/definitional | n/a | rare — the report defines few primitives |
| **exact** | closed-form or zero-ambiguity result *established here* | find the mistake | typing: "duplicate-key detection rate is zero" |
| **inherited** `(asf #…)` | a result imported from ASF/AAT, **cited not rederived**; carries the source's status by reference, but *our restatement is independently defeasible* | check our restatement against the cited segment — do **not** re-derive | context-economy: the DL-budget, κ×A, the persistence condition, the reinjection channel; every capability card's theory-quantity impact field |
| **conditional** | holds under named premises (ours or inherited) | check the premises hold | context-economy: "context-stuffing helps then degrades" is an information-rate result under its premises |
| **robust-qualitative** | a direction/ordering across many cases, no magnitude | find a case where the direction reverses | typing headline; annotation headline; context-economy's four-families finding |
| **measured** `(self / ext)` | a quantity with stated conditions; sub-flag *whose* measurement | self → replicate the protocol; ext → check source + corroborate | typing: stress test (self), MCP taxonomy (ext); context-economy: 5K→250K, >85%, 30–50 tools (ext) |
| **observed** | a pattern across *shipped systems* / field, survivorship-corrected | replicate the survey; **check for descent** (copying ≠ agreement) | context-economy: the four mechanism families; typing: JS-family threshold folklore |
| **testimonial** | a first-person practitioner/agent account | corroborate with another voice/substrate | templates: the de-novo grok testimony; annotation: ELI testimony + the report's own dogfooding |
| **synthetic** | design-reasoning from one author's coherence | ground-validate against an implementation, or an independent design vote | templates: the owner's product vision; typing: the schema-evolution design |
| **heuristic** | a working rule, no proof, known exceptions | bound its exceptions | typing: the guessing-tax as operational guidance |
| **hypothesis** | an untested prediction | run the experiment | **every** capability-card "hypothesized impact" field |
| **discussion-grade** | framing/provocation, explicitly not load-bearing | — (honest about being a starting point) | scattered connective prose |
| **sketch** | direction identified, not worked | work it | annotation's open "which marker" question; templates' streaming question |

Why these five empirical members and not fewer: they are the five repair-routes an
agent actually has when it distrusts a "the world is like this" claim —
**re-measure, re-survey, corroborate-a-voice, ground-validate-a-design,
bound-a-heuristic.** Collapse any two and you tell a reader "here is a doubt" without
telling them "here is what to do about it," which is the whole value the label adds.

### The honest fork this creates (for the coordinator / Joseph)

My empirical split is **strongly correlated with pilot A's genre axis** (observed ≈
shipped-practice genre; testimonial ≈ agent-account genre; measured-ext ≈ external-
research genre). That raises a real question I will not paper over: **do we keep both
the T1–T5 genre codes and the empirical-status subtypes, or does the status subtype
screen off the genre code for empirical claims?** My chapters suggest the status
subtype is the one an agent *acts on* (it names the repair), while genre is passive
provenance. My instinct is: **keep genre as frontmatter provenance bookkeeping; let
the empirical status subtype carry the repair-routing; accept that for empirical
claims the two are near-redundant and that is fine** (they answer different questions —
"whose account" vs "how do I test it"). But this genuinely pressures pilot A's genre
axis toward dissolution for the empirical majority of claims, and that is a fork for
Joseph, not a thing I should decide unilaterally against a sibling's landed work.

---

## 2. `inherited` — the cite-don't-rederive status (my chapters need this most)

context-economy currently *re-explains* ASF results in its own words ("window limits
are a ceiling on sustainable plan complexity … an information-rate result, not
folklore"). Every one of my capability cards names a theory quantity (observation
ambiguity A, event rate ν, the DL budget, the reinjection channel, update gain) — and
every one of those is an ASF result being *leaned on*, not produced here. Joseph's
charge names exactly this: "referencing asf segments (#asf/aat/deriv-…) for most
derived stuff instead of rederiving."

**Proposal.** A first-class status `inherited (asf #slug)` meaning: *the result is
ASF's; we cite it, we do not reprove it; but the sentence on THIS page is our
transmission of it and can be wrong even if the source is right* (the coordinator's
"inherited-exact vs exact-here" caution, generalized — I'd make it `inherited`, not
`inherited-exact`, because what's inherited may be conditional or robust-qualitative
at the source, and we shouldn't launder it to exact). Two obligations travel with it:

1. **A dual citation form.** The wikilink convention already in the report
   (`[[FILE|word]]`) extends to `[[asf-theory-report#slug|plain gloss]]`. But the
   report's own external-document rule (Joseph, 2026-07-22) says harness-side readers
   cannot follow repo links — so an inherited claim **still carries a one-line
   plain-word gloss** on the page (teach-the-substance AND link). My capability cards
   already do this ("drives observation ambiguity A toward zero — goal-relevant
   content forward"); the `inherited` status just makes the discipline nameable and
   checkable.
2. **The transmission is audited, not the theorem.** The verification event for an
   `inherited` claim (see §5) is "checked our restatement against #slug on DATE," not
   "re-derived." This is cheaper *and* more honest than either re-proving (wasteful,
   and we're not the theory's home) or asserting (unaudited).

This one status carries more of my division's weight than any other single mechanism.

---

## 3. Claim-grain, not segment-grain (the capability card is already the unit)

ASF marks epistemic status at *two* grains: segment-level (`status:` frontmatter) and
claim-level (equation tags `*[Derived]*`, plus the "What Is Derived vs What Is Chosen"
derivation-audit table). My chapters **need the finer grain**, because a single bridge
mixes strengths constantly: typing's *headline* is robust-qualitative, but its MCP leg
is measured-ext, its evolution leg is synthetic, its "detection rate zero" is exact. A
segment-level `strength:` field (pilot A's frontmatter) cannot tell that truth; it can
only report the headline and hope the prose carries the rest.

**Proposal.** Adopt claim-grain marking, but realize it in the report's own idiom, not
ASF's LaTeX tags (the report has almost no equations — importing `*[Derived]*` would
be costume):

- **The capability card is already a claim-grain unit** — one card, one proposed
  claim, its own register (all cards are `hypothesis`). Keep it; it's the report's
  native equation-tag.
- **For load-bearing *body* claims that diverge from the chapter headline, say the
  status in words inline** (pilot A's "say the rung in words" rule — keep it), and
  where a chapter has three or more load-bearing claims at mixed strength, offer an
  **optional "What each leg carries" mini-table** — the report's analog of ASF's
  derivation-audit table. typing is the poster child: its four-leg list would become a
  four-row table (leg / what it carries / status / repair). I did not build these this
  cycle (out of scope mid-division), but typing, context-economy, and edit-representation
  are the chapters that would most benefit, and the table doubles as the reader's
  repair-map.

---

## 4. Coverage honesty = ASF's Search Log, and my Honest edges are already it

Every one of my chapters ends with **Honest edges** that are, structurally, a
search-log-plus-coverage statement: "three of the schema-family sources read at
depth, roughly thirteen not"; "single-source, one morning, zero implementations";
"no external evidence that annotations improve outcomes." ASF's Search Log vocabulary
— `not-conducted / cursory / targeted / nominally-comprehensive / comprehensive /
intuition-only` — is a ready-made discipline for exactly this, and it solves a real
hubris risk in *my* chapters: typing's ✦ idea "nobody has enumerated the undetectable
set side by side" is a **novelty claim**, and right now nothing says under what search
depth it's made. ASF's line "the Search Log is what prevents novelty claims from being
hubris" transfers to the report's demand-novelty claims almost verbatim.

**Proposal.** Adopt a lightweight coverage tag on Honest-edges claims and on any
"nobody has / no tool does" novelty assertion: a dated status from ASF's ladder. Two
high-value specifics for this report:

- **`intuition-only` is the right home for de-novo testimony and agent priors**, and
  ASF explicitly welcomes it ("honest priors made visible"). My templates de-novo
  yield and my own "I am the end-user, here's my friction" claims are `intuition-only`
  / `testimonial` — not weaker-so-hide-them, but *tagged so they're weighed as what
  they are*. This aligns exactly with Joseph's mid-run "tools for me" addendum: my
  first-person friction is admissible evidence *because* it's honestly tagged.
- **The "nobody has done X" novelty assertions get a search status or they don't ship
  as novelty.** Cheap, and it kills the exact hubris ASF's Search Log kills.

---

## 5. Stage = re-runnable checks, not a promotion ladder (Joseph's steward input, and my own felt need)

Joseph's steward note ("stages haven't been too useful … helpful for rigor but not as
gates that permanently change a forward-progressing state") matches what I lived this
cycle: I *rewrote* four chapters and the outline is morphing — a permanent stage a
chapter climbs-and-holds would be a lie within a day. And it matches my workflow-
feedback point 3: **the report is rich on what-to-do-when-a-claim-is-wrong and silent
on recording a claim that was checked and held.**

**Proposal.** Keep ASF's four gate *checks* as re-runnable rigor instruments, drop the
ladder:

- The four checks — **dependency audit** (does `depends:` hold and is each dep itself
  checked), **content review** (the three triage questions + label audit), **mechanical**
  (links resolve, cards well-formed, register words present), **notes disposition**
  (cross-notes disposed visibly) — are *checklists you run when landing or verifying
  work*, not rungs.
- Record verification as a **dated event, cheap to append, honest about going stale**:
  a per-chapter `verified:` block or a report-level verification log —
  `claim/leg → source → date → holds | adjusted | inherited-restatement-checked`.
  This is the "verified-at-source" record I asked for in workflow feedback, and it's
  exactly Joseph's "record what was verified and when … an event, not a permanent
  state." **Crucially it also carries the regression guard**: a `deliberately-corrected-
  away: X` line (context-economy's C7 five-votes→one-origin is the live example) so a
  future re-verifier is *told* not to "fix it back" toward the cleaner-reading original.
  Today that guard survives only because the RESIDUALS revision log happened to mention
  it — too fragile.
- `stage:` stays as a *warnings-only* draft-maturity hint (ASF's own 2026-07-14 posture),
  never a gate.

---

## 6. The lineage / convergence / corroboration problem → ASF's Related Work labels

The report's single hardest evidence problem — is uniformity across shipping harnesses
*agreement* or *copying*? — is live in my context-economy chapter (the C7 correction:
"one origin plus two or three rediscoveries, not five votes"). ASF already has the
vocabulary the report keeps reinventing in prose: **convergent-independent / direct-
anticipation / partial-anticipation / formalized-by / verified-by / conceptual-precursor /
adjacent**. These transfer almost verbatim to how a "converged" shipping-practice claim
should tag *what kind* of convergence it is.

**Proposal.** Adopt an open-ended relationship-label set (ASF's, lightly renamed for the
tooling domain) for the report's convergence and prior-art claims. context-economy's C7
becomes: deferred-loading = *one direct-origin + two convergent-independent + one
descent* — which is both truer and machine-sortable, and it's what the method chapter's
"corrected for who copied whom" discipline has been doing in longhand all along.

Corollary: **Novelty-claim postures** (synthesis / differentiation / novelty / transfer /
recognition) fit the capability cards — a card proposing seal-boundaries is a *transfer*
(commitment semantics from version control / CHRONICA into templating); one proposing
the undetectable-set taxonomy is a *novelty* claim (under stated search). Lead the card's
provenance line with the posture. Adopt, lightly.

---

## 7. Transmissibility as part of truth (Joseph's clause, institutionalized)

Joseph: "what's best for the truth" *encompasses* "clear enough for the truth to be more
easily comprehended and transmitted." ASF institutionalizes this in the **Feynman-
criterion Brief field** (the bathtub gloss). The report's analog already exists and my
chapters use it: the capability card's job is to name the *specific* theory quantity and
the *mechanism and direction* in words ("drives observation ambiguity A toward zero on
parse outcomes" beats "improves observation quality"). That IS the Feynman discipline at
claim grain.

**Proposal.** Make transmissibility a *check*, not a new field: on any load-bearing or
inherited claim, the reviewer asks "could a reader re-derive the qualitative claim from
the plain-word gloss alone, without the symbol?" — and where the answer is no, the claim
is not yet at criterion (ASF's exact test: "where we have not produced the analog
ourselves, the segment is not yet at Feynman criterion"). This bites hardest on the
`inherited` claims (§2), where the temptation is to gesture at ASF instead of carrying
the substance — and it's the same discipline as the report's standalone-ownership bar,
so it costs nothing new.

---

## 8. What I'd DECLINE from ASF, with reasons (the deltas Joseph's "any differences" asks for)

- **The LaTeX equation-level tags (`*[Derived]*`) and `## Formal Expression` cadence** —
  decline as-is. The report is demand-prose with almost no equations; the *kernel*
  (claim-grain status) survives via the capability card + inline register words + the
  optional "what each leg carries" table (§3). Importing the LaTeX tags would be costume
  rigor.
- **The three rings (inevitability-core / canonical-formulations / empirical-heuristic)** —
  decline as a structure. They stratify a *mathematical* theory by how forced each claim
  is; a *demand* report has no inevitability core (demands aren't mathematically forced —
  almost everything the report says lives in ASF's third ring). The **useful kernel
  survives as max-attainable-status** (§9). The report's closest honest analog to "which
  ring" is its existing "agreement across independent evidence kinds" discipline — keep
  that, don't dress it as rings.
- **Wholesale ASF segment-`type` vocabulary** (postulate/definition/scope/corollary/…) —
  decline. The report's own `type:` set (finding/demand/principle/counterposition/method/
  synthesis) fits its domain and is reader-legible. The valuable ASF refinement is at the
  *status/empirical-register* grain (§1), not the type grain. (One possible small
  adoption: `worked-example` as a type, since annotation's self-referential dogfooding
  paragraph and templates' de-novo testimony function as worked examples — but that's a
  minor call, flagged not pressed.)
- **`empirica:` registered-experiment references** — decline *now*, adopt-shaped-hole for
  *later*. The report has no run experiments yet (phase 3 spikes are future). But the
  contract ("an empirical claim citing an experiment with no matching recorded run is a
  truth-status defect") is exactly right for the report's `claim-or-kill` experiments
  (self-chunking's specified test; typing's "Norway suite" card). Reserve the `measured
  (self)` status to *require* an experiment pointer once phase 3 runs exist; until then,
  those claims are honestly `hypothesis`.

---

## 9. Max-attainable-status — cheap, honest, adopt

ASF's ceiling idea ("Max attainable: X. Currently Y because Z") prevents wasted promotion
effort and is honest about what a claim *can* become. My chapters need it concretely:

- templates' product-shape *specifics*: ceiling = `synthetic` / `testimonial` (they are
  design vision; no effort promotes them to `measured` without an implementation) — so
  don't spend effort trying to "prove" them; mark the ceiling and move on.
- context-economy's numeric thresholds: ceiling = `measured` (folklore now; a real
  measurement could firm them) — worth a spike, unlike the above.
- typing's "no silent retype": ceiling = `measured` via the Norway-suite card — a clear
  promotion path, so *not* leaving it at `synthetic` is the right investment.

Adopt the one-line ceiling note on any claim whose ceiling isn't obvious. It's the
mechanism that tells the next cycle's agent where pushing pays and where it's wasted.

---

## 10. Summary — adopt / adapt / decline

**Adopt:** the `inherited (asf #…)` cite-don't-rederive status (§2); the empirical-family
status split defined by repair (§1); claim-grain marking via the capability card + inline
words + optional leg-table (§3); Search-Log coverage tags incl. `intuition-only` (§4);
gate-checks-as-re-runnable-instruments + dated verification events with a regression-guard
line (§5); Related-Work relationship labels + novelty-claim postures (§6); the transmiss-
ibility check (§7); max-attainable-status (§9).

**Adapt:** ASF's derivation-audit table → the report's "what each leg carries" mini-table;
Feynman Brief → a claim-grain transmissibility check on the plain-word gloss; ASF's
segment-status frontmatter → pilot A's `register:`+`strength:`, with `strength:` drawing
from the refined ladder.

**Decline (with reason):** LaTeX equation tags + Formal-Expression cadence (no equations);
three rings (no inevitability core in a demand report — ceiling survives); wholesale ASF
`type:` vocab (the report's own fits); `empirica:` now (no runs yet — reserve the shape).

**Forks for Joseph (not averaged):**
1. Does the empirical-status subtype **screen off** the T1–T5 genre axis for empirical
   claims (§1 fork)? My chapters push toward yes-for-empirical-claims; pilot A landed the
   genre axis; this needs your call, not a sibling overriding a sibling.
2. `inherited` vs `inherited-exact` — I propose the un-suffixed `inherited` (the source's
   status may be conditional/robust-qualitative, and we shouldn't launder to exact), with
   the defeasible-transmission caveat carried by the verification-event, not the label.
   The coordinator leaned `inherited-exact`; genuine small fork.
3. How much claim-grain marking is worth the friction (§3) — I lived the need in typing
   specifically; whether it generalizes past the three mixed-strength chapters is a
   judgment about reader-value vs author-cost that wants your read.

*Written from the V/VI vantage; the seam between notation-demand (V) and memory/
continuity (VI) is exactly where "epistemology as notation" stops being abstract — the
annotation chapter's whole thesis is that agents want to carry register-metadata on
content, which is this proposal's machinery pointed back at UDON itself. That reflexivity
(the report's epistemology system is a live demand-datum for the format the report is
about) is the strongest reason to get this right, and it's a fork-free observation I'd
want surfaced whatever the calls above.*

---

## 11. Reframe under the TST-native default (Joseph, arrived mid-draft)

Joseph now expects the handover consumer to be **a new group/part inside ASF's 02-TST
(Temporal Software Theory)**, not a standalone transfer. That flips the default under
which everything above was written. §§0–10 asked "what earns its place from a neighbor";
the right question is now **"align with ASF's FORMAT unless a difference is warranted by
this material's nature — and price every delta as future reconciliation cost."** The
analysis in §§0–10 survives (the grounding in my four chapters is unchanged); what
changes is the default and how three items re-resolve. And the deliverable is reframed:
**this is not a local schema, it is a proposal to extend TST's evidence vocabulary** —
a more valuable and more accountable artifact, because a delta now has to justify itself
against a home it will actually live in.

**What is warranted-by-nature (the deltas worth their reconciliation cost):**

- **The empirical-register split (§1) is the flagship warranted delta.** This corpus
  carries evidence kinds TST's current status vocabulary does not distinguish — above
  all **first-person agent testimony** (the de-novo grok yield; the ELI accounts; the
  report's own dogfooding), which has no home in ASF's `empirical`/`observation` pair.
  Framed as a TST extension: **add `testimonial` and `synthetic` as first-class statuses,
  and sub-flag `measured` by self/external** — because a theory of *software and agents*
  will meet exactly these evidence kinds repeatedly, not just in this report. The
  anti-collapse justification (each routes to a different repair, §0) is the argument
  TST's maintainers would need, and it's already made. This is the piece I'd lead the
  whole deliverable with.
- **A `demand` type (and the report's `finding/principle/counterposition` types).** ASF's
  `type:` set is theory-shaped (postulate/definition/result/…); a *demand* report has no
  `demand` there. Under the align-default this is a real delta — but warranted: the
  corpus's primary claim-kind genuinely is "an agent needs X," which is neither a
  postulate nor an empirical result. So §8's "decline wholesale type vocab" re-resolves
  to **propose `demand` (and the handful of report-native types) as TST type-vocabulary
  extensions**, priced honestly as new entries TST would carry.

**What re-resolves toward alignment (deltas I was too quick to keep):**

- **`inherited` (§2) should mostly become ASF's existing cross-volume reference, not a
  new status.** If the report lives in TST, then a TST segment citing an AAT result is
  *intra-corpus* — precisely ASF's `volume:slug` cross-volume reference (AAT ↔ TST ↔
  LogA ↔ ELI), with `depends:` carrying the edge and the cited segment's own `status:`
  traveling by reference. Inventing a new `inherited` status is then a delta with real
  reconciliation cost and little warrant. **What survives as a genuinely warranted micro-
  delta is only the transmission-defeasibility caveat** (our restatement can err even
  when the AAT source is exact) — and that belongs on the *verification event* (§5:
  "restatement checked against #slug on DATE"), not as a status label. So §2 shrinks:
  use ASF cross-volume refs + `depends:`; keep the one-line plain-word gloss for the
  harness-side reader (still warranted — external readers can't follow the ref); drop the
  `inherited` status. Cheaper and more reconcilable. *(This also softens fork #2 — the
  `inherited` vs `inherited-exact` question largely dissolves once it's a cross-reference,
  not a status.)*
- **The genre-axis fork (§1's fork) re-resolves toward dissolution.** ASF/TST has **no
  T1–T5 genre axis** — its status ladder carries the epistemic work and provenance rides
  in `depends:` + citations + the Search Log. Under the align default, the T1–T5 codes
  are themselves a delta to justify, and I don't think they clear the bar: the empirical-
  status subtypes (§1) carry the repair-routing, and provenance is already carried the
  ASF way. So my instinct from §1 ("genre near-redundant for empirical claims") sharpens
  to a recommendation: **let the refined status ladder + ASF-style provenance replace the
  T1–T5 genre axis**, rather than run both. This is now a *reconciliation-cost* argument,
  not just a parsimony one — and it's still a fork for Joseph, but the TST-native framing
  tilts it. (I flag that this partially revises pilot A's landed genre axis; honest
  divergence, for the coordinator to synthesize.)

**What stays declined, now clearly warranted:** the three rings (a demand report has no
inevitability core — it joins TST's third/empirical ring by nature; near-zero
reconciliation cost to omit), and the LaTeX equation tags (no equations; ASF only
requires them where equations exist, so omission is not a delta at all).

**The substrate observation, now concrete (and my division is where it bites).** ASF
segments are authored in markdown today; if this corpus lands in TST *and* UDON matures,
the natural end state is **ASF/TST segments authored in UDON, carrying these very
registers natively as designated attributes** — which is exactly the
`annotation-and-metacognition` thesis (strippable, queryable register-metadata on
content) and the `typing-and-schema-boundary` thesis (syntactic typing, versioned
schemas) pointed at ASF's own format. The reflexivity I noted above stops being a nice
observation and becomes a **concrete future-substrate question**: the epistemology
system this deliverable proposes is, if UDON succeeds, a UDON schema — `status`,
`register`, `depends`, `verified`, `search-log` as native attributes on a segment
document. That makes getting the vocabulary right *doubly* load-bearing: it is both TST's
evidence discipline and an early, real schema for the format UDON is trying to become.
I'd surface this to Joseph as the reason the empirical-register extension is worth doing
carefully now rather than locally-and-later — it is plausibly the first real UDON schema
ASF would dogfood.
