---
source: sapientia ai-conversation-system-requirements.md (Joseph, 2025-10-10) — full-body deep read this pass (STEWARD-CALLS #8); the harness-critical §4/§6/§7 requirements excerpted verbatim
gathered: 2026-07-21
status: gathered (verbatim requirement spans; the deep-read that supersedes the head-read summary in characterizations/II1-sapientia-architecture-and-guides.md §ai-conversation-system-requirements)
paths:
  - ~/src/_core/sapientia/ai-conversation-system-requirements.md:256-299
  - ~/src/_core/sapientia/ai-conversation-system-requirements.md:513-576
  - ~/src/_core/sapientia/ai-conversation-system-requirements.md:659-759
  - ~/src/_core/sapientia/ai-conversation-system-requirements.md:836-874
  - ~/src/_core/sapientia/ai-conversation-system-requirements.md:1146-1161
source_commit: 1ecc9f77e4884906dec1d2c1032f2a51ff3ee5e4
categories: [harness-facing, tool-execution, state-machine, never-corrupt-state, audit-first, rollback, recovery, edit-tool-contract, failure-mode-matrix, tier1-ideology]
why_included: >
  THIS IS PRIMARILY FOR THE HARNESS CONSUMER. Seven months before the harness
  programme, this spec wrote down the invariants a trustworthy agent loop must
  guarantee about its OWN state when a tool-call round is interrupted. The
  load-bearing content the harness needs is the concrete recovery state machine:
  the broken-state taxonomy (REQ-18: three ways a tool round dies), the blocking
  state machine that refuses new input until healed (REQ-19), the per-failure-type
  resume/rollback/repair procedures (REQ-23/24/25), the multi-match str_replace
  safety contract (REQ-28 — a Tier-1 -> Tier-2 convergence with shipped edit tools;
  cf. sapientia REQ-28 dated 2025-10 in II8-harness-refs), and the failure-mode
  matrix (auto-retry vs manual-recovery vs data-loss-risk per mode). The prior
  characterization head-read this doc's TOC + a §7 grep; this is the verbatim
  state machine, the part a harness engineer actually reimplements.
---

# Conversation-system tool-execution state machine — the recovery contract (verbatim)

> **Read for:** the harness consumer, first. The question this artifact witnesses
> is *"what must an agent loop guarantee about its own state so a crashed or
> orphaned tool-call round never corrupts the conversation, and every failure has
> a defined recovery path?"* Below are the verbatim requirement spans; the full
> 40-requirement spec (context tracking, caching economics, extended thinking,
> UI) is at the pinned source. The five prime design principles it opens with:
> **(1) Never corrupt conversation state — fail gracefully, block dangerous
> actions; (2) Always recoverable — every failure has a defined recovery path;
> (3) Transparent operations; (4) Context-aware; (5) Audit-first — complete
> record of all API interactions.**

## REQ-9: Complete Audit Trail (the substrate recovery rests on) — verbatim

> **Requirement:** The system MUST maintain a complete, immutable audit trail of all API interactions.
>
> **Audit Components:**
>
> #### Request Logging
> - Full API request body (system prompt, messages, tools, parameters)
> - Headers and API version
> - Timestamp (preparation start time)
> - Request size in bytes
>
> #### Response Logging
> - Full API response body
> - Response size in bytes
> - Response timestamp
> - HTTP status code
>
> #### Telemetry Tracking
> - **Timing breakdown:** Preparation duration (request building), Connection time (TCP handshake), Request send time (upload), Response receive time (download), Total duration
> - **Size metrics:** Request size, Response size
> - **Audit trail management:** Git commit for each request, Git commit for each response, Commit messages include timing info
>
> **Storage:** Structured format (JSON); Version controlled (git); Separate directory per conversation; Sequential numbering (turn-001, turn-002, etc.)
>
> **Rationale:** Debugging — Exactly what was sent/received at any point; Provenance — Immutable record with git timestamps; Analysis — Performance metrics, token usage patterns; **Recovery — Reconstruct conversation state from the audit trail.**

## REQ-18: Incomplete Conversation State Detection — the broken-state taxonomy (verbatim)

> **Requirement:** The system MUST detect incomplete conversation states on startup or after failures.
>
> **Incomplete States:**
>
> #### State A: Tool Use Pending
> - **Detection:** Last message is from AI, contains tool use requests, no following user message
> - **Cause:** Tools were requested but never executed (crash, ctrl-c, etc.)
> - **Symptom:** Conversation ends mid-workflow
> - **Recovery:** Execute pending tools OR rollback to retry user message
>
> #### State B: User Message Orphaned
> - **Detection:** Last message is from user (plain text), no assistant response
> - **Cause:** API timeout, connection loss, crash after sending
> - **Symptom:** User's message has no response
> - **Recovery:** Resend user message
>
> #### State C: Tool Results Orphaned
> - **Detection:** Last message is from user (tool results), no assistant response
> - **Cause:** Tools executed, but no final AI response
> - **Symptom:** Tool execution completed but conversation incomplete
> - **Recovery:** Send tool results to get AI response

## REQ-19: Blocking State Machine — verbatim

> **Requirement:** The system MUST block new user messages when conversation is in incomplete state.
>
> **Behavior:**
> 1. Detect incomplete state on startup or after failure
> 2. Set blocking flag with failure type
> 3. Display clear guidance for recovery
> 4. REJECT all new user input (except recovery commands)
> 5. Clear blocking flag only after successful recovery
>
> **Rationale:** Prevents "talking past" an error and corrupting conversation history. Forces explicit recovery decision.

## REQ-23: Resume Command — recovery procedure by failure type (verbatim)

> **Requirement:** The system MUST provide a resume command to recover from failures.
>
> #### Resume from Tool Results Orphaned
> 1. Remove tool results temporarily (to rebuild tracking snapshot)
> 2. Add back tool results
> 3. Make API call to get AI response
> 4. Update conversation with response
>
> #### Resume from User Message Orphaned
> 1. Rebuild tracking snapshot with current context
> 2. Resend user message (with updated snapshot)
> 3. Wait for AI response
> 4. Update conversation
>
> #### Resume from Tool Use Pending
> 1. Extract all tool use blocks from last AI message
> 2. Execute each tool
> 3. Truncate large tool results (> 500KB) to prevent API timeout
> 4. Add tool results as user message
> 5. Make API call to get AI response
>
> **Common Behavior:** Show "Resuming conversation..." message; Clear failure state on success; Re-set failure state if resume fails; Update tracking snapshots after successful resume.

## REQ-24: Rollback Command — verbatim

> **Requirement:** The system MUST provide a rollback command to undo failed tool requests.
>
> **Rollback Behavior:**
> 1. Verify failure state is "tool use pending"
> 2. Remove last AI message (the one with tool use)
> 3. Display original user message that will be resent
> 4. Set failure state to "user message orphaned"
> 5. User runs /resume to retry

## REQ-25: Conversation Repair — integrity fixes (verbatim, condensed to the operations)

> **Requirement:** The system MUST provide a repair command to fix conversation integrity issues.
>
> #### Orphaned Tool Use Detection
> - **Issue:** AI message has tool use, but no following user message with tool results
> - **Fix:** Insert placeholder tool results (error message explaining they were missing)
>
> #### Partial Tool Results
> - **Issue:** AI requested 3 tools, but only 2 results returned
> - **Fix:** Add missing tool results (error placeholders)
>
> #### Tool Use Followed by Text
> - **Issue:** User sent text message after AI requested tools (should be tool results)
> - **Fix:** Convert message to array with tool results first, then text
>
> #### Backup Before Repair
> - **Requirement:** MUST create backup of original file before making any changes; **Location:** Same directory, `.backup` suffix; **Restoration:** User can manually restore if repair causes issues.

## REQ-28: Text Editor Suite — the multi-match str_replace safety contract (verbatim)

> **Requirement:** The system SHOULD provide a multi-command text editor tool with safety features.
>
> #### String Replace Command
> - **Input:** File path, old string, new string
> - **Output:** Success (1 replacement) or error
> - **Safety:** MUST reject if pattern matches > 1 location
> - **Error Details:** Show line numbers of ALL matches if multi-match detected
> - **Behavior:** Uses single-replacement (not global) even if safety check fails
>
> **Multi-Match Protection Example:**
> ```
> Input: Replace "def process" with "def process_v2"
> [String appears on lines 45, 123, 456]
> ERROR: Pattern matches 3 locations in file. Please make your pattern more specific to match only one location.
> Matches found at: Line 45 / Line 123 / Line 456
> ```
>
> (Companion commands in the same suite: **View** — file contents with line numbers or directory listing; **Create** — fails if file exists, no overwrites, creates parent dirs; **Insert** — insert after line N, line 0 = beginning, line EOF = append.)

**Cross-tier note (flag, don't manufacture):** the "reject if the old-string pattern
matches more than one location, and report every match's line number" contract is
the same safety principle that shipped edit tools (Tier-2 in-vivo maps) converged
on independently — the single-occurrence-anchor requirement. This is a genuine
Tier-1 (design) ↔ Tier-2 (shipped practice) convergence, one of the highest-value
kinds in this compilation. See `copies/II8-harness-refs/sapientia-era-tool-ideology.md`
(REQ-28, dated 2025-10) which reads the same requirement from the harness-refs copy.

## Failure Mode Matrix (verbatim) — the auto-retry / manual-recovery / data-loss-risk decision table

| Failure Mode | Detection | Auto-Retry | Manual Recovery | Data Loss Risk |
|--------------|-----------|------------|-----------------|----------------|
| **Server Error (500-503)** | HTTP status | ✅ 10x exponential | /resume after exhaustion | None (saved before send) |
| **Timeout (4-10min)** | Exception | ✅ 3x progressive | /resume after 19min | None (saved before send) |
| **Connection Error** | Exception | ❌ Immediate fail | /resume | None (saved before send) |
| **Tool Use Orphaned** | State check on load | ❌ | /resume or /rollback | ⚠️ Moderate (tools not executed) |
| **User Message Orphaned** | State check on load | ❌ | /resume | ⚠️ Moderate (response missing) |
| **Tool Results Orphaned** | State check on load | ❌ | /resume | ⚠️ Low (can re-request) |
| **Tool Execution Error** | Try/catch in tool | ❌ Returns error to AI | AI handles | None (error passed to AI) |
| **Large Tool Result** | Size check | ✅ Auto-truncate at 500KB | N/A | ⚠️ Partial (truncated) |
| **JSON Serialization** | /debug scan | ❌ | Manual message editing | 🔴 High (corrupted file) |
| **Encoding Issues** | /debug scan | ❌ | Manual message editing | ⚠️ Moderate (garbled text) |
| **Orphaned Tool Blocks** | /repair scan | ❌ | /repair auto-fix | ⚠️ Low (placeholder results added) |

## What the harness consumer should take from this

- A tool-call round has exactly three ways to die (pending / orphaned-user /
  orphaned-results), each with a *detection rule from message shape alone* and a
  bounded recovery. That taxonomy is reusable independent of this spec's Ruby.
- The invariant that makes recovery possible is **auto-save-before-send + immutable
  git-committed audit trail** (REQ-4 + REQ-9): the state on disk is never behind
  the wire, so "reconstruct from the log" is always available.
- **Blocking is a feature**: refusing all non-recovery input until an incomplete
  state is resolved is what prevents "talking past" an error into corruption. A
  harness loop that silently accepts the next turn over a broken tool round is the
  anti-pattern this names.
- The str_replace single-match contract is where this Tier-1 design meets shipped
  Tier-2 edit-tool practice — carry it as a convergence, not as a sapientia-only idea.
