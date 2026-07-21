# Bigger picture — after clean-room unsequester (2026-07-20)

Written after reading front doors, all active `TODO-*` lanes, unscrubbed
`spec/CORE.md`, the descent grammar units, fixtures layout, and the greenfield
suites (2a / 3a / 3b) + peer feedback. Purpose: one map of **where the project
is**, **what the real bottleneck is**, and **how the clean-rooms plug into the
live stack** — without re-litigating language taste Joseph already holds.

---

## 1. What the system *is* (stable architecture)

```text
                    ┌─────────────────────────────┐
                    │  AUTHORITY: spec/CORE.md    │
                    │  (+ companions, CHANGELOG)  │
                    │  semver: CORE-VERSION       │
                    └─────────────┬───────────────┘
                                  │ compliance measured by
                                  ▼
                    ┌─────────────────────────────┐
                    │  fixtures/v0.9/ (active)    │
                    │  fixtures/v0.8/ (frozen tag)│
                    └─────────────┬───────────────┘
                                  │
          ┌───────────────────────┼───────────────────────┐
          ▼                       ▼                       ▼
   generator/*.descent.udon   tools/descent          (future pedagogy
   ~2.3k lines live grammar   (submodule generator)    / cheat-sheets)
          │                       │
          └───────────┬───────────┘
                      ▼
              generated parser.rs
              event stream (wire)
                      │
          ┌───────────┴───────────┐
          ▼                       ▼
     AST / stream-AST         UX / utils / agents
     (TODO-PARSER)            (lanes below)
```

**Propagation rule (README, load-bearing):**  
`spec → event-parser → AST → aux · utils · UX → publishing`  
You cannot honestly work a lower layer without the one above.

**Compliance rule:** an implementation is “core-vX compliant” iff it passes
that version’s fixture group — not because a TODO says so.

**Area lanes (open-only TODOs, ~1.6k lines open work tracked):**

| Lane | Job | Health vs authority |
|------|-----|---------------------|
| META | versioning, org, literate-fusion aspiration | Names the *real* problem (contract vs pedagogy vs derivation) |
| SPEC-CORE | CORE.md edits | Has P0 history (text-wire landed); backlog is landings + org |
| SPEC-OTHER | dialects, markdown, temporal, callouts | Thin; temporal recast still open |
| TEXT-WIRE | newline-carrying Text | **LANDED** 2026-07-19 (design of record) |
| CORE-PARSING | grammar + event parser | Green on alpha.2 group; **paused** on wire |
| PARSER | AST / streaming AST | Substrate landed; keep-everything at AST still broken |
| DESCENT | generator capabilities | HOLD/RELEASE, EOF gen landed; more wanted |
| UX / UTILS / PUBLISHING | outer rings | Explicitly wait on core ^0.9 |

---

## 2. Where things stand *right now* (the pivot)

As of 2026-07-19 PM (DIRECTION-2026-07-19.md + README caveat):

| Fact | Meaning |
|------|---------|
| Parser **green** on `fixtures/v0.9/` (both backends) | Implementation state is strong for alpha.2 semantics *as encoded* |
| **Text-wire recast LANDED** | Pure concat reconstruction of text — same invariant greenfields call “text law” |
| **EOF recast LANDED** | Positional vs delimited; descent generates most unwind |
| Flat attribute-value **wire DERATIFIED** | Cannot separate value extent from content; needs value-bracket (`AttrStart`/`AttrEnd` direction) |
| **`core-v0.9.0` tag path ON HOLD** | README queue (`*{` grammar → S-batch → mining → tag) is stale as *plan* |
| **Clean-rooms running** | Methodology to get a parser-agnostic contract + event model without recursive descent priming |
| One grammar red left (`;{`-in-blob) | Folded into `*{` rewrite — **blocked on wire reconception** for honest encoding |

**Critical insight for Joseph’s framing:**  
You are not short on *language opinions*. You are short on a **clean forum** where:

1. the **contract** can be stated without “the parser does…”,  
2. the **wire** can be redesigned without smuggling value extent into absences,  
3. the **grammar** can be rewritten to a contract rather than to itself,  
4. **pedagogy / fixtures / descent names** can radiate from authority without six hand-synced documents.

META already states this as “contract vs pedagogy” + density gradient + literate fusion. The clean-rooms are the *method* chosen to break the coupling; the deratified wire is the *crisis* that forced the method now rather than later.

---

## 3. The artifact stack problem (META, restated)

Joseph’s density gradient (META):

```text
cheat-sheets < learning-examples < learning-version < fixtures < spec < grammar
```

Authority radiates **from spec outward**, not from densest outward. Today:

