# TODO-SPEC-CORE 0.9 supplement — attribute-model nail-downs

Small rulings and collateral edits the 0.9 attribute-model promotion
(proposal-3 + substrate-3 → CORE) will force. Each gets decided either at
its natural spot while writing the spec (with a recommendation surfaced to
Joseph there), or in the sweep-up pass when the 0.9.0-alpha.1 spec text is
essentially finished (see the revisit item in `TODO-SPEC-CORE.md`).

**Context — ruled 2026-07-15/16, carried here so the items below make sense:**
the sameline scan stays *provisionally open* at a bare value token's
boundary; the next non-space character decides — a head-position marker
(`:` next attr, `\` force-prose, guarded `|`, framed ` ; `, fence) means the
token finished as a single-token value and the scan continues; plain text
commits the rest of the line as a text blob owned per binding priority
(open attr first). Hence `|el :alpha something \ tail` → `alpha="something"`
+ el prose, and `|el :alpha true story` → `alpha="true story"` (no keyword
carve-out at the boundary; flags `:key?` cover keyword-then-prose).
Version plan: v0.8 fixture group freezes as-is; the model lands as
**0.9.0-alpha.1** with a new `core/fixtures/v0.9/` group.

## Open

- [ ] **Boundary-marker set, stated exactly.** One normative sentence listing
      which markers keep the scan open at a bare-token boundary
      (`:`, `\`, guarded `|`, framed ` ; `, fence — and whether `@` / `!`
      participate; recommendation: yes, full head-position uniformity).
- [ ] **Embedded context (`|{…}`) under the new model.** Neither proposal
      addresses it. `|{input :required}` (today BoolTrue) becomes an error
      under flags — needs `:required?`. Presumed rule: embedded = element-
      rooted sameline with `}` as an additional terminator. Needs a ruling +
      fixture updates (`attributes.yaml::embedded_flag_attr_before_brace`
      and kin). *(discuss w/ Joseph)*
- [ ] **Block-line `\` at the boundary.** `:key something \ tail` on a block
      attr line: value finishes as `"something"`; who owns the tail
      (presumably element prose)? One example's worth of spec text.
- [ ] **Event vocabulary for multi-segment / node values.** Substrate §S15
      says "`AttrStart`…`AttrEnd` or equivalent" — the grammar, `tree.rs`,
      and the fixture harness need the real names and shapes. Largest
      implementation decision in the pile. *(discuss w/ Joseph)*
- [ ] **Warning-code names (P3-7).** Final strings for the CORE table
      (`AttributeValueExtendedByTrailingText`, `MissingAttributeValue`, the
      §S6.3 second-value warn, phase-late `:`), and prune forecast codes
      that die with the model (`UnmarkedBooleanFlag`, `ValuedBooleanKey`;
      `MarkerInTextValue` likely dies with the literal-text model).
- [ ] **CORE collateral beyond the Attributes section.** Booleans (`:flag` →
      true dies), Absent-vs-Nil-vs-False table, scattered `|button :disabled`
      examples, Value Terminator Rules / Bare String Terminators tables
      (run-to-EOL dies), README attribute-vs-child decision table. Plus a
      footnote that element-suffix sugar (`|el?` → `$?` BoolTrue) is
      untouched by and distinct from attr flags (`:key?`).
- [ ] **Substrate/proposal text alignment with the boundary ruling.** Update
      `design/attribute-model-proposal-3-substrate.md` §S5 (replace the
      mid-line/end-of-line wording with the boundary rule; correct the
      "NOT" example — `|el :first value with spaces :another x` →
      `first="value with spaces :another x"`; drop the "letter-first bare
      value" framing) and §S8 (add the boundary-`\` case to the distinctions
      list); touch the matching proposal-3 §4/§10 examples.
