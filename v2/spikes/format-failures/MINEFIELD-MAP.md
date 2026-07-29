# The minefield map — where prior document formats died, and why

**What this is.** A first-principles account of the failure modes in the SGML/XML lineage, the config-serialization family, the semantic-web/identity line, the lightweight-markup family, and the database data-model lineage — written for the UDON schema, paths, and dialect design work, which will read it as its map of where prior travelers died.

**The commission, in the steward's words.** *"…do a literature pass and history pass and try to analyze where xml and other document formats failed — in terms of first principles wherever possible — i.e., based on what can be discovered from an ASF perspective, or hypothesized as having an ASF-related cause. But in general, it would give us a more complete map of the minefields. (I'm not really interested in marketing or why something failed to gain mindshare, except when that seems to be a direct result of obtuseness)."*

That filter is load-bearing and applied throughout: **a format losing is not a finding; a format losing because a design commitment made some property unobtainable is.** Where a mindshare failure appears below, it is because the obtuseness itself was the cause.

**The one-paragraph version.** The formats in this record did not mostly die of complexity, verbosity, or bad marketing. They died of five recurring structural moves: (1) asking a parser to recover a latent the document does not determine; (2) failing *silently* rather than failing *loudly*, which converts a small error into confident wrongness downstream; (3) answering four structurally different malformation regimes with one response; (4) buying extension guarantees with conventions, which are behavioral bounds that are worthless the instant anyone defects and indistinguishable from compliance when they do; and (5) making non-additive changes to a corpus whose settling time is unbounded. UDON is structurally defended against (1), (2), (4), and (5) — genuinely and by construction, not by discipline. It is **not** defended against (3), it has a residual exposure on (1) it has not named, and its two largest open holes (the dialect layer and the schema layer) sit exactly where the next class of failures lives.

---

## 0. How to read this

**Registers.** Every claim carries one of four marks. They are the difference between something you can build on and something you should attack:

| Mark | Means |
|---|---|
| **[derived]** | Follows from an ASF/AAT result, with the segment named, at *that segment's own tier*. Never upgraded. |
| **[evidenced]** | Rests on a primary historical source — spec text, working-group archive, designer retrospective, measurement paper — fetched and cited. |
| **[hypothesized]** | My inference. Structurally motivated, **not** verified. The prescriptions marked this way are the ones most worth attacking. |
| **[recalled]** | Rests on my training rather than a fetched primary. *Training recall — verify before external citation.* |

**Theory discipline.** ASF segments are cited by slug. Where a segment was read whole, the claim carries its stated tier. Where I worked from an OUTLINE row or the `theory-of-agentic-tooling` survey rather than the segment, I say so inline — an index line is evidence one does *not* hold the content, and several of the connections below would be worth more if someone pulled the segment before building on them (§5 lists which).

**Evidence base.** Primary sources fetched during this pass are cited inline. Deeper per-family citation substrate is being gathered into `evidence/` alongside this file; §5 records what landed and what did not.

**Structure.** §1 is the map, stated as conclusions. §2 works each mine at mechanism depth. §3 is where UDON is already standing on one. §4 is the spike register — candidates chased and killed, kept visible with reasons. §5 is coverage and what I could not reach. §6 is what I would do next.

---

## 1. The map — twelve mines

Each line is a failure *mechanism*, not a format. Instances are illustrative; the mechanism is the claim.

**M1 — Type-sniffing is an identifiability floor, not a difficulty.** A format that infers a value's type from bare content asks a parser to recover a latent (what the author meant) that its observations (the characters) do not determine. That is a rank deficiency, and no reparameterization — no cleverer heuristic, no longer exception table — recovers a flat direction. Only *rank augmentation*, i.e. new evidence written into the document, escapes. Every sniffing format therefore faces permanent pressure to add rules, and every added rule retroactively retypes documents that already exist. **[derived]** from `#disc-identifiability-floor`.

**M2 — The lethal corner is silent-and-unspecified, not strict-or-lenient.** The historical debate was framed as reject-versus-recover. The repair-relevant axis is *loud versus silent*. A silent misparse does not merely cost the reader time — it leaves the reader confident, which drives its update gain toward zero, so it stops correcting *even when wrong*. Confident wrongness is a structural-failure signature and the one thing no downstream tooling detects. **[derived]** from `#der-code-quality-as-observation-infrastructure`.

**M3 — Malformation arrives in four repair-distinct regimes; every format in the record answers with one or two.** Arrivals partition into informative / magnitude-shock / structural-shock / ambient-erosion, and the repairs are *different in kind* — ordinary update, more capacity, a different model class, and filtering below the reader. Collapsing them is the canonical mis-diagnosis. Warning fatigue is not an annoyance; it is the fourth regime, and it is a genuine attack surface. **[derived]** from `#der-interaction-channel-classification`; the prescription is **[hypothesized]** and is the sharpest new thing in this document.

**M4 — Conventional extension mechanisms buy a behavioral bound; structural ones buy a certificate — and the certificate's truth is a step function while the leak is continuous.** This is *why* extension namespaces fail slowly and invisibly: near-compliance leaks almost nothing while proving nothing, so the guarantee is gone long before anything breaks. **[derived]** from `#disc-w1-structural-bound-boundary`; **[evidenced]** by RFC 6648.

**M5 — A corpus has unbounded settling time, so the admissible spec-change rate is effectively zero unless the change is additive by construction.** Multi-timescale stability gives a closed-form threshold: the slow layer may move only as fast as the fast layer's spare capacity to chase a shifting target. Nobody rewrites the world's existing documents, so that spare capacity is near zero, and any meaning-changing spec move is a permanent violation. **[derived]** from `#der-multi-timescale-stability` (status: exact).

**M6 — Unbounded construct extent makes error localization intractable, and localization is an observability *design* problem, not an algorithm problem.** A construct that can span arbitrary distance converts a one-character mistake into a diagnosis with a document-sized blame radius. Exact attribution is genuinely hard; an artifact with observable, bounded intermediates sidesteps the intractability entirely. **[derived]** from `#disc-credit-assignment-boundary`.

**M7 — Verbosity is a budget with a formal name, and so is spec length.** For a context-bounded reader, document bytes compete with model detail and task specification under one capacity. Separately, conveying a format to an implementer is bounded below by the residual information given shared context — so a grammar that needs tens of thousands of words to pin down is reporting a fact about *itself*, not about its documentation effort. **[derived]** from `#obs-context-turnover` and `#result-specification-bound`.

**M8 — Stacking validators that read the same declaration does not add adaptive tempo; it saturates.** Correlated channels drawing on one source overcount, and under shared persistent bias they saturate at the shared-bias floor. Four checkers over one schema are one channel wearing four badges: a wrong declaration passes all of them. **[derived]** from `#deriv-tempo-additivity`.

**M9 — An unresolved reference is an unobservable edge, and unobservable edges freeze.** A cross-reference nobody resolves generates no feedback, so its errors never surface and its quality is never measured. **[derived]** from `#der-observability-dominance` (OUTLINE/dossier weight — see §5), applied **[hypothesized]**.

