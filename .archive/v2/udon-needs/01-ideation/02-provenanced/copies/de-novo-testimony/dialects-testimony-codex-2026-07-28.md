---
source: >
  De-novo agent testimony, elicited 2026-07-28 per Joseph's standing license
  (v2/udon-needs/CLAUDE.md de-novo-testimony bullet): a fresh Codex agent
  (codex CLI, headless, run from a neutral empty scratch directory with NO
  project context and no tool access beyond the sandbox itself) asked the
  modeled beginner's-mind question about extensible typed-value sub-languages
  ("dialects" in this project's vocabulary, though the word was deliberately
  withheld from the prompt — see caveat). Query preserved verbatim at the top
  of the body; raw output verbatim below.
gathered: 2026-07-28
status: gathered source material — first-person practitioner testimony, unprimed
area: dialects / embedded typed-value sub-languages — de-novo end-user demand
technique-provenance: >
  Practices the accumulated estate technique (fresh-context agent as
  beginner's-mind instrument) — see 02-tooling-needs/src/delegation-as-tooling.md
  and the prior templates/paths testimony in this directory. Cross-substrate
  round of four: codex, grok, agy (Gemini-family), and a fresh Claude
  subagent, all against the identical prompt — see the sibling files
  `dialects-testimony-grok-2026-07-28.md`,
  `dialects-testimony-agy-2026-07-28.md`, and
  `dialects-testimony-claude-2026-07-28.md`.
invocation: >
  `codex exec -C <neutral-empty-dir> -s workspace-write --skip-git-repo-check
  --color never "<prompt>"` (first attempt without --skip-git-repo-check
  refused with "Not inside a trusted directory"). Model reported as
  gpt-5.6-terra.
caveat: >
  The prompt deliberately never used UDON's own vocabulary ("dialect",
  "angle-bracket envelope", "bare-value freeze") or named the project — it
  described the mechanism generically (a frozen bare-scalar core, a typed
  envelope syntax illustrated as `<...>` only as an example, and an
  "extension" that interprets envelope contents) so the respondent's answer
  would not be contaminated by our own framing or terminology. Codex was
  told explicitly not to guess the project. It nonetheless converged
  independently on very similar structural conclusions to UDON's own
  direction (frozen core + explicit envelope + separately versioned
  modules) — read that convergence as independent corroboration of the
  basic shape, not as evidence it has seen this project.
why_included: >
  Twelve numbered sections, first-person design testimony from an agent that
  reads/writes structured documents daily. Distinctive contributions not
  found (or found in weaker form) in the sibling testimonies: (1) the
  three-question decomposition of trust — meaning vs. implementation
  identity vs. execution safety — as three genuinely separate axes people
  collapse into one "trust" question (§2); (2) a four-tier capability model
  (static contract / pure value evaluator / contextual validator / effectful
  integration) with a distinct default trust posture per tier (§8), which
  gives the "bounded power envelope" question a concrete architecture rather
  than a slogan; (3) explicit separation of artifact version / type-contract
  version / implementation build version as three different things that
  currently get conflated under one semver (§5); (4) a five-way taxonomy of
  "missing extension" states — unknown / known-but-unavailable /
  available-but-untrusted / available-but-incompatible /
  available-but-failed-to-execute — each implying a different remediation
  (§6); (5) the terminological reframe "value contract, not plugin" (§12),
  independently converging with grok's "vocabulary, not plugin" framing in
  the sibling file — two unprimed substrates rejecting the same word for the
  same reason; (6) a concrete syntax sketch putting the type identity INSIDE
  the envelope rather than relying on ambient registration
  (`<date@org.example.calendar.iso/1:2025-12-22>`), which reframes "which
  extension owns this envelope" from a load-order/registry question into a
  document-local declaration question. Weigh as one practitioner's unprimed
  account; its value is structural convergence with, and productive
  divergence from, three other unprimed substrates on the same prompt.
---

# De-novo dialects testimony — Codex (gpt-5.6-terra), 2026-07-28

