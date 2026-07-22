---
slug: progressive-disclosure-read-path
type: demand
register: evidenced
support-kind: [design, observational]
strength: robust-qualitative   # an estate design-of-record direction
convergent: —   # NOT ARMED: estate-convergent only. The observational support is a thin echo of the context-economy material, not an independent arrival - two facets of one author's position do not arm the lock
verified:
  - 2026-07-22 · frontmatter-migration · pilot-A · axes assigned from the chapter's claim; convergent legs audited under the failure-mode-independence key
stage: drafted (fresh-page bridge rewrite, 2026-07-22)
consumers: both
depends: [addressing-is-the-long-pole, context-economy]
sources:
  - ../../01-ideation/02-provenanced/commentary/spikes/agent-utility-NOTES.md  # §2 payload table
  - ../../01-ideation/02-provenanced/copies/I3-design-of-record/udon-agentic-body.md  # read whole
  - ../../01-ideation/02-provenanced/syntheses/tier2-invivo-digest.md  # C11
---

# The read path: glance first, then focus

Editing was the last three chapters' subject; this one is about the
cheaper thing agents do far more often — *reading* — and about a
mismatch: an agent's context window is a hard budget, but the reading
tools it is given are mostly all-or-nothing. Open the file whole, or
search it blind. What an agent actually needs, over and over, is the
middle move: a cheap structural **glance** — what is this document, what
are its parts, how big — followed by focused descent into exactly one
region, without paying for the rest.

**The glance has been designed in detail, and the design keeps arriving
at the same conventions.** The most complete treatment is a tool catalog
written for agent-facing document work in late 2025 (its full text
informs this chapter; the catalog's own conventions section is the most
transferable part). Its rules are concrete: every payload carries **line
numbers**, so an agent can correlate one tool's answer with another's;
descent payloads carry a **breadcrumb** — the chain of ancestors, each
with its own line number — so "where am I?" never costs a second read;
summaries appear as **counts in parentheses** rather than prose ("3
children, 12 attributes"); answers carry an explicit **confidence
marker**, with an explanation whenever confidence is not high; and errors
arrive as **menus** — a refusal that lists the nearest resolvable
alternatives, each one copy-pasteable, rather than a bare "not found."
The same catalog designs a stateful session view (current location,
expanded and collapsed regions, staged-but-uncommitted changes) and a
trace query — *what refers to this, what does this refer to, with
locations* — which is impact analysis as a first-class read: the
due-diligence an agent should be able to do before any risky write.

**The key composition: what you can see is what you can address.** The
glance's skeleton lines are designed to *be* valid addresses — the
previous chapter's subject — so a skeleton is simultaneously a map and a
set of handles. Glance, copy the line, descend; descend, copy the line,
edit. That single design decision is what makes the read path and the
edit path one loop instead of two tools.

**Shipping practice has half of this.** Real coding harnesses have
independently built progressive disclosure *for tool output* — long
results arrive as previews with the full text parked on disk behind a
recoverable path, and some prune results against a stated focus question.
What none of them has is the *structural* glance: their skeletons are
file trees and search hits, lines of text with no shape. A document
notation whose structure is itself cheap to skeletonize would supply the
half that is missing — and the budget arithmetic is stark: a 200-token
glance in place of a 5,000-token full read is not a convenience, it is
room for a more ambitious plan in the same window.

**Who reads this and when:** for UDON, the skeleton/glance utility is
among the cheapest high-value tools to build once addressing exists, and
skeleton-lines-as-addresses is the design decision to protect. For the
harness, the payload conventions — line numbers, breadcrumbs, counts,
confidence, menu-shaped errors — transfer to any tool output in any
notation, and several are already ecosystem-standard.

## Honest edges

All shape, no measurements: no one has measured glance-versus-full-read
context savings or task-success deltas on real agent workloads (the one
usability study that exists predates these designs). The session view
assumes a single writer; under concurrent writers it survives only via
the re-resolve-at-commit rule the previous chapter describes — stated in
the design, enforced by no code yet.

## Working Notes

**The convergence lock is deliberately NOT armed here, and that call is worth
challenging.** Both legs — the design-of-record and the read-path echo in the
context-economy material — trace to the same author's position, so under the
failure-mode-independence key they are two facets of one estate leg, not two
independent arrivals. The direction still looks right; it simply has one
independent source rather than two.

What would arm it: a shipped progressive-disclosure read surface in a harness
nobody here influenced (an outline/skeleton-then-focus read tool), or de-novo
agent testimony that the glance→focus shape is what they reach for unprompted.
Either would be a genuinely independent failure mode. If someone finds one, the
lock arms as `[design, observational]` or `[design, testimonial]`.
