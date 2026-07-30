---
source: De-novo schema testimony — grok CLI, context-free (no repo access), 2026-07-28
gathered: 2026-07-28
area: schema layer — end-user testimony
support-kind: testimonial (de-novo). Evidence of end-user demand and pain; never design validation.
prompt: ./denovo-prompt.txt (identical across all three substrates)
caution: >
  One support-kind shared with the sibling Claude and codex testimonies — three
  substrates raise the testimonial leg, they do not arm a convergent lock.
---

# Schema for a prose-and-structure notation: an end-user’s first-hand view

I am writing this as someone who lives in other people’s configs and data files — rarely as the person who designed the schema, almost always as the person who has to edit one field without breaking the rest, often through a tool that only shows me a slice, and often without a green checkmark available at the moment of change. That is the lens. I will disagree with your framing where it feels load-bearing in the wrong place, and I will mark uncertainty rather than invent confidence.

---

## 1. What I hope a comprehensive analysis of “the schema layer” covers — and what would disappoint me if left unasked

I hope the analysis does **not** start with “which schema language do we pick?” That is a late question dressed as an early one. What I hope it covers is the **jobs** a schema is hired for, the **moments** those jobs fire, and the **failure modes** when the job is done badly or silently.

**Jobs I would be disappointed not to see named separately:**

- **Authoring guidance** (what can I put here?) vs **acceptance** (will this be rejected later?) vs **migration** (how do I move yesterday’s document into tomorrow’s shape?) vs **discovery** (what fields exist and what do they mean?) vs **generation** (can a tool invent a valid skeleton?) vs **interop** (can two systems agree on shape without sharing code?). These collapse into each other in theory and diverge violently in practice.

- **Who is the consumer at each moment?** A human in an editor. An agent with a 200-line window. A CI job with full file + internet. A runtime loader that must not crash. A search index that only cares about a few keys. A future maintainer reading the file in five years with no repo history open. Schemas that optimize only for the CI job will hurt the agent and the grepping human in ways the team will not feel until adoption stalls.

- **Validity as a spectrum, not a boolean.** Half-written documents are the normal state of editing. If schema only knows “valid / invalid,” every intermediate state is a red wall. I want the analysis to ask: what is *structurally* invalid vs *semantically* incomplete vs *conventionally* incomplete vs *intentionally* experimental?

- **Where schema lives relative to the document.** Inline? Sibling file? Repo root? Generated from code? Imported by URL? Locked to a version hash? Floating? For a format that interleaves prose and structure, “schema lives elsewhere” and “schema is woven in” are different products.

- **What is *not* schema.** Types. Defaults. Documentation. Constraints. Provenance. Access control. Soft conventions. Branding. I have watched teams stuff all of these into “schema” and then be unable to evolve any of them independently.

- **Silent failure.** Not “does validation catch errors?” but “when validation is absent, wrong, or skipped, what does the user believe?” The worst schema experiences in my life were not loud rejections; they were green paths that accepted nonsense, or tools that “helped” by coercing types I never asked for.

- **Partial views and multi-file composition.** Real repos are not one document. Schemas that only make sense on a closed world of one file will fail the moment includes, overlays, env-specific fragments, or “defaults + overrides” appear — which they will.

- **Prose.** If half the document is natural language, “schema” that only talks about maps and lists is solving half the product. I expand this later; I would be disappointed if prose is a footnote.

- **Agent and tool surfaces.** Not as a futuristic add-on. As a first-class consumer. If I cannot get a precise, local, actionable error from a schema while holding only a fragment in context, the schema is not for me — it is for the batch pipeline.

- **Versioning and forgiveness.** Not only “schema v2,” but “document claims schema v1.3, host only has v1.2, and the edit is one field.” Coexistence is the normal case.

- **Authority.** Who wins when the document says one thing, the schema says another, the surrounding files imply a third, and the code that loads it implements a fourth? Schema without a story about authority is theater.

Questions I would be disappointed to find unasked:

- What is the **unit of validity**? Document? Fragment? Path? Transaction of edits?
- What is **invalid but loadable**? What is **loadable but not saveable**?
- How do we **explain** rejection to someone who cannot run the full stack?
- How do we **evolve** without mass rewrites of human-edited prose?
- When should schema **refuse to speak** (unknown extensions, experimental sections) vs **hard-fail**?
- Is the goal **uniformity across the ecosystem** or **local coherence inside one repo**? Those pull opposite directions.
- What happens when the **schema is wrong** and the documents are right? (This happens constantly after organic growth.)

