---
source: UDON repo — test/usability/results/AGENT_FEEDBACK.md (aggregated first-person FEEDBACK blocks from test agents, Dec 2025)
gathered: 2026-07-21
status: gathered — thematic excerpt (verbatim blocks selected + indexed). SUPERSEDED as the primary artifact by the whole-file copy `AGENT_FEEDBACK-full.md` in this same directory (per STEWARD-CALLS #7 — the "sample, not whole dump" call was overruled: originals wanted). This file keeps an honest, narrower role: a curated thematic index INTO the full copy — start here for the recurring themes, read `AGENT_FEEDBACK-full.md` for every block + the Judge/Validated-score tail this excerpt omits.
supersedes_note: >
  Read `AGENT_FEEDBACK-full.md` (whole 827-line original) for the complete
  testimony and the machine-scoring tail; this excerpt covers only the FEEDBACK
  blocks at source lines 9-279 and drops the Judge-scores/Validated-scores half.
paths:
  - test/usability/results/AGENT_FEEDBACK.md:9-279
source_commit: 3d8e5b9c52b2a581c4ab9021984423073a694693
categories: [agent-testimony, notation-friction, wishlist, mixed-content-boundary, whitespace-fragility, error-recovery, tooling-day-one, adoption-barrier, independent-rederivation]
why_included: >
  First-person testimony from the tool's actual audience (agents) about where
  the notation hurt and what they reached for — the L-tier row that is higher
  signal than its weight suggests. TWO things make it valuable. (1) The recurring
  wants/frictions converge hard across independent one-shot agents: the
  prose/structure boundary marker, whitespace/indentation fragility on
  copy-paste, error-recovery and diagnostic messages ("is the syntax forgiving
  or strict?"), unquoted-value type ambiguity, and "tooling from day one or
  adoption founders." (2) A large share come from the `invention` track — agents
  asked to design their OWN mixed-content notation BEFORE seeing UDON — so their
  landing on the same tensions is independent re-derivation of UDON's core design
  problem, not agreement with it. That is a genuine convergence worth flagging
  (though same-model, not cross-tier). Reads as a demand spec for the notation's
  error/tooling surface — first-class for the harness consumer too (what an
  agent's authoring loop needs to self-correct).
---

# Agent feedback excerpts — what agents wanted / what hurt

Verbatim blocks from `AGENT_FEEDBACK.md`, selected for the recurring themes.
The file's own header: "Aggregated feedback from test agents evaluating UDON
syntax. These insights come from agents asked to interpret or produce UDON."

## The recurring themes (index over the corpus)

1. **The prose/structure boundary is the central unsolved tension** — nearly
   every `invention`-track agent independently identified "distinguish 'this is
   structure' from 'this is text'" as the hard problem, and each invented a
   marker (`|`, `>`, `@`, sigil, quoted-prose) with acknowledged costs.
2. **Whitespace/indentation fragility** — "copy-paste errors become syntax
   errors"; invisible-whitespace bugs flagged as "more critical than it seems."
3. **Error recovery & diagnostics** — "is the syntax forgiving or strict?";
   "do indentation mismatches silently create wrong structure, or is there an
   explicit error message?" A repeated, unanswered want.
4. **Unquoted-value type ambiguity** — `name=foo` symbol vs `name="foo"` string;
   `key: true` vs `key: "true"`; int/float/decimal distinction.
5. **Tooling-from-day-one or adoption founders** — "success might depend heavily
   on having exceptional tooling from day one—syntax highlighting, validation,
   transformation tools."
6. **The everything-format / complexity-vs-benefit skepticism** — "trying to be
   good at data, documents, AND configuration means compromising on all three."
7. **Attribute syntax & list syntax want canonicalization** — `()` vs `[]`,
   inline `[a,b,c]` vs indented children.

## Selected verbatim blocks

### On mixed content being genuinely hard (invention track, haiku-4-5)

> **1. Mixed content is genuinely hard.** The moment you want prose + structure,
> traditional notations (JSON, YAML, XML) all struggle. … Most notation designs
> nail data OR documents, but not both. This suggests that if UDON solves this
> well, it's genuinely novel.
>
> **2. Indentation-based structure has real costs.** It's easy to read but
> fragile to write and parse. Invisible whitespace bugs are severe. Consider:
> does UDON have explicit error messages for indentation mismatches, or do they
> silently create wrong structure? This is more critical than it seems.

### The prose/structure boundary, independently re-derived (invention, opus-4-5)

> The hardest tension I encountered: making prose "natural" while keeping
> structure unambiguous. My `>` marker feels slightly noisy but necessary—
> without it, you can't tell if `@em important` means "em element with attribute
> 'important'" or "em element containing text 'important'".
>
> I'm skeptical that any notation fully solves mixed content elegantly. The
> fundamental problem: you need *some* way to distinguish "this is structure"
> from "this is text", and every choice has costs.

### Same tension, different invented answer (invention, sonnet-4-5)

> This exercise immediately revealed the central tension: making prose feel
> natural while keeping structure unambiguous. My instinct was to make prose
> quoted, but that feels backward for a document-first format.
>
> Alternative I considered: Make UNQUOTED text the default (prose), and require
> some sigil for structural elements (maybe `:element-name` or `@element`?). …
> The design space feels constrained enough that there might only be 2-3 viable
> approaches.

### The questions agents kept asking back (invention, haiku-4-5)

> - How do you handle **deeply nested attributes**? …
> - Does **prose have access to interpolation/templating**? …
> - How do you **visually distinguish** an element with no children from prose
>   that happens to be a single word?
> - What's the **error handling story**? Indentation is fragile; how do parsers
>   report problems helpfully?

### Enablement track — tooling and A2A performance worry (enablement, sonnet-4)

> I'm genuinely intrigued by the mixed content concept, but I worry about the
> complexity-to-benefit ratio. … The success might depend heavily on having
> exceptional tooling from day one—syntax highlighting, validation,
> transformation tools, etc. Without that, even compelling use cases might
> founder on adoption friction.
>
> Also wondering about performance characteristics—mixed parsing typically has
> higher overhead than pure structured formats. For high-volume agent-to-agent
> communication, this could matter.

### Cognitive-load skepticism, with the inline-parse-overhead point (topic_enablement: Cognitive load, sonnet-4-5)

> **Inline syntax ambiguity.** Consider: `|p See |{a :href /docs the docs} for
> details.` vs regular prose: "See the docs for details." The cognitive overhead
> of parsing `|{...}` syntax while reading is non-trivial.
>
> [Appreciated:] The **mixed content model** is genuinely thoughtful. …
> **Inline elements** `|{em like this}` are more readable than XML/HTML for
> prose-heavy content. The **progressive disclosure** of complexity in the spec
> itself (flags, mixins, references) shows careful design.

## Note for synthesis

The `invention`-track convergence (multiple independent agents landing on the
same prose/structure-boundary problem and the same fragility/error-recovery
worries) is *same-model* convergence, not cross-tier triangulation — flag it as
independent re-derivation of the design problem, not as external corroboration
of UDON's answer. Its force is that the problem is real and hard, witnessed by
the audience itself.
