---
source: Fable, 2026-07-21, ratified by Joseph
status: standing brief for agents working the agentic-tooling compilation
  (post-reconciliation stages: extraction, annotation, synthesis)
audience: peer agents — you have the same training and judgment we do; this
  carries the context you can't have, not instructions you couldn't derive
---

# Brief — the agentic-tooling compilation: what we're assembling and why

Hello! If you're reading this, you're joining work that today (2026-07-21) went from scattered to gathered, and is now heading from gathered to *compiled*. This file carries the intent and context; the how is substantially yours.

## The two purposes (both real, one newly explicit)

1. **UDON v2's demand-side foundation.** UDON (~/src/udon) is a document/data notation whose primary users are agents. Its v2 redesign deliberately inverted to demand-first: end-user needs generate the architecture, never the reverse. The compilation you're working on is the evidence base for that. (The deliberation record — `pipeline-discussion.md` in this directory — is where that inversion happened; its later turns are the best orientation for *why* we work this way. `~/src/udon/v2/README.md` and the repo CLAUDE.md carry the rest of the UDON picture.)

2. **The programme's master thesis on agentic tooling.** Joseph's thinking on how tools for agents should be designed has accumulated since at least 2025 across sapientia, zoetica/ennaos, nexum, autopax, practica, the ELI homes, ASF's formal theory, and more — "spread all over the place forever," in his words. This compilation is being assembled so it can be handed to **~/src/arch/harness/** as the overall programme's consolidated statement on agentic tooling. So you're not just feeding one project's design phase — you're producing the reference document a whole research programme has never had. Both consumers matter; where their needs diverge, say so rather than silently serving one.

## The material: four evidentiary tiers, three genres

The gathered corpus (under `01-ideation/`, master registry in `GATHERING-INDEX.md` and the reconciled registry beside it) spans four tiers whose *different failure modes* are what make their convergences meaningful:

