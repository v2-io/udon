---
slug: errors-that-teach
type: principle
evidence: [T4, T2, T3, T1]
status: cross-tier-convergent (4-tier — the strongest lock in the corpus)
stage: drafted
consumers: both
depends: [tools-are-observation-infrastructure]
sources:
  - ../../01-ideation/02-provenanced/syntheses/asf-dossier.md   # §2.4
  - ../../01-ideation/02-provenanced/syntheses/CONVERGENCES.md  # clusters 8, 15
  - ../../01-ideation/02-provenanced/syntheses/tier2-invivo-digest.md  # C1, C2, C6
  - ../../01-ideation/02-provenanced/commentary/spikes/agent-utility-NOTES.md  # §2 principles
---

# A well-designed refusal is mutation-free, revelation-rich, and law-rich

**Claim.** Every tool interaction does up to three things at once: it
*mutates state* (changes something), *reveals state* (tells the agent what
is there), and *teaches law* (shows what invariantly governs this tool's
little jurisdiction — what it will and will not ever do). Errors are the
interactions where the law component dominates, and that makes a refusal
precious rather than merely unfortunate: it is the *safe* channel for an
agent to learn a system's constraint surface. The alternatives are worse —
learning a constraint destructively, or never learning it until it bites.
The design criteria fall out directly. A good refusal **mutates nothing**
(the failure is atomic, so the lesson isn't confounded by a half-applied
change), **reveals state** (what matched, where, what exists), and
**teaches the law** that was violated — ideally as a menu of exact next
actions.

## The strongest worked example this report has

Every kind of evidence this report draws on — the design work, the
shipping ecosystem, an agent's own testimony, and the formal theory —
converges on one example, and it is worth actually seeing. An early
find-and-replace editing tool in the 2025 agent-infrastructure work
silently replaced *every* occurrence of its pattern and reported a count;
its author discovered the damage only later. The tool that replaced it
refuses instead:

```text
⚠️  WARNING: Pattern matches 3 locations:
  - Line 1246 (deliberation-participate tool)
  - Line 1273 (council-participate tool)
  - Line 1890 (execute method)
Pattern matches 3 locations. Make pattern more specific.
```

Read that refusal against the three components. **Mutation: zero** — the
file is untouched. **State revealed** — not just "3 matches" but *where*,
which teaches the reader something true about the file itself: it has
repeated structure (three tool definitions with similar shapes), and the
edit was anchored on content that repeats when it needed to anchor on
structure that doesn't. **Law taught** — this tool requires uniqueness,
and the message points at the repair ("make pattern more specific" —
with the companion craft rule recorded beside the tool: anchor on closing
delimiters and method boundaries, which occur once, not on field lists,
which repeat). An agent doesn't just recover from this error; it comes
out knowing more about the codebase than it knew before the refusal.
That is what "errors as teaching moments" means mechanically — and it is
why the tool's safe default became replace-one rather than replace-all.

How each kind of evidence holds its corner:

- **Built (2025):** the refusal above shipped, with its design rationale
  recorded at the time — fail *before* corruption; rich diagnostics; the
  message guides toward the fix.
- **Shipped ecosystem-wide:** exact-match editing that fails loudly on
  zero matches or more than one, with a mandated prior read of the file,
  is the near-universal contract today (11 of the 14 harnesses examined
  at source). Most of that uniformity is inheritance from one influential
  design rather than independent invention — which still makes the
  survivorship point: in several years of intense iteration, nothing
  displaced it.
- **Shown failing when absent:** an agent's own first-person account of a
  tool that lacked this refusal shape describes exactly the damage the
  shape exists to prevent.
- **Derived by the theory:** the previous chapter established that a tool
  loop gives an agent real experimental access to its world only under
  conditions — one of which is that the agent *knows what its actions
  actually do*. Accumulated law-teaching feedback is how that condition
  gets established in practice. And laws are the slowest-moving stratum
  of an agent's world model, observed almost exclusively at violation
  attempts — so law-rich refusals accelerate exactly the layer nothing
  else can reach. In the theory's own words: "well-taught laws become
  infinite-velocity components of the agent's environment model — learned
  once, never re-derived."

The same demand recurs across the 2025–26 design work in other dress —
an error-message plan built on speaking domain concepts rather than
mechanics, a quality ladder ranking diagnostics by how much they teach.
The theory's full treatment of law-teaching is in
[the theory report](../reports/theory-of-agentic-tooling.md) §2.4.

## Design consequences

1. **Error taxonomy is first-class language and tool design.** Classify
   every diagnostic by which component it carries; bias hard toward
   law-rich, located, structure-revealing refusals.
2. **Atomicity of failed operations is an epistemic requirement**, not
   just a safety nicety — a refusal that half-mutates confounds the
   lesson it was supposed to teach.
3. **Error-as-menu:** offer candidates as ready-to-use exact next actions;
   on zero matches, name the likeliest hypothesis out loud ("the file may
   have changed since you read it").
4. **Name the failure class.** "Not found," "not unique," and "resolves
   to several" are different situations with different repairs — the
   [addressing chapter](addressing-is-the-long-pole.md) carries the
   concrete vocabulary this demands.
5. **Severity must track loss, and diagnostics must stay machine-legible.**
   UDON's anomaly posture — keep everything; a warning means content was
   kept, an error means something was lost — is this principle already
   applied at the notation layer.

## What this opens (ideas, not designs)

If refusals are the law-teaching channel, several things become
conceivable that nothing yet built does:

- ✦ **A refusal contract.** Every tool error could *declare* its three
  components as machine-readable fields: what mutated (which must say
  "nothing" or itemize exactly), what was observed, which law was
  violated. Agents could then accumulate the law fields across a session
  into a durable laws-file — the slow stratum of the world model made
  explicit, exportable, and inheritable by the next session (which is the
  [persistence chapter](persistence-is-imported.md)'s concern arriving
  early).
- ✦ **Laws queryable before violation.** The theory observes that laws are
  learned almost only at violation attempts — but that is a fact about
  today's tools, not about the world. A tool could answer counterfactuals:
  "would this call succeed?" — a dry-run channel that moves law-learning
  off the violation channel entirely. The honest doubt: violation-driven
  learning is attention-efficient precisely because it arrives exactly
  when relevant; an ask-first channel might simply go unasked.
- ✦ **Refusal quality as a measured property.** Replay the same malformed
  call under different goal framings and measure how differently the
  refusal gets interpreted; a refusal whose meaning shifts with the
  agent's goals is ambiguous, and that ambiguity is measurable. A harness
  could run this as a standing evaluation of its own error surfaces.
- ✦ **The diff-shaped refusal.** For a notation with a schema, the
  error-as-menu principle scales up: a validator that answers not just
  "invalid at line 12" but "here is the nearest valid document, as a
  diff." Whether *nearest* is computable cheaply enough is exactly the
  kind of question a design probe exists to answer.
- ✦ **Refusals as curriculum telemetry.** A tool's refusal stream is a
  record of which of its laws are worst-taught. Documentation ordered by
  violation frequency — the manual written *from* the refusals — would
  invert the usual relationship between docs and errors.

**Who reads this and when:** the harness applies it to every tool result
and system message; UDON applies it to parser and validator diagnostics
and to the edit tool's refusal design (the
[guarded-mutation chapter](schema-guarded-mutation.md)). Same principle,
two surfaces; no divergence.

## Honest edges

The theory's own scope note travels with this chapter: diagnostics inside
a working session and state carried *across* sessions are deliberately
distinct channels with different design physics. This chapter is the
in-session half; the [persistence chapter](persistence-is-imported.md) is
the other.
