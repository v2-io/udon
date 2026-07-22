# Rationale

**Non-normative.** Why the contract says what it says. Implementers fixing
a bug don't need this file; anyone weighing a change to the language does.
(Distilled from the greenfield-2a rationale + the 0.9 ruling record; the
deeper demand-side grounding now lives in `../udon-needs/`.)

## One escape, positional

`\` carries four behaviors from one rule: *position decides everything*.
The alternative — a table of escapable characters — grows with the language
and gets memorized wrong. Position does not grow. The cost is that `\` is
literal almost everywhere (Windows paths survive unescaped), which is also
the benefit.

## The commit model over per-character escaping

Prose safety comes from a state (Structure Position → committed), not from
quoting. That is what lets Markdown tables, emoticons, and code-ish text
live in prose untouched, at the price of exactly one carve-out — the framed
` ; ` — chosen because trailing annotations (`|li Item ; TODO`) are worth
one rule.

## Whose name is it

Attributes-as-edges / children-as-nodes replaces the XML-era "metadata vs
content" heuristic, which never answered real questions. An edge may
terminate at a node (node values) precisely because "structure must be a
child" was residue of the old heuristic, not a consequence of the model.

## Stacking, not last-wins

Last-wins silently destroys data on the happy path, which contradicts
keep-everything on the sad path. Stacking makes repetition mean something
uniform (it is also what makes `.a.b` trait sugar mere desugaring), and
pushes "only one allowed" where proscription belongs: the schema.

## The frozen bare set and the envelope

Every format that recognizes values from bare syntax eventually faces
pressure to recognize more (dates, versions, units), and each accretion
retypes someone's existing document — YAML's Norway problem is the canon
case. UDON freezes bare recognition permanently and gives growth its own
visible space (`<…>`). Additivity is structural, not disciplinary: a
dialect *cannot* reach bare space. (Rational/complex leaving bare space —
L5 — is this principle applied to our own accretions.)

## Keep-everything and loss-defined severity

A parser that drops or halts converts an author's small mistake into data
loss downstream, and every implementation invents different recovery unless
the spec defines it. JSON wins by rejecting; UDON's domain — documents,
prose, streamed LLM output, half-written files under agent edit — wins by
keeping. Defining severity by *loss* (L0) makes the two levels checkable
instead of vibes-based; the incomplete-input result separates "the input
ended mid-construct" (a document-level fact) from per-construct noise.
There is also a formal reading: sharp, located, typed anomalies are
low-ambiguity observations for agent consumers — the error channel is a
teaching channel, and an unconfounded one only if failed operations don't
mutate.

## Geometric vs delimited

The two-extent taxonomy makes end-of-input behavior derivable instead of
enumerated: geometry closes silently (EOF is a newline), delimiters warn (a
promised closer never came). Any new construct declares its extent kind and
inherits its EOF story. `$partial-key` is the taxonomy's fail-safe applied
to the one construct where acting on a truncation is dangerous.

## The inline-brace principle

"No inline form is ever a boundary marker" costs one surprise
(`:n value |{em x} :a 1` swallows the `:a`) and buys a hard invariant: flow
is closed under its own forms, and value parsing never re-enters structure
mode mid-text. The teachable pair — braces inline text, no braces binds a
node — exists because both readings genuinely need writing.

## The text law

"Text reconstructs by pure concatenation" forces every whitespace decision
(dedentation is geometry, terminators are text, blanks are text only
between text) to be made once, in the model, instead of ad hoc per
consumer. Anything a consumer must consult the source to reconstruct is a
model hole — the law makes holes detectable. It found a real one: the 0.9
flat wire could not reconstruct ownership, and was deratified.

## Designated, not reserved

`$key` as an ordinary quoted-off attribute keeps the model at one concept
(attributes) instead of three, makes sugar mechanically verifiable, and
lets dumb generators produce full-fidelity documents. The `$`-quoting
friction is the whole collision defense — convention, not law — mirroring
Ruby symbols / Erlang atoms.

## Bounded lookahead as language law

Declaring the bound normative protects streamability from future syntax: a
proposal needing unbounded lookahead is *ill-formed*, not merely slow.

## Carve-outs carry their reasons

The one structural addition of 0.9.1: deliberately-open questions travel
with the demand-side reason they are open (CARVEOUTS). Three diligent
clean-room rewrites closed the multi-line question per-construct because
the spec never said *why* it was open — diligence on a wrongly-framed
question produces well-organized irrelevance. An openness that carries its
charter can't be silently re-closed in a dead framing; a judgment
transported without its scope and date becomes law nobody ratified.
