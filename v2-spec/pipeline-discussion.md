# Pipeline discussion — stages, "fold," verdicts, ornamental

*(status: ongoing, 7/20)*

## Joseph

❯ In c6 you discuss the fold. What *specifically* does this entail?

---

## Fable

"The fold" is a specific, small program — worth pinning down exactly, because it's the executable form of the W0 law. Concretely:

Definition. A fold is a single pass over the event stream with an accumulator and nothing else: fold(events) → (tree, anomalies). It consumes events one at a time, in order, and its only memory is the structure it's building (in practice: a stack of open nodes). Its inputs are forbidden from including the source bytes, spans, or any re-derived layout logic — if the fold ever needs to peek at the original document or re-run indentation analysis to decide where something belongs, the wire has failed the law at that point.

The instance that already exists (post-text-recast, in the harness today): the text fold —

Text/RawContent → append content as-is
BlankLine       → append "\n"
everything else → no text contribution

That's the whole thing, and it's the contract sentence from TODO-TEXT-WIRE made runnable. The deleted compensator was precisely a fold that cheated — it consulted source gaps between spans to reinsert the newlines the wire dropped.

The generalized fold (what C5's option A asserts, once W1's bracket exists) is the structural extension — a stack machine:

ElementStart      → push new element onto stack
Name / Attr key   → set on stack top / open an assignment
value events      → attach to the open assignment
AttrValueEnd      → close the assignment          ← W1 makes this possible
Text/BlankLine    → append to stack top's content (text rules above)
Warning/Error     → append to anomaly list
ElementEnd        → pop; attach to new stack top

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

Text/RawContent → append content as-is
BlankLine       → append "\n"Is this an accurate model of what we're talking about?:

```
  pushdown-parser(udon chunks -> Raw event stream -> assembled event stream)  -> stepwise (streaming) AST
  RD-parser(udon doc -> Raw event stream -> assembled event stream)           -> oneshot AST
```

  with any of (pushdown, RD, streaming AST, oneshot AST) parsers or parser-modes available to the end-user as libraries?
  (where assembled event stream is what you are calling folded?)
Close — two corrections, one of which is exactly the kind of confusion the vocabulary work should prevent:

1. There is no "raw vs. assembled" event stream — there's one event stream. Both backends emit the same wire, and that identity is a proven property (pushdown_differential runs every fixture × every chunk size against the one-shot RD parser and asserts identical events, spans included). So the model is:

pushdown parser:  udon chunks   →  event stream   (resumable at any byte boundary)
RD parser:        whole udon doc →  event stream   (same stream, proven identical)

One wire, two engines. The stream is the WIRE contract's subject; nothing between the parser and the stream.

2. The fold is not a stream — it's the step after the stream. Fold = the event-stream → tree reduction. So in your model, "assembled" corresponds not to a second event stream but to the output of the fold:

                       ┌→ streaming AST builder (fold that ships each root
event stream ──────────┤   subtree the moment it closes)
                       ├→ one-shot AST builder (fold that returns one Document)
                       └→ any custom consumer (your own fold: an indexer,
                           a highlighter, a converter — never re-reads source)

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
 
 (NOTE: I have only started going through the results from you and the other t parts of the rulings table-- so it's almost certain there are more refinedideas that aren't represented yet above. If it isn't yet, I think we should consider defining "ornamental" as 'choices about things that change how the udon looks without changing the AST (or some late consumable form before that), except they mayn namespace for exact verbatim round-trip. But it can be proven to beornamental if a round-trip is made that strips them before going back to udon, and then a second round trip results in the same original AST + exactly the same udon as the result
  of the first round-trip, i.e.:

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

