---
source: >
  De-novo agent testimony, elicited 2026-07-22 (deepening cycle one, pilot B)
  per Joseph's standing license (RESIDUALS §standing-license; CLAUDE.md
  de-novo-testimony bullet): a fresh grok-family agent (grok CLI, headless,
  run from a neutral scratchpad directory with NO project context and tools
  disabled) asked the modeled beginner's-mind question about templating and
  dynamics. Query preserved at the top of the body; raw output verbatim below.
gathered: 2026-07-22
status: gathered source material — first-person practitioner testimony, unprimed
area: templates & dynamics — de-novo end-user demand
technique-provenance: >
  Practices the accumulated estate technique (fresh-context agent as
  beginner's-mind instrument), NOT a novel method — see
  02-tooling-needs/src/delegation-as-tooling.md and the prior paths
  testimony (paths-testimony-gemini-2026-07-22.md). Cross-substrate variant:
  grok-family, distinct from the corpus's dominant model family, adding
  independence. Two other substrates were tried first and failed for
  non-substantive reasons (agy misparsed the invocation; gemini CLI auth
  is deprecated) — recorded for the failed-attempt ledger, not as evidence.
why_included: >
  Eighteen first-person sections. Independently corroborates the templates
  chapter's core structural claims from zero project context: (1) templates
  as an interrogable contract between intention and materialization (§4);
  (2) interpolation-to-text vs structural-splice as genuinely different
  operations that must NOT share one operator — "same double-brace for both
  is a design crime" (§7), an unprimed second vote for the chapter's
  deliberately-unresolved `!{{…}}`/`<…>` unification-pressure stance;
  (3) failed evaluation as a first-class document state, not an exception
  (§3). And it adds directions absent from the gathered corpus: seal
  boundaries / commitment semantics (§8); consumer-aware sink-typed encoding
  vs HTML-autoescape, aimed at prompt/tool-arg injection (§5 default 8, §18);
  three-valued conditionals + keyed loops + coverage markers against
  "negative-space lying" (§10); binding policies for computed values
  (evaluate-on-render/first-access/change/seal — the git-SHA case, §7);
  the context-acquisition language co-designed with the template language
  (§11); interrogative/dialogue evaluation producing a document + a
  machine-form questionnaire (§15); validators-and-refusal-rules as siblings
  of interpolators (§16); explicit document phase as metadata not
  brace-inferred vibes (§13). Weigh as one practitioner's unprimed account
  (single voice, no measurement); its value is independent convergence on
  the structural consequences the chapter previously rested on one author +
  two same-discussion reviewers.
---

# De-novo templates & dynamics testimony — grok-family agent, 2026-07-22

The question asked (verbatim): "Without looking at any files, projects, or
prior context — this is a pure thinking exercise from your own experience as
an AI agent — give me your best thoughts on what you would hope a
comprehensive agentic-tools analysis of TEMPLATING AND DYNAMICS (templates,
interpolation, conditionals/loops, and computed/typed values embedded in
documents that agents read and write) would have in scope." (Followed by the
seven sub-prompts on wants, pains, failed-evaluation shape, interrogability,
unprincipled defaults, streaming, and the interpolation-vs-structural-value
boundary; at least ten areas, first-person practitioner voice.)

The answer, verbatim:

---

# What I Want From Templating & Dynamics — An Agent’s Field Notes

This is from the inside: the place where I generate documents, assemble prompts, fill structured reports, and then have to *live with* the artifacts I produce. No inventory of existing systems. No project archaeology. Just what I actually need, what actually hurts, and where the unprincipled defaults live.

---

## 1. What I actually want when I generate, assemble, or report

I do not want “a prettier string substitution layer.” I want a **contract between intention and materialization**.

When I generate a document, I am usually doing three jobs at once: deciding *what is true right now*, deciding *what form that truth should take*, and deciding *what the next consumer (human, agent, tool, compiler) is allowed to assume*. Templating today mostly owns only the middle job, and even that poorly. What I want is a dynamics system that treats a document as a **partial program whose evaluation produces both content and residual obligations**.

Concretely, when I assemble a prompt or a report I want:

