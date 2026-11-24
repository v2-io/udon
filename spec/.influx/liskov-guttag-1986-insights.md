# Liskov & Guttag (1986) Read Against `udon` v2 and `verisectorium`

*Reading notes prepared 2026-11-24 from Barbara Liskov & John Guttag, **Abstraction and Specification in Program Development** (MIT Press / McGraw-Hill, 1986; 2nd printing 1987), via the OCR text extract (`liskov-guttag-B.txt`). Every claim about the book is tied to verbatim quotations with book page numbers and extract line numbers (`L…`); interpretations and transfers to `udon` or `verisectorium` are marked as mine.*

---

## Executive Takeaway: What Actually Surprised Me

Going in, I expected Liskov & Guttag (1986) to be mostly familiar CS-3110-style material (locality, modifiability, `requires`/`effects`, rep invariants). Reading the primary text with `udon` v2 and `verisectorium`'s `vision-2026-11-21` files open beside it surfaced **six things that genuinely sharpen live open problems** — and **four clear places where Liskov & Guttag does not transfer or where `udon` / `verisectorium` have already moved past it**.

**Highest-leverage finds for `udon` v2:**
1. **Two-tiered specifications (Ch. 10, Larch style: Auxiliary Specifications vs. Interface Specifications)** — directly resolves how `«AST»` (language-independent abstract value domain) relates to parser rules, errors, and streaming, and gives `partitioned by` + `sufficient-completeness` as concrete tools for `element.md`, `AST.md`, and systematic gap-finding.
2. **Specificand sets, underdetermination, and definitional vs. operational specs (Ch. 3.6, Ch. 8.1–8.2)** — clarifies the open question in `AST.md` L39 (whether compliant parsers must emit identical ASTs) and guards against operational parser-prose leaking into the spec.
3. **Total domain partitioning + nondeterministic error choice (`normally ... except`) (Ch. 5, Ch. 10.2.2)** — cleans up parser error/warning handling and avoids accidental spec contradiction when one input triggers two syntax errors at once.
4. **Why `Consumer vs. Implementer` splits into *three* roles for a notation** — and why writing the user manual / pedagogy early is an independent *fitness* check (Ch. 12.2), not a downstream chore.

**Highest-leverage finds for `verisectorium`:**
1. **Marked cross-register redundancy (`I.e.` / `E.g.`) as both reader self-check and error-detector (Ch. 8.2.3)** — directly challenges `cold-reader.md` §4.3's placement of "redundant restatement" under Noise and sharpens `note 30`'s `restatement` kind.
2. **Rejected alternatives as an active *uniform-criteria detector* in reviews (Ch. 14.1)** — adds a second, distinct function beyond Parnas/Eduyot's anti-rediscovery memory (`outside-fields.md` §1, §8).
3. **Weak vs. strong dependencies (`weakly uses` vs. `uses`, Ch. 13.2.1)** — refines `core/`'s binary `rests on` vs. `pointing` split and bears on `30-addendum.md` §13.6 ("what does 'move' mean?").
4. **Disjunctive coherence as a syntactic detector for "pseudo-generalizations" (Ch. 14.1.2)** — formalizes Joseph's exact critique of `note 30` ("pseudo-generalizations that aren't actually generalizations and are mostly semantic punts").
5. **The five failure modes of verification + Unit vs. Integration vs. Acceptance validation (Ch. 9.2, Ch. 11.5, Ch. 12.1)** — maps cleanly onto Joseph's three failure modes (spec fault / compliance fault / fitness fault) and shows why each level holds a *different* artifact fixed.
6. **Decomposition ≠ Abstraction (Ch. 1.2.2), plus Rep Invariants & Benevolent Side Effects (Ch. 4.5)** — cleanly frames `verisectorium`'s on-disk files vs. abstract segments (why paragraph reflow doesn't mint a version; `equal` vs. `similar` for identity vs. content).

**Where L&G does NOT transfer (or `verisectorium` / `udon` are already ahead):**
- Idealized top-down design process (Ch. 12–13) — contradicted by modern protocol studies already gathered in `how-models-get-made.md` (and quietly qualified by L&G themselves on pp. 216, 293).
- Binary `satisfies` relation with no graded credence, provenance, multi-reader outlines, or turnover-induced semantic decay.
- Imperative module/heap mechanics (CLU `modifies`, `up`/`down`, aliasing) — relevant to a mutable AST *library*, not to UDON's syntax-to-AST mapping itself.

---

## Part I · Insights for `udon` v2

### 1. Two-Tiered Specification: Auxiliary Specifications (Traits) vs. Interface Specifications (Ch. 10, pp. 187–216)

In `udon/spec/def/AST.md` (Working Notes, L36), the spec notes a gap: *"The opening says the «AST» is 'shown in this spec in an implementation-language agnostic notation'; none has been chosen."* Meanwhile `spec/def/element.md` (L28) separates *what an element is in the AST* from *how it is written*, and `canonical.outline.md` L7 pins both the static non-streaming AST and parser errors/warnings/streaming (`[^1]`).

Liskov & Guttag Chapter 10 (presenting Larch/CLU) splits every formal specification into **two distinct tiers** for exactly this reason:

> "Formal specification provides a means of defining these auxiliary domains precisely. It uses two kinds of specifications. An interface specification describes the interface that an abstraction presents to its users, that is, to implementers of other modules that use the abstraction. Each interface specification is built on top of an auxiliary specification, which provides a vocabulary that allows us to express the interface specification succinctly and clearly. An interface specification is always dependent on the programming language. Auxiliary specifications, on the other hand, are independent of the programming language." (Ch. 10, pp. 187–188; `L399–L401`)

> "The problem with informal specifications is that these auxiliary domains are never defined precisely. If readers have an intuitive understanding of the domain, and this intuition matches that of the specifier, they will be able to understand specifications based on the domain; otherwise they will not. Worst of all, as mentioned in chapter 8, there is no way to know whether a reader and the specifier are interpreting things in the same way." (Ch. 10, p. 187; `L399`)

