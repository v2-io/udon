# Ruling table — v2-spec charter

**Purpose:** One sitting for Joseph. Every row is either **already ruled** (must not re-open as open philosophy), **open** (needs a mark), or **packaging** (how the new suite lives). After rulings, this file is the non-negotiable input to fresh authoring — not a merge negotiation into live CORE.

| | |
|--|--|
| **Draft** | grok (greenfield-3b), 2026-07-20 |
| **Stress-check** | Fable (greenfield-2a) — integrated from `RULING-TABLE-delta-fable.md` |
| **Genre** | DECISIONS-ledger craft — status, impact, options, costs |

**How to rule:** fill the **Ruling** column (`A` / `B` / `C` / custom / `defer to …`). Optional: initials + date. Rows marked `ALREADY RULED` need only confirm “carry as-cited” unless you explicitly overturn.

---

## Legend

| Tag | Meaning |
|-----|---------|
| **[BEHAVIOR]** | Changes or pins user-visible document meaning |
| **[WIRE]** | Event stream / fixture harness — not surface UDON spelling |
| **[ORG]** | Suite packaging, versioning, process |
| **Status: ALREADY RULED** | In CHANGELOG / TODO-SPEC-CORE; seed DECISIONS by citation |
| **Status: OPEN** | Needs a mark this sitting (or explicit defer with venue) |
| **Status: CHARTER** | Process decision for v2 authoring itself |

**Impact** = what breaks or unblocks if the ruling goes the other way.

**Ruling**: All current rulings are *subject to revision* as tactical, strategic, technical, and organizational realities emerge. The rulings serve the project; the project does not serve the rulings.

**NOTE** *(7/20 rulings are pre-pipeline discussion, which may reformulate the ruling table in many ways - jaw)*

---

## 0. Charter (process for v2)

| ID  | Topic                                                     | Tag         | Status  | Options                                                                                                                                                        | Impact / costs                                                                                                     | Drafter lean (not a ruling)                                                       | **Ruling**                                                                                          |
| --- | --------------------------------------------------------- | ----------- | ------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------- |
| C0  | Greenfield replacement vs brownfield merge into live CORE | [ORG]       | CHARTER | **A** archive old suite, author fresh · **B** backport clean rooms into live CORE over weeks                                                                   | A: discard accretion debt; import rulings/silences. B: re-buy accretion; zero external consumers.                  | **A** (agreed Joseph/Fable/grok)                                                  | A<br>jaw 7/20                                                                                       |
| C1  | Clean-room pure re-derivation vs seeded authoring         | [ORG]       | CHARTER | **A** pure clean room again · **B** max context; CHANGELOG + this table non-negotiable; freshness only on wording/org                                          | A re-fights July. B is the post-instrument phase.                                                                  | **B**                                                                             | B<br>jaw 7/20                                                                                       |
| C2  | New version line                                          | [ORG]       | OPEN    | **A** `0.10.0` (alpha.2 history kept; 0.9.x = transitional) · **B** clean `0.9.0` re-foundation · **C** other                                                  | A: `core-v0.8.0` frozen gate remains honest; alpha.2 rulings stay under their ledger version. B: renumbering risk. | **A** (Fable lean; grok agrees)                                                   | A -- (0.10.0)<br>jaw 7/20                                                                           |
| C3  | Suite file set for fresh authoring                        | [ORG]       | OPEN    | **A** SPEC + ADM + GLOSSARY + WIRE + SEMANTICS + DECISIONS + OPEN (+ optional GRAMMAR extract, pedagogy) · **B** fewer · **C** more (dialects in-tree day one) | A = three-contract architecture.                                                                                   | **A**; dialects may be thin stubs day one                                         | A -- with tactical deference to authors<br>jaw 7/20                                                 |
| C4  | Old parser during rewrite                                 | [ORG]       | OPEN    | **A** keep runnable as differential oracle vs new fixtures · **B** freeze immediately · **C** delete ASAP                                                      | A: cheapest audit of intentional disagreements. Not authority.                                                     | **A** until new gate green                                                        | A -- with care not to intermingle<br>jaw 7/20                                                       |
| C5  | Fixture assertion surface                                 | [WIRE][ORG] | OPEN    | **A** assert fold-recovered ADM slice + anomalies + incomplete-input result · **B** raw event lists only · **C** both (events + fold ADM)                      | A: law-testable; blocks harness compensator class. B: “stream looks right” disease. C: heavier, gold.              | **C** if affordable else **A**                                                    | C -- with distinction between idiomatic, comprehensive, and descriptive (non-normative)<br>jaw 7/20 |
| C6  | Incomplete-input in fixtures                              | [WIRE]      | OPEN    | **A** `result: incomplete` (or equiv) on cases · **B** AST/driver-only test · **C** defer                                                                      | META gap: interior-newline close vs EOF open look identical on raw wire.                                           | Initially **A** with C5<br><br>See [[pipeline-discussion]] for ongoing discussion |                                                                                                     |

