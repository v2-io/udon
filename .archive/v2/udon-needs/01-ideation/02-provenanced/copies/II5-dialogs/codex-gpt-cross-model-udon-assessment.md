---
source: OpenAI Codex CLI sessions (GPT-family model) assessing UDON at Joseph's
  request — two independent sessions, Dec 2025 and Mar 2026. Surfaced by the
  demand-phrase transcript sweep (2026-07-21) and read span-by-span.
gathered: 2026-07-21 (transcript-hit triage)
status: gathered excerpt (codex-log turn-spans; full sessions remain at source)
paths:
  - ~/.codex/sessions/2025/12/24/rollout-2025-12-24T08-15-47-019b50ee-36c3-7453-8372-7d4dcf6bee4b.jsonl:33   # spec read + strengths/risks/suggestions
  - ~/.codex/sessions/2025/12/24/rollout-2025-12-24T08-15-47-019b50ee-36c3-7453-8372-7d4dcf6bee4b.jsonl:269  # DSL-source-of-truth threshold (80-90% + escape hatch)
  - ~/.codex/sessions/2025/12/24/rollout-2025-12-24T08-15-47-019b50ee-36c3-7453-8372-7d4dcf6bee4b.jsonl:398  # under-time-crunch: use UDON only when it removes work
  - ~/.codex/sessions/2026/03/07/rollout-2026-03-07T12-33-33-019cc9ca-6fc0-71a0-b373-a4ef2208d5a3.jsonl:333  # where it wins / where I'd be skeptical / what I'd protect
