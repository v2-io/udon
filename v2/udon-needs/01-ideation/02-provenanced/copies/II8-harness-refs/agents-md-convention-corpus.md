---
source: the AGENTS.md agent-guidance-file convention, sampled across shipping CLIs + Joseph's own 2025 predecessor (geminex)
gathered: 2026-07-21
status: gathered — verbatim excerpts of two representative AGENTS.md files (opencode July 2026; geminex Sept 2025); the wider corpus is witnessed, not fully copied
paths:
  - /Users/josephwecker-v2/src-ext/opencode/AGENTS.md   # whole, excerpted
  - /Users/josephwecker-v2/src/_ref/_arch/geminex/AGENTS.md   # excerpted head (sections 1-7)
source_commit:
  - "src-ext/opencode: f5573281c (July 2026)"
  - "_ref/_arch/geminex: afacb5b (Sept 2025)"
categories: [agents-md, agent-guidance-file, project-instruction-convention, tier-2-shipped-practice, joseph-own-build, harness-handover]
why_included: >
  AGENTS.md is now a shipped cross-vendor standard (codex reads it per a formal
  scope/precedence spec — see agent-tool-authoring-conventions.md §C; the file
  appears at repo roots across codex/opencode/qwen-code/kimi-code/minimax-cli/
  mistral-vibe). This captures what such a file actually CARRIES — the demand
  signal being "what does an agent need told about a project that its training
  can't give it." Two contrasted samples: opencode's (a shipping product's,
  July 2026: dependency-direction rules, branch/commit conventions, a detailed
  TS style guide) and geminex's (Joseph's OWN Elixir agent-CLI predecessor,
  Sept 2025, Zoetica/sapientia lineage) — the latter doubling as a witness to his
  earliest agentic-tooling build. UDON is a candidate format for exactly this
  genre (structured project-instruction docs agents parse), so the convention's
  real-world shape is demand evidence.
---

## A. opencode/AGENTS.md (July 2026) — a shipping product's agent-guidance file (verbatim excerpt)

*What a mature coding CLI tells agents working IN its own repo. Note the shape:
hard build/codegen commands, an architectural invariant (dependency direction),
naming conventions, and a substantial style guide — all things an agent's training
can't supply about THIS project.*

```
- To regenerate the legacy JavaScript SDK, run `./packages/sdk/js/script/build.ts`.
- After changing the public Protocol or Server `HttpApi`, run `bun run generate` from `packages/client`. Do not edit `src/generated` or `src/generated-effect` directly.
- Keep runtime dependencies directed from Schema to Core and Protocol, then from Core and Protocol to Server. Client runtime code may depend on Schema and Protocol but never Core or Server.
- The default branch in this repo is `dev`. Local `main` ref may not exist; use `dev` or `origin/dev` for diffs.

## Branch Names
Use a short branch name of at most three words, separated by hyphens. Do not use slashes or type prefixes such as `feat/` or `fix/`.

## Commits and PR Titles
Use conventional commit-style messages and PR titles: `type(scope): summary`. Valid types are feat, fix, docs, chore, refactor, and test.

## Style Guide
- Keep things in one function unless composable or reusable
- Do not extract single-use helpers preemptively. Inline the logic at the call site unless the helper is reused, hides a genuinely complex boundary, or has a clear independent name that improves the caller.
- Avoid try/catch where possible; Avoid using the `any` type; Use Bun APIs when possible
- Rely on type inference; avoid explicit annotations unless necessary for exports or clarity
- Prefer functional array methods (flatMap, filter, map) over for loops
```

## B. geminex/AGENTS.md (Sept 2025) — Joseph's own agent-CLI predecessor (verbatim excerpt)

*Joseph's Elixir agent-CLI from the Zoetica/sapientia lineage — witness to his
earliest agentic-tooling build. The tool-and-streaming details are the signal:
a growing tool registry, ANSI-safe streaming of thinking/tool output, a `/context`
command, provider registry.*

```
# Geminex Agents Briefing (v0.3)
Welcome to Geminex. This briefing brings new collaborators up to speed on the current OTP umbrella, highlights feature gaps, and records the expectations around Zoetica's rituals.

## Repository Layout & Runtime Pieces
- apps/geminex_core/ – Session GenServers, provider registry, Anthropic SSE adapter + cache, and the growing tool registry.
- apps/geminex_cli/ – Option parsing, credential loading, /context command, and StreamPlayer that renders thinking/tool output with ANSI-safe helpers.

## Current CLI Capabilities
- Flags: --thinking on|off, --tools on|off, --tracking on|off, --color, --format, --dry-run, provider/model selectors, @file expansion, BSD sysexits codes.
- StreamPlayer prints 💭 thinking (dim magenta), tool requests, main content, and a [done] footer with cache + token metadata.
- /context command is wired but returns stub data until the resolver and token ledger are completed.
- Tool definitions live in GeminexCore.Tools; execution is still stubbed, so tool requests are informational only.

## Pending Work & Known Gaps
- Tool execution loop and tool_result submission pipeline remain to be built; the CLI currently only displays tool requests.
- Context budgeting, tracking snapshots, queued message UX, and live ratatui integration are open tasks.

## Workflow Expectations
- Follow Zoetica rituals when appropriate: plan → tribunal → implement → verify → document → handoff. Keep change-sets focused and reference TST reasoning.
```

**What the corpus witnesses.** An AGENTS.md carries the project-specific context an
agent's training cannot: exact build/codegen commands, architectural invariants,
naming/commit conventions, known-gaps, and (in Joseph's) the workflow ritual and
the streaming/tool-registry design. The *demand* it evidences is durable and
structured project-instruction documents that agents parse — a genre UDON directly
targets. Two era-separated samples (2025 Elixir predecessor → 2026 shipping TS
product) show the convention converging on the same job. The wider corpus (codex,
qwen-code, kimi-code, minimax-cli, mistral-vibe roots, plus many nested
package-level ones in opencode/kimi) is witnessed in the commentary file, not
copied — the two samples here are representative of the shape.
