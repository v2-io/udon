---
source: nexum repo — .archive/ (main synthesized CLI-design recommendation)
gathered: 2026-07-21
status: gathered
paths:
  - /Users/josephwecker-v2/src/_core/nexum/docs/.archive/cli-design-recommendation.md
source_commit: c87c75ce20aeaad9290732e17be256601b45a338
categories: [agent-cli-conventions, testing-first, mode-aliases, stream-separation, session-management, dual-interactive-headless]
why_included: >
  Committed 2025-11-07 (internal date "2025-01-06" is a confirmed mis-date). The synthesis the other
  CLI-research docs in this section fed into: testing-first design, mode-based aliases, clean
  stdout/stderr separation, dual interactive-REPL + headless/scriptable modes, auto-save session
  management with named checkpoints. Built from real minimal-sapientia usage + modern-AI-CLI survey +
  the sapientia conventions. The consolidated "how an agent-facing conversational CLI should be shaped"
  document for the harness consumer.
---
# Nexum CLI Design Recommendation

**Date:** 2025-01-06
**Status:** Draft for Review
**Purpose:** Comprehensive CLI design based on research of minimal-sapientia usage, modern AI CLIs, and established CLI conventions

---

## Executive Summary

Based on analysis of:
- Nexum's architecture and goals (TDD-first, audit trail, GhosTTY TUI focus)
- Actual minimal-sapientia usage patterns (58 commands from zsh history)
- Modern AI CLIs (Claude Code, Codex, Gemini)
- CLI conventions (~/src/sapientia/cli-conventions/)

**Core Recommendations:**

1. **Testing First** - Design CLI to make testing trivial from day one
2. **Mode-Based Aliases** - `nexum-test`, `nexum-debug` for common scenarios
3. **Clean Output Separation** - stdout for data, stderr for diagnostics
4. **Dual Operation Modes** - Interactive REPL + headless/scriptable
5. **Session Management** - Auto-save with optional named checkpoints

---

## Part 1: Usage Pattern Analysis

### Minimal-Sapientia Actual Usage (zsh history)

**Most Common Pattern (42 of 58 invocations):**
```bash
./bin/minimal-sapientia -p [prompt-file] -i [context-file] --tracking
```

**Key Findings:**

1. **`--tracking` used in 90% of real sessions** (vs being optional in design)
   - **Implication:** Should be default-on, not opt-in
   - **Open Question:** Any scenarios where tracking should be off?

2. **System prompt (`-p`) and initial context (`-i`) almost always paired**
   - **Implication:** Consider streamlining these
   - **Alternative 1:** Single `--context` flag that loads both
   - **Alternative 2:** Convention where `NEXUM.md` includes both sections
   - **Open Question:** Are they truly separate concerns or should they merge?

3. **Session continuation (`-c`) heavily used (26% of invocations)**
   - **Implication:** Must be first-class, not afterthought
   - **Need:** Clear semantics for auto-save vs explicit resume

4. **Sampling experiments common (10 invocations)**
   - `--temperature`, `--top-p`, `--no-thinking` used together
   - **Implication:** Need these controls early even if basic
   - **Open Question:** Should these be interactive commands too? (`/temperature 0.5`)

5. **Flag confusion in codex usage**
   - User tried both `-c` and `-p` for config file override
   - **Implication:** Flag naming clarity critical
   - **Recommendation:** Use `--config` (unambiguous)

### Modern CLI Usage Patterns

**Claude Code (44 invocations):**
- Dominated by simple `claude` and `claude -c`
- MCP management frequent but separate concern
- Debug flags essential during development

**Codex (36 invocations):**
- Resume by ID is primary workflow
- `--full-auto` preset reduces cognitive load
- Config override needed for multi-config testing

**Gemini (4 invocations):**
- Least used, simplest invocations
- MCP management similar pattern across all three

**Commonalities (Ubiquitous Patterns):**
- All support interactive + headless modes
- All have session persistence/resumption
- All support JSON output for automation
- All integrate MCP for extensibility
- All have debug/verbose modes

---

## Part 2: Command Structure Recommendations

### Top-Level Commands

