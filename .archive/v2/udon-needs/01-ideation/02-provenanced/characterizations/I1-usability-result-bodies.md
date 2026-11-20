---
source: UDON repo — test/usability/results/udon-realistic-*.yaml (24 files) + udon-context_comparison-*.yaml (21 files); the RESULT BODIES (the `response:` field = the actual UDON each agent produced) plus per-run judge feedback
gathered: 2026-07-21
status: characterization — distilled from all 45 result bodies (every `response:` + every `feedback:` field read via structured extraction; verbatim load-bearing fragments embedded below). The bodies are agent OUTPUT too numerous to copy whole; the load-bearing ones are excerpted verbatim so the evidence travels. The repeated cheatsheet/minimal/comprehensive reference-context prompt blocks were sampled (one of each level read in full — they recur unchanged across runs), not re-read per file.
paths:
  - test/usability/results/udon-realistic-*.yaml (24 files; `response` + `feedback` fields)
  - test/usability/results/udon-context_comparison-*.yaml (21 files; `response` field; `feedback` empty by design — these were run to compare output across context levels, not judge-scored)
source_commit: 3d8e5b9c52b2a581c4ab9021984423073a694693
source_authored_commit: 3fb7736f55d9874e45d6345042c39270b497d642
categories: [agent-output-corpus, minimum-viable-context, notation-footguns, inline-element-boundary, markdown-leakage, quoting-drift, correct-udon-priors, judge-scoring, grammar-constrained-generation, dynamics-tier-demand, intra-document-references, schema-cardinality-sigils]
why_included: >
  The deeper pass over the realistic + context_comparison result bodies that a
  prior extraction pass had marked `dry` as "output-quality, not demand-catalog"
  (LEDGER 2026-07-21) — a call Joseph OVERRULED (STEWARD-CALLS #7): "that judgment
  is overruled; go look with fresh eyes and the Brief's witness question." Read
  through the witness question — *what do these artifacts witness about what agents
  need from the notation and its tooling* — the bodies are dense signal, not noise.
  Three things they witness: (1) the empirical answer to the context_comparison
  study's own question — how much in-context reference a model needs to author
  idiomatic UDON, and the finding that it is NOT monotone (genre-conditional; for
  one genre minimal is the sweet spot, for another comprehensive is required);
  (2) the notation's real authoring footguns, observed cross-run / cross-genre /
  cross-context (unbalanced `|{...}}` inline closers above all) — a demand spec for
  the error surface and for grammar-constrained generation; (3) the "correct UDON"
  judge prior made empirical — what scored high vs low, and an LLM-judge structured-
  output failure mode (parse-error scores) that is itself agent-tooling evidence.
  First-class for BOTH consumers: UDON (the footgun catalog) and the harness (how
  much context an authoring loop needs, structured-output fragility). Companion to
  the whole-file `copies/I1-usability/AGENT_FEEDBACK-full.md` (its Judge/Validated
  score tail is the machine-scored half; this file reads the output that was scored).
---

# What agents actually produced — the realistic + context_comparison result bodies

> **Provenance / overrule note.** This is the extraction that STEWARD-CALLS #7 restored. The bodies are the agents' own UDON output under the authoring-task briefs (task definitions are in `copies/I1-usability/authoring-task-defs.md`). `realistic` runs were LLM-judge-scored (rubric in the task-defs file); `context_comparison` runs carry no score — the harness ran each of six task shapes at three reference-context depths (cheatsheet ≈52 lines / minimal ≈122 / comprehensive ≈452) purely to compare, so *the comparison across depths is the finding*. All runs are `claude-haiku-4-5-20251001` (Dec 2025), old spec.

## 1. Minimum viable context — the study's own question, answered from the bodies

The context_comparison track exists to find "the MINIMUM VIABLE CONTEXT an agent needs to produce good UDON" (task-defs `why_included`). The bodies answer it, and the answer is **genre-conditional, not a single threshold** — more reference is not uniformly better.

**Schema — the sharpest gradient (cheatsheet is not enough; comprehensive teaches the idiom).**  
The same "blog-post schema" brief produced three qualitatively different shapes:

- `schema @ cheatsheet` (214158) fell back to the rubric's *named anti-pattern* — element-per-field with quoted content, no attributes, no cardinality:
  ```udon
  |post
    |title "Blog Post Title"
    |subtitle "Optional subtitle goes here"
    |author
      |name "Author Name"
  ```
- `schema @ minimal` (214159) recovered attribute shape (`:title` … `:tags [..]`) but still modeled a *document instance*, not a schema.
- `schema @ comprehensive` (214202) produced idiomatic schema-notation with required/optional/repeated **cardinality sigils** and typed fields:
  ```udon
  |schema[blog-post]
    |field[id]!                :type integer :auto-increment
    |field[title]!             :type string :max-length 200
    |field[subtitle]?          :type string :max-length 300
    |field[tags]*              :type string
  ```
  This is the shape the design-of-record schema layer independently specifies (`!`/`?`/`*` cardinality) — the comprehensive reference *taught* it, so read this as "the full reference was followable," **not** independent re-derivation (same-author + in-context teaching; convergence discipline applies).

**Config — more context → richer structure.** cheatsheet/minimal produced flat attribute lists; comprehensive (214113, 214101) promoted `|cors` and `|ssl-config` to child elements with their own attributes — a genuine structure upgrade, not over-engineering.

**Prose-markup genres — more context made output WORSE (the non-monotone case).**  
For `experiment_report` and `structure_prose` the judge scored the comprehensive- context runs *below* the minimal ones:

| genre | cheatsheet | minimal | comprehensive |
|---|---|---|---|
| experiment_report | 2/3/2/3 | **4/4/4/5** | 2/2/2/3 |
| yaml_config | 4/2/5/3 | **5/5/5/5** | 5/5/5/5 |
| yaml_frontmatter (scored batch) | 4/2/3/2 | **4/5/5/5** | 4/3/4/4 |

(syntax/structure/flow/completion). The comprehensive reference invited *elaborate domain markup* the judge penalized (see §2 over-markup). **Takeaway for the harness consumer: minimum-viable-context is a per-task-shape property; a 122-line reference was the sweet spot for structured/config/prose genres, while schema alone needed the full 452-line reference to reach the idiom.** A one-size context budget is wrong.

## 2. The recurring authoring footguns — a demand spec for the error surface

These reproduce across independent runs, genres, and context levels. This is the notation's real friction, witnessed in production rather than speculated.

**(a) Unbalanced inline-element closers `|{ … }}` — the single most-reproduced error.**  
Agents systematically emit an extra `}` closing `|{…}` inline elements. Verbatim, across at least five independent runs and three genres:

- structure_prose @ minimal (214612): `However, |{em 3}} participants`
- experiment_report @ cheatsheet (214906): `(|{data :statistic p :value <0.001}}).` and `|{data :value 3}} participants` and `|{em jitteriness}}`
- experiment_report @ comprehensive (214919): `for placebo.|{measurement … }}` , `(|{p-value :value "<0.001"}}).`, `|{n 3}}`, `|{adverse :type jitteriness}}`
- structure_prose @ comprehensive (214620): `expected closing` parse-fail territory
- inline_heavy @ comprehensive (214156): `:unit "mol/(m²·s)"}}`

This directly corroborates the invention-track testimony in `AGENT_FEEDBACK-full.md` ("without [a marker] you can't tell if `@em important` means element-with-attribute or element-containing-text"; "some marker felt necessary, but it adds visual noise"). The `|{…}` boundary is where agents lose track of nesting depth. **First- class signal for grammar-constrained generation and for a forgiving/at-least- diagnostic parser** (which the invention agents explicitly asked for: "What's the error handling story? Indentation is fragile; how do parsers report problems helpfully?").

**(b) Markdown code-fence wrapper leakage.** *Every* context_comparison response is wrapped in ```` ```udon … ``` ```` fences despite the prompt's "Output UDON only. No explanation." The model's chat-formatting prior overrides the instruction. A harness that ingests agent-authored UDON must strip/expect fences — or the notation's own raw-fence affordance must absorb them.

**(c) Markdown-syntax leakage *inside* UDON, specifically under comprehensive context.**  
The 452-line reference runs reverted to embedding markdown:
- markdown_to_udon @ comprehensive (214529): `# API Documentation`, `## Authentication`, and an *escaped* markdown table `'| Tier | Requests/min |` inside the UDON body.
- yaml_frontmatter @ comprehensive (214723) and mixed_doc @ comprehensive (214131): `## Getting Started` / `## Introduction` headings instead of `|h2`. The richer reference apparently showed markdown-interop affordances and the agent leaned on them. Interaction effect worth the harness knowing: teaching more can teach the *escape hatch* louder than the core.

**(d) Quoted-vs-unquoted scalar drift by context depth.** cheatsheet/minimal quote scalars (`:version "2.1.0"`, `:last_updated "2025-01-15"`); comprehensive drops the quotes (`:version 2.1.0`, `:last-updated 2025-01-15`) and switches snake_case→ kebab-case keys. The reference depth silently moves the model's quoting/casing prior — a reproducibility hazard for any pipeline that expects stable typing.

**(e) The `|title "value"` element-as-attribute anti-pattern** (the rubric's named anti-pattern). Appears at low context: schema @ cheatsheet (above), and yaml_frontmatter @ cheatsheet (214848) wrapped metadata in a `|metadata` + `|author` element tree — judge scored `structure:2`. Confirms the anti-pattern is a real low-context attractor, not a strawman.

## 3. The "correct UDON" judge prior, made empirical (the AGENT_FEEDBACK score tail)

The scored realistic runs reveal what the team's judge rubric actually rewards:

- **Scored 5/5/5/5:** `yaml_config @ minimal` (214928), all three `conversation_log` (214942/946/953), `recipe @ minimal` (215007), `yaml_frontmatter @ minimal` (214854). The common shape: **flat attributes for metadata, one child-element per sequence item, prose left as prose.** Idiomatic, un-elaborate.
- **Scored low (2s):** over-markup (`experiment_report` with dense `|{measurement …}}` inline typing), over-nesting (`|metadata` wrappers), and quoted-everything.

So the judge prior is: *attributes over child-elements for metadata; restraint over density; don't wrap what a flat attribute expresses.* That is a concrete, if opinionated, statement of "correct UDON" — useful to phase-2 as a **contestable** prior (the same density the judge penalized is exactly the typed-inline-data the `|{measurement :value N :unit X}` reach shows agents *want* — see §4; the tension between judge-restraint and author-expressiveness is a real design question, not a settled one).

**The LLM-judge structured-output failure (inference, flagged).** 9 of the 24 realistic runs — the first chronological batch (214520–214723) — returned no score but `{"error":"unexpected end of input, expected closing \" at line 5 column N}`, consistently on **line 5** with varying column. The score object is `{"syntax":N,"structure":N,"flow":N,"completion":N,"notes":"…"}`; line 5 is the `notes` line. The most consistent reading is that **the LLM judge emitted invalid JSON — an unescaped `"` inside its free-text `notes`** — i.e. structured-output fragility, not a fault in the agent's UDON; the later re-run batch scored cleanly. I could not fully verify this (the judge's raw output isn't retained in the yaml), so it is an inference, not a confirmed cause. Either way it is agent-tooling evidence: **a scoring loop that asks an LLM for JSON lost ~38% of its runs to malformed output before a re-run** — the exact case for constrained decoding / grammar-constrained generation, which is one of UDON's own pitches (`design/GRAMMAR-CONSTRAINED- GENERATION.md`) and which the invention-track agents reached for by name.

## 4. Positive demand — what agents reached for, and it worked

Not all signal is friction. Where the output succeeded, it witnesses genuine wants:

- **Dynamics tier matches a real authoring need.** All three email-`template` runs (214207/211/218) produced fluent `!if`/`!else`, `!for … in …`, and filter-piped interpolation — `!{user.name | capitalize}`, `!{order.total | currency}`, `!{order.date | format "%B %d, %Y"}`. The templating tier was used correctly with minimal prompting; comprehensive even added an inline `|style` CSS block for HTML fidelity. Strong signal the `!`-dynamics design lands.
- **Intra-document references.** nested @ comprehensive (214144) reached for `:reports-to @[ceo]` / `@[vp-engineering]` to model org-chart edges — unprompted demand for cross-node references within a document (the `@[id]` insert/reference mechanism). inline_heavy also used `@[baseline-study]` inside `|{a :href …}`.
- **Typed inline elements for scientific data.** `|{measurement :value 245 :unit ms :sd 32}` and `|{dose :amount 200 :unit mg}` recur as the natural reach for typed data embedded in prose — the *want* behind the mixed-content thesis, even though the judge penalized its density (§3). The reach is the signal; the penalty is the open design tension.
- **Deep uniform nesting is comfortable.** The org-chart bodies nest 4–5 levels of `|person`/`|employee` with per-node attributes and stay readable — indentation-as- structure held up at depth for a genuinely hierarchical genre.

## Coverage / honesty

- **Read:** every `response:` body (45) and every `feedback:` field (45), via structured YAML extraction; one full realistic yaml read line-by-line (214520) to confirm field shape; the cheatsheet / minimal / comprehensive reference-context prompt blocks each read once (they recur unchanged across runs).
- **Not separately read:** the per-file repetition of those reference blocks; the Ruby harness plumbing (already witnessed in `commentary/I1-usability-witness.md`).
- **Model/era caveat:** single model (haiku-4-5), single day (2025-12-23), old spec. The footguns and context-effects may shift on newer models / current spec — carry as period evidence, not a standing benchmark. The `context_comparison` runs have no scores, so their quality read is my judgment against the rubric, not the harness's.
- **Open for synthesis / possible steward calls:** (a) the judge-restraint vs author-expressiveness tension (§3/§4) — is dense typed-inline markup a footgun or a wanted affordance the judge prior wrongly penalized? (b) the non-monotone context finding (§1) — does it survive on current models, and does it argue for genre-adaptive reference bundling in the harness?
