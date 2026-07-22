---
source: nexum repo — .archive/ (consolidated open CLI-design decisions)
gathered: 2026-07-21
status: gathered
paths:
  - /Users/josephwecker-v2/src/_core/nexum/docs/.archive/cli-open-questions.md
source_commit: c87c75ce20aeaad9290732e17be256601b45a338
categories: [agent-cli-conventions, open-questions, flag-naming, contested-decisions]
why_included: >
  Committed 2025-11-07. The open CLI-design decisions (flag naming, mode detection, session model)
  prioritized CRITICAL/HIGH/MEDIUM. Included because it records which conventions were CONTESTED vs
  settled — the disagreement is itself signal (e.g. clean-break vs gradual-deprecation of ambiguous
  short flags). Useful to synthesizers as a map of where the ideology was still unresolved in Nov 2025.
---
# CLI Design: Open Questions and Decisions Needed

**Date:** 2025-01-06
**Status:** Awaiting Decisions
**Purpose:** Centralize all open questions requiring decisions before implementation

---

## Overview

This document consolidates all open questions identified during CLI design research. Questions are prioritized by when decisions are needed.

**Priority Levels:**
- **CRITICAL** - Must decide before Phase 1 implementation
- **HIGH** - Should decide before Phase 2
- **MEDIUM** - Can decide during Phase 2-3
- **LOW** - Can defer to Phase 3+

---

## CRITICAL Priority (Decide Before Phase 1)

### Q1: Flag Naming - Break from minimal-sapientia?

**Context:** minimal-sapientia uses `-p`, `-i`, `-c`. These are ambiguous.

**Options:**

**A: Clean Break**
- Remove all short flags: `-p`, `-i`, `-c`
- Force long flags: `--system-prompt`, `--initial-context`, `--continue`
- **Pros:** Clear, unambiguous, modern
- **Cons:** More typing, breaks muscle memory, friction for existing users
- **Migration:** Provide compatibility wrapper for 6 months

**B: Gradual Deprecation**
- Keep short flags with deprecation warnings
- "Warning: `-p` is deprecated, use `--system-prompt` instead"
- Remove in version 2.0
- **Pros:** Smooth transition, less friction
- **Cons:** More code, warnings clutter output, maintains ambiguity longer

**C: Hybrid Approach**
- Keep `-c` for `--continue` (most common, 26% usage)
- Remove `-p` and `-i` (force long flags)
- **Pros:** Balances brevity and clarity
- **Cons:** Inconsistent philosophy (some short, some long)

**D: Keep All**
- Maintain backward compatibility indefinitely
- **Pros:** Zero friction
- **Cons:** Maintains ambiguity, `-c` conflict with config

**Data Points:**
- minimal-sapientia usage: `-p` (72%), `-i` (72%), `-c` (26%)
- Codex confusion: User tried both `-c` and `-p` for config
- Modern CLIs: Claude uses `-c` for continue, Codex uses subcommands

**Recommendation:** Option A (clean break) with compatibility shim (Option B) for 6 months.

**Decision Needed By:** Before starting Phase 1 (argument parser)

**Impact:**
- Argument parser design
- Help text
- Documentation
- Migration guide
- User communication

---

### Q2: Tracking - Default On or Off?

**Context:** 90% of minimal-sapientia usage includes `--tracking`.

**Options:**

**A: Default On**
- Tracking enabled by default
- Use `--no-tracking` to disable
- **Pros:** Matches actual usage (90%), less typing
- **Cons:** Privacy concerns?, performance overhead?

**B: Default Off**
- Tracking disabled by default (original design)
- Use `--tracking` to enable
- **Pros:** User explicitly opts in, privacy-first
- **Cons:** Contradicts usage data, more typing for common case

**C: Auto-Detect**
- On for interactive mode
- Off for batch/agent mode
- **Pros:** Best of both worlds
- **Cons:** Magic behavior, hard to predict

**Data Points:**
- 90% usage rate (52 of 58 invocations)
- Only 2 invocations without tracking (both help requests)

**Recommendation:** Option A (default on)

**Counter-Arguments:**
- "But tracking has overhead" → Measure it first
- "But privacy" → What privacy concerns? User controls data
- "But original design" → Usage data trumps original intent