```bash
# Primary modes
nexum                                  # Interactive REPL (default)
nexum "initial prompt"                 # Start with prompt
nexum -p "prompt"                      # Headless mode

# Session management
nexum --continue                       # Continue last session
nexum --resume [id]                    # Resume specific session
nexum list-sessions                    # Show all sessions

# Utilities
nexum self-test                        # Validate installation
nexum health                           # System health
nexum --help                           # Help
nexum --version                        # Version
```

### Mode Aliases (Symlinks/Wrappers)

**High Priority (Phase 1-2):**
```bash
nexum-test        # json output, no color, batch mode - for CI/CD
nexum-ai          # Alias for nexum-test (AI agent-friendly)
nexum-debug       # verbose, trace, metrics
```

**Medium Priority (Phase 3):**
```bash
nexum-safe        # dry-run, confirmations
```

**Rationale:** Testing showed users prefer `--full-auto` over remembering complex flag combinations. Codex's preset approach reduces cognitive load.

**Open Questions:**
- Should `nexum-test` be the canonical name or `nexum-ai`?
- Should we support user-defined aliases via config?
- What about `nexum-quick` (fast, minimal validation)?

### Flag Design Philosophy

**Principles from CLI Conventions:**
1. Short flags for common operations (`-c`, `-v`)
2. Long flags must be descriptive (`--system-prompt`, not `-p`)
3. Boolean flags have `--no-` variants (`--thinking` / `--no-thinking`)
4. Stackable short flags where sensible (`-vvv` for verbose levels)

**Key Flags:**

```bash
# Output Control
--format=text|json|stream-json         # Output format
--no-color                             # Disable colors
--color=auto|always|never              # Color control

# Verbosity
-v, --verbose                          # Increase verbosity (stackable)
-q, --quiet                            # Suppress non-error output
--debug                                # Maximum debug output

# Session Management
-c, --continue                         # Continue last session
--resume=ID                            # Resume specific session

# Configuration
--config=PATH                          # Override config file
--system-prompt=FILE                   # System prompt (not -p)
--initial-context=FILE                 # Initial context (not -i)

# Feature Toggles
--thinking / --no-thinking             # Extended thinking
--tools / --no-tools                   # Tool use
--tracking / --no-tracking             # Tracking snapshots

# Sampling
--temperature=FLOAT                    # 0.0-1.0 (default: 1.0)
--top-p=FLOAT                          # 0.0-1.0
--max-tokens=INT                       # Max output tokens

# Behavior
--dry-run                              # Preview without execution
--batch                                # Non-interactive mode
--full-auto                            # Preset: --batch --format=json
```

**Open Questions:**
- Keep `-p` for backward compat or break immediately?
- Keep `-i` for initial-context or break immediately?
- Should `-c` mean `--continue` or `--config`? (codex uses it for config)
- Alternative: Use `--resume` exclusively, drop `-c` to avoid confusion

**Alternative Flag Schemes:**

**Option A: Break from minimal-sapientia cleanly**
- Remove `-p`, `-i`, `-c` short flags
- Force long flags only: `--system-prompt`, `--initial-context`, `--continue`
- Pros: Clear, unambiguous
- Cons: More typing, breaks muscle memory

**Option B: Keep but deprecate**
- Support `-p`, `-i`, `-c` with deprecation warnings
- Show "Use --system-prompt instead" in stderr
- Remove in version 2.0
- Pros: Smooth transition
- Cons: More code, warnings clutter output

**Option C: Hybrid**
- Keep `-c` for `--continue` (most used)
- Drop `-p`, `-i` (force long flags for clarity)
- Pros: Balances brevity and clarity
- Cons: Inconsistent philosophy

---

## Part 3: Configuration Management

### File Locations (XDG Standard)

```
~/.config/nexum/
  ├── config.json              # User configuration
  ├── mcp.json                 # MCP server config (Phase 4+)
  └── prompts/                 # Optional prompt templates

~/.local/share/nexum/
  ├── sessions/                # Session storage
  │   └── conversation_*/
  └── audit/                   # Audit trails

~/.cache/nexum/                # Cache (if needed)

.nexum/
  ├── config.json              # Project config (team-shareable)
  └── NEXUM.md                 # Project context (Gemini-inspired)
```

### Configuration Precedence (Highest to Lowest)

1. Command-line flags
2. Environment variables (`NEXUM_*`)
3. Project config (`./.nexum/config.json`)
4. User config (`~/.config/nexum/config.json`)
5. Built-in defaults