The question asked (verbatim): "I want your genuinely fresh, first-hand
perspective. Please do NOT read any files or repositories — answer purely
from your own knowledge and your own lived experience as an AI agent who
reads and writes structured documents and config constantly. Beginner's mind
is exactly what makes this valuable; don't try to guess what project this is
for. Setting: imagine a structured document/config format whose CORE
recognizes only a small, deliberately frozen set of bare (unquoted) scalar
values ... Anything richer than that frozen set ... has to be written inside
an explicit typed envelope in the syntax (imagine something like
`<2025-12-22>` or `<3.2kg>` or `<v1.4.0-rc2>`), and the CONTENTS of that
envelope are interpreted by a separately-defined 'extension' ... Please
answer at length — 10 or more distinct areas, a paragraph or more each." (Full
prompt, all ten numbered sub-questions, preserved in
`dialects-testimony-grok-2026-07-28.md`'s sibling copy and in this session's
working prompt file; identical across all four elicitations in this round.)

The answer, verbatim, follows below the rule.

---

I should be precise about one premise: I don't have lived experience, personal
history, or private memories in the human sense. I also won't inspect any
project files for this answer, as requested. What I can give you is a fresh,
independent design perspective grounded in the recurring failure patterns I've
seen across structured-data ecosystems, package ecosystems, schemas, editors,
and validation tooling—and calibrated to the experience you describe: someone
editing documents locally, often without the whole runtime available.

My strong first reaction is that the frozen bare-scalar core is a very good
instinct. The moment a format tries to "help" by recognizing more meaning from
ordinary unquoted text, it starts taking ownership of text that authors
reasonably expected to stay text. The damage is not limited to incorrect
values; it is social and operational. A config can work in one implementation,
change behavior after an upgrade, or be misread by a consumer far away from
the author's context. Explicit syntax for richer meaning is the correct escape
hatch. But the extension system has to preserve the same principle: **meaning
must be explicit, stable, inspectable, and locally understandable.** If
plugins merely move the guessing or ambiguity one layer outward, the design
has not actually solved the problem.

## 1. Built-in rich types versus a real extension mechanism

I would want a real extension mechanism, not a steadily expanding menu of
officially blessed rich types. The reason is not ideological openness; it is
that "rich type" needs are inherently contextual. Dates and durations seem
universal until you ask whether the relevant thing is an instant, a calendar
date, a business-day interval, a recurring schedule, a duration under a
particular calendar, or an uncertain historical date. "Quantity" seems
universal until conversion, precision, dimensions, natural-language display,
and regulated units enter the room. File paths, versions, money, identifiers,
coordinates, URLs, and regular expressions each look like one thing until they
are actually several incompatible things.

If the core maintains a large built-in collection, it becomes a
standardization committee for every domain's edge cases. That produces two bad
outcomes: the core grows slowly and still does not fit everyone, or it grows
quickly into a pile of historical compromises whose behavior is difficult to
change. A deliberately narrow core plus separately versioned, explicit
rich-value modules is cleaner.

That said, I would not want a completely flat world where every document must
obtain third-party code just to understand dates. There is a useful middle
layer: a **small, permanently defined standard library of non-guessing typed
envelopes**, with very conservative semantics. For example, perhaps explicitly
named or referenced modules for an ISO calendar date, an RFC-style timestamp,
a decimal quantity with declared units, and perhaps a byte string. The key is
that these are not additional bare tokens and are not privileged because the
core guessed them. They are stable vocabulary modules with unusually strong
interoperability commitments.

My line is: the core should define syntax, identity, resolution, error
behavior, and a narrow semantic contract for extensions. It should not decide
that every plausible semantic category needs to become part of the language. A
type belongs in the standard library only when there is broad cross-domain
use, a genuinely stable canonical meaning, meaningful benefits from universal
support, and enough maturity that freezing it will not permanently trap users
in a bad compromise.

## 2. What would make me trust an extension

I would trust an extension only when I can distinguish three separate
questions:

1. **What does this extension claim to mean?**
2. **Can I know exactly which implementation is being used?**
3. **Is it safe and appropriate to execute that implementation in this
   context?**