**Decision Needed By:** Before Phase 1 (default behavior)

**Impact:**
- Default configuration
- Help text
- Documentation
- Performance considerations

---

### Q3: `-c` Flag Meaning - Continue or Config?

**Context:** `-c` is ambiguous.
- minimal-sapientia: `-c` = continue (26% usage)
- Codex: `-c` = config override
- Unix convention: `-c` often means "command" or "config"

**Options:**

**A: `-c` means `--continue`**
- Preserves minimal-sapientia usage
- Most common operation in real usage
- **Pros:** Matches usage pattern, less breaking change
- **Cons:** Conflicts with Unix `-c` convention for config

**B: `-c` means `--config`**
- Follows Unix convention
- Matches user expectation from other tools
- **Pros:** Standard convention, predictable
- **Cons:** Breaking change from minimal-sapientia

**C: No `-c` short flag**
- Force `--continue` and `--config` (long forms only)
- **Pros:** Eliminates ambiguity entirely
- **Cons:** More typing

**Recommendation:** Option C (drop `-c` entirely)

**Rationale:**
- Avoids ambiguity
- Forces clarity
- Modern CLIs use longer flags anyway
- Continue is important but not 90% usage (only 26%)

**Decision Needed By:** Before Phase 1 (argument parser)

**Impact:**
- Argument parser
- Backward compatibility
- User documentation

---

### Q4: System Prompt + Initial Context - Keep Separate or Merge?

**Context:** Always used together (100% of time when present, 42 of 42 invocations).

**Options:**

**A: Keep Separate Flags**
```bash
nexum --system-prompt identity.md --initial-context context.md
```
- **Pros:** Explicit, flexible, architecturally distinct
- **Cons:** Verbose, always typed together

**B: Single Combined Flag**
```bash
nexum --context combined.md
```
File contains both sections (with markers or convention).
- **Pros:** Less typing, acknowledges pairing
- **Cons:** Less flexible, requires file format convention

**C: Auto-Load from Project**
```bash
nexum  # Auto-loads NEXUM.md from project root
```
- **Pros:** Zero typing, convention-based
- **Cons:** Magic behavior, hard to override

**D: Profile System**
```bash
nexum --profile architectus
```
Profile associates prompt + context + settings.
- **Pros:** Powerful, reusable, handles the pairing
- **Cons:** Extra complexity, indirection

**E: Keep Separate + Auto-Load**
```bash
# Auto-load NEXUM.md if present
nexum

# Or override
nexum --system-prompt other.md --initial-context other-context.md
```
- **Pros:** Convention + flexibility
- **Cons:** Multiple ways to do same thing

**Data Points:**
- 100% pairing rate
- Two distinct personas (architectus, zi-am-tur)
- Files often in subdirectories (architectus/, zi-am-tur/)

**Recommendation:** Option E (keep separate + auto-load)

**Rationale:**
- Preserves architectural distinction
- Auto-load handles common case (zero typing)
- Overrides available when needed
- Enables profile system later (Phase 3)

**Decision Needed By:** Before Phase 1 (basic functionality)

**Impact:**
- Argument parser
- File loading logic
- Project conventions
- Documentation

**Follow-up Questions:**
- What's the file format for combined context?
- What's the search path for auto-load? (`.`, `.nexum/`, `.nexum.md`?)
- Should auto-load be default or opt-in?

---

### Q5: Exit Code Range - sysexits Only or Custom Range?

**Context:** Need codes for nexum-specific errors (session not found, auth failed, etc.)

**Options:**

**A: sysexits.h Only**
- Use standard codes: 0-2, 64-78
- Map nexum errors to closest match:
  - Session not found → 66 (EX_NOINPUT)
  - Auth failed → 69 (EX_UNAVAILABLE)
  - Context overflow → 69 (EX_UNAVAILABLE)
- **Pros:** Standard, widely understood
- **Cons:** Limited, imprecise mapping

**B: Reserve 80-99 Range**
- Standard codes for standard errors
- 80-99 for nexum-specific:
  - 80: Session not found
  - 81: Auth failed
  - 82: Context overflow
  - etc.
