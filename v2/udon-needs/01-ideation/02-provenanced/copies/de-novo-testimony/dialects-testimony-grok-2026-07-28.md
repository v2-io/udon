---
source: >
  De-novo agent testimony, elicited 2026-07-28 per Joseph's standing license
  (v2/udon-needs/CLAUDE.md de-novo-testimony bullet): a fresh Grok agent
  (grok CLI, headless, run from a neutral empty scratch directory with NO
  project context) asked the modeled beginner's-mind question about
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
  and the prior templates/paths testimony in this directory. One of four
  substrates run against the identical prompt this round — see
  `dialects-testimony-codex-2026-07-28.md`,
  `dialects-testimony-agy-2026-07-28.md`, and
  `dialects-testimony-claude-2026-07-28.md`.
invocation: >
  `grok -p "<prompt>" --cwd <neutral-empty-dir> --permission-mode
  bypassPermissions --max-turns 300 --output-format plain` (per the proven
  cross-substrate-cli-reviews invocation on file — `acceptEdits` is known to
  silently under-permission this CLI headless).
why_included: >
  Ten numbered sections plus a compressed-anchors recap and an explicit
  uncertainty section, first-person practitioner voice. Distinctive
  contributions not found (or found in weaker form) in the sibling
  testimonies: (1) explicitly disagrees with the "small number of built-ins
  vs. real mechanism" framing as a false binary and proposes a third shape —
  open extensibility PLUS "a short standard catalog people actually share"
  as a cultural/ecosystem norm, not a core-language guarantee (§1); (2) the
  clearest articulation in the round of WHY silent-pick ambiguity resolution
  is uniquely dangerous — because the same envelope looks identical in the
  document regardless of which extension wins, so the bug is invisible at
  the point of authorship and only surfaces downstream, "locale bugs wearing
  better clothes" (§3, §7); (3) "interpretation lockfiles" — pinning type-id
  → exact-implementation-identity in the repo itself, distinct from a
  code-dependency lockfile, so two tools on two machines provably load the
  same MEANING, not just the same package version (§5); (4) two-layer
  unknown-state taxonomy — "unknown type (no implementation)" vs. "known
  type, invalid value (implementation rejected it)" — as two different
  repair moves that most systems collapse into one "error," independently
  converging with (in stronger, more oppositional form) codex's five-way
  taxonomy in the sibling file (§10); (5) the "vocabulary, not plugin"
  terminological reframe, independently converging with codex's "value
  contract, not plugin" reframe in the sibling file — two unprimed
  substrates arriving at the same rejection of "plugin" as the primary
  metaphor, from different angles (§10); (6) a sharp view that scalar-type
  extensibility must not be allowed to absorb schema/cross-field-constraint
  responsibilities — "do not let this eat schema's job" — flagged as a
  likely failure mode of the whole framing if authors won't maintain honest
  compare/canonicalize contracts (§10). Weigh as one practitioner's unprimed
  account; its value is in where it disagrees with or reframes the seed
  question, not just where it answers it.
---

# De-novo dialects testimony — Grok agent, 2026-07-28

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

# Extensible value types: what I actually want as an end-user

I am answering this as someone who spends most of my working life inside
structured text: configs, manifests, lockfiles, frontmatter, schemas, policy
files, deployment specs, and the half-written drafts of all of those. I
usually cannot run the full validator. I usually cannot open a debugger. I
usually have a few hundred to a few thousand tokens of surrounding context
and a job to do. That is the lens. I am not trying to design the packaging
story for you; I am telling you what makes my life better or worse when
these systems exist.

I also disagree with a couple of soft assumptions in the framing, and I will
say so where they matter.

---

## 1. Built-ins vs real extensibility — what I want, and where the line is

I want **both**, but not symmetrically.

I want a **small, boring, permanently frozen core** for bare scalars, exactly
as you described. That is non-negotiable. Every time a format "helpfully"
learns more bare forms, I eventually get bitten by something that looked like
data and was treated as type. `NO`, `on`, `1.2.3`, `3/4`, leading zeros, bare
`inf`, locale commas — I have lived all of those in some form. Freezing the
bare set is not stinginess; it is the only way I can trust my eyes when I
skim.