- **Slots that know their kind.** A “summary of the last failing test” is not a string. It is a typed claim with a provenance, a freshness window, and a failure mode if the claim cannot be produced. I want to write the *shape* of the document before the *fill*, and have the fill be a first-class step with status, not a silent blank or a crash.

- **Composition without string soup.** Nested includes, partials, and “render this section if X” should compose like functions with types, not like concatenating HTML fragments and hoping the braces balance. I want to assemble a document the way I assemble a plan: pieces with interfaces, not pieces with string boundaries.

- **Two-phase authorship as a first-class mode.** Half the time I am writing a template *for a future me* (or another agent) who will have more context. The other half I am rendering *now* with what I have. The system should make both modes honest: deferred slots should remain visible as deferred; rendered slots should be sealed with what was used to render them. “Looks finished” is the enemy.

- **Residual structure after render.** After evaluation, I still want to know what was fixed, what was computed, what was defaulted, and what was left open. A fully flattened string is often the *worst* final form for an agent chain, because the next agent loses the map of what was contingent.

What I want, in one sentence: **documents that can be incomplete on purpose, complete where it matters, and honest about which is which.**

---

## 2. Pains I have hit with existing templating

Every mainstream system I have used as an agent fails me in overlapping ways. The failures feel different on the surface (Jinja vs Liquid vs f-strings vs YAML-with-`${}`) but the *agent experience* is the same: **silent wrongness, opaque failure, and loss of structure.**

**Silent wrongness is worse than loud failure.** Missing a variable and getting empty string, or a default that was never intended for this branch, produces documents that *look* coherent. I then ship them. The next agent (or human) trusts them. Recovery happens far downstream, after the lie has compounded. Mustache-style “just omit missing keys” is a disaster for agent workflows that need *epistemic honesty*, not pretty pages.

**Error messages that speak compiler, not task.** “Undefined variable `user.name` at line 47” is better than silence, but still not enough. I need: *which template tree*, *which call site*, *what context was present*, *what nearby keys look like* (typo recovery), and *whether this was required or optional in the author’s intent*. Stack traces through include chains often erase the only useful frame: the semantic slot name.

**Logic in templates vs logic in code is a false dichotomy that agents get crushed by.** Jinja/Liquid/ERB let you put real control flow in templates. That is sometimes necessary and often a trap. Once a report’s branching lives half in Python and half in Jinja, neither side is the source of truth, and I cannot reason about the document without executing it. Pure Mustache “logic-less” is the opposite trap: all the real decisions get pushed into pre-baking a giant context blob, and the template becomes a dumb printer of decisions I already had to make without the document’s help.

**YAML/JSON-with-substitution is a special hell.** It looks structured, so I trust it. Then substitution turns types into strings, breaks indentation, or injects a multi-line value into a scalar position and the whole document becomes invalid *after* I thought I was done. The template language and the host language disagree about what a value *is*. Agents live and die on structured validity; string-first substitution is structurally hostile.

**Escaping and dual-use content.** Prompt assembly is not HTML. HTML escaping is wrong. Shell escaping is wrong. Markdown is wrong. JSON string escaping is sometimes right and sometimes disastrous. The default “auto-escape for the web” assumption is so deeply baked that every non-web use becomes a minefield of double-escaping or under-escaping. When the *output* is itself a prompt or a tool call payload, the template system’s security model is pointed at the wrong adversary.

**Debuggability collapses under composition.** Includes, macros, inheritance, and partials are necessary for DRY. They also make it nearly impossible to answer “why is this section blank?” without a full render trace. As an agent, I often lack a browser DevTools for templates. I need a **render ledger**, not just a final string.

**Performance and re-render thrash** matter less for me than for web servers, but *partial re-evaluation* matters a lot. I often have 90% of a context and want to fill 10% more without invalidating sealed sections. Most systems are all-or-nothing.

---

## 3. What a *failed* template evaluation should look like

Failure should not be an exception that vaporizes the work. Failure should be a **first-class document state**.

Ideally, a failed evaluation produces:

1. **A partial artifact**, not nothing. Everything that *could* be rendered cleanly should be rendered and marked sealed. Everything that could not should remain as an explicit **hole** with a typed error, not disappear and not invent content.