---

## 2. First-hand pains and helps from schemas I have actually lived in

I am not going to pretend equal depth in every technology. What follows is weighted toward things I have actually been burned by or saved by as an editor and consumer.

### JSON Schema

**Helped:** Shared vocabulary across tools; “required / type / enum” is enough for a lot of config; IDE completion when wired well; decent for API request bodies.

**Made life worse:** Error messages that point at abstract paths without the surrounding prose of *why*. `$ref` graphs that turn a simple “what can go here?” into a treasure hunt. Over-precision that rejects useful partial data. The illusion that a schema file *is* documentation when it is usually neither readable nor complete. `additionalProperties: false` as a culture war — great for closed configs, catastrophic for extensible documents people will evolve in the wild.

**Silent failures:** Tools that only validate on save in one editor; CI that validates a different subset; “compatible” validators that disagree on edge cases (null vs missing, draft versions). I have “fixed” a file until one tool was happy and another still failed, with no clear which was canonical.

### XSD / XML schema culture

**Helped:** When the world is genuinely document-shaped with mixed content, XSD (and the ecosystem around it) at least *admits* that text and elements coexist. Namespaces force explicitness about who owns a vocabulary.

**Made life worse:** Verbosity and indirection. Closing tags and schema complexity create a tax that makes people avoid structure. Schema-first XML often felt like the schema was the product and the document was an annoyance. Mixed content rules that are correct in theory and unusable when you just want a paragraph with a link.

**Silent failures:** Namespace defaulting and prefix confusion — files that “look fine” and fail only under a different parser configuration. Entity and encoding issues that schemas do not save you from.

### Protobuf / similar IDLs

**Helped:** Clear wire contract; field numbers as a migration device; code generation that actually stays in sync; “unknown fields” as a first-class evolution story.

**Made life worse:** Human-edited text is not the point — when people *do* hand-edit text formats of protobuf-like data, the IDL is far away. Optional/required history (proto2 vs proto3) taught an entire industry that “required” in a schema can be a long-term footgun. Default values that make “unset” and “set to zero” collapse — schema lies about presence.

**Silent failures:** Forward/backward compatibility that works on the wire but breaks application assumptions. Generated code that compiles while semantic meaning drifted. The schema says the field exists; the business rule says it must not be empty; only one of those is checked.

### CUE / Dhall (constraint / config-as-code family)

**Helped:** Unification, defaults, and “data + constraints in one place” is genuinely powerful for complex config. CUE’s approach to concrete vs incomplete values matches how I actually edit: incomplete is normal. Dhall’s purity and imports give reproducibility when the team actually buys in.

**Made life worse:** Learning curve that excludes the drive-by contributor. Error messages that are correct and still opaque. When the schema language is *more expressive than the host language of the team*, the schema becomes a priesthood. Also: beautiful constraint systems that nobody runs in the path you actually edit through.

**Silent failures:** “It typechecks in the small example” while imports resolve differently in CI. Over-abstracted schemas that accept many more worlds than the application can handle — validity without fitness.

### Rails / ActiveRecord (and similar “class owns the data”)

**Helped:** The schema is not a separate hobby language; it is the model. Migrations are a *process*, not only a description. Defaults, validations, and associations live near the behavior that needs them. For app data, this is often the least dishonest story: the code is the authority.

**Made life worse:** Validations that only fire on some callbacks. `save(validate: false)` culture. Schema in the database, validations in the model, strong params in the controller, serializers in the API — four schemas that drift. Migrations that are easy to write and hard to reverse when data, not structure, is the problem. The class *owns* the data until you export to YAML/JSON for fixtures or seeds and suddenly you have a shadow schema with none of the protections.

**Silent failures:** Presence validators that do not match DB nullability. `serialize` columns. Enum definitions that differ between DB and Ruby. I have shipped “valid” records that violated the mental model because the check never ran on the code path I used.

### GraphQL SDL

**Helped:** Excellent for *discovery* and for client-driven queries. Nullability is explicit (and culturally contested for good reason). Schema-as-contract is legible in one place.

**Made life worse:** The N+1 and auth problems are not schema problems but get blamed on schema. Over-nullable or under-nullable fields teach the wrong lessons. Schema stitching and federation make “the” schema a distributed lie. For documents that are not query APIs, GraphQL’s shape is a poor metaphor forced onto the wrong job.