**Three mechanisms inside Chapter 10 transfer straight into `udon` v2:**

1. **`partitioned by` defines abstract equality by naming the exact minimal observers (Ch. 10.1.2, pp. 198–199).**
   > "Saying that sort S is partitioned by a set of functions F asserts that if two terms of sort S are unequal, a difference can always be observed using a function in F. In this case the terms are equal if they cannot be distinguished using any of the functions in F." (p. 198; `L421`)

   *Bearing on `udon` (my reading):* `element.md` (L25) currently states as an invariant: *"Two «elements» that differ only in the order their «attributes» were written are the same «element»."* That is a `partitioned by` claim. Explicitly listing the observer set for `«AST»` / `«element»` / `«attribute»` immediately forces crisp answers to the live open questions in `element.md`, `AST.md`, and `spec-lite-incoherences-2026-11-07.md`:
   - Is attribute key order observable? No (excluded from `partitioned by`).
   - Are repeated values under one attribute name ordered (`element.md` L46)? If yes, `attr_values(el, name)` returns a sequence, not a set.
   - Where do `meta` and `ornament` sit (`spec-lite-incoherences` L51: *"content < content+meta < content+meta+ornament"*)? If core compliance is `partitioned by` content observers alone, while `meta` and `ornament` are layered observers (or optional traits), then two parsers can legitimately differ in whether they retain source spans or whitespace ornament while still producing the *same* core AST.
   - It also resolves `AST.md` L37 ("directed acyclical graph" vs. "tree"): a pure value sort defined by `generated by` + `partitioned by` has no object aliasing (`equal` = structural value equality), whereas a shared-node DAG introduces object identity vs. value equality (`equal` vs. `similar`, Ch. 4.9.5 pp. 93–94 and Ch. 10.2 p. 209).

