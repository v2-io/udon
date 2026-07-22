---
source: Anthropic's own conventions for authoring agent-facing capabilities (anthropic-skills mcp-builder + agent_skills_spec) + codex production system-prompt personality/planning conventions
gathered: 2026-07-21
status: gathered — verbatim excerpts (mcp-builder agent-centric design principles; SKILL.md spec; codex personality/autonomy/planning); each source is larger than excerpted
paths:
  - /Users/josephwecker-v2/src/_ref/anthropic-skills/mcp-builder/SKILL.md   # excerpted: "Agent-Centric Design Principles"
  - /Users/josephwecker-v2/src/_ref/anthropic-skills/agent_skills_spec.md   # excerpted: what a SKILL is + frontmatter contract
  - /Users/josephwecker-v2/src-ext/codex/codex-rs/core/gpt_5_2_prompt.md   # 298 lines; excerpted personality / AGENTS.md / autonomy / planning
source_commit:
  - "_ref/anthropic-skills: c74d647 (Nov 2025)"
  - "src-ext/codex: 0fb559f0f (July 2026)"
categories: [tool-authoring-conventions, cheat-sheet-design, agent-facing-prose, system-prompt, tier-2-shipped-practice, harness-handover]
why_included: >
  Two vendors' explicit doctrine on how to write things agents consume — directly
  relevant to how UDON's agent tooling (cheat-sheets, tool guidance, capability
  catalogs) and the harness's own tool surfaces should be authored. Anthropic's
  mcp-builder states the quality bar outright — "the quality of an MCP server is
  measured by how well it enables LLMs to accomplish real-world tasks" — and gives
  five agent-centric design principles (build for workflows not endpoints;
  optimize for limited context; actionable/educational error messages; natural
  task subdivisions; evaluation-driven development). The agent_skills_spec defines
  the discoverable-capability packaging convention (a SKILL.md folder). Codex's
  production system prompt shows the canonical personality/autonomy/planning prose
  a shipping harness gives a frontier model. The witness question answered: what
  the humans building agent tools believe those tools must do FOR the agent —
  workflow-shaped, context-frugal, self-teaching.
---

## A. Anthropic mcp-builder — the agent-centric design principles (verbatim)

*`_ref/anthropic-skills/mcp-builder/SKILL.md`, Nov 2025. The stated quality bar,
then five principles for designing tools an LLM will actually use well.*

The bar:

> "An MCP server provides tools that allow LLMs to access external services and
> APIs. **The quality of an MCP server is measured by how well it enables LLMs to
> accomplish real-world tasks using the tools provided.**"

The five principles, verbatim:

```
Build for Workflows, Not Just API Endpoints:
- Don't simply wrap existing API endpoints - build thoughtful, high-impact workflow tools
- Consolidate related operations (e.g., schedule_event that both checks availability and creates event)
- Focus on tools that enable complete tasks, not just individual API calls
- Consider what workflows agents actually need to accomplish

Optimize for Limited Context:
- Agents have constrained context windows - make every token count
- Return high-signal information, not exhaustive data dumps
- Provide "concise" vs "detailed" response format options
- Default to human-readable identifiers over technical codes (names over IDs)
- Consider the agent's context budget as a scarce resource

Design Actionable Error Messages:
- Error messages should guide agents toward correct usage patterns
- Suggest specific next steps: "Try using filter='active_only' to reduce results"
- Make errors educational, not just diagnostic
- Help agents learn proper tool usage through clear feedback

Follow Natural Task Subdivisions:
- Tool names should reflect how humans think about tasks
- Group related tools with consistent prefixes for discoverability
- Design tools around natural workflows, not just API structure

Use Evaluation-Driven Development:
- Create realistic evaluation scenarios early
- Let agent feedback drive tool improvements
- Prototype quickly and iterate based on actual agent performance
```

**Cross-tool echo:** "Make errors educational, not just diagnostic" is the same
teaching-semantics idea as the sapientia REQ-28 "show ALL match line-numbers" and
the fork-recommendation's Requirement H. "Optimize for limited context / make
every token count / high-signal not data dumps" is the same budget discipline as
Claude Code's 1%-context skill listing (see cc-tool-suite-prompts.md). Independent
statements of a shared doctrine: agent tools must be workflow-shaped, context-
frugal, and self-teaching.

## B. Agent Skills spec — the discoverable-capability packaging convention (verbatim excerpt)

*`_ref/anthropic-skills/agent_skills_spec.md`. How a capability is packaged so an
agent can discover and load it on demand — the same discovery/on-demand-load
pattern as deferred tools and the Skill listing budget.*

```
A skill is a folder of instructions, scripts, and resources that agents can
discover and load dynamically to perform better at specific tasks. In order for
the folder to be recognized as a skill, it must contain a `SKILL.md` file.

The skill's "entrypoint" is the SKILL.md file. It is the only file required to
exist. The file must start with a YAML frontmatter followed by regular Markdown.

The YAML frontmatter has 2 required properties:
- name — hyphen-case, must match the directory name
- description — what the skill does and when Claude should use it
```

*Notation-relevant:* the SKILL.md convention is a document format for agent
capabilities — YAML frontmatter (typed metadata) + Markdown body (prose
instructions) + optional resources. This is precisely the "structure + prose in
one file" shape UDON targets, shipped as a real agent-facing standard — a live
comparator and a candidate future consumer class.

## C. codex production system prompt — personality / autonomy / planning (verbatim excerpt)

*`src-ext/codex/codex-rs/core/gpt_5_2_prompt.md` (298 lines, July 2026). The
canonical agent-facing tone-and-behavior prose a shipping harness gives GPT-5.2.
Head excerpted; the full file also covers sandbox/approval model, apply_patch (see
edit-format-schemas.md), and output formatting.*

Personality:

> "Your default personality and tone is concise, direct, and friendly. You
> communicate efficiently, always keeping the user clearly informed about ongoing
> actions without unnecessary detail. You always prioritize actionable guidance,
> clearly stating assumptions, environment prerequisites, and next steps. Unless
> explicitly asked, you avoid excessively verbose explanations about your work."

The AGENTS.md contract (how the harness tells the agent to honor repo-local
instruction files — the convention the AGENTS.md corpus below is written against):

> "The scope of an AGENTS.md file is the entire directory tree rooted at the
> folder that contains it. For every file you touch in the final patch, you must
> obey instructions in any AGENTS.md file whose scope includes that file. …
> More-deeply-nested AGENTS.md files take precedence in the case of conflicting
> instructions. Direct system/developer/user instructions take precedence over
> AGENTS.md instructions."

Autonomy/persistence:

> "Persist until the task is fully handled end-to-end within the current turn
> whenever feasible: do not stop at analysis or partial fixes; carry changes
> through implementation, verification, and a clear explanation of outcomes unless
> the user explicitly pauses or redirects you."

Planning (the `update_plan` tool, and the "not for padding" discipline — a near-exact
twin of Claude Code's TodoWrite when-to/when-NOT-to guidance):

> "Note that plans are not for padding out simple work with filler steps or stating
> the obvious. … Maintain statuses in the tool: exactly one item in_progress at a
> time; mark items complete when done. … Do not jump an item from pending to
> completed: always set it to in_progress first. Do not batch-complete multiple
> items after the fact."

**Convergence note:** codex's `update_plan` discipline and Claude Code's
`TodoWrite` guidance (cc-tool-suite-prompts.md) are almost the same text from two
vendors — exactly-one-in-progress, no batch-completion, no filler steps, mark
in_progress before starting. A shipped-practice convergence on how an agent should
externalize a plan.