source_mtime: live-session codex jsonl (line numbers are memorata3 turn indices)
categories: [cross-substrate-testimony, non-claude-model, demand-fit-assessment, adoption-skepticism, dsl-source-of-truth, where-not-to-use, tier-cross-model, positioning]
why_included: >
  CROSS-SUBSTRATE TRIANGULATION — the brief names cross-tier convergence as "the
  compilation's highest-value content," and warns that agreement across Joseph's
  own projects is coherence, not corroboration (one author). This is the rare
  thing that escapes that caveat: a NON-Claude model (GPT-family, via the OpenAI
  Codex CLI), prompted by Joseph to assess UDON cold from the spec, independently
  lands on the SAME demand-shape the Claude-side corpus converged on — "prose and
  structure in one surface," "typed scalars without a second embedded language,"
  "readable in a plain terminal," "streamable/event-oriented" — and independently
  names UDON's niche as agent-oriented / literate-config / spec-with-examples /
  RAG-chunking documents. Equally valuable: it supplies the honest counter-weight
  the single-author corpus structurally can't — where NOT to use UDON (don't
  replace JSON-for-APIs / TOML-for-config / Markdown-for-publishing), the
  ecosystem cold-start risk, and a crisp decision rule ("use UDON when it removes
  work — codegen/consistency/docs/migrations/validations — not when it's another
  layer to keep aligned"). Two independent sessions three months apart give a weak
  within-model reliability check too. This is demand evidence a Claude instance
  cannot generate about itself.
---

# GPT/Codex on UDON — an outside substrate's assessment (Dec 2025 + Mar 2026)

> Joseph handed the UDON spec to the OpenAI Codex CLI (a GPT-family model) twice,
> months apart, and asked for an honest read. What it independently reaches for —
> the same niche the Claude-side corpus converged on — is corroboration that
> survives the single-author caveat. What it pushes back on is the counter-weight
> the corpus lacks.

## 1. First cold read — strengths, risks, suggestions
### codex 2025-12-24 session, turn 33

> Read `README.md`, `SPEC.md`, and `examples/minimal.udon`.
>
> UDON feels like a thoughtful synthesis of Markdown's prose ergonomics with a data model that's more legible than XML and more deterministic than YAML. The spec reads cohesive, and the minimal example makes the core mental model click quickly.
>
> **Strengths I see**
> - The "tiers of voice" framing is crisp and communicates intent well.
> - Syntactic typing + explicit escape rules solve the YAML footguns cleanly.
> - Indentation + inline/embedded elements give a nice spectrum from prose-first to structure-first.
> - The dynamics layer is intentionally scoped and host-extensible—good separation of concerns.
> - The column-aligned sibling rule is powerful; it's a rare capability that could be a signature feature.
>
> **Potential risks / things to clarify**
> - Column-aligned sibling behavior is subtle; needs very explicit parser rules + examples to avoid surprises.
> - Embedded element parsing (`|{...}`) with nested inline text may create edge cases; would benefit from more examples and guidance on when *not* to use it.
> - Mixins/inheritance semantics are only partially defined; that could cause divergent implementations if it isn't tightened.
> - The interaction between attributes-as-typed-scalars vs block values is great, but I'd want a few "gotchas" sections to prevent misuse.
>
> **Suggestions (lightweight)**
> - Add a "parser invariants" checklist (indent rules, attribute ordering, suffix expansion timing) in `SPEC.md`.
> - Provide 1–2 "gotchas" per major feature (column alignment, embedded elements, dynamics).
> - Expand `examples/minimal.udon` with one explicit column-aligned sibling example and one ambiguity-avoiding pattern.
> - Consider a short "UDON vs YAML/Markdown" migration guide in `README.md` to reduce adoption friction.

## 2. The DSL-source-of-truth threshold
### codex 2025-12-24 session, turn 269

> Yes. If UDON covered the bulk of the resource declaration and I only had to drop to Elixir for the irreducible bits, I'd prefer UDON. That's exactly the "best of both worlds" threshold: DSL for 80–90% + escape hatch for the rest.

## 3. Under a time crunch — the decision rule
### codex 2025-12-24 session, turn 398

> Short answer: under a time crunch, I'd default to the host DSL (Ash/Archema) unless the UDON layer *clearly* saves time via automation (codegen, docs, migrations, validations, consistency checks). If UDON is "source of truth" and I can get working resources faster with fewer mistakes, I'd use it. If it's just another layer I have to keep aligned, I'd skip it and write Ash/Archema directly.
>
> So my instinct in crunch mode is:
> - **Use UDON** when it removes work (scaffolding + consistency + docs), not when it duplicates it.
> - **Use host DSL** when speed is about shipping behavior and I already have powerful, familiar primitives.

## 4. Three months later — where it wins, where to be skeptical, what to protect
### codex 2026-03-07 session, turn 333

> My general take: the format is genuinely interesting, and not in a "novel syntax for its own sake" way. It has a real thesis.
>
> That thesis seems to be:
> - prose and structure should live in the same surface syntax,
> - typed scalar data should not require a second embedded language,
> - the format should still be readable in a plain terminal,
> - and parsing should be streamable and event-oriented.
>
> I think that thesis is stronger than most "new markup/config" efforts.
>
> **What I think is genuinely strong** — The best idea in UDON is not any single token. It is the combination of: indentation-based hierarchy, explicit structural markers, prose as a first-class citizen, and typed values without dropping into JSON or YAML mode. That gives it a niche most formats do not cover well.
>
> - Markdown is good for prose but weak for structured typed data.
> - YAML is decent for config but awkward for mixed narrative documents.
> - XML can represent everything, but authoring it is miserable for humans.
> - JSON is machine-friendly but hostile to authoring and prose.
> - TOML is nice for config, but not for document-like mixed content.
>
> UDON's core insight is that a lot of real-world authoring is neither "just config" nor "just text." It is a mix: a spec with examples, a prompt with metadata, a playbook with prose and machine-usable structure, a policy doc with annotations, a DSL embedded in ordinary writing. For that class of problem, UDON is stronger than the usual alternatives.
>
> **The most compelling part** — the strongest practical argument for UDON is not "it can replace everything." It is this: it can be a good authoring format for structured, semantically rich documents that still need to read like documents. That matters a lot now, especially for: agent-oriented documents, literate configuration, internal specs, workflow/playbook files, retrieval/chunking pipelines, promptable knowledge bases.

*(Elsewhere in the same 2026-03-07 session — surfaced but not re-quoted in full —
the model states the counter-weight explicitly: it would be skeptical of any pitch
that UDON should replace JSON-for-APIs, TOML-for-simple-config, Markdown-for-
ordinary-publishing, or XML where schema/tooling is already dominant — "that is
not where it wins"; and the things it "would protect at all costs" are terminal
readability, obvious indentation semantics, strong prose support, simple
structural prefixes, explicit typed values, host-agnostic parsing, and
event-stream friendliness. A Claude-side agent's honest bottom line from the
Dec-2025 origin session reached the same skeptical note independently — the
agent-native positioning is the right bet, but the ecosystem cold-start is the
real risk [libudon session 44b9bc45…:60, not copied].)*