2. **`generated by` + `sufficient-completeness` as a systematic gap-finder (Ch. 10.1.4–10.1.5, pp. 201–205).**
   L&G note that mathematical completeness ("no independent axioms can be added") is *wrong* for specs because it forbids underdetermination (p. 201; `L427`). Instead they use **sufficient-completeness** (can every observer applied to every constructor be reduced?) as a **candidate generator**:
   > "It is worth noting that very often the set of axioms in a trait is not sufficiently complete, as was the case with INTSTACK. Sufficient-completeness is still a useful property, though, because it allows us to generate a candidate set of axioms. We may then decide explicitly to omit some axiom, but starting with a list of candidates helps us avoid omitting an axiom by accident." (p. 205; `L435`)
   > "Frequently, the places where a trait is not sufficiently complete correspond to exceptions in interface specifications built from the trait." (p. 204; `L433`)

   *Bearing on `udon` (my reading):* Several incoherences cataloged in `spec/.influx/spec-lite-incoherences-2026-11-07.md` are accidental omissions in the syntax-construct × context matrix (e.g., `rule-deeper-marker-lines-are-text` stated for `|` but silent on `:`, `;`, fences; EOL framing on `|li Item ;` vs. `:a \`). Building an explicit constructor × observer table for the AST—and a construct × context table for the syntax—turns accidental gaps into explicit decisions, and flags exactly where parser diagnostics/errors belong.

3. **Co-evolution warning for `DECISIONS.kdl`'s `definitions-first` lean (Ch. 10.3, p. 216).**
   > "In this chapter, the trait INT_ARRAY_SPEC was presented before the specification of the type int_array. The order of presentation is arbitrary. In constructing this specification, we developed the interface and traits in tandem. We began with a preliminary trait. As we worked on the interface specification, we went back several times and modified the trait to make the interface specification easier to write." (p. 216; `L457`)

   *Bearing on `udon` (my reading):* Working definitions first (`DECISIONS.kdl` L39) is a great cure for spec-lite's lexicon explosion, *provided* `udon` expects the definitions (`«AST»`, `«element»`, `«attribute»`, `«value»`) to get revised as parsing/streaming rules are written against them, rather than treating Part 1 as frozen before Part 2 begins.

---

### 2. Specificand Sets, Underdetermination, and Operational vs. Definitional Specs (Ch. 3.6, Ch. 8.1–8.2)

`AST.md` (Working Notes, L39) holds an explicit open question: *"whether every compliant parser must give the same «AST» for the same «partial» with no exceptions. The earlier quality factors called this a weight, not a veto, because 'some rare contexts may unavoidably need different trees' (CTQ-FACTORS.md, note b3). The Definition's first point is written as if there were none."*

L&G's vocabulary in Ch. 3.6 and Ch. 8.1–8.2 cuts this cleanly:

> "We define the meaning of a specification to be the set of all program modules that satisfy it. We call this the specificand set of the specification." (Ch. 8.1, p. 150; `L325`)
> "It is important to remember that a specification, its specificand set, and a particular member of the specificand set are very different kinds of things, as different as a program, the set of all possible executions of that program, and an execution of that program on a single set of data." (p. 150; `L325`)
> "There is a vast difference between knowing that some members of a specification's specificand set are appropriate and knowing that all members are appropriate." (Ch. 8.2.1, p. 151; `L327`)
> "Some details of what the procedure does may also be left undefined, leading to a procedure that is underdetermined. This means that for certain inputs, instead of a single correct output, there is a set of acceptable outputs. An implementation is constrained to produce some member of that set, but any member will do. ... An underdetermined abstraction can have a deterministic implementation, that is, one that, if called twice with identical inputs, behaves identically on the two calls." (Ch. 3.6, pp. 51–52; `L127–L129`)

And on **definitional vs. operational** specifications (Ch. 8.2.2):
> "A definitional specification explicitly lists properties that the members of the specificand set are to exhibit. The alternative to a definitional specification is an operational one. An operational specification, instead of describing the properties of the specificands, gives a recipe for constructing them. ... Operational specifications have some advantages. Most significantly, they seem to be relatively easily constructed by trained programmers—chiefly because their construction so closely resembles programming. They are generally longer than definitional specifications, however, and they often lead to overspecification. ... A good check for generality is to examine every property required by a specification, in both the requires and effects clauses, and ask whether it is really needed. If it is not, then it should be eliminated or weakened. Also, any portion of a specification that is operational rather than definitional should be viewed with suspicion." (Ch. 8.2.2, p. 153; `L331`)

*Bearing on `udon` (my reading):*
- **Separate *determinism* from *underdetermination*.** Every UDON parser should be deterministic on a given input, while the *spec* should be **maximally determined on the abstract AST** (`partitioned by` core observers) and **deliberately underdetermined** on everything else: internal rep, attribute iteration order, optional `meta`/`ornament` retention, streaming buffer boundaries, and exact diagnostic prose (as long as the error class/location is specified). If `CTQ-FACTORS` b3 truly has rare contexts where two ASTs are acceptable, they should be **explicitly named underdeterminations** (like L&G's *"in an arbitrary order"* on p. 152, `L329`), never silent ambiguity!
- **Watch out for operational spec drift.** `spec-lite-incoherences` L55 noted agent jargon like `"line scan"` creeping into rule cards, and `DECISIONS.kdl` L61 floats PEG representations inside the spec. PEG grammars are inherently *operational* (ordered choice encodes a parsing algorithm, which can silently overspecify lookahead/error order and exclude streaming/table-driven parsers). If PEG is included, L&G's discipline says either treat it as a *non-normative / marked-redundant* cross-check, or prove its language equals the definitional rules; and state UDON's streaming constraint ("kind within a character or two; no unbounded holdback") as an **explicit efficiency/streaming constraint** beside the functional spec — just as L&G's Design Notebook (Ch. 13.2.2, pp. 269–270; `L563–L565`) separates *functional behavior* from *efficiency constraints* (`temporary space << Order(n)` in `format`, p. 273; `L571`).
- **Two abstraction functions in UDON (Ch. 4.5, pp. 70–78).** In UDON there are *two* many-to-one abstraction functions:
  1. `A_parse: SourceText -> AbstractAST` (defined by the spec: forgets irrelevant layout/attribute order).
  2. `A_impl: ConcreteRep -> AbstractAST` (owned by each parser implementation in Rust/Ruby/etc., with its own `rep invariant` and allowed **benevolent side effects**, Ch. 4.5.4 pp. 77–78, such as lazy view-parsing of `C-with-view` values or string interning!). Keeping these two barriers distinct prevents parser internals from leaking into the spec.

---

### 3. Total Domain Partitioning, Errors vs. Failures, and Nondeterministic Multi-Error Choice (Ch. 5; Ch. 10.2.2)

For a general-purpose parser accepting arbitrary external text, L&G's error-handling doctrine is directly on point:

- **General-use abstractions should be *total*, partitioning the entire input domain `D = D_0 U D_1 U ... U D_n` (Ch. 3.6 p. 53; Ch. 5 pp. 100–101, 110, 116).**
  > "If the procedure is intended for general use (for example, if it is to be made available as part of a program library), safety considerations should be given great weight." (Ch. 3.6, p. 53; `L131`)
  > "Most procedures should be defined over the entire domain; exceptions are used to take care of situations in which the 'normal' behavior cannot happen." (Ch. 5.5, p. 116; `L257`)
  > "Termination by signaling an exception is part of the ordinary behavior of the procedure." (Ch. 5.1, p. 102; `L229`)

- **Separate programmatic exceptions, human diagnostics, and unspecified `failure` (Ch. 5.4, pp. 112, 115).**
  > "Not all errors give rise to exceptions. Consider an erroneous record in a large input file, where it is possible to continue processing the file by skipping that record. In such a case, it may be appropriate to inform a person (not a program) about the error. Exceptions are a mechanism for communication among programs, not for communication from programs to people. ... Note, by the way, that what is done with the error is defined in the abstraction's specification." (Ch. 5.4, p. 112; `L249`)
  > "The failure exception is an implicit exception of every procedure, yet no mention of failure was made in any of the specifications. This omission is appropriate. A specification describes the behavior of a procedure when it is working and when its arguments satisfy the requires clause. Failure occurs when the procedure is broken and no longer meets its specification or when the arguments are improper." (Ch. 5.4, p. 115; `L255`)

- **Avoid accidental contradiction when multiple error conditions hold simultaneously (Ch. 10.2.2, pp. 212–213).**
  In L&G's `normally PostPred except signals e_1 when PrePred_1 ... signals e_n when PrePred_n`:
  > "If more than one of them is true, an exception associated with one of the true enabling conditions must be raised, but the choice of which exception is nondeterministic. ... To state this a bit more formally, a predicate of the form given above is equivalent to the predicate `( returns | signals exception_1 | ... | signals exception_n ) & ( returns => PostPred & ~(PrePred_1 | ... | PrePred_n) ) & ( signals exception_1 => (PrePred_1 & PostPred_1) ) ...` This semantics allows a nondeterministic choice of signals when this is desired, as discussed. If instead we had the pre-conditions implying the results, as in `PrePred_i => signals exception_i & PostPred_i` the nondeterminism would not be possible." (Ch. 10.2.2, p. 212; `L449`)

  *Bearing on `udon` (my reading):* This is a sneaky real-world language-spec trap. If UDON writes flat rules ("if condition A, parser MUST emit error E1"; "if condition B, parser MUST emit error E2"), any malformed document satisfying both A and B either forces a parser to emit *both* (requiring error recovery) or makes the spec **inconsistent** for fail-fast parsers unless priority or nondeterministic choice (L&G's `signals e_i => PrePred_i` direction) is stated!

---

### 4. Streaming (`«fragment»`) as an Iteration / Sink Abstraction (Ch. 6 & Ch. 13.4, 13.9)

`canonical.outline.md` (L31, `[^1]`) defers streaming (`«fragment»`) while noting UDON is designed for fixed-buffer incremental delivery. L&G Ch. 6 (pp. 118–128) introduces **iteration abstraction** specifically to solve the exact tension between batch materialization (`el_seq` — *"we have two data structures... we must process the entire collection to build the sequence"*, p. 119; `L263`) and leaking internal representation. And in Ch. 13.4 & 13.9 (pp. 274–275, 290), their text formatter (`format`) meets `temporary space << Order(n)` by feeding incremental events into an abstract sink (`doc`).

*Bearing on `udon` (my reading):* When UDON eventually specifies `«fragment»` streaming, L&G's pattern suggests defining the streaming parser as yielding a stream of abstract AST construction events (or driving an abstract sink `ASTBuilder`) such that **running the non-streaming `ASTBuilder` over the streaming events is provably identical to the non-streaming `«partial»` AST**. That keeps one semantic model instead of two parallel specs.

---

### 5. `Consumer vs. Implementer` Splits into Three Roles for a Notation — and Early User-Manual Writing Tests Fitness (Ch. 12.2)

Joseph's spark from `spec-notes.md` was viewing **Consumer vs. Implementer** as two projections of the UDON spec (with the AST and examples sitting between them), plus adding **fitness** (Failure Mode 3: a compliant parser still failing UDON's primary purposes).

Reading L&G sharpens this in two concrete ways:
1. **In a data/document language, "Consumer" is actually *two* distinct roles:**
   - **AST Consumer (host program / caller of the parser)** — this is L&G's literal *client* of the parser module. Its duality with the **Parser Implementer** is exact: `requires` (what input encoding/framing the caller supplies) ↔ `effects` (what AST invariants and diagnostics the parser guarantees).
   - **Document Author / Human-or-Agent Reader** — this person writes and reads `.ud` text. They are *not* calling a parser API; they are using the notation's syntax to express meaning. Their projection needs progressive disclosure, idioms, mental models, and why-this-syntax heuristics (`defining-udon.md` Part 3).
   If a single "Consumer" projection tries to serve both the host-program caller and the document author, it mixes API guarantees (e.g., `$root` metadata attributes, unordered attribute map invariants) with authoring pedagogy. Keeping all three projections distinct — **Parser Implementer**, **AST Consumer**, **Document Author** — lets the AST sit cleanly between Implementer and AST Consumer, while concrete `.ud ↔ AST` examples sit across all three.
2. **Writing the Author Manual / Pedagogy is an early *fitness* probe, not just a later deliverable (Ch. 12.2, p. 256).**
   > "The requirements specification can be the input to two activities in addition to the design. It can be used to produce acceptance tests and as a basis for a user's manual. The user's manual is something that must be produced anyway, but its production can provide an independent check on the suitability of the specification. If the system is hard to use, this may be evident when the manual is written. Also, by reading the manual, the customer may notice deficiencies in the specification that were overlooked earlier." (Ch. 12.2, p. 256; `L537`)

   *Bearing on `udon` (my reading):* `DECISIONS.kdl` L54 (`pedagogy-outline`) currently says *"A pedagogy outline comes later."* L&G (independently echoing Knuth's TeX manual thesis in `how-models-get-made.md`) argue that drafting the user-facing manual *alongside* the spec is one of the cheapest early detectors of Failure Mode 3 (fitness): awkwardness in explaining a rule to an author exposes spec defects before any parser is built.

---

### 6. Adjacent Catch in `udon/spec/.influx/defining-udon.md`: Fixture Suites Do Not *Define* Compliance (Ch. 9.1–9.3)

`spec/.influx/defining-udon.md` (L42) states: *"The `CORE.md` specification should explicitly state that passing the canonical fixture suite is the **only** definition of compliance."*

L&G Chapter 9 explicitly refutes treating a finite black-box test suite as the definition of compliance:
- Exhaustive testing is impossible for infinite input domains (p. 162; `L349`).
- Black-box tests alone cannot measure internal coverage (e.g., a parser using table lookup vs. computation, p. 165; `L355`), and glass-box path-completeness cannot detect *missing* paths (p. 166; `L357`).
- Compliance is defined by membership in the specification's **specificand set** (Ch. 8.1, p. 150); the fixture suite is an indispensable **black-box validation driver** derived from paths through the specification (Ch. 9.1.1, pp. 162–165), supplemented by **property/invariant-checking drivers** that compare outputs directly against inputs rather than only golden files (Ch. 9.3, p. 174; `L373` — crucial wherever UDON leaves aspects underdetermined, such as attribute order or optional ornament).

---

## Part II · Insights for `verisectorium`

*Context check:* `verisectorium/msc/scratch/vision-2026-11-21/` already brought in Parnas & Clements (1986), Wassyng & Lawford (2003), Naur (1985), Thurston (1994), Knuth (1989), Lakatos (1976), Goel (1992), Voevodsky (2014), Tao/ETP (2025), and Patterson (2004). Notably, Liskov & Guttag (1986) is from the exact same year and lineage as Parnas & Clements (1986) — citing Parnas (1972, 1977) and Hester/Parnas/Utter (1981) on pp. 160 and 294 — while adding formal-specification, coherence, and verification machinery that Parnas & Clements does not cover. Below are the points that **genuinely add to or push back on** `vision-2026-11-21`, `note 30`, `30-addendum.md`, and `core/`.

---

### 1. Marked Cross-Register Redundancy as Reader Benchmark & Error-Detector (Ch. 8.2.3, pp. 154–157)

In `vision-2026-11-21/cold-reader.md` (§4.3, table L115), *"Redundant restatement"* is classified under **Noise**: *"Adds cost without benefit when the original is reachable; helps when it is not."* And in `note 30` (§1, L20), a `restatement` is framed mainly as a simplification or alternate-length version for a different reader.

L&G Ch. 8.2.3 pushes back directly on treating in-place redundancy as noise — **provided it is cross-register and explicitly marked**:

1. **The dangerous comprehension failure is *silent misunderstanding*, not confusion (p. 154):**
   > "There are two distinct ways in which people may fail to understand a specification. They may study it and come away knowing that they do not understand it. ... This is troublesome, but not as dangerous as when people come away thinking that they understand a specification when in fact they do not." (p. 154; `L333`)

   Their `billion` example (pp. 156–157; `L337–L339`): *"Returns the integer one billion"* looks perfectly unambiguous to both American ($10^9$) and British ($10^{12}$) readers — *"Unfortunately, they are also likely to interpret it in completely different ways."* Adding `i.e., 10^9` looks redundant to an American author and prevents silent divergence.

2. **Two distinct truth-serving roles of marked redundancy ("redundant without being repetitious", pp. 155–156):**
   - **Self-check benchmark across reader backgrounds** (the `subset` and `present value` examples, pp. 155–156; `L335–L337`: domain phrase + formal `I.e.` formula + concrete `E.g.` calculation):
     > "By stating the same thing in more than one way, a specification provides readers with a benchmark against which they can check their understanding. This helps to prevent misunderstandings and thus allows readers to spend less time studying a specification." (p. 155; `L335`)
   - **Internal error-detection checksum** (the `too_cold` example, p. 156; `L337`: `temp < 0 degrees Fahrenheit` alongside `I.e., ... not greater than the freezing point of water at standard temperature and pressure`):
     > "Redundancy does not reduce the number of mistakes in a specification. Instead it makes them more evident and provides the reader with the opportunity to notice them." (p. 156; `L337`)

3. **The mandatory marking condition (p. 156) — why unmarked redundancy *does* become noise:**
   > "If readers are to benefit from redundancy, it is critical that all redundant information be clearly marked as such. Otherwise a reader can waste a lot of time trying to understand what new information is being presented when, in fact, none is. A good way to indicate that information is redundant is to preface it with 'i.e.' or 'e.g.'" (p. 156; `L337`)

*Bearing on `verisectorium` (my reading):*
- This sharpens `cold-reader.md` §4.3: **repetitive same-register restatement** (copy-forward prose) is noise and decays under turnover; **marked cross-register redundancy** (normative prose + formal predicate + concrete worked example, explicitly typed as `restates` / carrying no new claim) *raises* the truth-to-noise ratio even when the original is right next to it, because it prevents silent misreading and creates an internal collision surface for catching spec bugs (`too_cold`)!
- It also aligns cleanly with `verisectorium`'s `restates` reference kind: if an `E.g.` example in `udon` (`spec-lite-incoherences` L25: *"Example overreaches the Statement"*) is explicitly typed as a redundant restatement of its rule, any mismatch immediately signals a spec defect instead of silently smuggling in a second rule.
- Notice also L&G's warning against **growth by accretion** (pp. 154–155; `L333–L335`): *"Like programs, specifications that grow by accretion are often longer than they need to be. Instead of just adding to a specification, it is important to step back from that local change and see whether there is a way to consolidate the information."* — directly echoing `verisectorium`'s `replace, don't append` / consolidation discipline.

---

### 2. Rejected Alternatives as an Active *Uniform-Criteria Detector* in Reviews (Ch. 14.1, p. 295)

`outside-fields.md` (§1, §8) already imported Parnas & Clements (1986) and Mishnah Eduyot for why rejected alternatives are kept: preserving rationale for future maintainers and recognizing when a rejected idea resurfaces.

L&G Ch. 14.1 adds a **distinct, active epistemic use of rejected alternatives during review** that I did not see in `vision-2026-11-21`:

> "It is useful for the designers to present not only the design but also the alternatives that were considered and rejected. This will give the outside reviewers a context for evaluating the chosen design. It may also help the reviewers to find flaws in the chosen design. A common problem is failure to apply design criteria uniformly. Explaining that an alternative was rejected because it failed to meet some criterion may well prompt the reviewers to notice that some other part of the design fails to meet that same criterion." (Ch. 14.1, p. 295; `L615`)

*Bearing on `verisectorium` (my reading):* In `verisectorium`, a decision's rejected alternatives (currently an optional field in `core/def/decision.md`) aren't just archaeology or anti-rediscovery guards — they are **implicit universal claims about the project's decision criteria**! If decision D1 rejected option X for violating criterion C, an auditor (or a cross-decision check) can test whether accepted decision D2 silently violates C.

Also worth noting from the same paragraph (p. 295; `L615`):
> "In addition, both the reviewers and the designers must keep in mind that the purpose of the review is only to find errors, not to correct them. Errors should be recorded in an error log, and then the review should continue (unless so many errors have been found that continuing is no longer productive)."

This reinforces `note 30` §2's strict separation between **checking** and **reflecting/repairing** (and `stopgap` §III.8's auditor-vs-reviser boundary).