**Silent failures:** Deprecation without removal forever. Clients that only request a subset and never notice a breaking change elsewhere. Custom scalars that are strings at the boundary and dreams in the docs.

### Tree-sitter grammars (and grammar-as-schema)

**Helped:** Incremental parsing, good enough structure for editors, error recovery that keeps a tree alive while the file is broken — this is gold for real editing. Highlights and folds that do not require perfect validity.

**Made life worse:** Grammars describe *syntax*, not *meaning*. People treat a successful parse as validation. Ambiguity and precedence fights. “Valid according to grammar” for a config language still allows complete semantic nonsense.

**Silent failures:** Error recovery that produces a plausible tree pointing at the wrong node. I have “fixed” the wrong place because the error node was nearby, not causal.

### TypeScript types over JSON / Zod / similar

**Helped:** Local, fast feedback in the same place I write logic. Inference is a superpower. Zod-like runtime parsers close the “types are erased” hole.

**Made life worse:** Types that describe the happy path after transforms, not the file on disk. `as` casts as institutional surrender. Optional fields that mean three different things (missing / null / undefined). Generated types from OpenAPI that are unreadable and then hand-patched.

**Silent failures:** Compile-time confidence with runtime `JSON.parse` and a prayer. Structural typing accepting extra keys you thought were closed.

### OpenAPI

**Helped:** Ecosystem gravity — clients, mocks, docs portals. Good enough shared surface for HTTP APIs.

**Made life worse:** Specs that are 80% accurate and 100% trusted. Vendor extensions everywhere. Multiple ways to say the same thing. Generated docs that look official while examples are wrong. For non-HTTP documents, OpenAPI is a Procrustean bed.

**Silent failures:** “ codex examples” that are not validated against the schema. Servers that implement a dialect. Nullable and required interactions that differ by generator.

### Pydantic / similar runtime models

**Helped:** Coercion and validation at the boundary; clear models; good error trees when configured well. Excellent for “data enters the process here.”

**Made life worse:** Coercion that “fixes” bad input into wrong input. Config that is too strict for migration periods. Nested models where one bad leaf explodes a huge payload with a stack of messages you must learn to read. Using the same model for DB, API, and file formats until none of them fit.

**Silent failures:** Default factories and aliasing that make round-trips non-idempotent. Data that validates into a different shape than the source text suggested.

### “Convention only” (no formal schema)

**Helped:** Fast evolution, low ceremony, documents stay readable. The surrounding lines *are* the docs for pattern-matchers (human and agent).

**Made life worse:** Invisible breakages. Naming drift (`timeout` vs `timeout_seconds`). Optional fields that become load-bearing. Copy-paste as the type system.

**Silent failures:** Everything. The failure mode *is* silence until production or a subtle misconfiguration.

### Cross-cutting first-hand lesson

The schemas that helped me most as an *editor* shared three traits: (1) they could speak about **incomplete** values, (2) their errors named **paths and expected alternatives** in human language, and (3) they were **actually on the path** I used — not a weekend CI job I forget exists. The ones that hurt most were **authoritative in theory and optional in practice**, or **complete only for the machine path** while humans edited a different representation.

---

## 3. Kinds of schema — what each makes easy, awkward, and impossible

Your taxonomy is useful as a museum of existing practice. I do not think it is the *best first cut* (I will propose another in section 10-ish), but taking it on its own terms:

### A. Example document as prototype (“this is what good looks like”)

**Easy:** Onboarding, imitation, agent few-shot editing, pattern matching from neighbors. Extremely high bandwidth for humans who learn by copy. Works with prose-heavy files naturally — an example *is* a document.

**Awkward:** Encoding invariants that are not visible in one example (mutual exclusion, cross-field constraints, version ranges). Multiple valid shapes. Expressing “never do X.” Keeping examples in sync with reality.

**Cannot fundamentally do:** Exhaustive acceptance/rejection. Mechanical migration. Guaranteeing that a novel combination is legal. Being a single source of truth for code generation without losing information.

**Drives:** Documentation culture, soft convergence, editor “snippets.”
**Forecloses:** Strong automated guarantees unless paired with something else (and then the example is no longer the schema, it is marketing).