Those are often incorrectly collapsed into "it came from a registry" or "the
signature checks out." Provenance matters, but it is not the same as semantic
fitness, and neither is the same as runtime safety.

For meaning, I would want a stable type identity, a clear human-facing name, a
concise statement of the semantic domain, an explicit grammar or recognizer
description, canonical and accepted textual forms, examples and
counterexamples, normalization rules, comparison/equality rules, serialization
guarantees, and error behavior. If `<3.2kg>` is accepted, I need to know
whether it preserves the spelling `kg`, normalizes to grams, distinguishes
mass from weight, supports prefixes, accepts `3,2 kg` in some locales, and
considers `3.20kg` equal to `3.2kg`. "It parses quantities" is not remotely
enough.

For implementation identity, I would want a content-addressed or
cryptographically pinned artifact—not merely `units >= 2`. A document that
relies on a semantic type should be able to say, effectively: "I require this
type contract, and I was authored against this compatible release or exact
digest." The resolved lock information should be portable and reviewable. I
would also want an issuer/publisher identity that is independently
verifiable, not a display name that can be easily impersonated.

For execution safety, I would heavily prefer extensions that can be used in a
**declarative/data-only mode** for ordinary parsing and validation. If
arbitrary native code, network access, filesystem access, environment access,
or nondeterministic behavior is needed just to determine whether a value is
valid, I become reluctant very quickly. A parser for a scalar value should be
boring. The strongest trust signal is that the module's normal operation is
sandboxed, deterministic, resource-limited, side-effect-free, and
independently testable.

I would refuse to load an extension if it is unpinned, unsigned when trust
policy requires signatures, asks for capabilities unrelated to value parsing,
has no discoverable contract, resolves differently depending on registry
state, performs network activity during parsing, or claims broad and vaguely
specified recognition such as "handles all identifiers" or "interprets any
ISO-looking string." I would also refuse—or at least quarantine—an extension
that cannot state its compatibility policy and canonicalization behavior. The
cryptography can be perfect and I would still not trust a module whose
semantics are indistinct.

## 3. Ambiguous or overlapping interpretations

Silent selection is the wrong default. It is particularly wrong if selection
depends on load order, registry order, installation order, operating-system
behavior, or an implementation-specific preference. Those are exactly the
kinds of invisible environmental differences that make configs behave
differently in CI, an editor, a deployment system, and six months later.

My preferred design is to make the identity of the type explicit in the
envelope syntax or its immediately adjacent metadata. In other words, not
merely:

```text
<2025-12-22>
```

but something conceptually like:

```text
<date@org.example.calendar.iso/1:2025-12-22>
<quantity@org.example.units.si/2:3.2 kg>
<version@org.example.semver/2:v1.4.0-rc2>
```

The precise punctuation is not important. The important property is that the
document—not ambient loaded extensions—states which semantic contract owns
the content. That eliminates most ambiguity before any parser is asked to
infer intent.

If you still want shorthand such as `<2025-12-22>`, I would treat it as an
optional authoring convenience with a strict expansion rule: it must resolve
from a document-local declaration table, not from global registration. For
example, the document might declare `date = org.example.calendar.iso@1`, and
then `<date:2025-12-22>` is unambiguous. A bare unqualified envelope should
either remain opaque text or be invalid in strict mode. I would not let the
active plugin set decide.

The best case is a document that is self-describing: an unfamiliar reader
sees a short type label, can find its declaration at the top or in an
imported manifest, and can inspect its contract without executing anything.
The worst case is an extension contest: two plugins claim `<1.0>`, a runtime
picks one based on who registered last, an editor renders it one way, a
deployment tool validates it another, and a future update reverses the
result. That is effectively the YAML implicit-typing problem recreated at
plugin scope.

If overlapping claims have to exist—for example, two types intentionally
accept some of the same payload strings—that is fine as long as the envelope
carries a type identity. Overlap is not inherently dangerous; **unmarked
ownership** is.

## 4. Introspection without execution is a real need