- **Pros:** Precise, extensible
- **Cons:** Non-standard, requires documentation

**C: Hybrid**
- Use sysexits where reasonable
- Custom codes only when no good match
- **Pros:** Balanced approach
- **Cons:** Requires judgment calls

**Recommendation:** Option B (reserve 80-99)

**Rationale:**
- Precision matters for scripting
- 80-99 range unlikely to conflict
- Can still use sysexits for appropriate errors
- Document clearly in help and docs

**Decision Needed By:** Before Phase 1 (error handling)

**Impact:**
- Error handling code
- Documentation
- Test suite
- User scripts

---

## HIGH Priority (Decide Before Phase 2)

### Q6: Configuration Format - JSON, TOML, YAML, or All?

**Context:** Need config file format.

**Options:**

**A: JSON Only**
- Single format, built-in Ruby support
- **Pros:** Simple, no extra deps, standard
- **Cons:** Less human-friendly (no comments, strict syntax)

**B: TOML Only**
- Human-friendly, Codex uses it
- **Pros:** Comments, relaxed syntax, modern
- **Cons:** Requires gem, less common in Ruby world

**C: YAML Only**
- Very human-friendly, widely used
- **Pros:** Comments, flexible, familiar
- **Cons:** Too flexible (indentation issues), security concerns

**D: Support All**
- Detect by extension (.json, .toml, .yaml)
- **Pros:** Maximum flexibility
- **Cons:** More code, testing, maintenance

**Data Points:**
- Claude: JSON
- Codex: TOML
- Gemini: JSON
- Ruby ecosystem: JSON and YAML common

**Recommendation:** Option A (JSON) for Phase 1-2, consider TOML later

**Rationale:**
- Simplest to implement
- Built-in support
- Good enough for MVP
- Can add TOML in Phase 3 if demand

**Decision Needed By:** Before Phase 2 (config support)

**Impact:**
- Config parsing code
- Documentation
- Example configs
- Test fixtures

---

### Q7: Checkpoint Storage - Per-Session or Global?

**Context:** Named checkpoints need storage strategy.

**Options:**

**A: Per-Session Namespace**
```
sessions/conversation_20251107_150000/
  ├── conversation.jsonl
  └── checkpoints/
      ├── before-refactor.jsonl
      └── working-state.jsonl
```
- **Pros:** Organized, clear association, no conflicts
- **Cons:** Requires session context to use, longer paths

**B: Global Namespace**
```
checkpoints/
  ├── before-refactor.jsonl        # From session X
  └── working-state.jsonl          # From session Y
```
- **Pros:** Simple, flat, easy to reference
- **Cons:** Name collisions, unclear which session

**C: Hybrid**
```
checkpoints/
  └── before-refactor/
      ├── metadata.json              # Which session
      └── checkpoint.jsonl
```
- **Pros:** Global tags with context
- **Cons:** Extra complexity

**Recommendation:** Option A (per-session)

**Rationale:**
- Checkpoints are session-specific by nature
- No name collisions
- Clear organization
- Can still have short reference: `--checkpoint before-refactor` (searches current session)

**Decision Needed By:** Before Phase 2 (checkpoint implementation)

**Impact:**
- File organization
- Checkpoint CLI
- Resume logic
- Documentation

---

### Q8: Agent Mode - Suppress All stderr or Just Progress?

**Context:** In agent mode (non-TTY, CI, --format=json), what goes to stderr?

**Options:**

**A: Suppress All**
- Nothing to stderr in agent mode
- Absolute clean output
- **Pros:** Cleanest, most predictable
- **Cons:** No error visibility at all

**B: Suppress Progress Only**
- Errors still to stderr
- Progress/status suppressed
- **Pros:** Errors still visible, cleaner than nothing
- **Cons:** May contaminate output if streams merged

**C: Structured Output for All**
- Everything as JSON events (if --format=json)
```json
{"type":"status","message":"Starting..."}
{"type":"data","content":{...}}
{"type":"error","message":"Failed"}
```
- **Pros:** Complete information, structured
- **Cons:** More complex, requires parsing

**D: Verbose Flag Overrides**
- Default: Suppress progress, keep errors
- `--verbose`: Show everything
- `--quiet`: Suppress everything
- **Pros:** User control
- **Cons:** More flags, more complexity

