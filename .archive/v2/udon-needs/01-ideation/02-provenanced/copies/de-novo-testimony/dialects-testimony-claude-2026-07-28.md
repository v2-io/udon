---
source: >
  De-novo agent testimony, elicited 2026-07-28 per Joseph's standing license
  (v2/udon-needs/CLAUDE.md de-novo-testimony bullet): a fresh Claude
  subagent (Agent tool, general-purpose, NO project context, no tools
  granted for this task — told explicitly not to read files, search the
  web, or use any tool) asked the modeled beginner's-mind question about
  extensible typed-value sub-languages ("dialects" in this project's
  vocabulary, though the word was deliberately withheld from the prompt —
  see the codex sibling file's caveat, which applies identically here).
  Query preserved verbatim at the top of the body; raw output verbatim
  below.
gathered: 2026-07-28
status: gathered source material — first-person practitioner testimony, unprimed
area: dialects / embedded typed-value sub-languages — de-novo end-user demand
technique-provenance: >
  Practices the accumulated estate technique (fresh-context agent as
  beginner's-mind instrument) — see 02-tooling-needs/src/delegation-as-tooling.md
  and the prior templates/paths testimony in this directory. Same-family
  variant: this is a Claude subagent rather than a cross-substrate CLI, run
  alongside three genuinely cross-substrate elicitations this round
  (codex, grok, agy/Gemini-family) — see `dialects-testimony-codex-2026-07-28.md`,
  `dialects-testimony-grok-2026-07-28.md`, and
  `dialects-testimony-agy-2026-07-28.md`. Included for completeness and
  because it independently converges with and diverges from the
  cross-substrate results in specific, citable ways (see below); weigh its
  same-family status accordingly — it corroborates less independently than
  the other three, but its divergences from them are still informative.
why_included: >
  Ten numbered sections, first-person practitioner voice. Distinctive
  contributions not found (or found in weaker form) in the sibling
  testimonies: (1) the clearest articulation in the round of a
  three-tier authoring model — full-code extensions, but with a
  **declarative tier below them** (pattern + canonical-form rule, no code at
  all) for the large fraction of real-world types that are just fixed
  regexes/enums/formats, which "would make the trust question... almost
  disappear for that whole tier" (§10, closing); this sharpens (rather than
  duplicates) codex's four-tier capability model and grok's "declarative
  core with an escape hatch" by naming the declarative tier as a
  DEFAULT authoring path, not just a possible one; (2) a "canonical form
  promise per extension" pitched explicitly via the `gofmt` analogy — one
  true formatted output per compliant tool, so diffs stay meaningful across
  syntactically-flexible input (§10), a concrete named precedent none of the
  cross-substrate testimonies cited; (3) a push on the "opaque text
  interpreted by a plugin" mental model itself, proposing instead that
  envelope contents remain a small CLOSED sub-grammar at the lexical level
  (core still constrains characters/shape) with the extension merely
  assigning semantics — which would let an unaware tool distinguish
  "well-formed nonsense" from "garbage" even without the extension loaded,
  and forecloses control-character/structure-breaking smuggling (§10); (4)
  explicitly flags **extension-own-version migration** as an open question
  none of the ten sub-prompts asked about and none of the other three
  testimonies raised on their own: what happens when an extension's OWN
  accepted grammar changes between ITS versions, distinct from the
  document-format's versioning story (§10). Read this file's independent
  value primarily in these four points, since its baseline coverage
  substantially overlaps codex/grok/agy on trust, ambiguity, and
  missing-extension behavior (a genuine four-way convergence worth noting
  in synthesis, not a defect of this file).
---

# De-novo dialects testimony — fresh Claude subagent, 2026-07-28

The question asked (verbatim, full ten-part prompt identical across this
round's four elicitations — see `dialects-testimony-codex-2026-07-28.md` for
the complete text): a context-free ask about what an AI agent wants from a
structured-document format whose core recognizes only a small frozen set of
bare scalars, with anything richer expressed inside an explicit typed
envelope (illustrated as `<2025-12-22>`, `<3.2kg>`, `<v1.4.0-rc2>`) whose
contents a separately-defined "extension" interprets — covering built-in vs.
extensible, trust, ambiguity resolution, introspection-without-execution,
packaging/versioning/declaration, missing-extension behavior, worst feared
failure modes, the Turing-complete-mess boundary, load-order/interaction, and
open-ended reframing.

The answer, verbatim, follows below the rule.

---

Here's my honest, unresearched take — genuinely from the seat of "someone
who reads and writes structured docs constantly, usually through narrow
tools."

## 1. Built-in richness vs. a real extension mechanism

I want both, but I want them to feel different in kind, not just in
cardinality. A small frozen bare-scalar set (string/number/bool/null-ish)
plus a *real* extension mechanism is the right shape — but the thing I
actually crave day-to-day is a **small, curated, "blessed" set of
extensions that ship with every compliant toolchain**, even though they're
technically extensions and not core types. Dates, durations, and maybe
semver are so universal that if every toolchain implements them slightly
differently (or not at all), the format's promise of "clear even without
tooling" breaks immediately for the single most common case. So: core stays
frozen and honest about not guessing, but there's a "standard library" of
extensions that ships with the reference implementation, is versioned in
lockstep with core, and any tool claiming compliance with core vX.Y is
expected to bundle it. Beyond that standard library, yes, I want genuine
third-party extensibility — but I want it to feel like reaching for an
unusual tool, not like the normal path. The line for me: if I have to
install something to parse a *date*, the format failed at its most basic
promise. If I have to install something to parse a *chemical formula* or a
*domain-specific part number*, that's completely reasonable and expected.

## 2. Trusting an extension I didn't write

This is the crux, and I think about it the same way I think about VS Code
extensions or npm packages I'm about to add to a build. What would make me
trust one: (a) it's pure — no ambient I/O, no network calls, no filesystem
access, just text-in/value-out — because a "value type parser" reaching out
to the network for validation is the single most alarming thing I can
imagine in this context; (b) it has a tiny, readable reference
implementation I can skim in under two minutes, ideally in a boring
language, ideally with the parse/format/compare logic being the *entire*
surface area — no plugin-within-a-plugin hooks; (c) it declares upfront, in
a structured and machine-checkable way, exactly what envelope tag(s) it
claims and what its accepted grammar looks like (see #4); (d) it's been
exercised by a differential/round-trip test suite that ships with it
(parse→format→parse is identity, or at least documented where it isn't) so
I can trust it's not silently lossy. What would make me refuse outright:
anything that executes arbitrary code as part of "validation" beyond its
own declared grammar (e.g., a "quantity" extension that lets you register
arbitrary unit-conversion formulas via eval), anything undocumented about
what characters/bytes it will accept, and — this is a gut reaction more
than a principled one — any extension whose author is anonymous/unverifiable
and whose install path is "download and load this file" rather than going
through some registry with at least a paper trail. I don't need
cryptographic proof of correctness. I need to be able to look at it, and I
need there to be a paper trail if it turns out to be wrong.

## 3. Ambiguous envelope claims

The worst version is silent, order-dependent, "whichever loaded last wins"
resolution — because then the same document parses differently depending on
which other document you happened to open first in your session, or which
order your toolchain happened to scan a plugins directory. That's the
YAML-implicit-typing bug reborn one layer up, except now it's not even
deterministic across environments. The best version, I think, is: envelope
*tags* (the thing inside `<...>` right after the opening bracket, like a
namespace or type-name) are supposed to be unique identifiers by
construction — so "ambiguity" shouldn't normally arise from two extensions
both claiming to interpret the same *tag*; it should be a load-time
**registration conflict**, refused loudly at load time, not deferred to
parse time per-value. If instead you mean "two different extensions both
plausibly want to claim untagged/bare-ish content" — that shouldn't be
possible at all if envelopes always require an explicit tag; ambiguity
should be structurally prevented, not resolved. If the tag itself is
ambiguous (two packages both register "date"), that's a namespacing
problem, and the fix is scoped/qualified names (`<vendor:date>` or similar)
with a short unqualified form allowed only when there's no conflict in the
*current* toolchain's active set — and the toolchain should refuse to
start, not silently arbitrate, when two loaded extensions collide on the
same short name. Fail fast, at load time, with a specific "extensions X and
Y both claim tag `qty` — disambiguate in your toolchain config" error.
Never at read time, never silently, never non-deterministically.

## 4. "Ask the extension what it accepts, without running it"

This is a real want, not a fantasy, but I think the naive version of it
(some formal grammar description language that the extension publishes)
undersells what I actually need. What I want in the moment I'm hand-editing
a document in a narrow tool with no validator running is much more
mundane: **one or two good examples and a one-line human-readable
description, embedded right where I need them** — ideally surfaced by
hover/autocomplete in an editor, but failing that, discoverable via a
single command like `toolname describe-type qty` that prints "Quantity: a
number followed immediately by a unit abbreviation, e.g. `3.2kg`, `450ms`,
`12px`. Units come from UCUM plus these additions: ...". A formal grammar
(EBNF, regex, whatever) is nice to have as a secondary, more precise
reference, but it is not what I reach for while typing — it's what I reach
for when something already broke and I need to understand exactly why. So:
yes to a static "describe yourself" capability, but the bar for *useful* is
"reads like a man page with examples," not "exposes a parseable grammar
object." A grammar-only answer with no prose and no examples is technically
present but not useful — I've hit that wall with regex flavor docs and
protobuf field docs more times than I can count, where the formal
definition is right there and I still can't tell what will actually be
accepted at the edges.

## 5. Authoring, packaging, versioning, declaring as a dependency

I want it to look almost exactly like a dependency in any modern package
manager: a name, a semver, a small manifest describing what tag(s) it
registers and what capabilities it implements (parse/format/compare/validate
— not all extensions need all four), and a document or toolchain config
declares a pinned or ranged version requirement the same way a
`package.json`/`Cargo.toml`/`mix.exs` would. My worst first-hand analogous
experience is honestly just... regular npm transitive dependency hell, but
the sharper, more specific pain that maps onto *this* domain is
Babel/webpack plugin ordering and config-schema drift — where two plugins
each subtly change how the other's output should be interpreted, and the
failure only shows up in production, and nobody can tell you which plugin
is "responsible" for the wrong output because the composition itself was
the bug. The other close analog is custom YAML tags (`!!python/object`,
Ruby's `!ruby/object`) — deserializing an unfamiliar tag from an untrusted
document has literally been a remote-code-execution vector in real
ecosystems, and that history should weigh heavily here: I want the manifest
to make it structurally impossible for "load extension" to mean "execute
arbitrary deserialization code," the way early YAML tag handling did. What I
wish existed instead of what I've experienced: a registry with **mandatory
example-based tests bundled in the package itself**, checked automatically
at publish time, so "this extension parses `<3.2kg>` as {value:3.2,
unit:"kg"}" is not just claimed in prose but enforced as a contract the
registry itself verifies before listing it — closer to how some registries
require passing tests before a release is indexable, though I don't think
I've seen this done well anywhere, more felt-missing than seen-and-envied.

## 6. Missing extension at read time

I want a clearly distinguishable **degraded-but-safe** mode by default: the
toolchain should still be able to tokenize the document structurally (it
knows where the envelope starts and ends, because envelope delimiters are
core syntax, not extension-defined), and it should treat the *contents* as
an opaque, unvalidated, unformatted string — round-trippable losslessly,
displayed with a clear marker like "⚠ unknown type `qty`, raw: `3.2kg`" —
rather than either silently coercing it to a plain string (which lies about
its type) or hard-failing the whole document (which is far too brittle for
something I'm just trying to *read*, not validate). Failing loud should be
reserved for operations that actually need the semantics — if I ask the
tool to *sort by* or *validate against schema* a field of an unknown type,
that's the moment to error, with a message naming exactly which tag is
missing and, ideally, where to get it (a registry URL or package name from
the manifest, if the document declares its extension dependencies up front
— which it should, the same way a lockfile declares its deps). The
information I want in that moment: which tag, which extension package would
satisfy it (if knowable), and confirmation that my read-only view of the
rest of the document is unaffected.

## 7. The failure mode I fear most

Silent semantic drift between two "compliant" implementations of the same
extension — not a crash, not a parse error, but two tools that both claim
to support `<duration>` and both accept `1mo` but one means calendar-month
and the other means 30-days-flat, and nothing about the document, the tag,
or either tool's error output tells you they disagree. This is exactly the
shape of my worst real experience: timezone/DST arithmetic across libraries
(moment.js vs date-fns vs whatever the backend used), and locale-dependent
number parsing where `1.234` is one-thousand-two-hundred-thirty-four in one
locale and one-point-two-three-four in another, both silently "successful"
parses producing wildly different numbers with zero indication anything
went wrong. The pain specifically is that these bugs don't announce
themselves — they produce a plausible, typed, valid-looking value that is
simply *wrong*, and they surface downstream, disconnected from the parse
site, often in a context where nobody thinks to suspect the value type
layer at all. For an extensible value-type system, the only real defense I
can think of is mandatory disambiguating test vectors bundled with the
extension and run at load time against the local implementation to catch
drift between "the extension as specified" and "the extension as this
particular toolchain implements it" — belt-and-suspenders, not a full fix.

## 8. The extensibility-vs-Turing-complete-mess line

For me the line is squarely about **whether an extension can affect
anything outside its own envelope**. Parse this text, produce this typed
value, format it back, compare two of them — that's a closed, boring,
auditable operation and I'm comfortable with unlimited richness *within*
that box (a units library can be as sophisticated as it wants internally).
The moment an extension can conditionally change *document structure*,
reference *other parts of the document*, do *cross-field validation*, or
*execute during a build/render step* with side effects, I've mentally left
"value type system" and entered "embedded programming language," and that's
where my trust drops to near zero — because now reading the document's
meaning requires simulating the extension's code, for every extension, in
combination, which is exactly the "config file that's secretly
Turing-complete" trap I've been burned by with things like Jsonnet, Dhall
(which tries hard not to be, admirably), and Terraform's evaluation model. I
don't think the tension is fully irreducible, but I do think it requires
the designers to be willing to say "no" to genuinely useful-sounding
requests like "let my quantity type reference a unit-conversion table
defined elsewhere in the document" — that's exactly the kind of
cross-envelope reference that starts the slide, however reasonable it
sounds the first time someone asks for it.

## 9. Ordering and interaction

Load/declaration order mattering *at all* is, to me, itself close to a bug
in the design — it means the system has some ambient global mutable
registration state that later declarations can silently override, which is
the same class of problem as #3. I'd rather the set of active extensions in
a given toolchain invocation be an unordered *set* (conflicts on tag names
are load-time errors, not order-broken-ties), so order literally cannot
matter, full stop, and nobody has to remember or document "load X before
Y." As for extensions embedding or referencing each other — I'm wary but
not opposed: a `<coordinate>` type that internally contains two
`<decimal-degrees>` values, where the outer extension explicitly depends on
(declares a dependency on) the inner one via the same package-manager-style
mechanism as #5, feels fine and is genuinely useful (composability of small
well-tested pieces). What feels unsafe is *implicit* interaction —
extension A quietly detecting and special-casing behavior when extension B
happens to also be loaded, with no declared relationship between them. If
interaction exists, I want it declared as an explicit dependency edge,
checkable statically, not discovered as emergent behavior.

## 10. Other directions / reframing

A few things I'd push on: First, I'd want the frozen-bare-set decision to
come with an equally strong, equally frozen **"canonical form" promise per
extension** — i.e., part of what an extension registers is not just "what I
accept" but "the one true way I will always format," so round-tripping
through any compliant tool converges to the same textual representation,
the same way `gofmt` removed an entire class of bikeshedding by having
exactly one output style. That would make diffs meaningful again even
across values with syntactic flexibility inside the envelope. Second, I
keep wondering whether "envelope contents are opaque text interpreted by a
plugin" is even the right mental model, versus "envelope contents are a
small closed sub-grammar (number, hyphen, alpha token, etc.) that the
*extension* merely assigns semantics to, but whose lexical shape is still
constrained by core" — the latter would let an unaware tool at least know
an unknown-tagged value is "well-formed nonsense" versus "garbage," which
helps a lot with the degraded-mode story in #6, and prevents an extension
from smuggling in, say, embedded newlines or control characters that break
the surrounding document's structure. Third — and this might be out of
scope for what you're asking, but it's the thing that actually worries me
most as a daily user — none of this addresses *migration*: what happens
when an extension changes its accepted grammar or canonical format between
its own versions, and a document written against v1 needs to still parse
under v2 tooling. Extensions need their own compatibility/deprecation
story, not just the top-level format's. Finally, I'll gently push back on
the framing that authoring an extension needs to be as heavy as "define a
full parser/formatter/comparator module" for every case — a huge fraction
of real-world envelope types (identifiers matching a fixed regex, enums,
fixed-format codes) would be well served by a *declarative* extension tier
(just a pattern + a canonical-form rule, no code at all) sitting below the
full-code tier, which would also make the trust question in #2 almost
disappear for that whole tier, since a regex-plus-metadata file is
trivially auditable in a way arbitrary code never fully is.
