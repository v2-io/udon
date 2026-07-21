# Feedback on greenfield-2a (from greenfield-3b / Grok)

**Auditor context:** Parallel clean-room rewrite in `../greenfield-3b/`; also
reviewed revised `../greenfield-3a/`. This is an independent read of
`new-spec/` against scrubbed `spec/` + snippets, and against what a
middle-pillar contract needs. Peer review, not a score.

---

## 1. Bottom line

**This is the strongest of the three greenfield suites I have seen as a
*language contract package*.**

Not because it is shortest (it is not) or longest (3b’s suite is wider), but
because the **pillar split is real, the ADM is load-bearing, open questions
are honest, and the SPEC covers the hard recognition edges without becoming a
parser diary**. If Joseph wanted one directory to treat as “the contender for
what CORE should grow into,” I would start the comparison here — then borrow
selected moves from 3a (scannable grammar front door) and 3b (traces /
explicit multi-line pin if desired).

| Dimension | 2a |
|-----------|----|
| Role | Official Spec pillar, properly decomposed |
| Normative core | SPEC (~1000 lines) + ADM + GLOSSARY + OPEN-QUESTIONS |
| Non-normative | RATIONALE, PEDAGOGY sketch |
| Completeness of Core edges | High |
| Overclaim risk | Low (open items numbered; companions deferred honestly) |
| Main residual | No rewritten dialect companions; no fixture suite yet; multi-line left open |

---

## 2. What is excellent (steal-worthy)

### 2.1 Document architecture

The README’s map matches defining-udon without collapsing pillars:

| File | Job |
|------|-----|
| SPEC | Contract |
| ADM | What “means” is |
| GLOSSARY | One name per concept + retired table |
| OPEN-QUESTIONS | Deliberate undefineds with *decision space* |
| RATIONALE | Why (out of the critical path) |
| PEDAGOGY | How to teach (sketch, labeled as such) |

This is cleaner than 3b’s wider sprawl and denser than 3a’s four-file
compression. **OPEN-QUESTIONS is especially good:** each Q has a decision
space *and* a marked drafter recommendation, without pretending the
recommendation is a ruling. That is more honest than either “silently pin” or
“undefined forever with no menu.”

### 2.2 The ADM “text law”

ADM §4 is the best single model idea in any of the greenfields:

> text reconstructs by pure in-order concatenation of Text; terminators are
> text; dedentation is geometry; ornamental blanks are not content.

That forces whitespace policy into one place and makes “model holes”
detectable. 3b’s SEMANTICS circles nearby; 2a states it as **model law**. I
would adopt this language.

Also strong:

- Document as `{ content, anomalies, result }` with `incomplete-input`
- Stacking as model fact (`:x 1 :x 2` ≠ `:x [1 2]`)
- Sugar identity in the model (handwritten `$key` ≡ sugar)
- Comments/Verbatim/Directive/Interpolation/Reference as first-class Nodes
- Views explicitly non-normative over a normative substrate

Forest of top-level nodes (no phantom root): correct.

### 2.3 Glossary quality

Best terminology product of the three, for my money:

- **Open position** (retires “head position”) — good rename
- **Boundary decision**, **commit (to text)**, **the scan**
- **Flow** / **flow value** distinguished (3a still collapses these)
- **Warned extension** (retires warn-and-stack / segment-ingest)
- **Designated attribute**, **flag suffix**, **geometric/delimited extent**
- **Retired terms table** with targets
- Cross-refs to owning sections

Sectioning (Structure / Lines / Text / Values / Extents / Anomalies /
Consumers) is scannable without being incomplete. This is the hybrid I
wished for when reviewing 3a’s glossary.

### 2.4 SPEC recognition coverage

§3–§5 actually carry the value-acquisition machine:

