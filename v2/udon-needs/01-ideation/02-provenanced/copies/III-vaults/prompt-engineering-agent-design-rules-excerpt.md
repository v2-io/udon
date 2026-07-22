---
source: ~/vaults/gemini/PROMPT_ENGINEERING_GUIDE.md §"Core Implementation Principles" (excerpt of a 16 KB "AI Agent Prompt Engineering Guide for Claude")
gathered: 2026-07-21
status: gathered — excerpt (lines 16-37; the design-rules list only, not the API/technique-library bulk)
paths:
  - ~/vaults/gemini/PROMPT_ENGINEERING_GUIDE.md:16-37
source_commit: git f8a6ec99a9749f3fce763c6bdb9cb95a75ca8496 (repo ~/vaults/gemini)
categories: [tier2-shipped-practice, agent-prompt-design, structured-output, determinism, self-contained-context, validation-first, observability]
why_included: >
  The distilled design rules the built gemini system operated under, stated as
  demand text: self-contained prompts ("Claude has zero context beyond your
  prompt"), temperature=0 for reproducibility, structured XML/JSON output for
  reliable parsing, fail-fast/validation-first, observable intermediate steps.
  These are the generative-side counterpart to the output-contract linter
  (see the lineage characterization): the same operator both prompted for
  structured output AND lint-enforced it. Relevant to the harness's
  loop-trust/observability questions and to UDON-as-a-structured-output-target
  for agents. The rest of the guide (API config, technique library, Python
  ClaudeAgent class) is implementation, left in place.
---

## Core Implementation Principles

### Agent-Focused Design Rules
1. **Explicit over implicit** - Claude has zero context beyond your prompt
2. **Deterministic by default** - Use `temperature=0.0` for reproducible results
3. **Structured output preferred** - XML/JSON for reliable parsing
4. **Fail-fast validation** - Build verification into prompts
5. **Composable patterns** - Design reusable prompt components

### Agent Implementation Rules
- **No context assumption** - Every prompt must be completely self-contained
- **Externalized reasoning required** - Chain-of-thought must be visible in output
- **Deterministic behavior preferred** - Consistent results for agent reliability
- **Structured parsing targets** - Design outputs for programmatic consumption

### Reliability Patterns for Agents
1. **Validation-first design** - Include output format validation in prompts
2. **Graceful degradation** - Handle partial/malformed responses
3. **Retry-friendly patterns** - Design prompts for automatic retry
4. **Observable intermediate steps** - Enable debugging of reasoning chains

---