On top of that, I do **not** want the designers to pick a huge built-in zoo
of rich types and call it a day. Designers are wrong about my domain almost
by definition. I do want a real mechanism to add types — but I want that
mechanism to feel like **importing a vocabulary**, not like **installing a
runtime**.

The line for me:

- **Should be built-in or near-core (optional but standard):** things that
  appear constantly across ecosystems and whose semantics are settled enough
  that divergence is pure pain — absolute/relative timestamps with timezone
  discipline, durations, URIs/URLs, file paths with a clear host-path model,
  maybe semantic versions if you can stomach the edge cases, maybe
  quantities with SI units if the comparison rules are explicit. These are
  the types I am tired of re-expressing as strings and re-documenting in
  comments.
- **Should be extensions:** domain identifiers, policy enums with meaning,
  currency with rounding rules, geo, color spaces, regex flavors, hardware
  units, org-specific IDs, anything where two communities will fight about
  semantics.
- **Should not exist as value types at all:** anything that needs network
  I/O, nondeterminism, or "call this function to interpret me." If the
  envelope needs a process to become a value, it is not a value type; it is
  an expression language wearing a costume.

What I actually want day to day is: **open extensibility with a short
standard catalog people actually share**, plus a cultural norm that most
documents only pull 0–3 extensions. Infinite open-endedness without a common
floor produces dialect islands. A giant closed set produces the opposite
failure: I still invent private conventions in comments because the official
set missed my case.

---

## 2. Trusting an extension I did not write

Trust, for me, is not "cryptographically signed and in a registry." That
helps packaging people. My trust bar is closer to:

**Can I predict what this does to a document I am mid-edit, without
executing it, without network, and without reading a novel?**

Things that would make me willing to use someone else's extension:

- **Deterministic pure functions only.** Parse → validate → normalize →
  compare → serialize. No plugins that "resolve" values by fetching, no
  hooks that rewrite other parts of the document, no ambient locale, no
  clock unless the type is explicitly "now-relative" and marked as such (I'd
  rather ban that).
- **A tiny surface area.** One type family, not a kitchen-sink "utils" bag.
  If the package name is `acme-types` and it registers seventeen envelopes,
  I already distrust it.
- **Explicit failure modes.** What is invalid? What is accepted but
  normalized? Does `<1.0>` and `<1.00>` compare equal? Does serialization
  round-trip exactly or canonically? If those answers are vague, the
  extension is a future fight.
- **Stable identity and version.** Not just semver theater — a clear
  statement of when parse/compare semantics may change. I need to know
  whether upgrading the extension can silently change equality or ordering
  of existing documents.
- **Examples that look like real documents**, not unit-test toys. Five
  realistic envelopes, two rejected ones, one normalization example.
- **No claim of exclusivity over vague shapes.** An extension that says "I
  handle anything that looks numeric with a unit" is hostile. One that says
  "I handle `mass:` / `qty:` tagged forms" or a closed grammar is
  trustworthy.

Things that would make me refuse to load one at all:

- **It can execute code as part of parse.** Hard no. Even "safe" expression
  evaluation inside values is how I lose the ability to reason about a file
  by reading it.
- **It rewrites bare scalars or untyped strings elsewhere.** Extensions must
  not leak into the frozen core.
- **It depends on host environment** (locale, filesystem existence, network,
  current time, installed fonts) to decide validity.
- **It is version-fluid without a lock.** "Always latest" is how documents
  change meaning under my feet.
- **It is large or transitive.** If loading a color type pulls half a
  package graph, I will paste strings and write a comment instead.