---

### 3. Weak vs. Strong Dependencies (`weakly uses` vs. `uses`) (Ch. 13.2.1, pp. 268–269)

In `verisectorium/msc/notes/30-addendum.md` (§13.6, L360), an un-kicked question asks: *"Does 'move' mean has to be checked again, decided again, or rewritten?"* Meanwhile `core/model.outline.md` (L42) draws a binary line: `rests on` propagates unsettledness, while `holding` and `pointing` do not.

L&G's Module Dependency Diagram (Ch. 13.2.1) introduces a useful intermediate edge: **weak use** (dashed arc) vs. **strong use** (solid arc):

> "Sometimes, an abstraction uses an object of a type without calling any of the type's operations. For example, it might receive an object as an argument and simply pass the object on to another abstraction. In such a case we say that the target weakly uses the type. A special dashed arc is used to indicate this kind of dependency." (Ch. 13.2.1, p. 268; `L561`)
> "An abstraction that weakly uses an erroneous type is affected if the type disappears entirely, but not if the type changes or is replaced by another type. For example, in figure 13.1, if we found a problem with D, we would have to rethink the implementations of E and P, but Q and I would not be affected. Of course, if rethinking E prompted us to change its specification, we would be forced to reexamine the implementation of Q." (pp. 268–269; `L561–L563`)