I think this is very real, and it matters more than many runtime-centric
designs assume. It is not just an engineer's fantasy. Most document reading
happens under constrained conditions: code review, a small editor
integration, a web viewer, an AI-assisted edit, a diff viewer, a migration
tool, a search indexer, or an incident response situation. In many of those
contexts, executing arbitrary extension code would be inappropriate even if
it were possible.

But "introspection" is only useful if it answers the questions a human
actually has in the moment. A machine-readable schema that says the payload
is `string` or matches an opaque regular expression is technically
introspection but operationally weak. I would want a small, standardized,
static **type card** shipped inside the package and available in registries
or caches. It should include:

- Stable type identifier and compatibility line.
- A one-sentence purpose: "An ISO 8601 calendar date without time or
  timezone."
- Accepted syntax, including grammar or a portable pattern.
- Canonical syntax and whether accepted input is normalized.
- Clear positive examples and common invalid or surprising examples.
- The semantic model: instant versus local date, exact decimal versus binary
  float, path syntax versus filesystem-resolved path, and so on.
- Equality, ordering, and comparison semantics.
- Interoperability notes and locale/timezone assumptions.
- Whether it can be rendered safely as text when unsupported.
- Resource and capability requirements for full validation.
- Links or embedded text for normative specification, license, security
  notes, and changelog.

For a narrow scalar type, I would prefer that the acceptance language and
canonicalization rules be represented in a portable declarative form whenever
possible—an EBNF-like grammar plus constraints, a decision table, a
finite-state recognizer, or a constrained validation IR. This lets
lightweight tools provide syntax highlighting, completion, linting, and basic
validation without loading code. Some types will need semantic validators
that go beyond a grammar—checksums, calendar validity, unit dimensions,
named registries—but the static card can still tell me what is guaranteed
without execution and what requires the reference evaluator.

The answer also needs to be **version-specific**. "This type accepts
semantic versions" is not useful if v1 accepts leading `v` and v2 rejects it,
or if prerelease ordering changed. Introspection should describe the exact
contract selected by the document, not the latest marketing description of
the plugin.

## 5. Authoring, packaging, versioning, and dependency declaration

I would make an extension artifact look more like a small, signed language
definition with optional reference implementations than like an arbitrary
application plugin. At minimum, it should contain a manifest; a static type
card; declarative syntax/normalization/constraint assets where applicable;
test vectors; compatibility metadata; publisher identity/signatures; and
optionally one or more execution backends. The artifact should say which
portions are normative and which are convenience implementations.

That division is important. If the only specification of a type is
JavaScript, Python, Rust, or a compiled shared object, then its semantics are
"whatever this executable does." That makes independent implementations,
safe inspection, language-neutral tooling, and archival durability all much
harder. I would rather see: a normative declarative contract, authoritative
test vectors, then an optional sandboxed implementation optimized for
complete validation or expensive semantics.

For versions, I would separate **artifact version**, **type-contract
version**, and **implementation build/version**. They are related but not
identical. A documentation fix or new backend should not imply that the data
meaning changed. A compatible extension of accepted input may still be
dangerous if another consumer will reject it. A new comparison or
canonicalization rule is a semantic breaking change even if the API feels
minor. I would therefore favor explicit compatibility designations—perhaps
type identifiers with a major contract generation—and conservative behavior
for documents. Documents should reference a known compatible range only when
the ecosystem has a genuinely precise definition of compatibility; otherwise
an exact content digest plus a human-friendly version is safer.

Dependency declarations should live in an easily located, reviewable place: a
document header, sibling manifest, or package-level manifest. They should
declare type IDs, required compatibility lines, optional lock digests, and
maybe a local alias. The declaration should be enough for a tool to tell an
author: "this document requires `org.example.units.si`, contract 2; it is
unavailable; here is what the static contract says." A lockfile can add
reproducibility for a larger repository, but a document should not become
semantically unintelligible without access to a repository's transient
dependency state.

