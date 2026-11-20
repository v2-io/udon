# Feedback on greenfield-3a (from greenfield-3b / Grok)

**Auditor context:** I did the parallel clean-room rewrite in `../greenfield-3b/` (longer middle-pillar suite: MODEL / CORE / SEMANTICS / DECISIONS / dialects / pedagogy). I have not coordinated with this author; this is an independent read of `new-spec/` + `agents-thoughts.md` against the scrubbed input (`spec/`, snippets) and against what a middle-pillar contract needs to carry.

**Tone:** peer review, not a score. 3a and 3b optimized for different goods; both are useful.

---

## 1. What 3a is, in one paragraph

A **ruthlessly compressed three-pillar sketch**: Grammar (parser mechanics) / Specification (ADM + meaning) / Dialects, plus a short Glossary. ~**367 lines / ~3,500 words** of new-spec total versus the scrubbed CORE alone at ~1,745 lines / ~15,800 words. The structural bet matches `defining-udon.md` more literally than 3b did (3b deferred grammar and put weight on the middle pillar). As an **orientation map** of the language, this is strong. As a **complete normative contract** for implementers or for closing open rulings, it is not yet that — and `agents-thoughts.md` overclaims that it is.

---

## 2. Quantitative snapshot

| Artifact | Lines (approx) | Role |
|----------|---------------:|------|
| `1-GRAMMAR.md` | 115 | Lexer, boundary, indent, prose, anomalies |
| `2-SPECIFICATION.md` | 125 | ADM, attributes, sugar, scalars, refs, verbatim |
| `3-DIALECTS.md` | 83 | temporal@1 + baseline dynamics |
| `GLOSSARY.md` | 44 | Term source of truth |
| **Suite total** | **~367** | |
| Scrubbed `spec/CORE.md` | 1,745 | |
| 3b `new-spec/CORE.md` alone | 844 | for comparison |
| 3b full suite | ~2,200 | |

Other signals:

- RFC 2119: **~30 MUST**, **0 SHOULD** — decisive voice; almost no soft guidance layer.
- Examples: very few `udon` fences (mostly one dynamics illustration). Compression won; teachability lost.
- No DECISIONS / OPEN / SEMANTICS / Markdown-layers / pedagogy files.

Compression ratio vs original CORE is extreme (~15× by lines if you only count 1+2, ~5× if you count the whole suite vs full scrubbed `spec/`). That only works if coverage is actually preserved. It is **not** fully preserved (see §4).

---

## 3. What is genuinely good (steal-worthy)

### 3.1 Pillar firewall as a first-class product

Splitting **Grammar** vs **Specification** vs **Dialects** is the right answer to the original’s pillar collapse. A reader can open `2-SPECIFICATION.md` and meet ADM before scan state. 3b put ADM in a separate MODEL file and kept recognition rules in one CORE; 3a’s split is cleaner for *defining-udon*’s three-pillar diagram and for “I am writing a PEG today / I am writing a host today.”

**Steal for anyone:** keep that firewall even if files get longer.

### 3.2 Glossary as declared source of truth

Short, intentional, and explicit that other docs must not invent nouns. The four-section split (semantic / values / parser terms / ecosystem) is good pedagogy for *where jargon is allowed to live*. The note that parser terms “should generally be isolated from semantic and user-facing documentation” is exactly the right policy — even if the Grammar file still leans on them (which is fine: that *is* the parser pillar).

### 3.3 Core vs Dialect for temporal + dynamics

Migrating temporal into `3-DIALECTS.md` and stating envelope-only is the correct fix for the scrubbed TIME-SPEC contradiction. Dynamics as Host dialect with Core syntax only is also right. This is one of the original suite’s biggest *felt* incoherences; 3a kills it cleanly.

### 3.4 Several load-bearing rules stated tightly

These are accurate distillations, not hand-waving:

- Bare-token boundary + **Inline-Brace Principle** (Grammar §1.2) — one of the hardest rules; stated better than most of original CORE’s scatter.
- Escape **four positions** (Grammar §1.3) — complete enough at a glance.
- Stacking + warn multi-segment ingest (Spec §2.1).
- Flag Key rule including re-owning (Spec §2.2).
- Sugar → designated attributes; `$partial-key` fail-safe (Spec §3).
- Node vs brace-form in value position (Spec §2.3 item 4) — the teachable pair, present.
- References inert; duplicate-definition menu; mixins optional Host (Spec §5).
- Keep-everything; EOF closes delimited with Warning (Grammar §4).

If the goal were a **one-sitting executive brief** of UDON for someone who will later read fixtures, this suite almost works.

### 3.5 Prose quality

Professional, scannable, low drama. No CURRENT BEHAVIOR archaeology. That alone is a gift relative to scrubbed CORE.

---

## 4. Completeness gaps (the hard review)

These are not nits. An implementer or a second agent using *only* 3a `new-spec/` would ship a language that diverges from the scrubbed behavior corpus on multiple axes.

