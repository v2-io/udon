---
source: nexum repo — .archive/ (deeper Claude/Codex/Gemini comparison)
gathered: 2026-07-21
status: gathered
paths:
  - /Users/josephwecker-v2/src/_core/nexum/docs/.archive/modern-cli-comparison.md
source_commit: c87c75ce20aeaad9290732e17be256601b45a338
categories: [cli-capability-matrix, shipped-practice, session-management, headless-mode]
why_included: >
  Committed 2025-11-07. Deeper Claude Code vs Codex vs Gemini comparison — invocation styles, headless
  mode, session management, and "conventions worth copying." Companion to cli-analysis.md; same
  cross-tier value (surveys shipped harnesses). Useful to the harness consumer as a catalog of what the
  three reference agent CLIs actually do.
---
# Modern AI CLI Comparison

**Date:** 2025-01-06
**Purpose:** Detailed comparison of Claude Code, Codex, and Gemini CLIs

---

## Overview

This document compares three modern AI conversation CLIs to identify patterns, conventions, and innovations that should inform nexum's design.

**Tools Analyzed:**
- **Claude Code** - Anthropic's official CLI
- **Codex** - OpenAI's CLI
- **Gemini CLI** - Google's CLI

---

## Command Structure Comparison

### Basic Invocation

| Tool | Interactive | With Prompt | Headless |
|------|-------------|-------------|----------|
| Claude | `claude` | `claude "prompt"` | `claude -p "prompt"` |
| Codex | `codex` | `codex "prompt"` | `codex exec` |
| Gemini | `gemini` | `gemini "prompt"` | `gemini -p "prompt"` |

**Pattern:** All support similar invocation styles. Claude and Gemini use `-p` for headless, Codex uses separate `exec` command.

**Implication for Nexum:** Follow Claude/Gemini pattern (simpler).

### Session Management

| Tool | Continue Last | Resume by ID | List Sessions |
|------|---------------|--------------|---------------|
| Claude | `--continue` / `-c` | `--resume [id]` | Not exposed |
| Codex | `resume --last` | `resume [id]` | Implicit (shows recent) |
| Gemini | Manual checkpoints | `/resume <tag>` | `/chat list` |

**Patterns:**
- All support resumption (table stakes feature)
- Claude: Auto-save with ID-based resume
- Codex: Auto-save with ID-based resume
- Gemini: Manual named checkpoints

**Innovation:** Gemini's named checkpoints (`/save <tag>`) more user-friendly than UUIDs.

**Implication for Nexum:** Combine both - auto-save (Claude/Codex) + named checkpoints (Gemini).

### MCP Management

| Tool | Command Pattern | Config Location |
|------|-----------------|-----------------|
| Claude | `claude mcp add/list/remove` | `.mcp.json` or `~/.claude.json` |
| Codex | `codex mcp add/list/remove` | `~/.codex/config.toml` |
| Gemini | `gemini mcp add/list` | `~/.config/google-generative-ai/` |

**Pattern:** All use `<tool> mcp <subcommand>` structure (ubiquitous).

**Implication for Nexum:** Follow pattern but defer to Phase 4+.

---

## Flag and Option Comparison

### Output Format Control

| Tool | Format Options | Default |
|------|----------------|---------|
| Claude | `--output-format text\|json\|stream-json` | text (interactive), json (batch) |
| Codex | `--json` (newline-delimited events) | text |
| Gemini | `--output-format json\|stream-json` | text |

**Pattern:** JSON output universally supported for automation.

**Innovation:** Claude's auto-detection (batch mode defaults to JSON).

**Implication for Nexum:** Support all three formats, auto-detect mode.

### Debug and Verbose Modes

| Tool | Debug Flag | Verbose Flag | MCP Debug |
|------|------------|--------------|-----------|
| Claude | `--debug` | `--verbose` | `--mcp-debug` |
| Codex | Implicit in output | Config option | Not separate |
| Gemini | `--debug` | Not separate | Not separate |

**Pattern:** Debug modes common but implementations vary.

**Implication for Nexum:** Support both `--debug` and `--verbose` (stackable: `-vvv`).

