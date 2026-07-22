---
source: nexum repo — .archive/ (empirical usage analysis from zsh history)
gathered: 2026-07-21
status: gathered
paths:
  - /Users/josephwecker-v2/src/_core/nexum/docs/.archive/minimal-sapientia-usage-analysis.md
source_commit: c87c75ce20aeaad9290732e17be256601b45a338
categories: [empirical-usage, demand-signal, agent-cli-conventions, session-management, defaults-from-usage]
why_included: >
  Committed 2025-11-07. Rare empirical demand-side signal: 58 real minimal-sapientia invocations mined
  from zsh history (Sept–Oct 2025), showing how the tool was ACTUALLY used vs how it was designed — e.g.
  --tracking present in 98% of runs (→ should be default-on, not opt-in), -p/-i always paired (→ maybe one
  concept), continuation used 26% (→ first-class). This is the "what got used" evidence that theory-heavy
  sources in this section lack; valuable to both consumers as a reminder that observed usage, not designed
  affordance, should set defaults.
---
# Minimal-Sapientia Usage Analysis

**Date:** 2025-01-06
**Source:** zsh history analysis (58 invocations)
**Purpose:** Understand actual usage patterns to inform nexum CLI design

---

## Overview

Analysis of real minimal-sapientia usage from zsh history reveals patterns that differ significantly from designed behavior. This document captures findings and their implications for nexum.

---

## Raw Data Summary

**Total Commands Analyzed:** 58 unique invocations
**Time Period:** ~3 months (Sept-Oct 2025)
**User:** Single user (Joseph)
**Context:** Development and research work

---

## Usage Pattern Categories

### Category 1: System Prompt + Context + Tracking (42 invocations, 72%)

**Pattern:**
```bash
./bin/minimal-sapientia -p [prompt-file] -i [context-file] --tracking
```

**Examples:**
```bash
./bin/minimal-sapientia -p architectus/core-identity.md --tracking -i architectus/core-context.md
./bin/minimal-sapientia -p zi-am-tur/core-identity.md -i zi-am-tur/core-context.md --tracking
./bin/minimal-sapientia -p ../synaptic/entities/.build/zi-am-tur.md -i ./zi-am-tur-context.md --tracking
```

**Key Observations:**
1. `-p` and `-i` always paired (42 of 42 times)
2. `--tracking` present in all but 1 invocation (98%)
3. Paths often relative to current directory
4. Two main personas: `architectus` and `zi-am-tur`

**Implications for Nexum:**
- **Tracking should be default-on** (not opt-in)
- **System prompt + context as single concept?**
  - Alternative 1: Single `--context` flag loads both sections
  - Alternative 2: Convention where single file has both
  - Alternative 3: Keep separate but make pairing easier
- **Relative paths must be supported**

### Category 2: Session Continuation (15 invocations, 26%)

**Pattern:**
```bash
./bin/minimal-sapientia -c conversation_[timestamp].jsonl [other-flags]
```

**Examples:**
```bash
./bin/minimal-sapientia -c conversation_20250922_194034.jsonl --tracking
./bin/minimal-sapientia -i zi-am-tur-context.md -c conversation_20250922_194034.jsonl --no-thinking
./bin/minimal-sapientia -p architectus/core-identity.md --tracking -i architectus/core-context.md -c architectus-20251021.jsonl
```

**Key Observations:**
1. Continuation often combined with same `-p` and `-i` flags
2. Custom naming used (`architectus-20251021.jsonl` vs timestamp format)
3. Sometimes with `--no-thinking` (experimentation)
4. `--tracking` usually included

**Implications for Nexum:**
- **Session continuation is first-class feature**
- **Need both auto-save and custom naming**
- **Should continuation reload original system prompt/context automatically?**
  - Pro: Less typing, consistency
  - Con: Can't easily override
  - Open Question: What if original files moved/changed?

### Category 3: Sampling Experiments (10 invocations, 17%)

**Pattern:**
```bash
./bin/minimal-sapientia -i zi-am-tur-context.md --temperature X --top-p Y --no-thinking
```

**Examples:**
```bash
./bin/minimal-sapientia -i zi-am-tur-context.md --temperature 0.0 --no-thinking
./bin/minimal-sapientia -i zi-am-tur-context.md --top-p 0.7 --no-thinking
./bin/minimal-sapientia -i zi-am-tur-context.md --temperature 0.0 --top-p 0.0 --no-thinking
```

**Key Observations:**
1. Temperature and top-p often tested together
2. `--no-thinking` always present (for consistent comparison)
3. Same context file reused (`zi-am-tur-context.md`)
4. Temperature 0.0 tested (deterministic output)
5. Top-p values: 0.0, 0.3, 0.5, 0.7

**Implications for Nexum:**
- **Sampling controls needed early (Phase 1-2)**
- **Feature toggles matter** (`--no-thinking` useful for experiments)
- **Should support temperature=0.0 explicitly** (deterministic mode)
- **Consider preset sampling profiles?**
  - `--deterministic` → `--temperature 0.0 --top-p 0.0 --no-thinking`
  - `--creative` → `--temperature 1.0 --top-p 0.95`
  - `--balanced` → `--temperature 0.7 --top-p 0.9`