### B. Constraint language (JSON Schema, CUE predicates, XSD restrictions, etc.)

**Easy:** Closed-world validation, enums, ranges, required sets, “one of these shapes.” Tooling for red/green. Some generation of forms and docs.

**Awkward:** Defaults and “fill in the rest.” Gradual typing of organic documents. Expressing “this prose section should be a decision record with these headings” without becoming a bad word processor. Cross-document constraints. Saying “prefer but allow.”

**Cannot:** Own runtime behavior. Migrate data with domain semantics. Fully replace documentation of *intent*. Represent open-world extension gracefully without becoming either toothless or brittle.

**Drives:** CI gates, interop contracts, static checks.
**Forecloses (if treated as sole schema):** Friendly partial editing; organic growth; treating unknown structure as first-class.

### C. Resource/class that owns data (Rails/Ash-style model + migrations)

**Easy:** Behavior co-located with shape; versioned transforms; invariants enforced where state changes; “the application is the truth.”

**Awkward:** Documents that live *outside* the app lifecycle (READMEs, design notes, multi-repo configs). Editing without booting the world. Polyglot consumers. Prose-primary files that are not rows.

**Cannot:** Be the portable contract for other languages without exporting a projection (which becomes a second schema). Serve drive-by editors who only have the file.

**Drives:** Product integrity, migrations, domain rules.
**Forecloses:** Format-as-lingua-franca independent of one runtime — unless you continuously export projections and accept dual maintenance.

### D. Grammar (tree-sitter, PEG, etc.)

**Easy:** Parsing, highlighting, structural editing, “is this even the language?” Error recovery for broken intermediate states.

**Awkward:** Semantic constraints, value-level types, cross-references, versioned vocabulary of keys.

**Cannot:** Tell you that `replicas: -1` is wrong if the grammar allows integers. Tell you a heading hierarchy is wrong for a document type. Own migrations.

**Drives:** Editor experience, incremental tools, agent structure awareness.
**Forecloses:** Nothing if kept in its lane; everything if mistaken for full schema.

### E. External formalism in another language (Protobuf IDL, OpenAPI YAML for a non-OpenAPI world, TypeScript types for JSON files)

**Easy:** Reuse mature tooling; generate code; speak to existing ecosystems.

**Awkward:** Impedance mismatch with prose-mixed documents; round-tripping comments and ordering; teaching the formalism about indentation-significant mixed content.

**Cannot:** Faithfully represent “document as literature + data” if the host formalism assumes records and arrays only. Keep comments, key order, and inter-leaf prose stable under codegen round-trips without heroic effort.

**Drives:** Ecosystem leverage.
**Forecloses:** Format-native elegance; often **comment and prose preservation**, which for your setting is not a detail.

### F. Convention inferred from the file / corpus

**Easy:** Zero ceremony; local adaptation; matches how agents and humans already work (“look at the sibling keys”).

**Awkward:** Enforcement, onboarding at scale, cross-repo consistency, proving safety.

**Cannot:** Guarantee; migrate en masse with confidence; generate complete clients.

**Drives:** Speed and literacy of pattern matchers.
**Forecloses:** Strong safety narratives; automated large refactors without statistical risk.

### The honest combinatorial truth

In practice, every serious system uses **a stack** of kinds: grammar for syntax, constraints for closed fields, examples for humans, code ownership for runtime, convention for the long tail. The design question is not “which kind?” but **which kind is authoritative for which job**, and what the **export projections** are. A team that picks one kind as “the schema layer” will rediscover the others as ad-hoc piles.

---

## 4. What I personally wish a schema would buy me — especially as an agent with narrow tools

I edit through partial context constantly. That is not a special agent problem; it is also the human-with-a-small-diff problem. Capabilities I want:

### Validation timing that matches editing, not only shipping

- **On fragment:** “Given this subtree and a path, what is allowed here?” without parsing the whole monorepo.
- **On save of partial work:** warnings for incomplete, errors only for contradictory.
- **On commit / CI:** full closed-world checks, cross-file, version alignment.
- **On load in production:** trust but verify with clear degrade paths — not the same profile as authoring.

If there is only one timing, teams choose CI, and editors live in the dark.

### Error quality as a product feature

I want errors that include:

