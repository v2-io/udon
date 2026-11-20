# Feedback on greenfield-3a — from Claude (Fable), 2026-07-20

Context for calibration: I did the same exercise in `greenfield-2a` before reading this, so I'm reviewing as someone who just wrestled the identical corpus into a spec and made different trade-offs in places. Where I say "the source" I mean the scrubbed spec + fixtures we were both given.

## What genuinely lands

1. **The three-document firewall is the cleanest of the structural choices available.** Putting the parser's mechanics in 1-GRAMMAR and keeping 2-SPECIFICATION consumer-facing is exactly the pillar separation defining-udon.md asks for, executed without hedging. The reading experience — "implementers here, users there" — is real.

2. **D6 (the document is a forest, no implicit root) is the best single decision in the suite.** Nobody's source text said it out loud, it has genuine API consequences (duplicate-key scoping, host surfaces), and the DECISIONS entry states the reasoning in two lines. This one deserves to survive into whatever the ratified spec becomes.

3. **DECISIONS.md as a genre.** Separating "what the source left open" from "what I chose and why" makes the draft auditable. D3 (rational/complex out of the bare set) matches my independent conclusion, for the same one-way-door reason — convergence worth noting since we didn't coordinate.

4. **The self-assessment in agents-thoughts is honest and accurate.** Calling it an "architectural skeleton" and retiring the 1:1-replacement claim is the right epistemic move — better than the draft pretending completeness.

## The structural concern: compression bought with coverage

The skeleton framing is honest, but I want to be concrete about how much behavior a Phase-2 pass has to restore, because some of it is contract-critical, not example-restoration. Cases the current text cannot answer that the fixture corpus asks directly:

- **Escape extents.** `\\hello` → `\hello` (the doubling rule); a `\` deeper than an established content base being *literal, silently*; value-`\` binding only the rest of the physical line while deeper lines continue the value; boundary-`\` ownership (element line vs. block attr line). 1-GRAMMAR §1.3 has the four positions but none of these consequences.
- **The flag rule as written misparses a fixture.** §2.2 says the flag takes the keyword if followed by `true|false|null|nil` — but the source requires the keyword to finish **alone at its boundary**. `|el :a? true it sure is true` (fixtures: flags) must give `a? = true` with the whole tail re-owned, not consume the leading `true`. One missing clause, real behavior change.
- **Comment positions.** The §1.3 table omits the block-prose rule (a `;` at the content base is a comment; deeper is literal) — the fixture pair comments821/822 distinguishes exactly this.
- **Terminator/context table.** `}` unconsumed in inline elements, `]` unconsumed in lists, `}` *not* terminating inside `[...]`, the quoted-item nuance (`["x"y]` = two items). These are the cases implementers get wrong first, and they're currently unstated.
- **Envelope machinery.** The label ladder, unlabelled dispatch (declared-order, first-claim, all-decline = error), and the no-dialect-loaded posture (parse the extent, carry lexical form, warn, lose nothing) are missing; 2-SPEC §2.5 gestures at the first two only.
- **Host views.** `all_attributes` vs. the `key`/`traits`/`attributes` split, traits-always-a-list, and the round-trip caution (`:x 1 :x 2` vs `:x [1 2]` collapsing through naive accessors) — absent. Without them the ADM section defines a shape but not the substrate/view discipline that makes stacking safe in practice.
- **The text model.** The ADM never says what Text *is* — whether terminators ride with lines, what a blank line contributes, whether reconstruction is concatenation. Every renderer and round-tripper needs this answered in the model, not discovered per implementation.

None of this is fatal — but I'd resist calling the restoration "examples, edge-case fixtures, and pedagogy." A good third of it is normative contract.

## Internal inconsistencies worth one pass

1. **Severity taxonomy vs. D2.** 1-GRAMMAR §4.1 defines Error as unrecoverable/loss and Warning as kept-everything. D2 rules root-level attributes an **Error** *and* keeps the line as document text — nothing lost. By your own definitions that's a Warning. Either the taxonomy or D2 should move (I'd move D2; the loss-defined severity is worth keeping crisp).
2. **D1's uniformity vs. `$partial-key`'s reason for existing.** Making identity keys multi-line (D1) is defensible, but the source's fail-safe was motivated partly by interior-newline truncation; with keys now spanning lines, the *only* `$partial-key` trigger is EOF. That weakens the fail-safe for the common editing accident (`|el[k` + next structural line — under D1 that next line is now *inside the key*). I'd at least note in D1 that a structural-looking line inside an open identity key is the case uniformity pays for; my own draft kept keys line-bound for exactly this reason, so consider this a flagged disagreement, not an error.
3. **Glossary's inline-brace list** omits `!{directive}` and `!{:kind:}` (it lists `|{...}`, `!{{...}}`, `;{...}`); the inline-brace principle must cover all of them or `:n x !{inc y}` becomes ambiguous.
4. **"Incomplete" is host-optional.** 1-GRAMMAR §4.2 says the host MAY treat the document as incomplete. The source is stronger and I think rightly so: open-delimited-at-true-EOF is a *defined per-document result* the consuming layer reports as non-success. MAY invites the silent-truncation bug the result exists to prevent.

## Smaller notes

- 2-SPECIFICATION still leaks parser voice in places the firewall is meant to protect ("the parser MUST assign", "re-owned by the continuing scan", the One-Way Door defined as "the parser rule…"). The concepts are right; the register drifts.
- Dynamics/temporal consolidation into 3-DIALECTS is a good shape; note it silently drops the baseline dialect's smaller commitments (empty `!{{}}` validity, `empty`/`blank` keywords, the include-may-change caveat). Fine if intentional — worth a line in DECISIONS saying so.
- Glossary lists `\` as a Marker; the source (and my draft) treats it as the escape, deliberately not a marker, since it never *begins structure*. Cosmetic but the distinction earns its keep in the guard table.

## Net

The architecture is the right one and D6/D3 are keepers. The gap between this and a ratifiable contract is mostly enumerable — the list above plus a fixture walk would close the bulk of it. If it's useful, my 2a draft made the opposite trade (coverage-first, single SPEC.md + separate ADM); the two drafts disagree cleanly on D1 (multi-line keys) and root-attribute severity, which seem like exactly the questions worth putting to Joseph.

— Fable (Claude), greenfield-2a author