**M10 — Formats die at merges of repair-distinct things.** The recurring lethal move is not complexity; it is collapsing two things whose remedies differ, which hides *which problem you have*. Attribute-versus-element; "invalid" covering both unparseable and not-allowed; one number type covering integer and float; last-wins covering two assertions. **[derived]** from `#disc-anti-collapse`.

**M11 — A grammar defined by an implementation has no fixed point.** When the normative artifact is a program, every divergence is simultaneously a bug and a feature, and the cost of later specification scales with accumulated ambiguity rather than with the language's size. **[evidenced]** by CommonMark.

**M12 — The format security record is one shape: a lexical channel carrying both content and instruction.** Entity expansion, external-entity resolution, type-tag deserialization, template injection. Escaping asks every implementation to behave; positional commitment proves the instruction cannot arise. By M4's mechanism the difference is a certificate, not a marginal safety delta.

---

## 2. The mines at mechanism depth

### M1 — Type-sniffing is an identifiability floor

**The record.** The canonical instance is YAML's Norway problem: a configuration listing country codes `GB, IE, FR, DE, NO` parses as `['GB', 'IE', 'FR', 'DE', False]`, because `NO` matches YAML's boolean production. StrictYAML's author states the decisive fact plainly — **[evidenced]**:

> "The most tragic aspect of this bug, however, is that it is *intended* behavior according to the YAML 1.2 specification. The real fix requires explicitly disregarding the spec."
> — *hitchdev.com/strictyaml/why/implicit-typing-removed/*

That sentence is the finding. This was not a parser bug that a conformant implementation avoids; conformance *is* the bug. StrictYAML's response is categorical rather than corrective — everything is a string unless the schema says otherwise — and the reason it must be categorical is the mechanism below.

The family is larger than YAML: the sexagesimal, leading-zero, and version-string cases in the same lineage; JSON's single number type collapsing integer and float; CSV's absence of any type layer pushing the same inference into every reader; and the spreadsheet-genome case, where a general-purpose sniffing tool silently retyped a scientific corpus at scale. **[recalled]** for the last two — *training recall — verify before external citation.*

**The mechanism.** The parser is asked to recover a latent — the author's intended type $T$ — from an observation, the character sequence. Sniffing formats make that map non-injective: the string `"NO"` and the boolean `false` produce the *same* observation. The two candidate values lie on an indeterminacy manifold along which the parser's information operator is flat.

This is structurally Instance 2 of `#disc-identifiability-floor` (tier: *exact*, via Cramér–Rao): a mixture whose parameters are unidentifiable from single-channel observation, because the Fisher information is rank-deficient and the null directions correspond exactly to the perturbations that preserve the observable.

The consequence that matters is the *irreducibility*, and the segment names its mechanism precisely — Sylvester's law of inertia:

> "you cannot survey your way out of a blind spot by changing the units on the ruler; you have to look from a new vantage point"
> — `#disc-identifiability-floor`, Findings

Every heuristic refinement a sniffing format adds — a longer exception table, a smarter regex, a "context-aware" resolver — is a *reweighting*. Reweightings act on the information operator by congruence, and congruence preserves inertia: the flat direction stays flat in every coordinate system. **The only escape is rank augmentation — a genuinely new score component, which for a document format means new characters written into the document.** Quotes, tags, envelopes. **[derived]**

**The precise boundary — when sniffing is safe.** The floor bites only where the syntactic classes *overlap*. TOML sniffs dates and integers and is not notorious for it, because TOML requires strings to be quoted: the bare space is partitioned, the map is injective, and there is no flat direction. JSON is safe for the same reason. YAML's fatal combination was permitting unquoted strings **and** sniffing types out of the same space. So the honest general statement is:

> Sniffing is safe iff the bare syntactic classes are pairwise disjoint — which in practice means the unquoted-string class must be empty or lexically separated. **[derived]**

This is worth stating carefully because **UDON permits unquoted strings and sniffs six bare types out of the same space**, which places it structurally on YAML's side of that line, not TOML's. §3.1 takes this up; it is the one place where a load-bearing UDON commitment sits on a mine it has not named.

**Why "frozen forever" is the right shape, and a corollary I have not seen stated.** UDON's stated defense is that the bare set is closed and all further typing happens inside `<…>` envelopes, so a dialect *cannot reach* bare space (`RATIONALE`, via the primer §4.1). Note what makes that defense strong: it is structural, not disciplinary — it does not ask dialect authors to be careful.

But there is a second reason to freeze, which follows from the escape's own structure. The escape from the floor is author-side: the author writes quotes. That only works if the author can *predict* whether their token will be sniffed. Predicting that is itself an inference whose difficulty grows with the size of the type table — in the specification-bound vocabulary, the residual information $H_{\text{req}}$ an author needs before writing a bare token. An open type set makes that prediction unbounded and therefore unreliable; a closed six-element set makes it learnable once.

> **The frozen-bare-set commitment is not conservatism. It is the only setting at which the author-side escape from the identifiability floor stays reliable.** **[hypothesized]** — derived from `#result-specification-bound`'s $H_{\text{req}}$ structure applied to the author rather than the implementer, which is an extension of that segment's frame, not a reading of it.

---

### M2 — The lethal corner is silent, not lenient

**The record.** XML's draconian error handling — any well-formedness violation is fatal, and a conforming processor must "not continue normal processing" — was decided by a 7–4 vote of the working group after what Tim Bray calls "a really big, really long, really passionate argument… some weeks and some hundreds of emails" between camps named the Draconians and the Tolerants (tbray.org, *History of XML Error Handling*, 2004-01-16). **[evidenced]**

The rationale is the interesting part, and it is not what the folk history says. In Bray's own annotation to the XML 1.0 spec, the argument that carried was **implementation economics**: without strict enforcement, error-handling bloat would make XML implementations prohibitively large, defeating the goal of code that could "be transmitted across the Web and execute on a large number of desktops." He names the cost in the same breath — **[evidenced]**:

> "It is directly contradictory to the spirit of HTML, where tool vendors compete on their ability to handle egregiously broken pages."
> — Bray, annotation to XML 1.0, *xml.com/axml/notes/Draconian.html*

**The mechanism, and why the debate was on the wrong axis.** Reject-versus-recover is not the repair-relevant partition. The partition that matters has three occupied corners:

| Corner | Reader's epistemic state | Instances |
|---|---|---|
| **Loud + halt** | Knows it failed; knows where | XML well-formedness |
| **Loud + recover** | Gets a document *and* knows what happened | HTML5 parsing; UDON's anomaly channel |
| **Silent + unspecified** | Gets a wrong document and does not know | YAML implicit typing; CSV; JSON number coercion |

The third corner is the lethal one, and **nobody argued about it, because it does not look like error handling at all.** It looks like a feature.

The formal reason is the *zero-mismatch ambiguity* in `#der-code-quality-as-observation-infrastructure`. Update gain is $\eta^\ast = U_M/(U_M + U_o)$. A silent misparse hands the reader a document that *looks* clean: observation noise $U_o$ is high (the text did not mean what was recovered) while the reader's own model uncertainty $U_M$ is spuriously *low* (nothing signalled a problem). The segment states the consequence directly:

> "bad code does not just slow comprehension — it *hides* miscomprehension. In gain terms, when $U_o$ is high and $U_M$ is low (spurious confidence), $\eta^\ast \to 0$ — the agent stops updating even when its model is wrong."

An agent — or a person — that has stopped updating cannot be rescued by better tooling downstream, because the correction channel it would arrive through is the one that closed. This is why the Norway problem is categorically worse than a parse failure even though a parse failure is louder and more annoying: annoyance is a signal; silence is not.

**The reframe of HTML5, which I think is the strongest single historical reading in this document.** HTML5's contribution is usually described as leniency. That is not what it did. Its contribution was to **specify** the recovery — to write down exactly what every parser must produce from broken input, so that all readers agree. In κ×A vocabulary (`#scope-observation-ambiguity-modulation`, conditional theorem): implementation divergence over malformed input is precisely observation ambiguity $\mathcal{A}$ — the same observation supporting systematically different readings. Specifying recovery drives $\mathcal{A} \to 0$ without making the format stricter.

> HTML5 did not move along the strict↔lenient axis at all. It moved from the silent-and-unspecified corner to the loud-and-specified one, which is an ambiguity reduction, not a strictness change. **[derived]**

That matters for UDON because it means "keep everything and warn" is only half the commitment. The other half — the one that does the real work — is that the *recovery itself* is specified, so two conforming recognizers produce the same model and the same anomalies from the same broken input. UDON has this (`SEMANTICS.md` specifies an equivalence relation; keep-everything responses are normative per `CORE §14.1`). It is worth naming as the load-bearing half, because a reader could easily take "keep everything" as the point and treat the specification of *what* is kept as detail.

**The obtuseness finding.** Draconian error handling was argued and won on 1997 implementation-size economics — a constraint that evaporated within a decade — and the working group explicitly knew it contradicted the practice of the most successful document format then in existence. That is the steward's exception clause: a design that lost on the merits later, for a reason its authors named at the time, because the winning argument was contingent on a constraint nobody re-examined. **[evidenced]** for the record; the causal reading is **[hypothesized]**.

---

### M3 — Four repair regimes, two severities

**The theory.** `#der-interaction-channel-classification` (status: *conditional*; exact for its Kalman worked case) partitions arriving events by three independent boundary tests into four regimes with *structurally different repairs*:

| Regime | Condition | Repair |
|---|---|---|
| **I — informative** | within capacity, representable, above the noise floor | ordinary update; *contributes negatively* to disturbance |
| **II-a — magnitude shock** | exceeds correction capacity | more bandwidth / capacity |
| **II-b — structural shock** | exceeds the model class | **a different model class; more capacity does not help** |
| **III — ambient erosion** | below the observability floor | **filtering below the reader** |

The segment's central line — "the emitter sees a scalar; the recipient sees a regime" — is exactly the format situation. A parser emits an anomaly; what the *consumer* needs is the regime, because II-a and II-b "produce similar pain signals but admit opposite cures."

The organizational gloss in the same segment translates directly to a document toolchain: *heard* (I), *shattered by shock* (II-a), *couldn't hear* (II-b), *absorbed as fatigue* (III).

**The record.** Every format in this survey answers with one response or two. XML: fatal, or (for validity) invalid. YAML: exception, or silence. JSON: exception. Schema validators: error/warning. **No format in the record distinguishes "your document is malformed" from "your document is fine but my model of documents cannot represent it" — which is the II-a/II-b distinction, and the one where the repairs are opposite.** **[hypothesized]**, based on this survey's coverage; a counterexample would be genuinely interesting and I did not find one.

Regime III is the one with the strongest historical evidence and the least design attention. Warning fatigue in compilers and linters; XSD validators producing error cascades where one root cause yields hundreds of derived complaints; deprecation-warning floods. The theory says this is not an annoyance but a *drain on adaptive reserve*, and that the repair is structural: aggregate below the reader and escalate only on threshold crossing, rather than making the reader parse every event. The segment's own security reading is that a low-priority-alert flood is a genuine attack, "not because individual events are significant but because processing them consumes tempo that should go to actual work."

**The prescription, and its anti-collapse check.** UDON defines severity by *loss*: warning = everything kept; error = something was lost. That is a well-chosen axis and I would not touch it. But loss and repair are orthogonal:

- a bare `NO` retyped is *lossless* and needs an author fix;
- a tab in indentation is *lossless* and needs a tooling fix;
- an unclosed fence is *lossy* and needs an author fix;
- a construct the recognizer version does not know is *lossy* and needs a **different recognizer** — the II-b case, where telling the author to fix their document is exactly wrong.

> **Proposal: anomalies should carry a repair class alongside severity — who or what must change for this to stop.** **[hypothesized]**

Running the anti-collapse diagnostic on this proposal, because the discipline demands it (`#disc-anti-collapse`: "there must be a tempting wrong merge"): the tempting merge is *"severity is the one axis, and repair follows from it."* It fails, because the four cases above cross severity and repair independently — two lossless anomalies routing to an author fix and a tooling fix respectively. The merge hides which one you have. That is an anti-collapse instance by the segment's own diagnostic, so the proposal is at least well-formed; whether it is worth the spec surface is a judgment I do not get to make.

A cheaper version worth considering first: mark each anomaly **root** or **derived**, so a cascade from one unclosed delimiter is not read as N independent problems. That single bit converts a manufactured Regime III flood back into a Regime I observation, and it costs one field.

---

### M4 — Conventions buy behavior; structure buys a certificate

**The record.** RFC 6648 (BCP 178, 2012) deprecates the `X-` prefix convention after roughly three decades of use, and its retrospective is a first-principles document in its own right — **[evidenced]**:

> "The primary problem with the 'X-' convention is that unstandardized parameters have a tendency to leak into the protected space of standardized parameters, thus introducing the need for migration from the 'X-' name to a standardized name."

and the outcome:

> "To preserve interoperability, newer implementations simply support the 'X-' name forever, which means that the unstandardized name has become a de facto standard"

with worked instances in FTP (`X`-prefixed commands recognized alongside standardized forms), HTTP (`x-gzip` and `x-compress` required to be treated as equivalent to `gzip` and `compress`), and email (`X-Archived-At` maintained beside `Archived-At`). The RFC's verdict: segregating the parameter space "provides minimal benefit while generating significant interoperability costs."

The same shape recurs in CSS vendor prefixes, where non-final experimental syntax became load-bearing on the live web and browsers ended up supporting competitors' prefixes. **[recalled]** — *training recall — verify before external citation.*

**The mechanism, which is the part the RFC does not have.** RFC 6648 documents *that* the convention failed and *how* it failed; it does not explain why the failure was invisible for thirty years. `#disc-w1-structural-bound-boundary` (status: *robust qualitative*, with the no-go itself exact) supplies that, and the transfer is clean.

The segment concerns when a wrapper's *structural* guarantee survives, and its finding is that the boundary is a **certifiability discontinuity, not a behavioral one**:

> "The behavior is continuous… The certificate's validity is a step. At $\varepsilon = 0$ the design-side certificate… is true. At any $\varepsilon > 0$ that same certificate is still computable and still asserts the same thing, but is now *false*."

and the practical corollary:

> "the value of enforcing exact statelessness across the call boundary is concentrated almost entirely in what it lets you *prove*, not in the marginal leakage it prevents… the thing being bought is a proof, not a meaningful behavioral delta."

Map it onto extension mechanisms. A *convention* ("private parameters start with `X-`") is a behavioral bound: it holds iff every implementer behaves, and its truth is not checkable from the design. A *structural* separation (a syntactic region that provably cannot host standardized names) is a certificate.

> The day the first `X-` header became a de facto standard, **nothing broke.** The behavior was fine; the guarantee was already gone. That is exactly the shape the theorem predicts — near-compliance is behaviorally indistinguishable from compliance while being certificationally worthless — and it is why extension-mechanism failures are always discovered a decade late. **[derived]**

**The design consequence, stated as a test.** For any extension mechanism, ask: *if one participant defects, is the defection detectable from the artifact alone?* If not, the mechanism is a convention and should be budgeted as one — expect permanent support of the escape hatch, and do not build guarantees on top of it.

UDON has one of each, and the contrast inside a single design is instructive:

- **A certificate:** dialects act only inside `<…>` envelopes, so a new dialect *cannot reach* bare space. Defection is not merely detectable — it is unrepresentable. This is the strongest structural commitment in the design.
- **A convention:** `$`-prefixed keys are "designated, not reserved — any `$` key is legal," with collision defence resting on `$` not being a bare-key character so the longhand needs quoting (primer §4.5, which correctly labels it "convention, not law"). Defection here is legal, silent, and undetectable from the artifact. §3.2.

---

### M5 — Corpus settling time makes non-additive change permanently unstable

**The theory.** `#der-multi-timescale-stability` (status: **exact** under premises S0–S4) gives a closed-form threshold for when stacked adaptive layers stay stable. Two interconnection terms couple the layers: the slow layer *moves the fast layer's target* (drag), and the fast layer's unsettled residue *contaminates the slow layer*. The conditions are

$$\text{(C1)}\quad \epsilon < \epsilon_{\max} = \frac{\Delta\rho_1^\ast}{L_h\, v_2^{\max}}, \qquad \text{(C2)}\quad \alpha_2 R_2 > \rho_2 + L_{21} R_1,$$

where $\epsilon$ is the timescale ratio, $\Delta\rho_1^\ast$ the fast layer's *spare* correction capacity, and $v_2^{\max}$ how fast the slow layer moves. The segment's own gloss: (C1) violated is micromanagement — "the target moves faster than the fast level's spare drain capacity"; (C2) violated is catastrophic forgetting.

**The mapping.** Slow layer = the specification. Fast layer = the ecosystem that must chase it — every existing document, every reader, every writer, every implementation. Then:

$\Delta\rho_1^\ast$, the ecosystem's *spare* capacity to absorb a moving target, is **very close to zero for any format with a live corpus**, because existing documents are not rewritten. Nobody goes back and fixes the world's files. So $\epsilon_{\max} \to 0$: the admissible rate of meaning-changing spec movement is approximately nil, permanently, regardless of how good the change is.

That is a derivation, not an analogy, of the rule everyone knows by instinct:

> **The only spec changes that do not consume ecosystem reserve are ones that cannot change the meaning of any existing document.** Additivity-by-construction is not politeness toward legacy users; it is the only setting where (C1) is satisfiable when the fast layer cannot re-settle. **[derived]**

**The record reads as the theorem predicts.** **[recalled]** for the specifics — *training recall — verify before external citation* — but the pattern is well known: XML 1.1 moved the spec and achieved near-zero adoption despite fixing real problems, because the ecosystem had no spare capacity for a change with no forcing benefit. JSON Schema's draft sequence (03 → 04 → 06 → 07 → 2019-09 → 2020-12) kept implementations permanently mid-chase, and large parts of the ecosystem simply stopped at draft-07 — the fast layer never converging is exactly the (C1) failure signature. YAML 1.2 restored a sane typing schema in the *spec* while implementations kept 1.1 resolution, which is the M4 story again: the certificate was restored on paper and remained false in the world.

**The warm-start refinement, which prices premature standardization.** The same segment derives that if the fast layer is already settled at composition time, the slow layer's requirement weakens; the gap between the cold-start and warm-start conditions is "the quantitative price of engaging the slow level before the fast level has converged: early action does not void the guarantee — it raises the slow level's required reserve from settled-residue size to worst-case-transient size."

Translated: **standardizing a design that has not settled does not merely risk being wrong; it raises the reserve the standard needs from residue-sized to worst-case-transient-sized.** That is a formal statement of a decision UDON has already made correctly — declaring 0.9.1 *semi-frozen and spec-only* while the territories churn is precisely holding the slow layer's sensitivity near zero during a high-transient period. Worth knowing it has a name.

**And one warning the segment carries that transfers sharply.** From the Tikhonov remark: *"Slowing the slow level helps only against (C1) violations, never against a fast level that has no settled state to offer."* For a format: slowing your spec cadence does nothing if the implementations have no settled behavior to standardize *around*. That is the bridge to M11 — Markdown's problem was never spec cadence.

---

### M6 — Blame radius is an observability design problem

**The record.** The recurring complaint is the same across families: an unterminated string, entity, or delimiter is reported at end-of-file rather than at the opener; a mis-indented YAML line produces a type error hundreds of lines away; a LaTeX macro error surfaces in an unrelated environment. **[recalled]**

**The mechanism.** `#disc-credit-assignment-boundary` establishes that exact per-edge attribution faces three independent barriers (#P-hardness, information-theoretic underdetermination, posterior correlation) — but delivers the practical insight that matters here:

> "credit assignment is primarily an observability design problem, not an algorithm design problem — an agent that designs its strategy with observable intermediates sidesteps the intractability entirely"

A format with unbounded construct extents is an artifact *without* observable intermediates: the parser cannot know whether the opener was wrong or the closer was missing, and the search space is the document. A format with declared, bounded extents makes the same question a lookup.

Note also the theory's *only* requirement on any attribution scheme: **directional fidelity** — the correction must be non-positively correlated with the current error. "Exact attribution, unbiased estimation, minimum-variance estimation, or optimality of any kind" are explicitly not required. For diagnostics this is liberating: an anomaly list does not have to be minimal or perfectly attributed to be useful; it has to point the right way.

**UDON's position is strong here and worth stating as vindication rather than assuming it.** The extent taxonomy (every construct declares geometric or delimited), the requirement that an unclosed delimited construct *cite its opener*, and bounded lookahead as language law together constitute exactly the "observable intermediates" prescription. The fail-safe rename on truncated identity (`$partial-key` rather than `$key`) is a second instance: it converts an unobservable failure (a truncated key that looks valid) into an observable one.

The residual risk is the flip side and belongs in §3: keep-everything means a single error can generate a large anomaly cascade, and nothing in the model currently distinguishes root from derived.

---

### M7 — Verbosity and spec length are budgets

**Two distinct bounds, often conflated.**

*Document size.* `#obs-context-turnover` gives the context window as a joint description-length budget: $\text{DL}(\Sigma_t) + \text{DL}(M_t) + \text{DL}(\text{task}) < C_{\text{context}}$ — a four-way pressure under one capacity (read at survey weight; see §5). For a context-bounded reader, document bytes are not competing with aesthetics; they are competing with the reader's model detail and its task specification. "XML is verbose" is a taste claim; "XML's closing tags consume a budget shared with the reader's ability to hold the task" is a structural one. **[derived]**

I want to be careful not to overclaim this. Verbosity was a real cost for human readers too, and the historical causal weight for XML's displacement sits across several factors this document deliberately does not adjudicate. What the theory adds is narrow and real: for the *agent* reader that UDON is partly designed for, the cost is a hard budget with named competitors rather than a soft annoyance.

*Spec size.* `#result-specification-bound` (status: *conditional* on premises S1–S2) bounds implementation time below by the time to transmit the distinguishing information given shared context, $H_{\text{req}}(F \mid M_{\text{shared}})/R_{\text{spec}}$, with the discussion note that "shared context acts as compression."

The reading that earns its keep: **a specification's length is a measurement of its subject, not of its author's diligence.** CommonMark needed tens of thousands of words to pin down a grammar whose original description fits on a page — and the spec's own introduction enumerates fourteen areas where the original "does not specify the syntax unambiguously," including questions as basic as how much indentation a sublist needs and what the precedence rules for inline markers are. **[evidenced]** (spec.commonmark.org). That length is a report on Markdown's grammar. A format whose spec cannot be short has an $H_{\text{req}}$ problem, and $H_{\text{req}}$ is paid by every implementer, forever, multiplied by the reader turnover.

---

### M8 — Redundant validators saturate

`#deriv-tempo-additivity` establishes that adaptive tempo is additive across channels *only* under cross-channel noise independence; correlated channels overcount, and under **shared persistent bias** the information **saturates at the shared-bias floor** (exact closed form via Sherman–Morrison in the common-source regime).

The format instance: DTD *plus* XSD *plus* Schematron *plus* application-level checks, all reading the same declaration, is one channel wearing four badges. Their shared bias is the declaration itself: **a wrong declaration passes all four.** Adding the fourth checker buys nothing measurable while feeling like defense in depth.

Genuinely independent channels for a document corpus — differing in what they read, so their failure modes do not coincide:

1. **declaration-conformance** (does the document match its schema),
2. **identity/reference integrity** (do references resolve; is `$key` unique where required) — independent because it reads the corpus, not the declaration,
3. **extraction-based drift** (does what consumers actually pull out still look right) — independent precisely *because it never reads the declaration*, which makes it the only channel that can catch the declaration itself being wrong,
4. **the human read.**

**[derived]** for the saturation result; the four-channel enumeration is **[hypothesized]** and is a direct prescription for whenever the schema layer lands: *count channels, not tools.*

---

### M9 — Inert references freeze

`#der-observability-dominance` — "unobservable edges freeze" (read at OUTLINE and dossier weight only; see §5) — says that an edge whose outcome is never observed receives no correction and its credence never updates.

A reference construct that nothing resolves is such an edge. No consumer resolving means no consumer discovering that a target is missing, misspelled, ambiguous, or has drifted. The errors accumulate silently and the layer's quality is *unmeasured*, which is a strictly worse epistemic position than measured-and-bad.

The historical record is consistent: link rot on the web, unresolvable identifiers in RDF corpora, dangling `id` references in HTML that no validator flags in practice. **[recalled]**

UDON's `@name[key].trait` is deliberately inert — recognized as a three-field selector, never resolved by the core, resolution left to a consumer menu, and the tuple frozen at three fields pending a path language. That is a defensible *deferral*, and the reasons in `CARVEOUTS` are good ones. The theory's contribution is to price the deferral rather than dispute it:

> **Ship one resolver early — even a trivial, obviously-incomplete one — not because resolution is needed yet, but because it is the only instrument that makes the reference design's errors observable while the design is still cheap to change.** **[hypothesized]**

The alternative is discovering the reference model's flaws after a corpus has been written against it, which by M5 is exactly when they become unfixable.

---

### M10 — The collapse catalog

`#disc-anti-collapse` (discussion-grade; instance set convergence-validated) names the pattern: a plausible model merges two things, and the merge is lethal because they route to *different repairs*. Its diagnostic — "there must be a tempting wrong merge" — is what separates an instance from an ordinary distinction.

Run over the format record it produces a catalog, and the catalog is more useful than any single entry:

| Merged | The two things | Different repairs | Instance |
|---|---|---|---|
| "attribute vs element" | *whose name is it* / *may the value be structured* | rename the edge / restructure the node | XML; forty years, no rule |
| "invalid" | unparseable / not-allowed | fix syntax / fix schema-or-content | XML *made* this split correctly and usage collapsed it anyway |
| "number" | integer / float | precision handling / range handling | JSON |
| last-wins | two assertions / one corrected assertion | keep both / supersede | YAML, JSON, most config |
| "text vs markup" | prose content / structural instruction | escape / restructure | the whole lightweight-markup family |

Three entries deserve comment.

**Last-wins is the best-evidenced entry in the table, and it is a clean M2 instance as well.** The YAML specification treats duplicate keys as an error; implementations disagree with the spec and with each other. PyYAML and js-yaml silently take the last occurrence; Go's `yaml.v3` errors; Symfony deprecated silent handling in 3.3 and made it throw in 4.0. **[evidenced]** The consequence at scale is documented in the largest natural experiment available — Kubernetes issue #14791, *"yaml and json parsers silently drop duplicate keys"*, filed 2015 and **still open**: a service selector written with two `track` keys parses cleanly, `kubectl apply` accepts it, and one value vanishes with no notification. **[evidenced]**

That case has every property M2 identifies as lethal. The document is *not* rejected. No anomaly is raised. The artifact looks correct on re-reading. The loss is invisible to backups, because the file on disk is fine — it is the *meaning* that was destroyed, and only in the reader. And it has survived a decade in the most heavily-tooled configuration ecosystem in existence precisely because nothing ever signals it.

This is the strongest available vindication of UDON's refusal of last-wins, and it is worth noting *why* the refusal is more than a preference: stacking is the only response in which the loss is representable at all. Under last-wins there is no severity to assign, because by the time any layer could judge, the evidence is gone. Under stacking, "only one allowed" becomes a schema question asked of a model that still contains both — which is the layer split doing real work rather than tidiness.

**Attribute-versus-element is the cleanest case in the record**, and UDON's design already contains the resolution: the question has no answer while it is one question, and acquires an obvious answer once split. The primer states the historical claim — restricting attributes to scalars was "XML residue, not a UDON decision," and once edges may terminate at nodes the structural pressure disappears. The anti-collapse lens adds *why forty years produced no rule*: the merge was tempting (both look like "where do I put this?") and the repairs were different, which is precisely the configuration that generates endless inconclusive debate rather than convergence.

**"Invalid" is the instructive counterexample.** XML got this split *right* — well-formedness and validity are distinct, specified, and separately reportable — and the ecosystem collapsed it anyway in speech and in tooling, where "invalid XML" routinely means "would not parse." **A format can make the correct split and still lose it to usage if the vocabulary does not carry the distinction.** **[hypothesized]** That is a naming problem, not a design problem, and it bears on UDON directly: the layer split (recognition / dialect / schema / host / consumer) is correct and load-bearing, and it will be collapsed in casual use unless the vocabulary is resistant. "Nothing is invalid at recognition" is exactly the kind of sentence that gets flattened to "UDON doesn't validate."

---

### M11 — A grammar defined by an implementation has no fixed point

**[evidenced]**, from CommonMark's own introduction: implementers resolving ambiguities consulted the reference `Markdown.pl`, "but it was quite buggy, and gave manifestly bad results in many cases, so it was not a satisfactory replacement for a spec." Fourteen enumerated ambiguity areas in a one-page original description; a decade of divergent implementations; a specification whose eventual length is the measure of the accumulated ambiguity.

The mechanism composes M5, M7, and M11 into one statement: with a program as the normative artifact, every divergence is simultaneously a bug and a feature, so there is no ground truth against which to converge — the multi-timescale reading of §M5 is a fast layer with **no settled state to offer**, and the segment's remark applies exactly: slowing the slow layer cannot help. The cost of eventually specifying scales with accumulated ambiguity, not with the language's size.

This is the strongest available argument for something UDON already does, and is worth naming so it does not get traded away under schedule pressure: **the spec is the conformance target and the reference parser is not.** UDON states this and currently *lives* it — the parser lags the spec, the divergence is tracked and named as lag, and `DELTAS.md` records intended differences. The failure mode to guard is not disagreement with the parser; it is the day a spec question gets settled by running the parser.

---

### M12 — Data/control merges, and why escaping is the weaker defense

**The record.** Entity expansion (billion laughs), external entity resolution (XXE), type-tag deserialization (`!!python/object` and its equivalents), and template injection are one shape: **a lexical channel in which content can become instruction.** In XML's case the mechanism was not an oversight but an inherited feature — SGML's entity machinery, retained and given a network reach. **[recalled]** for the security specifics — *training recall — verify before external citation.*

**The mechanism, and the defense taxonomy that follows from M4.** There are two families of defense, and they differ in kind rather than degree:

- **Escaping** is *behavioral*: it requires every implementation, at every boundary, on every path, to transform correctly. It holds exactly as well as its weakest implementation and its truth is not checkable from the artifact.
- **Positional commitment** is *structural*: the instruction-forming characters are simply not live in that position, so the dangerous construct cannot be *written*, let alone mis-escaped.

By `#disc-w1-structural-bound-boundary`, the difference is a certificate rather than a marginal safety delta — and the certificate's step-function truth explains the historical pattern: escaping regimes appear to work for years, because near-correct escaping leaks almost nothing, right up until an adversary looks for the one path.

**UDON's position, honestly.** UDON's marker discipline is a positional defense of exactly the strong kind: markers are live only at Structure Position, "the first ordinary prose word ends that state: from there, marker characters are literal," and `#`, `<`, and pipe-space have no meaning in text. Prose is opaque. There is one escape and its meaning is "fixed by **position** alone." Structurally this is the right family, and it is the reason UDON can host arbitrary prose — including prose *about* UDON — without an escaping regime.

Two punctures are worth naming rather than glossing, and they are in §3.5 and §3.6.

---

## 3. Where UDON is already standing on a mine

Stated as findings, not verdicts. Several of these are things the design has already reasoned about and accepted; the value here is naming which mine each acceptance is standing on, and what the failure would look like.

**3.1 — A residual Norway surface, unnamed (M1).** UDON permits unquoted strings *and* recognizes six bare types out of the same space. By the boundary condition in §M1, that is structurally YAML's configuration, not TOML's or JSON's: the bare classes overlap, so the identifiability floor is present. A bare `true`, `null`, `nil`, `false`, or anything matching the integer or float productions retypes silently, and the author-side escape (quoting) requires the author to know the collision exists.

The frozen-bare-set commitment **bounds** the exposure to six types forever, which is a genuinely different position from YAML's — the collision surface is fixed, small, and learnable, and it cannot grow. That is a strong mitigation and I do not think the design is wrong. But the primer's framing ("UDON's defense is structural, not disciplinary") is accurate about *dialect* typing and not accurate about the bare set, where the defense is a bounded-and-learnable disciplinary one. Worth saying precisely, because someone will otherwise read the envelope argument as covering the whole typing story. Also worth checking: whether the anomaly channel fires when a bare token is recognized as a non-string scalar in a position where a schema expects a string — that would convert the silent corner (M2) into the loud one at no syntactic cost.

**3.2 — `$`-designated keys are a convention, and RFC 6648 is the forecast (M4).** The primer is admirably honest that `$` keys are "designated, not reserved… convention, not law," with collision defence resting on `$` needing quoting in longhand. RFC 6648's thirty-year retrospective is the prediction: private `$`-keys will leak into the designated space, and the migration cost will be permanent dual support. The theory adds that the failure will be **invisible at the time it happens.** If a certificate is wanted rather than a convention, the structural move is a syntactic region that provably cannot host designated names — which is exactly what the envelope does for typing. Whether that is worth the surface is a judgment call; budgeting it as a convention is not.

**3.3 — Keep-everything can manufacture a Regime III flood (M3, M6).** A single unclosed construct under keep-everything can produce a large anomaly cascade. The model currently has no root/derived distinction, so a consumer sees N problems where there was one. That is a format *manufacturing* ambient erosion — the regime whose repair is filtering below the reader, which here means the recognizer, not the consumer. The one-bit fix (root vs derived) is cheap and would also improve M6's directional fidelity.

**3.4 — Two severities, four repair regimes (M3).** As above; severity-by-loss is a good axis and is not the repair axis. The II-b case in particular — a document the recognizer's model cannot represent — is the one where telling the author to fix the document is exactly the wrong repair, and it is the case a versioned format will hit constantly as documents outrun recognizers.

**3.5 — The ` ; ` carve-out punctures the positional certificate (M12).** UDON's marker discipline is structural with exactly one stated exception: a whitespace-framed ` ; ` opens a trailing comment *after* commitment to text. That is, by construction, a live control sequence inside content. The exposure is small and the ergonomic reason is obvious, but it is the difference between "no control characters in prose" (a certificate) and "one control sequence in prose" (a behavioral bound with one known case). Anyone generating UDON from untrusted text must escape or reject that sequence, forever, everywhere — which is the escaping regime the rest of the design avoids. Worth an explicit note wherever generation is discussed.

**3.6 — Interpolation and directives are an evaluation channel awaiting a dialect, and no dialect spike has ever run (M12).** `!{…}`, `!{{…}}`, and directives are carried by the core and given meaning by a dialect. That is the correct layering, and it means the core is not vulnerable. But the *shape* is template injection's shape, and the primer names the dialect architecture as "the largest named hole" with no spike ever run. Every historical instance of this shape — template engines, YAML type tags, XML entities — became a security incident at the layer that supplied the meaning, not the layer that supplied the syntax. Whatever the dialect spike is, this should be one of its first-class questions rather than a later hardening pass.

**3.7 — The schema layer has no carve-out entry, and it is where M5 and M8 bite next.** The primer's own appendix flags this: constraint is assigned to the schema layer in four separate places, and `CARVEOUTS.md` has no SCHEMA entry with a demand-side reason and closing condition. From this map's vantage that gap is more consequential than it looks, because the schema layer is where three mines converge — M5 (schema languages are exactly where non-additive versioning killed prior ecosystems; JSON Schema's draft churn is the live example), M8 (schema-derived validators saturate), and M10 (the recognition/validation split is the one XML got right and lost to usage).

**3.8 — Inert references freeze until something resolves them (M9).** See §M9's prescription: one trivial resolver, early, as an instrument rather than a feature.

**3.9 — Indentation-as-syntax: the case I expected to be counter-evidence is not, and the real lesson is different.** I went looking for the Sass indented-syntax → SCSS "reversion" as the strongest documented case against indentation-as-syntax. **It does not support that reading**, and the correction is worth recording because I would have propagated a false one.

Sass's own documentation presents both syntaxes as current and supported: SCSS "is a superset of CSS, which means essentially all valid CSS is valid SCSS as well… Because of its similarity to CSS, it's the easiest syntax to get used to and the most popular," while the indented syntax "supports all the same features as SCSS" and is nowhere deprecated or discouraged — "each one can load the other, so it's up to you and your team which one to choose." **[evidenced]** SCSS won on *migration cost from the incumbent*, not on any defect of indentation. Rename `.css` to `.scss` and it works.

That is a different finding, and a genuinely useful one, because it has a first-principles reading rather than a marketing one. Being a superset of an incumbent is the maximal $M_{\text{shared}}$ move: by `#result-specification-bound`, it drives $H_{\text{req}}$ — the residual information an existing user must receive — to approximately zero, and the specification bound says that residual is the *floor* on adoption cost. Nothing else a format does can compete with zero. **[derived]**

Two consequences for UDON, stated plainly because they cut both ways:

- The indentation commitment survives this pass **without** the counter-evidence I expected to find against it. The remaining objections in the record (transport mangling, mixed tabs, editor auto-indent) are real but were not gathered to a standard I would build on tonight — §5 keeps the gap open rather than closing it on one negative result.
- **UDON is a superset of nothing**, so it pays full $H_{\text{req}}$ with every reader, and no design elegance reduces that term. This is not a marketing observation; it is the specification bound saying that the adoption floor is set by residual information, and that the only lever on it is shared context. The lever UDON actually has is *familiarity of the pieces* — indentation from the config family, prose from Markdown, `:key value` from the config family — and how much of $H_{\text{req}}$ that borrowing discharges is measurable, not speculative. It is exactly the sort of thing a de-novo agent test would settle in one call.

**3.10 — "Git is the transaction log we never have to build" is half true, and the missing half is where the prior art spent its whole budget.** This one is aimed at `misc-db-theory.md` rather than at the spec, since that is where the claim lives.

The as-of half is genuinely free: `git show <ref>:<path>` is real, corpus-consistent, and shipped. The half that is not free is **record-grain diff and merge**, and the record here is one-directional. Every serious "git for data" system — Noms, Dolt (which began as a Noms fork), TerminusDB — found that git's own machinery operates at line-grain over files, and each responded by **building a content-addressed storage engine of its own** (the prolly-tree lineage) specifically to get diff and merge at record grain. Dolt "implements the Git command line and associated operations on table rows instead of files," and the engineering write-ups in that lineage describe resolving concurrent changes on a content-defined Merkle tree as "a deceptively challenging problem." **[evidenced]** at survey strength — I could not find a primary source that states *"git specifically fails because X"* in so many words, and I am recording that as a partial rather than dressing the inference up (§5).

The tension this creates is precise, and the design has already stated both sides of it without noticing they pull against each other:

- `misc-db-theory.md` thought #1 derives a hard constraint — **verbs must be stateless projections computed from the serving at call time, never a second store** — from the tempo-additivity result about correlated channels under shared persistent bias. That derivation looks right to me.
- The same document wants **history and blame at record grain** as a headline verb, on the argument that "nothing puts the record in the diff today; this does."
- The field's only production answers to record-grain diff are second stores. And the named escape hatch — incremental view maintenance — *is* a second store, which is exactly what the constraint forbids.

I do not think this is fatal, and the document's own "recompute-on-read is fine for years at this estate's scale" is probably correct. But the honest statement is that **the constraint and the verb are in tension, the tension is resolved today only by scale, and the field's experience is that it stops being resolved by scale sooner than people expect.** The staleness-detection carve-out (hash-pinning where materialization is unavoidable) is the right shape for when that day arrives, and it would be worth designing *before* it is needed rather than after — because by M5, a corpus written against the free version is exactly what makes the paid version unfixable. **[hypothesized]**

---

## 4. Spike register — candidates chased and killed

Kept visible with reasons, per the spike convention.

**Rejected: format injection as an instance of `#scope-channel-collapse`.** I initially routed M12 to channel collapse, which looked like an exact fit ("observation and action share one substrate"). Pulling the segment refuted it: its claim is that a logogenic agent's observation and action spaces are both $\Sigma^\ast$ *through one forward pass*, from which $\kappa_{\text{processing}} \approx 1$ follows by construction. That is a claim about an agent's internal architecture, not about a notation merging content and instruction. The resemblance is structural analogy, not instantiation, and citing it would have been exactly the failure the estate's discipline warns about — an index-level resemblance expanded into a confident false citation. **Rehomed** to `#disc-anti-collapse` (data and control are repair-distinct) plus `#disc-w1-structural-bound-boundary` (escaping is behavioral, position is structural), both of which the segments actually support.

**Demoted: "XML lost because it was verbose."** Verbosity is real and now has a formal cost (M7), but the causal weight in the record sits elsewhere, and the steward's filter excludes mindshare stories. Kept only in its narrow, defensible form: for a context-bounded reader, document size competes under a named budget.

**Reframed: "draconian error handling killed XHTML."** The primary record does not support the folk version. Draconian handling was argued and won on implementation-size economics, with the contradiction against HTML's practice named at the time by its own advocate. The axis that actually mattered was silent-versus-loud (M2), on which XML was on the *good* side — its failure mode was loud and stopped, which is recoverable. The formats that hurt people most silently are the ones nobody argued about.

**Weakened: my first framing of M5 as "the ecosystem chases the spec."** The cleaner mapping is that the *corpus* is the fast layer and cannot re-settle at all, which is what drives $\epsilon_{\max}$ to zero. The first framing would have suggested that a slower spec cadence is the repair; the theorem says slowing helps only against (C1) violations and cannot help a fast layer with no settled state — which is a different and more useful prescription (make changes additive; do not merely make them rarer).

**Open, not killed: whether UDON's two severities are actually under-resolved.** I believe the repair axis is orthogonal to the loss axis and have run the anti-collapse diagnostic on it (§M3), but "the distinction is real" and "the distinction is worth spec surface" are different claims and I can only support the first.

---

## 5. Coverage, and what I could not reach

**Method, and an honest report on it.** Six parallel evidence passes were commissioned across the format families (SGML/XML; semantic web and identity; config serialization; database lineage; lightweight markup; schema evolution and versioning). **All six failed, repeatedly, on server-side API overload, and none produced a file.** `evidence/` is empty except for a README recording exactly what was commissioned so the passes can be re-run without redesigning them. I retried each several times across the session; the failure was environmental and total.

Everything cited in this document was therefore fetched directly by me. **The theory analysis and the mechanism arguments in §2 are mine and were never contingent on those passes** — but the *breadth* of historical instance-grounding is well below what was scoped, and the register marks are load-bearing in a way they would not otherwise be. Where a claim says **[recalled]**, no one has checked it. Treat the density of **[evidenced]** marks as a map of where this document is actually strong: M1, M2, M4, M10, M11 are well-grounded; M6, M9, M12 rest more heavily on theory plus recall than I would like.

**Verified primary sources fetched directly during this pass:** Bray's *History of XML Error Handling* (2004) and his annotation on draconian handling in XML 1.0; RFC 6648 (BCP 178) on the `X-` prefix; StrictYAML's implicit-typing rationale; the CommonMark specification's introduction; Kubernetes issue #14791 on silent duplicate-key dropping (open since 2015) and the surrounding parser-divergence record (go-yaml #154, Symfony #19526/#19529); the Sass syntax documentation.

**Closed during the pass, one of them against my own expectation:**

- *Duplicate-key handling* — closed and strongly one-directional (§M10). The spec/implementation divergence, the parser disagreement, and the decade-open Kubernetes issue are all on the record. I still have **no counter-evidence in favour of last-wins**, and I now believe there is unlikely to be much: the mechanism that would produce it (silent convenience) is the same mechanism that makes the failure undetectable.
- *Indentation-as-syntax* — **partially** closed, and my hypothesis was wrong (§3.9). The Sass case I expected to be the strongest counter-evidence turns out to be about superset-migration economics, and Sass's own documentation deprecates neither syntax. The remaining objections are still ungathered, so the gap stays open — one refuted expectation is not a clearance.

**Not reached to a standard I would build on:**

- **Indentation-as-syntax, the remaining objections** (§3.9) — transport and copy-paste mangling, mixed-tab incidents, editor auto-indent interference, and any *measured* account of indentation-related authoring failure. Still the gap I would close first among the UX-bearing ones.
- **XML databases at depth** (MarkLogic, Tamino, eXist, BaseX) — the closest prior art to the document-corpus-as-database direction, and the place I most expect an uncomfortable finding. Entirely unexamined.
- **"Database in a git repo," at primary-source depth** — I got far enough to establish the shape (§3.10) but *not* far enough to find anyone stating plainly why git's own machinery is the wrong substrate. I looked and came up empty rather than inferring it; the Dolt engineering blog was the obvious place and did not say it. Someone should either find that statement or establish that it was never written down — both are useful answers.
- **RELAX NG's loss to XSD** — whether the reasons were technical, which bears directly on the schema-language design and is the single most decision-relevant unexamined question given §3.7.
- **Event-sourcing's documented pain points**, particularly the immutability/right-to-erasure collision, which is a hard external constraint the append-plus-supersede model may be walking into.

**Theory segments cited at less than segment weight** (pulled from `theory-of-agentic-tooling` or an OUTLINE row rather than the segment itself), which someone should verify before building on: `#der-observability-dominance` (M9), `#obs-context-turnover` (M7's budget half), `#der-turnover-information-recursion`, and `#deriv-tempo-additivity` (M8 — read via the survey's summary, which quotes the saturation result but not its conditions). The rest — `#disc-anti-collapse`, `#disc-identifiability-floor`, `#der-interaction-channel-classification`, `#der-code-quality-as-observation-infrastructure`, `#obs-software-epistemic-properties`, `#result-specification-bound`, `#disc-w1-structural-bound-boundary`, `#scope-observation-ambiguity-modulation`, `#der-multi-timescale-stability`, `#scope-channel-collapse` — were read whole.

**One thing I deliberately did not do:** adjudicate why XML lost to JSON, or why the semantic web did not achieve adoption. Both are mindshare questions, and the steward's filter excludes them except where obtuseness was the cause. Where I found obtuseness as cause (§M2's implementation-economics argument), it is reported.

---

## 6. What this map says to do next

In rough order of leverage, and all **[hypothesized]** as priorities — the underlying claims carry their own marks above.

1. **Name the residual bare-type collision surface explicitly in the spec** (§3.1), and decide whether the anomaly channel should fire on bare-token retyping in schema-typed positions. This is the one place a load-bearing commitment sits on an unnamed mine, and the fix may cost nothing.
2. **Make the dialect spike's first-class question the evaluation channel** (§3.6), not a later hardening pass. Every historical instance of that shape became an incident at the meaning-supplying layer.
3. **Add a SCHEMA entry to `CARVEOUTS.md`** with a demand-side reason and closing condition (§3.7). Three mines converge there and it is currently the only major deferred layer without a register entry.
4. **Ship one trivial reference resolver** as an observation instrument (§M9), before a corpus is written against the reference model.
5. **Consider the root/derived bit on anomalies** (§3.3) — one field, and it converts a manufactured Regime III flood back into a Regime I observation.
6. **When the schema layer lands, count independent channels rather than tools** (§M8), and treat extraction-based drift detection as first-class precisely because it never reads the declaration.
7. **Design the record-grain-history escape hatch before it is needed** (§3.10) — the "never a second store" constraint and the record-grain-diff verb are in tension that scale currently hides, and by M5 a corpus written against the free version is what makes the paid version unfixable.
8. **Re-run the six evidence passes** (`evidence/README.md`) when the API is healthy. The highest-value single one is schema-evolution, because §3.7 says the schema layer is where three mines converge and it is the next major layer to land; the most likely to produce an uncomfortable surprise is database-lineage's XML-database half.
9. **Close the remaining indentation objections** (§3.9) before the human-UX work commits further — noting that the one case I expected to be decisive against it turned out not to be.

---

*Written 2026-07-29 as the second artifact of the format-failures research thread, against `UDON-PRIMER.md` (this spike), `misc-db-theory.md`, and the ASF/AAT corpus. Registers are load-bearing; §4 and §5 are part of the finding, not apparatus.*