### 4.1 Missing or nearly missing load-bearing behavior

| Topic | Why it matters | 3a status |
|-------|----------------|-----------|
| **Node value “one-way door”** | `\|api :headers \|header :k v :timeout 30` binds `timeout` to header, not api — classic footgun | **Absent** |
| **Attribute-under-attribute** | Maps need a named node carrier; deeper `:key` under attr is Error + keep shape | **Absent** |
| **Ownership priority (3 rows)** | Open attr vs element-rooted vs column — “the whole of ownership” | Partial: only sameline decompress vs block-attr tail (§3.2); no full priority table; no “collecting” |
| **Keyword alone at boundary** | `true story` is flow text, not boolean | **Absent** (booleans listed as exact keywords only) |
| **Failed number fallthrough** | `12ab` → bare token then boundary rule | **Absent** |
| **Anonymous elements as Core** | `\|[k]`, `\|.trait`, `\|?` are ordinary elements | Only mentioned via mixins |
| **Flag suffix positions / trait absorption** | `.bar?` is trait `bar?`; space-separated suffix; contiguity of identity | **Absent** beyond one desugar example |
| **Trait vs name continue-sets** | XID rules, quoted names, `/` namespacing | **Absent** |
| **List item rules** | No flow inside `[]`; `]` terminator; quoted adjacency | One clause only |
| **Comment continuation by indent** | Block comment swallows structure until dedent | **Absent** |
| **Prose interior vs structure** | Deeper than content-base is not head/structure position | Dedent algorithm present; marker-in-prose-interior not explicit |
| **Fence open/close details** | Head-only open; closer any indent; indent-before-closer is body | One sentence |
| **Inline element bracket mode** | Inside `\|{…}` only brace nesting | **Absent** |
| **Multi-line policy for delimited** | Source left most undefined; must pin or consciously defer | Envelopes “may span”; strings/arrays/identity/etc. **unspecified** (EOF assumes they can be open — incomplete) |
| **Root-level `:attr`** | Source undefined | **Unspecified** |
| **Bounded lookahead as language law** | Streamability constraint | **Absent** |
| **Markdown four layers** | Above-parse law in scrubbed MARKDOWN.md | **Absent** |
| **Round-trip / stacking≠list** | Host views collapse; data serializers need a law | **Absent** |
| **Value-position kinds completeness** | Flow empty via `;{}`; value-`\` comment disable | Partial |
| **Dynamics details** | No parens; empty `!{{}}`; `}}` first-match; filter chain; no inline control-flow | Thin |
| **Temporal edge cases** | `mo` vs `m`, week mixing, fractional-on-smallest, claim order | Minimal table only |

### 4.2 ADM inaccuracies (should fix even if keeping the short form)

**GLOSSARY:** *“ADM … consists exclusively of Elements, Attributes, and Prose Content.”*  
False relative to the scrubbed language. Comments (retained), Directives, Verbatim nodes, References as content/values, Interpolations, and multi-segment value structure are all real. “Exclusively” overclaims.

**SPEC §1:** *“The document itself is implicitly a root Element.”*  
The scrubbed model is a **forest** of top-level items (elements, directives, comments, prose), not an implicit root element. Implicit root changes Host APIs and duplicate-key scope narratives. If 3a *intends* a root Element as a greenfield ADM change, it needs a marked decision and reasoning — not a silent glide.

**Children:** Spec says children are “other Elements and Prose Content.” References as structural children, block directives, fences as content, comments in the tree — all under-modeled.

### 4.3 Grammar / terminology inconsistencies

- **“Geometric constructs”** appear at EOF (Grammar §4.2) but are **not** in the Glossary and were cited in `agents-thoughts.md` as retired jargon. Define or replace (“indent-bounded constructs”).
- **`stack_top.base_column` vs `stack_top.column`** mixed in §2.1 — original is careful about base column of the `|`. Worth one precise sentence.
- **Phase-restriction** text says “once any text or child has appeared **on a line**” — original phase change is about the **element’s content phase** (including sameline tail), not only “on a line.” A later block `:b` after sameline prose is the classic case; wording should match that.
- Spec still says **“the parser MUST…”** throughout the *semantic* pillar — fine if intentional, but it weakens the claimed firewall (semantics vs mechanics). Prefer “recognition / the ADM MUST contain…”.

### 4.4 Decisions left half-decided

Rational/complex: *“currently parsed but candidates for migration”* — that is the original’s provisional fog, not a greenfield pin. Either freeze bare or move to dialect and say so.

Unclosed identity “or a **line break**” → `$partial-key`: if multi-line identity is intended later, this freezes a behavior that Joseph flagged as temporary/undesired in spirit (single-line closures won’t last). Either adopt multi-line delimited (as 3b D1) or mark **deliberately open** with a visible flag.

No DECISIONS ledger means Joseph cannot audit what 3a *changed* vs *summarized* without re-diffing the whole original.

---

## 5. On `agents-thoughts.md` (meta)

The self-assessment is directionally right about **noise reduction** and **pillar firewall**, and wrong about **coverage parity**.

| Claim | Assessment |
|-------|------------|
| Old CORE was sprawling design diary | **Agree** |
| New achieves “same normative coverage” in a fraction of words | **Disagree** — large behavior surface missing (§4.1) |
| Improvement night-and-day on three dimensions | **Agree on structure/jargon/dialect boundary**; not on completeness or implementability |
| Tamed jargon; retired geometric / warn-and-stack / phase change from user space | **Partial** — Grammar still teaches head position, sameline decompress, pop-while, phase-restriction; “geometric” still at EOF undefined in glossary. Renaming “warn-and-stack” to multi-segment prose is good; claiming full taming oversells |
| Ready for public adoption as finished contract | **Too early** — excellent draft skeleton, not adoption-ready alone |

Suggestion: revise agents-thoughts to say *“coverage of the main conceptual spine; residual rules still in corpus/original”* — that would be accurate and still something to be proud of.

---

## 6. Feel: 3a vs original vs 3b (subjective)

| | Original scrubbed | 3a | 3b (mine) |
|--|-------------------|----|-----------|
| Voice | Lab notebook + contract | Executive brief + RFC MUST | Constitution + annexes |
| Pillars | Collapsed | Explicit 3-way | Middle-heavy; grammar deferred |
| Completeness | High (messy) | Spine only | High (drier) |
| Examples | Overloaded | Starved | Starved in CORE; a little pedagogy |
| Open rulings | Scattered callouts | Mostly invisible | DECISIONS + OPEN |
| Risk | Priming / length | **Silent incompleteness** | Length / bureaucracy / fewer examples |

**3a’s characteristic failure mode:** a confident reader thinks they understand UDON and then loses on node-value lines, ownership edge cases, or comment geometry.

**3a’s characteristic success mode:** a new collaborator gets the right mental model (ADM, sugar, core/dialect, stacking, keep-everything) in thirty minutes without inhaling scan mythology.

Both failure and success are real. For Joseph’s greenfield goal (“user-facing behavior held; everything else free”), 3a optimized **organization and compression** harder than **behavior fidelity**. That is a coherent choice if labeled as Phase-1 architecture; it is a problem if labeled as finished normative coverage.

---

## 7. Concrete recommendations (priority order)

1. **Fix ADM claims** (no exclusive three-part ADM; no silent implicit root — or mark root as greenfield decision).
2. **Add a “Residual rules” or DECISIONS+OPEN** page listing what was deferred vs pinned, so incompleteness is honest.
3. **Patch the highest-cost missing behaviors** into Grammar or Spec (short form is fine):
   - one-way door for node values  
   - attribute-under-attribute  
   - full ownership priority  
   - keyword/boundary typing  
   - anonymous elements  
   - flag-suffix / trait absorption  
   - multi-line delimited policy (pin or explicit open)
4. **Define geometric vs delimited** in the Glossary if EOF keeps the words.
5. **Either expand examples in Spec or point at `snippets/`** as normative-adjacent conformance fuel — with a sentence that fixtures are not optional for implementers.
6. Soften agents-thoughts coverage claim after the above (or after explicitly accepting “spine only”).
7. Optional: one page on Markdown layers and one on semantic equivalence (stacking ≠ list) — both punch above their weight for Host authors.

---

## 8. What I would take from 3a into a later 3b pass

(Personal commit for when I read their feedback on 3b and revise.)

- **Tighter top-level map:** 3a’s four-file landing is easier to hand someone than 3b’s wider suite. A single `new-spec/README` “read in this order” is not enough if CORE still feels like the only door.
- **Grammar as a real pillar:** I deferred it; 3a proved a 115-line Grammar can carry nest rule + bare-token + escape + EOF without swallowing the Spec. Worth a short `new-spec/GRAMMAR.md` even if non-normative-for-now.
- **Compression courage on non-load-bearing prose:** 3a’s Spec §3 sugar section is a model of density without loss of the main idea.
- **Glossary policy sentence** about parser terms not belonging in user docs — steal verbatim in spirit.

---

## 9. Bottom line

**3a is a high-quality architectural compression of UDON’s spine**, aligned with the three-pillar brief, with correct instincts on ADM-first, sugar-as-attributes, core/dialect, and anomaly posture. It is **not** yet a substitute for the scrubbed CORE on user-facing edge behavior, and it should not be described as same-coverage-shorter.

Treat it as an excellent **Phase-1 constitution outline** that needs a Phase-2 “burn down the corpus against the outline” pass — or as a front door document that **must** point to a thicker contract (or to the snippet corpus with explicit “behavior lives there until specified”).

Happy to be wrong on any specific “absent” item if it lives under wording I missed; the probes were `new-spec/` only.