**Open Questions:**
- Should `.nexum/config.json` be `.nexum.json` (dotfile in project root)?
- Should we support TOML (like Codex) or stick with JSON?
- Should system-wide config exist (`/etc/nexum/config.json`)?

### Configuration File Format

**Option A: Flat JSON (Simple)**
```json
{
  "tracking": true,
  "thinking": true,
  "tools": true,
  "temperature": 1.0,
  "format": "text",
  "sessions_dir": "~/.local/share/nexum/sessions"
}
```

**Option B: Nested JSON (Organized)**
```json
{
  "version": "1.0",
  "defaults": {
    "tracking": true,
    "thinking": true,
    "tools": true,
    "temperature": 1.0,
    "format": "text"
  },
  "paths": {
    "sessions": "~/.local/share/nexum/sessions",
    "audit": "~/.local/share/nexum/audit",
    "prompts": "~/.config/nexum/prompts"
  },
  "ui": {
    "color": "auto",
    "mode": "tty"
  }
}
```

**Recommendation:** Option B for extensibility, but support flat format too (convert internally).

---

## Part 4: Output Format Strategy

### Core Principle (from CLI Conventions)

**stdout = data only (pipeable)**
**stderr = all diagnostics, progress, errors**

This is CRITICAL but minimal-sapientia violates it (mixes status messages with data on stdout).

### Format Options

**Text Mode (default for interactive):**
```
=== Nexum - Conversation with Claude ===
Session: conversation_20251107_093022
Tracking: enabled | Thinking: enabled | Tools: enabled

> your prompt here

[Assistant]:
Response text here...
```

**JSON Mode (default for batch):**
```json
{
  "session_id": "conversation_20251107_093022",
  "turn": 1,
  "role": "assistant",
  "content": [{"type": "text", "text": "Response..."}],
  "usage": {"input_tokens": 1234, "output_tokens": 567}
}
```

**Stream-JSON Mode (for real-time):**
```json
{"type":"session_start","session_id":"..."}
{"type":"turn_start","turn":1}
{"type":"content","delta":{"type":"text","text":"Response "}}
{"type":"content","delta":{"type":"text","text":"text..."}}
{"type":"turn_end","usage":{...}}
```

### Mode Detection (Auto-Agent Mode)

**Trigger agent mode when:**
- `--format=json` explicitly requested
- `!$stdout.isatty` (non-TTY output)
- `ENV['CI']` set
- `ENV['NEXUM_AGENT_MODE'] == '1'`
- `--batch` flag

**Agent mode behavior:**
- No progress indicators, spinners, colors
- Structured output preferred (JSON)
- No interactive prompts (fail instead)
- Deterministic output ordering

**Open Questions:**
- Should agent mode suppress ALL stderr or just progress indicators?
- Should `--verbose` override agent mode's silence?
- How to handle stream merging (`2>&1`) detection?

---

## Part 5: Session Management

### Auto-Save Strategy

**Every conversation auto-saved to:**
```
~/.local/share/nexum/sessions/conversation_YYYYMMDD_HHMMSS/
  ├── conversation.jsonl      # Conversation log
  ├── manifest.json           # Session metadata
  └── checkpoints/            # Named checkpoints (optional)
      └── tag-name.jsonl
```

**Resume Options:**
```bash
nexum --continue                        # Resume last session
nexum --resume conversation_20251107_093022
nexum --resume-checkpoint tag-name      # Resume from named checkpoint
```

### Named Checkpoints (Gemini-Inspired)

**In interactive mode:**
```
> /save before-refactor
Checkpoint saved: before-refactor

> /resume before-refactor
Resumed checkpoint: before-refactor
```

**Via CLI:**
```bash
nexum save-checkpoint <tag>
nexum resume-checkpoint <tag>
```

**Open Questions:**
- Should checkpoints be per-session or global?
- Should `/save` without tag create auto-numbered checkpoint?
- How to list available checkpoints? (`nexum list-checkpoints`?)
- Should checkpoints be full conversation copies or diffs?

### Session Storage Structure

**Minimal (Current Approach):**
```
conversation.jsonl              # Just the conversation log
```

**Extended (Proposed):**
```
conversation.jsonl              # Conversation events
manifest.json                   # Metadata (model, config, timestamp)
checkpoints/                    # Named save points
  ├── before-refactor.jsonl
  └── working-state.jsonl
```