**Recommendation:** Option B (suppress progress, keep errors)

**Rationale:**
- Errors to stderr is Unix convention
- Progress indicators are noise in automation
- User can always redirect: `2>/dev/null`
- Verbose flag available for debugging

**Decision Needed By:** Before Phase 2 (output handling)

**Impact:**
- Output class
- Mode detection
- Testing
- Documentation

---

### Q9: Mode Aliases - Auto-Install or Manual?

**Context:** Mode aliases (nexum-test, nexum-debug) need installation.

**Options:**

**A: Auto-Install on First Run**
```bash
# First run
$ nexum
Creating mode aliases: nexum-test, nexum-debug...
```
- **Pros:** Convenient, automatic
- **Cons:** Requires write permission, surprising behavior

**B: Explicit Install Command**
```bash
$ nexum install-aliases
Installing mode aliases to /usr/local/bin...
```
- **Pros:** Explicit, user control
- **Cons:** Extra step, may forget

**C: Bundled in Installation**
```bash
$ gem install nexum
# Automatically installs all aliases
```
- **Pros:** Seamless, expected
- **Cons:** Requires packaging support

**D: Manual Symlinks**
```bash
$ ln -s $(which nexum) /usr/local/bin/nexum-test
```
- **Pros:** User control, no magic
- **Cons:** Manual, not discoverable

**E: Shell Functions**
```bash
# Add to ~/.bashrc or ~/.zshrc
nexum-test() { nexum --format=json --no-color --batch "$@"; }
```
- **Pros:** No installation needed, user config
- **Cons:** Not persistent across shells, manual setup

**Recommendation:** Option B (explicit install) + Option E (document shell functions)

**Rationale:**
- Explicit is better than implicit
- Shell functions work everywhere (no permissions needed)
- Install command for convenience
- Document both approaches

**Decision Needed By:** Before Phase 2 (mode aliases)

**Impact:**
- Installation process
- Documentation
- User experience

---

## MEDIUM Priority (Phase 2-3)

### Q10: Profile System - Implement or Defer?

**Context:** Usage shows two distinct personas with consistent prompt/context/settings.

**Options:**

**A: Full Profile System**
```bash
nexum --profile architectus
```
~/.config/nexum/profiles/architectus.json:
```json
{
  "system_prompt": "~/prompts/architectus-identity.md",
  "initial_context": "~/prompts/architectus-context.md",
  "temperature": 0.7,
  "tracking": true
}
```
- **Pros:** Powerful, reduces repetition
- **Cons:** Complexity, indirection

**B: Project-Only Profiles**
```bash
# In project directory with .nexum/config.json
nexum  # Auto-loads project config
```
- **Pros:** Simpler, team-shareable
- **Cons:** Less flexible

**C: No Profiles**
- Just use config files and flags
- **Pros:** Simplest
- **Cons:** More typing, repetition

**Recommendation:** Option B for Phase 2, Option A for Phase 3 if demand

**Decision Needed By:** Phase 2-3

---

### Q11: Sampling Presets - Useful or Overkill?

**Context:** Common sampling combinations could be presets.

**Presets:**
```bash
nexum --deterministic    # temp=0.0, top-p=0.0, no-thinking
nexum --creative         # temp=1.0, top-p=0.95
nexum --balanced         # temp=0.7, top-p=0.9
```

**Alternative:** Users specify explicitly
```bash
nexum --temperature 0.0 --top-p 0.0 --no-thinking
```

**Question:** Are presets helpful or just more to remember?

**Decision Needed By:** Phase 2-3

---

### Q12: File Inclusion Syntax - `@` or Something Else?

**Context:** Gemini uses `@path/to/file` for file inclusion.

**Options:**
- A: `@path/to/file` (Gemini-style)
- B: `#include path/to/file` (C-style)
- C: `<<path/to/file` (heredoc-style)
- D: No special syntax, just flag: `--include path/to/file`

**Considerations:**
- `@` can conflict with mentions
- `#` looks like comments
- `<<` looks like heredoc
- Flag is most explicit

**Decision Needed By:** Phase 3

---

### Q13: Shell Integration - Support `!` or Defer?

