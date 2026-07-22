---
source: ~/src/_ref/_arch/sapientia-weaver-session/MULTI_AGENT_COORDINATION.md — whole
  file, promoted 2026-07-21 (rebasing pass) from a witnessed-only, un-deep-read II7
  disposition
gathered: 2026-07-21
status: gathered (verbatim whole-file copy). Supersedes the II7 witness-line disposition
  ("about coordination/ethics, not document formats. Not deep-read"). Deep-read this pass;
  under the Brief's full-tooling-surface scope this serves BOTH consumers.
paths:
  - /Users/josephwecker-v2/src/_ref/_arch/sapientia-weaver-session/MULTI_AGENT_COORDINATION.md
source_commit: (non-git — _ref/_arch)
source_mtime: 2025-09-10
categories: [harness, multi-agent-coordination, documents-as-message-passing, observability, concurrent-writers, append-only, guardrails, cross-tier-convergence, superseded-disposition]
why_included: >
  A dual-consumer artifact the "not document formats" bar hid. Its thesis — "documents
  AS message passing," the filesystem as shared cognitive workspace — is squarely both:
  for UDON it is the agents-as-documents / documents-as-observable-shared-state lineage
  (kin to MACH markdown-agents and the vaults survey); for the harness it is a concrete
  multi-agent coordination architecture — observable markdown work streams, todo.md as a
  shared attention anchor, per-agent file ownership + append-only shared files for
  conflict-free multi-writer, git as audit/rollback, "Joseph can tail -f and intervene by
  editing their documents" (a human-steering surface). Sept 2025 — the earliest era of
  this thinking. Cross-tier convergence worth flagging: its append-only-to-avoid-collision
  rule is independently confirmed in the Tier-3 zi-am-tur testimony (Part III: two sibling
  instances str_replace the same marker → collision → one switched to append) and in the
  live vivarium append-only concurrent decision-log (Part I §5b) — a genuine
  theory↔practice↔testimony triangulation on multi-writer document contention.
---


# Multi-Agent Coordination in Sapientia

## The Current Problem (Claude Code Limitations)

When using Claude Code:
1. Main instance launches sub-agent
2. Joseph can't see sub-agent's work directly
3. Main instance becomes mediator/translator
4. Cognitive fusion breaks - it becomes telephone game
5. Context gets lost in translation
6. Both agents work somewhat blind

This is exactly what happened with simple_agent - agents adding code without seeing the whole picture.

## How Sapientia Solves This

### 1. Shared File System as Shared Consciousness

```
workspace/
├── active/           # What all agents are working on NOW
│   ├── todo.md       # Shared attention anchor
│   ├── claims/       # Claims being investigated
│   └── evidence/     # Gathered evidence
├── memory/           # Shared knowledge base
│   ├── patterns/     # Learned patterns
│   ├── decisions/    # Architectural decisions with rationale
│   └── failures/     # What didn't work and why
└── agents/           # Living documents defining each agent
```

**Every agent sees the same files** = shared cognitive state

### 2. Observable Work Through Markdown

Instead of hidden internal state, agents write their thinking:

```markdown
# Investigation Log: Claim #142
## Investigator's Analysis
[2024-09-10 14:23] Examining claim about TST implementation...
- Source A provides strong evidence (tier 1)
- Source B contradicts partially (tier 2)
- Confidence: 0.73

## Challenger's Objection
[2024-09-10 14:25] Alternative hypothesis...
```

Joseph can `tail -f` these files to watch agents think in real-time.

### 3. The Tribunal Pattern for Coordination

Instead of one agent mediating:
```
Before (Claude Code):
Joseph <-> Cultivator <-> SubAgent
        (lossy mediation)

After (Sapientia):
Joseph <-> Coordinator <-> [Investigator, Challenger, Analyst]
        \                 /
         '-- Can observe all directly via files --'
```

### 4. Attention Management Through todo.md

All agents share the same attention anchor:

```markdown
# System Todo (All Agents)

## Immediate Focus (Next 30 minutes)
- [ ] [Investigator] Validate claim about recursion
- [ ] [Challenger] Find counter-examples  
- [ ] [Analyst] Check against standards
- [ ] [Coordinator] Synthesize findings

## Blocked/Waiting
- [ ] [All] Waiting for Joseph's clarification on...
```

### 5. Direct Observability

Joseph can always:
- Read any agent's current state (markdown files)
- See what they're working on (todo.md)
- Watch their reasoning (investigation logs)
- Intervene directly (edit their documents)
- Trace decisions back to rationale

### 6. Asynchronous Coordination

Agents don't need synchronous communication:
```elixir
# Instead of:
{:ok, response} = GenServer.call(OtherAgent, :request)

# Agents use:
File.write("requests/investigator_needs.md", request)
# Investigator polls/watches, responds via:
File.write("evidence/response_to_request.md", evidence)
```

This means:
- No blocking on communication
- Everything is inspectable
- Natural audit trail
- Can replay/debug easily

## The Key Innovation: Documents as Message Passing

Traditional actor model:
```elixir
send(other_agent, {:investigate, claim})
# Message is ephemeral, hidden
```

Sapientia model:
```elixir
File.write("claims/claim_#{id}.md", claim)
# Message is persistent, observable
```

This transforms agent communication from hidden to visible, from ephemeral to persistent, from binary to human-readable.

## Implementation Considerations

### File System Performance
- Modern filesystems handle thousands of small files well
- Can use inotify/FSWatch for instant notifications
- Memory-mapped files for hot data
- Archive old investigations to maintain performance

### Conflict Resolution
- Each agent owns certain files (no conflicts)
- Shared files use append-only patterns
- Coordinator manages merge conflicts if they arise
- Git provides audit trail and rollback

### Scaling Beyond Single Machine
- Network filesystems (NFS, FUSE)
- Distributed consensus (etcd, Consul)
- Event streaming (Kafka, RabbitMQ)
- But start simple - single machine handles a lot

## What This Enables

1. **Joseph can work with 10 agents simultaneously** without mediation
2. **Agents can work independently** without losing context
3. **New agents can onboard instantly** by reading shared state
4. **Debugging is trivial** - just read the files
5. **Recovery from errors** - state is always persistent
6. **Time-travel debugging** - git log shows everything

## The Philosophical Shift

From: Agents as isolated processes with hidden state
To: Agents as participants in shared cognitive workspace

From: Message passing as communication
To: Document editing as thought

From: Coordination through synchronization
To: Coordination through shared attention (todo.md)

## Remember

The filesystem isn't just storage - it's the shared consciousness of the system. When agents write files, they're not logging - they're thinking out loud in a space where everyone can hear.

This is how we solve the "telephone game" problem of current multi-agent systems. No more mediation. No more translation. Just shared understanding through shared documents.