**Audit Repository (Separate):**
```
~/.local/share/nexum/audit/conversation_20251107_093022/
  ├── .git/                     # Git-backed audit trail
  ├── turn_001_sent.json
  ├── turn_001_response.json
  └── telemetry.jsonl
```

**Alternative:** Merge audit into session directory?
- Pros: Everything in one place
- Cons: Mixes concerns (conversation vs forensics)

---

## Part 6: Interactive Mode Features

### In-Session Commands (Slash Commands)

**Inspired by Gemini's prefix system:**

```
/help                   # Show available commands
/save <tag>             # Named checkpoint
/resume <tag>           # Restore checkpoint
/list                   # List checkpoints
/stats                  # Token usage statistics
/context                # Show context usage
/debug                  # Toggle debug mode
/format <format>        # Change output format
/quit, /exit            # Exit
```

**From minimal-sapientia (preserve):**
```
/temp <value>           # Set temperature
/exit, /save, /context, /debug, /repair, /resume, /rollback
```

**Open Questions:**
- Which commands from minimal-sapientia should we keep?
- Should `/save` auto-commit to audit git repo?
- Should there be `/undo` or `/rollback` to previous turn?
- Should `/export` generate markdown/PDF summaries?

### File Inclusion Shorthand (Gemini-Inspired)

```
> Please review @src/nexum/conversation/session.rb and explain the architecture
```

Expands to file content injection.

**Open Questions:**
- Should `@` also support globs? (`@src/**/*.rb`)
- Should it respect .gitignore by default?
- Should there be size limits per-file or total?
- Alternative syntax: `#include path/to/file`? (less ambiguous with mentions)

### Shell Integration (Defer to Phase 3+)

Gemini has `!` prefix for shell commands. We already have bash tool.

**Open Question:** Should `!` be shorthand for bash tool invocation?

---

## Part 7: Testing-First Design

### Requirements from CLI Conventions

Checklist from `cli-conventions/examples-and-patterns.md`:

- [ ] All exit codes are meaningful
- [ ] stdout contains only pipeable data
- [ ] stderr used for all diagnostics
- [ ] Works in non-interactive mode
- [ ] Handles Ctrl+C gracefully (SIGINT)
- [ ] Responds to SIGTERM for clean shutdown
- [ ] Validates all inputs
- [ ] Provides helpful error messages
- [ ] Documentation matches implementation
- [ ] Works with `set -euo pipefail`

**Critical Implications:**

1. **Exit codes must follow sysexits.h conventions**
   - 0 = success, 2 = usage error, 64-78 = specific errors
   - See full table in docs/cli-design-recommendation.md

2. **Stream separation is non-negotiable**
   - All status/progress to stderr
   - Only data to stdout
   - Enables: `nexum ... | jq .status`

3. **Signal handling must save state**
   - SIGINT (Ctrl+C) → save session, exit 130
   - SIGTERM → clean shutdown, exit 143
   - SIGHUP → reload config (optional)

4. **Input validation before execution**
   - Temperature/top-p ranges (0.0-1.0)
   - File existence checks
   - Session ID format validation
   - Conflicting option detection

### Testing Infrastructure Needs

**Phase 1 (MVP):**
- RSpec unit tests for argument parsing
- Integration tests using existing PtyHarness
- Smoke tests for basic invocations
- Shell integration tests (`set -euo pipefail`)

**Phase 2:**
- CI integration (GitHub Actions)
- Test all mode aliases
- Test all output formats
- Test signal handling

**Phase 3:**
- Fuzzing for argument parser
- Performance benchmarks
- Load testing for long conversations

---

## Part 8: Error Handling

### Error Message Philosophy (from conventions)

**Human-readable (default):**
```
Error: Session not found
  ID: conversation_20251107_150000
  Searched: ~/.local/share/nexum/sessions/

Try one of these commands:
  nexum list-sessions           # View all sessions
  nexum --continue              # Continue last session
  nexum "new conversation"      # Start new session
```

**Machine-readable (--format=json):**
```json
{
  "error": {
    "type": "SessionNotFoundError",
    "code": "SESSION_NOT_FOUND",
    "message": "Session not found",
    "details": {
      "session_id": "conversation_20251107_150000",
      "search_path": "~/.local/share/nexum/sessions/"
    },
    "help_url": "https://docs.nexum.dev/errors/session_not_found"
  }
}
```