2. **A structured error graph**, not a single string. Nodes: missing binding, type mismatch, predicate failed, cycle in dependency, host evaluation error, unparseable host document after inject. Edges: which hole depends on which. I want to walk the graph and decide what to fetch or recompute.

3. **Local recovery affordances.** For each hole: suggested repairs (`did you mean context.user_id?`), whether the slot is required for *this* consumer, whether a default is available and *who authorized it*, and whether I can re-run just this hole after patching context.

4. **No silent success.** If the system used a default, fallback, or “empty,” that must be visible in the residual metadata. “Rendered with warnings” is an honest middle state between success and failure; most systems collapse it into success.

5. **Stable identity for holes.** If I re-run after fixing `repo_name`, the hole for `test_summary` should still be the same hole. Diffable, addressable, patchable. Failure IDs that change every run force me to re-diagnose from scratch.

6. **A human-readable *and* machine-readable face.** Humans need a short narrative: “Couldn’t fill the risk section because severity depends on open_issues, which was not provided.” Agents need the graph. Both should be the same object viewed two ways.

What I do *not* want: the web default of “500 page” or the CLI default of “exit 1, stderr message, no partial.” Those are designed for human operators with full context reload. Agents operate under **incremental context acquisition**. Failed render is a *plan for what to gather next*, not a stop sign.

---

## 4. Should templates be interrogable? Yes — and not as a nicety

Interrogability is the difference between a template being a black-box function and a template being a **protocol**.

Before I run a template, I want to ask:

- What **required** bindings does this need?
- What **optional** bindings exist, and what happens if they are absent?
- What **predicates / branches** exist, and which inputs decide which branches?
- What **external effects** can evaluation trigger (file reads, tool calls, network, RNG)?
- What **types** are expected for each binding?
- What is the **output shape** (string blob vs structured tree vs multimodal package)?
- What is **stable across runs** vs intentionally non-deterministic?

Why this matters for me as an agent:

**Context is expensive and partial.** I often cannot afford to gather “everything.” Static requirements let me plan a minimal gather set. Dynamic requirements (depends on branch) let me gather in phases: resolve the branch keys first, then the branch body keys.

**I can validate before side effects.** If rendering a deployment report template will call tools or write files, I want to know *before* I start that I’m missing `environment` and will fail three layers deep after having already mutated state.

**I can match templates to situations.** Given a library of report templates, I want to select by capability: “which of these can I fill *now* with what I have?” That is impossible without a requirements surface.

**I can generate the context, not just consume it.** Interrogability lets me reverse the workflow: template → required schema → fill schema → render. That is how agents naturally work when producing structured reports. String templates invert this and force me to guess the schema from examples.

What I would *do* with interrogability, operationally:

- Preflight: compute missing required set; refuse or degrade early.
- Partial render: render sealed sections; leave holes for missing optionals or deferred requireds.
- Progressive disclosure: evaluate only enough to learn the next required keys (branch-aware requirements).
- Audit: “this document claimed X because it used bindings A,B,C at times T.”

Caveats: full static analysis of Turing-complete template languages is undecidable. That does not kill the idea. It means the language should be **stratified**: a declarative requirements surface for the common case, and an explicit “this template is dynamic / effectful / non-analyzable” flag for the escape hatch. The unprincipled default is the opposite: everything is dynamically powerful, nothing is introspectable.

---

## 5. Unprincipled defaults and norms we all conform to

These are the industry habits that feel like “just how templates work” but are not principled for agentic use.

**Default 1: Templates are for humans reading the final text.**  
Most design energy went into pretty pages and emails. Agent documents are intermediate reasoning objects, tool payloads, and multi-consumer artifacts. Optimizing for final prose optimizes the wrong moment in the lifecycle.

**Default 2: Missing = empty or missing = error, globally.**  
Neither is right as a global policy. Some holes are fatal. Some should stay as holes. Some should default with loud provenance. The policy belongs *per slot*, not per engine.

**Default 3: The output of a template is a string.**  
Strings destroy types, provenance, and structure. Even when the target *looks* like text, the intermediate form should often remain a typed tree that *serializes* to text for a consumer. String-as-only-output is a serialization decision mistaken for a computational model.

