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

**Status 2026-07-15: the 0.9 CORE Attributes text is DRAFTED** (CORE.md
"Attributes" + collateral). Items below marked *drafted (R#)* are resolved in
that draft by an explicit recommendation, flagged inline in CORE with the same
R-number — they stay open here until Joseph confirms each (or rules
otherwise while reviewing the section at its natural spot).

- [ ] **Boundary-marker set** — *drafted (R1)*: `:`, `\`, guarded `|`, framed
      ` ; `, fence, guarded `!`; `@` excluded (it is a value shape, not a
      scan marker). CORE "The Scan and the Bare-Token Boundary".
- [ ] **Embedded context (`|{…}`) under the new model** — *drafted (R2)*:
      embedded = element-rooted sameline with `}` as an extra terminator.
      Consequences drafted explicitly: `|{input :required}` errors (write
      `:required?`); an open bare attr's trailing tail is the attr's blob, so
      `|{a :href /home :title Home here}` gives `title="Home here"` and NO
      embedded content — this **changes a long-standing canonical example**;
      confirm deliberately. Fixture updates follow
      (`attributes.yaml::embedded_flag_attr_before_brace` and kin).
      *(discuss w/ Joseph)*
- [ ] **Block-line `\` at the boundary** — *drafted (R3)*: value closes; the
      rest of the line is the element's prose. CORE "Value-Position `\`".
- [ ] **Quoted keys never flag** — *drafted (R4, new item)*: terminal-`?`
      flag semantics apply to **bare** keys only; a quoted key (`:'$?'`,
      `:'key?'`) is always a plain attribute. Keeps the suffix-sugar target
      `:'$?' true` plain. CORE "Attribute Keys and Flags".
- [ ] **Event vocabulary for multi-segment / node values** — *drafted (R5)*:
      single scalar/reference/interpolation keeps `Attr` + one value event
      (0.8 wire, low churn); node / text-blob / multi-segment values bracket
      with `AttrStart` … `AttrEnd` around ordinary events. Names working
      until the fixture group lands. `tree.rs` + harness follow. *(discuss
      w/ Joseph)*
- [ ] **Warning-code names (P3-7)** — *drafted as working names* in the CORE
      warning-codes table: `AttributeValueExtendedByTrailingText`,
      `AttributeSecondValue`, `AttributeAfterChildren`; errors
      `MissingAttributeValue`, `AttributeUnderAttribute`. Dead forecast codes
      (`UnmarkedBooleanFlag`, `ValuedBooleanKey`, `MarkerInTextValue`)
      pruned. Finalize strings at fixture landing.
- [ ] **Substrate/proposal text alignment with the boundary ruling.** Update
      `design/attribute-model-proposal-3-substrate.md` §S5 (replace the
      mid-line/end-of-line wording with the boundary rule; correct the
      "NOT" example — `|el :first value with spaces :another x` →
      `first="value with spaces :another x"`; drop the "letter-first bare
      value" framing) and §S8 (add the boundary-`\` case to the distinctions
      list); touch the matching proposal-3 §4/§10 examples.
