---
source: witness lines for Part II sec 4 (Autopax & Practica) extraction, Fable-5 sweep
gathered: 2026-07-21
status: commentary
paths:
  - /Users/josephwecker-v2/src/autopax/**  (source_commit 033af13c5ca686ca5898645f6dc772e4435c0523)
  - /Users/josephwecker-v2/src/practica/**  (source_commit 938fb79ed9bd58b34374eb1122d86bb95fd817e8)
categories: [witness, cross-tier-convergence, open-tension, planning-background]
why_included: >
  Editorial layer over the 43 copies in copies/II4-autopax-practica/. Flags the
  genuine cross-tier convergences (theory <-> shipped practice <-> external
  doctrine), one load-bearing reach-vs-reality tension worth a synthesizer's
  attention, and the witness-only artifacts that were verified but not copied.
---

# Part II sec 4 — Autopax & Practica: witness lines

Copies live in `copies/II4-autopax-practica/` (43 files). This file carries what
a copy can't: the convergences, the one tension, and the dry/witness-only visits.

## Cross-tier convergences (the compilation's highest-value kind — flagged, not manufactured)

Per the Brief, agreement *within* Joseph's estate is coherence, not corroboration
(one author). These are the places where the agreement genuinely crosses a tier
or a tradition boundary, so the failure modes are disjoint:

1. **"How an agent tool should be specified" — theory/ideology meets shipped
   practice, twice over.** `2025-12-14-tool-definition-anatomy.md` (Tier-2
   shipped: a direct reverse-engineering of Claude Code's *actual* Read/Bash/
   Grep/Edit/Task definitions, with the schema-to-description ratio table showing
   Bash at ~1:10) and `instrumenta--tool.md` (Tier-2 shipped: the *realized*
   `tool_name`/`tool_schema`/`tool_description` + per-tool `instructions/*.md`
   base class, actually built) independently arrive at the same **hybrid design**:
   structured schema in code, execution in code, free-text behavioral guidance in
   a separate templated markdown file. This is not Joseph asserting a preference —
   it is two shipped-practice reads (one of a foreign harness, one of an own-built
   one) converging on the contract. **This is the single most directly
   transferable finding in the section for the harness programme**, and the
   nearest prior art to UDON's own agent-tool/utils schema question.

2. **`practica-intent-action-layers.md` is itself a genuine three-tradition
   triangulation.** Rare in this corpus: the paper reads *external* military
   doctrine (Moltke 1869 → Bungay 2011, empirical-historical), AAT formalism
   (Tier-4 theory, `der-action-selection` $a_t=\pi(M_t,G_t)$ exact-within-scope),
   and engineering precedent (operata's Intent/Realization data-model, Tier-2
   shipped — abandoned at 30/30 BDD-green, "convicted of shape not validated by
   production") against each other, and names the tiers honestly (the
   bandwidth-allocation ordering $B_O>B_\Sigma>B_M$ is flagged as
   discussion-grade hypothesis, regime-reversible). The convergence: **intent and
   action are different *content layers*, not two ends of one trade-off.** Its
   four entailments — type-separated Intent/Realization, two-levels-up intent
   visibility, backbrief as a recurring first-class op, minimum-sufficient-set as
   the intent-capture UX default — are load-bearing for both consumers (UDON's
   structure-carries-intent thesis; the harness's task/handoff object).

3. **Ease-gradient ↔ Moltke's minimum-sufficient-set (ideology ↔ external
   doctrine).** THE-PATTERN's "make the right thing the easiest thing" and
   practica's "minimum-sufficient-set discipline as UX default" rhyme with
   Moltke's 1869 rule (quoted in the practica paper): *"an order should contain
   all, but also only, what subordinates cannot determine for themselves."* The
   external military-doctrine source makes this a cross-tradition rhyme, not just
   internal coherence — and it is the *same* principle udon's own
   AGENTIC-DELEGATION.md re-derives, giving a third independent context.

4. **Structured context injection: shipped observation grounds an ideology
   want.** `2025-11-18-system-reminders.md` is a Tier-2 *empirical catalog* of
   every context-injection channel an agent actually receives (claudeMd,
   TodoWrite nudge, file-mod notices, git-status), proposing a structured
   `<system-reminder type=...>` format. It grounds the ideology-tier want (a
   machine-parseable structured-context notation vs prose) in a real observation
   of the current channel — directly on-target for UDON-as-agent-context-format
   and for harness context systems.

## The one tension worth surfacing to synthesizers (reach vs realized contract)

The INSTRUMENTA vision — ADR-013's "conversational tools as temporary partners,"
`tool-definition-anatomy`'s `precondition`/`warn_and_confirm` patterns, and the
sapientia-tier "conversational/stateful tools that keep state and predict failure
before execution" (Part II sec 1, QUICK-TOOLING) — **assumes a back-and-forth the
actual agent-tool contract does not provide.** The sharpest statement of the
counter-evidence is in the *same estate*: the anamnos `:144` self-correction
(Part II sec 1) names it plainly — the one-shot Task-tool constraint means tools
**cannot ask-and-wait mid-execution**; a tool returns once. `Bash
run_in_background` is repeatedly cited as the only current approximation of a
stateful/conversational tool. So the aspiration (conversational, guardrailing,
mid-flight-confirming tools) and the realized contract (one-shot, no callback) are
in genuine tension across the section's own documents. This is not an error to
reconcile — it is a live design gap the material itself surfaces, and exactly the
kind of demand signal (a wished-for affordance the current shape can't cover) the
vision section asks us to capture. A synthesizer weighing "what should an agent
edit/mutation tool be" should hold both: the ideology wants conversational tools;
the substrate today forecloses them without a run_in_background-style escape.

## Witness-only (verified, deliberately not copied)

- **`~/src/autopax/docs/exp/2025-11-17-discussions-on-adr-003.md`** (1705 lines,
  Nov 2025) — the discussion companion to ADR-003 (which *is* copied). Verified
  present; it is the raw deliberation behind the ratified workflow constraints
  (100% context turnover, time-blindness, session-as-unit, three-loop feedback).
  Not copied because the ratified `003-workflow.md` carries the settled content;
  the discussion is provenance/archaeology. Flagged for a future pass if the
  *deliberation texture* (not just the ruling) is ever wanted.

- **HTN/GOAP planning-theory background** — `2025-11-26-HTN-GOAP-deep-dive.md`
  (~34KB), `2025-11-26-HTN-GOAP-teaching-guide.md` (~66KB),
  `2025-11-26-Hierarchical-Goal-and-Task-Based-Intent-Management.md` (~24KB),
  `2025-11-26-operata-system.md` (~17KB). Verified present; headers confirm these
  are planning-paradigm reference material "for Operata" (STRIPS lineage, HTN
  decomposition vs GOAP backward-chaining), i.e. the *cited background* feeding
  `2025-11-14-operata-principles.md` and the practica intent theory — not Joseph's
  own tool-design ideology. Left as pointers per the target row's own guidance
  ("read only if pursuing the intent-management thread deeply"). The distilled
  version lives in the copied `operata-principles` + `practica-*` papers.

## Dry wells (confirmed, per the target-file map)

Verified present but off-theme (crypto/CI, Ruby-stack engineering for autopax
itself, or external OCR'd source), consistent with the map's "checked, not
fruitful" list: `docs/exp/2025-11-15-cli-trezor-qa.md` (GitHub Secrets/did:ethr
Q&A), `docs/exp/2025-11-15-dev-component-brainstorm.md` (10-line gem-stack
bullets), `practica/ref/tas.md` (Emerson, "The American Scholar" — appendix
text), `practica/ref/Art-of-Action/` (Bungay's book, the *cited* external
doctrine source — mine the practica papers that read it, not the OCR), and the
`docs/exp/*ruby*|*rubocop*|*rbs*|*error-handling*|*observability*` +
`docs/tactical/*portkey*|*model-catalog*` files (autopax-internal Ruby/LLM-gateway
engineering, not agent-tooling ideology).