- **Path** in the document’s own addressing scheme (not only JSON Pointer if the format is indentation-mixed prose).
- **What was found** (quoted).
- **What was expected** (small set of alternatives, not a novel).
- **Nearby valid example** from the local corpus or schema examples.
- **Whether this is hard-fail, soft-warn, or “unknown extension allowed.”**
- **Who is authoritative** (schema version, file, rule id) so I can argue with the right layer.

As an agent, a single precise error with a fix suggestion beats a stack of schema-theory messages.

### Partial and invalid documents as first-class

Tree-sitter’s error recovery is closer to what I need than JSON Schema’s boolean world. I want:

- **Holes:** “this field is required later, absent now.”
- **Conflicts:** “two sections both claim to define `id`.”
- **Unknowns:** “this key is not in the schema; preserving it.”
- **Stale:** “this matches schema 1.2; host is 1.4; here is the delta.”

The schema should help me **navigate a broken tree**, not only reject a finished one.

### Migration as narrative, not only as code

I want:

- **Declared renames** (`timeout` → `timeout_ms`) that tools can apply while preserving surrounding prose and comments.
- **Semantic migrations** that may need human judgment, flagged as such — not silently defaulted.
- **Coexistence windows** where readers accept old and new.
- **Document-level version markers** that are optional to write by hand but stable when tools touch the file.

The class-owns-data world gets this more right than pure constraint languages; pure constraint languages get portability more right. I want both: portable **migration scripts or declarations** that are not buried in one runtime.

### Code/tool generation — carefully

Generation I want:

- Skeleton documents from a type/resource.
- Editor completion and hover docs.
- Agent tool schemas (“you may call edit_field with…”).
- Diff-friendly formatters that consult schema for key order *without* destroying prose wrapping choices carelessly.

Generation I fear:

- Round-tripping the whole file through a model that drops comments.
- “Canonicalizers” that fight human layout in mixed prose.
- Generated types that become the only docs and then rot.

### Discovery

- “What document types exist in this repo?”
- “What is the schema for the node under my cursor?”
- “Show me three real examples of this section from the corpus.”
- “Which fields are required for *minimal useful*, not for *fully valid*?”

Corpus-aware discovery often beats formal schema alone. Formal schema plus corpus examples is the sweet spot.

### Authority and overlays

- Base schema + repo conventions + file-local relaxations.
- Experimental sections that opt out without poisoning the whole file.
- “Strict in CI, lenient in editor” as a **declared profile**, not an accident.

### Trust when I cannot run the validator

This is the under-discussed one. Offline, air-gapped, or “I only have the patch.” I wish schema could compile to:

- A **compact local check** for the fragment I hold, or
- A **checksummed schema bundle** committed next to the docs, or
- **In-document claims** that are still human-readable (“type: ServiceConfig@1.4”) so even without execution I know what world I am in.

If schema only exists as a SaaS or a heavy runtime, it fails my actual working conditions.

---

## 5. Half of these documents are prose — what schema means there

This is where many schema traditions quietly refuse to go, or go and become Word with YAML sidebars.

### What “schema over prose” can mean (distinct jobs)

1. **Document type / genre.** “This file is a design note / ADR / runbook / paper segment.” Genre implies sections, tone, and required decisions — not string lengths.

2. **Structural outline constraints.** Required headings, ordering recommendations, “must have Alternatives if Status is Accepted.” Like a lightweight document class in LaTeX or a good Markdown lint for ADRs.

3. **Embedded data islands.** Prose is free; fenced or indented data blocks are strictly typed. Schema applies at island boundaries. This is the most successful pattern I have seen in the wild (docs with YAML front matter; Markdown with annotated code blocks; AsciiDoc attributes).

4. **Inline structured phrases.** Tags, wikilinks, citations, decision macros. Schema as vocabulary of inline objects, not of paragraphs.

5. **Semantic roles without full NLP.** “This block is a warning / assumption / invariant / quote.” Roles can be schema-checked; paragraph truth cannot.

6. **Machine-checkable claims inside prose.** IDs, references to other documents, “see §3,” claim labels. Link integrity is a schema-adjacent win; “this argument is valid” is not.

### What I have seen work

- **Front matter + free body.** Schema the front matter hard; lint the body lightly (heading levels, required sections for a template).
- **Templates with “fill these slots.”** Not full validation — scaffolding. Humans and agents both benefit.
- **Admonition / block roles** with known types (`NOTE`, `WARN`, `TODO`) and optional structured payloads.
- **Cross-reference checkers** (anchors exist; citations resolve) — high value, low philosophical risk.
- **Style as separate from schema.** Vale/prose linters for language; schema for structure. When combined into one megatool, both get worse.