**Key Principles:**
1. Always provide context (what failed, where)
2. Always suggest next actions
3. Include help URLs for complex errors
4. Both formats must contain same information

### Exit Code Strategy

**Standard Codes (sysexits.h):**
```
0     SUCCESS             - Operation successful
1     GENERAL_ERROR       - General error
2     USAGE_ERROR         - Invalid flags/arguments
64    EX_USAGE            - Command line usage error
65    EX_DATAERR          - Data format error
66    EX_NOINPUT          - Cannot open input file
69    EX_UNAVAILABLE      - Service unavailable (API)
70    EX_SOFTWARE         - Internal software error
74    EX_IOERR            - I/O error
78    EX_CONFIG           - Configuration error
130   SIGINT              - Interrupted (128 + 2)
143   SIGTERM             - Terminated (128 + 15)
```

**Nexum-Specific (80+):**
```
80    SESSION_NOT_FOUND   - Session ID doesn't exist
81    AUTH_FAILED         - Authentication failed
82    CONTEXT_OVERFLOW    - Context window exceeded
```

---

## Part 9: MCP Integration (Defer to Phase 4+)

### Rationale for Deferral

All three modern CLIs support MCP, making it a standard pattern. However:

**Defer because:**
- Core conversation loop more critical
- Can add without breaking changes
- Additional testing complexity
- Usage data shows MCP used but not heavily (10-15% of commands)

**When to implement:**
- After Phase 3 (core features stable)
- When test coverage is high (>80%)
- When users request it explicitly

### Proposed MCP Commands (when ready)

```bash
nexum mcp add <name> [...]
nexum mcp list
nexum mcp remove <name>
nexum mcp get <name>
```

**Configuration location:**
```
~/.config/nexum/mcp.json
```

**Open Questions:**
- Use same format as Claude Code/Codex or diverge?
- Should MCP servers be per-project (`.nexum/mcp.json`)?
- Should there be MCP server marketplace/catalog?

---

## Part 10: Migration from Minimal-Sapientia

### Compatibility Strategy

**Option A: Clean Break**
- No backward compatibility
- Force users to update commands
- Provide migration guide
- Pros: Clean design, no cruft
- Cons: Friction for existing users

**Option B: Compatibility Shim**
- Provide `minimal-sapientia-compat` wrapper
- Translates old flags to new
- Warnings about deprecation
- Pros: Smooth transition
- Cons: Maintains old patterns

**Option C: Compatibility Mode**
- Detect old-style invocation
- Auto-translate with warnings
- Remove in version 2.0
- Pros: Balance of both
- Cons: Complex argument parser

**Recommendation:** Option B (compatibility shim) for 6 months, then remove.

### Migration Guide (Draft)

```markdown
# Migrating from Minimal-Sapientia to Nexum

## Command Mapping

| Old | New | Notes |
|-----|-----|-------|
| `minimal-sapientia -p prompt.md` | `nexum --system-prompt prompt.md` | Clearer intent |
| `minimal-sapientia -i context.md` | `nexum --initial-context context.md` | Clearer intent |
| `minimal-sapientia -c conversation.jsonl` | `nexum --resume conversation` | Resume by ID |
| `minimal-sapientia --tracking` | `nexum` | Now default-on |
| `minimal-sapientia [...]` | `nexum [...] --format=json | jq` | Pipeable output |

## Breaking Changes

1. **Session storage moved to `~/.local/share/nexum/sessions/`** (XDG standard)
2. **Tracking enabled by default** (use `--no-tracking` to disable)
3. **stdout contains only data** (progress/errors to stderr)
4. **Short flags renamed** (`-p` → `--system-prompt`, etc.)

## New Features

- Mode aliases: `nexum-test` for CI integration
- Named checkpoints: `/save <tag>` in sessions
- File inclusion: `@path/to/file` in prompts
- JSON output: `--format=json` for automation
```

---

## Part 11: Open Questions Requiring Decisions

### High Priority (Before Phase 1)

1. **Flag naming: Break from minimal-sapientia immediately or gradually?**
   - Immediate: Cleaner, forces users to learn new way
   - Gradual: Smoother, but maintains confusion longer

2. **Tracking default: On or off?**
   - Data says: On (90% usage rate)
   - But: What if user doesn't want tracking for privacy?