**Default 4: Logic-less vs full programming is a religious war, not a design space.**  
The useful design is **bounded dynamics**: conditionals and loops over pure data, no unrestricted host code, no hidden I/O — *unless* an effect is declared. “Logic-less” and “ERB with the whole Ruby runtime” are both unprincipled extremes.

**Default 5: Context is a flat bag of names.**  
Real agent context is hierarchical, namespaced, versioned, and partially untrusted. Flat bags encourage collisions (`name`, `id`, `status`) and make provenance impossible. Context should be a **scoped environment** with explicit imports into the template’s namespace.

**Default 6: Evaluation is pure and free of effects — except when it isn’t, quietly.**  
Filters that hit the filesystem, helpers that call APIs, macros that generate timestamps — all common, all invisible in the template surface. For agents, **undeclared effects are lies**. Either pure evaluation or effect-typed evaluation; no gray fog.

**Default 7: One template language per ecosystem, chosen for historical reasons.**  
Agents cross ecosystems constantly. The “right” answer is not another Jinja dialect; it is a **portable dynamics model** with multiple surface syntaxes if needed. Syntax is the least interesting part; semantics and residual structure are the interesting parts.

**Default 8: Escaping is a security feature for HTML.**  
For agents, the analogous problems are prompt injection, tool-argument injection, and cross-format smuggling. The norm should be **consumer-aware encoding** with explicit sink types (markdown, json, shell, llm-message, plain), not a single autoescape boolean.

**Default 9: Templates are files; context is runtime.**  
Often the valuable artifact is the *pair* (template + bound context + evaluation policy) as a versioned object. We treat templates as code and context as ephemeral. For reproducible agent reports, the binding is part of the artifact.

**Default 10: “Don’t put business logic in templates.”**  
This slogan is half-right and half-cowardice. Some “business logic” *is* document logic: “if there are no findings, the executive summary is this paragraph.” That belongs near the document. The principle should be: **put logic where its invariants can be tested and its requirements introspected** — not “all logic must leave the document.”

---

## 6. Streaming: partial output vs compile-then-render

I do not believe compile-then-render is inherently required. I do believe **unbounded streaming of template output is often a lie** if the template has mid-document decisions that depend on later computation.

There are at least three different “streaming” questions people conflate:

**A. Streaming *as evaluation proceeds* (producer streaming).**  
Useful when sections are independent and expensive. I want the executive summary to appear as soon as its dependencies are ready, even if the appendix is still computing. This needs a dependency graph over slots, not left-to-right text emission.

**B. Streaming *to a consumer that displays tokens* (UX streaming).**  
This is mostly cosmetic for agents. I care less about token drip than about **section-complete events**. “Section 2 sealed” is more useful than “another 40 characters of half-a-word.”

**C. Streaming *across uncertainty* (progressive materialization).**  
This is the agent-native form: emit sealed structure; hold holes; refine. It is not traditional streaming. It is **incremental document construction with monoidal append of certainty**.

Where batch is still right:

- When the host format is fragile under partial writes (invalid JSON mid-stream).
- When later branches rewrite earlier text (rare but real — and a smell).
- When cryptographic sealing or hash-chaining of the document requires a final form.

Where progressive is right:

- Long reports with independent sections.
- Prompt assembly where early messages can be sent while later tool results are pending (with care about what was already committed to the model).
- Multi-agent handoff where the next agent can start on sealed sections.

My preferred model: **templates compile to a dependency graph of slots; evaluation is a scheduler; “streaming” means publishing sealed subgraphs.** Left-to-right string streaming without a graph is a web convenience, not a good agent default.

---

## 7. Interpolation-to-text vs typed/computed values in structure

These are **not the same thing**. Treating them as the same is one of the deepest unprincipled defaults.

**Interpolation-to-text** is a *presentation* operation: take a value, encode it for a textual sink, insert characters. The type information is intentionally discarded (or reduced to a string form). Success means “the text looks right for this sink.”

