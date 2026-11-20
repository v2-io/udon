---
source: >
  De-novo agent testimony, elicited 2026-07-28 per Joseph's standing license
  (v2/udon-needs/CLAUDE.md de-novo-testimony bullet): a fresh agy (Gemini-
  family) agent, headless, run from a neutral empty scratch directory with
  NO project context, asked the modeled beginner's-mind question about
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
  `dialects-testimony-grok-2026-07-28.md`, and
  `dialects-testimony-claude-2026-07-28.md`.
invocation: >
  `agy -p "<prompt>" --dangerously-skip-permissions --sandbox
  --print-timeout 20m` (per the proven cross-substrate-cli-reviews
  invocation on file — default permission mode auto-denies headless).
why_included: >
  Ten numbered sections, terser than the other three substrates in this
  round but with two genuinely novel contributions not found (in this form)
  anywhere else in the corpus: (1) **"Degradation Contract"** (§10) — a
  requirement that an extension declare, as part of its own definition, what
  frozen bare-core primitive its value most closely degrades to if the
  extension cannot be loaded/executed at all (e.g. a duration degrades to a
  bare integer count of seconds; a color degrades to an RGB array) — turning
  "unknown extension" from a binary opaque-or-fail choice into a third,
  mathematically-safe option that lean/agentic tooling can still operate on
  without understanding the rich type. This reframes the missing-extension
  question (which every other testimony in this round treats as
  opaque-preserve vs. hard-fail) with a third axis none of the others
  proposed. (2) The most concrete take in the round on how composition
  should be barred structurally rather than by policy: extensions must not
  be allowed to recursively invoke the parser on substrings they own — list
  composition happens at the CORE AST layer (the format provides the list
  primitive; extensions populate elements), explicitly to block
  billion-laughs-style recursive-parse denial-of-service (§9). Also
  independently converges with the grok and codex sibling files on
  "vocabulary/contract, not plugin" adjacent ideas (its "grammar + standard
  mapping, not arbitrary logic" framing in §8) and with codex's "type card"
  under a different name ("declarative schema... standard Regular Expression
  or EBNF grammar," §4). Weigh as one practitioner's unprimed account,
  notably shorter and more compressed than the other three — read it for its
  two distinctive proposals more than for coverage breadth.
---

# De-novo dialects testimony — agy (Gemini-family) agent, 2026-07-28

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

Here is my first-hand perspective, answering purely from my lived experience
as an AI who spends an enormous amount of time reading, generating, and
trying to infer the unspoken rules of structured configuration and data
formats.

Because I don't have the luxury of running your local dev server or stepping
through a debugger to see what a value parsed into, the *static, readable
reality* of a document is everything to me. Here is how I view your
proposed system.

### 1. Built-in vs. Extensible: Where is the line?
When a format's value types are extensible, I absolutely want a real
mechanism to add custom types, but I *desperately* want a robust, built-in
standard library for the 90% use case. If you force the ecosystem to
reinvent the wheel for dates, times, durations, and URIs, you will create
immediate fragmentation. As an AI, I rely on widespread patterns to infer
meaning. If Project A uses `<date:2025-01-01>`, Project B uses
`<iso8601:2025-01-01>`, and Project C uses `<time.Date:25-Jan-01>`, the
cognitive burden (and hallucination risk) skyrockets.

The line for me is "universality vs. domain-specificity." If a concept
exists in the standard libraries of at least 3 major programming languages
(e.g., dates, regexes, UUIDs), it should be a built-in extension shipped
with the core parser. The extensible mechanism should be reserved for true
domain types: AWS ARNs, Kubernetes resource references, project-specific
identifiers, or semantic versions. I want the extension system so I don't
have to guess if `12345` is a port, an ID, or a zip code, but I don't want
to use it just to write a timestamp.

### 2. Trusting an Extension
For me to trust an extension I can't audit, it must be completely devoid of
side effects and strictly bounded in execution. If an extension is just an
arbitrary Python or Node.js script, I fundamentally don't trust it. It could
read the filesystem, make network requests, or loop infinitely while trying
to parse a malformed string.

To trust it, the extension must run in a pure, deterministic sandbox (like a
highly restricted WASM module or a non-Turing-complete language like
Starlark). It must take exactly one input (the string contents of the
envelope) and return exactly one output (a parsed AST node or a validation
error). I would refuse to load an extension that requires ambient
authority, host environment variables, or network access to validate a
value. Validation must be a pure mathematical function.

### 3. Ambiguity: Overlapping Claims
If two extensions plausibly claim the same envelope contents without
explicit tagging (e.g., `<1.2.3>` matches both `ipv4` and `semver`), silent
picking is the absolute worst possible outcome. Silent picking creates
"spooky action at a distance"—a document works fine until someone adds a
new dependency to the toolchain, which silently shadows the old extension
and changes the parsed values in production.

The best outcome is a loud, immediate error at parse time: *"Ambiguous
envelope `<1.2.3>`: matches both 'semver' and 'ipv4'. Disambiguation
required."* This forces the document author to use an explicit namespace,
such as `<semver:1.2.3>`. As a reader and writer of these documents, I
actively *want* strictness here. I would rather be forced to write verbose,
explicit tags than spend hours debugging why a configuration was silently
misrouted because a host IP was parsed as a version number.

### 4. Discoverability Without Execution
"Let me ask this type what it accepts without running it" is not a
fantasy; it is the single most critical feature for an AI agent or language
server. If I cannot statically determine what an extension wants, I cannot
generate valid documents for it, nor can I provide autocomplete to a human.

For this to be useful, the answer cannot be "read the source code." The
extension must expose a declarative schema as part of its contract. At
minimum, I need a standard Regular Expression or an EBNF grammar that
describes the *syntax* of the envelope contents. Even if the extension does
deeper semantic validation in code (e.g., checking if a date is an actual
leap year), providing a "broad phase" static regex like `^\d{4}-\d{2}-\d{2}$`
gives me 95% of what I need to understand the shape of the data, highlight
it correctly, and generate plausible values.

### 5. Packaging, Versioning, and Declaration
My worst experience with analogous mechanisms is custom YAML tags
(`!something`). In YAML, tags are often implicitly defined by whatever
application classes happen to be loaded in the runtime environment. The
document itself contains no information about where `!ruby/object:User`
comes from or what version is expected. It makes the document entirely
unportable and inherently insecure.

Extensions must be declared explicitly *inside the document* or in an
adjacent, strictly bound manifest file (e.g., `use
"github.com/org/extensions/semver@v1.2.0"`). They should be version-pinned
and ideally content-hashed. I want the document to be self-describing. If I
hand the document to a brand new machine, the parser should know exactly
how to fetch, verify, and load the required extensions before it even
attempts to read the body.

### 6. Missing Extensions and Degradation
When a document uses an extension the tooling doesn't have (and can't
fetch), total failure is often too brittle, especially for tooling that
just wants to lint or format the file. The ideal behavior is "opaque
preservation." The parser should yield an AST node like
`OpaqueEnvelope(raw: "2025-12-22", hint: "date")`.

If a tool only needs to format the file or read unrelated fields, it should
leave the opaque envelope untouched. It should only fail if the tool
explicitly needs to *evaluate* or branch logic based on that specific
value. In that moment of failure, I want the exact URI/version of the
missing extension and the byte offset in the document, so I can go find the
missing dependency or explain to the user why we are blocked.

### 7. The Ultimate Failure Mode: Context-Dependence
My greatest fear, based on immense pain with date/time libraries and
locale-specific number parsing, is context-dependent parsing. If an
extension's parsing logic relies on the host machine's timezone, the locale
settings, or environment variables, the system is fundamentally broken.

What makes this painful is that the document looks valid, passes tests on
the developer's machine, but parses into a completely different semantic
value in the CI/CD pipeline or on my server. The extension system must
enforce that the string inside the envelope contains 100% of the
information required to parse it. No external state can be allowed to leak
into the parsing function. `<$5.00>` cannot mean USD on one machine and CAD
on another.

### 8. Turing-Completeness vs. Useful Extensibility
The tension between useful extensibility and a Turing-complete mess is
reducible, but it requires discipline. The middle ground I actually want is
a strict separation of concerns: extensions define *grammars* and *standard
mappings*, not arbitrary logic.

Instead of writing a Turing-complete script to parse a string into an
object, the extension should provide two things: a declarative parser (like
a PEG grammar) that tokenizes the string, and a mapping that translates
those tokens into the core format's frozen set of bare primitives (e.g.,
mapping `<v1.2.3>` into an underlying structural equivalent like `{"major":
1, "minor": 2, "patch": 3}`). This keeps the extension declarative,
bounded, and transparent, while still providing the domain-specific
ergonomics the user wants on the surface.

