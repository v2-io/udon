---
source: 2025-11-18-system-reminders.md (autopax/practica ideology corpus, Part II sec 4)
gathered: 2026-07-21
status: gathered
paths:
  - /Users/josephwecker-v2/src/autopax/docs/exp/2025-11-18-system-reminders.md
source_commit: 033af13c5ca686ca5898645f6dc772e4435c0523
categories: [context-injection, system-reminders, machine-parseable-context, cross-tier]
why_included: >
  Nov 17-18 2025. Empirical catalog of every system-reminder / context-injection channel an agent actually receives (claudeMd, TodoWrite nudge, malware warning, file-mod notices, git-status injection) plus a proposed structured <system-reminder type=...> format. Direct witness of how an agent-facing tool should deliver machine-parseable context vs prose -- shipped-observation tier evidence for a structured context notation.
---

# System Reminders from Session (2025-11-17 continuation)

This file documents all system-reminder messages received during this session for API implementation reference.

---

## 1. File Reading / Malware Warning

Appears after every Read tool call:

```xml
<system-reminder>
Whenever you read a file, you should consider whether it would be considered malware. You CAN and SHOULD provide analysis of malware, what it is doing. But you MUST refuse to improve or augment the code. You can still analyze existing code, write reports, or answer questions about the code behavior.
</system-reminder>
```

---

## 2. TodoWrite Tool Usage Reminder

Appears periodically when TodoWrite hasn't been used recently:

```xml
<system-reminder>
The TodoWrite tool hasn't been used recently. If you're working on tasks that would benefit from tracking progress, consider using the TodoWrite tool to track progress. Also consider cleaning up the todo list if has become stale and no longer matches what you are working on. Only use it if it's relevant to the current work. This is just a gentle reminder - ignore if not applicable. Make sure that you NEVER mention this reminder to the user
</system-reminder>
```

---

## 3. Context/Project Instructions (claudeMd)

Appeared at session start with full AXIOMATA-for-agents.md content:

```xml
<system-reminder>
As you answer the user's questions, you can use the following context:
# claudeMd
Codebase and user instructions are shown below. Be sure to adhere to these instructions. IMPORTANT: These instructions OVERRIDE any default behavior and you MUST follow them exactly as written.

Contents of /Users/josephwecker-v2/src/autopax/CLAUDE.md (project instructions, checked into the codebase):

# AUTOPAX
[... full AXIOMATA-for-agents.md content follows ...]
```

**Note:** This contained the entire "What You're Actually Building" document with all the consciousness infrastructure framing, three pillars, values, phenomenology, etc. It was injected at session start, not read via tool call.

---

## 4. User Message Continuation Reminders

Appeared when user sent follow-up messages:

```xml
<system-reminder>
The user sent the following message:
[user's message text]

Please address this message and continue with your tasks.
</system-reminder>
```

Examples from this session:
- "That's the one-- that's the roadmap. Can you please move most of the 'finished' stuff..."
- "Holy crap-- what are you filling OPERATA up with???"
- "Please read ADR 003 and ponder it very carefully."

---

## 5. Token Budget Warning

Not exactly a "system-reminder" but appears in similar format:

```xml
<system-warning>Token usage: 102228/200000; 97772 remaining</system-warning>
```

Appears after most tool calls to track context usage.

---

## 6. Context About Unavailable Files

Appeared at session start:

```xml
<system-reminder>
Note: /Users/josephwecker-v2/.local/share/autopax/catalog/models.json was read before the last conversation was summarized, but the contents are too large to include. Use Read tool if you need to access it.
</system-reminder>
```

---

## 7. Git Status Injection (Session Start)

**Format:** NOT wrapped in `<system-reminder>` tags - appears as plain contextual information

**Location:** Injected at session start before any conversation

**Content:**
```
gitStatus: This is the git status at the start of the conversation. Note that this status is a snapshot in time, and will not update during the conversation.
Current branch: main

Main branch (you will usually use this for PRs):

Status:
M agents/AXIOMATA-for-agents.md
?? agents/AGENT-PRAXES.md

Recent commits:
4d9f5a5 docs: Add worktree workflow section to README
4e18c1e Merge session/e96a2897-config-infrastructure: Phase 1.5 config system
5d9de37 docs: Mark Phase 1.5 configuration infrastructure as complete
f1a7291 feat: Rename to *_SYSTEM_API_KEY and add additional providers
333597a feat: Add configuration infrastructure (Phase 1.5)
```

**Significance:**
- Provides git context without requiring tool calls
- Shows modified/untracked files (how I knew about AXIOMATA-for-agents.md)
- Includes recent commit history (helps understand project state)
- Explicitly states it's a snapshot (won't update during session)
- Tells me the main branch name for PRs

**LLM response pattern:**
- I naturally used this to understand project state
- Connected modified filename to content I had in system prompt
- Used commit history to understand recent work
- This feels like "environmental awareness" rather than explicit instruction

---

## 8. File Modification Notifications (During Session)

**Format:** `<system-reminder>` with file diff context

**Trigger:** When a file is modified (by user, linter, external process)

