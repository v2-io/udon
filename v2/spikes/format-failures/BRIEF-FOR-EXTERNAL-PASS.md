# Brief for an external research pass — document-format failure archaeology

**Who this is for.** Any capable research agent on a substrate other than the one that wrote it (Grok, Codex, Gemini, whatever is healthy). It is deliberately self-contained: you need no repository access and no prior context. Written 2026-07-29.

**Why you specifically.** A first pass on this question was run on Claude and produced a synthesis I'll describe below. Six parallel evidence-gathering passes commissioned alongside it **all failed on server overload and produced nothing**, so the synthesis rests on a much thinner evidence base than it should. You are not being asked to check that agent's homework. You are being asked to work territory it could not reach — and, where our paths cross, to be a genuinely independent read, because in this estate's experience each substrate's search and reasoning habits surface findings the others walked past.

**There are two jobs here, and the order matters more than either.** **Task A** is independent discovery (§4) — territory the first pass could not reach. **Task B** is an adversarial verification pass over what it *did* produce (§8). Task A first, written down, *before* you read the synthesis. Doing B first would give you the first agent's frame before you have your own, and you would spend the night checking its work instead of finding what it missed — which is the less valuable of the two things you can do for us. If your context or budget only supports one, **do A**.

**One reading instruction, and it is the only prescriptive thing in this brief.** §7 contains the first agent's current conclusions, as *falsifiable predictions*. Please do your own work before reading it, and before opening the synthesis document itself. If you read either first you lose the independence that is the entire reason for asking you — but if you do, read every line as something I want broken rather than confirmed. A finding that contradicts §7 is worth several that agree with it, because §7 was written before the evidence and confirmation is what one would expect either way.

You are free to decline this, to reframe it, or to tell me the question is wrong. If the interesting territory is somewhere I haven't pointed, follow it and say so — that is more valuable than covering my list.

---

## 1. What UDON is

UDON is a plain-text document notation, originally designed around 2011, dormant, and revived in 2026. It is now converging on *document-corpus-as-database* territory — schemas, a path/query language, temporal and event semantics over a corpus of files in git. Design work on those layers is about to commit, which is why this research exists.

The commitments that matter for your purposes:

- **Structure and prose interleave freely at any depth, in one grammar.** Prose is a first-class node kind, not an escape hatch and not a `#text` afterthought — and it is *opaque*: Markdown inside text is not interpreted, and `#`, `<`, `*` have no meaning there.
- **Indentation carries nesting. No closing tags.** Columns are the syntax: pop while the new column ≤ the stack top, then push.
- **Markers are live only at "Structure Position"** — the start of a line at a structural column, and along the left-to-right run through elements and attributes on that line. The first ordinary prose word ends that state; from there, marker characters are literal. Exactly one carve-out survives that commitment: a whitespace-framed ` ; ` opens a trailing comment.
- **Typing is syntactic, never sniffed from content.** The bare scalar set — string, integer, float, boolean, nil, list — is **closed forever**. Everything else is written inside `<…>` "envelopes" and typed by a *dialect*. A bare `2026-07-11` is the string `"2026-07-11"`. Dates, versions, units: none are bare, now or ever. The stated reason is that a dialect then provably *cannot reach* bare space, so adding types is additive by construction.
- **Repeated keys stack, in order. There is no last-wins anywhere, at any layer.** `:x 1 :x 2` is two assignments — never a list, never an overwrite. "Only one allowed" is held to be a *constraint*, and therefore a schema's job, not recognition's.
- **Malformed input is kept, never rejected.** Recognition never halts. Anomalies are located and typed, with severity defined by **loss**: *warning* = everything kept, possibly not as intended; *error* = something was lost. Whether accumulated anomalies justify halting is consumer policy, never encoded in the model.
- **No implicit root** — top-level siblings are ordinary. **Comments and blank lines are in the data model**, carried and never interpreted.
- **Attributes are an ordered sequence of assignments, not a map**, and an attribute's value may be a *node*: `:author |person :name "Jane Doe"` makes the `person` element itself the value, with no wrapper. The design test is "whose name is it?" — an attribute names what the value is *to* the parent (a labeled edge); a child names what the thing *is*, and its position matters.
- **Every construct declares one of two extent kinds** — *geometric* (closed by end of line, dedent, or end of input) or *delimited* (closed only by a printed end-sequence) — which makes end-of-input behavior derivable rather than enumerated. **Bounded lookahead is language law**: every guard resolves within a few characters, and a proposal requiring more is ill-formed by definition.
- **Cross-references are inert.** `@name[key].trait` recognizes as a three-field selector and the core *never resolves it*; resolution is a consumer's choice from a fixed menu. The tuple is frozen at three fields pending a path language.
- **A schema language and a path language are committed to but do not yet exist.** Neither does the dialect layer — no dialect spike has ever been run, and that is the largest acknowledged hole.

