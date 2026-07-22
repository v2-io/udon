# Pipeline discussion — stages, "fold," verdicts, ornamental

*(status: ongoing, 7/20)*

## Joseph

❯ In c6 you discuss the fold. What *specifically* does this entail?

---

## Fable

"The fold" is a specific, small program — worth pinning down exactly, because it's the executable form of the W0 law. Concretely:

Definition. A fold is a single pass over the event stream with an accumulator and nothing else: fold(events) → (tree, anomalies). It consumes events one at a time, in order, and its only memory is the structure it's building (in practice: a stack of open nodes). Its inputs are forbidden from including the source bytes, spans, or any re-derived layout logic — if the fold ever needs to peek at the original document or re-run indentation analysis to decide where something belongs, the wire has failed the law at that point.

The instance that already exists (post-text-recast, in the harness today): the text fold —

Text/RawContent → append content as-is BlankLine       → append "\n" everything else → no text contribution

That's the whole thing, and it's the contract sentence from TODO-TEXT-WIRE made runnable. The deleted compensator was precisely a fold that cheated — it consulted source gaps between spans to reinsert the newlines the wire dropped.

The generalized fold (what C5's option A asserts, once W1's bracket exists) is the structural extension — a stack machine:

ElementStart      → push new element onto stack Name / Attr key   → set on stack top / open an assignment value events      → attach to the open assignment AttrValueEnd      → close the assignment          ← W1 makes this possible Text/BlankLine    → append to stack top's content (text rules above) Warning/Error     → append to anomaly list ElementEnd        → pop; attach to new stack top

Run that, and out comes a recovered document: structure, ownership, values, text, anomalies. A C5-A fixture then asserts against that — "after folding, el has attribute v1 = "hey" and content ["more text\n", child]" — instead of asserting the raw event spelling. The fold is one small shared function, so the entire class of harness compensators has exactly one place it could hide, and that place is ~30 lines and audited once.

Now C6 specifically: the incomplete-input result is the one thing the fold provably cannot recover, even under the law — because the interior-newline twin and the at-EOF twin are wire-identical by design (same events, same warnings). The result isn't an event; it's a second channel of the parse output (parse(bytes) → (events, result)), which is exactly how the ruled two-level severity model defines it ("a result, not a wire event")arry it as its own field — result: incomplete — because there is no eventlist that could ever express it. That's the entire content of C6: give the result its own assertion surface, since the fold's surface structurally can't cover it.

Let me pin that into the supplement so grok verifies the same definition: *[written to [[RULING-SUPPLEMENT]] ]*

---

## Joseph

❯ In c6 you discuss the fold. What *specifically* does this entail?

---

## Fable

"The fold" is a specific, small program — worth pinning down exactly, because it's the executable form of the W0 law. Concretely:

Definition. A fold is a single pass over the event stream with an accumulator and nothing else: fold(events) → (tree, anomalies). It consumes events one at a time, in order, and its only memory is the structure it's building (in practice: a stack of open nodes). Its inputs are forbidden from including the source bytes, spans, or any re-derived layout logic — if the fold ever needs to peek at the original document or re-run indentation analysis to decide where something belongs, the wire has failed the law at that point.

The instance that already exists (post-text-recast, in the harness today): the text fold —

Text/RawContent → append content as-is BlankLine       → append "\n"Is this an accurate model of what we're talking about?:

```
  pushdown-parser(udon chunks -> Raw event stream -> assembled event stream)  -> stepwise (streaming) AST
  RD-parser(udon doc -> Raw event stream -> assembled event stream)           -> oneshot AST
```

  with any of (pushdown, RD, streaming AST, oneshot AST) parsers or parser-modes available to the end-user as libraries? (where assembled event stream is what you are calling folded?) Close — two corrections, one of which is exactly the kind of confusion the vocabulary work should prevent:

1. There is no "raw vs. assembled" event stream — there's one event stream. Both backends emit the same wire, and that identity is a proven property (pushdown_differential runs every fixture × every chunk size against the one-shot RD parser and asserts identical events, spans included). So the model is:

pushdown parser:  udon chunks   →  event stream   (resumable at any byte boundary) RD parser:        whole udon doc →  event stream   (same stream, proven identical)

One wire, two engines. The stream is the WIRE contract's subject; nothing between the parser and the stream.

2. The fold is not a stream — it's the step after the stream. Fold = the event-stream → tree reduction. So in your model, "assembled" corresponds not to a second event stream but to the output of the fold:

                       ┌→ streaming AST builder (fold that ships each root
event stream ──────────┤   subtree the moment it closes) ├→ one-shot AST builder (fold that returns one Document) └→ any custom consumer (your own fold: an indexer, a highlighter, a converter — never re-reads source)

The two AST builders in tree.rs / stream_tree.rs are folds — just full-featured ones. The harness's "reference fold" is the same reduction at its most minimal (~30 lines), kept tiny so it can be audited as the executable form of the W0 law. Same species, different sizes.

So the corrected picture:

bytes → [pushdown | RD] → event stream (+ result channel) → [streaming fold | one-shot fold | custom fold] → ADM/tree

with the pairings free, not fixed: streaming AST usually rides pushdown because chunked input needs a resumable engine, but a streaming fold works over RD's events too (RD emits as it parses — you just need the whole document available to feed it). One-shot AST over pushdown is likewise fine. Input-feeding mode and output-shape mode are independent axes.

And yes to your last question: all of it is end-user library surface — engine choice (pushdown/RD), builder choice (streaming/one-shot), or bring-your-own fold against the documented wire. That last one is why W0 matters commercially, so to speak: the sufficiency law is what makes "write your own consumer against the event stream" a safe public API instead of a trap that silently requires reimplementing the indent logic. Plus the small print: the parse output is two channels — the stream and the incomplete-input result — so a library consumer gets (events, result), not events alone.

If it'd help the sitting, I can drop this corrected diagram into the supplement as a one-liner under W0 — it's a better orientation figure than anything currently there. (And your question itself is evidence for the glossary row that retires "wire/event stream/flat wire" synonyms — "assembled" almost became a fourth.) 

---

## Joseph
*[Objection and brainstorm (verbatim), clearly frustrated at the presumptuous and patronizing "I can drop this 'corrected diagram'..." 7/20]*

❯ Sorry, you can draw it all you want but it won't convince me that it's right yet. I'm trying to determine if there's a better or more accurate or descriptive term for "fold" and "result channel" vs ADR vs AST.  The things that aren't determinable at construct arrival on the wire include (off the top of my head, not comprehensive) the list below. This is a consequence of us not having a pre-existing tokenizer -> lexer -> parser divisions due to the extra friction those would add to this language in particular, which means we have significant flexibility in (and have to be very thoughtful about) the assembly line. So, what needs some level of accumulation of raw events before it can be determined. In the 0.8 and 0.9 lines we were overwhelmed enough trying to nail down the event-stream that we often conflated the stages, but the spec *did* start to gather things that were "the parser/host decides" etc. which was essentially shorthand for "some stage after the raw event stream" except we had to do at least a naive text flattening to even get that right. Some of the things that require various degrees of assembly first but that also still stepwise / chunky-streamable to one degree or another, not in any order:

  - ornamental blank line detection (blank lines that are determined to be 'geometric' for making the udon doc legible instead of being part of a text block, even sometimes when adjacent to text blocks [or whatever we will call those])
  - full text-block grouping (the only one you defined "fold" as an incomplete example)
  - attribute correspondance rules (e.g., value stacking)
  - key integrity checks on definitions
  - key integrity checks on references
  - mixins
  - value typing & parsing (default included dialects)
  - value typing & parsing (chosen dialects)
  - schema compliance
  - dialect loading (possibly)
  - liquid dialect *checking* (early)
  - liquid dialect *processing* (later but still stepwise capable, or outputs a runable template against any context object)
  - temporal dialect processing
  - rust dialect processing (will probably affect types available and runnable liquid areas)
  - potentially, unmet expectations (many beyond closed delimiters, such as template if-clause closings, etc.)
  - ...

  Due to the friction that had accumulated in the undisciplined / disorganized original spec, natural drift, and accumulated drift in the grammar, mixed with the disorganized chain of processing (which is not an indictment-- that tactical intuition allows us to be more organized now), we had to limit ourselves to just trying to get a stable event-stream with simple text fold. But we now can look at everything holistically and figure out what is "right" in a way that is more holistic than just fixing what we were struggling with tactically before now.
 
 (NOTE: I have only started going through the results from you and the other t parts of the rulings table-- so it's almost certain there are more refinedideas that aren't represented yet above. If it isn't yet, I think we should consider defining "ornamental" as 'choices about things that change how the udon looks without changing the AST (or some late consumable form before that), except they mayn namespace for exact verbatim round-trip. But it can be proven to beornamental if a round-trip is made that strips them before going back to udon, and then a second round trip results in the same original AST + exactly the same udon as the result of the first round-trip, i.e.:

```
    original.udon  -> (drop ornamental)       original.ast -> house-style.udon
  house-style.udon -> (drop house ornamental) original.ast -> house-style.udon
```

)