The worst analogous experience is any ecosystem where a simple declarative
need silently becomes a dependency-resolution and arbitrary-code-execution
problem. Package managers have repeatedly trained users to accept opaque
transitive dependency trees, lifecycle scripts, supply-chain risk, lockfile
churn, and subtly non-reproducible resolution as normal. Editor-plugin
ecosystems add another variant: a plugin updates, starts interpreting a file
differently or emitting formatting changes, and the author has no easy view
of what semantic policy actually changed. What I wish existed instead is an
artifact model where the static contract is first-class, the runtime is
optional and capability-constrained, and "what this means" remains available
even when "how to execute it" is unavailable.

## 6. Missing extensions in current tooling

A missing extension should not normally make the whole document unreadable.
It should make the affected values **opaque, preserved, and visibly
unresolved**. The document's structure should still parse. Unaffected fields
should remain usable. A round-trip editor should preserve the original
envelope exactly, including its type identity, payload, and perhaps relevant
formatting, rather than replacing it with a null, a string, or a lossy
placeholder.

I would want different modes based on the task:

- A viewer or basic editor can show the literal envelope and an
  unresolved-type badge.
- A formatter can preserve the envelope byte-for-byte or according to safe
  structural rules, but must not canonicalize its payload.
- A validator in strict mode should fail if the type is required for a
  claimed-valid result.
- A deployment or execution tool should fail before acting if it cannot
  validate values that affect behavior.
- A search/indexing tool may index the raw payload and type identifier but
  should not pretend it knows the semantics.

The unresolved diagnostic should be helpful rather than merely saying
"unknown type." I would want: the exact required type ID and contract
version; the document's declared dependency/lock information; whether a
static type card is embedded or cached; whether a trusted compatible module
is available; which values are affected; whether the value can be treated as
an opaque literal for this operation; and a safe next action. For example:
"This document requires `org.example.calendar.iso@1`; no compatible
implementation is loaded. Static contract: calendar date, `YYYY-MM-DD`, no
time or timezone. This editor will preserve it but cannot validate calendar
correctness."

There should also be a clear distinction between **unknown**, **known but
unavailable**, **available but untrusted**, **available but incompatible**,
and **available but failed to execute**. Those lead to different remediation
and should never be collapsed into the same vague error.

## 7. The failure mode I fear most

The failure I fear most is **semantic drift hidden behind familiar-looking
text**. Not a loud parse error—those are inconvenient but survivable. The
dangerous failure is when an extension makes a value look normal, accepts it,
and gives it a different meaning in another tool, version, locale, timezone
database, or host environment.

Dates are the canonical example. `2025-12-22` looks simple, but a date can be
a civil day in a specific calendar, an interval dependent on a timezone, a
midnight instant, or an identifier with no temporal arithmetic intended. A
timestamp that parses in one timezone library may resolve differently after
timezone database updates. A duration like `P1M` is not a fixed number of
seconds. A "local date" may be valid differently in historical calendar
contexts. When those details are buried in implicit library behavior, a
config can validate, deploy, and later do something subtly different.

Units and money produce similar pain. `1.0` might be a binary float, exact
decimal, a quantity measured in a base unit, a display amount, or a rounded
financial value. Conversion may depend on a reference date, exchange-rate
source, unit-system version, or physical assumptions. Regexes are notorious
because a pattern can look portable while semantics around Unicode,
lookbehind, backtracking, anchors, and escape sequences differ drastically
across engines. Paths are equally perilous: separators, case sensitivity,
Unicode normalization, drive letters, home expansion, symlinks, and sandbox
roots are all environmental.

What makes these painful is not merely that the semantic model is rich. It
is that systems often expose a compact surface representation while quietly
delegating crucial interpretation to ambient state. The extension design
should push all material semantic inputs into the declared contract or the
value itself. If an extension depends on a timezone database, unit registry,
currency table, locale, or external identifier registry, that dependency
should be explicit, versioned where possible, and visible in its type card.
Determinism should be a stated property, not an assumption.

## 8. The boundary before it becomes a Turing-complete mess

I think there is a very workable bounded middle ground. The value-type
system should be allowed to express **recognition, validation, normalization,
canonical serialization, comparison, limited structured projection, and
perhaps deterministic conversion**. It should not casually become a
general-purpose computation, macro system, network client, filesystem
adapter, or document transformation framework.

