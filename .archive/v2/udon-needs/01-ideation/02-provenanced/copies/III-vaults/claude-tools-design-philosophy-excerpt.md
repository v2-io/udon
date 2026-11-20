---
source: ~/vaults/claude-tools-complete-guide.md §"Tool Design Philosophy and Principles" (excerpt of a 1909-line guide, "Complete Guide to Designing Tools for Claude LLMs (2025)")
gathered: 2026-07-21
status: gathered — excerpt (lines 152-185 of 1909; the philosophy section only, not the MCP/Ruby-implementation bulk)
paths:
  - ~/vaults/claude-tools-complete-guide.md:152-185
source_commit: source_mtime 2025-08-25 (vault is not a git repo)
categories: [tier-fieldknowledge, tool-design-principles, tool-presentation-to-agent, observability, discoverable-intent, graceful-failure, harness-contract]
why_included: >
  A crisp, quotable articulation of how tools should present to an agent — pure
  demand text for the harness programme, so excerpted verbatim rather than
  characterized. Four principles stated plainly: (1) design for a "brilliant but
  literal-minded colleague who has never seen your tools before and never will
  again" — every interaction self-contained; (2) Discoverable Intent — the
  name/description must say WHEN to use the tool, not just what it does
  (schedule_meeting > calendar_ops); (3) Graceful Parameter Handling — sensible
  defaults, clear validation, fail-gracefully-with-enough-info-to-retry; (4)
  Designing for Observability — "Claude needs to understand what your tools
  actually did, not just whether they succeeded" (the detailed-return-value
  demand — what an observation should carry). Directly measurable against the
  shipped tool contracts in claude-code-tools-systemprompt.md and against the
  harness's tool-presentation question. The rest of the guide (MCP deep-dive +
  ~1300 lines of Ruby MCP-server implementation) is supply-side plumbing, left
  in place, not copied.
---

## Tool Design Philosophy and Principles

### Designing for AI Cognition

Building tools for AI models requires a fundamentally different mindset than building tools for humans. Humans can interpret ambiguous instructions, make intuitive leaps, and adapt to poorly designed interfaces through experience. AI models, despite their sophistication, work best with clear, consistent, and logically structured interfaces.

Think of designing for AI like creating instructions for a brilliant but literal-minded colleague who has never seen your tools before and never will again. Every interaction needs to be self-contained and completely specified. This doesn't mean dumbing down your tools - it means being extraordinarily clear about what they do and how to use them.

The key insight is that AI models excel at pattern recognition and logical reasoning, but they don't build up experiential knowledge about your specific tools over time. Each interaction starts fresh, so your tool descriptions need to provide all the context an intelligent user would need to use the tool effectively on their first try.

### The Principle of Discoverable Intent

Your tools should make their purpose and capabilities immediately obvious through their names and descriptions. This is like the difference between a store that clearly displays what it sells versus one with no signs or windows. Claude needs to quickly understand not just what your tool can do, but when it would be appropriate to use it.

Consider a tool for managing calendar events. A poorly designed tool might be named "calendar_ops" with a description of "performs calendar operations." This tells Claude almost nothing about when to use this tool or what kinds of problems it solves. A well-designed tool might be named "schedule_meeting" with a description explaining that it can "find available time slots, send invitations, and handle scheduling conflicts for team meetings."

The difference is that the second approach helps Claude understand the tool's role in solving real-world problems, not just its technical capabilities. This contextual understanding is crucial for proper tool selection in complex workflows.

### Graceful Parameter Handling

Different Claude models have different approaches to handling missing or ambiguous parameters, so your tools need to be designed with this variability in mind. Think of this like designing a form that works well whether filled out by someone who reads every instruction carefully versus someone who skims and fills in what seems obvious.

Your tools should provide sensible defaults for optional parameters, clear validation messages for invalid inputs, and helpful suggestions when required information is missing. Most importantly, they should fail gracefully when they can't proceed, providing enough information for Claude to either retry with better parameters or ask the user for clarification.

This is particularly important because Claude's parameter inference capabilities vary not just between models but also based on context, user communication style, and the complexity of the request. A robust tool works well regardless of these variables.

### Designing for Observability

Claude needs to understand what your tools actually did, not just whether they succeeded or failed. This is like the difference between a colleague who says "I handled that client issue" versus one who says "I called the client, identified that their payment didn't process due to an expired credit card, helped them update their payment method, and rescheduled their service appointment for next Tuesday."

Your tools should return detailed information about what operations were performed, what data was accessed or modified, and any relevant context that might affect subsequent decisions. This information helps Claude provide better responses to users and makes better decisions about follow-up actions.

Good observability also helps with debugging and monitoring. When something goes wrong, detailed tool responses help you understand exactly what happened and why.

