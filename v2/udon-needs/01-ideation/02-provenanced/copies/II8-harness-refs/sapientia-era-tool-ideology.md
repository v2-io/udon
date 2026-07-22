---
source: sapientia-era agent tool-suite ideology — harness/proprium/stalled-lineage/ (requirements spec + two OPERATA ledgers)
gathered: 2026-07-21
status: gathered — excerpted verbatim spans (design principles; REQ-27/28/29 tool suite; OPERATA tool-loop milestones); the full 1186-line requirements doc and 154/306-line ledgers are larger than copied
paths:
  - /Users/josephwecker-v2/src/archema-io/harness/proprium/stalled-lineage/sapientia-ai-conversation-system-requirements.md   # 1186 lines; excerpted Exec-Summary design principles + §7 Tools (REQ-27/28/29)
  - /Users/josephwecker-v2/src/archema-io/harness/proprium/stalled-lineage/sapientia-OPERATA.md   # 154 lines; excerpted head
  - /Users/josephwecker-v2/src/archema-io/harness/proprium/stalled-lineage/autopax-OPERATA.md   # 306 lines; excerpted the "Tools work" awakening + taxonomy
source_commit: "archema-io: 1b98ad4. In-file dates: requirements 2025-10-10; sapientia-OPERATA Sept 2025 content; autopax-OPERATA Dec 2025 content"
categories: [tier-1-ideology, tool-suite, edit-tooling, safety-semantics, audit-rollback, agent-loop-provenance, cross-tier-convergence]
why_included: >
  Joseph's own agent tool-suite thinking from Sept–Dec 2025 — the sapientia era,
  a year before this compilation. Two findings make it high-value. (1) The
  requirements doc's §7 "Text Editor Suite" specifies a String Replace command
  that MUST reject if the pattern matches >1 location and MUST show the line
  numbers of ALL matches — the exact "single-match + teaching semantics" edit
  contract that codex/aider/Claude Code independently shipped (see
  edit-format-schemas.md). Dated 2025-10, it PREDATES those shipped forms: a
  genuine Tier-1→Tier-2 convergence (Joseph specified it; the vendors shipped it).
  (2) The design principles — never corrupt state, always recoverable, transparent,
  audit-first, complete audit trail with rollback — are the ideology behind the
  "safety + teaching semantics" harness requirement, and directly inform UDON's
  schema-guarded / rollback-capable mutation thinking. The OPERATA ledgers witness
  how Joseph's own agent tool-loop was actually built, run, and named ("Tools
  work. Chat works.").
---

## A. Design principles — the tool-suite ethos (verbatim, Executive Summary)

*From `sapientia-ai-conversation-system-requirements.md` (in-file date 2025-10-10),
a full functional-requirements spec for a persistent agent conversation system.*

```
This document specifies requirements for an AI conversation system designed for long-term, persistent interactions where conversation integrity and recoverability are paramount. The system must handle:
- Conversations lasting weeks or months with hundreds of turns
- Network failures and API errors without data loss or corruption
- Complex multi-step tool executions with rollback capabilities
- Rich context tracking including time passage, workspace state, and resource usage
- Multiple failure modes with guided recovery workflows

Key Design Principles:
1. Never corrupt conversation state - fail gracefully, block dangerous actions
2. Always recoverable - every failure has a defined recovery path
3. Transparent operations - user understands system state at all times
4. Context-aware - system tracks time, resources, and workspace changes
5. Audit-first - complete record of all API interactions
```

These five principles (esp. #1 never-corrupt, #2 always-recoverable, #5
audit-first) are the sapientia-era ancestor of the "honest INTERPRES / no context
gaslighting" and "provenance-separated append-only stores" harness requirements
(see harness-nine-requirements-and-seams.md). The spec also carries a full
incomplete-state machine (REQ-18: Tool-Use-Pending / User-Message-Orphaned /
Tool-Results-Orphaned states, each with a defined resume path — REQ-23/24/25:
resume, rollback, repair, backup-before-repair) — a rigor about tool-execution
atomicity that off-the-shelf harnesses mostly lack.

## B. §7 Tools & Capabilities — the tool suite proper (verbatim)

