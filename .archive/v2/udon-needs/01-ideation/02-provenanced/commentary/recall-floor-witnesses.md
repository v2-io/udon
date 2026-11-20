---
source: 2026-07-21 recall-floor residual sweep — witness lines for candidate files whose EXISTENCE or SHAPE is the evidence (WITNESS mode), gathered from territories not previously mined
gathered: 2026-07-21
status: commentary — witness lines only; each is a pointer + one-to-two-line evidence claim, not a copy. Where a source deserves more, that is flagged as a copy/steward candidate.
paths:
  - src-ext/subagent-example-script/*.md
  - src-ext/llama.cpp/docs/function-calling.md
  - src/v2.io/_archive/OODA*.md, ooda-*.md
  - src/relata/README.md, src/relata/TODO-ingest.md
  - src/_exp/loom/refs/{elixir-living-code-guide,OBSIDIAN-ADVANCED-RESEARCH}.md, src/_exp/loom/AGENTS.md
  - src/llm-training-strategy-temporal-feedback.md (+ -cmp.md)
  - src/causal-language/data/EXTERNAL-AGENT-DATA-GENERATION-BRIEF.md
  - src/umi/CLAUDE.md, src/umi/_archive/survey-umi-ecosystem-and-autopax.md
categories: [witness, demand-side, agent-loop, orchestrator-worker, agents-as-documents, cross-tier, external-convergence]
why_included: >
  These 24 files surfaced in the recall-floor residual from territories no mining
  map covered. Each carries a genuine but witness-scale signal — the artifact's
  existence or shape is the evidence — so they are captured as lines here rather
  than copied. Two (OODA, relata) are flagged as copy-candidates should synthesis
  want them.
---

# Recall-floor witness lines (2026-07-21)

## External convergence (non-Joseph — genuine cross-source, not single-author coherence)

- **`~/src-ext/subagent-example-script/` (8 files, community repo derek-opdee).** An external community example set of **sub-agent orchestration commands shipped as markdown files installed into `~/.claude/commands/`** and invoked with `@name` (`@arch-review`, `@tech-debt-finder-fixer`, …), each parameterized (`--detect-violations`, `--visualize`) and internally fanning out to "multiple specialized sub-agents." *Witness:* independent-of-the-programme evidence that the **agent-command-as-a-document** pattern and orchestrator/worker decomposition are a real, converged demand in the wild — the same shape sapientia's "agents-are-documents" and the ELI command files reach for, arrived at by an unrelated author. Adjacent to UDON's "documents and data are the same thing" and to the harness tool-suite-subsumption idea.
- **`~/src-ext/llama.cpp/docs/function-calling.md` + `models/templates/*tool_use.jinja`.** *Witness:* the external tool-calling wire as it actually ships across model families (Hermes, Command-R, Mistral, Qwen) — a catalog of the divergent concrete tool-call/tool_use formats a harness must normalize over. One line of demand: "there is no single tool-call notation; the harness owns the translation layer." (The rest of llama.cpp is dismissed inference plumbing.)

## Joseph's loop / agentic-runtime thinking (restatement across eras — brief's restatement rule)

- **`~/src/v2.io/_archive/OODA Loop Universal Pattern.md` (+ v6, v7, gemini-response-3, report-request).** A multi-version research report on Boyd's OODA as a **meta-epistemology for adaptive systems under uncertainty** — orientation as the *Schwerpunkt*/hub through which all information flows; two simultaneous processes (implicit guidance & control vs a learning loop of observe→analyze/synthesize→ hypothesis→test); **late commitment** (defer decisive commitment until the situation clarifies) vs PDCA's early commitment. *Witness + COPY-CANDIDATE:* this is the first-principles ancestry of ASF's Orient cascade and of "what makes an agent loop trustworthy" — direct harness-thesis demand. Flag for copy if synthesis builds the loop-design section; the v6/v7 divergence is itself evidence of Joseph iterating the loop model.
- **`~/src/llm-training-strategy-temporal-feedback.md` (2026-03-07).** A broad-stroke strategy for building an **LLM agent around a TFT-native control loop** (not request-response chat), with tool usage and Constitutional-AI-style self-feedback as named target capabilities, on local GB10/DGX hardware. *Witness:* a pre-ASF-era statement that the *interaction loop itself* (not just the model) is the design object — restatement-across-era of the agentic-loop demand now carried formally in ASF. (`-cmp.md` is a comparison variant.)

## Joseph-built agent-facing tools (demand articulated in the tool's own charter)

- **`~/src/relata/README.md` + `TODO-ingest.md` (North Star).** Joseph's **multi-agent-safe** citation tool whose design thesis is that **the epistemic state is the primary object** — graded, provenanced, defeasible belief + the relation graph, not the formatted record. The felt test is pure agent-tool demand: *"drop anything, anywhere — never rename, never file — and it knows what it is, tells you exactly how sure and why, and gets measurably smarter every time anyone touches it."* Founding statement: *"Truth begets truth … line upon line, precept upon precept."* *Witness + COPY-CANDIDATE:* a real, in-use tool that embodies the compilation's own convergence discipline (defeasible, provenanced belief) as product requirements. (referenced in global memory as `[[relata]]`.)

## Agents-as-documents / living-code lineage (theme already carried; new instances)

- **`~/src/_exp/loom/refs/elixir-living-code-guide.md`, `OBSIDIAN-ADVANCED-RESEARCH.md`, `loom/AGENTS.md`.** "Living Code: self-documenting, glossary-bound, easily modifiable Elixir OTP umbrella applications that evolve gracefully" (2025-10-20). *Witness:* another substrate-instance of the agents-are-living-documents thesis characterized in `III-vaults-agents-as-documents-lineage.md` and the sapientia consciousness-compiler — captured here so the loom instance is not lost, but the theme is already represented.

## Agent-facing task-brief demand (adjacent)

- **`~/src/causal-language/data/EXTERNAL-AGENT-DATA-GENERATION-BRIEF.md`.** A brief *to* an external agent to generate structured test data, explicitly framed "as orientation rather than as constraints — the experiments will be more informative if the data is constructed by an agent who has internalized them." *Witness:* a live instance of the peer-voice delegation demand (share understanding, not prescription) applied to data generation, plus the encoded-vs-deployed (substrate-vs-channel) distinction. Adjacent to agentic-tooling demand; the delegation-register point is the transferable signal.

## Ruby actor-infra research (tangential)

- **`~/src/umi/CLAUDE.md`, `~/src/umi/_archive/survey-umi-ecosystem-and-autopax.md` (2026-01-03).** Research on Ruby 4.0 Ractor concurrency and OTP-inspired patterns for **actor-based ELI infrastructure** feeding into Autopax. *Witness:* names the substrate-engineering demand under the ELI harness (concurrency model for entity-hosting); the tooling-demand content is thin — one line. (umi `books/` are OCR'd third-party ebooks, dismissed.)