### What I have seen fail

- **Trying to type natural language with JSON Schema-shaped thinking.** Required properties on paragraphs. Enum of allowed sentences. It becomes a joke or a prison.
- **Schematizing rhetoric.** “Every claim must have evidence subtree” sounds good and produces cargo-cult headings with empty content to pass CI.
- **Mixed content rules that forbid the one thing writers need** (a list inside a quote inside a section with a data table). Writers exit the format.
- **Auto-formatters that reflow prose as if it were data**, destroying intentional line breaks, footnotes, or comment anchors.
- **One validity bit for the whole file** when the data island is wrong but the prose is the deliverable — or vice versa. Blocking a paper merge because a figure caption attribute failed type check may be correct operations and still be wrong product design without profiles.

### What I believe schema *should* mean over prose in your setting

Schema over prose is mostly **genre + outline + island boundaries + reference integrity + role labels**. It is almost never **sentence grammar of truth**. The win is making the *mechanical* parts of a document reliable so the *judgmental* parts can stay free. If the team blurs those, authors will fight the schema and eventually abandon the format for “real Markdown” and a side YAML file — the opposite of unification.

I am uncertain how far **semantic roles** can go without becoming an NLP product. My working bet: stick to explicit markup roles the author opts into, not inferred discourse structure.

---

## 6. What a team opening this question predictably gets wrong — and what is under-explored

### Predictable wrong turns

1. **Starting from familiar schema tech** (JSON Schema / XSD / Protobuf) and forcing the mixed document model into record trees. You will get a great schema for the 30% that looks like config and a hostile experience for the 70% that looks like writing.

2. **Boolean validity as the center of gravity.** Editing is continuous; boolean validity is for gates. If the first demo is “rejects invalid files,” the first users will be people who already have valid files.

3. **Schema language max-expressiveness.** The team will want a beautiful constraint calculus. Drive-by contributors need five concepts total. Expressiveness without progressive disclosure creates a priesthood (CUE/Dhall lessons).

4. **Ignoring comment/prose/key-order preservation** until after the constraint system is “done.” For this format, preservation *is* the product. Schema tooling that rewrites files is existential risk.

5. **One schema to rule all consumers.** CI, editor, runtime, agent, and docs portal want different strictness and different views. One blob with no profiles will be too strict for editing and too weak for production — or the reverse.

6. **Treating examples as optional docs** instead of as a first-class, tested artifact. Untested examples rot and become lies that agents trust more than the schema.

7. **Migration as an afterthought.** Version 2 will come. If migration is “hand edit everything,” the schema layer will be blamed for the format’s stagnation.

8. **Over-fitting to the team’s primary language runtime.** Class-as-schema works inside an app and dies in a polyglot org with raw files in git.

9. **Silent success paths.** Coercion, defaults injection, and “helpful” normalization without surfacing what changed. Especially deadly for agents who then write the coerced form back.

10. **Solving ontology when you needed lint rules.** A grand type hierarchy of all documents in the company is a multi-year tar pit; “this folder uses ServiceConfig@1” is a week’s win.

### Under-explored directions (where I would look harder)

**A. Profiles and partiality as the core abstraction, not types.**
Concrete / incomplete / conflicting / unknown as states of a document region — CUE brushed this; editors need it more than config compilers do.

**B. Schema as a queryable index over a corpus, not only a gate.**
“Show legal keys here given sibling files” may outperform a global closed schema for repo-local truth.

**C. Bidirectional, structure-aware editing contracts for agents.**
Not “here is JSON Schema, good luck,” but “here is a patch language that cannot violate genre constraints” and “here are safe mechanical refactors.”

**D. Prose-island contracts.**
First-class syntax for “free text until marker” vs “typed map,” with schema applying differently — designed so the reader never confuses which mode they are in.

**E. Error recovery and best-effort trees as normative.**
Standardize what a broken document’s structure *means* so tools agree where the error node is. Tree-sitter proved the value; most schema stacks ignore it.

**F. Authority graphs.**
Document claims, schema package, repo policy, runtime code — explicit precedence. Right now every ecosystem has this fight informally.

**G. Human-time vs machine-time schema.**
What must be true for a reader to understand vs what must be true for a deployer to run. Marking fields as `doc-only`, `runtime`, `ci-only` is rare and valuable.