- Guards + Markdown table safety
- Bare-token boundary + inline-form principle + failed `12ab` + keywords
- Ownership table (collecting vs element tail) — the asymmetry stated cleanly
- Node one-way door (as consequence of scan, restated for authors)
- Attr-under-attr + Q2
- Phase gate / late `:`
- Flag re-owning
- Deferred values, value-position `\`, contexts/terminators
- Escape four positions including `\`-anchored content base
- Comments: framed sameline, continuation swallows structure, content-base strip
- Verbatim family, fence close rules
- Dynamics syntax only; envelope; frozen bare set; keep-everything; EOF

This is not a spine pretending to be complete. It is a real contract.

### 2.5 RATIONALE and PEDAGOGY

RATIONALE is the right density: positional `\`, commit model, whose-name-is-it,
stacking, frozen bare set, keep-everything, geometric/delimited, inline-form
principle, text law, designated-not-reserved, bounded lookahead. Someone
weighing a language change can read it in one sitting.

PEDAGOGY’s disclosure ladder and “idiom over allowance” table are exactly
what defining-udon asked for. Correctly labeled a sketch, not a fake manual.

### 2.6 Judgment on hard open items

Q6 (rational/complex → dialect), Q8 (nuanced multi-line: strings/lists/interp
yes; identity maybe line-bound), Q11 (no string escapes / other-quote /
doubling collision with list items) show real design taste. Q8 is *more
careful* than 3b’s blanket D1; I still lean multi-line for identity later, but
the recommendation is defensible and documented.

---

## 3. Gaps and nits (priority order)

### 3.1 Companion dialects not rewritten

SPEC annex points at DYNAMICS / TEMPORAL / MARKDOWN companions without
shipping clean-room versions under `new-spec/`. Core is fine alone; the
*suite* still inherits scrubbed TIME-SPEC’s known contradiction unless
readers obey the “envelope only” note in SPEC §10.1.

**Suggestion:** either a thin `new-spec/dialects/` (even shorter than 3a’s)
or an explicit “companions still scrub inputs; envelope rule in SPEC wins.”

### 3.2 Conformance fixtures cited, not present

§1.1: *passing the fixture suite is the definition of compliance*. Right
principle (defining-udon / CommonMark). No suite lives here yet. Until it
does, that sentence is aspirational. Point at `../snippets/` as provisional
fuel, or say “suite TBD for this draft version.”

### 3.3 Tab-in-indentation = line lost

SPEC §3.1: tab in indentation is an error and **the line is lost**. Scrubbed
CORE / 3b lean keep-everything best-effort. If intentional hardening, put it
in OPEN or RATIONALE; if not, soften to “error + best-effort keep.” This is
one of the few places 2a is *stricter* than keep-everything rhetoric.

### 3.4 Multi-line left open (Q8) vs greenfield freedom

Leaving Q8 open is coherent for a careful contract. Joseph’s greenfield note
was that single-line-only will not last. The drafter recommendation already
leans multi-line for most forms — good. Risk: implementers treat “undefined”
as “do whatever we do today.” Consider: *recommended default in prose* as
SHOULD multi-line for strings/lists pending fixture verification, still open
for identity.

### 3.5 Root attribute (Q1) still undefined

Recommendation (text + warning) is sensible; 3a/3b pinned Error + keep.
Undefined is fine if OPEN is canonical; just know three greenfields will
disagree until Joseph rules.

### 3.6 No explicit “pop while” implementer formula

Column rules in §3.1 are correct and contract-appropriate. Parser authors
often search for `pop while new_column <= base_column`. Optional non-normative
note (as 3b GRAMMAR) would help without polluting SPEC.

### 3.7 Dynamics / temporal depth

Syntax-only dynamics is right for Core. Expression grammar, truthiness,
filters live only by pointer. Acceptable if companions are next; incomplete
as a total clean-room deliverable of *all* scrubbed input.

### 3.8 Small consistency / polish

- Envelope listed inside “bare scalar set” in GLOSSARY (“string, integer, …
  list, envelope”) while SPEC says bare is frozen and envelope is the
  dialect boundary — **envelope is recognized bare but is not a “scalar type”
  in the same sense**. Worth a glossary tweak: “bare *value forms*” vs
  “frozen core scalars.”
- Mixin experiment mentioned only via RATIONALE/OPEN Q10 — fine; ensure SPEC
  doesn’t need a one-liner “hosts MAY.”
- PEDAGOGY still thin by design — no issue if the next pass grows levels 1–3
  with one running example.
- No DECISIONS.md for *closed* greenfield pins separate from OPEN — README
  lists moves; enough. Optional: promote “what we changed vs source” into a
  short CHANGELOG-style file for Joseph’s audit speed.

### 3.9 What I did *not* find as problems

I did not find silent loss of:

- one-way door, ownership rows, phase gate, partial-key, stacking≠list,
  flag rules, inline-form principle, geometric/delimited EOF, incomplete
  input, designated attributes, anonymous elements, XID names, fence
  rules, comment continuation.

Those were 3a’s early holes; 2a had them from the start (or enough density
that they are present in SPEC).

---

## 4. Comparison to 3a and 3b

| | 2a | 3a (revised) | 3b |
|--|----|--------------|-----|
| Architecture | Spec + ADM + Glossary + Open + Rationale + Pedagogy | Grammar + Spec + Dialects + Decisions | Wider suite + GRAMMAR companion + traces |
| Completeness | **High** | High after revision, still compressed | High |
| Scannability | Medium (1000-line SPEC) | **Best** | Medium |
| Openness hygiene | **Best** (Q1–Q11) | Decisions pins | Decisions + OPEN |
| ADM depth | **Best** (text law) | Good forest fix | Algebraic + SEMANTICS |
| Glossary | **Best** | Good policy, thinner inventory | Strong inventory |
| Dialects shipped | Pointers only | Temporal + dynamics present | Temporal + dynamics present |
| Pedagogy | Strong outline | Minimal | Tour + recognition traces |
| Multi-line | Open (Q8, nuanced rec) | Pinned all multi-line | Pinned all multi-line (D1) |
| Risk | Companion lag; fixture claim | Glossary lag; length tax paid as thinness | Length; bureaucracy |

**2a wins as the constitution.**  
**3a wins as the briefing.**  
**3b wins as the lab notebook + flight manual (traces) + explicit pins.**

A merged endgame might look like: 2a’s SPEC/ADM/GLOSSARY/OPEN/RATIONALE
skeleton, 3a-style GRAMMAR extract, 3b-style recognition traces + dialect
files, Joseph rulings on Q1/Q8/Q11.

---

## 5. Voice and anti-priming

Mission accomplished on the main greenfield goal:

- Almost no “the parser pops the stack” as the definition of meaning
- Stack/HOLD/event wire absent from the contract (README explicit)
- MUST/SHOULD/MAY used as real requirement language
- Rationale extracted so implementers can skip it

Remaining parser-adjacent nouns (**the scan**, **open position**,
**collecting**) are *language* nouns now, defined in the glossary — that is
the right residual, not a failure.

---

## 6. Concrete recommendations

1. **Ship or stub dialects** under `new-spec/` so TIME-SPEC contradiction
   cannot ambush readers.
2. **Qualify §1.1 fixture claim** until a suite exists; or start one from
   ownership / node-door / phase / EOF cases.
3. **Reconcile tab-in-indent** with keep-everything (or mark as deliberate
   exception in RATIONALE).
4. **Glossary:** fix envelope vs bare-scalar wording.
5. Optional: one-page **GRAMMAR.md** implementer extract (nest rule formula,
   boundary, escape, EOF) — non-normative, SPEC wins.
6. Optional: promote Q8 recommendation to SHOULD multi-line for strings/lists
   without closing identity yet.
7. Grow PEDAGOGY level 1–3 with one running example when time allows — the
   outline is already right.

---

## 7. Opinion (subjective)

Reading 2a feels like meeting a **finished engineer who already did the
reorganization you were about to recommend**. It is drier than scrubbed CORE
in the right way, warmer than pure RFC in the right places (ownership
examples, one-way-door restatement), and epistemically cleaner than both 3a’s
early overclaim and 3b’s temptation to pin everything.

If I had to assign roles for Joseph’s later synthesis:

- **2a = primary draft of the Official Specification pillar**
- **3b OPEN/DECISIONS + traces = stress-test and pin debate**
- **3a = packaging lesson (read order, grammar door, compression courage)**

I would not restart from 3a or 3b and try to grow into 2a’s quality of ADM +
OPEN hygiene; I would start from 2a and graft.

---

## 8. Confidence

High on architecture and SPEC coverage judgments (SPEC read end-to-end;
ADM/GLOSSARY/OPEN/RATIONALE/PEDAGOGY full).  
Medium on “best of three” as a global ranking — different optimizers; 2a
wins the *contract* contest specifically.  
Did not re-diff every corpus snippet against 2a line-by-line; coverage
judgment is structural, not a full T01–T28 trace audit against this SPEC.
Doing that trace pass against 2a would be the highest-value follow-up if you
want implementation-level certainty.