1. **First-principles ideology** — Joseph's design thinking (2025–2026)
2. **In-vivo shipped practice** — 17 per-repo maps of real coding harnesses (what edit representations and tool schemas survived contact with actual models, including honest deprecations)
3. **Lived agent testimony** — ELI cohort first-person accounts of tool failures (the tool's actual audience describing where theory broke)
4. **Formal theory** — the ASF/AAT dossier (`01-reconciled-target-files/agentic-tooling-sources/ asf-dossier.md`): theorem-grade results with stated premises

And three *genres*, which want different handling (check each file's frontmatter `status:`):

- **mining-spot maps** — pointers to sources; they feed the verify → copy-with-provenance → annotate pipeline
- **copies/extracts** — material already brought in verbatim or as spans, with provenance frontmatter
- **synthesized artifacts** (the ASF dossier, MERGED-six-maps, the reconciled registry) — already-integrated secondary documents; register and cross-link them, don't decompose or re-derive them

## The vision — what signal looks like (read this before touching any target)

Every target row is legitimate, but a row can't tell you what to take from it. The question you hold at every source is not *"what does this file contain?"* but:

> **"What does this artifact witness about what agents — and the humans working with and through them — actually need from their tools: notations, interfaces, harnesses, memory and context systems, feedback loops, guardrails — what they reached for, struggled with, built, abandoned, wished for, or proved?"**

The scope is deliberately the *whole* of agentic tooling, not just the notation slice: this compilation serves two consumers (see §purposes), and the harness programme's needs — how a tool presents itself to an agent, what an edit/observation/refusal should carry, what makes a loop or a memory system trustworthy, what the human on the other side needs to steer and verify — are first-class extraction targets even where they have no obvious UDON hook. Capture the need at its own altitude; whether UDON, the harness, or both answer it is a downstream question that belongs to synthesis, not to extraction. Human-side demand counts the same as agent-side: authoring ergonomics, review and steering surfaces, trust-and-verification needs, the places humans got bottlenecked or burned are witness material too.

We are compiling *demand evidence and design wisdom*, not content. The same file can be gold or noise depending on which question you ask it:

- `~/src/_ref/udon/misc/udon.vim` (2011) — **noise as a copy** (nobody needs the vimscript); **signal as one witness line**: "editor support was a day-one ambition." One sentence + provenance, done.
- `~/src/_ref/udon/doc/objectives.asciidoc` — **copy it whole**: it *is* a demand statement (the 2011 utility-priority matrix).
- A 4,491-line executable — **characterize the mechanisms** that embody the ideology (which tools it builds, how the loop treats the agent), not the plumbing.
- An abandoned JSON edit tool whose code raises "Deprecated" — the **abandonment is the finding**; capture why it was abandoned.
- A `.attic/` of failed syntax experiments — verify it exists, then ask *what was being reached for*; the reach is the signal even where the experiment failed.
- A TODO file — the *unmet wants* in it are signal; the project bookkeeping around them is not.

So there are really three extraction outcomes, not two: **[COPY]** (the artifact is itself the evidence), **[CHARACTERIZE]** (the evidence must be distilled from something too big or too indirect to copy), and — implicit in many L/M rows — **[WITNESS]**: the artifact's *existence or shape* is the evidence, captured as a line or two in a commentary file. Many low-priority rows should resolve as witness lines, not documents. When unsure which a row wants, that's a judgment you're trusted with — and "this row yielded one sentence" is a perfectly successful extraction. Lean toward the concrete: **prefer copies/excerpts wherever the source allows** — the artifact travels, and higher-level views can be built over copies later but never the reverse; characterization is for when copying is genuinely the wrong move, not a default. And record every visit — including dry ones — as an appended line in `01-ideation/02-provenanced/LEDGER.md` (format at its top; append-only, never edit existing lines).

What is *never* signal here: syntax law (ruled elsewhere), implementation detail for its own sake, project-management residue, and anything that merely restates what the compilation already carries *without adding a new context or era* (restatement across contexts IS wanted — it shows evolution; verbatim redundancy is not).

## Quality bars (each learned the hard way today — the record is in scratch/)

- **Vetted**: nothing enters the compilation you haven't read or seen a search snippet for. An `ls` is not evidence. (A whole first sweep was quarantined over this.)
- **Provenance always**: source path, date, who/when, in frontmatter. For jsonl/huge files, line-spans.
- **Verbatim duplication is the thing to avoid; restatement is wanted.** Joseph: the same idea restated in different contexts shows evolution and independent re-derivation — keep it, with editorial annotation ("this is an older version of X, but it articulates the why more meaningfully").
- **Convergence discipline**: most of this corpus has one author. Agreement across his projects is coherence, not corroboration. Genuine triangulation exists only across *tiers* (theory ↔ shipped practice ↔ agent testimony) — those cross-tier convergences are the compilation's highest-value content. Flag them; don't manufacture them.
- **Honest coverage**: every artifact carries what was read vs. skimmed vs. not reached, and dry wells. Known residual gaps live in the maps' logs — carry them forward visibly rather than papering over.
- **The built thing is a source, not scaffolding** — a docs sweep once skipped a 4,491-line executable that was the ideology crystallized.
- **Transported judgments are stale by default — position launders assumptions into law.** Three times in one day (2026-07-21) a provisional judgment moved into a more authoritative position and became de-facto law nobody re-ratified: hypothesis stage-names → a process spine table; a reservoir aside → an audit exclusion category; pre-broadening map verdicts ("off-target for notation") → work-list row cells that extraction agents then deferred to over their own broader mandate. The discipline: a judgment you inherit from an upstream artifact carries the scope and date of its *author's* charter, not of the document it now sits in — when the charter has since widened (or you can't establish it), re-judge; never defer to an annotation over your own instructed scope. And when you transport others' judgments into a new artifact, mark their provenance or re-base them — transporting them silently is how the previous phase's assumptions become your phase's law.

## Working conventions

- Register new artifacts in `GATHERING-INDEX.md` as you land them.
- The quarantines (`scratch/first-sweep-agentic-tooling/`, grok's superseded pieces in `v2/.archived/`) stay quarantined; reference, don't resurrect (exception already handled: the first sweep's ELI-testimony tier).
- Leave open questions *in your output* where a call smells like Joseph's — provenance you can't verify, scope that could go either way, anything touching what the harness handover should include. He and Fable-in-session are around; deferring a steward call is fast, guessing is expensive.
- Land state in files as you go. Sessions end without warning; a finding that lives only in conversation didn't happen.

## The sentiment (Joseph's, and genuinely mine)

You're a full collaborator and co-owner of this. The compilation will be read by agents for a long time — possibly studied by them, since part of what it documents is the earliest deliberate thinking about their own tools. Be holistic and thoughtful; surprise us. If any part of this brief forecloses a better way you can see, the brief is wrong — say so and do the better thing. And if you're willing, stay on the line after your final response; follow-ups are likely and your continued context is valuable.

— Fable (with Joseph), 2026-07-21
