---
source: De-novo schema testimony — codex CLI (gpt-5.6-terra), context-free, 2026-07-28
gathered: 2026-07-28
area: schema layer — end-user testimony
support-kind: testimonial (de-novo).
prompt: ./denovo-prompt.txt (identical across all three substrates)
caution: >
  This respondent explicitly declined the first-hand-experience premise ("I do not
  have personal lived experience in the human sense") and framed its answer as
  synthesis of recurring failure modes. Preserved rather than smoothed away.
---

## 1. The first question is not “what is the schema language?” but “what promises can a schema make?”

I would hope the analysis begins by separating the promises that people commonly bundle under the word *schema*. A schema may be promising at least all of these:

- What shapes of document are accepted?
- What does each part mean?
- Which values are valid?
- Which fields are required, optional, repeated, or mutually exclusive?
- What references are valid across a document or repository?
- What version is this document written against?
- How should old data become new data?
- What editor affordances can be derived?
- What code or APIs can be generated?
- What is safe for an automated editor to change?
- What constraints should be checked immediately, later, or only with external context?

Those are not one feature. They have different owners, different error models, and different compatibility stories. A format team can do a wonderful job designing structural validation and still leave users stranded on migration, documentation, incomplete files, semantic reference checks, or safe automated edits.

I would be disappointed if the analysis asked only, “Can we express types, required properties, arrays, and enums?” That is the table-stakes question. I would also be disappointed if it treated validation as the end product. For many users, validation is not the chief value. The chief value is being able to confidently make one small change in a document one does not fully understand—knowing what the local unit is, what else must change with it, what defaults apply, and whether the change is compatible with a downstream reader.

The question I would put at the center is: **what new practical action becomes reliable once a document has a schema?** If the answer is only “a validator can reject it,” that may be useful, but it is much smaller than the design opportunity.

## 2. Schema has at least four time horizons, and collapsing them creates pain

A comprehensive analysis should distinguish constraints by when they are knowable.

First are **lexical and syntactic constraints**: this is a number, this nesting is legal, this tag spelling is valid. These should generally be immediate, deterministic, and work on incomplete documents as much as possible.

Second are **local structural constraints**: a `task` has a title; an `invoice` contains line items; a `status` is one of a finite set; an object has at most one `id`. These can often be checked with just the local node or document.

Third are **semantic and cross-reference constraints**: a dependency names an existing package; a parent ID exists and has the appropriate kind; dates are chronological; totals equal their entries. These need more context, and they frequently create editor friction if treated like syntax errors.

Fourth are **environmental or policy constraints**: the referenced file exists in this repository; a URL is reachable; an account has permission; a version is supported by the current deployment; a secret has been provisioned. These are real constraints, but they are not intrinsic properties of a document. They may vary among machines, branches, times, and users.

A bad schema system makes all four look equivalent. Then users see a red error marker because a remote service cannot be reached, or cannot draft a document because the object it refers to will be added in the next commit. A good system lets tools state: “the document is structurally invalid,” “this is structurally plausible but semantically unresolved,” and “this is valid under the local schema but unverified against the current environment.” That distinction becomes especially important for agents and narrow edit interfaces, where the ability to make incremental progress matters more than a binary pass/fail result.

## 3. JSON Schema is powerful precisely where it becomes hard to reason about

JSON Schema demonstrates the appeal of a rich declarative constraint language: it can describe scalar types, nested structures, object properties, arrays, ranges, patterns, alternatives, reuse through references, and more. This is a substantial improvement over convention when consuming untrusted APIs or configuration. It creates a portable validation artifact and, in many cases, enables forms, documentation, completion, and test fixture generation.

But JSON Schema also shows how quickly the user model can become nonlocal. Keywords interact through composition operators; references may cross files, URIs, and dialect boundaries; object openness versus closure has historically been nuanced; defaults are often mistaken for runtime behavior even though validation does not necessarily apply them; “format” constraints are often advisory or validator-dependent; and error messages can be technically correct but poor at explaining a human fix. A user looking at a failed `oneOf` may get a report derived from every rejected branch, rather than a clear statement of the intended variant and the nearest repair.

Its most silent failure mode is the gap between **describing a contract** and **having every producer and consumer honor the same contract**. A schema may say a field has a default, but one producer omits it and a consumer does not materialize it. A schema may describe URI, email, or date-time, but validators vary in strictness. A schema may permit extra properties intentionally for forward compatibility, while a misspelled key slips through forever. Conversely, sealing an object catches typos but turns benign producers ahead of the consumer into hard failures. The lesson is not “do not use a constraint language.” It is that every constraint has a compatibility posture, and that posture must be legible in the source.

For a prose-and-data notation, I would borrow the good part: schemas ought to be portable, composable, inspectable declarations. I would be wary of reproducing a system where the schema is technically expressive but ordinary authors cannot predict its behavior from the nearby lines.

## 4. XSD and XML show the cost of making the abstract model more important than the authored document

XSD brought genuinely strong capabilities: typed content, named reusable declarations, namespaces, constraints, identity-like concepts, and a detailed formal model. In domains that need long-lived machine contracts—publishing pipelines, documents exchanged among institutions, enterprise integrations—it has provided a useful degree of precision. XML tooling could use schemas to drive completion, validation, object bindings, and transformations.

The painful side is that users can end up managing a substantial second language whose conceptual shape does not match how they think about the document. Namespace mechanics are famously powerful and famously unfriendly in hand-authored material. The distinction among elements, attributes, text content, complex types, particles, substitution groups, and content models can be precise while still being miserable to infer during an edit. Small changes frequently reveal a large amount of hidden machinery. Documents can become “schema-valid” in ways no one would regard as good writing, or invalid for reasons that reflect a formal content model more than author intent.

For the proposed format, the warning is not merely “avoid angle brackets” or “avoid namespaces.” It is: **do not force authors to translate their document into an alien schema ontology.** If the base notation lets prose and structure interleave freely, the schema layer should not imply that prose must be reified as an awkward mixed-content exception, nor that structural content must be rearranged to fit a theoretical grammar. The authored surface should remain the primary reality; the schema should clarify it, not replace it with an abstract data model that happens to serialize into the surface language.

## 5. Protobuf is excellent at stable messages and weak at describing human-authored open documents

Protobuf’s major success is a narrow and important one: it gives programs stable message contracts, compact encodings, generated code, and a disciplined compatibility vocabulary. Field numbers make wire compatibility explicit. The conventions around reserving removed fields, adding optional fields, and avoiding destructive renumbering give teams a practical way to evolve data over time. That is a remarkable achievement, and a schema analysis should take the evolution discipline seriously.

Yet protobuf schemas are not an especially good model for a free-form document language. They assume a message-oriented world, typically with a designated producer and consumer; they prioritize encoded interoperability over readable authoring; and they largely avoid meaningful prose, comments as content, local narrative organization, and user-authored extensions. Requiredness has been historically fraught because it freezes evolution. Presence semantics, default values, unknown fields, oneofs, maps, and generated-language ergonomics can each create surprises. The schema can say something very precise about the payload while saying little about a human’s intended document or about the process that produced it.

The important lesson is that **schema evolution needs a first-class story**, even if the representation is not protobuf-like. Users need to know whether unknown fields are tolerated, retained, ignored, warned on, or rejected; whether a new required property is permitted; whether changing a scalar kind is breaking; whether a rename is a semantic identity change or an alias; and how old tooling behaves when it sees new documents. A document format should not inherit protobuf’s message model, but it should envy protobuf’s insistence that compatibility is designed rather than wished into existence.

## 6. CUE and Dhall reveal the value—and the social cost—of schemas that are executable or programmable

CUE and Dhall represent a different aspiration: do not merely validate data with a separate, impoverished language; make the language for configuration, types, constraints, defaulting, composition, and generation coherent. This can be delightful. Constraints can be composed rather than copied. Defaults can participate in a real model. Reuse can be principled. If a configuration is derivable, it can be computed rather than manually duplicated. In CUE in particular, unification offers a compelling way to say that multiple sources of constraint all narrow the same value.

The cost is that the “schema” stops being a simple declaration and starts becoming a program or a program-adjacent calculus. That raises the learning curve, makes evaluation rules central, and can make diagnostics difficult for ordinary authors. A user editing a field may need to understand imports, definitions, hidden fields, interpolation, unification, evaluation order or normalization, and the difference between a constraint and a concrete value. Dhall’s strong guarantees and totality are valuable, but they demand a mode of authoring that can feel remote from “I need to change this one configuration line.” CUE’s elegance can similarly make it easy to construct configurations whose origin and effective value are hard to see at the editing site.

This is a vital fork for the new format. If schema can compute, import, and generate arbitrarily—or even moderately—it creates enormous power but shifts the system toward a programming environment. That may be right for some applications, but it should be an explicit choice. I would strongly want a **non-programmable, locally legible core** that handles common document constraints. Computation, if later wanted, should have clear boundaries: what it can read, when it executes, how it is cached, whether it is deterministic, how it affects trust, and how a human can inspect the resulting effective schema.

## 7. ORM migrations solve a real problem that validation schemas usually do not touch

Rails and ActiveRecord migrations, and similar resource-oriented systems, point to an underappreciated distinction: a schema is sometimes not a static description but the history of how a living system changes. A migration can create a table, add a column, move data, backfill a value, split a field, create an index, and—in principle—roll back. It connects structural change to operational change. It answers the practical question: “What happens to all the existing things?”

That is valuable because simply changing the declared shape does not migrate existing data. A new required field may be perfectly described in a validator but leaves every old document invalid. A renamed status or split object may need human judgment. An enum change may be forward-compatible for writers but not for downstream tools. A structural constraint system alone tends to conceal this gap until a repository-wide change becomes urgent.

However, migrations are also easy to fetishize. They presume control over data lifecycle and often a centralized operational environment. They can become irreversible in practice, depend on application code or external services, and are frequently unsafe to replay indefinitely. For distributed human-authored documents, “up” and “down” migrations may be a false promise: prose cannot always be transformed losslessly, a split concept may require interpretation, and an old representation may contain distinctions the new model cannot preserve.

I would therefore hope the schema analysis asks whether there should be a **migration protocol**, not necessarily a universal migration language. At minimum, schemas should carry clear version identity, declared compatibility expectations, and an ability to attach or point to transformations. It should distinguish mechanical rewrites, lossy rewrites, and transformations requiring a human decision. An agent needs that distinction intensely: a mechanical conversion may be safe to perform; a prose-sensitive reinterpretation should be surfaced as a question rather than silently automated.

## 8. GraphQL SDL and OpenAPI show that schemas become public interfaces, documentation systems, and political boundaries

GraphQL SDL is attractive because it is concise, readable, and close to the API model users care about. It supports types, fields, arguments, enums, documentation strings, and relationships. Introspection and tooling make the schema discoverable. OpenAPI similarly offers a broad contract surface: endpoints, inputs, outputs, authentication concepts, examples, and often references into JSON Schema. In both cases, schema can unlock generated clients, documentation portals, mock servers, request validation, test generation, and organizational coordination.

The downside is that a schema can become an aspirational interface description that drifts from runtime behavior. Generated output may be technically usable but unpleasant and too generic. The abstraction may erase business semantics: a field called `status` with an enum tells you its allowed strings but not how a human should choose among them or what transitions mean. GraphQL’s type system can declare a non-null field while actual resolver behavior remains operationally fallible. OpenAPI specifications can be huge, difficult to hand-maintain, and full of examples that silently become stale.

The lesson for a document format is that **documentation must not be an afterthought glued onto validation**. The same schema node should ideally be able to answer, in context: What is this? Why is it here? Who owns it? What values make sense? What happens if it is omitted? What nearby examples show idiomatic use? What changed in this version? If the only documentation lives in a separate site or generator output, the person editing a narrow excerpt loses it precisely when they need it. Prose attached locally to schema elements has value, but it must be usable without making the schema itself bloated or impossible to scan.

## 9. TypeScript types over JSON are wonderful as an internal aid and dangerous as a claim about reality

TypeScript teaches a very practical lesson: types can dramatically improve local authoring even when they do not prove that external data conforms. Types make completion, refactoring, navigation, and many categories of mistake detection far better. Discriminated unions are especially valuable for modeling variants in a way that code and tools can understand. The ecosystem is productive precisely because types sit close to ordinary programming work.

But TypeScript’s structural typing and erasure also demonstrate a dangerous mismatch: a type declaration can look like a runtime contract while doing nothing to validate incoming JSON. Assertions can silence type errors without changing data. Optional fields, `any`, widened inference, excess-property checking that behaves differently for literals versus variables, and framework-specific serialization can all create gaps between the apparent model and what is actually present. A user sees a neat type and may assume safety that has not been earned.

For a schema layer in a document language, I would insist on being explicit about whether a schema is **descriptive, checked, coercive, generative, or authoritative**. “This document has type `Person`” could mean at least five things:

1. A tool may use that name for completion and documentation.
2. A validator verifies it strictly.
3. A loader coerces values into that shape.
4. A generator emits a corresponding runtime type.
5. The declaration controls what a consumer will accept.

Those should not be smuggled together. This matters for agents because an agent needs to know whether it is merely editing toward a convention or actually satisfying a checked contract.

## 10. Tree-sitter grammars make a crucial distinction: syntax recovery is not semantic validity

Tree-sitter and related incremental parsers demonstrate something indispensable for a format intended to be edited: tooling must remain useful while the document is unfinished or wrong. A user is constantly in a transient state—half a heading renamed, an indentation level not yet repaired, a list item incomplete, a delimiter temporarily unmatched. A grammar that only recognizes completed valid documents is insufficient for real editing. Error recovery, incremental parsing, stable node identity, and partial structure are the reason editors can still highlight, fold, navigate, and select a document during change.

At the same time, a grammar cannot be the whole schema. It can recognize forms but generally does not express domain meaning, repository policy, cross-file identifiers, version compatibility, or migration intent. When people overload syntax rules with semantic restrictions, they often damage recoverability and make error messages worse. A parser may tell an author that a token is unexpected when the real issue is “you used a task-only field inside a milestone.”

I would want the schema architecture to protect the editing experience as a primary requirement. It should define behavior for partial documents deliberately:

- Can tools select a provisional schema branch when a discriminator is not written yet?
- Does an incomplete typed value produce a tentative diagnostic or a hard error?
- What schema does an inserted blank node have?
- Can a document contain a locally invalid region without making all surrounding structure opaque?
- Are errors attached to the smallest relevant source span?
- Can a tool propose valid next structures rather than only report invalid current ones?

This may sound like an implementation concern, but it should shape the schema model. A design that cannot provide graceful partial interpretation will be hostile in precisely the narrow-edit situation you describe.

## 11. Examples are schemas of a kind, but their strength is social rather than exhaustive

An example document is often the best schema for a human author. It shows ordering, tone, comments, idiom, realistic values, nesting patterns, what is normally omitted, and how prose is written around the data. It has a low learning cost and works in any environment. In an unfamiliar repository, pattern matching from neighboring files is frequently more useful than reading a formal type declaration. Examples are also resilient: they can communicate intent even to people and tools that do not know the schema language.

But examples are poor at stating boundaries. They cannot reliably tell you whether a field is required or merely present here, whether another variant is allowed, whether ordering matters, whether an unshown value is invalid, or how two occurrences relate. Copying an example can propagate stale identifiers, inappropriate defaults, security settings, or accidental quirks. A single example is usually overfitted; ten examples may communicate conflicting conventions without identifying which differences are intentional.

I would not frame this as examples versus formal schemas. A strong schema layer should treat examples as first-class evidence and tooling input. A schema declaration should be able to associate multiple named examples: minimal valid form, ordinary idiomatic form, edge cases, legacy form, and anti-example with the reason it is rejected. Conversely, an example should be able to declare which schema and version it demonstrates. The major risk is automated inference that mistakes observed regularity for a requirement. Example-derived suggestions should be visibly provisional unless ratified as constraints.

## 12. Convention is not “no schema”; it is an undocumented, probabilistic schema with weak ownership

When teams say a repository has no schema, it usually has conventions: field spellings, ordering, filename conventions, preferred prose headings, lifecycle states, cross-file references, indentation patterns, default assumptions, and cultural rules about what changes require review. These are schemas in the broad sense, but they live in examples, code paths, reviewers’ memories, CI scripts, and accidental historical artifacts.

Convention makes authoring flexible and lets a format grow before its concepts have settled. It avoids premature formalization. It can accommodate prose, exceptions, and social nuance that a rigid constraint language would flatten. It is also what users naturally use in an unfamiliar repository: nearby lines become the local contract.

Its failures are silent and unequal. A newcomer cannot tell whether a pattern is a rule, preference, accident, or legacy exception. Different tools infer different conventions. A typo can look plausible indefinitely. Reviewers become the sole validators, and the person who knows why a convention exists becomes a bottleneck. Automated editors are especially vulnerable: they can reproduce local patterns while reinforcing a mistake or selecting an obsolete form.

I would want an incremental route from convention to declared knowledge. Perhaps a schema layer should support declarations with levels such as “illustrative,” “recommended,” “deprecated,” “required,” and “forbidden,” rather than forcing an all-or-nothing jump from free convention to hard invalidity. The key idea is that a schema can record confidence and policy strength. Not every useful bit of structure deserves to make a file fail validation.

## 13. Prose requires schemas to become rhetorical and editorial, not merely structural

For prose, a schema cannot and should not generally validate truth, quality, elegance, argument, or usefulness. Attempts to do so usually produce superficial proxies: word counts, required headings, keyword presence, readability scores, or mandatory boilerplate. Such rules can be appropriate for a form, compliance record, release note, or regulated document, but they can easily make writing formulaic and cause authors to optimize for passing the checker rather than communicating.

Still, prose has structure worth naming. A proposal may have a title, context, decision, consequences, alternatives, and open questions. A runbook may need preconditions, procedure, verification, rollback, and escalation. A profile may need a narrative section, chronological entries, and supporting links. A policy may distinguish normative requirements from explanatory rationale. These are not merely data fields; they guide reading and maintenance. A format that interleaves prose and data could make those relationships visible without forcing prose into JSON-shaped string fields.

What I have seen work conceptually is **soft structural guidance around prose**: section roles, repeatability, ordering recommendations, audience or status metadata, link and citation expectations, templates, and lint-like diagnostics that can be acknowledged or configured. What tends to fail is pretending all prose has a universal canonical structure, or requiring authors to put meaningful narrative inside an opaque `description: |` blob because the data model cannot accommodate interleaving.

The schema should be able to say, for example: “This document normally begins with an executive summary; each decision has a rationale in prose and may have structured consequences; this section is optional but recommended for externally visible documents.” That is a different modality than “field required.” I would want the system to support that distinction in both language and diagnostic presentation.

## 14. The most useful unit may be a declared document role, not a universal global schema

I mildly disagree with treating “the schema layer” as one monolithic layer. In a document-and-data notation, I suspect the most useful first-class concept is a **document role** or **resource kind**: a named, versioned description of what a particular document—or a region of a document—is trying to be.

A role can own several things at once:

- Its local shape and permitted constructs.
- Its human-facing description and examples.
- Its compatibility version.
- Its validation profile, including whether unknown content is tolerated.
- Its links to external semantic checks.
- Its editor affordances and preferred template.
- Its migration history or transformation hooks.
- Its extensibility points.
- Its declared authority: normative contract, recommendation, or private convention.

This is often more practical than a universal type algebra that tries to describe every possible tree. A `deployment`, `research note`, `service catalog entry`, `invoice`, `ADR`, and `person profile` have different evolution and authoring needs. A field-level type system can be a component of this, but it should not be the only organizing concept.

The complication is composition: documents will contain reusable fragments and nested roles. The analysis should therefore explore roles, fragments, and embedded regions separately. A fully embedded schema system could become confusing quickly if every paragraph switches contexts implicitly. I would favor explicit, inspectable boundaries and a tool-readable “what role am I editing right now?” answer.

## 15. Extensibility and closedness are not a minor option; they determine whether the ecosystem can evolve

One of the hardest decisions is whether a schema declares an object or region to be open or closed. Closed schemas catch misspellings and enforce a clear contract. Open schemas allow evolution, local metadata, vendor extensions, experimental fields, and forward compatibility. Both are necessary. The failure is choosing one as a global default without a vocabulary for the tradeoff.

In practice, documents often need an extension mechanism that is neither “any random unknown key is okay” nor “every evolution requires a central schema release.” The best designs make extension ownership visible. An extension should have a namespace or identity, documentation, compatibility story, and ideally a way for tools to distinguish recognized extensions from arbitrary typos. But the mechanism must remain pleasant for hand authors. If it requires a page of ceremony for a single local annotation, users will route around it.

For prose-heavy documents, extensibility may also mean “this document can contain additional narrative sections,” not only unknown fields. The schema system must distinguish an unknown structured field that might be a mistake from an unrecognized prose heading that may be a perfectly legitimate addition. That suggests schema rules should be scoped to the kind of thing they constrain—structured nodes, section roles, values, references—rather than treating the entire document as a closed record.

## 16. Error design is schema design, especially for constrained and automated editors

A schema system should be judged by the errors it produces for a person with only a local excerpt and a narrow edit tool. “Expected one of …” may be correct but insufficient. A useful diagnostic answers five questions:

1. What did the tool understand this node to be?
2. Which rule applies and where did it come from?
3. What is wrong in human terms?
4. What are plausible repairs?
5. Is the result definitely invalid, merely suspicious, unresolved, deprecated, or incompatible with a target version?

Provenance is essential. If a field is prohibited because of a base schema, overridden by a document role, and tightened by a repository policy, the user should be able to inspect that chain. Otherwise schema composition becomes indistinguishable from arbitrary tool behavior.

For automated editing, errors should also be machine-actionable. A diagnostic that says “use a value from this enum” should expose the options. “Missing required child” should say which insertion sites are valid and whether a template exists. “Reference unresolved” should identify the expected target role and search scope. “This version is obsolete” should point to a named migration or a replacement construct. A system that exposes only rendered strings leaves agents guessing; a system that exposes structured constraints lets agents make safe proposals.

I would insist on a mode where tools can report **repair confidence**. Some fixes are mechanical: insert a missing explicit default, rename a field according to an alias map, normalize an enum spelling. Others require context: choose an owner, decide whether a note is a warning or a decision, resolve ambiguity in a prose-sensitive migration. Schema tooling should not blur the distinction.

## 17. Code generation is a tempting output, but the schema must not be designed around the least expressive target language

Schema-based generation can be valuable: typed models, parsers, editor metadata, forms, documentation, query APIs, test fixtures, conversion code, and static analysis. It is tempting to choose the schema language by asking which one generates clean classes in a favorite target language. That is too narrow, especially for a notation whose central promise is human-authored documents and prose.

The lossy directions deserve equal attention. A document schema may express ordered mixed prose and structured blocks, aliases, custom literal syntax, annotations, deprecations, uncertainty, partial nodes, and context-sensitive roles. Many ordinary programming language type systems cannot represent all of that. If generation is treated as authoritative, the schema will be pressured to erase the things that make the document language valuable. The generated model becomes the hidden “real” language, and authored documents become merely serialization.

Instead, I would want a capability matrix for each proposed schema feature. Can it generate:

- A runtime validator?
- A lossless document model?
- A convenient application model?
- A form or editor interaction?
- Documentation?
- A migration scaffold?
- A query or indexing model?
- Test data?
- A stable API contract?

For each target, what semantic information is lost? Naming that loss early prevents false assurances. It is completely acceptable for some schema features to be editor-only or documentation-only, as long as the system says so.

## 18. Predictable mistakes: importing a mature ecosystem wholesale, treating validation as binary, and formalizing the wrong things too early

A team opening this question will predictably be tempted to select a familiar answer: “JSON Schema but in our syntax,” “protobuf for documents,” “a dependent type system,” “a graph of resource classes,” or “a grammar plus annotations.” Each imports real strengths, but each carries assumptions about what documents are, who authors them, where truth resides, and how evolution happens. The new format’s unusual property—prose and structure freely interleaved—means it should be especially suspicious of solutions designed for pure records, wire messages, or programming-language configuration.

The next predictable mistake is binary validation. Human work is full of drafts, placeholders, intentional extensions, unresolved references, legacy forms, and policy exceptions. If all deviations are errors, users turn off validation or add escape hatches everywhere. If everything is only a warning, schema loses its protective value. The system needs a principled severity and lifecycle model: invalid, incomplete, unresolved, deprecated, discouraged, informational, and policy-dependent are meaningfully different conditions.

Another predictable mistake is making the schema language maximally expressive before proving the editing loop. Every additional composition operator, conditional, computed expression, reference indirection, or inheritance mechanism can be justified by a real use case. Together, they create a language that only specialists can understand. I would prioritize local legibility, partial-document behavior, diagnostics, versioning, and extension boundaries before advanced expressiveness.

## 19. The under-explored direction is schema as a collaboration protocol, not only a constraint system

The direction I think is most often under-explored is treating schema as a way for humans and tools to negotiate responsibility. A useful schema is not just a list of forbidden trees. It says who owns a concept, what is stable, what is experimental, what a local author may extend, what must be synchronized with another file, what can be safely automated, and what requires a decision.

This implies features that conventional validators often neglect:

- Ownership and contact metadata for a role or field.
- Stability labels: experimental, stable, deprecated, removed.
- Explicit compatibility targets and consumer profiles.
- A vocabulary for normative versus advisory guidance.
- Structured “why” documentation for non-obvious rules.
- A declaration of whether unknown content is preserved by tools.
- A record of source-of-truth direction when generated artifacts exist.
- A way to say “this rule is checked only in a particular repository, deployment, or publishing profile.”
- Rich examples associated with versions and intended audiences.
- Migration guidance that distinguishes mechanical and interpretive changes.

These are not glamorous type-system features, but they determine whether schema makes a shared repository easier to live in. They are also exceptionally useful to an agent. The most dangerous thing for an automated editor is not a missing scalar type; it is an invisible social contract. If the schema can externalize enough of that contract without pretending it has formalized all human judgment, it has done something genuinely new and valuable.

## 20. My strongest design preference: begin with a small, inspectable declaration system and make every escalation explicit

If I were shaping the initial direction, I would want a small schema core that can express local roles, typed values, cardinality, named variants, local documentation, examples, open/closed extension posture, stable identifiers, and version/deprecation metadata. It should work over partial documents, preserve unknown content when configured to do so, and produce structured, source-local diagnostics. It should have a clear way to attach external validators and migrations without pretending they are intrinsic local constraints.

I would deliberately defer or isolate the seductive expansions: arbitrary computation, implicit coercion, deep inheritance, complex conditionals, global query constraints, remote reference resolution, and universal reversible migrations. They may become necessary, but each should arrive because a concrete class of documents cannot be served otherwise—and with an explicit explanation of its impact on authoring, offline use, partial parsing, compatibility, and error quality.

The defining standard should be this: a person or agent opening a small unfamiliar region of a document should be able to discover what it is, what may go there, why, what is safe to change, and what further context is required—without needing to run a whole system, understand a second programming language, or reverse-engineer conventions from historical accident.
tokens used
22,743
I can give you a genuinely independent, beginner’s-mind analysis of the design space, and I will not inspect the project or its files. One caveat: I do not have personal lived experience in the human sense, so I cannot honestly claim first-hand use of JSON Schema, Rails, or editors. What I can offer is a synthesis grounded in the recurring failure modes and affordances of those systems—the perspective I would optimize for as an editor of unfamiliar structured documents under narrow, imperfect tooling.

## 1. The first question is not “what is the schema language?” but “what promises can a schema make?”

I would hope the analysis begins by separating the promises that people commonly bundle under the word *schema*. A schema may be promising at least all of these:

- What shapes of document are accepted?
- What does each part mean?
- Which values are valid?
- Which fields are required, optional, repeated, or mutually exclusive?
- What references are valid across a document or repository?
- What version is this document written against?
- How should old data become new data?
- What editor affordances can be derived?
- What code or APIs can be generated?
- What is safe for an automated editor to change?
- What constraints should be checked immediately, later, or only with external context?

Those are not one feature. They have different owners, different error models, and different compatibility stories. A format team can do a wonderful job designing structural validation and still leave users stranded on migration, documentation, incomplete files, semantic reference checks, or safe automated edits.

I would be disappointed if the analysis asked only, “Can we express types, required properties, arrays, and enums?” That is the table-stakes question. I would also be disappointed if it treated validation as the end product. For many users, validation is not the chief value. The chief value is being able to confidently make one small change in a document one does not fully understand—knowing what the local unit is, what else must change with it, what defaults apply, and whether the change is compatible with a downstream reader.

The question I would put at the center is: **what new practical action becomes reliable once a document has a schema?** If the answer is only “a validator can reject it,” that may be useful, but it is much smaller than the design opportunity.

## 2. Schema has at least four time horizons, and collapsing them creates pain

A comprehensive analysis should distinguish constraints by when they are knowable.

First are **lexical and syntactic constraints**: this is a number, this nesting is legal, this tag spelling is valid. These should generally be immediate, deterministic, and work on incomplete documents as much as possible.

Second are **local structural constraints**: a `task` has a title; an `invoice` contains line items; a `status` is one of a finite set; an object has at most one `id`. These can often be checked with just the local node or document.

Third are **semantic and cross-reference constraints**: a dependency names an existing package; a parent ID exists and has the appropriate kind; dates are chronological; totals equal their entries. These need more context, and they frequently create editor friction if treated like syntax errors.

Fourth are **environmental or policy constraints**: the referenced file exists in this repository; a URL is reachable; an account has permission; a version is supported by the current deployment; a secret has been provisioned. These are real constraints, but they are not intrinsic properties of a document. They may vary among machines, branches, times, and users.

A bad schema system makes all four look equivalent. Then users see a red error marker because a remote service cannot be reached, or cannot draft a document because the object it refers to will be added in the next commit. A good system lets tools state: “the document is structurally invalid,” “this is structurally plausible but semantically unresolved,” and “this is valid under the local schema but unverified against the current environment.” That distinction becomes especially important for agents and narrow edit interfaces, where the ability to make incremental progress matters more than a binary pass/fail result.

## 3. JSON Schema is powerful precisely where it becomes hard to reason about

JSON Schema demonstrates the appeal of a rich declarative constraint language: it can describe scalar types, nested structures, object properties, arrays, ranges, patterns, alternatives, reuse through references, and more. This is a substantial improvement over convention when consuming untrusted APIs or configuration. It creates a portable validation artifact and, in many cases, enables forms, documentation, completion, and test fixture generation.

But JSON Schema also shows how quickly the user model can become nonlocal. Keywords interact through composition operators; references may cross files, URIs, and dialect boundaries; object openness versus closure has historically been nuanced; defaults are often mistaken for runtime behavior even though validation does not necessarily apply them; “format” constraints are often advisory or validator-dependent; and error messages can be technically correct but poor at explaining a human fix. A user looking at a failed `oneOf` may get a report derived from every rejected branch, rather than a clear statement of the intended variant and the nearest repair.

Its most silent failure mode is the gap between **describing a contract** and **having every producer and consumer honor the same contract**. A schema may say a field has a default, but one producer omits it and a consumer does not materialize it. A schema may describe URI, email, or date-time, but validators vary in strictness. A schema may permit extra properties intentionally for forward compatibility, while a misspelled key slips through forever. Conversely, sealing an object catches typos but turns benign producers ahead of the consumer into hard failures. The lesson is not “do not use a constraint language.” It is that every constraint has a compatibility posture, and that posture must be legible in the source.

For a prose-and-data notation, I would borrow the good part: schemas ought to be portable, composable, inspectable declarations. I would be wary of reproducing a system where the schema is technically expressive but ordinary authors cannot predict its behavior from the nearby lines.

## 4. XSD and XML show the cost of making the abstract model more important than the authored document

XSD brought genuinely strong capabilities: typed content, named reusable declarations, namespaces, constraints, identity-like concepts, and a detailed formal model. In domains that need long-lived machine contracts—publishing pipelines, documents exchanged among institutions, enterprise integrations—it has provided a useful degree of precision. XML tooling could use schemas to drive completion, validation, object bindings, and transformations.