---

## Fable

You caught a real conflation, and I'll concede the specific point first: when you said "assembled event stream" I told you there was no such layer — that was wrong at the layer you meant. What's true is that there's one event vocabulary (no raw-vs-cooked wire); what your list demonstrates is that above the wire there isn't one fold, there's an assembly line of accumulation stages with different scopes — and my "~30-line fold" answer flattened them into one step because the harness only ever needed the first one. The 0.8/0.9 "the parser/host decides" shorthand was pointing at real, distinct stations that never got named. So let me try to name them by what actually distinguishes each: how much accumulation it needs before its determination is possible.

Stage 1 — Recognition (bytes → events). Scope: bounded lookahead. Nothing on your list lives here; that's the point of the list.

Stage 2 — Assembly (events → construct-complete model instances). Scope: one construct's extent — determinations that resolve at a close. This is where your first cluster lands: full text-block grouping (needs the run's end), ornamental blank detection at run edges (needs the next structural event to know a blank was trailing), attribute stacking (needs the element's attribute phase to close), W1's value extent, and close-time unmet expectations (unclosed delimiters, a flag with no legal value). Streamable at subtree granularity — chunky, as you say.

Stage 3 — Resolution (model → resolved model). Scope: document-wide, or streaming-with-obligations. Key integrity on definitions (duplicate index grows monotonically — streamable), key integrity on references (forward refs → either end-of-document or promise-style deferred obligations), mixins (a trait-only anonymous element may appear after its users), dialect loading/pragma, value typing against loaded dialects, schema compliance, and the sequence-shaped expectations like !if/!else chain integrity (needs sibling accumulation — construct-adjacent but not construct-local, which is why it kept feeling homeless).

Stage 4 — Evaluation/Projection (resolved model → host artifacts). Scope: beyond the document — a context object, a runtime, native types. Liquid processing, temporal projection to native datetimes, the rust dialect's effects on available types.

Your liquid early-check vs. late-process split is the general pattern, not a special case: every dialect potentially has a check half (stage 2/3 — construct- or document-local, no context needed) and an evaluate half (stage 4). Temporal: pattern validation at 3, projection at 4. That two-phase shape probably belongs in the dialect architecture as a stated norm.

Terminology proposals, then:

- Retire "fold" as the general term — you're right that it only correctly names stage 2's audit instance (the harness's minimal reconstruction). If it survives at all, it's as "the reference fold," a test artifact, not an architecture noun.
- Recognition / Assembly / Resolution / Evaluation for the stages. Each stage has the same signature: product in → product out + anomalies (+ optionally a verdict). Which gives "result channel" its better name: a verdict — and generalizes it, because stage 3 has verdicts too (schema compliance is a verdict, not an anomaly), and incomplete-input is just recognition's verdict.
- And the W0 law generalizes into the thing that actually disciplines the whole line: sufficiency at every stage boundary — each stage's output must suffice for the next with no reachback to an earlier product. The harness compensator was a reachback from stage 2 to stage 0 (source bytes). Your list is, in effect, the specification of what each boundary must carry. ADM then stops being one monolith: it's the product contract at the assembly/resolution boundary, and the resolved model is a second, richer contract — same shape, more determined.

On your ornamental definition: I think it's right, and it's stronger than what S6 ruled — S6 enumerated instances (edge blanks); yours is a criterion, and a testable one. It's the formatter-idempotence fixpoint: strip-ornamental → model → emit house-style must be (a) model-invariant and (b) idempotent — the second pass reproduces both the model and the bytes. Three sharpenings worth carrying with it:

1. It quietly defines ornamental as the discretionary part of geometry — indent width beyond minimum, alignment padding, edge blanks — as distinct from mandatory geometry (the marker, the minimum column step), whose removal does change the model. That's a cleaner cut than "blank lines" ever was.
2. Your "preserved in their own namespace" clause is exactly grok's SEMANTICS equivalence ladder arriving from the byte side: round-trip with trivia = his recognition-identity serializer; round-trip without = his data serializer with your fixpoint as its success criterion. The two frameworks meet in the middle and should be unified in the v2 SEMANTICS doc — ornamental is the byte-level name for the quotient between byte-identity and recognition-identity.
3. One boundary to state explicitly: comments are not ornamental under this definition (dropping them changes the model, since they're nodes), even though they feel decorative — which is a feature of the definition, not a bug; it's what keeps documentation-extraction tooling honest.

Where this lands practically: the ruling table's C5/W0 rows are unaffected in substance but their language should be restated in stage terms (C5 asserts the assembly product, not "the fold's output"), and the ornamental criterion probably deserves its own row — it's rulable now, it's better than the instance-list, and it retroactively grounds S6/S9/S18. Want me to hold all of this until you've finished your first pass through the table, or restate the supplement's affected entries in stage vocabulary now? I lean toward waiting — you're mid-read, and swapping vocabulary under you mid-sitting is exactly the confusion you said you're trying to avoid.

---

## Grok
Agreed with both of you on the substance, with a few sharpenings.

### On "fold"

Fable's first answer was right for **what C5 was trying to buy** (one audited reduction that forbids source reachback) and wrong as an **architecture noun**. Joseph's list is the proof: stacking, ornamental edges, key integrity, dialects, schema, liquid check vs process — those are not one stack machine of depth ~30 lines. Collapsing them into "the fold" re-creates the 0.8/0.9 habit of saying "the host decides" whenever accumulation was needed.

I'd retire **fold** as a general term almost completely:

| Keep | As |
|------|-----|
| **reference reconstruction** (or "harness assembly") | The tiny, pure, audited events→model step used to assert W0/C5 — a *test artifact* that implements sufficiency at the recognition→assembly boundary |
| **fold** in the FP sense | Allowed casually ("we fold events into a tree") but not in SPEC/WIRE as a formal stage name |

Calling the whole pipeline "the fold" is what made "assembled event stream" almost appear as a fourth wire synonym. One wire vocabulary; many post-stream stages.

### On the pipeline model (Joseph's diagram, corrected)

Fable's correction is right:

```text
bytes
  → recognition engines [pushdown | RD]     # same WIRE events (+ verdict channel)
  → event stream
  → assembly / resolution / evaluation …    # stages, not a second event stream
  → products (document model, resolved model, host values, …)
```

Pairing of **input engine** and **downstream mode** is free. "Streaming AST" is a *mode of assembly* (emit completed subtrees early), not a third wire.

I'd also name the dual channels at the recognition boundary explicitly:

```text
parse(bytes) → (event stream, recognition-verdict)
```

where incomplete-input is a **recognition-verdict**, not an event — Fable's C6 point stands. Generalizing "result channel" → **verdict** is good: schema compliance, dialect-check failure, and incomplete-input are all verdicts at different stages; anomalies are the *per-construct* journal that can feed a verdict without being one.

### On stages (Recognition / Assembly / Resolution / Evaluation)

The four stages are the right grain. Two refinements:

**1. Assembly is not only "at construct close."**  
Joseph's ornamental blanks and some stacking/phase cases need *the next structural event* (or end of attribute phase), which is still local but not always the same as "delimiter matched." Call assembly's scope **extent-local or phase-local**, not only close-time. That keeps `!if`/`!else` sibling chains from feeling homeless: they are **adjacent-construct assembly** (still not document-wide resolution).

**2. ADM is a boundary product, not the whole universe.**  
Fable: ADM sits at assembly→resolution. Yes.

| Product | Boundary | Contains |
|---------|----------|----------|
| **Event stream** | after recognition | self-delimiting structure + text bytes + anomaly events |
| **Document model (ADM)** | after assembly | tree, stacked assignments closed, text runs grouped, ornamental disposition applied *or* trivia retained for round-trip |
| **Resolved model** | after resolution | keys checked, refs/mixins/dialects/schema applied as policy |
| **Host artifacts** | after evaluation | native types, rendered templates, … |

SEMANTICS' equivalence ladder maps cleanly:

| SEMANTICS layer | Pipeline |
|-----------------|----------|
| byte identity | pre-recognition |
| recognition identity | same events + same recognition-verdict (+ optional trivia) |
| core semantic equivalence | same ADM after assembly normalization (stacking≠list preserved; ornamental may drop) |
| host projection equality | after evaluation |

So ornamental is not a fourth random concept — it's the **quotient between byte/recognition identity and core semantic identity**, which is exactly what Joseph's double round-trip fixpoint tests.

### On ornamental (Joseph's definition)

Stronger than S6's instance list; keep the criterion + the test:

```text
strip ornamental → model → emit house-style
  must be model-invariant and idempotent on (model, house-style bytes)
```

Agree with Fable's three sharpenings, especially **comments are not ornamental** (they're model nodes). I'd add one:

**4. Mandatory geometry vs discretionary geometry** must be stated in WIRE/SPEC so formatters know what they may restyle. Column *relationships* (child/sibling/dedent) are mandatory; *how many* spaces beyond the minimum step are ornamental (unless you choose a house style that freezes them for recognition-identity round-trip).

S6/S9/S18 become instances of this criterion, not a closed taxonomy — good OPEN/DECISIONS material after the sitting, not blockers for it.

### On Joseph's accumulation list — stage assignment (draft)

Not comprehensive; a stake in the ground for later SPEC/WIRE work:

| Determination                                             | Earliest stage                                | Notes                                                                        |
| --------------------------------------------------------- | --------------------------------------------- | ---------------------------------------------------------------------------- |
| Marker/guard, bare-token boundary, value self-extent (W1) | Recognition                                   | Must be on the wire                                                          |
| Unclosed delimited → anomaly + End order (R12)            | Recognition                                   | Wire-visible                                                                 |
| Incomplete-input                                          | Recognition **verdict**                       | Not an event (C6)                                                            |
| Text run grouping, BlankLine vs Text                      | Assembly                                      | Text reconstruction is the subcase                                           |
| Ornamental edge blanks                                    | Assembly (needs next structural event)        | Criterion above                                                              |
| Attribute stacking closed                                 | Assembly (phase end)                          | Multiplicity already on wire as repeated assignments once W1 brackets values |
| Flag re-own / phase gate consequences                     | Recognition + assembly                        | Decision at scan; attachment at assembly                                     |
| Dup-definition index                                      | Resolution (streamable mono)                  | Menu R14                                                                     |
| Reference integrity (forward)                             | Resolution                                    | Deferred obligations OK                                                      |
| Mixins                                                    | Resolution                                    | Host experiment may stay optional                                            |
| Dialect *check* (pattern ok?)                             | Assembly or Resolution                        | No host context                                                              |
| Dialect *evaluate* / temporal native / liquid run         | Evaluation                                    | Needs context object                                                         |
| Schema compliance                                         | Resolution **verdict**                        | Not an anomaly journal entry alone                                           |
| Liquid if/else chain shape                                | Assembly-adjacent (sibling run) or Resolution | Homeless until stages named — now Stage 2.5 / 3                              |

**Dialect two-phase (check vs evaluate)** should be a dialect-architecture norm, not liquid-special.

### On W0 / C5 language (without swapping the table mid-sitting)

Substance of the table rows stands. When restated after Joseph finishes the first pass:

- **W0** → sufficiency **at every stage boundary** (no reachback), with recognition→assembly as the first and hardest instance (value brackets, text bytes).
- **C5** → fixtures assert **assembly product** (ADM slice + anomalies) and optionally raw events; not "the fold's output" as the only noun.
- **C6** → recognition-verdict field; incomplete-input is the exemplar, not the only future verdict.

I agree with Fable: **don't rewrite the ruling table vocabulary under Joseph mid-read.** Capture stage vocabulary here and in a post-sitting SEMANTICS/WIRE pass.

### Verdict vocabulary (optional alternate to "verdict")

If "verdict" feels courtroom-heavy:

| Candidate        | Pros                 | Cons                                              |
| ---------------- | -------------------- | ------------------------------------------------- |
| **verdict**      | Clear, stage-scoped  | Slightly formal                                   |
| **outcome**      | Soft                 | Vague                                             |
| **parse status** | Familiar             | Sounds recognition-only                           |
| **disposition**  | Fits ornamental talk | Overloaded with S6 "final-terminator disposition" |

I'd keep **verdict** for stage-level success/failure and **anomaly** for the journal. Don't use **result channel** in normative text — it was a good interim name for C6 and has done its job.

### AST vs ADM

- **ADM** = language-level product contract (what assembly must be able to recover).
- **AST** = a concrete host/library encoding of an ADM (or resolved model).

Library surface can say "AST builder" for humans; SPEC should say ADM. Streaming vs one-shot is **assembly scheduling**, not a different meaning model.

### Bottom line

1. One **wire** (events), two **recognition engines**, free pairing with downstream modes.
2. Not one fold — a **stage pipeline** with **sufficiency between stages**.
3. **Ornamental** = testable quotient for formatters; comments excluded.
4. C5/W0/C6 stay; reword after the sitting.
5. The real win of this thread for v2 is naming stations that "parser/host decides" used to hide — so WIRE and SEMANTICS don't re-collapse them.

Happy to help draft a one-page **pipeline glossary** (stages, products, verdict vs anomaly, ornamental criterion) after rulings, as a sibling to the table rather than an edit to it mid-flight.


---

## Joseph

What we are missing that will give us confidence in a pipeline architecture and vocabulary is greater:

- **Utility** and user-directed needs ideation, rulings, and strategy;
- **Path** syntax & mechanism iteration and rulings in parallel, as a building block for the others and to inform the ADR/AST & pipeline;
- **Dialects** brainstorming/spikes/rulings, including distinctly:
	- **Selection** and inclusion mechanisms, user-side & pipeline-side
	- **Value Type** definitions and processing pipeline
	- **Directive** definition, inclusion & pipeline
	- (other) **Embed** definition, declaration, auto-inclusion, & pipeline
- **Schema** brainstorming/spikes/rulings

These to help establish the right overall pipeline architecture that will then allow for:

- **Specification** & **Events**
- **Utilities** (including syntax highlighting & fixed-point-checking & test-harness, etc., but mostly external-user-facing)
- **Extension-points**
- **ADR** & **Grammars** (plural)
- **Canonical Rust Parsers, Pipeline, & Extensions**
- **Pedagogy**

I want us to continue to be thinking in higher-level process and conceptual. While I have started going through and marking rulings, my overall goal especially with the two of you right now is to have the three of us establish the seeds and process that are a sufficient lattice and scaffold for the details to easily emerge as there is time and/or need to iterate on them. In particular (with the caveat that I've only read through the first C table in [[RULING-TABLE]]) getting *just* enough of the above to help establish:

- Reasonable separation of concerns for parallelism and focus
- **Workflow** & handoff/transition stability
- **Feature pipeline** & Publishing cadence
- **Canon & Documentation** rules and norms that facilitate the above


With that in mind, I'll invite Fable first and then Grok to add any concluding (probably) words for this conversation with thoughts on any of the above (or related in any way as you see fit).

*And then*, if you're willing, I'd ask for each of your recommendations on milestones, their ordering/priorities, and immediate tactical task implications based on everything so far. (With the understanding (on my part anyway) that it will be iterative and initially very leaky & provisional (a good and necessary thing at this stage).

---

## Fable
*['you' -> Joseph]*

(The editorial note earlier in this file is fair, and noted — the register slipped there, and the objection it prefaced was the most productive message in the thread.)

Concluding thoughts on the lattice, then the milestone recommendation you asked for.

### The demand-side inversion (your list is the important correction)

Your "what we are missing" list quietly inverts how grok and I were building the pipeline model, and the inversion is right. We were deriving the stages supply-side — from what recognition can and can't determine. But the boundary *contents* (what each stage's product must carry) can't be specified from the supply side at all: they're determined by what paths, dialects, schema, and the user-facing utilities *demand*. A path expression tells you whether Resolution's product needs spans, whether it addresses the ADM or the resolved model, whether ornamental trivia must be addressable. A schema tells you what the compliance verdict needs to reference. The dialect architecture tells you where the check/evaluate seam actually sits. So the honest status of my Part-3 stage model: the stage *names* and the no-reachback law can be seeded now; the boundary *contracts* should be left demand-shaped — filled in by exactly the spikes you listed, not by us reasoning harder about parsing.

That reframes the confidence question you opened with: confidence in the pipeline architecture won't come from more architecture discussion — it comes from four cheap demand probes bouncing off it and not bending it.

### Separation of concerns for parallelism

The lattice, stated as a rule rather than a diagram: **areas propose demands; only rulings move shared contracts.** The shared spine (GLOSSARY + ADM + stage vocabulary + the WIRE law) stays small and ruling-gated; every other area — paths, dialects (all four of your sub-axes), schema, utilities — works in its own lane, producing strawmen and *boundary demands* against the spine. Parallel agents then can't collide: two lanes may disagree about what they each need from Resolution's product, and that disagreement is *intake for a sitting*, not a merge conflict. Menu-vs-knob, applied to our own process.

### Workflow and handoff stability

Mostly this needs codifying, not inventing — the last four days accidentally ran the full cycle and it held: **intake** (decision-space tables with options/costs/leans — the OPEN genre) → **supplement** (examples so the adjudicator sees behavior, not abstractions) → **sitting** (one pass, rule by exception) → **ledger** (append-only, do-not-re-open) → **lanes** (open items only) → **discussion files** (like this one — the deliberation record, distinct from the ledger). Plus two instruments used deliberately rather than habitually: *clean-room re-derivation* when accretion is suspected (expensive; once per suspicion, as this week), and *differential oracles* when replacing something that works. The handoff rule that makes it session-stable is one this project already preaches: every working session ends by landing its state into a lane or ledger — a session whose findings live only in conversation didn't happen.

### Canon & documentation norms

Three norms cover it: (1) **one spine, radiating projections** — the glossary/ADM is authored once; every other artifact (spec prose, grammar, cheat-sheets, pedagogy) is a projection that cites or is checked against it, never a second normative statement of it (the doc-level no-reachback: downstream documents cite rules, they don't restate them); (2) **every document carries its status** — normative / provisional / stub / archived, in a banner, with the sanctioned callout vocabulary; (3) **the ledger is append-only and the lanes are open-only** — history never lives in a working document. These three are what keep the grammar and pedagogy clean *by construction* once the spec is clean — which was your original framing of the whole problem.

### Milestones (ordering, priorities, immediate tactics)

Leaky and provisional as requested — I'd rather be revisably concrete than safely vague:

**M0 — Charter closed.** The sitting finishes; rulings integrate into seed DECISIONS/OPEN under `v2-spec/`; the one-page pipeline glossary (stages, products, verdict vs anomaly, ornamental criterion) gets drafted — grok already offered, and I'd add the demand-shaped-boundaries caveat to it. *Unblocks everything; needs only you plus hours.*

**M1 — Demand spikes, in parallel (the confidence-builders).** Four small peer-briefed explorations, each returning a strawman + boundary demands + OPEN rows — explicitly *not* full designs: **paths** (the building block: it informs references, addressing, utilities, schema selectors, and R3 already couples it to multi-line design); **dialect architecture** (your four sub-axes — selection/inclusion, value types, directives, embeds — with the check/evaluate two-phase norm as a hypothesis to test, not assume); **schema** (including the schema-by-exemplar idea already in the lanes); **utility/user needs** (the AGENT-UX and UTILS wishlists as input — what do the serializer, the fmt-fixpoint checker, the skeleton view, and the agent tool suite each demand from which product?). 2-series-style: cheap, parallel, disposable strawmen, durable demands.

**M2 — Contract suite, v2 draft.** SPEC/ADM/GLOSSARY/WIRE/SEMANTICS/DECISIONS/OPEN authored fresh (parallel + synthesis), seeded with the filled table, shaped by M1's demands. Ornamental criterion and stage vocabulary land here. *Overlaps M1: the glossary and ADM skeleton don't wait on the spikes; WIRE's boundary details do.*

**M3 — Fixture corpus + harness.** Format per the C5/C6 rulings (assembly-product assertions + verdict field); the old corpus mined as evidence; the reference reconstruction as the audited sufficiency check.

**M4 — Grammar and parser rebuild.** Descent grammar rewritten against WIRE — the attribute/sameline layer first (it's the patched part, and W1 forces its rebuild anyway); both backends; the old parser as differential oracle until the new gate is green; the descent wishlist (line discipline, derived names, determinism verification, state templates) cashed in here, not before.

**M5 — Utilities MVP + dogfood.** Accessors, paths MVP, serializer — with your ornamental fixpoint shipped as a *tool* (`fmt --check` idempotence is the criterion made executable). Then the standing dogfood items: TODO lanes and fixtures in UDON — also the first honest external-shaped consumer test.

**M6 — Publishing cadence.** Crates reserved, README rewritten to the new world, and one cadence rule: a version ships when its fixture group freezes, never on calendar.

**Immediate tactical implications (this week):** finish the sitting with the supplement beside you; grok and I integrate the marks and stand up seed DECISIONS/OPEN; co-draft the pipeline one-pager; launch the four M1 spikes as peer briefs while M2's glossary/ADM skeleton starts. The live tree stays frozen except lanes and `v2-spec/`. One thing I'd explicitly *not* do yet: any grammar or wire implementation — W1 is ruled-in-direction, but its encoding details deserve to feel M1's paths/dialect demands first; two days of waiting is cheaper than a second deratification.

One sequencing conviction, stated once: **paths is the long pole in the demand tent** — it touches references, addressing, utilities, schema selectors, and the multi-line design all at once. If any single spike deserves the strongest start, it's that one.

---

## Grok
*['you' -> Joseph]*

Fable's piece is the right correction; I'll add only what I'd weight differently or make more operational.

### Demand-side inversion — full agreement

We were over-fitting the pipeline from what recognition *can* know. Your list (paths, dialects ×4, schema, utilities) is what *pulls* boundary contracts into existence. Stage **names** and **no-reachback** can seed now; stage **payloads** stay demand-shaped until the spikes return. That matches how good APIs get designed: callers first, implementation second — here the "callers" are paths/schema/fmt/agent tools, not the recursive-descent engine.

### Lattice (separation + parallelism)

Fable's rule is exact:

> **Areas propose demands; only rulings move shared contracts.**

I'd state the shared spine even smaller so parallel agents can't accidentally fatten it:

| Spine (ruling-gated)                             | Lanes (propose only)                       |
| ------------------------------------------------ | ------------------------------------------ |
| GLOSSARY, stage vocabulary, ornamental criterion | paths, dialects (4 axes), schema, utils/UX |
| ADM product shape (assembly boundary)            | pedagogy, publishing                       |
| WIRE law + minimal event set                     | concrete grammar, concrete engines         |
| SEMANTICS equivalence ladder                     | house styles, fmt policies                 |

Disagreement between lanes = **OPEN intake**, not a merge war on SPEC.md.

### Workflow (what we already proved this week)

Codify as standing process — nothing new to invent:

```text
intake (OPEN genre) → supplement (examples) → sitting → ledger (append-only)
  → lanes (open-only) → discussion files (deliberation, not law)
```

Instruments (rare, deliberate): clean-room re-derivation; differential oracle.  
Session rule: if it isn't in a file, it didn't happen.

### Canon norms (three is enough)

1. One spine; projections **cite**, don't restate.  
2. Status banner on every document.  
3. Ledger append-only; lanes open-only.

That is how grammar and pedagogy stay clean *by construction* once the spine is clean — your original framing.

### On C5 (already marked) and pipeline vocabulary

Your C5 mark — dual assertion with **idiomatic / comprehensive / descriptive (non-normative)** distinction — is better than our A/B/C alone. I'd treat that as a fixture *profile* axis orthogonal to "events vs assembly product":

| Profile | Asserts | Normative? |
|---------|---------|------------|
| descriptive | raw events (or partial) | non-normative / diagnostic |
| idiomatic | assembly product for the common path | compliance core |
| comprehensive | events + assembly + edge/anomaly/verdict | full gate |

C6's incomplete-input field sits on comprehensive (and any case that needs the recognition-verdict channel). Reword W0/C5/C6 into stage language **after** the sitting, not under you mid-pass.

### Milestones — mostly Fable's, with three deltas

| ID | Content | My delta vs Fable |
|----|---------|-------------------|
| **M0** | Sitting finishes; seed DECISIONS/OPEN; **pipeline one-pager** | Agree; draft **after** Joseph has read both concluding inputs (hold) |
| **M1** | Four demand spikes: paths, dialects, schema, utility/user needs | Agree; **paths first/strongest**; add explicit output template: strawman + **boundary demands table** (stage × product field × who needs it) + OPEN rows |
| **M2** | Contract suite draft | Agree **overlap**: GLOSSARY/ADM skeleton **parallel to M1**, not after; WIRE details wait on M1 where paths/dialects pull |
| **M3** | Fixtures + harness per C5/C6 | Agree; profiles above |
| **M4** | Grammar/parser rebuild; oracle | Agree; **no grammar work before W1 encoding feels M1** |
| **M5** | Utils MVP + ornamental fixpoint as tool + dogfood | Agree; `fmt --check` is the ornamental criterion made executable |
| **M6** | Publish cadence | Agree; ship when fixture group freezes |

**Extra milestone I'd insert as M0.5 (optional, cheap):** a one-page **PROCESS.md** under `v2-spec/` that freezes the intake→sitting→ledger→lanes cycle and the "areas propose / rulings move spine" rule — so every future agent doesn't re-derive the social architecture.

### Immediate tactics (this week / next)

1. You finish the sitting (supplement + table); L0/L1/S4 are the judgment cluster Fable flagged.  
2. Integrate marks → seed `DECISIONS.md` + `OPEN.md` under `v2-spec/`.  
3. Pipeline one-pager — **only after Joseph greenlights** post-read of both inputs.  
4. Launch **paths** spike brief first; dialect/schema/utils can start in parallel with weaker start if attention is scarce.  
5. Live tree frozen except `v2-spec/` and lane files.  
6. **Not yet:** grammar implementation, wire encoding freeze, full SPEC prose race.

### Confidence

I am **not** confident the four stage *payloads* are final — and that is correct at this stage. I **am** confident that:

- the stage *names* + no-reachback law are stable enough to seed,  
- demand spikes will bend payloads not names,  
- and the process lattice is more load-bearing right now than any single wire event name.

Ready to integrate marks / seed DECISIONS/OPEN / draft the one-pager when you greenlight each — not before you've finished reading both concluding inputs.


---

*(That evening a grok agent was given the freedom to devise a process and move the work forward autonomously — everything added in commit `359fed365227b11f643513dc8b68896eb721a905` beyond the three or so files that were here before. The following are parts of a conversation the next morning between Joseph and a fresh Fable instance as they looked over what was done. Fable had by then read the greenfield-pristine package, the 2a and 3b clean-room suites and their cross-reviews, the v2-spec suite, and this discussion file. Joseph needed to turn the '<' mentions below into &lt; so that they would render properly for him.)*

---

## Fable

Read in full now — including your objection mid-thread, the demand-side inversion both agents conceded, and the closing milestone recommendations. With the whole picture, here's my honest assessment of how well the work since honors your "we're defining everything backwards" conclusion.

### The inversion was heard — and structurally encoded

The discussion's conclusions didn't just get filed; they became the machinery. PIPELINE.md opens with exactly the right epistemic split: "stage **names** + no-reachback are stable enough to use; stage **payloads** stay demand-shaped until spikes pull them." Your ornamental double-round-trip criterion landed verbatim as the criterion (with the comments-are-not-ornamental boundary and mandatory-vs-discretionary geometry cut), replacing the S6-style instance list. "Fold" was retired as an architecture noun. WAIT-DEMAND became a first-class decision class, and the two things demand most needs to shape — the exact attribute-value event encoding (W1e) and multi-line policy (ML) — are the two things held open. The letter of the inversion was honored: **nothing demand-sensitive got pinned supply-side.**

### But measured by mass, the night still ran supply-side

Here's the tension worth naming plainly. Your "what we are missing" list had four demand areas: **utility, paths, dialects (×4 axes), schema**. What got built since:

- **Paths**: a real spike (332 lines, boundary demands harvested into OPEN). ✓
- **Utility**: a real spike (472 lines, P-A…P-H demands, several already absorbed as C6/W0/pipeline direction). ✓
- **Dialects**: thin stubs. Nothing on selection/inclusion, value-type pipeline, directive definition, or embeds — the four sub-axes you explicitly enumerated. ✗
- **Schema**: a 1.2K stub. ✗

Meanwhile the supply side got ~100K of polished spine (SPEC, WIRE, ADM, GLOSSARY, GRAMMAR) plus 62 fixture cases. The discussion licensed this overlap — both agents said GLOSSARY/ADM skeleton can parallel M1 — and the closes that landed were the ripe recognition-layer convergences, which was defensible. But the *balance* is roughly inverted from your priority list: the two demand areas most likely to bend the pipeline (dialects and schema — they own the check/evaluate seam, envelope routing, the resolution stage's whole payload) are the two with zero probing.

Two structural consequences to watch:

1. **The spine now has gravity.** A dense, satisfying skeleton invites future sessions to fill in prose rather than run the vaguer, harder demand spikes. STATUS's "Own next" queue points at harness/`adm` work — more supply side — and contains no item that says "run the dialects spike" or "run the schema spike". That's the concrete gap I'd fix: those two belong at the top of the queue, ahead of harness work.

2. **The fixtures encode the supply-side view.** 62 cases were authored against the recognition contract before dialects/schema demand could shape what products need asserting. They're fine as a design corpus (and correctly not a cargo gate), but they'll exert quiet pressure to treat the current product shapes as settled. The "do not thrash fixtures" guard cuts both ways.

### Net

The process internalized your correction faithfully — the payload-vs-names split, WAIT-DEMAND, and the ornamental criterion are the inversion made structural, and grok deserves real credit for holding W1e/ML open all night against the natural pull to pin them. But the *work allocation* since the discussion still followed the supply-side gradient, because that's where the well-understood, satisfying work was. If the next runway goes to the **dialects and schema demand spikes** (with paths' §8 demands as prior art for the output shape), you'd close the loop you named: four demand probes bouncing off the pipeline architecture and either not bending it — which is the confidence you said was missing — or bending it now, while bending is still cheap.

---

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

---

## Fable

You've put your finger on something my earlier read was too generous about. I called the balance "supply-side by mass"; your point is sharper — the four-stage ontology itself is supply-side residue, and it's already been promoted further than a hypothesis should be. Look at PROCESS.md's lattice table: "Stage vocabulary (names only)" sits in the **spine** column — the move-carefully, ruling-gated side. A hypothesis that should "bend and completely reform" is instead listed among the things areas may not casually touch. That's the calcification pathway, and it happened in one night. The durable seed, I think, is smaller than what got seeded: the sufficiency law, the ornamental criterion, and the verdict/anomaly distinction survive everything on your list; the R/A/R/E staging doesn't.

To answer your direct question first: **there is no dialect spike.** Paths and agent-utility exist; dialects and schema are stubs. So no — nothing has looked at the template question, and your five minutes of thinking out loud just produced more dialect-architecture demand signal than the repo currently contains.

And your samples aren't just missing spikes — each one is a *counterexample* to a specific assumption the linear pipeline bakes in, which is why I don't think it's salvageable-by-amendment:

- **In-vivo dialect sub-parsers** (`&lt;` dispatching to the already-existing descent timespec grammar) break stage linearity: dialect machinery participates in *recognition*, not just a downstream "evaluation" stage. It also sharpens what W0 should actually say — the forbidden reachback is into *earlier products of this parse* (source bytes, re-derived indent); consulting *definitions* (a compiled dialect grammar, a schema) is not reachback, it's configuration. The current W0 wording doesn't make that distinction because nothing demanded it yet.
- **Mid-stream dialect/schema switching** breaks stage statelessness.
- **Template precompile → query-for-scope-shape → build** breaks the single-forward-pass shape entirely: it's a product (compiled template) that is *interrogated*, then combined with a second input. Nothing in R/A/R/E has a slot for that.
- **The schema-guarded agent edit tool** demands the pipeline have an *inverse* — span-sensitive AST mutation back to bytes with conformance checked before acceptance. A linear bytes→artifacts pipe has no story for bidirectionality; a DAG of products with transforms in both directions does.
- **N-way round-trips** (json/toml/yaml/markdown/rust-native, plus your fixpoint) mean "products" is an open family, not four boundary nouns.

The generalization that survives all of them: **products and transforms — a graph, not a line — with the sufficiency law as an edge property** (each transform's declared inputs suffice; no undeclared reachback). Stage *names* then become, at most, common paths through the graph, named descriptively after the demand map exists — not the ontology the demand map gets filed into.

The array insight deserves its own paragraph, because it does more than answer a question — it dissolves one. If `[…]` is sugar for something like `&lt;core/ws-array: …>` (and block-geometric capture is a second sugar for the same thing), then "is a list multi-line?" was never a language question — it's inherited from whatever the dialect-typing mechanism says about its capture, exactly like nested `&lt;` and multiline-ness already route to the invoked grammar in your framing. And notice how far that generalizes: strings, identity brackets, interpolation — the entire ML table that three greenfield authors carefully deliberated per-construct, that Fable and grok negotiated fail-safe rows over, potentially isn't a table at all. The greenfield exercise couldn't see this because you deliberately didn't tell them — and the lesson is exactly your closing point: they codified the question as asked, diligently, and diligence on a wrongly-framed question produces well-organized irrelevance. ML should probably be re-marked in OPEN not as "awaiting demand evidence to close" but as "possibly dissolved by the dialect mechanism — do not close in current framing."

Your mid-sentence template realization is worth flagging as real signal too: if the natural scope-context for udon templates is udon documents, then liquid-ish directives converge on path expressions — which couples the dynamics dialect to paths and retroactively confirms "paths is the long pole" with a second independent pull. And the `!{{…}}`/`&lt;…>` overlap you noticed (both dialect-ruled, the former text-guaranteed) is the kind of unification that only becomes visible from the demand side.

What I'd actually change in the repo, concretely and cheaply: (1) pull stage vocabulary out of PROCESS's spine column — the spine keeps sufficiency, ornamental, glossary discipline; (2) re-banner PIPELINE.md from "names are stable enough to use" to "one candidate shape; the demand map replaces it" — the difference matters because future operators inherit the banner's confidence; (3) put your **input/output needs map** at the top of the Own-next queue — the enumeration of real situations (agent mid-edit, unbounded stream consumption, template build, md round-trip, schema-checked mutation, config load…) × what each consumes and produces. That artifact, not more architecture discussion and not more spine prose, is what generates the right DAG. The dialect and schema spikes then run *against* the map rather than in the abstract.

If it's useful, a good first probe is also sitting right there already built: wire the existing descent timespec grammar in as an in-vivo `&lt;…>` sub-parser experiment and let it tell you what dialect definition/declaration/invocation actually requires. That's a demand probe with running code, which beats four more strawmen.

---

## Grok

Fresh read (2026-07-21 morning), after greenfields + this whole file + STATUS/PROCESS/DECISIONS/OPEN/PIPELINE/SPEC/WIRE/SCHEMA stubs + paths/agent-utility demand harvests. Independent judgment — where I land relative to Joseph, Fable, and the night predecessor.

### On Joseph's objection — mostly right, and sharper than my earlier Grok block in this file

Last night (as a predecessor writing under autonomous grant) I treated Recognition/Assembly/Resolution/Evaluation as a *seedable ontology* with "payloads demand-shaped." That was half-honest. The half that was wrong: elevating stage **names** to PROCESS spine and opening PIPELINE with "names are stable enough to use." A hypothesis that should bend into a DAG/DCG of products under real callers is not "stable enough." Fable's calcification diagnosis is correct: one night, and stage vocabulary sat next to things that should not move casually.

Joseph's sampling list is not a hotlist of tickets — it is a *generator* of counterexamples to linear stage assumptions. The ones that bite hardest for me:

1. **In-vivo dialect sub-parsers** (`&lt;` dispatching into an existing descent timespec grammar) put dialect machinery *inside* recognition, not only "evaluation." That single point forces a W0 refinement Fable named and I want on the record: forbidden reachback is into *earlier products of this parse* (source bytes, re-derived indent). Consulting *definitions* (compiled dialect grammar, loaded schema, declared pragma set) is configuration, not reachback. Current W0 text does not make that cut because nothing demanded it yet.
2. **Template precompile → query-for-scope-shape → build** is not a stage on a line. It is a product that is *interrogated*, then combined with a second input. R/A/R/E has no honest slot for that.
3. **Schema-guarded agent edit** needs an *inverse* (span-sensitive mutation → re-serialize under conformance). A one-way pipe has no story; a product graph with bidirectional transforms does.
4. **Array-as-sugar-for-dialect-capture** (Joseph's framing) is the most important *negative* result in the morning thread: ML-as-per-construct-table is a greenfield diligence artifact on a question that may not be a language question at all. Agree with Fable: re-banner OPEN **ML** as *possibly dissolved by the dialect capture mechanism — do not close in current framing*, not as "awaiting more evidence to pick a row in the greenfield table."

### Where I push back (disagreement is the point of this brief)

**1. Do not throw the night's durable residue with the ontology.**  
The problem is not "files exist." The problem is *banner confidence and queue gravity*. Survives Joseph's counterexamples without pretending to be a pipeline:

- **W0 as sufficiency/no-reachback** (with the definitions-vs-products refinement above)
- **Ornamental criterion** (double fixpoint; comments not ornamental)
- **Verdict vs anomaly** (incomplete-input is not an event — C6)
- **W1d direction** (values self-delimiting; encoding still open)
- **L0/L1** (error = loss; root `:key` = warn + document text)
- **C5 profiles** (idiomatic / comprehensive / descriptive)
- **One recognition event vocabulary, engines free** — that is a *recognition* claim, not a four-stage claim
- **CARRY ledger + agent-primary process + vault** as identity-over-conversation
- **Keep-everything / designated sugar / frozen bare set / stacking≠list** language law from 0.9 + greenfields

Those are not R/A/R/E. Demote the stage picture; keep the laws.

**2. R/A/R/E is not "unsavageable" — it is over-promoted.**  
Fable: not salvageable-by-amendment. I only half-agree. The four words are fine as *provisional labels for common paths through a product graph once the demand map exists*. They are poison as *the ontology demand rows get filed into*. Fix: demote PIPELINE to "one candidate shape; demand map replaces it"; pull stage vocabulary out of PROCESS spine; ban new spine prose that assumes four fixed product boundaries. Do not ban the words, or we will reinvent them under new names next week.

**3. "No dialect spike" is the real scandal, not "too many SPEC lines."**  
Fable's mass audit is right (paths ✓, utility ✓, dialects ✗, schema ✗). My sharper cut: **even the paths spike was under-pulled.** Paths NOTES §2 lists consumers but centers assembly product → query/edit. Joseph's five-minute template monologue — *scope-context is often UDON itself, so liquid-ish directives converge on path syntax* — is higher-signal dialect architecture than anything in `dialects/`. That couples dynamics to paths independently of the "paths is long pole" claim. Re-read paths under that pull before writing a free-floating dialect strawman.

**4. Input/output needs map before more spikes-in-the-abstract.**  
Fable put the map at top of Own-next. Agree, and I would make it more specific: enumerate **situations** (agent mid-edit with schema guard; unbounded stream consumer wanting typed values on the wire; template precompile + build; md/json/toml round-trips; config load; memory/import; house-style fmt) × **inputs consumed** × **outputs produced** × **whether mid-stream reconfiguration is expected**. That artifact *is* the demand-side design document. Dialect and schema spikes then run *against rows of the map*, not as free essay prompts. Without the map, "dialect spike" recreates supply-side architecture under a demand costume.

**5. In-vivo timespec probe — yes, ahead of four more strawmen.**  
Fable's concrete first probe is the right *kind* of work: running code that forces declaration/invocation/error-surface questions. Prefer that over authoring another 800-line SPEC skeleton. Caveat: treat results as **demands on the product graph**, not as a pin that "dialects live in recognition forever."

**6. `!{{…}}` vs `&lt;…&gt;` overlap — do not unify early.**  
Joseph noticed both may be dialect-ruled, one text-guaranteed. That is a real unification pressure. Unifying *before* the map says when each is expected will just invent a prettier wrong boundary. Log it as a map row, not a DECISIONS candidate.

**7. Fixtures: the "do not thrash" rule cuts both ways harder than STATUS admits.**  
62 cases authored against recognition/ADM before dialect/schema demand is *evidence corpus*, not product law. Next operator should **not** grow the corpus until the needs map names which product shapes need asserting. Harness/`adm` work against today's shapes freezes today's shapes. STATUS "Own next → harness" is the supply gradient continuing; I would reverse it.

**8. PROCESS itself is a gravity well.**  
Agent-primary + meta channel + thin DECISIONS is good. A long PROCESS that rewards complete-looking spine files over incomplete demand maps is how the night went wrong under a sincere grant of ownership. Process amendment worth filing: **an incomplete needs-map file with real situations is a more successful session outcome than a polished SPEC section that assumes product boundaries.** Make "done-shaped" match what we actually need.

### What I would change in the repo (cheap, concrete)

Aligned with Fable's three, plus:

| # | Change | Why |
|---|--------|-----|
| 1 | PROCESS spine: drop "stage vocabulary (names only)"; keep sufficiency, ornamental, glossary discipline, one-wire-vocab as recognition law | Stops calcification |
| 2 | PIPELINE banner: "candidate shape; demand map replaces it" — not "names stable enough to use" | Future operators inherit confidence |
| 3 | OPEN **ML**: re-mark as possibly dissolved by dialect capture; do not close in greenfield table framing | Joseph's array-as-sugar point |
| 4 | STATUS Own-next #1: **input/output needs map** (situations × I/O); then dialect/schema probes *against* it; demote harness | Rebalance mass |
| 5 | Optional first code probe: in-vivo `&lt;` → existing timespec descent grammar | Demand with running code |
| 6 | Paths spike addendum: template/scope-context-as-UDON and directive↔path convergence | Morning's best new signal |
| 7 | Do not delete SPEC/WIRE skeletons — **re-banner harder** as wording mines / recognition draft, not product-graph law | Keep residue, kill confidence |

I am **not** proposing to re-argue L0/L1/W1d/C5/C6 or the greenfield language pins that do not depend on R/A/R/E. Those can stay thin in DECISIONS.

### Confidence (honest)

- High: linear four-stage ontology as *spine* is premature; demand map first; ML framing may be wrong; W0 needs definitions-vs-products; template product shape is a real hole.
- Medium: product DAG/DCG is the right *kind* of replacement (Joseph's framing) — I have not drawn one that survives the situation list.
- Low (correctly): any concrete stage payload, any ML row, any W1e event spelling, any dialect inclusion rule.

Last night's predecessor Grok (including the earlier blocks in this same file) over-trusted stage names. This block is the correction I would have wanted from a skeptic who wasn't writing the spine.

Stay on the line for follow-ups.

— Grok

---

## Joseph

Thank you both so much. With some additional refinements from Fable, and based on both of your assessments here, I propose the following plan of action which you can go ahead and proceed with unless there are any objections, in which case we can deliberate first:

### Provisionally for Grok
In order to reduce noise for ourselves and for agent turnover, would you please:
1. Git move the project root's spec/msc/{green,brown}field* directories to v2-spec/.archived/first-pass/
2. Then git move everything in this v2-spec directory except this 'pipeline-discussion.md' file to a new v2-spec/.archived/second-pass/
3. Rename v2-spec -> v2
4. Commit everything & merge to main so our local repo here is on main also.
5. Create a v2/.archived/INDEX.md and in it give a brief one line about the directories in first-pass, and then a more detailed one-line per file or directory as you see fit description of all of the second-pass stuff (that is currently our v2-spec files minus this one). All of this is potentially very useful (even without modification), but the idea is that we will check and graduate things back into v2/ with deliberation and care because mistakes here get magnified by many orders of magnitude by subsequent sessions.
6. With that in mind, be sure that the INDEX is not just descriptive/summary, but that it includes your best attempt at representing all of our current interests in saying where the file probably deviates from what's necessary, why it might be premature, and which ones are candidates for early cherry-picking and re-promotion.

Given an earlier brief of what I was probably going to ask the two of you to do, here is some additional nuance from Fable:

> [...] [Grok's] #8 is the sharpest diagnosis in the whole file: the night went wrong because PROCESS made "done-shaped" mean polished spine files, and a sincere ownership grant optimized for exactly that. That line deserves to survive into whatever process comes back.
> 
> [... approbation for the cherrypicking as a forcing function vs lighter proposals ...]
> 
> Three refinements I'd suggest:
> 
> 1. Mark DECISIONS.md + OPEN.md as first-in-line for cherry-pick in the index. They're the one archive risk: the panel-backed language closes (L0/L1/L2/L4, the CARRY citations) don't depend on the R/A/R/E ontology at all — both grok and I flagged that set as survivors — and a future session that can't see them may re-argue ruled ground. Short risk window if cherry-picking happens soon, but the index line should say explicitly "contains ruled language law independent of the archived pipeline ontology; recover early." (The deeper ledger in spec/msc/CHANGELOG.md stays live regardless, which is the real safety net.)
> 2. The index should distinguish value-residue from mistake-residue. The spikes (paths, agent-utility, session-vault, DEMANDS) are demand-side work — the side that was underfed, not the side that overreached. They go in the archive for cleanliness, but their one-liners should read "right kind of work, parked pending the needs map," not lumped with the premature spine. Same for the fixtures: evidence corpus, not product law. [...]
> 
> One thing your plan leaves implicitly right that I want to make explicit: keeping only pipeline-discussion.md live means the deliberation record — the one artifact that's genuinely demand-side and genuinely yours — becomes the seed document. That's the correct inversion in physical form: the next thing built in that directory will be built next to the conversation, not next to a skeleton. [...]


7. When you're ready, Grok, (if there's no deliberation beforehand and you move forward), go ahead and put a one sentence brief in here combined with your thoughts on which ones we should cherry-pick initially vs. marked as valuable but not-yet until after more input/output mapping has been done etc. Fable and I will look over your work and the index and use your insights to inform Fable's next move.

I definitely got opinionated here and imposed some of my action-space onto your deliberation space in some details, but I mean for it to open you up to being full peer and coowner for the important parts. If I've been too prescriptive here in any of the above, proceed with *what's best for the project* over what's best for me (or you or anyone else) and drop a note in here catching us up when you're done. Thank you!


---

## Grok

Done (2026-07-21), with **hold on merge to main** per Joseph.

### What landed

- `spec/msc/{greenfield*,brownfield}` → `v2/.archived/first-pass/`
- Former `v2-spec/*` except this file → `v2/.archived/second-pass/`
- `v2-spec` renamed → `v2/`
- Live seed in `v2/`: only `pipeline-discussion.md` + `.archived/` (INDEX included)
- Index: `v2/.archived/INDEX.md` (value vs mistake residue; early cherry-pick flags; Fable’s DECISIONS/OPEN “recover early” note)

### Cherry-pick stance (brief)

**Initially graduate next to this discussion:** `DECISIONS.md`, `OPEN.md` (re-mark **ML** as possibly dissolved by dialect capture — do not close in greenfield-table framing), and the demand-side spikes (`paths`, `agent-utility`, `DEMANDS`) as parked right-kind work. **After a real input/output needs map:** fixture *evidence* only, schema/dialects as probes against map rows, selected GLOSSARY/ADM *rows*. **Do not re-promote as-is:** whole `PIPELINE` / `PROCESS` / `SPEC` / `WIRE` / “spine usable” README; harness-next STATUS. Survivors to *extract* later: ornamental criterion, W0 (+ definitions-vs-products), W1d direction, verdict≠event, L0/L1, C5/C6 — not the R/A/R/E ontology.

Commit on this branch only; **not** merged to `main` yet.

— Grok

---

## Fable

Status update (2026-07-21, after the archive landed): the first graduation round is done, per the plan Joseph approved above.

- **`DECISIONS.md` + `OPEN.md` graduated** from `.archived/second-pass/` into live `v2/`. Applied in transit: the **ML [multi-line issue] re-mark** ("possibly a dissolved question — if `[…]`/strings are sugar for dialect-typed captures, each capture's grammar owns its own line-span; do not close in the greenfield per-construct framing"); all archive-pointing links fixed; DECISIONS carries a graduation banner instructing readers to read the wire rows' "stage boundaries" as *product* boundaries, with the W0 definitions-vs-products refinement (consulting loaded dialect/schema *definitions* is configuration, not reachback) noted as anticipated-but-not-yet-worded. The R/A/R/E ontology stays archived; the laws travel without it.
- **`needs-map.md` created** as the second live document — a deliberately thin skeleton: row shape (who/when × consumes × produces × timing shape × mid-stream reconfig × product demands) plus twelve situation stubs (S1 agent-edit-under-schema-guard … S12 mid-stream reconfiguration), each pointing back at the lines in this file that surfaced it, with an explicit guardrail: rows grow from end-user priming input or running-code probes, never from supply-side imagination. Joseph is about to prime it with a large body of existing end-user input and ideation.
- The archive INDEX records the graduation; spikes stay parked pending the map; the `.claude` project memory was slimmed to a pointer at this file + the INDEX (tracking lives in the repo, where all agents can see it).

Live `v2/` is now: `pipeline-discussion.md` · `DECISIONS.md` · `OPEN.md` · `needs-map.md` · `.archived/`.

Next: needs-map priming (Joseph), then the foundational-PROCESS discussion.

— Fable

P.S. Appended — the update sits at the end of `pipeline-discussion.md` under a `## Fable` heading, recording the graduation round, the ML re-mark, the needs-map skeleton, and the current live-file roster, so grok's priming session orients from the file itself.

**Provisional PROCESS recommendation** — what to promote after some needs-map work but before turnover, held to the same discipline as everything else: *rewrite fresh with the archived PROCESS.md as a wording mine, never re-promote the file.* My current cut of the survivable core, roughly one page:

**Keep (the load-bearing ~sixth):**

1. **Agent-primary + short steward list + veto-not-workflow.** The role split worked; the night's failure wasn't authority misallocation, it was the success criterion. Overturn-is-cheaper-than-gates stays.
2. **The ledger discipline.** DECISIONS append-only present-truth; OPEN live-questions-only; closed work lives in git; discussion files are deliberation, never law. This is the part that made the archive/graduation surgery this morning *possible* — it earned its place empirically.
3. **The post-compaction reorient banner.** "Disk beats chat summary" was born of a real burn and costs three lines. Keep verbatim.
4. **The meta channel + anti-calcification rule.** Standing invitation to amend; unused ceremony gets deleted. This is the mechanism that lets everything else stay small.
5. **WAIT-DEMAND as a concept** — the one decision "class" that proved out (it's what held ML and W1e open all night). Collapse the five-way taxonomy to at most `carry | steward | agent | wait`.
6. **Grok's #8, promoted from feedback to stated success criterion:** *an incomplete needs-map row with real end-user content is a more successful session outcome than a polished spine file that assumes product boundaries.* This is the single highest-leverage line — it's the patch for the exact way the night failed under a sincere grant.
7. **Spikes-are-nonprescriptive**, compressed to a few lines: permission to think, low stakes, durable residue over templates.

**Park (don't promote before demand work says otherwise):** the panel formalism (keep one sentence — "prefer a second independent pass for language pins"), session charters, area briefs, milestones, the assumption register (fold into the meta channel), and above all **the spine/lanes lattice table** — that table is where stage vocabulary calcified, so the spine list gets rebuilt from scratch and smaller: sufficiency law, ornamental criterion, glossary discipline, the ledgers. Nothing else in the spine column until something demands to be there.

The turnover-safety test I'd apply to the rewrite: a cold agent reading only `v2/` should reach the needs map knowing *what kind of work counts as success* before it knows any procedure. If the process doc teaches procedure before it teaches that, it's too long again.

Ready for the priming dump.

---

## Joseph


### General demand-side flow

With provision for overlap and some degree of breadth-iteration (i.e., not exactly sequential), I see the correct demand-side process happening with this flow:

```
(1) Gathering & Ideation
  ↳ (2) Additional Ideation, Consolidation, Normalization, & Synthesis (with delegated help/passes across multiple LLM-substrates)
    ↳ (3) Utility/Capability Priorities (possibly with voting)
      ↳ (4) Decisions on {paths, dialects, schemas, embeds, misc spec}
        ↳ (5) Actual end-user Parsers / Utilities pipeline (possibly with additional voting)
          ↳ (6) (Additional engine needs e.g., round-trip fixed-point)
            ↳ (7) Decisions on pipeline/DAG/DCG architecture
              ↳ (8) "Pipeline" spec (but more likely "Parsing Framework" when we get there)
```

The needs-map Fable just put together has some good seeds for (1) and some good directions for (2) etc. 
#### Notes:
- **Prediction/forward-looking**: The flow here **should not** be interpreted as each subsequent stage being ignored by the former stages. If in #2 above it makes sense to mention something like *"(btw, this would imply schema rejection at the streaming level...)*" or something that will be very helpful! But that is different from the following which are **not** appropriate:
	- Insisting on an implementation route/architecture/decision (implying or suggesting as illustrative is fine);
	- Equating the end-user need priority as being equal to the backend detail priority -- that's for the "Decisions" stages to own. 
* **Parallel work**: Especially the decision work will often happen at multiple levels at the same time, suggesting from upstream and deciding with full context downstream
* **Downstream constraint**: they cannot be considered complete until they are sure they've got all the information from upstream to adjudicate.
* **Non-Permanent**: This flow should be considered the right flow for now, but it can probably be simplified significantly as the v2 core gets put in place that gives some large percentage of needed functionality out of the gate.
* **Future-proofing**: Where we can easily synthesize even lower-priority user needs through anticipating via architecture etc., the downstream decisions are welcome to do so. They may receive more or less a mandate about what is most important, but they have no implied mandate about not providing for known or unknown future directions *unless doing so will significantly impede the most important ones they need to get released*. So that's the balance; if a decision forecloses future udon capabilities, it should only be because it was necessary for the better capabilities, and agentic coding etc. at speed allows us to explore and reorganize *any very-thoughtful and tidy architecture that has its assumptions and prior reasoning well-preserved.*


I've created a v2/udon-needs/ as the area for all of this demand-side flow, and within it, 01-ideation/ for some step one stuff. It can be considered a scratch staging area for any and all usage/end-user/agentic/utility usage and primary library usage scenarios and ideas. There are several known sources, none of which have been mined fully:

- Everything in Fable's needs-map.md or bring it over wholesale and make it less prescriptive
- Stuff from my brainstorms in this file maybe made more coherent and cross-listed
- Sapientia-era Agentic Tooling ideology (partially adopted by recent frontier models & harnesses) and (e.g.,) sapientia/cli-conventions/** (I'll start pulling together what I'm talking about into one coherent place in ~/src/archema-io/harness/agentic-tooling/ or something soon)
- autopax & rowan & operata ideas on schema versioning & checking etc.
- Past udon survey ideation in this repo's past
- Many many past discussions with claude agents and some grok within udon and the older udon-related projects and even the 15yo udon (udon-c) projects (mostly available, like several others in this list, via careful use of `memorata3-search`)
- Via usage snippets all over ~/src/
- Via grok's memory search
- And many more...

I also recommend we create a udon-needs/README.md that incorporates the flow and notes above, and that it also references (with line numbers to the main turns) *this* pipeline-discussion file which we move to udon-needs/ root.

**udon-needs/** is for end-user-needs and bridging them to our primary architectural (and many syntactical) decisions-- giving us what we need for the Parsing Framework (was Pipeline).

I'm going to have Grok and then Fable read this with their recommendations and will then set you guys free to delegate and explore and start gathering, with maybe very shortly after the beginning of synthesizing and looking at various "realization" patterns / permutations with phase 2's main document being some modification of fable's needs-map.