---

## 1. Already ruled — carry into DECISIONS by citation (do not re-open as open)

Confirm **carry** or mark **overturn** (rare; needs explicit reason).

| ID | Topic | Tag | Source (cite) | One-line content | Why it matters for v2 | **Ruling** |
|----|-------|-----|---------------|------------------|----------------------|------------|
| R1 | Text reconstruction / text-wire | [BEHAVIOR][WIRE] | CHANGELOG 2026-07-19 TEXT-WIRE; TODO-TEXT-WIRE | Full stream → text by pure concat; BlankLine ≡ `"\n"`; freeform blanks are Text; annotation-terminator rules | **Generalizes to ADM-sufficiency law for whole wire** | carry / overturn: |
| R2 | EOF geometric vs delimited + two-level severity | [BEHAVIOR] | CHANGELOG 2026-07-17/18; CORE End of input | Geometric silent at EOF; delimited unclosed → warn + keep; incomplete-input at true EOF | Wire + language | |
| R3 | Line-boundedness 0.9 | [BEHAVIOR] | CHANGELOG + TODO-SPEC-CORE “0.9 RESOLVED” | Remaining delimited multi-line **undefined, warn-before-disallow**; design proper = **0.10 with paths/dialects** | **Deferred because emergent-span:** an inner spanning construct defeats a line-bound container. Greenfield D1 → **ruled-deferred**, not open philosophy | |
| R4 | `*{` / inline-brace principle | [BEHAVIOR] | CHANGELOG 2026-07-19 densification | No inline brace is a boundary marker; commits flow; block `\|name` = node value | Encoding-independent; grammar rewrite paused for wire | |
| R5 | `$partial-key` / UnclosedIdentityKey | [BEHAVIOR] | CHANGELOG densification / identity HOLD-RELEASE | Unclosed identity → `$partial-key` not `$key` + warn | Fail-safe; interacts with R3 | |
| R6 | Flag keys, missing plain value → Nil+error, stacking; **attr-under-attr = Error (status only)** | [BEHAVIOR] | CHANGELOG attribute-model 2026-07-15/16 (alpha.1) | 0.9 attribute substrate. **Kept shape of attr-under-attr is NOT in this row** — see L6 | Seed DECISIONS | |
| R7 | Temporal not bare | [BEHAVIOR] | CORE + grammar carve-out | Bare dates are strings; temporal → envelope / dialect | TIME-SPEC recast still open as *text* | |
| R8 | Flat Attr wire **deratified** | [WIRE] | CHANGELOG + CORE banner 2026-07-19 | Value extent must not be inference-only | Forces WIRE.md + AttrValue bracket | |
| R9 | S-batch silences (S1–S6, C2, final-terminator disposition) | [BEHAVIOR] | CHANGELOG 2026-07-19 second batch | Includes: suffix stacking; empty `\|{}`; interp-as-key; **S6 two-layer blank/ws model** (see R15); ornamentation / final-terminator | Land as DECISIONS cites; wording in new SPEC | |
| R11 | Keep-everything recognition | [BEHAVIOR] | CORE anomaly posture + text-wire | Content kept with warnings where coherent; consumer halt/reject is menu | Severity *definition* open as L0 | |
| R12 | Unclosed emission order | [WIRE] | CHANGELOG 2026-07-18 | content → `Unclosed*` → `End`, uniform | WIRE must preserve or supersede under new brackets; fixtures assume order | |
| R13 | Micro-rulings batch (cite list) | [BEHAVIOR][WIRE] | CHANGELOG 2026-07-18 | `UnclosedInlineDirective` / `UnclosedInlineRaw`; nameless `!{`<EOF> → prose `Text "!{"`; *EOF ≡ eol + full-dedent* for remaining EOF edges (divergence = red-find); empty forced-text `:a \` ≡ empty-string value, no warning; `<>` interim BareValue + NoDialectsLoaded | Seed DECISIONS / WIRE inheritance | |
| R14 | Duplicate-definition menu | [BEHAVIOR] | CORE References; greenfield convergence | Document-layer menu: `error \| allow-if-identical \| first-wins \| last-wins \| keep-all` (+ optional warn); default **error** | Name the option space so v2 does not re-derive it | |
| R15 | Whitespace-only / blank lines (S6 two-layer) | [BEHAVIOR][WIRE] | CHANGELOG second-batch **S6** | Non-protruding blank/ws line → `BlankLine` (span covers ws); ws past content-base → prose; `\` on otherwise-blank line → kept empty Text. AST: interior→newline, edge→ornamentation | Was S1 OPEN in draft1 — **carry, not open**. TODO-SPEC-CORE silence entry stale | |
| R16 | Empty identity `\|el[]` / empty brackets | [BEHAVIOR] | CHANGELOG 2026-07-18 empty-brackets | Closed whitespace-only single-value bracket (`\|el[ ]`, `@[ ]`, and historically `< >`) → **nil**-valued key (not empty-list value). Array `[ ]` → empty array. Unclosed keeps whitespace + Unclosed*. Note: `<>` interim refinement same day (BareValue + NoDialectsLoaded); `< >`→nil is dialect-era | Was S2 OPEN — **carry** | |
| R17 | Array items = uniform value rules | [BEHAVIOR] | CHANGELOG 2026-07-18 §1.8 (Joseph agreed) | Inline Lists enumeration is illustrative, not exhaustive; refs/interps allowed as items | Was S5 OPEN — **carry** | |
| R18 | Multiple suffixes `\|field?!` | [BEHAVIOR] | CHANGELOG second-batch **S1** (also in R9) | Suffixes stack (`≡ :'$?' true :'$!' true`) | Was S6 OPEN — **carry** (duplicate of R9 detail) | |
| R19 | Empty embedded `\|{}` | [BEHAVIOR] | CHANGELOG second-batch **S4** (also in R9) | Valid empty anonymous embedded element | Was S7 OPEN — **carry** | |
| R20 | Framed ` ; ` inside `\|{…}` | [BEHAVIOR] | CHANGELOG alpha.1 fresh-eyes | Ruled **out for now** — bare `;` literal inside embedded; CORE notes revisit when dialects land | Was S10 OPEN — **carry-with-revisit** | |
| R21 | Bare recognition frozen (integer + float) | [BEHAVIOR] | CHANGELOG **0.8.0-alpha.1** | Bare numeric recognition frozen to integer + float only | Frames L5 as **confirm/reaffirm**, not a greenfield invention. Dialect spelling still open | |

**Struck from draft1:** R10 (comment-continuation as “already ruled”) — CORE still says needs a ruling; greenfield convergence is not a ruling source. **L7** is the open row.

---

## 2. Wire contract (new document — ratify law + vocabulary)

| ID | Topic | Tag | Status | Options | Impact / costs | Drafter lean | **Ruling** |
|----|-------|-----|--------|---------|----------------|--------------|------------|
| W0 | **ADM-sufficiency law** as WIRE’s normative sentence | [WIRE] | OPEN | **A** adopt: pure fold over events recovers ADM (structure, ownership, values, text, anomalies, incomplete-input); no source/spans for recovery · **B** weaker (“helpful events”) · **C** defer | A: decision procedure for every “own event?”; matches text-wire. B: taste returns. | **A** | |
| W1 | Attribute value extent | [WIRE] | OPEN | **A** explicit value bracket (`Attr`/`AttrStart` + **`AttrValueEnd`** or symmetric Start/End) · **B** keep inference (reject — deratified) · **C** other | A: fixes W5; forces attr-layer grammar rebuild. **Must re-land mixed interp:** `pre!{{x}}post` is a flow value (*{ batch settled *semantics*); flat-wire “re-emitted Attr segments” encoding is **void** — bracket is the test case that proves the fix. | **A** | |
| W2 | Minimal wire subset vs full vocab refresh | [WIRE] | OPEN | **A** minimal: value bracket only first · **B** full Text-role refresh same pass · **C** phased: A then B | C realistic. | **C** | |
| W3 | Reference encoding | [WIRE] | OPEN | **A** structured · **B** interim raw after `@` · **C** defer to paths | | **B** for first gate; **A** when identity machinery shared | |
| W4 | Warning/error code derivation | [WIRE][ORG] | OPEN | **A** derive Unclosed\<Construct\> · **B** hand registry · **C** both | Descent partial A. | **C** | |
| W5 | Text event role disambiguation | [WIRE] | OPEN | **A** separate roles/types · **B** single Text + brackets imply role · **C** defer after W1 | | **B** where brackets exist; **A** if fold still fails | |

---

## 3. Language — open forks

### 3.0 Severity (rule first — shortens L1/L4)

| ID | Topic | Tag | Status | Options | Impact / costs | Drafter lean | **Ruling** |
|----|-------|-----|--------|---------|----------------|--------------|------------|
| **L0** | **Severity definition** | [BEHAVIOR] | OPEN | **A** Error = **loss only** (kept-as-text cases are Warnings mechanically) · **B** Error = **loss ∪ illegal-geometry / cannot-mean-as-written** (tab-in-indent, etc. may be Error while keeping bytes) · **C** other | One ruling makes L1/L4 severity labels mechanical. Wobble both 3a and 3b hit. | Prefer **A** if purity; **B** if “Error marks structural illegality” is wanted | |

### 3.1 High-interaction

| ID | Topic | Tag | Status | Options | Impact / costs | Drafter lean | **Ruling** |
|----|-------|-----|--------|---------|----------------|--------------|------------|
| L1 | Root-level `:key` | [BEHAVIOR] | OPEN (define-or-carry) | **A** Warning + document Text keep · **B** Error + keep · **C** free-floating attr · **D** **carry undefined** (incumbent: CHANGELOG 2026-07-18 — free-float do-not-rely) | Prior **ruling was undefined**, not A/B. Greenfields re-litigated without that cite. Severity label depends on L0. | Lean **A** if defining now; **D** if v2 stays thin | |
| L2 | In-string escapes | [BEHAVIOR] | OPEN | **A** none (other quote; positional `\` pure) · **B** `\\` + delimiter quote · **C** doubling (list collision) | | **A** | |
| L3 | Multi-line delimited (0.9) | [BEHAVIOR] | **ALREADY RULED (R3)** | Confirm carry R3 only | | **confirm carry R3** | |
| L4 | Tab in indentation | [BEHAVIOR] | OPEN | **A** Error + best-effort keep as text · **B** Error + **line lost** (**live CORE today**) · **C** Warning + keep | **Ruling against live text** either for A or C. Severity depends on L0. | Prefer keep (A or C); not B | |
| L5 | Rational / complex bare | [BEHAVIOR] | OPEN (confirm/reaffirm) | **A** reaffirm out of bare → dialect (aligns **R21** 0.8.0-alpha.1 freeze + greenfield) · **B** restore bare · **C** split | Live CORE caution “parser-decided” is hedge, not the freeze. Dialect spelling (`<r:…>`) is separate (SPEC-OTHER). | **A** | |
| L6 | Attr-under-attr **kept shape only** | [BEHAVIOR] | OPEN | **A** text of open value + error (status already R6) · **B** sibling warned extension · **C** drop · **D** other | Error **status** ruled; shape was “needs a ruling” in CORE | **A** | |
| L7 | Comment continuation strip | [BEHAVIOR] | OPEN | **A** content-base shape (first cont. line) · **B** verbatim from comment column | CORE explicitly needs a ruling; not R10 | **A** | |

### 3.2 Remaining silences / design opens

| ID | Topic | Tag | Status | Options | Impact / costs | Drafter lean | **Ruling** |
|----|-------|-----|--------|---------|----------------|--------------|------------|
| S3 | Multiple keys / surrogate+natural `\|phase[9][scribal]` | [BEHAVIOR] | OPEN | **A** valid; design surface+uniqueness+@ resolution in 0.10 OPEN · **B** invalid · **C** tuple-only enough | Joseph lean: valid, design open | **A** design-open | |
| S4 | `InconsistentIndentation` prose-only? | [BEHAVIOR] | OPEN | **A** confirm prose-only (legacy fixtures die) · **B** restore comment/attr seed base · **C** defer | Unrecorded if A | Confirm **A** if grammar intent | |
| S8 | Raw block empty same-line body `!:sh: ` | [BEHAVIOR] | OPEN | **A** empty RawContent · **B** none · **C** defer | | **A** | |
| S9 | Blank-line placement vs dedent | [BEHAVIOR][WIRE] | OPEN | **A** BlankLine inside still-open child · **B** after End · **C** defer w/ AST S6 | | **C** | |
| S11 | Inline raw in value position | [BEHAVIOR] | OPEN | **A** flow segment · **B** verbatim node · **C** undefined | 2a Q4 | **A** | |
| S12 | Nested envelope routing | [BEHAVIOR] | OPEN | **A** dialect-driven · **B** core hands off · **C** defer | | **A** or defer | |
| S13 | Mixins | [BEHAVIOR] | OPEN | **A** host experiment only · **B** specify · **C** drop | | **A** | |
| S14 | Reference model until paths | [BEHAVIOR] | OPEN | **A** keep (name,key,traits); no incremental growth · **B** paths now · **C** defer | | **A** | |
| S15 | Pragma + filename designator | [ORG][BEHAVIOR] | OPEN | **A** OPEN stub · **B** full in v2.0 · **C** defer | | **A** | |
| S16 | Markdown four layers | [ORG] | OPEN | **A** companion stub · **B** full Layer-1 now · **C** defer | | **A** | |
| S17 | Float semantic equality | [ORG] | OPEN | **A** host profile · **B** specify · **C** omit from core equivalence | | **A** or **C** | |
| S18 | Inline-comment framing whitespace | [BEHAVIOR] | OPEN | **A** preserve both framing spaces on strip (live CURRENT) · **B** collapse · **C** defer with dialects | 3b O12; CORE pending dialect work | **C** or **A** pin live | |

**Moved to §1 carry (not open):** former S1→R15, S2→R16, S5→R17, S6→R18, S7→R19, S10→R20.

---

## 4. Packaging & authoring (after rulings)

| ID | Topic | Tag | Status | Options | Impact | Drafter lean | **Ruling** |
|----|-------|-----|--------|---------|--------|--------------|------------|
| P1 | Where new suite lives | [ORG] | OPEN | **A** replace `spec/` (old → `_archive/…`) · **B** author under `v2-spec/` until cutover · **C** dual-run | B keeps old tree byte-stable for C4 oracle | **B** (Fable + grok) | |
| P2 | Parallel agents for suite authoring | [ORG] | OPEN | **A** yes, seeded by this table + CHANGELOG · **B** single agent · **C** human-led | | **A** | |
| P3 | Non-normative GRAMMAR extract day one | [ORG] | OPEN | **A** yes (SPEC wins on conflict) · **B** later | | **A** thin | |
| P4 | Pedagogy day one | [ORG] | OPEN | **A** outline only · **B** full tour · **C** defer | | **A** | |
| P5 | Dialects in suite day one | [ORG] | OPEN | **A** temporal@1 + dynamics thin · **B** pointers only · **C** full | | **A** or **B** | |

---

## 5. Explicitly out of scope this sitting

- Full path syntax / multi-line **design proper** (0.10 venue — R3 + emergent-span)  
- Literate fusion machinery  
- UX / utils / crates.io  
- Descent LINE construct implementation  
- Re-opening CHANGELOG “Ruled” without an Overturn mark on the matching R-row  
- Cosmetic CORE unwrap / bare-pipe tables (authoring polish, not rulings)  

---

## 6. Suggested sitting order

1. **C0–C2** — greenfield, seeded authoring, version line (often already decided).  
2. **Carry R1–R21** — scan; overturn only if wrong.  
3. **W0–W1** — sufficiency law + AttrValueEnd (hinge).  
4. **C5–C6** — fixture format / incomplete-input.  
5. **L0** — severity definition (**before** L1/L4).  
6. **L1, L2, L4–L7** — quick language (L1 = define vs carry undefined; L5 = reaffirm freeze).  
7. **S3, S4, S8–S9, S11–S18** — mass-defer OK with venue noted.  
8. **P1–P2** — where and how to author.  

Unmarked → treat as **defer with venue** at end of sitting (not silent forever).

---

## 7. After you rule

1. Integrate any further stress delta if needed.  
2. Authoring agents receive: **filled table** + CHANGELOG cite list + greenfield suites as *wording only*.  
3. First artifacts under `v2-spec/`: DECISIONS (R* + your marks), OPEN (remaining S*/L*), then ADM / SPEC / WIRE / SEMANTICS / GLOSSARY.  

---

## 8. Integration log (Fable stress-check)

| Action | Detail |
|--------|--------|
| OPEN → carry | S1→R15, S2→R16, S5→R17, S6→R18, S7→R19, S10→R20 |
| Added carries | R12 emission order, R13 micro-batch, R14 dup-def menu, R21 bare numeric freeze |
| Struck | R10 (false “already ruled” for comment continuation) |
| Split | R6 error-status only; L6 = kept shape |
| Reframed | L1 define-or-carry (+ option D); L5 confirm/reaffirm (+ R21) |
| Added open | L0 severity; S18 framing whitespace; W1 mixed-interp note |
| Sitting order | L0 before L1/L4 |
| Sources | Delta also swept alpha.1 / 0.8 CHANGELOG sections |

**Genuinely open for judgment (post-integration):** roughly C2–C6, W0–W5, L0, L1 (define-or-carry), L2, L4, L6, L7, S3–S4, S8–S9, S11–S18, P1–P5 — many one-word defers. Still one sitting.

**Stress-check artifact:** integrated above and removed (this log is the record).
