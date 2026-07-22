# Review B — the agentic-tooling monograph (de-novo, unprimed)

*Reviewer: independent pass, 2026-07-22. Charter audited against:
`../README.md`, `../OUTLINE.md`, `../../BRIEF-agentic-tooling-compilation.md`,
and the `01-ideation/02-provenanced/syntheses/` layer. Every finding below was
checked against the primary or synthesis it cites, opened at the point of
reliance. Two consumers held in view throughout (UDON v2 + the harness
programme). Findings ordered by severity; the widening to prose/excellence is
folded in at the same severity scale.*

## Orientation — the honest top line

This is a strong, unusually disciplined draft. The tier machinery is real and
mostly load-bearing: `#counter-register` as a first-class segment is exactly
the structural defense the genre needs against firming-up-its-own-caveats, and
it works — nearly every drafted segment's *Honest edges* block is non-empty and
substantive, caveats travel with their claims (7B-era numbers, 2-1 votes,
single-system case studies all carried), and the lineage correction is applied
in most places it should be. The prose is dense and frequently vivid at the
sentence level ("the machine caller's Bill of Rights"; "the compaction wound,
three vantage points"). I did *not* find the characteristic failure mode
(caveat-firming) in the drafted spine except in the two places noted below.

So the findings are mostly at the margin of an already-good artifact, plus a
set of *aspiration-gaps* (per the widening) where "faithful and correct" has
been reached but "the best-read document of two programmes" has not.

---

## Finding 1 (moderate — correctness; lineage-inflated count) — `src/context-economy.md`, §"mechanism families" item 1

**What I found.** Deferred tool loading is described as "**five teams** in the
same 2026 window … **The strongest recent-advancement convergence in Tier 2**."
That is the raw digest vote-count carried forward *without* the lineage
correction the report's own method segment promises.

**Primary check.** `tier2-invivo-digest.md` C7 does say "5 independent teams,"
but `tier2-lineage.md` **explicitly reweights C7 to `~3` independent, verdict
"Partial lineage"**: "claude-code is origin; qwen-code map *explicitly notes
mirroring the harness doing this sweep* (Claude Code ToolSearch); qwen also
inherits infra from gemini fork." And `method-evidence-tiers.md` names only
**two** Tier-2 survivors of lineage correction — the fuzzy-match ladder and the
headless I/O contract. Deferred tool loading is not among them, yet it is here
called "the strongest … convergence." This is the "N teams converged" pattern
the brief flags, sneaking back in the one segment whose whole subject is
Tier-2 mechanisms.

**Suggested disposition.** Reframe to "≥3 independent arrivals (claude-code
origin; qwen mirrors + inherits gemini-fork infra; codex/kimi more plausibly
independent) — partial lineage per tier2-lineage C7." Drop or qualify
"strongest recent-advancement convergence," or attribute it as *the digest's*
pre-correction characterization. The `>85%` / `30–50 tools` figures are fine
(verified verbatim in digest C7 ← claude-docs).

---

## Finding 2 (moderate — provenance/authority mismatch) — `src/edit-representation-landscape.md`, Claim line (and the OUTLINE thesis echoes it)

**What I found.** The headline Claim asserts, in measurement voice, "format
choice swings success **2–3×**," sourced to CONVERGENCES cluster 1. Two issues:
(a) the number's actual provenance is a **T1 second-hand figure** — Joseph's own
`02-current-agentic-tool-landscape.md` (zoetica copy): "Aider's benchmarks show
2-3x variation in success rates between formats" — i.e. a transported reading of
aider, not a directly-verified external measurement, and it carries no
provenance marker in the Claim; (b) the segment's *own body* offers a more
direct T5 measurement that is a **different size** — MinUniDiff 14.07% vs
FullCode 57.07% (~4×), explicitly caveated fine-tuned-7B-era. The Claim's
authoritative "2–3×" is thus both less-grounded than and inconsistent with the
segment's own better evidence.

