---
source: parallel harness-in-vivo sweep — repo ~/src-ext/opencode
gathered: 2026-07-21
status: vetted mining-spot map
repo_version: git dev @ f5573281 (2026-07-19 07:46, "chore: generate"); working tree dated 2026-07-18. opencode by anomalyco (github.com/anomalyco/opencode). Bun/TypeScript monorepo, Effect-based.
---

# opencode — agent harness/CLI, tool-use in vivo

**Center of mass:** `packages/opencode/src/tool/` (tool definitions + their `.txt` description prompts), `packages/opencode/src/session/prompt/` (one system prompt PER model family), and `packages/opencode/src/session/llm/` (streaming/native request adapters). The tool architecture is Effect + a `.ts`/`.txt` split: every built-in tool pairs a `<name>.ts` (schema + execute) with a `<name>.txt` (the verbatim model-facing description prompt). That `.txt` corpus is the single richest artifact here — real, shipping tool-use instructions.

All paths relative to repo root. High-value first.

## Tool-definition architecture (the abstraction)

- **`packages/opencode/src/tool/tool.ts`** (183 lines) — the tool `Def` interface (`id`, `description`, `parameters` schema, optional `jsonSchema`, `execute` returning `{title, metadata, output, attachments}`). Notable: `InvalidArgumentsError` (L24-34) whose `message` getter produces the model-facing "rewrite the input so it satisfies the expected schema" prose that the AI SDK feeds back as the tool result — i.e. the canonical schema-validation-failure → self-correction loop. Every tool's output is auto-truncated post-execute (L131-144). Date: 2026-07. **High** — this is the tool contract itself.
- **`packages/opencode/src/tool/json-schema.ts`** (164 lines) — how Effect schemas become the JSON Schema handed to the model: strips `additionalProperties`, removes `null` from optional-param `anyOf`, flattens single-member unions and `allOf`, inlines `$ref`/`$defs`, and forces explicit integer min/max bounds (L83-85). Concrete evidence of schema-sanitization done to keep provider tool-APIs happy. **High** for anyone designing machine-facing schemas.
- **`specs/v2/tools.md`** (186 lines) — the *design spec* for the v2 tool type: `Definition<Input,Output>` with Schema codecs for both input AND output, plus an optional `toModelOutput` that converts structured output into an array of `Tool.Content` blocks. Shows the intended direction: typed output + explicit model-rendering hook. Date: v2 spec, 2026. **High** — forward-looking structured-output design.
- **`packages/opencode/src/tool/registry.ts`** (450 lines) — assembles the active tool set per request. **Key finding (L286-295):** model-conditional tool routing — `usePatch = modelID.includes("gpt-") && !oss && !gpt-4` gives GPT-5-class models the `apply_patch` tool and hides `edit`/`write`; everyone else gets `edit`/`write` and no `apply_patch`. Also per-model schema override via `Provider.tool()` (L307-322), web-search gating, plugin/MCP tool ingestion (L120-190). **High** — direct evidence that edit-tool choice is model-specific.

## The edit-tool design (str-replace vs patch — both ship)

- **`packages/opencode/src/tool/edit.ts`** (737 lines) — the str-replace editor, and the standout artifact. Params (L47-56): `filePath/oldString/newString/replaceAll`. The `replace()` function (L682-729) runs a **cascade of 9 fuzzy replacer strategies** in order until one matches uniquely: `SimpleReplacer`, `LineTrimmedReplacer`, `BlockAnchorReplacer` (Levenshtein-similarity anchoring on first/last lines, threshold-gated, L288+), `WhitespaceNormalizedReplacer`, `IndentationFlexibleReplacer`, `EscapeNormalizedReplacer`, `TrimmedBoundaryReplacer`, `ContextAwareReplacer`, `MultiOccurrenceReplacer`. Plus `isDisproportionateMatch` (L731-737) that REFUSES a match whose span is much larger than `oldString` and tells the model to re-read. A must-read-before-edit lock enforced via typed errors. Date: 2026-07. **High** — the most developed fuzzy-edit tolerance logic in this repo; directly relevant to "how do agents edit reliably."
- **`packages/opencode/src/tool/edit.txt`** (11 lines) — the edit tool's model instructions: read-before-edit required, exact-indentation-after-line-prefix rule, the multi-match / not-found error contract, `replaceAll` for renames. **High** — the prose contract paired with edit.ts.
- **`packages/opencode/src/tool/apply_patch.ts`** (313 lines) + **`apply_patch.txt`** (34 lines) — the alternative editor for GPT models: an OpenAI-style `*** Begin Patch / *** Update File / @@ / +/- / *** End Patch` envelope supporting Add/Delete/Update+rename in one call. `.txt` is the verbatim patch-format grammar taught to the model. Date: 2026-07. **High** — the second, diff-based edit paradigm; contrast with edit.ts.
- **`packages/opencode/src/tool/write.txt`** (10 lines) + **`write.ts`** (104) — full-file write; read-before-overwrite enforced, "NEVER proactively create .md/README". **Medium.**