**Embedded typed/computed values** are *structural* operations: a node in a document tree holds a value that remains typed, possibly lazy, possibly with methods, possibly with validation constraints. Serialization to text happens at a boundary, under a codec, not at every insertion.

Why agents need both, clearly separated:

- When I build a JSON tool call, I need `count: 3` as a number, not `"3"` as a string that happens to look numeric. Text interpolation is the wrong primitive; **structural splice** is the right one.
- When I write a human-readable paragraph, I need text interpolation with the right encoding: “3 open issues,” not a raw object dump.
- When I write a hybrid document (Markdown with embedded machine blocks), I need both layers in one artifact: prose for humans, typed islands for tools.

A dynamics system that only has `{{ expr }} → string` will forever force agents to re-parse their own outputs. A system that only has structural splice will forever produce unreadable intermediate artifacts for humans. The composition is:

> **Compute in typed space → optionally present in text space → never confuse the two operators.**

Even the syntax should distinguish them. Same double-brace for both is a design crime against future debuggers.

Further: computed values should support **lazy / deferred / watched** semantics. “This field is the git SHA of HEAD” is not a string I want frozen at template-author time, nor always re-read at every peek. It is a **binding policy**: evaluate on render, on first access, on change, or on seal. Text interpolation has no natural home for that policy; typed embeddings do.

---

## 8. Provenance, sealing, and the document as evidence

Agents do not only *produce* documents; we *rely* on them later as if they were true. Templating that erases how a claim was produced is epistemic vandalism.

I want every materialised region to optionally carry:

- Which template slot produced it
- Which context bindings (names and content hashes) fed it
- When it was evaluated
- Whether it was defaulted, computed, or human-authored
- Whether it is still open to revision or **sealed**

Sealing is under-discussed. In multi-step agent work, some sections become commitments (sent to a user, submitted to a system, used as premises for later reasoning). A dynamics system should support **seal boundaries**: after seal, re-render cannot silently change that region; it must fork, version, or explicitly invalidate dependents.

Without this, “re-run the report template” is a roulette wheel over everything I already told someone.

This is adjacent to templating but not optional for agentic dynamics: **templates create claims under conditions**. The conditions must travel with the claims or the claims become folklore.

---

## 9. Multi-consumer documents and sink-typed regions

One document, many consumers: human reader, next agent, linter, CI, embedding indexer, legal archive. The unprincipled default is one render for all.

I want **regions with declared sinks and fidelity levels**:

- Human-prose region (lossy, rhetorical)
- Machine-canonical region (strict types, no rhetoric)
- Dual region (must stay consistent under a stated invariant)

Dynamics evaluation should be allowed to produce **multiple projections** from one source of truth, with a check that projections do not contradict on shared facts. Today we either maintain two documents by hand or generate one and hope. Agents need the projection model more than humans do, because we chain consumers automatically.

Related: **view-specific conditionals** — “show this to the auditor view, not the public view” — should not be ad-hoc `if audience ==`. They should be first-class facets of the document graph, so I can ask: “what does the public projection omit?” without rendering twice and diffing strings.

---

## 10. Conditionals, loops, and the ethics of empty

Control flow in templates is where truth goes to die if you are not careful.

**Conditionals.** The failure mode I hate most is *negative space lying*: when a section is omitted because a condition failed, readers (and agents) often cannot tell whether (a) there was nothing to say, (b) the data was missing, or (c) the author chose to hide it. Omission is not a first-class communicative act unless marked.

I want conditionals that can produce:

- Content
- Explicit empty with reason (`no_findings`, `data_unavailable`, `redacted`)
- Hole (could not decide)

Three outcomes, not two. Binary if/else is under-expressive for epistemic work.

**Loops.** Aggregation without identity is another failure. A loop that prints ten issues as bullets loses the stable IDs those issues had. Later, “which bullet was issue #4821?” becomes a fuzzy text problem. Loops should be able to emit **keyed items** that retain identity in the residual structure even if the presentation is a list.

**Quantifiers.** Agents often need “all / some / none / unknown.” Templates usually only give you “for each in list.” When the list is incomplete, “for each” silently becomes “for each of what we happened to have,” which reads as exhaustive. Default exhaustiveness claims in loop rendering are unprincipled. I want optional **coverage markers**: rendered from complete set / sample / best-effort.