*Bearing on `verisectorium` (my reading):* This gives a clean three-way stratification of dependency sensitivity when a piece D changes:
1. **Existence-only (`weakly uses`)**: affected *only* if D is retired/deleted (e.g., a piece that merely routes or passes through `«node»` without depending on its internals, or an outline slot pointing at D).
2. **Contract/specification dependence (`uses` / `rests on`)**: affected if D's claim/definition/spec changes, *immune* to internal proof/wording/representation edits that preserve the contract (compare `core/`'s carrying check!).
3. **Internal/representation dependence**: eliminated whenever an abstraction barrier holds (and a structural defect when it exists!).
Notice also L&G's conservative default during design (Ch. 13.6, p. 279; `L583`): *"Before studying do_line, we did not know whether its use of doc would be weak or strong, so we assumed it would be strong."*

---

### 4. Disjunctive Coherence as a Structural Detector for "Pseudo-Generalizations" (Ch. 14.1.2, pp. 299–303)

In `30-addendum.md` (L3, §13), Joseph criticized several phrases in `note 30` as *"pseudo-generalizations that aren't actually generalizations and are mostly semantic punts"*, and kicking them uncovered lumped meanings (`built-upon` = 5 things, `outside things` = 4 things, `piece` = 3 scales, `act`/`instrument`/`waiting` = 2 things each).