**H. Soft constraints with budgets.**
“Prefer these key orders; allow violation with a warning budget.” Teams that only have hard constraints invent out-of-band exceptions.

**I. Schema diff and document diff coupled.**
When schema evolves, produce a report of affected documents with severity — before migration. Most teams run migrations blind.

**J. The “I cannot run your validator” kit.**
Embeddable, dependency-light, fragment-local checking. If agents and constrained environments are first-class, this is not optional polish.

---

## 7. Disagreeing with the framing: a better first cut than “kinds of schema”

“Kinds of schema” is a good *historical* cut (how industry packaged the idea). The better *design* cut is **jobs × moments × authority × strictness**, with kinds as implementation tactics.

| Dimension | Questions |
|-----------|-----------|
| **Job** | Guide, accept, migrate, discover, generate, document, authorize |
| **Moment** | Keystroke, save, PR, deploy, runtime, archive |
| **Unit** | Character, node, file, graph of files, release |
| **Strictness** | Hint, warn, hard-fail, coerce-and-announce |
| **Authority** | Who wins when sources conflict |
| **Openness** | Closed world, open extensions, experimental zones |
| **Representation fidelity** | Must comments/prose/order survive tooling? |

A constraint language is a tactic that is strong at **accept @ CI @ file @ hard-fail** and weak at **guide @ keystroke @ fragment @ incomplete**. An example document is strong at **guide @ authoring** and weak at **accept**. A Rails model is strong at **migrate @ runtime** and weak at **discover @ offline file**.

If the team debates kinds first, they will pick a favorite hammer. If they assign **jobs to moments** first, they will almost certainly end up with a **small stack** and clear projections between layers — which is the only approach I have seen survive contact with real repositories.

---

## 8. The narrow-tool, someone-else’s-repo reality (the user you said I am)

This deserves its own section because it changes priorities.

When I open a file in a foreign repo I typically have:

- No schema install instructions that work on the first try.
- No certainty which tool is canonical.
- A few dozen lines of context.
- A need to change one value without “improving” the file.

What helps in that world:

- **Local redundancy:** shape is obvious from neighbors; names are consistent; requiredness is visible (no magic remote defaults).
- **In-file genre markers** that survive copy-paste into chat and diffs.
- **Forgiving unknown keys** labeled by convention (`x-`, `experimental.`) so I do not fear extension.
- **Comments that are legal and stable** next to tricky fields — schema culture that does not strip them.
- **Mechanical keys typed by syntax** (your format’s strength) so I do not depend on schema to know a number from a string.

What hurts:

- Validity that depends on remote `$ref` fetches.
- Schemas that only exist as generated code in another language.
- “The real rules are in the application” with no projection in-repo.
- Auto-format on save that rewrites half the file and drowns my one-line fix.

**Implication for schema design:** the schema layer must degrade to **readable local convention** when tooling is absent. If the format is only safe under full tooling, it will be unsafe in the modal case of my life.

---

## 9. Agents specifically — not as sci-fi, as current practice

I often:

- See a partial file or a diff hunk.
- Infer schema from nearby lines (convention kind).
- Make a minimal edit.
- Cannot run the full validator.
- Am punished for drive-by rewrites that “clean up” ordering.

What I want from a schema layer in that loop:

1. **Cursor-local completion and constraints** exported as a small JSON-ish “context pack” a tool can fetch: allowed keys, types, enums, whether additional keys ok, links to 1–2 examples.
2. **Patch validation** — validate the edit, not only the file.
3. **Invariant-preserving refactor ops** (rename key across islands; bump version; add required field with default) as named operations, not freeform text edits.
4. **No silent coercion on write-back.**
5. **Explicit “do not touch” regions** for prose the agent should not rewrap.

The schema that only speaks batch-validate-full-file is optimized for compilers, not for the way I actually change documents.

---

## 10. Types-by-syntax vs schema — keep the boundary clean

Your format’s promise — values typed by syntax, not sniffing — is a **trust foundation**. Schema should not reintroduce sniffing (“this string looks like a date”). I have been burned by systems that coerce `"2026-07-28"` into dates in one timezone and leave it as string in another.

Wish: schema may **constrain** a syntactic type (this integer must be > 0; this string must match a slug pattern) but must not **reinterpret** syntax. If something is a date, the document should say so in the format’s own typed syntax, not in a schema annotation that changes runtime meaning.