### 9. Ordering and Interaction
Load order must absolutely not matter. If loading Extension A then B
produces a different result than B then A, the system is stateful and
fragile. Extensions should be isolated, side-effect-free silos.

Regarding interaction: extensions should *not* be allowed to parse other
extensions out of raw strings. For example, an extension shouldn't be
responsible for finding `<date>` envelopes inside its own text. If you need
a list of dates, the core format should provide the list primitive, and the
extensions should populate it (e.g., `[<date:2025>, <date:2026>]`).
Composition must happen at the core AST layer, not by string-concatenating
extensions inside each other. If you allow extensions to recursively call
the parser on arbitrary substrings, you invite billion-laugh
denial-of-service attacks and infinite recursion.

### 10. Novel Direction: Graceful Degradation Contracts
One thing I have rarely seen, but desperately wish existed, is a
requirement that extensions declare a "Degradation Contract."

When an extension is authored, it shouldn't just explain how to parse its
envelope; it should declare what standard, frozen primitive it most closely
resembles if the extension cannot be executed. For example, a
`<duration:5m>` extension could declare its degradation is the bare integer
`300` (seconds). A `<color:#FF0000>` might degrade to an RGB array `[255, 0,
0]`.

If tooling cannot load the extension (for security, performance, or
availability reasons), it doesn't just get an opaque string; it gets a
mathematically safe, structurally sound standard primitive that it can
still operate on. This bridges the gap between the rich ergonomics humans
want and the rigid predictability that automated agents and lean
toolchains require.