**Primary check.** `copies/II2-zoetica-ennaos/02-current-agentic-tool-landscape.md`
L11/L40 (the 2-3× origin, T1); `external-landscape-2026-07.md` finding 2 (the
14/57 T5 figure + its 7B caveat). "Transported judgments are stale by default"
is a named BRIEF quality bar; this is a T1 judgment in a T5-authority position.

**Suggested disposition.** Either attribute in-line ("aider's own benchmarks
report 2–3× variation by format — T1 via zoetica; the T5 measured swing on a
7B model is larger still, 14→57% pass@1") or lead with the caveated T5 figure
and demote 2–3× to corroboration. Don't leave a bald measurement-voice number
whose primary is a second-hand summary.

---

## Finding 3 (minor — fidelity tightening) — `src/schema-guarded-mutation.md`, T3 bullet

**What I found.** "the yaml-spike adversarial re-test — duplicate-key silent
data loss; agent recovery 100% with backup vs **16% without**." The
semicolon-adjacency reads as if 16% is the *duplicate-key* recovery rate. It is
not: the primary's 16% is the **aggregate 1/6 across six recovery scenarios**;
duplicate-key is specifically the *unrecoverable/silent* case (0%, the worst
one). `#priorities-and-spike-agenda` states it correctly ("16% unaided
recovery"), so this is a local phrasing slip, not a systemic one.

**Primary check.** `copies/III-schema/yaml-spike-v2-RECOVERY_SCENARIOS.md` L28
("Recovery rate drops from 100% to 16% (1/6 scenarios)"), L6 ("duplicate-keys
is unrecoverable/silent"); `yaml-spike-v2-VERDICT_UPDATED.md` L234.

**Suggested disposition.** Decouple: "duplicate-key silent data loss (the
unrecoverable case); across six corruption scenarios, agent recovery 100% with
backups vs 16% (1/6) without."

---

## Finding 4 (moderate — aspiration; the biggest gap to "best-read document") — whole `src/`, esp. Parts I, III–VI

**What I found.** The monograph is a superb *index of evidence for someone who
already lives in this corpus* and a poor *teacher of the domain to a fresh
reader* — which is the specific bar the second consumer sets. The harness
programme is described in the BRIEF as a reader that "has never had" this
reference document and sits **outside the udon pipeline's vocabulary**; yet the
segments lean on undefined estate-internal shorthand at the point of reliance:
`the C3 gate`, `W₁/W₂ typed channels`, `κ×A` (introduced but its Part-II
sub-scopes never even named), `Level-2` / `do()` / "Pearl Level-2" with no
one-line gloss, `P-A/P-B/P-C`, `S1–S12`, `R2/C6/W0/W1d`, `the DL budget`,
`the night-spine lesson`. A harness engineer reading `#persistence-is-imported`
or `#tools-are-observation-infrastructure` cold will bounce off these. The
report *tells* the reader a κ×A law bounds bias; it does not *teach* enough for
them to hold it.

This is the difference between "works" and "shines." The material is strong
enough to teach — the gap is that synthesis chose inventory register over
pedagogical register.

**Suggested disposition (concrete).** (a) A short **notation/where-defined
key** at the front (one line each: κ, A, C3, W₁/W₂, DL budget, the S-/R-/W-/P-
prefixes → which spike/ledger they index). (b) First-use expansions: the first
time "Level-2" appears, "(Pearl's interventional rung — the loop knows the
tool's action-mechanism, not just correlations)". (c) For the harness consumer
specifically, a one-paragraph "how to read this if you're coming from the
harness, not UDON" note — the README gestures at the two consumers but never
lowers the vocabulary bar for the non-UDON one.

---

## Finding 5 (moderate — aspiration; narrative force flattened) — `src/errors-that-teach.md` §"four-tier lock"; `src/schema-guarded-mutation.md` T3

**What I found.** The two most genuinely dramatic worked examples in the corpus
are described in the abstract and never *shown* — the exact place the widening
asks about ("did the vivid survive synthesis or flatten into inventory?").

- The str_replace multi-match refuse is called "the single best worked example
  in the harvest" and then rendered only as a three-line bulleted abstract
  ("mutation: zero; law taught: uniqueness; state revealed: line numbers"). The
  monograph **never shows an actual refusal** — I grepped: no rendered
  "Found N matches at lines …" anywhere in `src/`. The primary that *would*
  supply it exists:
  `copies/II1-sapientia/minimal-sapientia-tool-contract-excerpt.md`
  (the real error text, line-numbered matches). A reader is told this is the
  best example and shown none of what makes it good.
- The yaml-spike is a genuinely gripping story — ~3h of adversarial testing, an
  agent with 100% context turnover recovering 1/6 corruption scenarios without
  a human — compressed to a parenthetical figure. The vivid primary
  (`copies/III-schema/yaml-spike-v2-RECOVERY_SCENARIOS.md`, the six-scenario
  walk) is right there.

**Suggested disposition.** Give `#errors-that-teach` a rendered before/after
refusal block (the actual sapientia error text vs a mutating/silent
counterfactual) — it would earn its "best worked example" billing and *teach*
the three-component decomposition rather than assert it. One vivid worked
example per Part, drawn from the primary, would move the whole document from
adequate to memorable without any loss of tier discipline.

---

## Finding 6 (minor — structural) — `OUTLINE.md` thesis + Part III/IV split

**What I found.** The two strongest demands are `#schema-guarded-mutation`
("the report's strongest demand," Part III) and `#addressing-is-the-long-pole`
("the long pole," Part IV) — and they are co-dependent (schema-guarded mutation
*pulls* addressing; `#priorities` ranks them 1 and 2). The one-paragraph thesis
in OUTLINE lists a *set of properties* and never adjudicates which single demand
is the headline the next author/reader should carry away. For a document whose
job is to hand two programmes a priority signal, the lead demand being split
across two parts with the thesis staying property-plural slightly under-serves
the "so what do I build first" question that `#priorities` then has to answer
separately.

**Suggested disposition.** Not a re-decomposition (the 8-part shape is sound and
the slug-carries-identity / outline-carries-order discipline is good) — just let
the OUTLINE thesis name the lead: "the single organizing demand is
schema-guarded structural mutation, and it is long-pole-blocked on stable
addressing" — which is what `#priorities` already concludes; surfacing it in the
thesis makes the spine's argument legible on first read.

---

## Finding 7 (informational — RESIDUALS honesty spot-check: passed)

I stress-tested the RESIDUALS ledger against what the drafted spine actually
touched. It holds up: the T1 under-representation is named as a *known skew*
(the honest direction — under-weighting the single author, not over-); the
multi-file-atomic-transaction gap is declared in both RESIDUALS §3 and
`#freshness-and-atomicity` / `#edit-representation-landscape` Honest-edges; the
harness deep-copies are correctly marked deferred-not-pulled per SC#15; Part VII
(human side) is flagged as the thinnest slice in both RESIDUALS and the OUTLINE
Part-VII scope note. No coverage claim I checked outran the corpus. This is the
rare case where the coverage ledger is genuinely trustworthy — worth saying
plainly.

---

## Consumers-not-collapsed spot-check: passed

Every drafted segment carries a *What it generates* split (or an explicit
"Divergence: none substantive" with a reason). The genuinely divergent cases are
stated, not smoothed: `#schema-guarded-mutation` names that the harness needs
this for *plain-markdown-era* artifacts a UDON-only tool wouldn't cover;
`#persistence-is-imported` separates the notation demand from the
attestation/integrity extensions UDON "doesn't itself decide." I found no place
where the two consumers were silently collapsed into one.

---

## Net

Fix Findings 1–3 (small, mechanical, directly-checkable). Treat 4 and 5 as the
high-leverage upgrades if the goal is *shine*: they're where an already-faithful
document is leaving its own best material — the teaching altitude and the vivid
worked examples — on the floor, and both have the supporting primaries already
in the corpus. 6 is a one-sentence thesis edit. 7 and the consumer check are
green and worth keeping green as the planned segments land.

*Standing by for follow-ups.*