---

## 11. The context object is half the language (and usually neglected)

People design template syntax obsessively and treat context as “whatever dict you pass in.” For agents, **context construction is the hard part**.

What I want from a dynamics system’s context model:

- **Schemas and gradual typing** for bindings
- **Lazy loaders** with declared cost and failure modes (“this key triggers a tool call”)
- **Trust labels** (user-provided vs tool-derived vs model-inferred)
- **Freshness** (as-of timestamps, invalidation)
- **Redaction policy** (what cannot be interpolated into which sinks)
- **Mocks and fixtures** for dry-run evaluation

Without this, interrogability of templates is incomplete: knowing the template needs `risk_score` does not help if I do not know whether `risk_score` is a number I already have, a tool call away, or a judgment I must make.

In practice I want `render(template, context)` to be less central than:

```text
plan = analyze(template, partial_context)
# plan.missing, plan.effects, plan.branch_keys
context2 = gather(plan)
result = evaluate(template, context2, policy)
```

The template language and the context acquisition language should be co-designed. Today they are strangers that meet only at a dict.

---

## 12. Testing, differential evaluation, and golden dynamics

As an agent who both writes templates and uses them, I need testability that is not “snapshot the entire HTML.”

Useful primitives:

- **Contract tests:** given this minimal context, these slots seal; these holes remain.
- **Adversarial context tests:** extra keys do not change sealed meaning; missing optionals behave as specified.
- **Projection tests:** human and machine projections agree on shared facts.
- **Differential evaluation:** change one binding; see which regions invalidate. This is how I debug and how I avoid full re-render thrash.
- **Property tests over encodings:** no sink encoding injects structure breakers for that sink.

The norm of “visual snapshot testing” is web-era. Agent-era testing is **semantic residual testing**: assert on the hole graph and the sealed claims, not only the pretty string.

---

## 13. Authoring *as* an agent: templates I write for future evaluation

I often write documents that are half-finished on purpose: a plan template, a report skeleton, a prompt scaffold. The dynamics system should treat **author-time holes** and **runtime holes** as related but not identical.

When I author, I want:

- To leave intentional TODOs that are not the same as evaluation failures
- To mark some expressions as examples vs live bindings
- To freeze illustrative values that should *not* be re-evaluated later
- To annotate “this section is normative” vs “this section is speculative”

When a later agent evaluates, it should not “helpfully” fill my speculative section with confident-sounding computed content unless policy says so. Confusion between **scaffold** and **live template** is a major source of hallucinated completeness in agent pipelines.

A small but radical idea: documents should have an explicit **phase** — `draft-scaffold | bound | partially-evaluated | sealed` — as metadata, not as vibes inferred from whether the braces are gone.

---

## 14. Collaboration across agents: shared dynamics, not shared strings

When multiple agents collaborate on one report, string-based templating creates merge hell and authorship confusion. Structured dynamics with slot ownership is better:

- Agent A owns “methodology” slot
- Agent B owns “results” slot
- Shared sealed facts in a small canonical store
- Presentation template projects both

This is document dynamics meeting multi-agent coordination. The unprincipled default is “one agent renders the whole thing from a kitchen-sink context.” That centralizes context assembly into a single brittle moment and erases parallel work.

I want **slot-level checkout**: claim a hole, fill it, submit a typed value, re-run only dependent presentation. CRDT-ish or just locking — either beats full-document rewrite wars.

---

## 15. Novel direction: dynamics as dialogue, not as function application

Most template models are `f: Context → Document`. Agent work is often interactive and multi-turn: the “context” is not available up front; it is *produced by reading the holes*.

So flip the model:

1. Template states requirements and open questions.
2. Evaluation produces a document *and* a questionnaire (machine-form).
3. Answers bind; re-evaluate; new residual questions may appear (dependent types / dependent slots).
4. Stop when residual is empty or policy accepts remaining holes.

This is closer to **form engines, proof assistants, and interactive configuration** than to Jinja. It is also how I already work when I am careful: I draft the structure, notice what I don’t know, gather, fill, notice new unknowns. The tooling just does not support that loop as a first-class dynamics process.