## Model-family system prompts (tool-use instruction, verbatim)

`packages/opencode/src/session/prompt/` — one prompt per model family, so this is a natural A/B corpus of how the SAME harness instructs DIFFERENT models to use tools. Each ~7-15KB. **High** collectively.

- **`anthropic.txt`** (~8KB, read in full) — the Claude prompt: "You are OpenCode"; heavy TodoWrite-usage mandate with worked examples; parallel-tool-call policy (L83-84); "use specialized tools not bash — Read not cat, Edit not sed, Write not heredoc" (L85); `file_path:line` citation convention (L98-105); `<system-reminder>` tag semantics (L75). **High** — the canonical tool-use instruction set.
- **`beast.txt`** (~11KB) — a maximally-autonomous "keep going until solved, never yield early, webfetch-everything" persona (the GPT "beast mode" prompt). **Medium** — extreme end of agent-autonomy prompting.
- **`gpt.txt`, `copilot-gpt-5.txt`, `codex.txt`, `gemini.txt`, `kimi.txt`, `meta.txt`, `trinity.txt`, `default.txt`, `build-switch.txt`** — per-family variants; `codex.txt` and `copilot-gpt-5.txt` pair with the apply_patch routing above. **Medium** — mine for cross-model tool-instruction deltas.
- **`plan-mode.txt`, `plan.txt`, `plan-reminder-anthropic.txt`** — the read-only "plan agent" mode instructions. **Medium.**
- **`packages/opencode/src/agent/prompt/{compaction,explore,summary,title}.txt`** — sub-agent / context-management prompts (compaction = context-window management). **Medium.**

## Other built-in tools (schema + .txt description each)

Each is a real machine-facing tool contract. **Medium-High** as a set; the `.txt` files are short and dense.

- **`read.ts`** (386) + **`read.txt`** — line-numbered `<line>: <content>` output format, 2000-line/50KB default caps, `offset`/`limit`, per-line 2000-char truncation, image (jpeg/png/gif/webp) + PDF returned as attachments (L304-306), "avoid tiny repeated slices" guidance. **High** — output-format + context-budget design.
- **`shell.ts`** (645) + **`shell/prompt.ts`** (dynamic prompt builder) + **`shell/shell.txt`** — the bash/shell tool. prompt.ts (L28-60) injects OS/shell-specific notes (PowerShell 7 vs 5.1 vs cmd chaining rules); `.txt` bans using shell for file ops and carries a full git/gh policy block. `workdir` param instead of `cd`. **High** — command-exec tool with OS-adaptive prompting.
- **`grep.ts`+.txt`, `glob.ts`+.txt`** — ripgrep/glob search; both `.txt`s steer open-ended search toward the Task tool to save context. **Medium.**
- **`task.ts`** (360) + **`task.txt`** — sub-agent spawner: fresh-context vs resumable `task_id`, "launch multiple concurrently", "outputs generally trusted", tell-it-code-vs-research.  
  **High** — multi-agent delegation contract.
- **`todo.ts`** + **`todowrite.txt`** — structured task-list tool with pending/in_progress/ completed/cancelled states and strict "exactly one in_progress" / "mark done only after verification" rules. **High** — a machine-readable progress-state format.
- **`webfetch.ts`(192)+.txt`, `websearch.ts`(143)+.txt`, `mcp-websearch.ts`** — fetch (markdown/text/html), search (live-crawl modes, current-year injection). **Medium.**
- **`lsp.ts`(113)+.txt`** — LSP code-intelligence tool (goToDefinition, findReferences, hover, call-hierarchy, workspaceSymbol); 1-based line/char. **Medium** — structured code-nav as a tool.
- **`skill.ts`(70)+.txt`** — loads a named "skill" (injects its instructions/resources into context). **Medium** — skill-injection mechanism.
- **`question.ts`(44)+.txt`** — structured user-question tool: array-of-labels answers, `multiple`, auto "type your own", "(Recommended)" convention. **Medium** — structured human-in-loop I/O.
- **`plan.ts`+plan-enter/exit.txt`** — mode-switch suggestion tools. **Low-Medium.**
- **`truncate.ts`(156)+`truncation-dir.ts`** — the tool-output context manager: outputs over 2000 lines / 50KB (L14-15) get written to a truncation dir and replaced with a preview + a hint to inspect the saved file (7-day retention). **High** — concrete "context management around tool results" evidence.
- **`invalid.ts`(21)** — the fallback tool for an unknown tool-id call. **Low.**