### Category 4: Help and Exploration (2 invocations, 3%)

**Pattern:**
```bash
./bin/minimal-sapientia -h
./bin/minimal-sapientia --tracking --help
```

**Implications:**
- **Help must be comprehensive and discoverable**
- **Help should show current settings** (when flags provided)

---

## Flag Usage Frequency

| Flag | Count | Percentage | Implication |
|------|-------|------------|-------------|
| `--tracking` | 52 | 90% | Should be default-on |
| `-p` (system prompt) | 42 | 72% | Core feature, always paired with `-i` |
| `-i` (initial context) | 42 | 72% | Core feature, always paired with `-p` |
| `-c` (continue) | 15 | 26% | First-class feature |
| `--no-thinking` | 10 | 17% | Important toggle for experiments |
| `--temperature` | 7 | 12% | Needed for sampling control |
| `--top-p` | 7 | 12% | Needed for sampling control |
| `-h` / `--help` | 2 | 3% | Always needed |

---

## Session Naming Patterns

**Auto-Generated (Timestamp Format):**
```
conversation_20250922_194034.jsonl
conversation_20251002_142412.jsonl
conversation_20251004_163612.jsonl
```

**Custom Named:**
```
architectus-20251021.jsonl
architectus-8-oct-2025-continuing.jsonl
zi-am-tur-8-oct-2025-continuing.jsonl
2025-10-01-architectus-ongoing.jsonl
```

**Observations:**
1. Custom names more descriptive
2. Often include persona name (`architectus`, `zi-am-tur`)
3. Sometimes include date in human-readable format
4. "continuing" suffix indicates long-running sessions

**Implications for Nexum:**
- **Support both auto-generated and custom names**
- **Named checkpoints more useful than UUIDs**
- **Consider tag system:** `nexum --save-as "architectus-ongoing"`

---

## Persona Usage Patterns

### Architectus Persona (32 invocations, 55%)

**Identity Files:**
```
architectus/core-identity.md
../sapientia/architectus/core-identity.md
```

**Context Files:**
```
architectus/core-context.md
../sapientia/architectus/core-context.md
```

**Usage:** Architecture and planning work

### Zi-am-tur Persona (20 invocations, 34%)

**Identity Files:**
```
zi-am-tur/core-identity.md
../synaptic/entities/.build/zi-am-tur.md
```

**Context Files:**
```
zi-am-tur/core-context.md
./zi-am-tur-context.md
```

**Usage:** Implementation and technical work

### Implications

1. **Multiple personas are real use case**
2. **Identity + context files form coherent "profile"**
3. **Could nexum have profile system?**
   ```bash
   nexum --profile architectus    # Loads ~/.config/nexum/profiles/architectus.json
   ```
   Profile contains:
   - System prompt path
   - Initial context path
   - Default temperature/top-p
   - Preferred model

---

## Path Patterns

**Relative Paths (Most Common):**
```bash
-p architectus/core-identity.md
-i zi-am-tur-context.md
-c conversation_20250922_194034.jsonl
```

**Parent Directory Paths:**
```bash
-p ../sapientia/architectus/core-identity.md
-p ../synaptic/entities/.build/zi-am-tur.md
```

**Implications:**
- **Must support relative paths (CWD-relative)**
- **Must support parent directory paths (`../`)**
- **Consider supporting ~ expansion** (`~/prompts/default.md`)
- **Consider supporting environment variables** (`$NEXUM_PROMPTS/default.md`)

---

## Anti-Patterns Observed

### 1. Repetitive Flag Combinations

**Problem:** Same flags typed repeatedly
```bash
./bin/minimal-sapientia -p architectus/core-identity.md --tracking -i architectus/core-context.md
# Typed 20+ times
```

**Solution for Nexum:**
- Mode aliases: `nexum-architectus`
- Profiles: `nexum --profile architectus`
- Config files: `.nexum/config.json` in project

### 2. Long Paths

**Problem:** Long paths typed repeatedly
```bash
-p ../sapientia/architectus/core-identity.md
```

**Solution for Nexum:**
- Config search paths
- Environment variables
- Symlinks or shortcuts

### 3. Flag Confusion

**Problem:** Not observed in minimal-sapientia, but seen in codex usage:
```bash
codex -c '~/.codex/config.toml'   # Tried
codex -p ~/.codex/config.toml     # Then tried
```

User confused about which flag means config file.

**Solution for Nexum:**
- Use unambiguous `--config` (not `-c`)
- `-c` should mean `--continue` (more common)
- Document clearly in help

---

## Comparison with Other CLIs (from zsh history)

### Claude Code Usage (44 invocations)

**Dominant Pattern:**
```bash
claude              # Simple, 30+ times
claude -c           # Continue, 10+ times
claude --resume     # Occasional
```

**MCP Management:**
```bash
claude mcp add/list/remove    # Several times
```

