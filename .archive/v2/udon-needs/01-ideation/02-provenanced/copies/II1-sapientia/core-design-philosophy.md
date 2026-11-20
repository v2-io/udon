---
source: sapientia tool-consciousness corpus (Joseph & Zi-am-tur, Sept 2025) — verbatim copy of cli-conventions/core-design-philosophy.md
gathered: 2026-07-21
status: gathered (verbatim whole-file copy)
paths:
  - ~/src/_core/sapientia/cli-conventions/core-design-philosophy.md
source_commit: 1ecc9f77e4884906dec1d2c1032f2a51ff3ee5e4
categories: [tier1-ideology, cli-conventions, agent-cli, unix-philosophy]
why_included: >
  The distilled thesis of the whole sapientia CLI-conventions corpus: Unix philosophy (do-one-thing, composable, silence-is-golden, fail-fast, idempotent) fused with explicit AI-Agent Design Principles (deterministic output, structured output modes, machine-readable errors, no interactive prompts in non-interactive mode). A compact demand statement for how a tool should present itself to an agent — directly applicable to any UDON/harness agent-facing CLI. Read first; siblings elaborate.
---

## Core Design Philosophy

### Unix Philosophy Foundations
- **Do one thing well** - Each utility should have a single, clear purpose
- **Composability** - Design for chaining with other tools via pipes
- **Text streams as universal interface** - With structured output options for machines
- **Silence is golden** - No output on success unless explicitly requested
- **Fail fast and explicitly** - Clear, immediate errors with proper exit codes
- **Idempotency** - Operations should be idempotent where possible

### AI Agent Design Principles
- **Predictable, deterministic behavior** - Same inputs always produce same outputs
- **Structured output modes** - JSON/TSV/CSV options via flags
- **Machine-readable errors** - Parseable error formats, not just human prose
- **Explicit verbosity control** - Clear separation of operational output vs diagnostic info
- **No interactive prompts in non-interactive mode** - Fail fast instead