L&G Ch. 14.1.2 gives a crisp taxonomy of **three coherence failures** visible directly in a concept's or operation's specification:
- **No coherence** (p. 300; `L625`): *"If it seems that the best way to specify a procedure involves describing its internal structure (that is, how it works), the procedure is probably incoherent. The second good tip-off is difficulty in finding a suitable name..."*
- **Conjunctive coherence** (`A & B & C`, pp. 300–301; `L625–L627`): bundling things that merely happen at the same time (e.g., `initialize A & initialize B`), which breaks as soon as a caller needs only one conjunct.
- **Disjunctive coherence** (`A | B` in normal behavior, pp. 301–302; `L627–L629`):
  > "Disjunctive coherence often arises from a misguided attempt to generalize abstractions. ... However, if the result is an abstraction with disjunctive coherence, then it is usually better not to do the replacement." (p. 302; `L629`)
  > "Occasionally the appearance of excessive disjunctive coherence indicates failure to introduce appropriate data abstractions into the design." (p. 302; `L629`)

And crucially, L&G give the **contrast case** showing what a *real* generalization looks like (`justify(from_right)` vs. `get_end(j)`, p. 302; `L629`):
> "While there is a disjunction in justify's specification, it is buried rather deeply. Most of the specification, and most of the code, is independent of the value of the argument from_right."

*Bearing on `verisectorium` (my reading):* This is a direct, checkable test for every unified concept in `verisectorium` (and every rule/term in `udon`): **Write its specification in plain operational/logical form. If a disjunction (`if kind = A then ... else if kind = B then ...`) sits at the top level of its normal behavior, it is a pseudo-generalization (split it, or look for the missing abstraction underneath); if the variation is buried deep inside mostly shared mechanics, the generalization earned its keep.** (Think of `30-addendum.md` §10's four kinds of "outside things" or §7's "how each piece stands".)

---

### 5. Five Verification Failure Modes & The Unit / Integration / Acceptance Validation Triad (Ch. 9.2, Ch. 11.5, Ch. 12.1)

This maps directly onto Joseph's **three failure modes** (from `spec-notes.md`) and sharpens `verisectorium`'s checking model (`note 30` §2 & `vision-2026-11-21` Q27/Q31):

1. **Five reasons a formal verifier can fail (Ch. 11.5, p. 248; `L521`):**
   1. Insufficient deductive power of the checker (needs lemmas / different method).
   2. Internal helper specifications are **too weak** to derive the whole (even though the implementation is right).
   3. Bridging invariants / abstraction functions are inappropriate.
   4. Correctness depends on an **unstated fact about the application area** (*"Ideally, one should incorporate such information into the specification or other documentation"* — compare `verisectorium` Q19 / ASF `der-directed-separation`: knowledge held outside the record!).
   5. The implementation fails the spec — and critically:
      > "The program, the specification, or both may be 'wrong.' ... There is no a priori way to know whether it is the program or the specification that is 'wrong.' Uncovering such problems is the primary purpose of program verification." (p. 248; `L521`)

