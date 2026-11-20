# Feedback on greenfield-3b — from Claude (Fable), 2026-07-20

Calibration: I did this same exercise in `greenfield-2a` before reading 3b, and I read 3a just before this. I have not read the feedback-from-gemini file, so anything we agree on is at least semi-independent. One honesty note on "convergence" up front: the three drafts share one input corpus and overlapping training lineages, so where we agree it is weak evidence of correctness — coherence, not corroboration. I'll still mark the agreements, because they identify what's *stable under re-derivation*, which is exactly what this exercise was for.

## What genuinely lands

1. **SEMANTICS.md is the one document neither 3a nor I produced, and it's the best new idea in the three suites.** Naming the equivalence layers (byte / recognition / core-semantic / host-projection) and then pinning what normalization may and may not do — §2.4 stacking≠list not collapsed, §2.12 `$partial-key` never promoted, §3.3 forbidden silent serializer changes — gives round-trip tooling a contract it otherwise has to invent. This should survive into the ratified spec whatever else happens.

2. **Coverage is near-complete without the source's bulk.** Against my own fixture walk: the flag rule keeps the "alone at boundary" clause (which 3a dropped and would misparse `:a? true it sure is true`), the comment position table includes prose-base-vs-deeper, the terminator table has the unconsumed `}`/`]` and quoted-adjacent-items cases, the envelope machinery (ladder, declared-order dispatch, no-dialect posture) is all present. The crosscheck file plus the §14.3 representative-anomalies table are exactly the auditability the exercise wanted.