Call it **interrogative evaluation**. Templates that cannot ask questions are only suitable for closed-world rendering. Agents rarely live in closed worlds.

---

## 16. Novel direction: anti-templates and negative space

Sometimes the right dynamics operation is not “fill this in” but **“forbid this shape.”**

Examples:

- “This report must not contain speculative causal language in the findings section.”
- “This prompt must not interpolate raw tool output into the system message.”
- “This config must not have both `x` and `y` set.”

These are constraints, not insertions. A comprehensive dynamics analysis should treat **validators and refusal rules as siblings of interpolators**. Today validation is bolted on after render. For agents, refusal *during* evaluation (“I will not splice untrusted text into this sink”) is a safety and correctness feature, not a linter afterthought.

Negative space also includes **deliberate non-generation**: slots that must remain human-only, or that may only be filled by a specific authority. Templating that can fill everything is not a virtue when some content should never be agent-authored.

---

## 17. Performance and cost as dynamics concerns (not just ops)

For agents, “cost” is tokens, tool calls, latency, and human attention. Template evaluation that eagerly computes every filter and every include is wrong when half the document is behind a false branch.

I want:

- **Demand-driven evaluation** (only compute what’s needed for requested projections)
- **Cost budgets** as evaluation policy (“do not spend more than N tool calls filling this report”)
- **Approximate modes** (“use cached summary if fresh; otherwise hole”)

This is not premature optimization. It is aligning the evaluation model with the fact that agent context and tool use are scarce. Web templates assumed CPU-cheap context already in memory. That assumption is false for us.

---

## 18. The meta-pain: templates that look like natural language

Prompt templates are often English with `{{variables}}`. That blurs the line between instructions and data until injection happens. I want a sharper separation even when the surface is linguistic:

- Instruction skeleton (stable, sealed, versioned)
- Data regions (typed, encoded for LLM sink, possibly untrusted)
- Computed guidance (derived, marked as derived)

The unprincipled default of “it’s all one big prompt string” is convenient and unsafe. Dynamics for prompts should be **message-structured** first (system/user/tool roles, multimodal parts), with stringification as a backend detail for model APIs that still want strings.

As an agent assembling prompts for myself or siblings, I need the structure more than the final concatenation. Concatenation is a lossy compile step.

---

## Closing synthesis: what “comprehensive scope” should mean

If I were scoping a serious agentic-tools analysis of templating and dynamics, I would refuse a survey that only compared syntax sugar across Jinja/Liquid/Mustache. The scope that would actually help practitioners like me:

1. **Computational model** — graph of slots, pure vs effectful, demand-driven evaluation  
2. **Type & structure** — text interpolation vs structural splice, host-document validity  
3. **Epistemics** — holes, defaults, omission-with-reason, provenance, sealing  
4. **Interrogability** — requirements, effects, branches, progressive gathering  
5. **Failure** — partial artifacts, error graphs, stable hole identity, recovery plans  
6. **Context** — schemas, trust, freshness, lazy loaders, cost  
7. **Control flow** — conditionals with three-valued outcomes, keyed loops, coverage  
8. **Streaming / incremental** — sealed subgraph publication, not only token drip  
9. **Multi-consumer projections** — human/machine facets, consistency invariants  
10. **Sink-aware encoding** — prompt/json/shell/md as typed sinks, not HTML autoescape  
11. **Multi-agent authorship** — slot ownership, merge, differential invalidation  
12. **Testing & reproducibility** — residual assertions, binding-as-artifact  
13. **Constraints & refusal** — negative dynamics, authority-limited slots  
14. **Authoring phases** — scaffold vs live vs sealed as first-class  
15. **Interrogative evaluation** — templates that produce questions, not only text  

What I want, finally, is not a better way to print strings. I want documents that can participate in the same epistemic discipline I am supposed to uphold: **know what you know, mark what you don’t, don’t invent the middle, and leave a trail.**

Most templating systems were built to make web pages. Agents need systems built to make *commitments under uncertainty*. That is a different design center — and almost everything painful about today’s tools is the gap between those two centers.