### Model Selection

| Tool | Flag | Options |
|------|------|---------|
| Claude | `--model` | `sonnet`, `opus`, custom aliases |
| Codex | `--model` / `-m` | Model names |
| Gemini | Implicit (API choice) | Via API key/endpoint |

**Pattern:** Model selection supported but varies by provider.

**Implication for Nexum:** Support `--model` but keep simple (defer complex selection).

---

## Feature Comparison

### Context Window Management

| Tool | Context Size | Auto-Compression | Manual Compression |
|------|--------------|------------------|---------------------|
| Claude | ~200k tokens | Yes (@95%) | `/compact` |
| Codex | ~200k tokens | Yes (threshold) | Not exposed |
| Gemini | 1M tokens | Yes (threshold) | `/compress` |

**Innovation:** Gemini's 1M context window significantly larger.

**Pattern:** Auto-compression universal, manual trigger optional.

**Implication for Nexum:** Implement auto-compression, expose manual trigger.

### Project Context Files

| Tool | File Name | Auto-Load | Purpose |
|------|-----------|-----------|---------|
| Claude | `CLAUDE.md` | Yes | Project instructions |
| Codex | `AGENTS.md` | Yes | Project context |
| Gemini | `GEMINI.md` / `AGENT.md` | Yes | Rules and context |

**Pattern:** Special markdown files in project root (ubiquitous).

**Implication for Nexum:** Support `NEXUM.md` or `AGENT.md`, auto-load.

### Approval and Safety Systems

| Tool | Approval Modes | Sandbox |
|------|----------------|---------|
| Claude | Permission modes | Permission prompts |
| Codex | Suggest / Auto-Edit / Full-Auto | Seatbelt (macOS), Landlock (Linux) |
| Gemini | Permission prompts | Permission prompts |

**Innovation:** Codex's three-tier approval system and OS-level sandbox.

**Pattern:** All have safety mechanisms, vary in sophistication.

**Implication for Nexum:** Start simple (permission prompts), consider sandbox later.

---

## Unique Features

### Claude Code Unique

1. **Subagents System**
   - Separate context windows per agent
   - Task-specific specialization
   - Automatic delegation
   - **Implication:** Complex, defer unless user demand

2. **Output Styles**
   - System prompt presets
   - Persistent configurations
   - **Implication:** Nice-to-have, low priority

3. **Auto-Compaction at 95%**
   - Clear threshold
   - Automatic trigger
   - **Implication:** Adopt this pattern

4. **Permission-Prompt-Tool**
   - Delegates permission to MCP tool
   - **Implication:** Advanced, defer

### Codex Unique

1. **Sophisticated Sandbox**
   - OS-level enforcement (Seatbelt/Landlock)
   - Granular policies (read-only, workspace-write, full-access)
   - Testing utilities
   - **Implication:** Excellent security model but complex, defer

2. **Three-Tier Approval**
   - Clear progression: Suggest → Auto-Edit → Full-Auto
   - **Implication:** Better than binary on/off, consider for Phase 2

3. **Codex Cloud**
   - Remote execution
   - **Implication:** Not applicable to nexum

4. **JSONL Session Storage**
   - Session fork operations
   - Detailed replay
   - **Implication:** We already do JSONL, good validation

5. **Full-Auto Preset**
   - `--full-auto` combines multiple settings
   - **Implication:** Definitely adopt this pattern

### Gemini Unique

1. **Three Command Prefixes**
   - `/` for meta commands
   - `@` for file inclusion
   - `!` for shell integration
   - **Implication:** Excellent organization, consider adopting

2. **Manual Checkpoint Tagging**
   - User-defined tags
   - More intuitive than UUIDs
   - **Implication:** Adopt as complement to auto-save

3. **1M Token Context**
   - 5x larger than competitors
   - **Implication:** Not under our control (API feature)

4. **Automatic Token Caching**
   - Transparent cost optimization
   - **Implication:** API feature, not CLI concern