| Artifact | Role in practice | Problem |
|----------|------------------|---------|
| CORE.md (~large, mixed pillars) | Authority + tutorial + warnings registry + (deratified) wire notes | Cannot optimize contract and tutorial at once; “the parser” voice; lagging jargon dual-names |
| generator/*.descent.udon (~2.3k + legacy 1.9k) | Actual recognition machine | Implements 0.9 model + flat wire idioms (`Attr` re-emit = multiplicity; NODE/BLOB return codes); vocabulary freeform/embedded/blob; rational/complex still typed bare; poisoned for clean-room on purpose |
| fixtures/v0.9 | Compliance measurement | Excellent; but harness historically *masked* wire bugs (text-wire story); still need incomplete-input as non-event assertion |
| CHANGELOG rulings | Truth ledger for 0.9 | Strong; do not re-open |
| design/ | Ahead-of-spec | Partly superseded; status banners |
| greenfield-* | Untainted re-derivation | **Forum for contract (and 2-series: events)** |

The grammar files are not “wrong code” — they are a **high-fidelity encoding of a transitional model** (flat wire, 0.9 attribute scan, provisional names). Reading them as language authority is the poison: they teach return-code protocols and emit rhythms as if those were UDON.

---

## 4. What the clean-rooms produced (for this map)

| Suite | Primary product | Best use in synthesis |
|-------|-----------------|------------------------|
| **2a (Fable)** | SPEC + ADM + GLOSSARY + OPEN + RATIONALE | **Primary contract skeleton**; OPEN-QUESTIONS as ruling forum |
| **3b (Grok)** | CORE suite + SEMANTICS + DECISIONS + traces + dialects | **SEMANTICS / round-trip law**; auditability; recognition traces; dialect recasts |
| **3a (Gemini)** | Compressed Grammar/Spec/Dialects | **Front-door packaging** and scannability lesson |
| **2-series / greenfield (earlier)** | Event-model derivation | **Value-bracket wire** half (reconcile with brownfield wire note) |

**Spine consensus (language):** enough for Joseph to adjudicate; not the bottleneck.  
**Forum consensus (structure):** forming — SPEC/ADM/GLOSSARY/OPEN/SEMANTICS + optional GRAMMAR extract + dialects as companions is the obvious merge shape.  
**Still open forks (for Joseph, not peer ranking):** multi-line per construct (Q8/D1), string escapes (Q11/O15), root-attr severity (mostly dissolved), packaging of dialects/wire.

Fable’s anchoring disclosure applies: treat peer rankings as complementary strengths; treat failure-mode arguments as arguments.

---

## 5. The live CORE vs greenfield gap (high signal)

| Theme | Live CORE / stack | Clean-room pressure |
|-------|-------------------|---------------------|
| Wire | Deratified flat Attr; value extent implicit | Explicit value bracket (2-series); ADM without wire (3-series) |
| Text reconstruction | **Landed** (TODO-TEXT-WIRE) | Same invariant as “text law” — rare pre-agreement |
| Vocabulary | Mixed; grammar-lags-spec synonyms | Consolidated glossaries (2a/3b strongest) |
| Pillars | Collapsed in CORE | Split (to varying degrees) |
| Multi-line | Line-boundedness deliberately undefined for many | Split recommendations (selective vs blanket) |
| Rational/complex | Still in grammar types | Out of bare set in greenfields |
| Temporal | Envelope in CORE; TIME-SPEC stale; bare carved from grammar | dialects/temporal@1 |
| `*{` semantics | Ruled in CORE; grammar rewrite **paused** | Affirmed as language law |
| Keep-everything | Event layer yes; AST still drops tree on error | Contract clear; AST is a lower-layer bug |
| Pedagogy | Inside CORE + design/examples | Separate sketches (2a/3b) |

**Implication:** the next productive work is not “make the parser match greenfield day one.” It is:

1. **Ratify a contract forum** (merge greenfield structure into how SPEC lives).  
2. **Ratify wire** (value bracket) from 2-series + brownfield analysis.  
3. **Only then** rewrite descent units against contract+wire (not against old wire).  
4. **Radiate** fixtures / pedagogy / warning names from the contract.

Doing (3) before (1)–(2) is how you get another generation of grammar that cannot be unpoisoned.

---

## 6. Grammar / descent — what “poor shape” means

Not “unreadable spaghetti” only — **semantic debt**:

- **Type/event names:** Freeform, Embedded, blob return codes, Rational/Complex bare types.  
- **Protocol complexity:** FIN/OPEN/NODE/BLOB/REOWNED/… because functions cannot share caller locals; attributes are a multi-function scan protocol.  
- **Flat-wire assumptions:** segment stacking = re-emit Attr; node value = Attr + ElementStart without bracket.  
- **Dual backends** (recursive + pushdown) increase the cost of every protocol change.  
- **Descent itself** is improving (EOF generation, HOLD/RELEASE, Unclosed derivation) but still missing line-discipline, entry-site spans on warnings, etc.

The greenfields correctly **omit** this layer. The brownfield correctly **pauses** grammar encoding on the deratified wire. That pause should stay until wire+contract ratify.

---

## 7. A bigger-picture “forum” proposal (for keeping things clean)

Name the products so work has a home (names negotiable):

| Product | Contents | Source of truth for |
|---------|----------|---------------------|
| **A. Language contract** | SPEC (2a-shaped) + ADM (text law) + GLOSSARY + SEMANTICS (3b) | What documents mean; anomalies; equivalence |
| **B. Open rulings** | OPEN-QUESTIONS / DECISIONS (2a hygiene + 3b impact tags) | What is undefined vs pinned; Joseph’s queue |
| **C. Wire contract** | Separate doc (value-bracket events) — *not* mixed into A | Event stream for fixtures & generators |
| **D. Grammar** | descent units rewritten *to A+C* | Recognition encoding only |
| **E. Compliance** | fixtures per CORE-VERSION | Measured compliance |
| **F. Pedagogy** | progressive disclosure (2a outline + 3b traces) | Humans / agents learning — non-normative |

**Hard rules for the forum:**

1. **A never cites D** for meaning. D may cite A.  
2. **C is not A.** Value brackets are wire; stacking≠list is A/SEMANTICS.  
3. **B is the only place pins and undefineds change** after a ruling session — not drive-by CORE edits mid-grammar.  
4. **E asserts only what A+C promise** — harness must not re-consult source for text (already fixed for newlines; keep that discipline).  
5. **F is allowed to be wrong about idiom; never about A.**

This is META’s “separable spine” + literate-fusion *direction*, without requiring full fusion on day one.

### Sequencing (recommended)

```text
Now          1. Joseph ruling table on open forks (Q8 rows, Q11, packaging)
             2. Synthesize A from 2a spine + 3b SEMANTICS/glossary graft + callouts
             3. Ratify C (value bracket) from greenfield-2* EVENTS + brownfield wire note

Then         4. Backport A into live spec tree (or replace CORE gradually)
             5. Rewrite descent units to A+C; burn fixtures green
             6. Unpause *{ grammar encoding; land remaining SPEC-CORE text

Later        7. Literate fusion pilot (one construct)
             8. Pedagogy projections derived, not hand-forked
             9. core-v0.9.0 tag when A+C+E agree
```

**Do not:** resume the pre-pivot “queue to tag” as if the wire still stood.  
**Do not:** implement blob/`*{` grammar on flat wire “just to clear the red.”

---

## 8. Where each TODO lane sits after the pivot

| Lane | Still valid? | Notes |
|------|--------------|-------|
| TODO-TEXT-WIRE | Done / residual polish | Text law already in greenfield ADM |
| TODO-CORE-PARSING | Pause marker is correct | Wire wait; list still has real bugs (`|{`-led prose swallow) for after rewrite |
| TODO-SPEC-CORE | Split | P0 text-wire landing partly obsolete; `*{` *text* still to land; wire section needs replacement not repair |
| TODO-SPEC-OTHER | Active | Temporal dialect, markdown layers, callout sweep, composite types — aligns with greenfield dialects |
| TODO-META | **Central** | Spec org + literate fusion is the strategic thread; greenfields are empirical input to (3) structural pass |
| TODO-PARSER | After wire | AST keep-everything / warnings collection still real |
| TODO-DESCENT | Parallelizable | LINE construct, Unclosed derivation, entry-site — helps next grammar gen |
| UX / UTILS | Wait | Correctly gated on core ^0.9 |

---

## 9. One-page “what success looks like”

You have a clean forum when:

1. A cold implementer can implement recognition from **A** without reading descent.  
2. A fixture author asserts **E** without source-gap folds for text.  
3. A grammar change is justified by **A or C**, never by “the other backend expected this return code.”  
4. Joseph’s rulings land only in **B**, then A/C update, then D/E follow.  
5. Pedagogy (**F**) can be rewritten without touching A’s normative sentences.

The greenfields proved (1) is possible. The text-wire landing proved (2) for newlines. The wire deratification proved (3) was being violated. The open work is institutionalizing that discipline across the umbrella.

---

## 10. Immediate helpful moves (if Joseph wants hands on next)

1. **Ruling table session** — Q8 per-construct, Q11, root-attr, callout vocabulary rollout (SPEC-OTHER already piloted).  
2. **Contract synthesis draft** — not another clean-room; a merge of 2a+3b into `spec/` or `spec/msc/contract-v0/` with B tracking deltas from live CORE.  
3. **Wire ratify** — short normative EVENTS.md from 2-series + brownfield, explicit Attr value brackets.  
4. **META update** — point the “structural pass / separable spine” item at greenfield results as the grounded assessment (META asked for this).  
5. Leave descent alone until 2–3 exist.

---

## Sources touched for this map

- `README.md` (Status + How the work is organized)  
- `TODO-META.md`, `spec/TODO-SPEC-CORE.md`, `TODO-TEXT-WIRE.md`, `core/TODO-CORE-PARSING.md`, `core/TODO-PARSER.md`, `spec/TODO-SPEC-OTHER.md`, `tools/descent/TODO-DESCENT.md`  
- `spec/msc/brownfield/DIRECTION-2026-07-19.md`  
- `spec/CORE.md` (structure, deratified wire, version)  
- `core/generator/*.descent.udon` (sample + sizes)  
- `core/AGENTS.md`, greenfield 2a/3a/3b suites + peer feedback  

*Not a full line-by-line audit of every grammar state or every CHANGELOG ruling — structural picture, not a compliance score.*