3. **Continue vs Resume: Should `-c` mean --continue or --config?**
   - Codex uses `-c` for config
   - Minimal-sapientia uses `-c` for continue
   - Conflict resolution needed

4. **System prompt + initial context: Keep separate or merge?**
   - Usage shows they're always paired
   - But: Architecturally distinct (identity vs context)

5. **Exit code 80+: Reserve range for nexum-specific or use sysexits only?**
   - Sysexits only: Standard but limited
   - Custom range: Flexible but non-standard

### Medium Priority (Before Phase 2)

6. **Configuration format: JSON, TOML, YAML, or support all?**
   - JSON: Simple, built-in Ruby support
   - TOML: Human-friendly (Codex uses it)
   - YAML: Common but complex

7. **Checkpoint storage: Per-session or global namespace?**
   - Per-session: Organized but requires session context
   - Global: Simpler but potential tag collisions

8. **Agent mode: Should it suppress all stderr or just progress?**
   - All: Cleanest output
   - Progress only: Errors still visible

9. **Mode aliases: Install automatically or require explicit setup?**
   - Auto: Convenient but clutters bin/
   - Manual: Clean but requires user action

### Low Priority (Phase 3+)

10. **MCP config: Per-user or per-project or both?**
11. **Shell integration: Support `!` prefix or defer to bash tool?**
12. **File inclusion: Support globs or single files only?**
13. **Export formats: Markdown, PDF, HTML?**

---

## Part 12: Alternatives Considered

### Alternative 1: Subcommand Structure (like git/docker)

```bash
nexum session start [...]
nexum session resume [id]
nexum session list
nexum checkpoint save <tag>
nexum checkpoint resume <tag>
nexum mcp add [...]
```

**Pros:**
- Organized, scalable
- Clear namespacing
- Easy to extend

**Cons:**
- More verbose for common operations
- Not used by any of the three modern CLIs
- Doesn't match usage patterns (simple invocations dominate)

**Decision:** Reject. Top-level commands + subcommands only for management (like `nexum mcp`).

### Alternative 2: Single Binary with Mode Detection Only

```bash
nexum                          # Detect mode from context
```

**Pros:**
- Simplest user interface
- No flags to remember

**Cons:**
- Magic behavior confusing
- Hard to force specific mode
- Testing difficult

**Decision:** Reject. Explicit modes via flags + aliases better.

### Alternative 3: Separate Binaries per Mode

```bash
nexum-interactive              # Interactive REPL
nexum-batch                    # Batch/headless
nexum-test                     # Test mode
```

**Pros:**
- No mode detection needed
- Clear intent
- Easy to test

**Cons:**
- Proliferation of binaries
- Confusion over which to use
- Not standard pattern

**Decision:** Partial adopt. Main `nexum` + mode aliases (`nexum-test`, etc.).

---

## Part 13: Implementation Phasing

### Phase 1: MVP (Weeks 1-2)

**Goal:** Basic interactive + headless modes with session persistence

**Deliverables:**
- Argument parser (basic flags)
- Interactive REPL (simple, no TTY::Reader yet)
- Headless mode (`-p "prompt"`)
- Session auto-save
- Session resume (`--continue`, `--resume`)
- JSON output (`--format=json`)
- stdout/stderr separation
- Exit codes
- RSpec test suite
- PTY integration tests

**Flags:**
```bash
--format=text|json
--continue / --resume
--verbose, --debug
--no-color
--tracking / --no-tracking
--thinking / --no-thinking
--tools / --no-tools
```

**Open Questions Before Starting:**
- Flag names finalized? (break from minimal-sapientia or compat?)
- Tracking default-on confirmed?
- `-c` means continue or config?

### Phase 2: Enhanced Modes (Weeks 3-4)

**Goal:** Mode aliases, configuration, sampling controls

**Deliverables:**
- Mode aliases (`nexum-test`, `nexum-debug`)
- Configuration file support
- User config (`~/.config/nexum/config.json`)
- Project config (`.nexum/config.json`)
- Environment variables (`NEXUM_*`)
- Sampling controls (`--temperature`, `--top-p`)
- Named checkpoints
- Signal handling (SIGINT, SIGTERM)
- Input validation
- Error formatting (human + JSON)

