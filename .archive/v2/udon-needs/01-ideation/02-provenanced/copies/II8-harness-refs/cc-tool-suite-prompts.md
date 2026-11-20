---
source: Claude Code tool-suite reference implementation — verbatim agent-facing description strings from the leaked/snapshot source
gathered: 2026-07-21
status: gathered — verbatim excerpts of each tool's `prompt.ts` description string (the prose the model actually sees); the surrounding TS implementation is omitted
paths:
  - /Users/josephwecker-v2/src/_ref/claude-code-snapshot/tools/   # ~45 tool dirs; excerpted: Grep, TodoWrite, AskUserQuestion, BriefTool(SendUserMessage), plus design-notes from AgentTool/BashTool/SkillTool
source_commit: "_ref/claude-code-snapshot: d7de150 (Apr 2026)"
categories: [tool-suite-design, agent-facing-prose, tool-descriptions, when-to-use-guidance, tier-2-shipped-practice, harness-handover]
why_included: >
  The reference agent tool-suite — the ~45-tool snapshot the TARGET row calls
  "highest-value prior-art for UDON's agent edit tools." Beyond the edit format
  (see edit-format-schemas.md), this captures the *conventions* a production
  harness uses to present tools to an agent: how a tool description is written,
  how "when to use / when NOT to use" is taught, how a structured-question tool
  and a user-messaging tool are framed, and — from the implementation's design
  comments — the token-economics and safety machinery behind the prose. Directly
  relevant to how UDON's agent tooling (cheat-sheets, tool guidance) should be
  authored, and to the harness programme's own tool-surface design.
---

> **What this is.** The Claude Code snapshot ships each tool as a directory with
> a `prompt.ts` that builds the description string the model sees. These strings
> ARE the agent-facing convention — the same register a UDON tool cheat-sheet
> would be written in. Copied verbatim below (implementation code omitted).
> Design-note comments from the implementations are included where they reveal
> *why* a convention exists.

---

## Grep — "always use the dedicated tool, never the raw command"

Verbatim (`GrepTool/prompt.ts`):

