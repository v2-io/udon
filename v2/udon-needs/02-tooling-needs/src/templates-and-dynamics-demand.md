---
slug: templates-and-dynamics-demand
type: demand
evidence: [T1]
status: design-of-record demand; architecture deliberately open (dissolves stage-pipeline assumptions)
stage: drafted
consumers: udon-primary
depends: [addressing-is-the-long-pole]
sources:
  - ../../pipeline-discussion.md  # Joseph ~L532–534, Fable/Grok ~L556–617
  - ../../01-ideation/needs-map.md  # S4, S7, S12
---

# Templates and dynamics: the product that is interrogated

**Claim.** The template use-case breaks every linear-pipeline assumption
the notation's processing story might be tempted to make, and it arrived
with a design insight attached: **the natural scope-context for UDON
templates is UDON itself**, which pulls the dynamics dialect's directives
toward path expressions and couples templating to addressing.

## The demand, as stated at the source

Joseph's template monologue (pipeline-discussion, the morning that
reshaped v2) is the primary source and is best carried nearly whole. The
product shape: `template = precompile('my.template.udon')` — then
**interrogate the compiled template for what scope-context it wants**
("it wants one with the following objects/variables and the following
predicates / boolean functions") — then `build-from(template, scope) →
output`. Three structural consequences, each a counterexample to a fixed
stage line:

1. **A product that is interrogated, then combined with a second input**
   has no slot in a bytes→events→tree→evaluation line; it forces the
   products-and-transforms graph the process discussion landed on.
2. **Mid-derivation, the scope-context realization:** "honestly I would
   probably want the scope-context to be udon itself most of the time, so
   a lot of the liquid-like directives end up having path-like
   syntaxes…" — dynamics couples to paths *independently* of the edit
   tool's pull, the second of two independent pulls that made addressing
   the long pole.
3. **The `!{{…}}`/`<…>` overlap:** both are dialect-ruled evaluation
   sites; the visible difference is that interpolation is text-guaranteed
   on completion. Logged as unification *pressure*, deliberately not
   acted on ("unifying before the map says when each is expected will
   just invent a prettier wrong boundary" — the panel's concurrence).

Adjacent open questions the same turns raised, inherited by the dialects
spike: can any of this stream (does a template-bearing document have an
event-level story at all, or is precompile-then-build inherently
batch?); what does the *failed* evaluation surface look like (a dynamics
error is a first-class anomaly, not a host exception); and mid-stream
reconfiguration (S12) — "now this dialect rules" — which stresses whether
dialect binding is per-document, per-scope, or per-event.

## What it generates

- **For UDON:** the dialects spike (#priorities-and-spike-agenda) owns
  this; the segment exists so the spike inherits the demand in its
  original force rather than a paraphrase. Two boundaries already firm
  enough to state: the core recognizes `!` syntax and carries expressions
  unparsed (ruled — a conformant parser needs no dialect), so the
  template product is *entirely* a dialect/host construction; and
  whatever the scope-interrogation surface becomes, it is a schema-shaped
  answer ("this template requires these names, these predicates") — the
  schema spike should be in the room.
- **For the harness:** templates are its prompt-assembly and
  report-generation substrate (the T4 frame: prompt assembly *is* the
  reconstruction mechanism — a template with an interrogable scope
  contract is a checkable prompt assembler). The near-term form doesn't
  wait for UDON dynamics: any templating the harness adopts should have
  the interrogable-requirements property, because "what does this
  template need?" asked programmatically is what makes template use
  verifiable rather than vibes.

## Honest edges

Single-source (one author, one morning), zero implementations, no
scenario corpus — by far the thinnest evidence base of any demand segment,
carried at design-of-record weight because it is the steward's stated
product vision and because its *structural* consequences (the graph, the
paths coupling) were independently ratified by two other substrates in
the same discussion. The Ruby-era ease ("output an erb and run it") is
noted in the source as lost under the Rust-centric present — the
implementation-cost question is real and unexplored.
