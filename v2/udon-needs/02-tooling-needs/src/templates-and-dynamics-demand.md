---
slug: templates-and-dynamics-demand
type: demand
evidence: [T1]
status: owner's stated product vision; architecture deliberately open (dissolves stage-pipeline assumptions)
stage: drafted
consumers: udon-primary
depends: [addressing-is-the-long-pole]
sources:
  - ../../pipeline-discussion.md  # Joseph ~L532–534, Fable/Grok ~L556–617
  - ../../01-ideation/needs-map.md  # S4, S7, S12
---

# Templates and dynamics: the product that is interrogated

**Claim.** The template use-case breaks every linear-pipeline assumption
a notation's processing story might be tempted to make — and it arrived
with a design insight attached: **the natural data context for a UDON
template is UDON itself**, which pulls the template language's
directives toward path expressions and couples templating to
addressing.

## The demand, as stated at the source

The primary source is the project owner thinking the product through
out loud (recorded in [[pipeline-discussion.md|the design
deliberations]]), and it is best carried nearly whole. The product
shape: compile a template once — then **interrogate the compiled
template for what it needs** ("it wants [a context] with the following
objects/variables and the following predicates / boolean functions") —
then build: template plus a context, yielding output. Three structural
consequences, each a counterexample to any fixed processing line:

1. **A product that is interrogated, then combined with a second
   input,** has no slot in a bytes → events → tree → evaluation line.
   It forces a *graph* of products and transformations — things made,
   questioned, and recombined — rather than a one-way pipe.
2. **The data-context realization, arrived at mid-sentence:** "honestly
   I would probably want the scope-context to be udon itself most of
   the time, so a lot of the liquid-like directives end up having
   path-like syntaxes…" — templating couples to addressing
   *independently* of the edit tool's pull. Two unrelated products
   arriving at the same dependency is much of why the
   [addressing chapter](addressing-is-the-long-pole.md) calls it the
   long pole.
3. **Two evaluation sites that resemble each other.** UDON has an
   interpolation form (evaluate this expression, yield text) and a
   typed-value envelope (a dialect interprets this content); both are
   dialect-governed evaluation, differing visibly in that interpolation
   guarantees text on completion. The resemblance is logged as
   unification *pressure* and deliberately not acted on — in the
   deliberation's own words, unifying before the demand picture says
   when each is expected "will just invent a prettier wrong boundary."
   Two independent reviewers of that discussion concurred.

Adjacent open questions from the same turns, inherited by the dialect
design work: can any of this stream — does a template-bearing document
have an event-level story at all, or is compile-then-build inherently
batch? What does *failed* evaluation look like on the page — a dynamics
error should be a first-class anomaly, not a host exception. And can
the governing dialect change mid-document ("now this dialect rules…"),
which stresses whether dialect binding is per-document, per-scope, or
per-event.

## What it generates

- **For UDON:** the dialect design work owns this territory; this
  chapter exists so it inherits the demand at original strength rather
  than as a paraphrase. Two boundaries are already firm: the core
  language only *recognizes* the dynamics syntax and carries
  expressions unparsed (a conformant parser needs no template engine —
  already decided), so the template product is entirely a dialect and
  host construction; and whatever the interrogation surface becomes,
  its answer is schema-shaped — "this template requires these names,
  these predicates" — so the schema design work should be in the room.
- **For the harness:** templates are its prompt-assembly and
  report-generation substrate, and the theory frames prompt assembly as
  the very mechanism by which a fresh session reconstructs its state —
  so a template whose requirements can be asked for programmatically is
  a *checkable* prompt assembler. That property doesn't wait for UDON:
  any templating the harness adopts should be interrogable, because
  "what does this template need?" answered by the template is what
  makes assembly verifiable rather than hopeful.

## What this opens (ideas, not designs)

- ✦ **The contract is a schema document.** The interrogation's answer
  ("I need these names, of these kinds") is itself a small schema — so
  it can be printed, versioned, validated against, and even used to
  *generate the question* when a required context member is missing
  (the same schema-generated-ask move the
  [structured-output chapter](structured-output-two-mechanisms.md)
  proposes for tools).
- ✦ **Contract diffing.** If templates compile to interrogable
  contracts, two versions of a template have *diffable requirements* —
  breaking-change detection for prompt assemblers, the way API
  contracts get semver discipline today. "This prompt template now
  demands a field your pipeline doesn't supply" becomes a build error
  instead of a silent misassembly.
- ✦ **Partial application.** Fill the context members you have; emit a
  residual template with a correspondingly narrower contract. Staged
  assembly across agents falls out — one agent binds the stable
  context, a later one binds the session-specific remainder, and the
  contract tracks exactly what is still owed.
- ✦ **Output that explains itself.** The build step could annotate each
  produced node with which template node and which context value made
  it — rendered documents carrying their own derivation. For prompt
  assembly, that is the difference between debugging a prompt by
  staring at it and *querying* it: "which template line injected this
  claim, from which data?"

## Honest edges

Single-source: one author, one morning, zero implementations, no
scenario corpus — by far the thinnest evidence base of any demand
chapter, carried at owner's-stated-vision weight because that is what
it is, and because its *structural* consequences (the product graph,
the addressing coupling) were independently endorsed by two other
reviewers in the same discussion. The earlier-era ease is also honestly
recorded in the source — in Ruby, "output an erb [Ruby's embedded
template form] and run it" made all of this nearly free; under the
present Rust-centric implementation the cost question is real and
unexplored.