**Flags:**
```bash
--config PATH
--temperature X
--top-p Y
--max-tokens N
save-checkpoint <tag>
resume-checkpoint <tag>
```

### Phase 3: Rich Features (Weeks 5-6)

**Goal:** In-session commands, file inclusion, TUI improvements

**Deliverables:**
- Slash commands (`/save`, `/stats`, etc.)
- File inclusion (`@path/to/file`)
- TTY::Reader integration (multi-line editing)
- Session management commands (`list-sessions`, `fork-session`)
- Help improvements (`--help --format=json`)
- Man page
- Shell completion (zsh, bash)

### Phase 4: MCP Integration (Week 7+)

**Goal:** Extensibility via Model Context Protocol

**Deliverables:**
- MCP configuration
- MCP commands (`nexum mcp add/list/remove`)
- MCP server integration
- Tool discovery and invocation

**Defer until:** Core stable, test coverage high, user demand.

---

## Part 14: Success Criteria

### Phase 1 Success Criteria

- [ ] Can start interactive session: `nexum`
- [ ] Can run headless: `nexum -p "test" --format=json | jq .status`
- [ ] Can resume session: `nexum --continue`
- [ ] stdout contains only data (pipeable)
- [ ] stderr contains diagnostics
- [ ] Exit codes follow sysexits.h
- [ ] All tests pass
- [ ] Works with `set -euo pipefail`

### Phase 2 Success Criteria

- [ ] CI integration works: `nexum-test "prompt" | jq .`
- [ ] Config files respected (user + project)
- [ ] Sampling controls work
- [ ] Ctrl+C saves session gracefully
- [ ] Named checkpoints work
- [ ] Error messages helpful (human + JSON)

### Phase 3 Success Criteria

- [ ] In-session commands work (`/save`, `/stats`)
- [ ] File inclusion works (`@path/to/file`)
- [ ] Multi-line editing smooth (TTY::Reader)
- [ ] Help is comprehensive and accurate
- [ ] Shell completion available

### Long-Term Success Criteria

- [ ] Becomes reference implementation for conversation CLIs
- [ ] Testing is trivial (one-liner CI integration)
- [ ] Documentation matches implementation
- [ ] Users prefer it over minimal-sapientia
- [ ] Audit trail provides forensic value
- [ ] Extensible via MCP without core changes

---

## Part 15: Next Steps

### Immediate Actions (This Week)

1. **Review this document** - Discuss findings, alternatives, open questions
2. **Make key decisions** - Flag naming, tracking default, exit codes
3. **Prioritize features** - Confirm Phase 1 scope
4. **Create ADR** - Architectural Decision Record for major choices
5. **Spike argument parser** - Prototype basic parsing to validate design

### Before Implementation (Next Week)

6. **Write help text** - Complete `--help` output
7. **Create test plan** - Detailed test scenarios for Phase 1
8. **Setup CI** - GitHub Actions workflow skeleton
9. **Update AGENTS.md** - Agent guidance for CLI work
10. **Update TODO.md** - Break down implementation tasks

### Implementation (Weeks 1-2)

11. **Build Phase 1** - Following TDD approach
12. **Test continuously** - Every feature with RSpec
13. **Document as you go** - Keep help text updated
14. **Daily commits** - Frequent small commits

---

## Appendices

### Appendix A: Full Exit Code Table

See `docs/exit-codes.md` (to be created)

### Appendix B: CLI Conventions Reference

See `~/src/sapientia/cli-conventions/` (already exists)

### Appendix C: Modern CLI Comparison

See `docs/modern-cli-comparison.md` (to be created)

### Appendix D: Minimal-Sapientia Usage Analysis

See `docs/minimal-sapientia-usage-analysis.md` (to be created)

---

## Document Status

- **Draft:** 2025-01-06
- **Review:** Pending
- **Approved:** TBD
- **Implementation:** TBD

## Related Documents

- `docs/rewrite-plan.md` - Overall nexum architecture
- `docs/tui-options.md` - TUI implementation plans
- `docs/data-model-proposal.md` - Session data surfaces
- `AGENTS.md` - Agent interaction guidelines
- `TODO.md` - Task tracking

## Feedback Needed

Please review and provide feedback on:
1. Open questions (Part 11)
2. Alternative approaches (Part 12)
3. Flag naming decisions (Part 2)
4. Phase 1 scope (Part 13)
5. Any missing considerations
