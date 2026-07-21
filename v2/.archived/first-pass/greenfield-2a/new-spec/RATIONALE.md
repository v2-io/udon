# Rationale

**Non-normative.** Why the contract says what it says. Implementers fixing a
bug do not need this file; people weighing a change to the language do.

## One escape, positional

`\` carries four behaviors from one rule: *position decides everything*.
The alternative — a table of escapable characters — grows with the language
and gets memorized wrong. Position does not grow. The cost is that `\` is
literal almost everywhere (Windows paths survive unescaped), which is also
the benefit.

## The commit model over per-character escaping

Prose safety comes from a state (open → committed), not from quoting. This
is what lets Markdown tables, emoticons, and code-ish text live in prose
untouched, at the price of exactly one carve-out (the framed ` ; `), chosen
because trailing annotations (`|li Item ; TODO`) are worth one rule.

## Whose name is it

Attributes-as-edges / children-as-nodes replaces the XML-era "metadata vs.
content" heuristic, which never answered real questions. An edge may
terminate at a node (node values) precisely because "structure must be a
child" was residue of the old heuristic, not a consequence of the model.

## Stacking, not last-wins

Last-wins silently destroys data on the happy path, which contradicts
keep-everything on the sad path. Stacking makes repetition *mean* something
uniform (it is also what makes `.a.b` trait sugar mere desugaring), and
pushes "only one allowed" where proscription belongs: the schema.

## The frozen bare set and the envelope

Every format that recognizes values from bare syntax eventually faces
pressure to recognize more (dates, versions, units), and each accretion
retypes someone's existing document (YAML's Norway problem is the canon
case). UDON freezes bare recognition permanently and gives growth its own
visible, quoted-off space (`<…>`). Additivity is structural, not
disciplinary: a dialect *cannot* reach bare space.

## Keep-everything and two-level severity

A parser that drops or halts converts an author's small mistake into data
loss downstream, and every implementation invents different recovery unless
the spec defines it (the JSON lesson, inverted: JSON wins by rejecting;
UDON's domain — documents, prose, streamed LLM output — wins by keeping).
Defining severity by *loss* (warning = kept, error = lost) makes the levels
checkable instead of vibes-based, and the incomplete-input result separates
"the input ended mid-construct" (a document-level fact) from per-construct
noise.

## Geometric vs. delimited

The two-extent taxonomy is what makes end-of-input behavior derivable
instead of enumerated: geometry closes silently (EOF is a newline),
delimiters warn (a promised closer never came). Any new construct declares
its extent kind and inherits its EOF story.

## The inline-form principle

"No inline form is ever a boundary marker" costs one surprise (`:n value
|{em x} :a 1` swallows the `:a`) and buys a hard invariant: flow is closed
under its own forms, and value parsing never re-enters structure mode
mid-text. The teachable pair — braces inline text, no braces binds a node —
exists because the two readings genuinely both need writing.

## The text law

"Text reconstructs by pure concatenation" forces every whitespace decision
(dedentation is geometry, terminators are text, blank lines are text only
between text) to be made once, in the model, instead of ad hoc in each
consumer. Anything a consumer must consult the source to reconstruct is a
model hole; the law makes holes detectable.

## Designated, not reserved

`$key` as an ordinary quoted-off attribute keeps the model at exactly one
concept (attributes) instead of three (identity, classification,
attributes), makes sugar mechanically verifiable, and lets dumb generators
produce full-fidelity documents. The `$`-quoting friction is the whole
collision defense — convention, not law — mirroring Ruby symbols/Erlang
atoms.

## Bounded lookahead as a language law

Declaring the lookahead bound normative (not an implementation brag) is
what protects streamability from future syntax: a proposal that needs
unbounded lookahead is *ill-formed*, not merely slow.

## Two-level severity, no parser policy

The parse ladder's levels (b)–(e) belong to consumers because only
consumers know the stakes (a config loader and a log-mining pipeline want
opposite strictness). Menu-vs-knob keeps that choice from fragmenting the
language: consumers choose, but from a spec-fixed menu.