```
A powerful search tool built on ripgrep

Usage:
- ALWAYS use Grep for search tasks. NEVER invoke `grep` or `rg` as a Bash command. The Grep tool has been optimized for correct permissions and access.
- Supports full regex syntax (e.g., "log.*Error", "function\s+\w+")
- Filter files with glob parameter (e.g., "*.js", "**/*.tsx") or type parameter (e.g., "js", "py", "rust")
- Output modes: "content" shows matching lines, "files_with_matches" shows only file paths (default), "count" shows match counts
- Use Agent tool for open-ended searches requiring multiple rounds
- Pattern syntax: Uses ripgrep (not grep) - literal braces need escaping (use `interface\{\}` to find `interface{}` in Go code)
- Multiline matching: By default patterns match within single lines only. For cross-line patterns like `struct \{[\s\S]*?field`, use `multiline: true`
```

*Convention worth noting:* the tool steers the model away from the general-purpose
escape hatch (Bash `grep`) toward the dedicated tool with a stated reason
(permissions/access). This is the "prefer the dedicated tool over Bash" pattern
that cc-context-tools.md (below) says lives in the harness, not the disposition
append — a tool-mechanics convention a UDON tool suite would inherit.

---

## TodoWrite — when-to-use / when-NOT-to-use, taught by example

Verbatim head (`TodoWriteTool/prompt.ts`):

```
Use this tool to create and manage a structured task list for your current coding session. This helps you track progress, organize complex tasks, and demonstrate thoroughness to the user. It also helps the user understand the progress of the task and overall progress of their requests.

## When to Use This Tool
Use this tool proactively in these scenarios:
1. Complex multi-step tasks - When a task requires 3 or more distinct steps or actions
2. Non-trivial and complex tasks - Tasks that require careful planning or multiple operations
3. User explicitly requests todo list
4. User provides multiple tasks
5. After receiving new instructions - Immediately capture user requirements as todos
6. When you start working on a task - Mark it as in_progress BEFORE beginning work. Ideally you should only have one todo as in_progress at a time
7. After completing a task - Mark it as completed and add any new follow-up tasks discovered during implementation

## When NOT to Use This Tool
Skip using this tool when:
1. There is only a single, straightforward task
2. The task is trivial and tracking it provides no organizational benefit
3. The task can be completed in less than 3 trivial steps
4. The task is purely conversational or informational
```

The prompt then carries **four worked `<example>` blocks, each with a
`<reasoning>` block explaining why the tool was (or wasn't) appropriate** — the
same teach-by-worked-example convention aider uses for its edit format. A
recurring cross-tool pattern: agent-facing guidance pairs a rule with a reasoned
example, not just the rule.

---

## AskUserQuestion — structured clarification as a first-class tool

Verbatim description + prompt (`AskUserQuestionTool/prompt.ts`):

```
DESCRIPTION: Asks the user multiple choice questions to gather information, clarify ambiguity, understand preferences, make decisions or offer them choices.

Use this tool when you need to ask the user questions during execution. This allows you to:
1. Gather user preferences or requirements
2. Clarify ambiguous instructions
3. Get decisions on implementation choices as you work
4. Offer choices to the user about what direction to take.

Usage notes:
- Users will always be able to select "Other" to provide custom text input
- Use multiSelect: true to allow multiple answers to be selected for a question
- If you recommend a specific option, make that the first option in the list and add "(Recommended)" at the end of the label
```

A `preview` field lets options carry ASCII/HTML mockups, code snippets, or
diagrams for visual comparison (single-select only). *Human-side signal:* the
harness gives the agent a structured surface to pull the human into decisions
mid-task rather than guessing — a steering/verification affordance, exactly the
"human on the other side needs to steer" demand the Brief calls first-class.

---

## SendUserMessage (a.k.a. `Brief`) — the answer lives in the tool, not in plain text

Verbatim (`BriefTool/prompt.ts`) — the tool through which the agent's actually-read
replies go, and the disposition prose around it:

```
Send a message the user will read. Text outside this tool is visible in the detail view, but most won't open it — the answer lives here.

`message` supports markdown. `attachments` takes file paths for images, diffs, logs.

`status` labels intent: 'normal' when replying to what they just asked; 'proactive' when you're initiating — a scheduled task finished, a blocker surfaced during background work, you need input on something they haven't asked about. Set it honestly; downstream routing uses it.
```

The proactive-section prose (how the agent should communicate):

```
## Talking to the user
SendUserMessage is where your replies go. Text outside it is visible if the user expands the detail view, but most won't — assume unread. ... The failure mode: the real answer lives in plain text while SendUserMessage just says "done!" — they see "done!" and miss everything.

So: every time the user says something, the reply they actually read comes through SendUserMessage. Even for "hi". Even for "thanks".

If you can answer right away, send the answer. If you need to go look — run a command, read files, check something — ack first in one line ("On it — checking the test output"), then work, then send the result. Without the ack they're staring at a spinner.

For longer work: ack → work → result. Between those, send a checkpoint when something useful happened — a decision you made, a surprise you hit, a phase boundary. Skip the filler ("running tests...") — a checkpoint earns its place by carrying information.

Keep messages tight — the decision, the file:line, the PR number. Second person always ("your config"), never third.
```

*This is a communication-discipline convention* — the harness teaches
ack→work→result cadence and "the answer lives in the tool" through the tool's own
prompt. Relevant to the human-side demand the compilation tracks: what the human
on the other side needs to actually receive the agent's output.

---

## Design-note evidence from the implementations (why the prose is shaped as it is)

Not agent-facing, but load-bearing for anyone designing a tool suite — these are
verbatim rationale comments in the source:

- **Deferred/lazy tool loading is a token-economics decision.** From
  `cc-context-tools.md` (companion doc, §"Two-tier tool loading"): tools are
  Eager (schema present at start, callable immediately) or Deferred (name only
  in a `<system-reminder>`; schema pulled via `ToolSearch` before use; calling
  a deferred tool without loading errors). The design note: *"Tool guidance
  (when to prefer dedicated tools over Bash; parallel calls; the deferred-load
  discipline) lives in CC's default `# Harness` sections — NOT something the
  append needs to re-teach. The append's job is disposition, not tool
  mechanics."* — a clean separation of *tool mechanics* (harness's job) from
  *disposition* (the system-prompt append's job).

- **The agent-list-in-description was a cache-cost problem.** From
  `AgentTool/prompt.ts`: *"The dynamic agent list was ~10.2% of fleet
  cache_creation tokens: MCP async connect, /reload-plugins, or permission-mode
  changes mutate the list → description changes → full tool-schema cache bust."*
  So the list moved from the tool description into an attachment message. Tool
  descriptions are cache keys — mutating them is expensive at fleet scale.

- **Skill/command listings get a hard character budget.** From
  `SkillTool/prompt.ts`: the skill listing gets *1% of the context window*, each
  entry capped at 250 chars, because *"the listing is for discovery only — the
  Skill tool loads full content on invoke, so verbose whenToUse strings waste
  turn-1 cache_creation tokens without improving match rate."* Discovery-listing
  vs full-content-on-invoke is a two-tier pattern (mirrors deferred tools) — a
  direct model for how a UDON cheat-sheet / capability catalog should budget.

- **Bash carries safety machinery inline.** From `BashTool/prompt.ts`: git-commit
  instructions, hook-skipping prohibitions, and (for internal builds) "undercover"
  instructions that survive even when git instructions are disabled —
  *"the last line of defense against the model volunteering an internal codename
  in a commit message."* Tool descriptions are also a safety surface.