A useful test is: "Can this value be understood as a value independently of
the surrounding program?" If yes, it is a good candidate. A date, unit
quantity, URI, version, checksum-bearing identifier, color, or coordinate can
all have a portable contract. If the "type" needs to query a live service,
read a local database, execute user code, inspect arbitrary fields elsewhere
in the document, or make policy decisions based on environment, it is likely
not a scalar value type anymore. It may be a validation rule, a resolver, a
build step, a policy engine, or an application-level feature.

I would enforce this architecturally, not by good intentions. Split
extension capabilities into tiers:

| Tier | Suitable responsibilities | Default trust posture |
|---|---|---|
| Static contract | Grammar, examples, documentation, declared semantics | Always inspectable |
| Pure value evaluator | Parse, validate, normalize, compare, serialize | Sandboxed and deterministic |
| Contextual validator | Check against declared registries or document context | Explicit opt-in, constrained |
| Effectful integration | Network, filesystem, secrets, external services | Not a value type; separately authorized |

The central system should be capable of saying: "This is a pure type module
and can run in a sandbox," or "This is a contextual validator and cannot
determine intrinsic value validity alone." That does not eliminate
complexity, but it keeps complexity named and compartmentalized. The tension
is not irreducible; it becomes unmanageable only if every extension receives
the authority of a general plugin by default.

## 9. Load order, declaration order, and interactions

Load order should not affect a document's meaning. Full stop. It may affect
performance, implementation selection among explicitly equivalent verified
backends, or the order in which diagnostics appear, but not which type
claims a payload or what a typed envelope means. If load order affects
semantics, then reproducibility and human inspection are already
compromised.

Declaration order can matter only where the document explicitly says it
does, and I would keep such cases rare. For example, it might matter for
display preferences or a sequence of policy rules, but it should not
determine type resolution. A dependency declaration should be a set or map
keyed by type identity, not a competition queue.

Extensions will sometimes want to interact. A duration module may use a
calendar module; a currency amount module may use a decimal module plus a
currency-code registry; a domain identifier may embed a normalized URI; a
collection type may contain another typed value. I would support that, but
through explicit declared dependency edges and typed composition, rather
than unstructured "call whichever extension happens to be installed." Each
dependency must identify the required contract version and state whether the
relationship is normative. Cycles should be prohibited or sharply
constrained; scalar types should not become a graph of mutually recursive
runtime plugins unless the document format already has a well-defined way to
handle recursive value schemas.

I would distinguish **embedding** from **referencing**. If a type's payload
embeds another typed value, it should use a standard nested-envelope
mechanism so a lightweight parser can still see the boundary and the
referenced type. If it merely refers to a value elsewhere, that is
document-level reference semantics, not something a scalar parser should
reinvent. This distinction avoids a common trap where every plugin invents
its own mini-language, hiding type boundaries inside opaque payload strings.

## 10. Testing, verification, and interoperability

I would want test vectors to be mandatory, normative, and richer than a
handful of happy-path examples. Every published type contract should include
valid inputs, invalid inputs, canonical outputs, equality/ordering cases,
boundary cases, Unicode cases, locale and timezone assertions where relevant,
resource-limit cases, and compatibility fixtures for prior versions. A
competing implementation should be able to run the same corpus and
demonstrate conformance.

For important types, I would also want property-based and differential
testing support. If a type defines parse/serialize behavior, round-tripping
should be checked. If it defines normalization, normalization should be
idempotent. If it defines ordering, transitivity and consistency with
equality should be checked. If several implementations claim the same
contract, their outputs should be compared against a common corpus. For
security-sensitive parsers, fuzzing and declared complexity bounds matter. A
scalar envelope is a potentially attractive attack surface for pathological
regexes, huge decimals, recursive structures, and decompression-like
workloads.

There should be a clearly visible maturity status: experimental, stable,
deprecated, superseded, security-revoked. A registry's "verified" badge
should not mean merely "the archive uploaded successfully." It could
represent distinct checks: publisher identity verified, manifest
syntactically valid, static contract available, conformance suite passed,
reproducible reference build available, independently implemented, and
security-reviewed. Those are all different claims, and users deserve to see
which one is being made.