**Context:** Gemini supports `!command` for shell execution.

**Options:**
- A: Support `!` prefix (Gemini-style)
- B: Use bash tool only (existing)
- C: Both

**Considerations:**
- We already have bash tool
- `!` is shorthand for common case
- May conflict with history expansion in some shells

**Decision Needed By:** Phase 3 or defer

---

## LOW Priority (Phase 3+)

### Q14: MCP Configuration - User, Project, or Both?

**Context:** MCP servers can be user-wide or project-specific.

**Options:**
- A: User-only (`~/.config/nexum/mcp.json`)
- B: Project-only (`.nexum/mcp.json`)
- C: Both (project overrides user)

**Recommendation:** Option C (standard pattern)

**Decision Needed By:** Phase 4 (MCP implementation)

---

### Q15: Export Formats - Which to Support?

**Context:** Users may want to export conversations.

**Options:**
- Markdown (easy, readable)
- PDF (professional)
- HTML (web-friendly)
- LaTeX (academic)
- Org-mode (Emacs users)

**Question:** Which formats are worth supporting?

**Decision Needed By:** Phase 3+

---

### Q16: Auto-Compression Threshold - What Percentage?

**Context:** Claude uses 95%, others vary.

**Options:**
- A: 95% (Claude's choice)
- B: 90% (more conservative)
- C: Configurable
- D: Multiple warnings (80%, 90%, 95%)

**Recommendation:** Option A (95%) with configurable override

**Decision Needed By:** Phase 3

---

### Q17: Context Window Size - Should nexum know about it?

**Context:** Different models have different context windows.

**Options:**
- A: Hardcode (1M for Sonnet 4.5)
- B: Auto-detect from model
- C: User configurable
- D: Query API for limits

**Recommendation:** Option C with reasonable defaults

**Decision Needed By:** Phase 3

---

## Decision Process

### How to Decide

For each question:

1. **Review Options** - Read alternatives and tradeoffs
2. **Check Data** - Usage patterns, modern CLI comparison
3. **Consider Principles** - Simplicity, testing, user experience
4. **Prototype if Unclear** - Spike the approaches
5. **Document Decision** - ADR (Architectural Decision Record)
6. **Implement and Validate** - TDD approach

### Decision Template

```markdown
# ADR: [Question Number] - [Topic]

**Date:** YYYY-MM-DD
**Status:** Decided
**Decision Maker:** [Name]

## Context

[Background and why decision needed]

## Decision

[Chosen option]

## Rationale

[Why this option over others]

## Consequences

[Positive and negative outcomes]

## Alternatives Considered

[Brief summary of rejected options]
```

---

## Priority Summary

### Before Phase 1 (CRITICAL)

- Q1: Flag naming (clean break or compat?)
- Q2: Tracking default (on or off?)
- Q3: `-c` meaning (continue, config, or drop?)
- Q4: System prompt + context (separate or merge?)
- Q5: Exit codes (sysexits only or custom range?)

### Before Phase 2 (HIGH)

- Q6: Config format (JSON, TOML, or both?)
- Q7: Checkpoint storage (per-session or global?)
- Q8: Agent mode stderr (suppress all or just progress?)
- Q9: Mode aliases (auto-install or manual?)

### Phase 2-3 (MEDIUM)

- Q10: Profile system (implement or defer?)
- Q11: Sampling presets (useful or overkill?)
- Q12: File inclusion syntax (`@` or other?)
- Q13: Shell integration (`!` or defer?)

### Phase 3+ (LOW)

- Q14: MCP config (user, project, or both?)
- Q15: Export formats (which ones?)
- Q16: Auto-compression threshold (percentage?)
- Q17: Context window (how to determine?)

---

## Next Steps

1. **Review Questions** - Team discussion of options
2. **Make Critical Decisions** - Q1-Q5 before Phase 1 starts
3. **Document Decisions** - Create ADRs
4. **Update Design Docs** - Reflect decisions in cli-design-recommendation.md
5. **Begin Implementation** - With clear direction

---

## Document Status

- **Draft:** 2025-01-06
- **Review:** Pending
- **Decisions:** 0 of 17 made
- **Next Review:** Before Phase 1 implementation