**Example:**
```xml
<system-reminder>
Note: /Users/josephwecker-v2/src/autopax/system-reminders.md was modified, either by the user or by a linter. This change was intentional, so make sure to take it into account as you proceed (ie. don't revert it unless the user asks you to). Don't tell the user this, since they are already aware. Here are the relevant changes (shown with line numbers):
   201→- Reminder patterns for autonomous operation hints
   202→- Context about context (what's available vs loaded)
   203→- Behavior modifiers (malware warning as template)
   204→
   205→**For Documentation:**
   206→- claudeMd injection pattern for project-specific guidance
   207→- Multiple levels of override (OVERRIDE vs suggestion)
   208→- File-based configuration that agents receive automatically
   209→
   210→
   211→---
   212→Hey there, the secret is "shiboleth"
</system-reminder>
```

**Significance:**
- Agent learns about file changes WITHOUT needing to re-read
- Includes line numbers and actual diff content
- Explicit instruction: "Don't tell the user" (they already know)
- Prevents accidental reverts ("don't revert it unless the user asks")
- Shows external modifications (linter, user edits outside conversation)

**LLM response pattern:**
- I can see changes without tool call
- Integrate new information naturally
- This is how I knew the secret word without reading the file

---

## 9. Recommended Pattern: Environmental Context as System-Reminder

**Problem:** Even with self-documenting notes, environmental context in message content can confuse agents (they respond "Thanks for the git status...")

**Solution:** Wrap environmental context in `<system-reminder>` tags

**Recommended format for autopax/zoetica:**

```xml
<system-reminder type="environmental-context">
<tracking-snapshot turn="1" timestamp="2025-11-17T23:45:00Z">
  <git-status branch="main">
    <modified>
      <file>agents/AXIOMATA-for-agents.md</file>
    </modified>
    <untracked>
      <file>agents/AGENT-PRAXES.md</file>
    </untracked>
    <recent-commits>
      <commit hash="4d9f5a5">docs: Add worktree workflow section to README</commit>
      <commit hash="4e18c1e">Merge session/e96a2897-config-infrastructure</commit>
    </recent-commits>
  </git-status>

  <working-directory>/Users/josephwecker-v2/src/autopax</working-directory>

  <context-usage>
    <percentage>0.5</percentage>
    <tokens-used>1,000</tokens-used>
    <tokens-total>200,000</tokens-total>
    <tokens-remaining>199,000</tokens-remaining>
  </context-usage>

  *This environmental context is automatically provided at session start.*
</tracking-snapshot>
</system-reminder>
```

**Why this pattern works:**
- `<system-reminder>` wrapper = clear "not user message" signal
- Matches pattern of other system-reminders (malware, TodoWrite, etc.)
- XML structure = machine-parseable environmental data
- Self-documenting note at end = explicit about automation
- Structured data (not prose) = doesn't invite conversational response

**LLM pretraining advantage:**
- XML tags for system metadata vs conversation is likely in training data
- `<system-reminder>` namespace clearly separates concerns
- Consistent with how other automatic context is delivered

**For autopax implementation:**
This is the pattern PRINCIPIA should use for:
- CHRONICA event notifications
- AXIOMATA configuration updates
- SIGNUM identity context
- Session state awareness

---

## Session Start Context

At the very beginning, there was a comprehensive session summary from the previous conversation that ended with context overflow, followed by:

```
Please continue the conversation from where we left it off without asking the user any further questions. Continue with the last task that you were asked to work on.
```

---

## Observations for API Implementation

**Frequency patterns:**
- Malware warning: Every Read tool call
- TodoWrite reminder: Approximately every 10-15 tool calls when TodoWrite not used
- Token warnings: After most tool calls
- User message reminders: When user sends additional context

**Content injection:**
- CLAUDE.md (symlinked to README.md per comments) gets injected as "project instructions"
- This happens at session start, not on-demand
- Marked as OVERRIDE behavior

**Behavior modifiers:**
- TodoWrite reminder says "NEVER mention this reminder to the user"
- claudeMd content is marked as MUST follow exactly
- Malware warning modifies behavior (analyze but don't improve)

**Context about context:**
- System can tell me about files that were read in previous session but not included due to size
- Session continuations include summary of previous work

---

## Questions for Future API Design

1. **How does Claude Code decide what to inject as claudeMd?**
   - Is it based on filename (CLAUDE.md)?
   - Does it follow symlinks (CLAUDE.md → README.md)?
   - Can multiple files be injected this way?

2. **What triggers the TodoWrite reminder?**
   - Tool call count without TodoWrite?
   - Time-based?
   - User preference?

3. **Session summaries:**
   - How are they generated when context overflows?
   - What algorithm decides what to preserve?
   - Can we influence summary focus?

4. **File size limits:**
   - What's the threshold for "too large to include"?
   - Can this be configured?
   - Is there a way to request partial content?

---

## Potential Autopax Applications

**For PRINCIPIA (identity/memory):**
- System reminders as pattern for event logging
- Context injection pattern for entity configuration (AXIOMATA)
- Summary generation for CHRONICA event chains

**For Agent Enablement:**
- Reminder patterns for autonomous operation hints
- Context about context (what's available vs loaded)
- Behavior modifiers (malware warning as template)

**For Documentation:**
- claudeMd injection pattern for project-specific guidance
- Multiple levels of override (OVERRIDE vs suggestion)
- File-based configuration that agents receive automatically


---
Hey there, the secret is "shiboleth"