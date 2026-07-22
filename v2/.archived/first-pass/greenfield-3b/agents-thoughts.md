Quantitative

Size

┌───────────────────────────────────────────────────┬───────┬────────────────┐ │ Corpus                                            │ Lines │ Words (approx) │ ├───────────────────────────────────────────────────┼───────┼────────────────┤ │ Original scrubbed suite (spec/*)                  │ 2,680 │              — │ ├───────────────────────────────────────────────────┼───────┼────────────────┤ │ New suite (new-spec/**, incl. pedagogy/decisions) │ 2,188 │              — │ ├───────────────────────────────────────────────────┼───────┼────────────────┤ │ Original CORE only                                │ 1,745 │        ~15,800 │ ├───────────────────────────────────────────────────┼───────┼────────────────┤ │ New CORE only                                     │   844 │         ~4,800 │ └───────────────────────────────────────────────────┴───────┴────────────────┘

So: CORE is ~48% the lines and ~30% the words. The whole suite is only modestly smaller than the original suite, because mass was moved, not only deleted — MODEL, SEMANTICS, GLOSSARY, DECISIONS, recast dialects.

Density shifted too: original CORE ~9.0 words/line; new CORE ~5.6. That tracks “longer essay paragraphs + embedded teaching” → “tighter contractual lines + tables.”

Structure

┌────────────────────────────┬───────────────┬───────────────────────────────────┐ │                            │ Original CORE │ New CORE                          │ ├────────────────────────────┼───────────────┼───────────────────────────────────┤ │ ## sections                │ 23            │ 17 (numbered 1–15 + 2 appendices) │ ├────────────────────────────┼───────────────┼───────────────────────────────────┤ │ ###                        │ 68            │ 54                                │ ├────────────────────────────┼───────────────┼───────────────────────────────────┤ │ ```udon examples           │ 93            │ 10 (+ 6 in pedagogy tour)         │ ├────────────────────────────┼───────────────┼───────────────────────────────────┤ │ Admonition callouts ([!…]) │ 17            │ 0                                 │ └────────────────────────────┴───────────────┴───────────────────────────────────┘

Original CORE was trying to be contract + tutorial + edge-case museum + implementer diary in one scroll. New CORE is thinner as a reading surface because examples and status drama left.

Conformance voice

┌──────────────────────────────┬───────────────┬─────────────────────────────────────┐ │                              │ Original CORE │ New CORE (+MODEL/SEMANTICS)         │ ├──────────────────────────────┼───────────────┼─────────────────────────────────────┤ │ RFC 2119 MUST/MUST NOT       │ 0             │ 14 (+6 more in companions)          │ ├──────────────────────────────┼───────────────┼─────────────────────────────────────┤ │ SHOULD*                      │ 0             │ 4 (+1)                              │ ├──────────────────────────────┼───────────────┼─────────────────────────────────────┤ │ MAY                          │ 0             │ 19 (+9)                             │ ├──────────────────────────────┼───────────────┼─────────────────────────────────────┤ │ “the parser”                 │ 17            │ 0                                   │ ├──────────────────────────────┼───────────────┼─────────────────────────────────────┤ │ “parser” (any)               │ 31            │ 0                                   │ ├──────────────────────────────┼───────────────┼─────────────────────────────────────┤ │ “head position”              │ 23            │ 0 (→ Structure Position ×15)        │ ├──────────────────────────────┼───────────────┼─────────────────────────────────────┤ │ CURRENT / UNDEFINED BEHAVIOR │ 9 / 5         │ 0 / 0 (pinned in DECISIONS or OPEN) │ ├──────────────────────────────┼───────────────┼─────────────────────────────────────┤ │ GREENFIELD markers           │ 0             │ 9 in CORE (honest deltas)           │ └──────────────────────────────┴───────────────┴─────────────────────────────────────┘

That last block is the feel in a single chart: original describes a system’s behavior; new asserts a contract.

Vocabulary

┌───────────────────────────────────────┬───────────────────────────────────────────────┐ │                                       │                                         Count │ ├───────────────────────────────────────┼───────────────────────────────────────────────┤ │ extracted-jargon.txt definition lines │ ~152 terms (messy, overlapping, honest probe) │ ├───────────────────────────────────────┼───────────────────────────────────────────────┤ │ New GLOSSARY formal rows              │                                           ~72 │ ├───────────────────────────────────────┼───────────────────────────────────────────────┤ │ Explicitly retired synonyms           │    9 named (freeform, blob, head position, …) │ └───────────────────────────────────────┴───────────────────────────────────────────────┘

Roughly: half as many named concepts in the contract surface, not because the language shrank, but because duplicate names and implementer-internal names were refused entry.

Decisions

15 recorded: about 8–9 behavior pins, rest organizational. Multi-line (D1) is the largest user-facing contract change; most of the rest is “open → specified” rather than “old happy path → new happy path.”

───

Subjective feel

What the original feels like

A brilliant lab notebook that became the constitution by accident.

It has real depth — ownership rows, bare-token boundary, inline-brace principle, $partial-key, geometric vs delimited EOF — and those ideas are good. But the reading experience is:

• You meet scan machinery before you meet what a document is. • The same rule is taught three times (prose heuristic, worked example, edge case), sometimes with a CURRENT BEHAVIOR footnote that half-takes it back. • Vocabulary drifts mid-document (“blob” / “flow” / “text”; “freeform” / fence; “head” everywhere). • Status is honest but scattered — provisional, undefined, needs-a-ruling live next to normative prose with the same visual weight. • Companions disagree with CORE (TIME-SPEC still bare-recognizing while CORE says envelope-only). That undermines trust even when CORE is right.

If you already have the language in your head, the original is rich. If you don’t, it’s a fog with excellent mountains in it.

What the new suite feels like

A small constitution with annexes.

You can walk: glossary → model → core rules → “what we changed” → open questions. The emotional register is drier on purpose. Less “let me show you why this is beautiful,” more “here is what MUST hold.”

That is an improvement for a middle pillar. It is a demotion as a single document that seduces. I put a little of the seduction back in pedagogy/tour.md, but it is thin compared to original CORE’s 93 example blocks.

───

What I’m actually proud of (specific)

1. ADM before surface.  
Original never quite says “an Element is name + ordered attributes + content, and sugar is not a second ontology.” It implies it across identity/attributes sections. MODEL §3 + sugar table makes “generators can only emit attributes and still produce identity” a theorem, not a vibe. That was always the design; it is now load-bearing prose.

2. Stacking vs list as a first-class distinction.  
Original has it (and warns about host views collapsing it). SEMANTICS makes  
:x 1 :x 2 ≠ :x [1 2]  
a round-trip law, not a footnote. That is the kind of thing that stops “helpful” AST normalizers from lying.

3. Structure Position + Line Scan instead of “head position” as ambient weather.  
“Head position” in the original is correct but sticky — it colonizes every section. Renaming and defining it once (geometry §3.3) then referring by role made CORE sections about attributes/comments/escape stop re-explaining the universe.

4. Extent as its own chapter (geometric vs delimited + EOF).  
Original buries one of the language’s deepest invariants near the end, mixed with anomaly ladder and line-boundedness caveats. Pulling extent into §13 and deciding multi-line (D1) replaced a fog bank with a rule. Even if you reject D1’s particular choice, the shape “extent is a chapter” is better than “undefined per construct, see footnotes.”

5. Zero “the parser” in the contract.  
This sounds cosmetic. It isn’t. Every time the original says “the parser does X,” a reader’s mind builds a particular control-flow machine — which is exactly the priming problem you described. “Recognition MUST map …; a Recognizer is not required to implement mixins” keeps Host/Document/Dialect layers from collapsing into one imagined Rust file.

6. Anomaly posture re-scoped without becoming JSON-harsh.  
Proud of not swinging the pendulum. Keep-everything stays recognition law; reject/halt become Consumer knobs (menu). That preserves LLM/stream partial-input honesty and gives “strict mode” a place that isn’t a second dialect of the language.

7. Temporal honesty.  
Original suite felt incoherent because TIME-SPEC and CORE contradicted each other. Recasting temporal as envelope-only dialect is mostly alignment, but the feel of a suite that doesn’t argue with itself matters more than line count.

8. DECISIONS.md as a product.  
For a greenfield rewrite, the most useful artifact for you might not be CORE — it’s the list of “here is where I pinned the open joint.” Behavior vs org tags mean you can audit deltas in twenty minutes without diffing 1700 lines of prose.

9. Ownership asymmetry stated as a table, not a journey.  
Original teaches element-rooted vs attribute-rooted through narrative (“this is the whole of ownership”). New CORE keeps the rule and puts it in a priority table. Less charm, more something you can implement without re-reading three pages.

───

What feels worse or thinner (honest)

Example starvation.  
93 → 10 udon fences in CORE is a real loss for “I learn by seeing.” The original’s hierarchy chapter is almost a short story about columns; mine is a Nesting Rule and a non-normative stack appendix. For pedagogy, original still wins unless we grow pedagogy/ a lot.

Some texture compressed too hard.  
Escape’s four positions, fence closer indent pitfalls, comment-at-base vs deeper-literal — covered, but the original’s worked counterexamples carry muscle memory. Cross-check says “covered”; a new implementer might still need the corpus snippets as the real second volume.

RFC 2119 can feel bureaucratic.  
Original’s voice is more alive. Mine is more enforceable. Those are different virtues; I optimized for the middle pillar you asked for.

I may have over-retired jargon in places.  
“Head position” was sticky because it was useful. Structure Position is clearer for outsiders; veterans may feel translated. That’s acceptable if the glossary is the bridge — but it’s a real social cost inside the project.

Float equality / a few SEMANTICS edges are still soft.  
I would not brag about those paragraphs.

───

One-line feel summary

Original: a deep, slightly haunted design diary that contains a language.  
New: a smaller language constitution that still needs a diary and a textbook beside it — but no longer pretends they are the same file.

The improvement I’m most sure of is not “shorter.” It’s separability: you can disagree with D1, swap temporal, or rewrite pedagogy without the contract dissolving — and you can find the contract without inhaling scan mythology first. The improvement I’m least sure of is whether CORE alone is still sufficiently example-rich for a cold implementer without the clean-room snippets as co-equal input.