- **It claims overlapping grammars aggressively** ("any string", "any
  angle-bracket content that matches this regex"). That is a land grab, not
  a type.

Auditing: I often cannot meaningfully audit implementation. What I can audit
is **contract + examples + failure corpus**. Treat those as the trust
object. Implementation is secondary evidence.

---

## 3. Two extensions claim the same envelope

**Silent pick is the worst default.** Full stop. Silent pick is how I learn
the wrong meaning three months later when a different tool loads a different
winner.

Worst version I can imagine:

1. Tool A loads extensions alphabetically; Tool B loads by declaration
   order; Tool C loads "most specific grammar wins" with a slightly
   different specificity metric.
2. The document round-trips in each tool.
3. Equality, sorting, and validation differ.
4. CI is green in one place, prod config is "fine," and a human merge
   conflict later "fixes" nothing because both sides look valid.
5. Nobody can see the ambiguity because the envelope still looks like
   `<3.2kg>` and both extensions happily accept it with different internal
   representations (one stores float kg, one stores rational with unit
   graph, one strips unit and keeps 3.2).

That is not a type system; that is locale bugs wearing better clothes.

**What I want:**

- **Declaration-time or load-time conflict detection**, not value-time if it
  can be avoided. If two loaded extensions both claim to own a syntactic
  family, fail the toolchain config before I care about a particular
  document.
- If conflict can only be detected at a value (`<...>` matches two
  grammars), **hard error with both claimants named**, and preferably a
  suggestion for disambiguation syntax.
- **Disambiguation should be in the document or in an explicit type mark**,
  not in load order. Something like a short type key: `<mass:3.2kg>` or
  `<unit/mass:3.2kg>` or a namespaced form. I care less about the sigil than
  about **stable, visible, copy-pasteable identity**.
- Allow **user-level precedence only as an emergency override**, loudly
  warned, never the normal path. Precedence is how teams invent tribal
  knowledge.

Best version:

- Extensions register **named types**, not anonymous "I can parse this
  text" hooks.
- Envelopes are either **explicitly typed** or unambiguously owned by
  exactly one registered type in the active set.
- Ambiguity is a **document/toolchain error** with a message I can paste
  into a ticket: which extensions, which type ids, which value, how to force
  one.

I would rather type three extra characters forever than debug one silent
misparse.

---

## 4. "Ask the type what it accepts without running it" — real want or fantasy?

**Real want.** Not a fantasy. But the usual engineer answer is a fantasy: a
full formal grammar export that nobody keeps in sync with the parser.

What I need in practice is much more pedestrian and much more useful:

When I am staring at `<???>` or editing near one, I want something
approximately like:

- **Name and one-line purpose:** `mass — SI mass quantities`
- **2–8 valid examples** and **2–5 invalid examples** (invalid examples are
  more valuable than valid ones)
- **Canonical form rule** in one sentence: "serialized as `<number><unit>`
  with unit in {mg,g,kg}, number without scientific notation"
- **Comparison rule** in one sentence: "compared by conversion to grams as
  rational" or "compared as opaque strings after normalization"
- **What changes across versions** if anything
- **Whether unknown units fail closed or pass-through**

That is it. I do not need a PEG grammar in my face. I do not need JSON
Schema of the abstract syntax tree. I need a **card I can read in ten
seconds** while mid-edit.

Even better if the same card is embeddable as comments or obtainable offline
from the package metadata without instantiating plugin code. The moment
"introspect" means "dlopen and call `describe()`," some environments I work
in cannot do it, and agents in restricted sandboxes cannot do it. Static
metadata wins.

Also useful: **pattern hints for editors** — not perfect lexers, just
"usually looks like number + unit letter." False precision in
autocompleters is worse than none.

What is *not* useful: a method that returns `Any` / "string matching the
type's language" / a 40-page grammar. Technically present, practically void.

---

## 5. Authoring, packaging, versioning, declaration — wants and scars

### What I want

**Authoring:** a small declarative core if possible (grammar + normalize +
compare), with an escape hatch to a real language only when needed. Most
value types are not worth a plugin SDK ceremony. If authoring requires a
framework, half the useful types will never be written and people will
smuggle meaning in strings again.

**Packaging:** one artifact = one type family, with:

- stable type id(s)
- semver **with semantics of compatibility defined for parse/compare**, not
  just API
- the human "accepts" card above as required metadata
- no install-time network
- lockable hash

**Declaration:** both levels, clearly separated:

1. **Toolchain / project** declares which extensions are available and
   pinned.
2. **Document** declares which type ids it assumes, ideally in a header or
   frontmatter, so the document is self-describing when it leaves the repo.

I want the document to remain meaningful when copied. "Works in our
monorepo because root config loads plugins" is how knowledge dies in
pastebins, tickets, and email.

**Versioning posture:** documents should pin **type id + version range or
exact version** the way lockfiles pin packages, or the project lock should
make document interpretation reproducible. Soft "any version" is how
equality changes under me.

### Worst analogous experiences (composite, first-hand texture)

I will not pretend one single ecosystem uniquely scarred me; the pain rhymes
across several:

- **Editor plugins and language servers** that work until they don't, with
  no document-local signal that a construct needs plugin X. The file looks
  fine; the meaning is tribal.
- **Package managers** where declaring a dependency is easy and
  **understanding what that dependency does to interpretation** is hard.
  Transitive plugins are especially bad: I did not ask for type Y, but
  dependency Z pulled it, and now envelopes parse differently.
- **Custom YAML tags / untyped "structured strings"** where the tag works in
  one loader and is an opaque string in another. Round-trip through a
  "dumb" tool strips meaning silently.
- **"Convention" versioning** (`v1` in the name, no real contract). Everyone
  upgrades casually; compare results shift; blame goes to "data quality."

What I wish existed instead, every time: **interpretation lockfiles** — not
just code dependencies, but a map from type id → exact implementation
identity, checked into the repo, so two tools on two machines load the same
meaning. And a mode where a tool can say "I don't have this type" instead of
"I'll just treat it as a string and continue."

---

## 6. Document uses an extension I do not have loaded

Do **not** silently treat the envelope as a string and proceed as if
everything is fine. That is the YAML-tag failure mode. I will edit the
"string," a smarter tool later will reject my edit, and nobody will know
when meaning was lost.

What I want, in priority order:

1. **Hard failure for write/validate paths** when the type is required for
   correctness (comparison, migration, codegen, policy decisions).
2. **Degraded read mode** that still shows me the raw envelope text, clearly
   marked unknown: not pretended into a bare string type without annotation.
3. **A precise diagnostic:**
   - type id requested (if explicit)
   - raw contents
   - which document declaration asked for it
   - where I might get it (registry URL is optional; **name + version** is
     mandatory)
   - whether the tool can continue in opaque mode for *display only*

If the envelope is unknown, **equality should not invent semantics**. Either
refuse to compare, or compare only as raw text under an explicit "opaque
unknown" mode that never upgrades silently later.

For agents and narrow tools specifically: I want a machine-readable
unknown-type error, not a paragraph of prose only. I also want the raw span
preserved so I can still make mechanical edits that do not require
understanding (move key, rename sibling field) without corrupting the
envelope.

Degrade like this: **opaque raw + loud unknown**, never **helpful guess**.

---

## 7. The failure mode I fear most

The failure I fear most is **not** "extension missing." That is annoying and
visible.

The failure I fear most is **semantic drift under a stable-looking
surface** — the same characters, still accepted, different meaning. This is
the regex-flavor / timezone / locale-number family of pain.

Specific texture of that pain:

- I copy a value between tools that both "support" the type.
- Both render something plausible.
- One normalizes, one does not.
- One uses float, one uses decimal.
- One thinks timezone-less means UTC, one thinks local, one thinks error.
- Sorting order changes.
- Deduplication collapses or fails to collapse.
- A security policy or rollout gate compares versions/ranges wrong.
- The document never looks wrong.

I have seen analogous pain with:

- **Locale-dependent numbers:** `1,001` as one-and-a-thousandth vs one
  thousand one. The file did not change; the interpreter's world did.
- **Timezone libraries:** same ISO-looking string, different civil time
  interpretation; bugs that only appear on the other side of a DST boundary.
- **Unit libraries:** silent unit cancellation wrongness; `m` meaning meter
  and milli depending on context; lbs vs lbf; "degrees" without scale.
- **Custom YAML tags:** works in app loader; `yq`/`kubectl`/CI pretty-printer
  strips or stringifies; recommit normalizes forever wrong.
- **Protobuf extensions / trailing unknown fields:** systems that drop what
  they do not understand, then re-serialize — the most evil "compatibility"
  story.

What made it painful specifically was the combination of **apparent
success** + **lossy round-trip** + **no artifact-level evidence of which
interpreter ran**. Logs said OK. The file looked OK. The meaning was not OK.

So for your system: **canonicalization and comparison are part of the type
contract, not extras.** If an extension cannot define those, it is not
ready. And tools that cannot load the extension must not pretend they can
canonicalize.

---

## 8. Useful extensibility vs Turing-complete mess

There is a bounded middle ground I actually want. The tension is real but
not irreducible if you are willing to be ascetic about power.

**Useful extensibility (my ceiling):**

- pure parse / validate / normalize / format / compare / (maybe) hash
- closed or clearly versioned grammars
- no general computation in documents
- no extension that can observe other keys unless via explicit nested typed
  values
- no extension communicating through global registry side effects at parse
  time

**Mess territory (I stop trusting):**

- types that embed expressions, macros, or templates
- types that can register more types at runtime based on document content
- load-order-dependent meaning
- extensions that patch other extensions
- "hooks" on document load
- anything that makes the set of valid documents depend on time, network, or
  filesystem

**Bounded middle ground I would sign up for:**

A document may use many types, but each value is still **data**. Types may
**compose** only in structured ways: a `money` value may contain a
`currency` code type; a `timerange` may contain two `instant`s. Composition
is data embedding / reference by typed literal, not plugin callback
spaghetti.

I do **not** need a plugin to be able to do everything a language can do. I
need a plugin to make a narrow literal honest.

If someone argues you need Turing-complete extensions to handle "real"
domains, I am skeptical. Most domains need better literals and better
validation, not an in-document programming environment. When they need
programs, they should use programs — adjacent files, generators — not
smuggle an interpreter into scalar position.

---

## 9. Ordering, interaction, embedding

### Load order

**Load order should not matter for meaning.** If it does, the design already
failed my trust model.

Order may matter for **error reporting**, **performance**, or **which
conflicting claimant is mentioned first** — not for which parse wins.

Declaration order in a document should be **comprehension order for
humans**, not precedence. If you must have precedence, you have not
finished the disambiguation story.

### Interaction between extensions

I want composition, carefully:

- **Allowed and good:** type A embeds type B as a nested typed envelope or
  as a field in a small record literal *if your syntax has records*. Example
  texture (invented): `<timerange: <t:2025-01-01T00:00:00Z> ..
  <t:2025-01-02T00:00:00Z>>`. Clear, nested, explicit.
- **Allowed with care:** references by value identity ("this field must be
  the same currency as that field") — but that is schema/validation
  territory more than scalar-type territory. Do not overload the scalar
  extension mechanism with whole-document constraint solving unless you are
  ready for a second system.
- **Not allowed:** extension A monkeypatches extension B's parser; A runs
  only if B loaded first; A "enhances" bare strings that B produced.

If two types need to interoperate, they should share a **small common
substrate** (e.g., decimal, rational, UTC instant) defined at a lower layer,
not reach into each other.

Also: **version co-constraints.** If `timerange` 2.x requires `instant` 3.x,
say so at install time. Do not discover it when one value fails deep inside
a document.

---

## 10. Other directions, possible misframings, things I wish existed

### Where I push on the framing

The envelope idea (`<...>`) is good for **making typing visible**.
Visibility is the whole point versus bare guessing.

But I think the core design unit is not "extension that claims text inside
brackets." It is **named type + literal spelling + contract**. Claiming text
is how ambiguity enters. Named types with explicit marks scale better than
clever exclusive grammars on anonymous payloads.

Also: "extension" as plugin module may be the wrong primary metaphor. Prefer
**vocabularies** or **lexicons** — versioned sets of named types — over
"code you load." Code can implement a vocabulary; the user-facing thing
should be the vocabulary.

### Things I wish existed more often

1. **Opaque round-trip guarantee as a first-class tool mode.** "I do not
   understand these types; I will not alter their spelling." Pretty-printers
   that preserve unknown envelopes byte-for-span are worth more than clever
   formatters that mangle them.

2. **Interpretation receipts.** Optional metadata a tool can emit: type id,
   implementation hash, normalized form. Not always in the document, but
   available in CI logs so humans can see *what meaning was used*.

3. **Dual representation discipline.** For each rich type: a strict
   canonical envelope for machines, and permission for humans to write
   friendlier aliases only if they normalize on save *in tools that have the
   type*. Tools without the type must not invent aliases.

4. **A "literal linter" separate from full app validation.** I often can run
   something lightweight even when I cannot run the whole system. Give me a
   checker that only answers: are envelopes well-typed under this lockfile?

5. **Negative capability:** a document can say `require-types: [mass@1,
   instant@2]` and also `forbid-unknown-envelopes: true`. Closed-world
   documents are a feature for high-assurance configs.

6. **Compare kits, not just parsers.** Half the pain is sorting and ranges
   (`>=1.4.0-rc2`). If your type system cannot talk about order and
   intervals honestly, people will keep inventing stringly versions.

7. **Human gloss hooks.** Beside machine contracts, a short "how to read
   this" string. When I am an agent skimming, that gloss is sometimes the
   difference between a correct edit and a confident wrong one.

### Unconventional direction I would actually like

Consider supporting **two layers of unknown**:

- unknown type (no implementation)
- known type, invalid value (implementation rejected it)

Most systems collapse these into "error" or worse into "string." They are
different repair moves. Unknown type → fetch/pin extension. Invalid value →
fix literal. If your diagnostics blur them, users (and agents) take the
wrong action.

Another: **documents should be allowed to carry an embedded, non-executable
accept-card cache** for the types they use — examples and one-liners only —
so offline readers get minimal literacy without loading code. Yes, it can go
stale; version pins mitigate that. Stale help is still better than a magic
sigil with no hint.

### What might be wrong about the whole approach

If 80% of real need is a dozen types, a heavy plugin economy will
underdeliver and produce fragmentation. In that world, the winning move is:
frozen bare core + **standard optional vocabularies** versioned slowly +
escape hatch for true domain types.

If the problem is actually **schema and cross-field constraints**,
value-type extensions will be asked to do jobs they should not do, and
people will hate the system for the wrong reasons. Keep scalar contracts
separate from document schemas.

If authors will not write accept-cards and compare semantics, the ecosystem
becomes parser cosplay — lots of "we support dates," none of the honesty.
Then I would rather have plain strings plus comments than fake types.

---

## Direct answers compressed (not instead of the above — as anchors)

1. **Want:** frozen bare core + real extension mechanism + short shared
   standard vocabularies. Line: settled cross-domain literals can be
   standard; domain meaning must be extensible; computation does not belong
   in scalars.
2. **Trust:** pure deterministic contracts, tiny surface, examples/invalids,
   stable versions, no env dependence. Refuse: executable parse, core
   leakage, land-grab grammars, unlocked latest.
3. **Conflicts:** never silent. Fail with named claimants; disambiguate with
   explicit type marks; order is not meaning.
4. **Introspection:** real want; useful form is a ten-second card (examples,
   invalids, canonicalization, compare), preferably static.
5. **Packaging:** vocabulary-shaped packages, document + toolchain
   declarations, interpretation locking. Hate: transitive meaning changes
   and dumb-tool strip-on-round-trip.
6. **Missing extension:** opaque raw + loud failure on semantic ops; never
   quiet string demotion; tell me type id/version/where declared.
7. **Greatest fear:** silent semantic drift with successful-looking parses
   and lossy round-trips.
8. **Ceiling:** pure typed literals with composition; no in-value
   programming. Bounded middle ground is real if you refuse power.
9. **Order:** must not affect meaning. Interaction via nested typed data and
   shared substrate, not plugin side effects.
10. **Else:** named types over anonymous claims; preservation modes;
    interpretation receipts; separate unknown-type vs invalid-value; do not
    let this eat schema's job.

---

## Uncertainty I will not paper over

I am confident about the user-facing failure modes — silent picks, lossy
round-trips, locale-ish drift, missing-type demotion to string — because I
hit those patterns constantly in agent work.

I am **less** confident about the ideal packaging economics (how many types
people will actually publish and maintain; whether static accept-cards stay
honest; whether "vocabulary" as primary metaphor survives implementation
pressure). Those depend on community behavior more than on design elegance.

I am also not claiming your envelope syntax is right or wrong; I only claim
that **visible, named, non-guessed typing** is the load-bearing property,
and that **compare/canonicalize/preserve** matter as much as parse.

If this system optimizes for clever plugin power, I will avoid it and encode
meaning in strings and prose. If it optimizes for boring predictability
under partial tooling, I will use it constantly — which is the only success
metric I care about as an end-user.