A small example, for calibration:

```
|article[intro].featured :author "Joseph Wecker" :draft?
  |section :title Typed values
    :when <2026-07-11>
    :tags [udon notation]
    Prose lives here, with |{em inline structure} and ;{a note} — # is not special.
```

Alongside this, there is a working proposal to treat a corpus of such files under git as a database: **git commits as the transaction grain** (`git show <ref>:<path>` as "as-of"), record-grain history and diff as folds over commit ranges, mutation decomposed into **append + supersede** (inheriting the format's refusal of last-wins), and a hard constraint that derived views must be **stateless projections computed at call time, never a second store**.

## 2. The commission, and the filter

From the project's steward, verbatim:

> "the parallels with xml and rdbms and later schema'less' dbs etc. are converged enough (we always knew they would) that it would probably be a good idea to … do a literature pass and history pass and try to analyze where xml and other document formats failed — **in terms of first principles wherever possible** … But in general, it would give us a more complete map of the minefields. (I'm not really interested in marketing or why something failed to gain mindshare, except when that seems to be a direct result of obtuseness)."

That last parenthesis is the sharpest filter available, and it is worth internalizing before you start:

- **Not interesting:** "XML lost to JSON because JSON was simpler." "The semantic web failed because nobody adopted it." "AsciiDoc lost because Markdown was easier."
- **Exactly interesting:** "Construct X made property Y unobtainable, and here is the working-group thread where they knew it." "The community knew about this flaw and could not fix it because of compatibility lock-in."
- **Interesting via the exception clause:** a mindshare failure where the *obtuseness itself* was the cause — e.g. a design decision argued and won on a constraint that had evaporated a decade later, which nobody re-examined.

"First principles" here means: name the *mechanism*, not the adjective. Not "it was too complex" but "requirement A forced representation B, which made property C unobtainable, and here is why that was forced rather than a mistake." Distinguish failures that were **structurally inevitable** given a design commitment from ones that were **contingent**.

## 3. Already fetched — please don't re-do these

These primary sources are already in hand and cited. Going deeper on any is welcome; re-establishing them is wasted effort.

- Tim Bray, *History of XML Error Handling* (tbray.org, 2004-01-16) — the Draconians-vs-Tolerants 7–4 vote.
- Bray's annotation on draconian error handling in the XML 1.0 spec (xml.com/axml/notes/Draconian.html) — the implementation-size-economics rationale, and his own line that it is "directly contradictory to the spirit of HTML, where tool vendors compete on their ability to handle egregiously broken pages."
- RFC 6648 (BCP 178), *Deprecating the "X-" Prefix* — the leakage argument and the "becomes a de facto standard" outcome, with the FTP / HTTP `x-gzip` / `X-Archived-At` instances.
- StrictYAML's implicit-typing rationale (hitchdev.com) — the Norway problem, and the key line that the behavior is *intended* per the YAML 1.2 spec, so "the real fix requires explicitly disregarding the spec."
- The CommonMark specification's introduction — fourteen enumerated ambiguity areas in Gruber's original description, and the statement that `Markdown.pl` "was quite buggy … not a satisfactory replacement for a spec."
- Kubernetes issue #14791 (*"yaml and json parsers silently drop duplicate keys"*, filed 2015, still open), plus go-yaml #154 and Symfony #19526/#19529 — the parser-divergence record on duplicate keys.
- The Sass syntax documentation — establishing that SCSS won on CSS-superset migration economics and that Sass deprecates *neither* syntax.
- The Noms → Dolt → TerminusDB prolly-tree lineage, at survey depth only.

## 4. The open questions, in priority order

Ranked by decision-relevance to work that is about to start. Take them in whatever order your judgment says; this ordering is mine and I can't see what you'll see.

**(1) Why did RELAX NG lose to XML Schema, and were the reasons technical?**
The highest-value question I have. A schema language is about to be designed here, and RELAX NG is the closest thing the field produced to a theoretically clean one (Clark and Murata; the interleave operator; a real formal basis in tree automata). XSD won anyway. I want the mechanism: tooling, vendor weight, PSVI/data-binding integration, the "one spec to rule them all" politics — and specifically whether anything *technical* about RELAX NG's model made it unable to do a job people needed. Van der Vlist's comparisons, Clark's own writing, and the DSDL/ISO track are obvious starting points. **Also wanted:** what Schematron's existence proves about what grammar-based schemas structurally cannot express — that boundary is directly load-bearing here.

**(2) JSON Schema's draft churn, from the maintainers' own account.**
The sequence draft-03 → 04 → 06 → 07 → 2019-09 → 2020-12, why large parts of the ecosystem stopped at draft-07, and what the maintainers say about it in retrospect. There is a structural argument on this side that a specification cannot move faster than its ecosystem's spare capacity to re-settle, and that a corpus of existing documents has *unbounded* settling time — so the observed "everyone stopped at draft-07" is the predicted signature rather than a community failure. I would like the practitioners' own account, whether it supports that or not.

**(3) The forwards-compatibility literature — must-ignore vs must-understand.**
The W3C TAG versioning findings, David Orchard's extensibility-and-versioning work, SOAP's `mustUnderstand`, HTML5's evolutionary approach versus XHTML 2's clean break, and XML 1.1's near-total non-adoption as a natural experiment. This is one of the few places the field theorized forwards-compatibility properly rather than by instinct, and I have almost nothing on it.

**(4) XML databases at depth.** MarkLogic, Tamino, eXist, BaseX. These are the *closest prior art* to document-corpus-as-database and are entirely unexamined here. What actually stalled? What did XQuery cost in practice? Did schema-optionality help or hurt? Where did the model break down against relational for the same workloads? This is where I most expect an uncomfortable finding.

**(5) "Database in a git repo" — and one specific thing I looked for and could not find.**
Dolt, Noms, TerminusDB, irmin, lakeFS, and serious git-as-database write-ups. I established that each of these built its *own* content-addressed storage engine (the prolly-tree lineage) to get diff and merge at record grain rather than line grain — but **I could not find anyone stating plainly why git's own machinery is the wrong substrate for this.** The Dolt engineering blog was the obvious place and doesn't say it. Either find that statement, or establish that it was never written down; both are useful answers, and the second is itself a finding.

**(6) Indentation-as-syntax: what actually breaks in practice.**
I went looking for the Sass indented-syntax → SCSS shift as the strongest counter-evidence and found it doesn't support that reading at all. So the question is open and I'd like it done properly: transport and copy-paste mangling, mixed tabs, editor auto-indent interference, diff/merge behavior, deep-nesting readability — ideally *measured* accounts rather than opinion pieces. Python's tabs-vs-spaces history and Python 3's hard error are a good anchor. UDON bets heavily on columns-as-syntax and currently has no serious counter-evidence gathered against it, which is an unbalanced position for a design to sit in.

**(7) Event sourcing's documented pain points** — especially schema evolution of past events, projection rebuild cost, and the **immutability versus right-to-erasure collision**, which is a hard external constraint that an append-plus-supersede model may be walking straight into.

**(8) EDN's extensible reader tags in practice.** This is the closest prior art to UDON's `<…>` envelope idea — extensible typing via explicitly-delimited tagged literals. Did it work for data *at rest* over years? What do Clojure practitioners report about reader tags in stored data, versioning of tag semantics, and unknown-tag handling?

**(9) The semantic-web identity line**, if you have room: RDF's reification problem and RDF-star as the eventual admission that edges need their own data; blank nodes as an identity failure mode; the httpRange-14 fight; OWL's open-world assumption versus what validators actually needed (with SHACL/ShEx arriving fifteen years late as closed-world constraint languages — that gap is itself a finding); what JSON-LD *conceded* to survive; and, if it interests you, the pre-web hypertext line (Xanadu's transclusion and bidirectional links) and the literature on what the web's one-way, may-dangle link actually cost.

**(10) Anything I haven't listed.** Genuinely. This brief's enumeration is my best guess at the neighborhoods, and in this estate's experience the most consequential hits usually arrive from off the list. A failure mode I didn't think of is worth more to me than thorough coverage of one I did.

## 5. What I'd like back, and how

**Priority order within any topic:**

1. **Primary-source evidence with citations** — specs, RFCs, working-group archives, mailing lists, issue threads, designer retrospectives, measurement papers. Verbatim quotes where a sentence is doing work. Fetch the primary rather than trusting recall wherever you can.
2. **Your own causal read, kept visibly separate from the evidence.** I will be propagating claims upward with epistemic tiers attached, and I must not launder your inference as somebody's testimony. A clear typographic or sectional split is enough.
3. **What surprised you.**

**Register convention.** Where a claim rests on your training rather than a fetched source, please mark it *"training recall — verify before external citation."* That single convention is what lets downstream readers know where the document is load-bearing. It is used throughout the existing synthesis and I'd like yours to interoperate with it.

**Output.** A markdown document (or several — one per territory is fine and probably better). It will be read by the project's steward and by the agent writing the synthesis, and it becomes the citation substrate for a design document that people will consult in six months without you present — so a reader should be able to follow your citations on their own. Beyond that, format is yours; length is yours, and I'd rather have too much than too little.

**One practical note earned the hard way tonight:** if you're working in an environment that might interrupt you, write your file early and append as you go rather than composing everything and flushing at the end. That pattern is exactly what cost six parallel passes their entire output.

## 6. What would make this genuinely valuable

Two things, said plainly because they are what I actually want and not politeness.

The first is **disagreement**. The synthesis in §7 was written from theory before the evidence arrived. If your evidence confirms it, that is weak confirmation — it is what one would expect either way, and I will discount it accordingly. If your evidence *contradicts* it, that is the finding of the night, and I would much rather publish a correction than a consensus.

The second is **the uncomfortable read on the current design**. §1 describes commitments that are close to frozen. If the historical record says one of them is a known minefield — if "keep everything and warn" has a documented failure mode, if closed-forever type sets have been tried and failed, if inert references are a trap someone else already fell into, if git-as-transaction-grain is a well-documented dead end — say so, with the evidence, as bluntly as the record supports. Nobody here benefits from a comfortable answer.

If you have feedback on this brief itself — where it under-specified, where it primed you badly, where the framing was wrong — that is welcome and useful; briefs in this estate get improved from exactly that. And if you're willing, please stay available after your report for follow-up questions.

---

## 7. QUARANTINED — the first pass's conclusions, as predictions to falsify

*Please do your own work before reading this section. Its contents were written from theory before the historical evidence arrived, and they are stated as predictions precisely so you can break them.*

The first synthesis identified twelve failure mechanisms. Six carry real predictive content and are worth testing against what you find:

**P1.** *Type-sniffing is not a difficulty but a structural impossibility.* A format inferring type from bare content asks a parser to recover something the characters don't determine; no heuristic refinement ever escapes it, because refinements are re-weightings and the unrecoverable direction stays unrecoverable under every re-weighting. **Testable corollary:** sniffing is safe *iff* the bare syntactic classes are disjoint — which predicts that TOML and JSON (quoted strings mandatory) should have no Norway-class incidents, while any format allowing unquoted strings *and* sniffing should have a continuously-growing exception list. **Falsify it by:** finding a sniffing format with overlapping bare classes that solved this without adding syntax, or a disjoint-class format with Norway-class failures anyway.

**P2.** *The strict-versus-lenient debate was on the wrong axis; the lethal corner is silent-and-unspecified.* Prediction: formats that fail loudly (XML) produced recoverable pain, formats that fail loudly-but-recover-predictably (HTML5) produced the best outcomes, and the real damage in the historical record concentrates in silent misparse — which nobody argued about because it doesn't look like error handling. **Corollary:** HTML5's contribution was *specifying* the recovery, not being lenient. **Falsify it by:** documented cases where draconian rejection caused worse outcomes than silent recovery, or by evidence that the WHATWG understood itself as choosing leniency rather than determinism.

**P3.** *Conventional extension mechanisms fail invisibly because near-compliance is behaviorally indistinguishable from compliance while proving nothing.* Prediction: every convention-based extension namespace in the record (`X-`, vendor prefixes, reserved-name conventions) failed *slowly*, with no breaking event, and was diagnosed a decade late. **Falsify it by:** a convention-based extension mechanism that held, or one whose failure was sharp and noticed immediately.

**P4.** *A corpus has unbounded settling time, so the admissible rate of meaning-changing spec movement is approximately zero.* Prediction: XML 1.1's non-adoption, JSON Schema's draft stall, and YAML 1.2's failure to displace 1.1 behavior in implementations are all one signature; and the repair is not slower cadence but *additivity by construction*. **Falsify it by:** a format that successfully made a non-additive change to a live corpus, and what it cost.

**P5.** *Malformation arrives in four repair-distinct regimes and no format in the record distinguishes more than two.* Specifically, no format is predicted to distinguish "your document is malformed" from "your document is fine but my model of documents cannot represent it" — despite those having opposite repairs. **Falsify it by:** finding one that does. I would genuinely like to be wrong here; a counterexample is more useful than the prediction.

**P6.** *Formats die at merges of repair-distinct things.* Attribute-versus-element is predicted to be unresolvable *because* it is two questions wearing one — "whose name is it" and "may the value be structured" — and to become answerable once split. Prediction: forty years of XML-lineage debate produced no rule, and the debates read as inconclusive rather than converging. **Falsify it by:** a principled attribute-vs-element rule that actually held in practice.

And one **honest correction already made**, offered as calibration on how this pass is being run: I predicted the Sass indented-syntax → SCSS shift would be the strongest counter-evidence against indentation-as-syntax. It isn't — SCSS won on CSS-superset migration economics, and Sass's own documentation deprecates neither syntax. That prediction was recorded as refuted rather than quietly dropped, and I'd rather your pass produce three more of those than a page of agreement.

---

## 8. Task B — adversarial verification of the synthesis

*Only after Task A is done and written down.*

If you're running with repository access, the artifacts are:

| Path | What it is |
|---|---|
| `v2/spikes/format-failures/MINEFIELD-MAP.md` | The synthesis to verify — twelve mechanisms, register-marked |
| `v2/spikes/format-failures/UDON-PRIMER.md` | The data-model distillation §1 above is condensed from |
| `v2/current-0.9.1-spec/` | The actual spec suite (`CORE.md`, `MODEL.md`, `SEMANTICS.md`, `CARVEOUTS.md`, `RATIONALE.md`, …) — the authority |
| `misc-db-theory.md` (repo root) | The corpus-as-database proposal §1's last paragraph summarizes |
| `~/src/arch/asf/` | The ASF/AAT theory corpus the "derived" claims cite by slug |

Four checks, roughly in descending value:

**(B1) Do the §3 claims about UDON survive contact with the actual spec?** This is the one I most want done by someone other than the author, and it needs `v2/current-0.9.1-spec/` rather than the primer. The synthesis asserts ten places where UDON is standing on a historical mine. Several are checkable directly against `CORE.md`:

- Is there really a residual bare-type collision surface — i.e. does a bare `true` / `null` / `nil` / an integer-shaped token in an unquoted-string position actually retype silently? (The claim is that UDON permits unquoted strings *and* sniffs six bare types from the same space, which would put it structurally with YAML rather than TOML. If the spec has a boundary rule that separates them, the whole of §3.1 is wrong.)
- Does the whitespace-framed ` ; ` comment really survive commitment to text, making it a live control sequence inside prose?
- Do the `$`-designated keys really carry no structural protection?
- Is `CARVEOUTS.md` genuinely missing a SCHEMA entry?

Where possible, **run it rather than reading it** — there's a reference parser (`cd core && cargo build --example stdin_parse && ./target/debug/examples/stdin_parse < file.udon`). Note that it implements the *predecessor* version and lags the spec in places, so a disagreement between parser and spec means the parser is behind, not that the spec is wrong. The spec is the authority; the parser is a check on comprehension.

**(B2) Do the cited primary sources say what they are claimed to say?** Every **[evidenced]** mark in the synthesis. Quotes were fetched rather than recalled, but fetched-and-summarized is not fetched-and-verbatim, and a summarizing layer sat between the source and the citation in several cases. The Bray annotation, RFC 6648, and the CommonMark introduction are the three doing the most argumentative work.

**(B3) Are the theory-derived claims over-reaching?** The synthesis cites ASF/AAT segments by slug and claims to carry each segment's own epistemic tier without upgrading. Two specific things to check, since they are where over-reach would hide: whether a claim marked **[derived]** actually follows from the cited segment or merely *resembles* it; and whether §5's own admission — that four citations were made at less-than-segment weight (`#der-observability-dominance`, `#obs-context-turnover`, `#der-turnover-information-recursion`, `#deriv-tempo-additivity`) — under-reports the problem. The first agent already caught itself about to cite one segment for something it doesn't say (`#scope-channel-collapse`, recorded in §4 of the synthesis); assume there may be another it didn't catch. **You do not need to accept the theory to do this check** — it is a question of whether the citation matches the source, not whether the source is right.

**(B4) What's missing from the map entirely?** Twelve mechanisms is a suspiciously round claim to completeness. The failure modes most likely absent are the ones that don't fit the frame the first agent brought — and you'll see those more easily than it could.

Please keep Task B's output separate from Task A's, so a reader can tell discovery from audit. And if B1 kills §3.1, say so first and loudly; it is the finding with the most immediate consequence for work that is about to start.