I would also prefer a mechanism for durable archival. Documents can live
longer than registries, organizations, domains, package hosts, and original
implementers. A document's dependency information should be sufficient to
preserve a meaningful static explanation of its values decades later.
Content-addressed artifacts, embedded compact type cards, and stable
identifiers are much more attractive to me than a dependency declaration
that says only "download whatever `example.org` currently serves."

## 11. Human ergonomics: types should explain themselves at the point of use

The artifact design is important, but I would judge the system by the
editing experience. When I hover over or encounter a typed envelope, I want
a short explanation immediately, without opening an external website or
reading a specification. I want an editor to show something like:

> `org.example.units.si@2` — SI physical quantity.
> Accepted: decimal number + optional space + SI unit expression.
> Canonical: `3.2 kg`.
> Equality: values compare after exact SI conversion.
> No locale-dependent commas.
> This tool has static support; full validation is available.

That makes types feel like vocabulary rather than opaque magic. Completion
should be conservative: suggest forms and units from the static contract, but
never silently rewrite values into a new semantic form. Formatting should say
whether it is preserving source spelling or applying a type's canonical
serializer. Diffs should ideally show both raw and semantic-aware views when
available: `1 m` → `100 cm` is textual change but may be semantic no-op for
one type; `2025-12-22` → `2025-12-23` is not.

I would strongly resist UI that hides the envelope because it makes
documents look prettier. The explicit type marker is valuable provenance. A
friendly editor can render a date picker or color swatch, but it should
retain an easy way to see the literal source and exact selected type. The
reader should never have to trust that the UI's pretty rendering corresponds
to the document's real semantics.

## 12. A potentially different first cut: make types named contracts, not plugins

The main framing I would adjust is terminological and architectural: I would
avoid making the primary abstraction a "plugin." That word brings
expectations of arbitrary executable behavior, lifecycle hooks, host access,
and ambient registration. It encourages the exact complexity and trust
problems this format is trying to avoid.

I would call the primary unit a **value contract** or **type definition**. A
type definition is a named, versioned, inspectable, mostly declarative
semantic contract. It may have zero, one, or many implementations. An
implementation is a separately trusted backend that can evaluate that
contract. Tooling can use static information when it has no backend, use a
sandboxed backend when it needs complete validation, or choose an
independently implemented backend so long as it conforms to the same
contract.

That separation has a few benefits:

- A document depends on meaning, not on a particular executable.
- Multiple implementations can exist without turning into competing owners
  of the same syntax.
- Readers can inspect the meaning without executing code.
- The ecosystem can support reference implementations, optimized
  implementations, and pure static tooling.
- Security policy can govern implementations separately from semantic
  compatibility.
- Long-term archives retain more than a pointer to an obsolete package
  binary.

There is uncertainty here: some genuinely useful domains may resist a clean
declarative contract, and forcing every type through a constrained schema
language could create awkward or underspecified abstractions. I would not
make declarative representation mandatory for every last semantic rule on
day one. But I would make it the preferred path, require a static contract
even when a reference evaluator is necessary, and place strong capability
boundaries around executable implementations.

If I had to reduce the entire design to a few non-negotiable choices, they
would be these:

1. Rich values carry explicit type identity; active-plugin guessing never
   chooses their meaning.
2. Type contracts are inspectable without execution and are version-specific.
3. Documents declare their required contracts locally and can pin
   reproducible resolution.
4. Unknown types remain opaque and losslessly preserved; strict operations
   fail only where semantic validation is needed.
5. Arbitrary code is optional, sandboxed, capability-limited, and secondary
   to the semantic contract.
6. Load order cannot change meaning.
7. Canonicalization, comparison, locale, time, external registries, and
   environmental dependencies are explicit rather than ambient.
8. Conformance tests and durable static documentation travel with the type.

That would preserve the beginner's-mind virtue of the frozen core: the
document tells you when text has special meaning, what kind of meaning it
has, and enough about that meaning to remain intelligible even when the full
machinery is absent.