5. **Completely Free Tier**
   - 1,000 req/day
   - **Implication:** Not applicable (we're client, not provider)

6. **Open Source**
   - Apache 2.0 license
   - Community contributions
   - **Implication:** Consider for nexum eventually

---

## Ubiquitous Patterns (All Three Tools)

These features appear in ALL three tools - they're table stakes:

1. ✅ **Dual Operation Modes**
   - Interactive REPL
   - Headless/scriptable mode

2. ✅ **Session Persistence**
   - Auto-save all sessions
   - Resume by ID or last

3. ✅ **JSON Output**
   - For automation and CI/CD
   - Machine-parseable

4. ✅ **MCP Integration**
   - Standard protocol
   - Add/list/remove commands

5. ✅ **Project Context Files**
   - Markdown in project root
   - Auto-loaded

6. ✅ **Debug/Verbose Modes**
   - For troubleshooting
   - Different levels of detail

7. ✅ **Model Selection**
   - Override default model
   - Support multiple tiers

8. ✅ **Configuration Files**
   - User-level and project-level
   - JSON or TOML

9. ✅ **Multiple Auth Methods**
   - API keys
   - OAuth (some)

10. ✅ **Safety Mechanisms**
    - Permission prompts
    - Approval modes

**Implication:** These are minimum requirements, not optional.

---

## Pattern Analysis

### Naming Conventions

| Pattern | Tools Using | Example |
|---------|-------------|---------|
| `--flag=value` | All three | `--format=json` |
| `--flag value` | All three | `--model sonnet` |
| `-f` (short flags) | Claude, Codex | `-c`, `-m`, `-p` |
| Subcommands | All three | `tool mcp add` |

**Implication:** Follow standard Unix conventions (short + long flags).

### Configuration Precedence

All three follow similar precedence (highest to lowest):
1. Command-line flags
2. Environment variables
3. Project config
4. User config
5. Defaults

**Implication:** Standard pattern, adopt exactly.

### Session Storage

| Tool | Location | Format |
|------|----------|--------|
| Claude | `~/.claude/` | JSONL |
| Codex | `~/.codex/sessions/` | JSONL |
| Gemini | `~/.config/google-generative-ai/checkpoints/` | JSONL |

**Pattern:** JSONL universal, location varies.

**Implication:** Use XDG paths (`~/.local/share/nexum/sessions/`).

---

## Design Lessons

### What Works Well

1. **Simple invocations dominate** - `claude`, `codex`, `gemini` most common
2. **Presets reduce cognitive load** - `--full-auto` better than multiple flags
3. **Named checkpoints** - More intuitive than UUIDs (Gemini innovation)
4. **Auto-detection** - Mode, format, color based on environment
5. **Subcommands for management** - `tool mcp` pattern scales well
6. **Project context files** - Team-shareable, version-controlled

### What Doesn't Work Well

1. **Inconsistent flag meanings** - `-c` means different things (continue vs config)
2. **Hidden session storage** - Hard to find/manage sessions
3. **UUID-based session IDs** - Hard to remember/reference
4. **Complex permission systems** - Confusing for new users
5. **Too many modes** - Users don't know which to choose

### Innovations Worth Adopting

1. **Gemini's command prefixes** - `/`, `@`, `!` for different purposes
2. **Codex's approval tiers** - Clear progression of automation
3. **Gemini's named checkpoints** - More user-friendly than IDs
4. **Claude's auto-compaction** - Transparent context management
5. **Codex's full-auto preset** - Single flag for common scenario

### Anti-Patterns to Avoid

1. **Magic behavior** - Auto-detection without user control
2. **Inconsistent flag names** - `-c` meaning different things
3. **Hidden defaults** - Users can't discover settings
4. **Too many binaries** - Confusion over which to use
5. **Opaque session IDs** - Can't remember or reference easily

---

## Recommendations for Nexum

### Must Implement (From Ubiquitous Patterns)

1. Dual modes (interactive + headless)
2. Session auto-save and resume
3. JSON output format
4. Debug and verbose flags
5. Project context file (`NEXUM.md`)
6. Configuration hierarchy
7. MCP integration (Phase 4+)

### Should Implement (Proven Innovations)

1. Named checkpoints (Gemini)
2. Command prefixes (Gemini: `/`, `@`)
3. Approval tiers (Codex: Suggest/Auto/Full)
4. Auto-compaction (Claude: @95%)
5. Full-auto preset (Codex)
6. Mode aliases (testing ergonomics)

### Could Implement (Nice-to-Have)

1. Subagents system (Claude) - Complex, low priority
2. Sandbox system (Codex) - Complex, use containers instead
3. Shell integration (Gemini: `!`) - Bash tool sufficient
4. Output styles (Claude) - Low priority

### Should Not Implement

1. Cloud execution (Codex Cloud) - Not applicable
2. Token caching (Gemini) - API feature, not CLI
3. Custom models (complex) - Keep simple

---

## Comparison Tables

### Feature Matrix

| Feature | Claude | Codex | Gemini | Nexum Plan |
|---------|--------|-------|--------|------------|
| Interactive REPL | ✅ | ✅ | ✅ | ✅ Phase 1 |
| Headless mode | ✅ | ✅ | ✅ | ✅ Phase 1 |
| JSON output | ✅ | ✅ | ✅ | ✅ Phase 1 |
| Stream JSON | ✅ | ✅ | ✅ | ✅ Phase 1 |
| Session auto-save | ✅ | ✅ | ❌ | ✅ Phase 1 |
| Resume by ID | ✅ | ✅ | ❌ | ✅ Phase 1 |
| Named checkpoints | ❌ | ❌ | ✅ | ✅ Phase 2 |
| Project context file | ✅ | ✅ | ✅ | ✅ Phase 2 |
| MCP integration | ✅ | ✅ | ✅ | ⏳ Phase 4 |
| Debug mode | ✅ | ✅ | ✅ | ✅ Phase 1 |
| Auto-compression | ✅ | ✅ | ✅ | ⏳ Phase 3 |
| Approval modes | ✅ | ✅ | ✅ | ⏳ Phase 2 |
| Sandbox | ❌ | ✅ | ❌ | ❌ Defer |
| Subagents | ✅ | ❌ | ❌ | ❌ Defer |
| Cloud execution | ❌ | ✅ | ❌ | ❌ N/A |
| Command prefixes | ❌ | ❌ | ✅ | ⏳ Phase 3 |

### Maturity Assessment

| Aspect | Claude | Codex | Gemini |
|--------|--------|-------|--------|
| Documentation | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| User Experience | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| Features | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| Stability | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ |
| Innovation | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Open Source | ❌ | ✅ | ✅ |

---

## Conclusion

### Key Takeaways

1. **Patterns are converging** - All three tools share core features
2. **Innovation still happening** - Each has unique valuable features
3. **Testing is critical** - Mode aliases and JSON output enable automation
4. **Session management varies** - Named checkpoints > UUIDs for UX
5. **MCP is standard** - But can be deferred to Phase 4

### For Nexum

**Adopt:**
- Dual modes, JSON output, auto-save, resume (ubiquitous)
- Named checkpoints (Gemini innovation)
- Mode aliases for testing (ergonomics)
- Command prefixes (Gemini organization)
- Full-auto preset (Codex simplification)

**Defer:**
- MCP (until core stable)
- Subagents (complex, low demand)
- Sandbox (use containers)

**Avoid:**
- Inconsistent flag meanings
- Magic behavior without control
- Hidden session storage

### Success Criteria

Nexum will succeed if it:
1. Makes testing trivial (one-liner CI)
2. Combines best innovations from all three
3. Avoids their anti-patterns
4. Remains simple for common cases
5. Extensible for advanced cases

---

## Appendices

### Appendix A: Full Command Reference

(Detailed command syntax for each tool - omitted for brevity)

### Appendix B: Configuration File Examples

(Example configs from each tool - omitted for brevity)

### Appendix C: Usage Examples

(Real-world usage patterns - omitted for brevity)

---

## Document Status

- **Draft:** 2025-01-06
- **Review:** Pending
- **Updates:** Ongoing as tools evolve