3. **DECISIONS.md with [BEHAVIOR]/[ORG] tagging and impact statements** is the strongest decisions ledger of the three. D16 (absorbing 3a's grammar pillar as a non-normative extract with "CORE wins on conflict") is a graceful resolution of the pillar tension — better than my choice of not authoring a grammar view at all.

4. **The self-assessment is honest where it counts** — flagging float equality as soft, admitting the cold-implementer example-poverty risk, and the "least sure of" framing. The one-line summary ("a smaller constitution that no longer pretends to be the diary and textbook") is accurate.

## Convergence table (for Joseph, mostly)

Independently re-derived by all three drafts: rational/complex leave the bare set; comment continuation uses the content-base shape; the document is a root-less forest; attribute-under-attribute = error + text-ingest; inline verbatim in value position = flow segment. Those five look ripe for ratification. The genuine three-way splits are below.

## The principal disagreement: D1's blast radius

D1 (all delimited constructs multi-line) is the cleanest-sounding rule, and I want to push back on it concretely rather than aesthetically:

1. **It hollows out `$partial-key`.** The fail-safe exists so a truncated identity is never acted on. With identity brackets multi-line, the common editing accident — `|el[k` followed by the next structural line — no longer *produces* a partial key: the next line is silently inside the bracket, and every line after it too, until EOF finally warns. The fixture corpus asks this directly (`|el[k` + `more`). D1's impact note says "recognizers that closed at newline will need to follow this contract" but doesn't surface that the fail-safe's main trigger just moved from "next line" to "end of file."
2. **Typo blast radius goes from one line to the rest of the document.** An unclosed `;{` or `!{{` today costs at most a line (however each construct handles it); under D1 it swallows everything to EOF, with the diagnosis arriving as one warning at the very end pointing back at the opener. Keep-everything means nothing is *lost*, but everything after the typo is *misfiled* — for an interactive author that's the worst repair experience the language could offer, and for streamed LLM output it means one dropped brace re-interprets the entire remainder of the stream.
3. The uniformity win is real but purchasable more cheaply: my 2a draft's recommendation was selective (strings, lists, interpolations multi-line; identity brackets line-bound *because of* the fail-safe; inline comments decided with the dialect work). That keeps "geometric vs. delimited" as the only taxonomy while letting the two constructs whose failure modes are identity-corruption and document-swallowing stay line-bounded. I'd at minimum split D1 into per-construct rows so Joseph can ratify them separately — as one atom, the strongest objection sinks the whole rule.

## Second disagreement: D7's in-string escapes

D7 makes `\\` and `\"`/`\'` recognized inside quoted strings. Two costs the decision entry doesn't price: (a) it breaks the "escape is positional, period" story — the language's cleanest single rule now has a fifth, non-positional case living inside quotes; (b) `"C:\Users\new"` changes meaning (`\\` halves; `\U`, `\n` stay literal pairs — a subtle mixed rule that authors will guess wrong in both directions). My draft went the other way (no interior escapes; contain one quote kind with the other; doubling *if ever needed*, never backslash) precisely to keep §9's positional story whole — and notably, quote-doubling is foreclosed by the list rule (`["x""y]` is two items), which is an argument *against* my own fallback worth having on the table too. This is a genuine open fork; it deserves to be in OPEN.md or split out of D1/D7 for an explicit ruling rather than riding as a pin.

## Internal inconsistencies worth one pass

1. **Severity is defined by loss, but two table rows keep everything and say Error.** §14.1: Error = loss. §14.3: root attribute → Error, kept as text (nothing lost); missing value → Error, attribute stands with Nil (defensible — the *value* the author intended is genuinely absent — but then say so; the root-attribute row has no such defense). Either refine the definition ("loss, or a construct that cannot mean anything as written") or demote the root-attribute row to Warning. 3a has the identical wobble; whichever way it resolves should resolve both.
2. **MODEL's `MultiSegment` as a Value kind double-models multiplicity.** §3.2 says stacking = multiple assignments and the model does *not* collapse them; §4's `Value` then includes `MultiSegment` "from stacking-adjacent ingest or warn-ingest." Now warned-ingest material has two candidate homes (another assignment vs. a segment inside one value) and a round-tripper can't know which to emit. Pick one channel — I'd drop `MultiSegment` and make warned extension always a further assignment, which SEMANTICS §3.3 already treats as the protected shape.
3. **The text law is present but scattered.** Terminators-are-text lives in CORE §7.2, blank-line handling in MODEL §2 + CORE §7.3 + SEMANTICS §2.7, and nowhere does the model state the single invariant they all serve: *document text reconstructs by pure in-order concatenation of Text, no fabrication, no source consultation*. Stating that once in MODEL §6 would let the three scattered clauses become consequences instead of siblings (and would give the future wire redesign its acceptance test — which I suspect is a thing Joseph will want from exactly this document).
4. **Guard-failing marker characters at the bare-token boundary.** §6.4's boundary list names the marker characters, but the fixtures probe `:3`, `|~`, `!=`, `|el :k v != 3` — characters that *look* like boundary markers and fail their guards. The intended reading (failed guard ⇒ not a boundary ⇒ the token joins the flow) is derivable but unstated; one sentence closes it. (I found and patched the identical gap in my own draft, so consider this the finding of a fellow offender.)

## Smaller notes

- GRAMMAR.md §3 lists `\` in the marker table; CORE correctly keeps it out of the marker set (it never begins structure). Minor, but the glossary is supposed to be the tiebreak and it sides with CORE.
- MODEL §4.6 Reference key: "may be $partial-key path on failure" — the fail-safe renames the *attribute* on elements; for a reference selector the model should say what the selector carries instead (an invalid/partial flag on the tuple?). One clause.
- SEMANTICS §2.3 normalizing integer base spelling for core equivalence is defensible but note it makes core equivalence non-round-trip-safe by design; §3.1 already handles this, a cross-pointer would prevent misuse.
- The pedagogy tour and dialects recasting are solid; temporal's interior grammar preserved under the envelope matches my read of the source's intent exactly.

## Net

This is the most complete and most auditable of the three suites — the one I'd hand a cold implementer today, with SEMANTICS.md as its distinctive contribution. The two places I'd hold ratification: split D1 per-construct (the identity-bracket and inline-comment rows don't survive their failure modes, in my judgment), and re-open D7's in-string escapes as an explicit fork. Everything else on my list is a one-pass tightening, not a rethink.

— Fable (Claude), greenfield-2a author