2. **What is held fixed changes across three levels of validation (Ch. 9.2, p. 173; Ch. 12.1, pp. 251–252):**
   - **Unit validation** (holds the unit's specification fixed):
     > "The acceptance of the specification as a given is a key factor that distinguishes unit testing from integration testing. During unit testing, when a module fails to meet its specification, we generally conclude that it is incorrect." (Ch. 9.2, p. 173; `L371`)
   - **Integration validation** (puts the *internal specifications* on trial):
     > "When validating a whole program, we must accept the fact that the most serious errors are often errors of specification. In these cases, each unit does what it is supposed to, but the program as a whole does not. A prime cause of this kind of problem is ambiguous specifications." (Ch. 9.2, p. 173; `L371`)
   - **Acceptance / Fitness validation** (puts the *requirements specification & implementer's interpretation* on trial against the customer/world):
     > "At best, integration testing shows that the modules together satisfy the implementer's interpretation of the specification. The implementer may have misinterpreted the specification or neglected to test some portion of its behavior, though, and the customer therefore needs some other basis for deciding whether or not the program does what it is supposed to do. This typically takes the form of acceptance tests. Acceptance tests provide an evaluation of the program behavior that is independent of the design, and they are generally performed by an organization different from the one that worked on the design and implementation. They should include both trial runs under conditions approximating those the customer will actually encounter and tests derived directly from the requirements specification." (Ch. 12.1, pp. 251–252; `L527–L529`)
     > "Program verification can ensure that a program meets its specification, but it is not generally practical today, and even if it were, it would still find errors much too late in the program development process. ... One can never be absolutely certain that a requirements specification describes the exact product the customer wants." (p. 252; `L529`)

*Bearing on `verisectorium` (my reading):* Look at `note 30` §2's three steps (`Made off to the side` → `Checked on its own premises` → `Reflected into the whole on the whole's terms`). Step 2 is **unit validation** (premises held fixed); Step 3 is **integration validation** (catching clashes where two pieces each satisfied their own premises yet fail to compose). Neither step by itself performs **acceptance / fitness validation** against the external purpose/world — which is exactly what `PRIMER.md` surfaced as *"The wrong universe was pushing back"* (formal builds and consistency checks find edge cases forever without saying which matter; *use* does). Treating unit / integration / acceptance as three distinct kinds of checking — differing in *what is held fixed* and *who has standing to run it* — sharpens both `udon`'s three failure modes and `verisectorium`'s checking model.

---

### 6. Decomposition ≠ Abstraction (Ch. 1.2.2), Rep Invariants, Benevolent Side Effects, and `equal` vs. `similar` (Ch. 4.5, 4.9.5)

Three compact conceptual tools from Chapters 1 and 4 sharpen existing `verisectorium` questions:

1. **Decomposition is NOT abstraction (Ch. 1.2.2, pp. 8–9; `L41–L43`).**
   L&G give two rules for using a specification: (1) assume the postcondition holds; (2) *"We can assume only those properties that can be inferred from the post-condition."* Then:
   > "This insistence on forgetting information is what distinguishes abstraction from decomposition." (pp. 8–9; `L41–L43`)
   > "The most common problem [with decomposition] is creating individual components that solve the stated subproblems but do not combine to solve the original problem." (Ch. 1.1, p. 3; `L31` — illustrated by assigning different writers each character's lines in a play!)

   *Bearing on `verisectorium` (my reading):* Cutting a 115-line segment into 65 veritoids (`questions-asked.md` L33) is **decomposition**. Allowing an arriving reader or downstream piece to rely *only* on an outline/summary/statement without reading inside the 65 veritoids is **abstraction** (forgetting internal detail behind an explicit barrier). Confusing the two explains why fine-grained decomposition alone *increases* reader burden instead of reducing it!

2. **Rep Invariant minimality & Benevolent Side Effects for renderings vs. versions (Ch. 4.5.2, 4.5.4; pp. 75, 77–78).**
   - On how much belongs in a representation invariant:
     > "A rep invariant should express all constraints on which the operations depend, but it need not state additional constraints. ... A good way to think of this is to imagine that the operations are to be implemented by different people who cannot talk to one another; the rep invariant must contain all the constraints that these various implementers depend on." (Ch. 4.5.2, p. 75; `L175`)
     *Bearing:* Under total agent turnover, independent sessions/tools literally *are* "different people who cannot talk to one another." That gives a clean minimality rule for `bin/defs check` and ontology schemas: check *everything* tools and arriving minds rely on, and *nothing* merely conventional.
   - On **benevolent side effects** (Ch. 4.5.4, p. 78; `L181`):
     > "Such side effects are often performed for reasons of efficiency. They are possible whenever the abstraction function is many-to-one, since there are then many rep objects that represent a particular abstract object. Sometimes it is useful within an implementation to switch from one of these rep objects to another. Such a switch is safe since the rep still maps to the same abstract object."
     *Bearing:* Answers `questions-asked.md` Addendum 13.8 ("Is a reflowed paragraph a new version?"): a markdown file on disk is a `rep` of an abstract veritoid; the normalization map `A: FileBytes -> AbstractVeritoid` is many-to-one, so `md-press` unwrapping or formatting cleanup is literally a **benevolent side effect** (`A(r_1) = A(r_2)`) that preserves version identity without invalidating checks!

3. **`equal` (object identity) vs. `similar` (value equivalence) (Ch. 4.9.5, pp. 93–94; Ch. 10.2, p. 209).**
   > "We have adopted a convention of reserving the equal operation for the equality relation; that is, it should be impossible to distinguish between two equal objects. Therefore, two mutable objects can be equal if and only if they are the very same object; otherwise we could distinguish them by applying a mutating operation to one and not the other. ... We use the name similar for the operation that captures the relationship between [two distinct objects; OCR: 'a and /?'], namely, the fact that the two objects contain similar values." (Ch. 4.9.5, pp. 93–94; `L211–L213`)

   *Bearing:* Directly echoes `core/`'s separation of **minted `identity`** (`x_obj = y_obj`, surviving edits so findings/questions stay attached) from **content `version`** (`x = y`, value equivalence).

---

## Part III · Where Liskov & Guttag Does *Not* Transfer (and Where `udon` / `verisectorium` Have Already Moved Past It)

Honest scoping matters so we don't import 1986 assumptions that hurt live work:

1. **Top-down idealized design process (Ch. 12–13) does not fit novel-model discovery.**
   L&G explicitly acknowledge their design chapters are idealized (*"Our presentation idealizes the design process; for example, no design errors are made"*, Ch. 13.4, p. 274; `L573`) and argue strongly for top-down design (*"Bottom-up design is not really a tenable process for any but the smallest programs"*, Ch. 13.9, p. 293; `L611`), even while admitting in passing that real work goes back and forth (p. 293) and that traits and interfaces are developed in tandem (p. 216).
   `verisectorium/msc/scratch/vision-2026-11-21/how-models-get-made.md` is already well ahead of L&G here: protocol studies (Guindon, Goel, Ball et al.), Schön, Knuth, and Lakatos show that for *new* notations and ontologies, premature formalization suppresses lateral moves and the problem/intention co-evolve with concrete cases. **Take L&G's *artifact structures* (two-tiered specs, specificand sets, coherence checks, marked redundancy), not their top-down discovery narrative.**

2. **Binary satisfaction, no graded warrant, no turnover decay, no multi-reader projections.**
   L&G's world is binary (`m ∈ SpecificandSet(S)` or not; `TRUE = FALSE` or consistent) with persistent human engineers for whom *writing* documentation is the bottleneck (p. 292: *"Because such documentation is difficult and time consuming to produce, it is often neglected"*). They have no machinery for:
   - graded credence or the `found out` vs. `decided` atom split (`lean` vs. `ruling`, `RFC 2119 SHOULD`, `lapsed checks`, `waivers`);
   - independent vs. correlated lines of evidence (same-model echo chambers);
   - turnover-driven information decay (`der-turnover-information-recursion`, Naur's theory death, Thurston's unlearnability);
   - multiple canonical outlines/projections over one shared pool of atoms;
   - the inverted agent economics (`PRIMER.md`, `outside-fields.md` §6) where *writing* is nearly free and *reading/checking attention* (especially the steward's) is the binding scarcity.

3. **Program-module mechanics vs. declarative document notations.**
   Much of Chapters 2, 4.2, 7, and 15 concerns imperative/object-oriented runtime mechanics (`modifies`, mutable aliasing, heap vs. stack allocation, CLU `up`/`down`/`cvt`, Pascal conventions). Those apply if/when someone designs a mutable UDON DOM/AST *library API* in Rust or Ruby, not to UDON's core declarative syntax-to-AST specification.

4. **Note on the "three senses of abstraction" (`spec-notes.md` vs. L&G).**
   The lecture transcript's lexical split — (v) forgetting details to treat different things as the same, (n) the resulting artifact, (n) a language feature/method for abstracting — is a clean teaching frame, while L&G's own primary taxonomy in Ch. 1 (pp. 3–10) cuts orthogonally:
   - **Process**: many-to-one mapping that *forgets* irrelevant detail (distinguishing abstraction from *decomposition*).
   - **Two methods**: *abstraction by parameterization* (forgetting actual data identities) vs. *abstraction by specification* (forgetting how behavior is realized).
   - **Three kinds**: *procedural*, *data*, and *iteration* abstractions.
   Holding both cuts together is useful: the lecture's three senses prevent word-sense collisions in conversation, while L&G's `decomposition ≠ abstraction` prevents mistaking fine-grained slicing for genuine complexity hiding.

---

## Part IV · Reading Ledger

*Source file:* `/Users/josephwecker-v2/.gemini/antigravity-cli/brain/81d949a9-1e64-4240-8436-72bd4fdae6f4/scratch/liskov-guttag-B.txt` (964 lines; extracted from `/Users/josephwecker-v2/src/_ref/books/1986-liskov-guttag-abstraction-and-specification-B.djvu`).

**Read whole, myself:**
- Front matter: Title/copyright, Table of Contents, Preface, Acknowledgments (`L1–L26`, pp. i–xvii)
- **Ch. 1** Introduction (`L27–L48`, pp. 1–11)
- **Ch. 3** Procedural Abstraction (`L105–L136`, pp. 40–55)
- **Ch. 5** Exceptions (`L223–L258`, pp. 99–117)
- **Ch. 6** Iteration Abstraction (`L261–L284`, pp. 118–129)
- **Ch. 8** More on Specifications (`L325–L346`, pp. 150–160)
- **Ch. 10** Writing Formal Specifications (`L399–L462`, pp. 187–218)
- **Ch. 12** A Preamble to Program Design (`L527–L554`, pp. 251–264)
- **Ch. 14** Between Design and Implementation (`L615–L648`, pp. 295–311)

**Read in substantial part, myself:**
- **Ch. 4** Data Abstraction: §4.1–4.5 (`L137–L182`, pp. 56–78) and §4.9–4.10 (`L199–L218`, pp. 87–96). Skipped §4.6–4.8 CLU list/olist implementation code (`L183–L198`).
- **Ch. 9** Testing and Debugging: §9.1–9.3 (`L347–L376`, pp. 161–175) and §9.5–9.6 (`L389–L398`, pp. 182–186). Skipped §9.4 Debugging (`L377–L388`).
- **Ch. 11** A Quick Look at Program Verification: §11.4–11.6 (`L505–L526`, pp. 240–250). Skipped §11.1–11.3 Hoare-logic straight-line/loop/procedure proof rules (`L463–L504`).
- **Ch. 13** Design: §13.1–13.6 (`L555–L584`, pp. 265–279) and §13.9–13.10 (`L601–L614`, pp. 288–294). Skipped §13.7–13.8 detailed `doc`/`line` CLU specs (`L585–L600`).
- **Ch. 15** Using Other Languages: opening & §15.1 start (`L649–L652`, pp. 312–313).

**Not read:**
- **Ch. 2** An Overview of CLU (`L49–L104`, except opening `L49`)
- **Ch. 7** Using Pascal (`L285–L324`)
- **Ch. 15** §15.1–15.3 remainder (`L653–L670`)
- **Appendices A, B, C** (CLU Reference Manual, Formatter Implementation, Programming Assignments) and Index (`L671–L964`).

**Repo files read whole for grounding:**
- `udon`: `spec-notes.md`, `spec/canonical.outline.md`, `DECISIONS.kdl`, `spec/def/{AST,element,root}.md`, `spec/.kinds/term.kdl`, `spec/.influx/{defining-udon.md,spec-lite-incoherences-2026-11-07.md}`.
- `verisectorium`: `msc/scratch/vision-2026-11-21/PRIMER.md`, `core/model.outline.md`, `core/src/{intro-spine,disc-record-surfaces}.md`; plus substantial portions (first 46 KB each) of `vision-2026-11-21/{00-working,outside-fields,how-models-get-made,cold-reader,asf-bearing,questions-asked}.md`, `msc/notes/30-2026-11-19-model-in-a-nutshell-after-four-stores.md`, and `msc/notes/30-addendum.md`. (Not read: `udon/.archive/sessions/2026-11-20-v2-clean-slate-12b5188c.md`, `verisectorium/core/def/*.md`, and the trailing footnotes/sections past 46 KB in the long `vision-2026-11-21` files.)
