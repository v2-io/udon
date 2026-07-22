---
source: Joseph morning sampling of demand counterexamples to linear pipeline
gathered: 2026-07-21
status: gathered excerpt from deliberation record
paths:
  - v2/udon-needs/pipeline-discussion.md:525-542
categories:
  - templates
  - dialects
  - schema-guarded-edit
  - round-trips
  - ML-dissolve
  - DAG-DCG
why_included: |
  Highest-texture Joseph demand brainstorm: template precompile, in-vivo dialects, schema-guarded edit, array-as-sugar dissolving ML. needs-map S* rows seed from this but lose detail.
---

> **Why gathered:** Highest-texture Joseph demand brainstorm: template precompile, in-vivo dialects, schema-guarded edit, array-as-sugar dissolving ML. needs-map S* rows seed from this but lose detail.

<!-- excerpt v2/udon-needs/pipeline-discussion.md:525-542 -->
## Joseph

Hmmmm. I just looked through PIPELINE.md ... I appreciate everything that the grok agent worked really hard on, but it was so much in process-design work with some of these files that, yeah, even pipeline pays homage to demand-side but then comes up (or institutes) the pipeline ideas that I felt were premature without the sufficient demand-side understanding. I'm simply not convinced that the recognition/assembly/resolution/evaluation is the right ontology, although it's a fine starting hypothesis-- but a hypothesis that should quickly bend and completely reform based on what we really need to do with:
- markdown processing (including the several different user-side situations that implies)
- round-trip fixedpoint like you pointed out, but also other target round-trips like json, toml, markdown, yaml, rust-native, ...
- fully implemented timespec dialect -- we even already have the descent grammar... which also seems to imply that type delimiters '&lt;' could actually invoke a specialized low-level parser in vivo potentially... same with other standard automatically included dialects
- which begs the question-- what *is* the picture for defining, possibly compiling or validating/verifying, declaring, and utilizing a dialect?
- the liquid dialect is one that should basically allow a `template = precompile('my.template.udon')` and then query it for what kind of scope-context object it wants. It wants one with the following objects/variables and the following predicates / boolean functions, etc.  And then `build-from(template, my-scope-context-1) -> output-*` where output-* is what the discussion needs... a flattened non-liquid udon document? or if 'template' there is already precompiled ast + things for modifying based on the eventstream-- maybe straight to ADR? Do we allow some sort of event-streaming at all for liquid-template udon files?  These were more easy to contemplate in Ruby early in the year-- simply output the document you want with some actual liquid template directives build in and run liquid on it or, to be more performant and less dependent-- essentially output an erb fully ready to be executed. Not sure what happens now with the pipeline when we are rust-centric. But it seems like this sort of thing should be understood-- from the demand-side decisions we need to make, starting with "I'm an agent-- when would templates come in handy? What would I expect out of template xyz?" -- now that I ask it outloud, even though I'm not a logogenic agent, I think "hmmm, honestly I would probably want the scope-context to be udon itself most of the time, so a lot of the liquid-like directive end up having path-like syntaxes..."  ahhh.. now a little progress.... is this anything like what the dialect spike looked at? To the topic again though, that means there would be quite the overlap between !{{interpolation}} and &lt;interpolation> ... maybe the difference is the first is guaranteed to be text-type when done - but it's all still dialect ruled...
- what is ordering for dialects? or do we just allow for mostly &lt;namespaced/type: val> (inferred if no ambiguity) dialects, and dialects that are the equivalend of custom liquid transformers / filters etc. but that don't change the underlying template logic. dialects are allowed to define what? override interpolation? define how to interpret inline |{elements} ?  yes but only one can be specified -- default applies unless one and only one overrides??
- what's the end user expectation on the various parsers for badly typed values? (parsing errors on the type values) -- if we have an open continuous stream we're parsing that is effectively unbounded and so the user is using the events and not accumulating -- even if it's the chunky ADR parser which does *some* accumulation to disambiguate certain things but in a bounded way that passes them on as soon as it can for continuous streams, won't it expect types etc. to be already processed?
- can all of the above be changed mid-stream? Now this dialect rules... now this other one does...
- can schemas be nested or otherwise composable?
- what are the kinds of schema and linting conformance tools needed -- I know for example a critical tool IMO for agents is a specialized edit tool that makes edits very easy without needing to worry about indent-levels for prose or raw code blocks, while simultaneously guaranteeing that no mutation that would cause the document to now violate the schema is accepted. The tool itself will need the machinery to do jq/yq like span-sensitive changes to the AST and have it checked against a static schema
- or is the schema static? etc.
- if dialect typing &lt; goes to another part of the grammar, that other part of the grammar can be in charge of any nested &lt;, or whether it accepts multiline or not... However we're currently branching out typing handling (array vs what used to be called bare-value (single text word) vs numeric etc.) would ideally end up mirroring very well the dialect typing mechanism-- and it all changes what the pipeline would look like!
- if array capture was just a syntactical sugar for &lt;core/ws-delimited-array: .... > for example, or for geometric/block delimited array, then *that* answers the 'multiline or singleline?" question-- not us arguing in the dark and finally accepting something *that is an incorrectly framed question in the first place guaranteed to be irrelevant the moment we have dialects and schemas worked out* (I didn't tell the greenfield authors about this-- preferring to let them imagine whatever codification they wanted from the current disorganized spec. It was interesting, but it can't now suddenly become "*the* design question of the moment,"  it was left as undefined but loosely speaking allowed (multilines in those constructs) *because* it was a demand-side question that would significantly affect the pipeline needs.

I could go on and on and on-- but I'm sure you see the point. Don't get caught up in the *details* of those things on the list-- that's *not* necessarily my "hot-list" of critical decisions-- it's literally a random-sampling to give you the flavor of some of the ways the demand-side could completely change our input/output needs (that might be a useful map...) and demand-side setups that would significantly inform the correct pipeline architecture (or rather a kind of DAG really, or even DCG..., with partial results being tranferable possibly and resumed etc.)