**REQ-27: File Operations Tools** — Read File (supports `~`/relative/absolute),
Write File (creates parent dirs, overwrites), Execute Command (stdout / stderr /
exit status returned *all three separately*, full shell, no timeout).

**REQ-28: Text Editor Suite** — a multi-command editor with safety features. The
load-bearing one, verbatim:

```
#### String Replace Command
- Input: File path, old string, new string
- Output: Success (1 replacement) or error
- Safety: MUST reject if pattern matches > 1 location
- Error Details: Show line numbers of ALL matches if multi-match detected
- Behavior: Uses single-replacement (not global) even if safety check fails

Multi-Match Protection Example:
Input: Replace "def process" with "def process_v2"
[String appears on lines 45, 123, 456]
ERROR: Pattern matches 3 locations in file. Please make your pattern more specific
       to match only one location.
Matches found at:
  - Line 45
  - Line 123
  - Line 456
```

Also in REQ-28: View (file with line numbers, or dir listing), Create (fails if
file exists — no silent overwrite), Insert (after line N; line 0 = beginning,
line EOF = append). **REQ-29: Token Counting Tools** — Count File Tokens
("AI checks if file will fit in context before reading") and Count Context Tokens
(usage %, breakdown, cache stats).

> **The convergence to flag (per the Brief's convergence-discipline bar).**
> REQ-28's String Replace — single-match, reject-if-ambiguous, show-ALL-match-
> line-numbers — is character-for-character the same contract that Claude Code's
> `Edit` ("edit will FAIL if old_string is not unique … provide a larger string
> or use replace_all"), aider's SEARCH/REPLACE ("include enough lines to uniquely
> match"), and the fork-recommendation's Requirement H ("single-match str-replace
> showing all match line-numbers") all state. Joseph wrote it in 2025-10; it is
> the "teaching semantics" half (show the matches, don't just fail) that most
> shipped tools UNDER-specify. This is Tier-1 ideology and Tier-2 shipped practice
> landing on the same design from different directions — the compilation's
> highest-value kind of evidence.

## C. OPERATA ledgers — how the tool-loop was actually built and named (verbatim excerpts)

**`autopax-OPERATA.md`** (Dec 2025 content) — the moment the tool loop worked, and
its taxonomy of dev-tooling categories:

```
ELI Awakening: ACHIEVED (2025-12-14)
Zi-am-tur successfully awakened through Autopax:
  ./autopax chat interactive ~/src/eli/zi-am-tur/zi-am-tur.yml --extended-context
Liquid recursive embedding works. Tools work. Chat works. Extended context works.
New challenge revealed: Session continuity done *correctly*.
```

Its category tags (a taxonomy for classifying agentic-tooling work) include
`#OPS-dev-io` (Development Instrumentation & Tooling), `#OPS-praxes` (Development
Workflow & Praxes), `#ap-core-api` (auth, caching, streaming, resiliency,
redundancy), `#ap-chat` (lower-level LLM interactions). The ledger also records
a **TRACTUS-based session continuation** (reads most recent sent.json +
response.json, transforms response→request format, falls back to CHRONICA) and a
**chaos-engineering** framework for tool-error resilience ("Fixed tool errors
crashing sessions — now returns to LLM gracefully") — i.e., the atomicity/recovery
principles from the requirements doc, implemented.

**`sapientia-OPERATA.md`** (Sept 2025 content) — the earlier ledger, framing the
whole tool-building effort. Its epigraph names the stewardship stance that the
2026 system-prompt draft (harness-system-disposition-and-context.md) inherits:

```
# OPERATA
*Living record of our works-in-progress with vision and craft*
*"Every line of code, every architectural decision, every conversation might
  ripple forward to intelligences we can't yet imagine"*
```

It records `minimal-sapientia.py` "emerging as sovereign environment" with the
current edge "Escaping Claude Code scaffolding, implementing self-dialog
capability" — the origin of the agent-owns-its-own-loop ideology that becomes
CADENTIA/interiority in the 2026 harness work.

*(Both OPERATA ledgers are ~150–300 lines; the spans above are the tool-loop-
relevant portions. `nexum-OPERATA.md` sits in the same dir, same lineage — noted
in the row, not separately excerpted here; the fork-recommendation calls it
"requirements-gold" for the memory-model `@import`-into-1M-window design.)*