## Code-mode: MCP tools as a callable API inside a sandbox (recent advancement)

- **`packages/opencode/src/tool/code-mode.ts`** (310) — instead of exposing each MCP tool as its own model-visible tool, exposes a single `execute` tool ("Run a confined orchestration script with access to connected MCP tools", L14) that runs a script in a confined interpreter (`@opencode-ai/codemode`) where MCP tools are namespaced functions (`server.tool(...)`, grouped by server, L39-65). Projects MCP result content (text/image/ audio) back into attachments (L75+). Date: 2026-07. **High** — a genuinely recent tool-calling paradigm (script-orchestrated tool calls vs one-tool-per-call); very relevant to an agent-facing notation.

## Native/streaming request adapters (structured-output + streaming handling)

- **`packages/opencode/src/session/llm/AGENTS.md`** (91 lines, read in full) — the authoritative boundary doc: two runtimes (default **AI SDK** `streamText` → `ai-sdk.ts` adapts `fullStream` into shared `LLMEvent`s; opt-in **native** via `OPENCODE_EXPERIMENTAL_NATIVE_LLM=true`). Includes an ASCII flow diagram of the per-request native-gate with AI-SDK fallback (L38-81). Native supports OpenAI/OpenAI-compatible/Anthropic API-key only. **High** — how tool-calls + streaming events are normalized across providers.
- **`native-request.ts`** (196, read in full) — lowers opencode/AI-SDK-shaped messages into canonical `@opencode-ai/llm` requests: content-part mapping (text/media/reasoning/tool-call/ tool-result, L80-100), tool-result type coercion (json/text/error, L67-78), tool-definition construction (L126-133). **High** — the exact tool-call/tool-result wire shape.
- **`native-runtime.ts`** (195) — the native gate + tool bridge + LLMClient handoff. **Medium.**
- **`ai-sdk.ts`** (9315B) — the default `fullStream` → `LLMEvent` adapter. **Medium.**
- **`request.ts`** (7597B) — session request assembly. **Low-Medium.**

## Custom/plugin tool authoring (third-party tool-definition ergonomics)

- **`.opencode/tool/github-pr-search.ts`** (65, read in full) + **`github-triage.ts`** — real examples of the plugin `tool({ description, args: {query: tool.schema.string().describe(...)}, execute })` API. Shows the intended *ergonomic* surface for user-defined tools (Zod-ish schema, string return). **Medium** — what "defining a tool" looks like for an integrator.
- **`packages/opencode/src/agent/generate.txt`** (~5KB) — the meta-prompt that generates agent *configurations* from a description (persona + instructions + identifier synthesis).  
  **Medium** — agent-as-config generation.

## Dry wells / deliberately skipped

- `packages/tui/`, `packages/app/`, `packages/session-ui/`, `packages/ui/` — TUI/GUI rendering, not tool semantics. Skipped after dir-scan.
- 24 `README.*.md` translations, `screenshot-uk.png`, `STATS.md`, `sst.config.ts`, `infra/`, `nix/`, `flake.*` — build/marketing/infra, no tool content.
- `packages/console/`, `sdks/`, `github/` — hosted-console + SDK glue; not harness tool-use.
- `packages/docs/ai-tools/{claude-code,cursor,windsurf}.mdx` — docs comparing opencode to OTHER tools; positioning, not opencode's own tool defs. Low priority; skipped.

## Searches / commands run

- `git log -1` → dev @ f5573281, 2026-07-19; `git branch` → dev.
- `find -type d | grep -iE 'tool|prompt|agent|session|provider'` → located the two centers of mass.
- `ls -la tool/ tool/shell/ agent/prompt/ session/prompt/ session/llm/` + `wc -l tool/*.ts`.
- `grep -n` over `edit.ts` (replacer strategies), `registry.ts` (per-model routing).
- Read in full: tool.ts, json-schema.ts, native-request.ts, session/llm/AGENTS.md, github-pr-search.ts, edit.txt, apply_patch.txt, read.txt, shell.txt, todowrite.txt, task.txt, anthropic.txt, and the batch of small tool `.txt`s (skill/question/plan-enter/ plan-exit/webfetch/websearch/lsp/grep/glob/write). Read partial: edit.ts (replacer + params), code-mode.ts (L1-90), registry.ts (L1-80 + grep), read.ts (greps), truncate.ts (L1-40), shell/prompt.ts (L1-60), beast.txt/generate.txt heads, specs/v2/tools.md head.
- Dry-well confirmations: `ls specs/`, `ls .opencode/tool/`, `ls packages/docs/ai-tools`.