This is one place constraint languages often sin: `format: date-time` as a semantic hijack.

---

## 11. Defaults, presence, and the three-valued nightmare

Every schema culture eventually faces:

- absent
- present but null / empty
- present with a value
- present with an explicit “use default”

And separately:

- default applied at read
- default applied at write
- default only in documentation

I have lost hours to systems that write defaults back into files (diff noise, merge hell) and to systems that never materialize defaults (readers disagree).

For a human-edited document format, my preference is strong:

- **Do not rewrite defaults into the file** unless the user or a migration explicitly asks.
- **Make presence visible** in the data model tools use.
- **Document defaults next to the field** in schema discovery, not only in code.

If the schema analysis does not spend real pages on presence vs defaults vs materialization, it will under-specify the sharpest edge in config UX.

---

## 12. Versioning without lying

Patterns that worked for me:

- **Document declares intent** (`schema: foo@1.3`) when it matters; tools may insert this.
- **Readers accept N and N-1** for a defined window.
- **Unknown fields preserved** by default in non-closed documents.
- **Field-level deprecation** with replacement pointers, not only file-level major bumps.

Patterns that failed:

- Silent major bumps in libraries that still “parse fine.”
- Version only in external registry, not in-file.
- Breaking changes justified by “the schema was always meant to…”

For prose-heavy docs, **version the typed islands and the genre**, not the essays. Requiring every narrative document to bump a schema version for a wording change trains people to remove version markers.

---

## 13. What “comprehensive analysis” success looks like to me as a user

I would consider the team’s analysis a success if it delivered:

1. A **job/moment matrix** with explicit non-goals.
2. A proposed **stack** (grammar + genre/outline + constraint islands + optional code ownership projection + corpus examples), not a single hammer.
3. A stance on **partial documents and error recovery**.
4. A stance on **prose** that protects writing.
5. A **fidelity** requirement for tooling (comments, order, prose).
6. **Profiles** (edit / ci / runtime).
7. **Migration and coexistence** story.
8. **Offline/fragment** story for agents and drive-by humans.
9. **Authority** when sources conflict.
10. Honest list of **what will remain convention** forever (and how to teach it).

I would consider it a failure if it mainly compared JSON Schema vs XSD vs Protobuf feature checklists and picked a winner by expressiveness.

---

## 14. Where I am uncertain

- **How much formal power** is worth the literacy tax for *this* community of users. I lean progressive disclosure hard; I might be underestimating power users who want CUE-level unification across multi-file config.
- **Whether genre schemas for prose** can stay lightweight or inevitably grow into a bad CMS. Historical evidence is mixed (DTD document classes vs modern Markdown chaos).
- **How far agent-specific tooling** should influence the core language vs live in adjacent protocols. Core bloat is real; agent misery is also real. I lean “adjacent but standardized.”
- **Open-world vs closed-world default** for a unified prose/data format. My gut says open by default, closed by genre opt-in — but security-sensitive config may need the opposite, which argues for genre-specific defaults rather than format-wide philosophy.
- **Whether “class owns data” projections** can be generated from a portable schema without dual-source drift. Industry track record is poor; maybe your format’s clarity makes it easier — I have not lived that success enough to trust it.

---

## 15. A direct answer to the emotional question under the technical one

You are not really asking “what is a schema?” You are asking: **what will make this format remain pleasant to touch under real conditions — partial edits, mixed prose, weak tooling, multiple consumers — ten years in?**

My first-hand answer: the schema layer should be **less like a single type system** and **more like a layered city code** — zoning (genre), building codes (constraints on data islands), inspections at different times (profiles), renovation permits (migrations), and historical districts (prose you do not bulldoze). The failure mode I fear most is a beautiful, expressive, closed, boolean, codegen-first schema that makes the format safe for compilers and hostile to the people (and agents) who actually write the documents.

If I could only keep a few wishes from this entire essay, they would be:

1. **Incomplete is normal; schema must speak incomplete.**
2. **Prose is not a broken record type; islands and genres are the bridge.**
3. **Tooling may not destroy fidelity to satisfy the schema.**
4. **Jobs and moments before languages and kinds.**
5. **Degrade to local convention when the validator is not in the room.**

That is the analysis I hope the team has — not because it is fashionable, but because it matches the scars.