**Implication:** Simple invocations win. Complex flags used only when needed.

### Codex Usage (36 invocations)

**Dominant Pattern:**
```bash
codex resume [session-id]     # Most common
codex --full-auto --search    # For testing
```

**Config Override:**
```bash
codex -c '~/.codex/config.toml'    # Attempted
codex -p ~/.codex/config.toml      # Attempted
```

**Implication:** Session resume by ID is primary workflow.

### Gemini Usage (4 invocations)

**Minimal Usage:**
```bash
gemini
gemini --help
gemini mcp add/list
```

**Implication:** Least mature, simplest commands only.

---

## Design Recommendations from Analysis

### High Priority (Based on 70%+ Usage)

1. **Tracking Default-On**
   - Used in 90% of invocations
   - Opt-out via `--no-tracking` instead

2. **System Prompt + Context Pairing**
   - Always used together (100% of time when present)
   - Consider streamlining:
     - Option A: Single file with both sections
     - Option B: Config associates them (profiles)
     - Option C: Keep separate but document pattern

3. **Session Continuation First-Class**
   - Used in 26% of invocations
   - Must be trivial: `nexum --continue`

### Medium Priority (Based on 10-25% Usage)

4. **Sampling Controls**
   - Temperature and top-p used together
   - Need early (Phase 2) not late

5. **Feature Toggles**
   - `--no-thinking` useful for experiments
   - All toggles should have `--no-` variants

6. **Named Checkpoints**
   - Custom names more useful than timestamps
   - Support: `nexum --save-as "descriptive-name"`

### Low Priority (Based on <10% Usage)

7. **Help System**
   - Used rarely but must be comprehensive
   - Consider context-aware help

---

## Open Questions from Usage Analysis

### Question 1: Tracking Default?

**Data:** 90% of invocations include `--tracking`

**Options:**
- A: Default-on, `--no-tracking` to disable
- B: Default-off, `--tracking` to enable
- C: Auto-detect based on mode (on for interactive, off for batch)

**Recommendation:** Option A (default-on) based on overwhelming usage.

**Counter-Argument:** Privacy concerns? Performance overhead?

### Question 2: System Prompt + Context Separation?

**Data:** 100% paired when present (42 of 42 times)

**Options:**
- A: Keep separate flags
- B: Single `--context` flag loads both sections from one file
- C: Profile system associates them
- D: Auto-load from project directory (`NEXUM.md`)

**Recommendation:** Option D with fallback to separate flags.

**Open:** What if user wants system prompt without initial context?

### Question 3: Session Naming?

**Data:** Mix of auto-generated timestamps and custom names

**Options:**
- A: Always auto-generate, support tags later
- B: Prompt for name on start
- C: Auto-generate with option to rename/tag
- D: Named checkpoints within auto-generated sessions

**Recommendation:** Option D (combine both patterns).

### Question 4: Profile System?

**Data:** Two clear personas with consistent prompt/context pairs

**Options:**
- A: No profiles, just config files
- B: Full profile system with CLI (`nexum --profile architectus`)
- C: Project-based profiles only (`.nexum/config.json`)

**Recommendation:** Option C initially, Option B if demand arises.

### Question 5: Flag Naming?

**Data:** Codex usage shows confusion over `-c` meaning

**Options:**
- A: `-c` means `--continue` (more common in minimal-sapientia)
- B: `-c` means `--config` (common Unix convention)
- C: Drop `-c` short flag entirely, force long flags

**Recommendation:** Option C (avoid ambiguity entirely).

**Alternative:** Option A with `--config` long flag only.

---

## Conclusion

### Key Findings

1. **Actual usage differs from designed usage** (tracking 90% vs optional)
2. **Simple patterns dominate** (same flags repeated)
3. **Session continuation important** (26% of usage)
4. **Experimentation needs sampling controls** (17% usage)
5. **Multiple personas are real use case** (2 distinct personas)

### For Nexum Design

**Do:**
- Default tracking on
- Make session continuation trivial
- Support both auto-save and named checkpoints
- Include sampling controls early
- Consider profile/preset system
- Optimize for repeated patterns (mode aliases)

**Don't:**
- Use ambiguous short flags (`-c`)
- Force typing same flags repeatedly
- Hide session management
- Make sampling controls optional/late
- Ignore real usage patterns

### Success Metrics

Nexum will succeed if:
1. Common operations require fewer keystrokes than minimal-sapientia
2. Session management is transparent and flexible
3. Experimentation (sampling) is first-class
4. Profiles/presets reduce repetition
5. Zero ambiguity in flag meanings

---

## Appendices

### Appendix A: Raw Command List

(Full 58 commands - available on request)

### Appendix B: Persona File Analysis

(Analysis of architectus vs zi-am-tur prompt files - available on request)

### Appendix C: Session File Analysis

(Analysis of actual JSONL session files - available on request)

---

## Document Status

- **Draft:** 2025-01-06
- **Data Source:** zsh history (Sept-Oct 2025)
- **Next Review:** After nexum Phase 1 implementation
